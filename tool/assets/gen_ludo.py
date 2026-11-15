"""Ludo assets: board pieces assembled by Flame from the section 3.1 geometry, How-to-Play art,
and the full-board renderer used by the asset library."""
import math

from kit import COLORS, PLAYER, SHELL, Doc, desat, f, mix, outline, star_pts, symbol, tint
from registry import MODES, record

TRACK = [(13, 6), (12, 6), (11, 6), (10, 6), (9, 6), (8, 5), (8, 4), (8, 3), (8, 2), (8, 1), (8, 0), (7, 0), (6, 0),
         (6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (5, 6), (4, 6), (3, 6), (2, 6), (1, 6), (0, 6), (0, 7), (0, 8),
         (1, 8), (2, 8), (3, 8), (4, 8), (5, 8), (6, 9), (6, 10), (6, 11), (6, 12), (6, 13), (6, 14), (7, 14),
         (8, 14), (8, 13), (8, 12), (8, 11), (8, 10), (8, 9), (9, 8), (10, 8), (11, 8), (12, 8), (13, 8), (14, 8),
         (14, 7), (14, 6)]
HOME = {"red": [(13, 7), (12, 7), (11, 7), (10, 7), (9, 7)], "blue": [(7, 1), (7, 2), (7, 3), (7, 4), (7, 5)],
        "yellow": [(1, 7), (2, 7), (3, 7), (4, 7), (5, 7)], "green": [(7, 13), (7, 12), (7, 11), (7, 10), (7, 9)]}
START = {"red": 0, "blue": 13, "yellow": 26, "green": 39}
STARS = (8, 21, 34, 47)
YARD = {"blue": (0, 0), "yellow": (0, 9), "green": (9, 9), "red": (9, 0)}
ARROW = {"red": ((14, 7), 0), "blue": ((7, 0), 90), "yellow": ((0, 7), 180), "green": ((7, 14), 270)}

PAL = {"light": dict(base="#FFFFFF", cell="#FFFFFF", grid="#C9CED8", star="#5E6272", frame="#E2DCCD", bg="#F3EEE2", bg2="#EAE3D2"),
       "dark": dict(base="#171A24", cell="#232838", grid="#343A4F", star="#E6E8F0", frame="#262A3C", bg="#12141C", bg2="#171A24")}
C = 48  # cell size at 1x


def pc(color, mode):
    return PLAYER[color] if mode == "light" else desat(PLAYER[color], .1)


def cell_group(mode, kind, color=None):
    P = PAL[mode]
    if kind == "cell":
        return f'<rect x=".75" y=".75" width="{C - 1.5}" height="{C - 1.5}" fill="{P["cell"]}" stroke="{P["grid"]}" stroke-width="1.5"/>'
    if kind == "star":
        return (cell_group(mode, "cell") +
                f'<polygon points="{star_pts(24, 25, 15, 6.5)}" fill="none" stroke="{P["star"]}" stroke-width="2.4" stroke-linejoin="round"/>')
    c = pc(color, mode)
    if kind == "start":
        return (f'<rect x=".75" y=".75" width="{C - 1.5}" height="{C - 1.5}" fill="{c}" stroke="{P["grid"]}" stroke-width="1.5"/>'
                f'<polygon points="{star_pts(24, 25, 15, 6.5)}" fill="none" stroke="#FFFFFF" stroke-width="2.6" stroke-linejoin="round"/>')
    if kind == "home":
        glow = f'<rect x="3" y="3" width="{C - 6}" height="{C - 6}" rx="4" fill="none" stroke="#FFFFFF" stroke-opacity=".18" stroke-width="3"/>' if mode == "dark" else ""
        return (f'<rect x=".75" y=".75" width="{C - 1.5}" height="{C - 1.5}" fill="{c}" stroke="{P["grid"]}" stroke-width="1.5"/>'
                f'<rect x="4" y="4" width="{C - 8}" height="6" rx="3" fill="#FFFFFF" fill-opacity=".25"/>' + glow)
    if kind == "arrow":
        return (cell_group(mode, "cell") +
                f'<path d="M24 38 V12 M14 22 L24 11 L34 22" fill="none" stroke="{c}" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>')
    raise ValueError(kind)


def yard_group(color, mode, s=288):
    P = PAL[mode]
    c = pc(color, mode)
    k = s / 288
    g = []
    if mode == "dark":
        g.append(f'<rect x="{f(2 * k)}" y="{f(2 * k)}" width="{f(284 * k)}" height="{f(284 * k)}" rx="{f(18 * k)}" fill="none" stroke="{c}" stroke-opacity=".35" stroke-width="{f(8 * k)}"/>')
    g.append(f'<rect x="{f(6 * k)}" y="{f(6 * k)}" width="{f(276 * k)}" height="{f(276 * k)}" rx="{f(16 * k)}" fill="{c}" stroke="{outline(c)}" stroke-width="{f(3 * k)}"/>')
    g.append(f'<rect x="{f(10 * k)}" y="{f(10 * k)}" width="{f(268 * k)}" height="{f(10 * k)}" rx="{f(5 * k)}" fill="#FFFFFF" fill-opacity=".22"/>')
    g.append(f'<rect x="{f(48 * k)}" y="{f(48 * k)}" width="{f(192 * k)}" height="{f(192 * k)}" rx="{f(24 * k)}" fill="{P["base"] if mode == "light" else P["cell"]}" stroke="{outline(c)}" stroke-width="{f(3 * k)}"/>')
    for cx, cy in ((96, 96), (192, 96), (96, 192), (192, 192)):
        g.append(f'<circle cx="{f(cx * k)}" cy="{f(cy * k)}" r="{f(30 * k)}" fill="{tint(c, .78) if mode == "light" else mix(P["cell"], c, .25)}" stroke="{c}" stroke-width="{f(4 * k)}"/>')
    return "".join(g)


def centre_group(mode, s=144):
    k = s / 144
    tri = {"red": f"0,{144} 144,144 72,72", "blue": "0,0 0,144 72,72", "yellow": "0,0 144,0 72,72", "green": "144,0 144,144 72,72"}
    g = []
    for col, pts in tri.items():
        c = pc(col, mode)
        pts = " ".join(f"{f(float(a) * k)},{f(float(b) * k)}" for a, b in (p.split(",") for p in pts.split()))
        g.append(f'<polygon points="{pts}" fill="{c}" stroke="{outline(c)}" stroke-width="{f(2 * k)}" stroke-linejoin="round"/>')
    g.append(f'<polygon points="{star_pts(72 * k, 73 * k, 22 * k, 10 * k)}" fill="#FFF6C8" stroke="#F5B700" stroke-width="{f(3 * k)}" stroke-linejoin="round"/>')
    return "".join(g)


def frame_doc(mode, name):
    P = PAL[mode]
    d = Doc(192, 192, name)
    c = P["frame"]
    d.add(f'<path fill-rule="evenodd" d="M0 28 a28 28 0 0 1 28 -28 H164 a28 28 0 0 1 28 28 V164 a28 28 0 0 1 -28 28 H28 a28 28 0 0 1 -28 -28 Z '
          f'M18 22 a4 4 0 0 1 4 -4 H170 a4 4 0 0 1 4 4 V170 a4 4 0 0 1 -4 4 H22 a4 4 0 0 1 -4 -4 Z" fill="{c}" stroke="{outline(c)}" stroke-width="3"/>',
          f'<path d="M8 30 a22 22 0 0 1 22 -22 H162" fill="none" stroke="#FFFFFF" stroke-opacity="{.5 if mode == "light" else .1}" stroke-width="4" stroke-linecap="round"/>')
    return d


def render_ludo(d, x, y, size, mode, tokens=(), ghosts=(), movable=()):
    """Full board from the geometry. tokens: (where, color[, state]) where = ('yard', k) | (r, c) | ('home',)."""
    from gen_shared import token_doc
    P = PAL[mode]
    k = size / (15 * C)
    fr = size * .03
    d.add(f'<rect x="{f(x - fr)}" y="{f(y - fr)}" width="{f(size + 2 * fr)}" height="{f(size + 2 * fr)}" rx="{f(fr * 1.6)}" fill="{P["frame"]}" stroke="{outline(P["frame"])}" stroke-width="{f(fr * .25)}"/>',
          f'<rect x="{f(x)}" y="{f(y)}" width="{f(size)}" height="{f(size)}" fill="{P["base"]}"/>')
    d.add(f'<g transform="translate({f(x)} {f(y)}) scale({f(k)})">')
    owner = {TRACK[i]: ("start", col) for col, i in START.items()}
    for col, hs in HOME.items():
        for h in hs:
            owner[h] = ("home", col)
    stars = {TRACK[i] for i in STARS}
    arrows = {rc: (col, rot) for col, (rc, rot) in ARROW.items()}
    for r in range(15):
        for cc in range(15):
            if not ((6 <= cc <= 8) != (6 <= r <= 8)):
                continue
            rc = (r, cc)
            if rc in owner:
                g = cell_group(mode, owner[rc][0], owner[rc][1])
            elif rc in stars:
                g = cell_group(mode, "star")
            elif rc in arrows:
                col, rot = arrows[rc]
                g = f'<g transform="rotate({rot} 24 24)">{cell_group(mode, "arrow", col)}</g>'
            else:
                g = cell_group(mode, "cell")
            d.add(f'<g transform="translate({cc * C} {r * C})">{g}</g>')
    for col, (r0, c0) in YARD.items():
        d.add(f'<g transform="translate({c0 * C} {r0 * C})">{yard_group(col, mode)}</g>')
    d.add(f'<g transform="translate({6 * C} {6 * C})">{centre_group(mode)}</g>')
    for g in ghosts:
        (r, cc), col = g
        d.add(f'<circle cx="{(cc + .5) * C}" cy="{(r + .5) * C}" r="15" fill="{pc(col, mode)}" fill-opacity=".35" stroke="{pc(col, mode)}" stroke-width="3" stroke-dasharray="5 4"/>')
    groups = {}
    for t in tokens:
        groups.setdefault((t[0], t[1] if t[0][0] in ("yard",) else None), []).append(t)
    for key, grp in groups.items():
        for i, t in enumerate(grp):
            where, col = t[0], t[1]
            st = t[2] if len(t) > 2 else "idle"
            if where[0] == "yard":
                r0, c0 = YARD[col]; kk = where[1]
                cx, cy = (c0 + 2 + 2 * (kk % 2)) * C, (r0 + 2 + 2 * (kk // 2)) * C
            elif where[0] == "home":
                cx, cy = 7.5 * C + (i - (len(grp) - 1) / 2) * 16, 7.5 * C
            else:
                cx, cy = (where[1] + .5) * C, (where[0] + .5) * C
                if len(grp) == 2:
                    cx += (i - .5) * 16; cy += (i - .5) * 6
            ts = 54
            tk = token_doc(col, st, mode, f"lt{mode}{x:.0f}{cx:.0f}{cy:.0f}{i}{col}", 64)
            d.add(f'<g transform="translate({f(cx - ts / 2)} {f(cy - ts / 2 - 4)}) scale({f(ts / 64)})">{tk.inner()}</g>')
    d.add("</g>")


def howto(i, mode, name):
    from gen_shared import die_face, token_doc
    pal = SHELL[mode]
    d = Doc(320, 200, name)
    d.slab(2, 2, 316, 196, 22, pal["surface2"], sw=3, band=6, stroke=mix(pal["surface2"], pal["text"], .15))

    def tok(cx, cy, col, st="idle", k=40):
        t = token_doc(col, st, mode, f"{name}-{cx}-{cy}-{col}", 64)
        d.add(f'<g transform="translate({f(cx - k / 2)} {f(cy - k / 2)}) scale({f(k / 64)})">{t.inner()}</g>')

    def cells(row, n, x0, y0, s=44, kinds=None):
        for c in range(n):
            kind = kinds[c] if kinds else ("cell", None)
            d.add(f'<g transform="translate({x0 + c * s} {y0 + row * s}) scale({s / 48})">{cell_group(mode, kind[0], kind[1])}</g>')

    arrow = pal["primary"]
    if i == 1:
        d.add(f'<g transform="translate(24 30) scale(.5)">{yard_group("red", mode)}</g>')
        cells(0, 3, 186, 120, kinds=[("start", "red"), ("cell", None), ("cell", None)])
        tok(72, 78, "red", "movable"); tok(208, 142, "red", "ghost")
        d.add(f'<path d="M98 82 Q170 60 204 116" fill="none" stroke="{arrow}" stroke-width="4" stroke-dasharray="2 9" stroke-linecap="round"/>')
        die_face(d, 230, 22, 60, 6, mode)
    elif i == 2:
        cells(0, 6, 28, 78)
        tok(50, 100, "blue")
        d.add(f'<path d="M50 70 Q120 30 180 70" fill="none" stroke="{arrow}" stroke-width="4" stroke-dasharray="2 9" stroke-linecap="round"/>',
              f'<path d="M172 60 L184 72 L168 76" fill="none" stroke="{arrow}" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>')
        tok(182, 100, "blue", "ghost")
        die_face(d, 230, 130, 54, 3, mode)
    elif i == 3:
        cells(0, 5, 40, 96)
        tok(150, 112, "green", "idle")
        tok(150, 84, "red", "hop")
        d.add(f'<path d="M150 120 Q120 180 60 60" fill="none" stroke="#E0563B" stroke-width="4" stroke-dasharray="3 8" stroke-linecap="round"/>')
        for a in range(6):
            d.add(f'<circle cx="{f(150 + 22 * math.cos(a))}" cy="{f(126 + 10 * math.sin(a))}" r="6" fill="#FFFFFF" stroke="#D7D2C8" stroke-width="2"/>')
    elif i == 4:
        cells(0, 3, 90, 80, kinds=[("cell", None), ("star", None), ("cell", None)])
        tok(146, 96, "blue"); tok(170, 108, "yellow")
        d.add(f'<path d="M260 60 l22 8 v22 c0 18 -12 28 -22 32 c-10 -4 -22 -14 -22 -32 v-22 Z" fill="{tint(arrow, .6)}" stroke="{arrow}" stroke-width="4" stroke-linejoin="round"/>',
              f'<path d="M250 90 l8 8 l14 -16" fill="none" stroke="{arrow}" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>')
    else:
        d.add(f'<g transform="translate(180 40) scale(.83)">{centre_group(mode)}</g>')
        for c in range(4):
            d.add(f'<g transform="translate({20 + c * 40} 80) scale({40 / 48})">{cell_group(mode, "home", "red")}</g>')
        tok(140, 100, "red", "hop")
        d.add(f'<path d="M160 100 L210 100" fill="none" stroke="{arrow}" stroke-width="4" stroke-linecap="round"/>',
              f'<path d="M200 90 L212 100 L200 110" fill="none" stroke="{arrow}" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>')
    return d


def all_assets():
    out = []
    folder = "games/ludo/board"
    for mode in MODES:
        P = PAL[mode]
        for kind in ("cell", "star"):
            name = f"cell{'' if kind == 'cell' else '_safe_star'}_{mode}"
            d = Doc(C, C, name); d.add(cell_group(mode, kind))
            out.append(record(d, name, folder, "ludo", [mode], ["ludo_game"], "ludo-pieces"))
        for col in COLORS:
            for kind, nm in (("start", "cell_start"), ("home", "home_column"), ("arrow", "arrow")):
                name = f"{nm}_{col}_{mode}"
                d = Doc(C, C, name); d.add(cell_group(mode, kind, col))
                out.append(record(d, name, folder, "ludo", [mode], ["ludo_game"], "ludo-pieces",
                                  note="Points up; rotate per side" if kind == "arrow" else ""))
            name = f"yard_{col}_{mode}"
            d = Doc(288, 288, name); d.add(yard_group(col, mode))
            out.append(record(d, name, folder, "ludo", [mode], ["ludo_game"], "ludo-pieces", note="6 × 6 cells; slots at cell centres 2 and 4"))
        name = f"centre_home_{mode}"
        d = Doc(144, 144, name); d.add(centre_group(mode))
        out.append(record(d, name, folder, "ludo", [mode], ["ludo_game"], "ludo-pieces"))
        name = f"board_frame_ludo_{mode}"
        out.append(record(frame_doc(mode, name), name, folder, "ludo", [mode], ["ludo_game"], "ludo-pieces", nine=(32, 32, 32, 32)))
        name = f"board_bg_ludo_{mode}"
        d = Doc(96, 96, name)
        d.add(f'<rect width="96" height="96" fill="{P["bg"]}"/>')
        for x, y in ((0, 0), (96, 0), (0, 96), (96, 96), (48, 48)):
            d.add(f'<circle cx="{x}" cy="{y}" r="5" fill="{P["bg2"]}"/>')
        out.append(record(d, name, folder, "ludo", [mode], ["ludo_game"], "ludo-pieces", note="Seamless 96 px tile"))
        for i in range(1, 6):
            name = f"howto_ludo_{i}_{mode}"
            out.append(record(howto(i, mode, name), name, "games/ludo/howto", "ludo", [mode], ["how_to_play"], "howto"))
    return out
