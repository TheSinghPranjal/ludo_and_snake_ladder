"""Snakes & Ladders assets: per-theme tiles, frames, snake heads/tails/patterns, ladders, board cards,
How-to-Play art, theme JSON, and the board renderer used by the asset library."""
import json
import math
import os
import sys

from kit import PLAYER, SHELL, Doc, f, mix, outline, shade, star_pts, tint
from registry import MODES, record

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "design"))
from design_snl_boards import catmull, centre  # noqa: E402

ROOT = os.path.join(os.path.dirname(__file__), "..", "..")
THEME_OF = {"classic_sunshine": "sunshine", "sugar_rush": "sweets", "jungle_temple": "jungle"}
VARIANTS = "abcd"

THEMES = {
    "sunshine": {
        "light": dict(tile_a="#FFF59D", tile_b="#F9C440", frame="#F5C518", number="#3B2A07", halo=None, bg="#FFE9A8", bg2="#FFDD7A",
                      body="#8BC34A", belly="#DCEDC8", spots="#2E7D32", glow=None, rail="#3D8BE0", rung="#3D8BE0", accent="#FF7043"),
        "dark": dict(tile_a="#1E2A44", tile_b="#8A6A1C", frame="#C9A227", number="#FFF8E1", halo="#0E1320", bg="#141A2B", bg2="#1A2236",
                     body="#9CCC65", belly="#5F7F3A", spots="#388E3C", glow="#9CCC65", rail="#7FB8FF", rung="#7FB8FF", accent="#FF8A65"),
    },
    "sweets": {
        "light": dict(tile_a="#FFE3EF", tile_b="#D3F3E6", frame="#FF8FB8", number="#5A2440", halo=None, bg="#FFF0F6", bg2="#FFD9EA",
                      body="#FF7EB3", belly="#FFE0EE", spots="#FFFFFF", glow=None, rail="#FFFFFF", rung="#FFF4F8", accent="#E23B4E"),
        "dark": dict(tile_a="#2E2140", tile_b="#1E3A38", frame="#B4507E", number="#FFEAF4", halo="#140C1C", bg="#1A1224", bg2="#24182F",
                     body="#FF8FC0", belly="#9C4A70", spots="#FFE0EE", glow="#FF8FC0", rail="#F3E6EC", rung="#F3E6EC", accent="#FF6B7E"),
    },
    "jungle": {
        "light": dict(tile_a="#D8CFB6", tile_b="#B8AE92", frame="#6E5A3A", number="#3A3020", halo=None, bg="#DCE8C8", bg2="#C7DAAE",
                      body="#E0A030", belly="#F6DFA8", spots="#6B3D10", glow=None, rail="#4F8A2B", rung="#9A6B3A", accent="#7BBF45"),
        "dark": dict(tile_a="#2C312B", tile_b="#3C4236", frame="#4F4330", number="#F1EAD6", halo="#121510", bg="#131811", bg2="#1B2318",
                     body="#E8B04A", belly="#8A6630", spots="#7A4A12", glow="#E8B04A", rail="#7DB04A", rung="#B08452", accent="#9BD45E"),
    },
}
HEAD_ANCHOR = (0.15, 0.5)   # neck join, head faces +x
TAIL_ANCHOR = (0.08, 0.5)   # body join, tail tip at +x
BODY_WIDTH = (0.32, 0.12)   # tile widths at head and tail


def board(bid):
    with open(os.path.join(ROOT, "design", "boards", bid + ".json")) as fh:
        return json.load(fh)


