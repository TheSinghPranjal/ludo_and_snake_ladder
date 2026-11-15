"""Search for original Snakes & Ladders layouts that satisfy the brief.

Writes design/boards/<id>.json. Run from the repo root:
    python3 tool/design/design_snl_boards.py

Checks, per board:
- validator rules (range, direction, no start on 1 or 100, unique endpoints, no chains, 8 ranked snakes)
- ranks 1-6 include a snake head in the 90s, one in 40-89 and one below 40
- snake bodies stay clear of every snake head and ladder foot; ladders likewise
- no snake crosses another snake, no ladder crosses another ladder
- exact 2-player first-winner mean turns inside the board's window at 6, 7 and 8 snakes
- no jump copied from the published Chutes and Ladders board
"""
import json
import math
import os
import random
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
from snl_balance import stats  # noqa: E402

CHUTES = {(1, 38), (4, 14), (9, 31), (21, 42), (28, 84), (36, 44), (51, 67), (71, 91), (80, 100),
          (16, 6), (47, 26), (49, 11), (56, 53), (62, 19), (64, 60), (87, 24), (93, 73), (95, 75), (98, 78)}

BOARDS = [
    dict(id="classic_sunshine", name="Classic Sunshine", theme="sunshine", unlock={"type": "none"},
         ladders=9, window7=(29.0, 32.5), seed=11),
    dict(id="sugar_rush", name="Sugar Rush", theme="sweets", unlock={"type": "snakesWins", "count": 1},
         ladders=9, window7=(26.5, 29.0), seed=23),
    dict(id="jungle_temple", name="Jungle Temple", theme="jungle", unlock={"type": "snakesWins", "count": 3},
         ladders=8, window7=(33.0, 36.5), seed=37),
]
ALL_N = (25.5, 39.0)


def row(n): return (n - 1) // 10


def centre(n):
    r = row(n); c = (n - 1) % 10; col = c if r % 2 == 0 else 9 - c
    return ((col + .5) / 10, 1 - (r + .5) / 10)


def catmull(pts, per=24):
    p = [pts[0]] + pts + [pts[-1]]
    out = []
    for i in range(1, len(p) - 2):
        p0, p1, p2, p3 = p[i - 1], p[i], p[i + 1], p[i + 2]
        for s in range(per):
            t = s / per; t2 = t * t; t3 = t2 * t
            out.append(tuple(.5 * ((2 * p1[k]) + (-p0[k] + p2[k]) * t + (2 * p0[k] - 5 * p1[k] + 4 * p2[k] - p3[k]) * t2
                                   + (-p0[k] + 3 * p1[k] - 3 * p2[k] + p3[k]) * t3) for k in (0, 1)))
    out.append(pts[-1])
    return out


def seg_pts(a, b, n=30):
    return [(a[0] + (b[0] - a[0]) * i / n, a[1] + (b[1] - a[1]) * i / n) for i in range(n + 1)]


def dist(a, b): return math.hypot(a[0] - b[0], a[1] - b[1])


def min_d(poly, q): return min(dist(p, q) for p in poly)


def poly_d(a, b): return min(dist(p, q) for p in a[::2] for q in b[::2])


SNAKE_CLEAR = .05      # body centre-line to any other snake head or ladder foot, in board units
SNAKE_GAP = .04        # between two snake centre-lines


def snake_path(rng, h, t, forbidden, others, tries=500):
    """Pick 2-4 interior control points that keep the body clear; returns (clearance, ctrl, curve)."""
    H, T = centre(h), centre(t)
    dx, dy = T[0] - H[0], T[1] - H[1]; L = math.hypot(dx, dy); nx, ny = -dy / L, dx / L
    k = 2 if L < .3 else 3 if L < .55 else 4
    F = np.array(forbidden) if forbidden else np.zeros((0, 2))
    O = np.concatenate(others) if others else np.zeros((0, 2))
    best = None
    for _ in range(tries):
        amp = rng.uniform(.03, .18); sgn = rng.choice((-1, 1)); ctrl = []
        for i in range(1, k + 1):
            f = i / (k + 1) + rng.uniform(-.05, .05)
            a = sgn * (-1) ** i * amp * rng.uniform(.6, 1.0)
            ctrl.append((H[0] + dx * f + nx * a, H[1] + dy * f + ny * a))
        curve = np.array(catmull([H] + ctrl + [T]))
        if curve.min() < .02 or curve.max() > .98:
            continue
        body = curve[6:-3]  # the head sprite sits on the first samples
        clear = np.sqrt(((body[:, None, :] - F[None, :, :]) ** 2).sum(-1)).min() if len(F) else 1.0
        if clear < SNAKE_CLEAR:
            continue
        if len(O) and np.sqrt(((curve[::2, None, :] - O[None, ::2, :]) ** 2).sum(-1)).min() < SNAKE_GAP:
            continue
        score = clear - .02 * amp  # prefer clearance, then calmer curves
        if best is None or score > best[0]:
            best = (score, ctrl, curve)
    return None if best is None else (best[0], best[1], best[2])


def segments_cross(a, b, c, d):
    def o(p, q, r): return (q[0] - p[0]) * (r[1] - p[1]) - (q[1] - p[1]) * (r[0] - p[0])
    return o(a, b, c) * o(a, b, d) < 0 and o(c, d, a) * o(c, d, b) < 0


LADDER_CLEAR = .045
SNAKE_ROUTE = .075     # placement-time margin around a straight snake line, so a gentle curve still clears


