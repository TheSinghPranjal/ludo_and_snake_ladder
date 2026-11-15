"""Independently re-check design/boards/*.json against the brief. Exit 1 on any failure.

    python3 tool/design/check_snl_boards.py
"""
import glob
import json
import math
import os
import random
import sys

sys.path.insert(0, os.path.dirname(__file__))
from snl_balance import stats  # noqa: E402
from design_snl_boards import CHUTES, catmull, centre  # noqa: E402

HEAD_SKIP = 6 / 24   # fraction of the first curve segment hidden under the head sprite


def check(path):
    b = json.load(open(path)); errs = []
    J = b["jumps"]; L = [j for j in J if j["type"] == "ladder"]; S = [j for j in J if j["type"] == "snake"]
    if not 8 <= len(L) <= 9: errs.append(f"{len(L)} ladders")
    if sorted(s.get("rank") for s in S) != list(range(1, 9)): errs.append("snakes not ranked 1..8")
    starts = [j["from"] for j in J]; ends = [j["to"] for j in J]
    if len(set(starts)) != len(starts): errs.append("duplicate starts")
    if set(starts) & set(ends): errs.append("chain")
    for j in J:
        a, c = j["from"], j["to"]
        if not (1 <= a <= 100 and 1 <= c <= 100): errs.append(f"{j['id']} out of range")
        if a in (1, 100): errs.append(f"{j['id']} starts on {a}")
        if j["type"] == "ladder" and c <= a: errs.append(f"{j['id']} ladder goes down")
        if j["type"] == "snake" and c >= a: errs.append(f"{j['id']} snake goes up")
        if j["type"] == "snake" and not 2 <= len(j.get("path", [])) <= 4: errs.append(f"{j['id']} path")
        if (a, c) in CHUTES: errs.append(f"{j['id']} copies Chutes and Ladders")
    on = [s["from"] for s in S if s["rank"] <= 6]
    if not (any(h >= 90 for h in on) and any(40 <= h <= 89 for h in on) and any(h < 40 for h in on)):
        errs.append("ranks 1-6 miss a band")
    # bodies never cover another snake head or a ladder foot
    worst = 1.0
    for s in S:
        pts = [centre(s["from"])] + [tuple(p) for p in s["path"]] + [centre(s["to"])]
        body = catmull(pts)[int(HEAD_SKIP * 24):]
        for o in J:
            if o is s: continue
            q = centre(o["from"]); d = min(math.dist(p, q) for p in body); worst = min(worst, d)
            if d < .05: errs.append(f"{s['id']} covers {o['id']} start {o['from']} ({d:.3f})")
    res = [stats(J, n) for n in (6, 7, 8)]
    for n, (mean, med, _) in zip((6, 7, 8), res):
        if not 25 <= mean <= 40: errs.append(f"N={n} mean {mean:.2f} outside 25-40")
    return b, res, worst, errs


def monte_carlo(b, n, games=4000, seed=7):
    """Cross-check of the exact model with plain simulation."""
    jm = {j["from"]: j["to"] for j in b["jumps"] if j["type"] == "ladder" or j["rank"] <= n}
    rng = random.Random(seed); total = 0
    for _ in range(games):
        pos = [0, 0]; turns = [0, 0]; cur = 0
        while True:
            turns[cur] += 1; start = pos[cur]; six = 0
            while True:
                r = rng.randint(1, 6)
                if r == 6:
                    six += 1
                    if six == 3: pos[cur] = start; break
                if pos[cur] + r <= 100: pos[cur] = jm.get(pos[cur] + r, pos[cur] + r)
                if pos[cur] == 100 or r != 6: break
            if pos[cur] == 100: break
            cur ^= 1
        total += max(turns)
    return total / games


if __name__ == "__main__":
    bad = False
    print(f"{'board':18} {'N':>2} {'exact mean':>10} {'median':>6} {'MC mean':>8}  min clearance")
    for p in sorted(glob.glob("design/boards/*.json")):
        b, res, worst, errs = check(p)
        for n, (mean, med, _) in zip((6, 7, 8), res):
            print(f"{b['id']:18} {n:2d} {mean:10.2f} {med:6d} {monte_carlo(b, n):8.2f}  {worst:.3f}")
        for e in errs: print("  FAIL", e); bad = True
    print("ALL OK" if not bad else "FAILURES"); sys.exit(1 if bad else 0)