# ---------------------------------------------------------------- tiles & frames
def tile(theme, mode, kind, name, s=64):
    P = THEMES[theme][mode]
    d = Doc(s, s, name)
    base = P["tile_a"] if kind in ("a", "start") else P["tile_b"]
    if kind == "goal":
        base = P["tile_a"]
    d.add(f'<rect width="{s}" height="{s}" fill="{base}"/>',
          f'<path d="M0 0H{s}V3H3V{s}H0Z" fill="#FFFFFF" fill-opacity="{.35 if mode == "light" else .08}"/>',
          f'<path d="M{s} {s}H0V{s - 3}H{s - 3}V0H{s}Z" fill="{shade(base, .3)}" fill-opacity=".35"/>')
    if theme == "sweets" and kind == "b":
        for x, y, a, c in ((14, 16, 30, "#FF7EB3"), (44, 22, -20, "#7EC8FF"), (24, 46, 70, "#FFD34D"), (50, 50, 10, "#B07DE8")):
            d.add(f'<rect x="{x - 4}" y="{y - 1.5}" width="8" height="3" rx="1.5" fill="{c}" fill-opacity="{.7 if mode == "light" else .5}" transform="rotate({a} {x} {y})"/>')
    if theme == "jungle":
        d.add(f'<path d="M8 20 l10 4 l6 -3 M40 44 l8 6 M46 12 l-6 8" fill="none" stroke="{shade(base, .35)}" stroke-opacity=".6" stroke-width="1.5" stroke-linecap="round"/>')
    if kind == "start":
        g = "#3D9142" if mode == "light" else "#5DB862"
        d.add(f'<path d="M20 22 h14 v-8 l16 18 l-16 18 v-8 h-14 Z" fill="{g}" stroke="{outline(g)}" stroke-width="2.5" stroke-linejoin="round"/>')
    if kind == "goal":
        if theme == "sunshine":
            c = P["accent"]
            d.add(f'<path d="M14 52 L26 18 L48 40 Z" fill="{c}" stroke="{outline(c)}" stroke-width="2.5" stroke-linejoin="round"/>',
                  f'<path d="M20 36 L33 46 M17 44 L26 51" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round"/>')
            for x, y, col in ((36, 12, "#3E8EDE"), (48, 22, "#3D9142"), (54, 10, "#D9342B"), (42, 28, "#FFFFFF")):
                d.add(f'<circle cx="{x}" cy="{y}" r="3" fill="{col}"/>')
            d.add(f'<path d="M30 14 q4 -8 10 -6 M50 32 q8 0 8 -8" fill="none" stroke="{P["accent"]}" stroke-width="2.5" stroke-linecap="round"/>')
        elif theme == "sweets":
            d.add('<path d="M32 36 V60" stroke="#C9A27A" stroke-width="4" stroke-linecap="round"/>')
            d.ball(32, 26, 16, P["accent"], sw=2.5)
            d.add(f'<path d="M32 26 m-10 0 a10 10 0 1 1 10 10 a6 6 0 1 1 -6 -6" fill="none" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round"/>')
        else:
            gold = "#F5B700"
            d.add(f'<polygon points="32,8 50,28 32,56 14,28" fill="{gold}" stroke="{outline(gold)}" stroke-width="2.5" stroke-linejoin="round"/>',
                  f'<polygon points="32,8 40,28 32,56 24,28" fill="{tint(gold, .35)}"/>',
                  f'<polygon points="14,28 50,28 32,8" fill="#FFFFFF" fill-opacity=".25"/>')
    return d


def frame(theme, mode, name):
    P = THEMES[theme][mode]
    d = Doc(192, 192, name)
    c = P["frame"]
    d.add(f'<path fill-rule="evenodd" d="M0 36 a36 36 0 0 1 36 -36 H156 a36 36 0 0 1 36 36 V156 a36 36 0 0 1 -36 36 H36 a36 36 0 0 1 -36 -36 Z '
          f'M40 44 a4 4 0 0 1 4 -4 H148 a4 4 0 0 1 4 4 V148 a4 4 0 0 1 -4 4 H44 a4 4 0 0 1 -4 -4 Z" fill="{c}" stroke="{outline(c)}" stroke-width="4"/>')
    d.add(f'<path d="M10 40 a30 30 0 0 1 30 -30 H152" fill="none" stroke="#FFFFFF" stroke-opacity=".45" stroke-width="5" stroke-linecap="round"/>',
          f'<path d="M182 152 a30 30 0 0 1 -30 30 H40" fill="none" stroke="{shade(c, .3)}" stroke-width="6" stroke-linecap="round"/>',
          f'<rect x="38" y="38" width="116" height="116" rx="6" fill="none" stroke="{shade(c, .35)}" stroke-width="4"/>')
    if theme == "sunshine":
        for x, y in ((20, 20), (172, 20), (20, 172), (172, 172), (96, 20), (96, 172), (20, 96), (172, 96)):
            d.ball(x, y, 6, tint(c, .3), sw=1.5)
    elif theme == "sweets":
        for i, (x, y) in enumerate(((22, 60), (60, 18), (132, 20), (174, 64), (172, 130), (130, 174), (62, 172), (18, 130))):
            col = ("#FFFFFF", "#7EC8FF", "#FFD34D", "#B07DE8")[i % 4]
            d.add(f'<rect x="{x - 6}" y="{y - 2.5}" width="12" height="5" rx="2.5" fill="{col}" transform="rotate({i * 47} {x} {y})"/>')
    else:
        for x in (64, 128):
            d.add(f'<path d="M{x} 2 V38 M{x} 154 V190 M2 {x} H38 M154 {x} H190" stroke="{shade(c, .35)}" stroke-width="3"/>')
        leaf = P["accent"]
        for x, y, a in ((14, 14, 45), (178, 178, 225)):
            d.add(f'<path d="M{x} {y} q14 -2 22 10 q-12 8 -22 -10 Z" fill="{leaf}" stroke="{outline(leaf)}" stroke-width="2" transform="rotate({a - 45} {x} {y})"/>')
    return d