def candidate(rng, nl):
    """Place snakes, then ladders, one jump at a time, rejecting only the jump that conflicts."""
    used = set(); starts = set(); ends = set(); lsegs = []

    def fits(a, b):
        return a not in used and b not in used and a not in ends and b not in starts

    def add(a, b):
        used.update((a, b)); starts.add(a); ends.add(b)
    heads = [(91, 99), (60, 89), (40, 59), (14, 39)] + [(14, 99)] * 4
    snakes = []; ssegs = []   # straight head-to-tail lines stand in for the bodies while placing

    def clear_of_snakes(p, margin=SNAKE_ROUTE):
        return all(min_d(s, p) >= margin for s in ssegs)
    for lo, hi in heads:
        for _ in range(120):
            h = rng.randint(lo, hi); t = h - rng.randint(10, 60)
            if t < 2 or row(t) >= row(h) or (h, t) in CHUTES or not fits(h, t): continue
            H, T = centre(h), centre(t); body = seg_pts(H, T)[3:-1]
            if any(min_d(body, centre(s)) < SNAKE_ROUTE for s in starts): continue
            if not clear_of_snakes(H): continue
            if any(poly_d(body, s) < SNAKE_GAP + .02 for s in ssegs): continue
            add(h, t); snakes.append((h, t)); ssegs.append(body); break
        else:
            return None
    ladders = []
    for _ in range(600):
        if len(ladders) == nl: break
        a = rng.randint(2, 82); b = a + rng.randint(8, 34)
        if b >= 100 or row(b) == row(a) or (a, b) in CHUTES or not fits(a, b): continue
        A, B = centre(a), centre(b); seg = seg_pts(A, B)[2:-2]
        if not clear_of_snakes(A): continue
        if any(min_d(seg, centre(s)) < LADDER_CLEAR for s in starts): continue
        if any(min_d(o, A) < LADDER_CLEAR or segments_cross(o[0], o[-1], A, B) for o in lsegs): continue
        add(a, b); ladders.append(("ladder", a, b)); lsegs.append(seg_pts(A, B))
    if len(ladders) < nl: return None
    # ranks: the four anchor snakes plus two more are always on; 7 and 8 are the last two
    order = snakes[:4] + sorted(snakes[4:], key=lambda s: -(s[0] - s[1]))
    return ladders + [("snake", h, t, r) for r, (h, t) in enumerate(order, 1)]


def as_json(jumps):
    out = []; li = 0
    for j in jumps:
        if j[0] == "ladder":
            li += 1; out.append({"id": f"L{li}", "type": "ladder", "from": j[1], "to": j[2]})
        else:
            out.append({"id": f"S{j[3]}", "type": "snake", "rank": j[3], "from": j[1], "to": j[2]})
    return out


def design(cfg):
    rng = random.Random(cfg["seed"]); tries = 0
    while True:
        tries += 1
        jumps = candidate(rng, cfg["ladders"])
        if not jumps: continue
        ladders = [j for j in jumps if j[0] == "ladder"]; snakes = [j for j in jumps if j[0] == "snake"]
        starts = [centre(j[1]) for j in jumps]
        if len({row(j[1]) for j in jumps}) < 8: continue  # spread over the board
        ok = True
        lsegs = [(centre(l[1]), centre(l[2])) for l in ladders]
        J = as_json(jumps)
        m = [stats(J, n)[0] for n in (6, 7, 8)]
        lo, hi = cfg["window7"]
        if not (lo <= m[1] <= hi and all(ALL_N[0] <= x <= ALL_N[1] for x in m) and m[0] < m[1] < m[2]):
            continue
        curves = []; paths = {}
        for s in sorted(snakes, key=lambda s: -(s[1] - s[2])):
            forb = [q for q in starts if q != centre(s[1])]
            res = snake_path(rng, s[1], s[2], forb, curves)
            if not res: ok = False; break
            curves.append(res[2]); paths[s[3]] = [[round(x, 3), round(y, 3)] for x, y in res[1]]
        if not ok: continue
        crossings = sum(1 for c in curves for a, b in lsegs
                        if any(segments_cross(c[i], c[i + 1], a, b) for i in range(len(c) - 1)))
        if crossings > 3: continue
        for j in J:
            if j["type"] == "snake": j["path"] = paths[j["rank"]]
        J.sort(key=lambda j: (j["type"] != "ladder", j.get("rank", 0), j["from"]))
        for i, j in enumerate([j for j in J if j["type"] == "ladder"], 1): j["id"] = f"L{i}"
        full = [stats(J, n) for n in (6, 7, 8)]
        return dict(id=cfg["id"], name=cfg["name"], theme=cfg["theme"], size=10, unlock=cfg["unlock"],
                    jumps=J), full, tries, crossings


if __name__ == "__main__":
    out_dir = os.path.join("design", "boards"); os.makedirs(out_dir, exist_ok=True)
    print(f"{'board':18} {'tries':>6} {'x':>2}  N=6 mean/med   N=7 mean/med   N=8 mean/med   (solo mean 6/7/8)")
    for cfg in BOARDS:
        board, full, tries, x = design(cfg)
        with open(os.path.join(out_dir, cfg["id"] + ".json"), "w") as f:
            json.dump(board, f, indent=2); f.write("\n")
        cols = "   ".join(f"{m:5.2f} / {md:3d}" for m, md, _ in full)
        print(f"{cfg['id']:18} {tries:6d} {x:2d}  {cols}   ({' '.join(f'{s:.1f}' for *_, s in full)})")
        for j in board["jumps"]:
            print("   ", j["id"], j["from"], "->", j["to"])