def board_bg(theme, mode, name):
    P = THEMES[theme][mode]
    d = Doc(128, 128, name)
    d.add(f'<rect width="128" height="128" fill="{P["bg"]}"/>')
    if theme == "sunshine":
        for k in range(-2, 4):
            x = k * 64
            d.add(f'<path d="M{x} 0 L{x + 32} 0 L{x + 160} 128 L{x + 128} 128 Z" fill="{P["bg2"]}" fill-opacity=".55"/>')
    elif theme == "sweets":
        for x, y in ((0, 0), (128, 0), (0, 128), (128, 128), (64, 64)):
            d.add(f'<circle cx="{x}" cy="{y}" r="14" fill="{P["bg2"]}"/>')
        for x, y in ((64, 0), (64, 128), (0, 64), (128, 64)):
            d.add(f'<circle cx="{x}" cy="{y}" r="6" fill="{P["bg2"]}"/>')
    else:
        for x, y, a in ((30, 34, 20), (96, 92, -30), (94, 24, 70), (28, 100, 140)):
            d.add(f'<path d="M{x} {y} q16 -4 24 12 q-16 6 -24 -12 Z" fill="{P["bg2"]}" transform="rotate({a} {x} {y})"/>')
    return d


# ---------------------------------------------------------------- snake parts
def head_group(theme, mode, variant, state, scale=1.0):
    """Head drawn facing +x in an 80x64 box; neck join at HEAD_ANCHOR."""
    P = THEMES[theme][mode]
    body, sp = P["body"], P["spots"]
    o = outline(body)
    sx, sy = {"idle": (1, 1), "gulp1": (.93, 1.1), "gulp2": (.88, 1.18)}[state]
    rx, ry = {"a": (24, 19), "b": (22, 18), "c": (25, 21), "d": (26, 16)}[variant]
    cx, cy = 40, 32
    g = []

    def add(*parts):
        g.extend(parts)
    if P["glow"]:
        add(f'<ellipse cx="{cx}" cy="{cy}" rx="{f(rx * sx + 6)}" ry="{f(ry * sy + 6)}" fill="{P["glow"]}" fill-opacity=".22"/>')
    if state == "idle":
        add(f'<path d="M{cx + rx * sx - 2} {cy} h12 m0 0 l6 -4 m-6 4 l6 4" fill="none" stroke="#E53935" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round"/>')
    add(f'<path d="M6 {cy - 9} Q{cx - 10} {cy - ry * sy} {cx} {cy - ry * sy} Q{cx + rx * sx} {cy - ry * sy} {cx + rx * sx} {cy} '
             f'Q{cx + rx * sx} {cy + ry * sy} {cx} {cy + ry * sy} Q{cx - 10} {cy + ry * sy} 6 {cy + 9} Z" fill="{body}" stroke="{o}" stroke-width="3" stroke-linejoin="round"/>')
    add(f'<path d="M{cx - 14} {cy + ry * sy * .55} Q{cx + 6} {cy + ry * sy * .9} {cx + rx * sx * .8} {cy + ry * sy * .3}" fill="none" stroke="{shade(body, .2)}" stroke-width="4" stroke-linecap="round" stroke-opacity=".7"/>')
    if theme == "sweets":
        for i in range(3):
            add(f'<path d="M{cx - 18 + i * 9} {cy - ry * sy + 3} l7 {f(ry * sy * 2 - 6)}" stroke="{sp}" stroke-width="3.5" stroke-linecap="round" stroke-opacity=".8"/>')
    elif theme == "jungle":
        add(f'<path d="M{cx - 6} {cy - 4} l6 4 l-6 4 l-6 -4 Z" fill="{sp}"/>')
    else:
        for x, y, r in ((cx - 14, cy - 8, 3), (cx - 6, cy + 9, 2.5), (cx - 20, cy + 6, 2)):
            add(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{sp}"/>')
    if state == "gulp1":
        add(f'<path d="M{cx + rx * sx - 7} {cy - 5} Q{cx + rx * sx + 1} {cy} {cx + rx * sx - 7} {cy + 5}" fill="#3A1A1A" stroke="{o}" stroke-width="2"/>')
    if state == "gulp2":
        add(f'<path d="M{cx + rx * sx + 1} {cy - 12} L{cx + 6} {cy} L{cx + rx * sx + 1} {cy + 12} Z" fill="#5A1E2A" stroke="{o}" stroke-width="2.5" stroke-linejoin="round"/>',
                 f'<path d="M{cx + 12} {cy} L{cx + rx * sx - 2} {cy - 4} L{cx + rx * sx - 2} {cy + 4} Z" fill="#FF8FA3"/>')
    ex = cx + (2 if state != "gulp2" else -4)
    for s in (-1, 1):
        ey = cy + s * ry * sy * .48
        if state == "gulp2":
            add(f'<path d="M{ex - 6} {ey + 2} q6 -7 12 0" fill="none" stroke="#2A2A35" stroke-width="3" stroke-linecap="round"/>')
            continue
        er = 7.5 if variant != "d" else 6.5
        add(f'<circle cx="{ex}" cy="{f(ey)}" r="{er}" fill="#FFFFFF" stroke="{o}" stroke-width="2"/>',
                 f'<circle cx="{ex + 2.5}" cy="{f(ey)}" r="{er * .52}" fill="#2A2A35"/>',
                 f'<circle cx="{ex + 1.2}" cy="{f(ey - 1.6)}" r="{er * .2}" fill="#FFFFFF"/>')
        if variant == "b":
            add(f'<path d="M{ex - er} {f(ey - 1)} A{er} {er} 0 0 1 {ex + er} {f(ey - 1)} Z" fill="{body}" stroke="{o}" stroke-width="2"/>')
        if variant == "c":
            add(f'<path d="M{ex - 7} {f(ey - s * 10)} q7 {-s * 3} 12 {s * 1}" fill="none" stroke="{o}" stroke-width="2.4" stroke-linecap="round"/>')
        if variant == "d":
            add(f'<path d="M{ex - 4} {f(ey - s * 7)} l-3 {-s * 3} M{ex} {f(ey - s * 7.5)} l0 {-s * 3.5}" stroke="{o}" stroke-width="1.8" stroke-linecap="round"/>')
    add(f'<circle cx="{cx + rx * sx - 5}" cy="{cy - 4}" r="1.4" fill="{o}"/><circle cx="{cx + rx * sx - 5}" cy="{cy + 4}" r="1.4" fill="{o}"/>')
    if variant == "c" and state != "gulp2":
        for s in (-1, 1):
            add(f'<ellipse cx="{cx - 6}" cy="{f(cy + s * ry * sy * .62)}" rx="5" ry="3" fill="#FF8FA3" fill-opacity=".6"/>')
    inner = "".join(g)
    return inner if scale == 1 else f'<g transform="scale({scale})">{inner}</g>'


def tail_group(theme, mode, variant):
    """Tail drawn in a 48x32 box, body join at TAIL_ANCHOR, tip at +x."""
    P = THEMES[theme][mode]
    body = P["body"]; o = outline(body)
    shapes = {"a": "M2 10 Q30 12 46 16 Q30 20 2 22 Z", "b": "M2 10 Q26 10 34 16 Q40 24 46 18 Q40 14 34 22 Q24 22 2 22 Z",
              "c": "M2 10 Q20 11 30 13 a5 5 0 0 1 0 6 Q20 21 2 22 Z", "d": "M2 10 Q24 11 36 16 Q24 21 2 22 Z"}
    g = []

    def add(*parts):
        g.extend(parts)
    add(f'<path d="{shapes[variant]}" fill="{body}" stroke="{o}" stroke-width="2.5" stroke-linejoin="round"/>')
    if variant == "c":
        for x in (34, 39, 44):
            add(f'<circle cx="{x}" cy="16" r="3.2" fill="{tint(body, .25)}" stroke="{o}" stroke-width="1.8"/>')
    if variant == "d":
        leaf = P["accent"] if theme == "jungle" else P["spots"]
        add(f'<path d="M34 16 q6 -8 13 -2 q-5 8 -13 2 Z" fill="{leaf}" stroke="{outline(leaf)}" stroke-width="1.6"/>')
    return "".join(g)


def pattern_group(theme, mode, variant, w=64, h=32):
    P = THEMES[theme][mode]
    c = P["spots"]
    if variant == "a":
        return "".join(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{c}"/>' for x, y, r in ((10, 11, 3.5), (30, 21, 3), (50, 12, 3.5), (58, 22, 2)))
    if variant == "b":
        return "".join(f'<path d="M{x} 9 l7 7 l-7 7" fill="none" stroke="{c}" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>' for x in (8, 24, 40, 56))
    if variant == "c":
        return "".join(f'<rect x="{x}" y="6" width="7" height="20" rx="3.5" fill="{c}"/>' for x in (6, 38))
    return "".join(f'<polygon points="{x},8 {x + 8},16 {x},24 {x - 8},16" fill="{c}" fill-opacity=".9"/>' for x in (16, 48))


def ladder_parts(theme, mode):
    P = THEMES[theme][mode]
    rail, rung = P["rail"], P["rung"]
    if theme == "sunshine":
        r = (f'<rect x="3" y="0" width="10" height="64" fill="{rail}"/><rect x="3" y="0" width="3" height="64" fill="#FFFFFF" fill-opacity=".4"/>'
             f'<path d="M3 0V64M13 0V64" stroke="{outline(rail)}" stroke-width="2.5"/>')
        g = (f'<rect x="1" y="2" width="46" height="8" rx="3" fill="{rung}" stroke="{outline(rung)}" stroke-width="2.2"/>'
             f'<rect x="5" y="3.5" width="38" height="2" rx="1" fill="#FFFFFF" fill-opacity=".45"/>')
    elif theme == "sweets":
        stripes = "".join(f'<path d="M3 {y} L13 {y - 8} V{y - 2} L3 {y + 6} Z" fill="{P["accent"]}"/>' for y in range(0, 72, 16))
        r = f'<rect x="3" y="0" width="10" height="64" fill="{rail}"/>{stripes}<path d="M3 0V64M13 0V64" stroke="{outline(P["accent"])}" stroke-width="2"/>'
        g = (f'<rect x="1" y="2" width="46" height="8" rx="4" fill="{rung}" stroke="{outline(P["accent"])}" stroke-width="2"/>'
             + "".join(f'<path d="M{x} 2.5 l5 7" stroke="{P["accent"]}" stroke-width="3" stroke-linecap="round"/>' for x in (8, 18, 28, 38)))
    else:
        r = (f'<path d="M8 0 C2 16 14 16 8 32 C2 48 14 48 8 64" fill="none" stroke="{outline(rail)}" stroke-width="8"/>'
             f'<path d="M8 0 C2 16 14 16 8 32 C2 48 14 48 8 64" fill="none" stroke="{rail}" stroke-width="5"/>'
             f'<path d="M9 22 q8 -4 9 -10 q-8 2 -9 10 Z" fill="{P["accent"]}" stroke="{outline(P["accent"])}" stroke-width="1.4"/>')
        g = (f'<rect x="1" y="2" width="46" height="8" rx="4" fill="{rung}" stroke="{outline(rung)}" stroke-width="2"/>'
             f'<path d="M6 2v8M42 2v8" stroke="{rail}" stroke-width="3"/>')
    return r, g


# ---------------------------------------------------------------- renderers (board, snake, ladder)
def _tangent(P, i, j):
    dx, dy = P[j][0] - P[i][0], P[j][1] - P[i][1]
    return math.degrees(math.atan2(dy, dx)), math.hypot(dx, dy)


def render_snake(d, jump, x, y, size, theme, mode, variant):
    s = size / 10
    pts = [centre(jump["from"])] + [tuple(p) for p in jump["path"]] + [centre(jump["to"])]
    P = [(x + u * size, y + v * size) for u, v in catmull(pts, 18)]
    T = THEMES[theme][mode]
    N = len(P); left, right = [], []
    for i, (px, py) in enumerate(P):
        a = P[max(0, i - 1)]; b = P[min(N - 1, i + 1)]
        dx, dy = b[0] - a[0], b[1] - a[1]; L = math.hypot(dx, dy) or 1
        nx, ny = -dy / L, dx / L
        w = s * (BODY_WIDTH[0] - (BODY_WIDTH[0] - BODY_WIDTH[1]) * i / (N - 1)) / 2
        left.append((px + nx * w, py + ny * w)); right.append((px - nx * w, py - ny * w))
    poly = "M" + " L".join(f"{f(a)} {f(b)}" for a, b in left + right[::-1]) + " Z"
    if T["glow"]:
        d.add(f'<path d="{poly}" fill="none" stroke="{T["glow"]}" stroke-opacity=".28" stroke-width="{f(s * .14)}" stroke-linejoin="round"/>')
    d.add(f'<path d="{poly}" fill="{T["body"]}" stroke="{outline(T["body"])}" stroke-width="{f(s * .045)}" stroke-linejoin="round"/>')
    belly = "M" + " L".join(f"{f((l[0] * .35 + r[0] * .65))} {f((l[1] * .35 + r[1] * .65))}" for l, r in zip(left[3:-2], right[3:-2]))
    d.add(f'<path d="{belly}" fill="none" stroke="{T["belly"]}" stroke-opacity=".75" stroke-width="{f(s * .05)}" stroke-linecap="round"/>')
    pat = pattern_group(theme, mode, variant)
    step = max(3, N // 9)
    for i in range(4, N - 3, step):
        ang, _ = _tangent(P, i - 1, i + 1)
        w = (BODY_WIDTH[0] - (BODY_WIDTH[0] - BODY_WIDTH[1]) * i / (N - 1))
        k = s * w / 32 * .8
        d.add(f'<g transform="translate({f(P[i][0])} {f(P[i][1])}) rotate({f(ang)}) scale({f(k)}) translate(-32 -16)" opacity=".9">{pat}</g>')
    ang, _ = _tangent(P, N - 2, N - 1)
    k = s * .015
    d.add(f'<g transform="translate({f(P[-1][0])} {f(P[-1][1])}) rotate({f(ang)}) scale({f(k)}) translate(-29 -16)">{tail_group(theme, mode, variant)}</g>')
    ang, _ = _tangent(P, 2, 0)
    k = s * .0155
    d.add(f'<g transform="translate({f(P[0][0])} {f(P[0][1])}) rotate({f(ang)}) scale({f(k)}) translate(-40 -32)">'
          f'{head_group(theme, mode, variant, "idle")}</g>')


def render_ladder(d, jump, x, y, size, theme, mode):
    s = size / 10
    T = THEMES[theme][mode]
    (ax, ay), (bx, by) = [(x + u * size, y + v * size) for u, v in (centre(jump["from"]), centre(jump["to"]))]
    ang, L = _tangent([(ax, ay), (bx, by)], 0, 1)
    rail, rung = ladder_parts(theme, mode)
    half = s * .19; rw = s * .13
    d.add(f'<g transform="translate({f(ax)} {f(ay)}) rotate({f(ang - 90)})">')
    d.add(f'<rect x="{f(-half - rw / 2 + s * .05)}" y="{f(s * .05)}" width="{f(half * 2 + rw)}" height="{f(L)}" rx="{f(rw / 2)}" fill="#000000" fill-opacity=".14"/>')
    n = max(2, int(L / (s * .3)))
    for i in range(1, n):
        yy = L * i / n
        d.add(f'<g transform="translate({f(-half)} {f(yy - s * .06)}) scale({f(half * 2 / 48)} {f(s * .12 / 12)})">{rung}</g>')
    for sx in (-half, half):
        reps = max(1, math.ceil(L / (rw * 64 / 16)))
        seg = L / reps
        for r in range(reps):
            d.add(f'<g transform="translate({f(sx - rw / 2)} {f(r * seg)}) scale({f(rw / 16)} {f(seg / 64)})">{rail}</g>')
    d.add("</g>")


def render_board(d, x, y, size, bid, n=7, mode="light", tokens=(), numbers=True, frame_on=True, mini=False):
    theme = THEME_OF[bid]
    T = THEMES[theme][mode]
    b = board(bid)
    s = size / 10
    if frame_on:
        fr = s * .45
        d.slab(x - fr, y - fr, size + 2 * fr, size + 2 * fr, s * .5, T["frame"], sw=s * .06, band=s * .12)
    for sq in range(1, 101):
        r = (sq - 1) // 10; c = (sq - 1) % 10; col = c if r % 2 == 0 else 9 - c
        fill = T["tile_a"] if (r + col) % 2 == 0 else T["tile_b"]
        d.add(f'<rect x="{f(x + col * s)}" y="{f(y + (9 - r) * s)}" width="{f(s + .4)}" height="{f(s + .4)}" fill="{fill}"/>')
    if not mini:
        gx, gy = x + 0 * s, y + 0 * s
        d.add(f'<g transform="translate({f(gx)} {f(gy)}) scale({f(s / 64)})">{_goal_inner(theme, mode)}</g>')
    if numbers:
        for sq in range(1, 101):
            r = (sq - 1) // 10; c = (sq - 1) % 10; col = c if r % 2 == 0 else 9 - c
            cx, cy = x + (col + .5) * s, y + (9 - r + .5) * s
            halo = f' stroke="{T["halo"]}" stroke-width="{f(s * .08)}" paint-order="stroke"' if T["halo"] else ""
            d.add(f'<text x="{f(cx)}" y="{f(cy + s * .14)}" font-family="Fredoka" font-weight="700" font-size="{f(s * .4)}" '
                  f'text-anchor="middle" fill="{T["number"]}" fill-opacity="{.85 if sq != 100 else 1}"{halo}>{sq}</text>')
    for j in b["jumps"]:
        if j["type"] == "ladder":
            render_ladder(d, j, x, y, size, theme, mode)
    snakes = sorted([j for j in b["jumps"] if j["type"] == "snake" and j["rank"] <= n], key=lambda j: -j["rank"])
    for j in snakes:
        render_snake(d, j, x, y, size, theme, mode, VARIANTS[(j["rank"] - 1) % 4])
    for i, (sq, color) in enumerate(tokens):
        from gen_shared import token_doc
        u, v = centre(sq)
        same = [k for k, (q, _) in enumerate(tokens) if q == sq]
        off = (same.index(i) - (len(same) - 1) / 2) * s * .32
        ts = s * .98
        tk = token_doc(color, "active" if i == 0 else "idle", mode, f"bt{bid}{mode}{n}{i}{sq}", 64)
        d.add(f'<g transform="translate({f(x + u * size - ts / 2 + off)} {f(y + v * size - ts / 2)}) scale({f(ts / 64)})">{tk.inner()}</g>')


def _goal_inner(theme, mode):
    return tile(theme, mode, "goal", f"goalin-{theme}-{mode}").inner()


# ---------------------------------------------------------------- composed assets
def board_card(bid, mode, name):
    pal = SHELL[mode]
    b = board(bid)
    d = Doc(240, 300, name)
    d.shadow(120, 292, 110, 8, .2)
    d.slab(4, 4, 232, 284, 24, pal["surface"], band=8, stroke=mix(pal["surface"], pal["text"], .2))
    render_board(d, 34, 30, 172, bid, 7, mode, numbers=False, mini=True)
    T = THEMES[THEME_OF[bid]][mode]
    d.slab(20, 226, 200, 48, 16, T["frame"], band=6)
    d.text(120, 258, b["name"], 22, "#2A2A35" if mode == "light" or THEME_OF[bid] == "sunshine" else "#FFFFFF")
    return d


def locked_overlay(mode, name):
    d = Doc(240, 300, name)
    d.add(f'<rect x="4" y="4" width="232" height="284" rx="24" fill="{"#FFFFFF" if mode == "light" else "#12141C"}" fill-opacity=".62"/>')
    d.ball(120, 124, 42, "#5E6272" if mode == "light" else "#A9AEC2", sw=4)
    d.add('<path d="M104 126 h32 v24 h-32 Z M110 126 v-9 a10 10 0 0 1 20 0 v9" fill="none" stroke="#FFFFFF" stroke-width="5" stroke-linejoin="round"/>')
    return d


def howto(i, mode, name):
    pal = SHELL[mode]
    T = THEMES["sunshine"][mode]
    d = Doc(320, 200, name)
    d.slab(2, 2, 316, 196, 22, pal["surface2"], sw=3, band=6, stroke=mix(pal["surface2"], pal["text"], .15))
    s = 44
    x0, y0 = 30, 34

    def sq(c, r, label, fill=None):
        d.add(f'<rect x="{x0 + c * s}" y="{y0 + r * s}" width="{s}" height="{s}" fill="{fill or (T["tile_a"] if (c + r) % 2 else T["tile_b"])}"/>')
        if label:
            halo = f' stroke="{T["halo"]}" stroke-width="3" paint-order="stroke"' if T["halo"] else ""
            d.add(f'<text x="{x0 + c * s + s / 2}" y="{y0 + r * s + s / 2 + 6}" font-family="Fredoka" font-weight="700" font-size="16" text-anchor="middle" fill="{T["number"]}"{halo}>{label}</text>')

    def tok(cx, cy, col="red", st="idle", k=40):
        from gen_shared import token_doc
        t = token_doc(col, st, mode, f"{name}-{cx}-{cy}", 64)
        d.add(f'<g transform="translate({f(cx - k / 2)} {f(cy - k / 2)}) scale({f(k / 64)})">{t.inner()}</g>')

    def die(xx, yy, face, k=56):
        from gen_shared import die_face
        die_face(d, xx, yy, k, face, mode)

    arrow = pal["primary"]
    if i == 1:
        for c in range(5):
            sq(c, 2, 11 + c)
        tok(x0 + s / 2, y0 + 2.5 * s - 6)
        d.add(f'<path d="M{x0 + s / 2} {y0 + 2 * s - 10} Q{x0 + 2.5 * s} {y0 + s * .6} {x0 + 4.5 * s} {y0 + 2 * s - 10}" fill="none" stroke="{arrow}" stroke-width="4" stroke-dasharray="2 9" stroke-linecap="round"/>')
        die(236, 20, 4)
    else:
        for r in range(3):
            for c in range(5):
                sq(c, r, None)
        if i == 2:
            render_ladder(d, {"from": 1, "to": 23}, x0, y0 - 7 * s, s * 10, "sunshine", mode)
            tok(x0 + s * .5, y0 + 2.5 * s - 4, st="hop")
            d.add(f'<path d="M150 150 V60 M136 74 L150 58 L164 74" fill="none" stroke="{arrow}" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>')
        elif i == 3:
            j = {"from": 23, "to": 1, "rank": 1, "path": [[.17, .82], [.08, .88]]}
            render_snake(d, j, x0, y0 - 7 * s, s * 10, "sunshine", mode, "a")
            tok(x0 + s * 1.2, y0 + s * 1.4, st="hop")
            d.add(f'<path d="M262 52 V140 M248 126 L262 142 L276 126" fill="none" stroke="#E0563B" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>')
        elif i == 4:
            die(40, 50, 6, 64); die(124, 50, 6, 64)
            d.add(f'<path d="M210 70 a28 28 0 1 1 -4 36 M206 106 l-2 -14 l14 4" fill="none" stroke="{arrow}" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>')
            d.text(244, 160, "+1", 30, arrow)
        else:
            for c in range(5):
                sq(c, 1, (96 + c) if c < 4 else 100, None)
            d.add(f'<g transform="translate({x0 + 4 * s} {y0 + s}) scale({s / 64})">{_goal_inner("sunshine", mode)}</g>')
            tok(x0 + 1.5 * s, y0 + 1.5 * s)
            die(236, 120, 3, 56)
            d.add(f'<path d="M{x0 + 1.5 * s} {y0 + s - 4} Q{x0 + 3 * s} {y0 - 10} {x0 + 4.5 * s} {y0 + s - 4}" fill="none" stroke="{arrow}" stroke-width="4" stroke-dasharray="2 9" stroke-linecap="round"/>')
    return d


def theme_json(theme):
    out = {"theme": theme, "bodyWidth": {"head": BODY_WIDTH[0], "tail": BODY_WIDTH[1], "unit": "tile"},
           "headAnchor": HEAD_ANCHOR, "tailAnchor": TAIL_ANCHOR, "headFacing": "+x", "patternSpacing": 0.55,
           "ladderShadow": {"dx": 0.05, "dy": 0.05, "blur": 0.04, "opacity": 0.14, "unit": "tile"}, "modes": {}}
    for mode in MODES:
        P = THEMES[theme][mode]
        out["modes"][mode] = {
            "tiles": {"a": P["tile_a"], "b": P["tile_b"]}, "frame": P["frame"], "background": [P["bg"], P["bg2"]],
            "numbers": {"fill": P["number"], "halo": P["halo"]},
            "snake": {"base": P["body"], "belly": P["belly"], "outline": outline(P["body"]), "spots": P["spots"], "glow": P["glow"]},
            "ladder": {"rail": P["rail"], "rung": P["rung"], "outline": outline(P["rail"] if theme != "sweets" else P["accent"])},
        }
    return out


def all_assets():
    out = []
    for theme in THEMES:
        folder = f"games/snakes/themes/{theme}"
        for mode in MODES:
            for kind in ("a", "b", "start", "goal"):
                name = f"tile_{kind}_{theme}_{mode}"
                out.append(record(tile(theme, mode, kind, name), name, folder, "snakes", [mode], ["snakes_game"], "snl-tiles"))
            name = f"board_frame_{theme}_{mode}"
            out.append(record(frame(theme, mode, name), name, folder, "snakes", [mode], ["snakes_game"], "snl-tiles", nine=(48, 48, 48, 48)))
            name = f"board_bg_{theme}_{mode}"
            out.append(record(board_bg(theme, mode, name), name, folder, "snakes", [mode], ["snakes_game"], "snl-tiles", note="Seamless 128 px tile"))
            for v in VARIANTS:
                for st in ("idle", "gulp1", "gulp2"):
                    name = f"snake_head_{v}_{theme}_{st}_{mode}"
                    d = Doc(80, 64, name); d.add(head_group(theme, mode, v, st))
                    out.append(record(d, name, folder, "snakes", [mode], ["snakes_game"], "snl-snakes", anchor=HEAD_ANCHOR,
                                      note="Faces +x; rotate to the path tangent at the head"))
                name = f"snake_tail_{v}_{theme}_{mode}"
                d = Doc(48, 32, name); d.add(tail_group(theme, mode, v))
                out.append(record(d, name, folder, "snakes", [mode], ["snakes_game"], "snl-snakes", anchor=TAIL_ANCHOR))
                name = f"snake_pattern_{v}_{theme}_{mode}"
                d = Doc(64, 32, name); d.add(pattern_group(theme, mode, v))
                out.append(record(d, name, folder, "snakes", [mode], ["snakes_game"], "snl-snakes", note="Seamless along x; stamped along PathMetrics"))
            rail, rung = ladder_parts(theme, mode)
            name = f"ladder_rail_{theme}_{mode}"
            d = Doc(16, 64, name); d.add(rail)
            out.append(record(d, name, folder, "snakes", [mode], ["snakes_game"], "snl-ladders", note="Seamless along y"))
            name = f"ladder_rung_{theme}_{mode}"
            d = Doc(48, 12, name); d.add(rung)
            out.append(record(d, name, folder, "snakes", [mode], ["snakes_game"], "snl-ladders"))
    for bid in THEME_OF:
        for mode in MODES:
            name = f"board_card_{bid}_{mode}"
            out.append(record(board_card(bid, mode, name), name, "games/snakes/board_select", "snakes", [mode], ["board_select", "snakes_setup"], "snl-cards"))
    for mode in MODES:
        name = f"board_card_locked_{mode}"
        out.append(record(locked_overlay(mode, name), name, "games/snakes/board_select", "snakes", [mode], ["board_select"], "snl-cards"))
        for i in range(1, 6):
            name = f"howto_snakes_{i}_{mode}"
            out.append(record(howto(i, mode, name), name, "games/snakes/howto", "snakes", [mode], ["how_to_play"], "howto"))
    return out


def write_theme_json():
    paths = []
    for theme in THEMES:
        p = os.path.join(ROOT, "assets", "games", "snakes", "themes", f"{theme}.json")
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w") as fh:
            json.dump(theme_json(theme), fh, indent=2); fh.write("\n")
        paths.append(p)
    return paths
