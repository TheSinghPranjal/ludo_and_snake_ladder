"""Shared assets: brand, hub cards, tokens, dice, player cards, avatars, UI kit, icons, FX."""
import math

from kit import (COLORS, PLAYER, SHELL, Doc, desat, f, mix, outline, shade, star_pts, symbol, tint)
from registry import MODES, record

GAME_SCREENS = ["snakes_game", "ludo_game"]


# ---------------------------------------------------------------- tokens
def token_doc(color, state, mode, pid, size=64):
    d = Doc(size, size, pid)
    k = size / 64
    base = PLAYER[color]
    rim = "#FFFFFF" if mode == "dark" else None
    cx, cy, r = 32 * k, 30 * k, 21 * k
    lift = 0
    if state == "hop":
        lift = 6 * k
    if state != "ghost":
        if state == "hop":
            d.shadow(cx, 52 * k, 14 * k, 4.5 * k, .22)
        elif state == "selected":
            d.shadow(cx + 1 * k, 53 * k, 21 * k, 6 * k, .34)
        else:
            d.shadow(cx + 1 * k, 50 * k, 20 * k, 6 * k, .3)
    if state == "active":
        g = d.radial([(0, "#FFE58A", .0), (.62, "#FFE58A", .0), (.75, "#FFC93C", .75), (1, "#FFC93C", 0)])
        d.add(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(31 * k)}" fill="{g}"/>')
        d.add(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(25.5 * k)}" fill="none" stroke="#FFC93C" stroke-width="{f(3 * k)}"/>')
    if state == "movable":
        d.add(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(27 * k)}" fill="none" stroke="{tint(base, .35)}" stroke-width="{f(3 * k)}"/>',
              f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(30.5 * k)}" fill="none" stroke="{tint(base, .35)}" stroke-opacity=".45" stroke-width="{f(2 * k)}"/>')
    if state == "selected":
        d.add(f'<circle cx="{f(cx)}" cy="{f(cy - 2 * k)}" r="{f(26 * k)}" fill="none" stroke="#FFFFFF" stroke-width="{f(4 * k)}"/>',
              f'<circle cx="{f(cx)}" cy="{f(cy - 2 * k)}" r="{f(28.5 * k)}" fill="none" stroke="{outline(base)}" stroke-width="{f(1.6 * k)}"/>')
        cy -= 2 * k
    cy -= lift
    rr = r * (1.06 if state == "hop" else 1)
    if state == "ghost":
        d.add(f'<g opacity=".5">')
        d.add(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(rr)}" fill="{tint(base, .45)}" stroke="{outline(base)}" '
              f'stroke-width="{f(2.4 * k)}" stroke-dasharray="{f(5 * k)} {f(4 * k)}"/>')
        symbol(d, color, cx, cy, 9 * k, fill="#FFFFFF")
        d.add("</g>")
        return d
    d.ball(cx, cy, rr, base, rim=rim, sw=2.6 * k)
    d.ball(cx, cy, rr * .62, tint(base, .12), sw=1.6 * k, hl=False, shade_k=.1)
    symbol(d, color, cx, cy + .5 * k, 8.5 * k)
    d.add(f'<ellipse cx="{f(cx - rr * .42)}" cy="{f(cy - rr * .5)}" rx="{f(rr * .24)}" ry="{f(rr * .12)}" '
          f'transform="rotate(-35 {f(cx - rr * .42)} {f(cy - rr * .5)})" fill="#FFFFFF" fill-opacity=".7"/>')
    return d


def tokens():
    out = []
    for color in COLORS:
        for state in ("idle", "active", "movable", "selected", "hop", "ghost"):
            for mode in MODES:
                name = f"token_{color}_{state}_{mode}"
                out.append(record(token_doc(color, state, mode, name), name, "shared/tokens", "shared", [mode],
                                  GAME_SCREENS, "tokens", anchor=(0.5, 0.47)))
    d = Doc(64, 64, "token_shadow")
    d.shadow(32, 50, 21, 6.5, .34)
    out.append(record(d, "token_shadow", "shared/tokens", "shared", "tinted", GAME_SCREENS, "tokens", anchor=(0.5, 0.78)))
    for n in (2, 3, 4):
        for mode in MODES:
            name = f"stack_badge_{n}_{mode}"
            d = Doc(28, 28, name)
            fill = "#2A2A35" if mode == "light" else "#F2F3F7"
            fg = "#FFFFFF" if mode == "light" else "#1D2030"
            d.add(f'<circle cx="14" cy="14" r="12" fill="{fill}" stroke="{fg}" stroke-width="2"/>')
            d.text(14, 19.5, str(n), 15, fg)
            out.append(record(d, name, "shared/tokens", "shared", [mode], ["ludo_game"], "tokens"))
    return out


# ---------------------------------------------------------------- dice
PIPS = {1: [(1, 1)], 2: [(0, 0), (2, 2)], 3: [(0, 0), (1, 1), (2, 2)], 4: [(0, 0), (2, 0), (0, 2), (2, 2)],
        5: [(0, 0), (2, 0), (1, 1), (0, 2), (2, 2)], 6: [(0, 0), (2, 0), (0, 1), (2, 1), (0, 2), (2, 2)]}
DIE = "#FFFDF7"
PIP = "#2A2A35"


def die_face(d, x, y, s, face, mode):
    d.slab(x, y, s, s, s * .22, DIE, sw=s * .05, band=s * .1, stroke="#6B6476")
    if mode == "dark":
        d.add(f'<rect x="{f(x - s * .03)}" y="{f(y - s * .03)}" width="{f(s * 1.06)}" height="{f(s * 1.06)}" rx="{f(s * .25)}" '
              f'fill="none" stroke="#FFFFFF" stroke-opacity=".7" stroke-width="{f(s * .025)}"/>')
    for i, j in PIPS[face]:
        px, py = x + s * (.26 + .24 * i), y + s * (.24 + .24 * j)
        pr = s * (.1 if face != 1 else .13)
        d.add(f'<circle cx="{f(px)}" cy="{f(py)}" r="{f(pr)}" fill="{PIP}"/>',
              f'<circle cx="{f(px - pr * .3)}" cy="{f(py - pr * .3)}" r="{f(pr * .3)}" fill="#FFFFFF" fill-opacity=".35"/>')


def _rot(v, a, b, c):
    x, y, z = v
    y, z = y * math.cos(a) - z * math.sin(a), y * math.sin(a) + z * math.cos(a)
    x, z = x * math.cos(b) + z * math.sin(b), -x * math.sin(b) + z * math.cos(b)
    x, y = x * math.cos(c) - y * math.sin(c), x * math.sin(c) + y * math.cos(c)
    return x, y, z


# faces: normal, u axis, v axis, value (opposite faces sum to 7)
CUBE = [((0, 0, 1), (1, 0, 0), (0, 1, 0), 1), ((0, 0, -1), (-1, 0, 0), (0, 1, 0), 6),
        ((1, 0, 0), (0, 0, -1), (0, 1, 0), 3), ((-1, 0, 0), (0, 0, 1), (0, 1, 0), 4),
        ((0, -1, 0), (1, 0, 0), (0, 0, 1), 2), ((0, 1, 0), (1, 0, 0), (0, 0, -1), 5)]


def die_tumble(d, cx, cy, s, a, b, c, mode):
    light = (-.45, -.6, .66)
    faces = []
    for n, u, v, val in CUBE:
        rn = _rot(n, a, b, c)
        if rn[2] <= 0.02:
            continue
        ru, rv = _rot(u, a, b, c), _rot(v, a, b, c)
        o = [n[i] - u[i] - v[i] for i in range(3)]
        ro = _rot(o, a, b, c)
        p0 = (cx + ro[0] * s, cy + ro[1] * s)
        e1 = (ru[0] * 2 * s, ru[1] * 2 * s)
        e2 = (rv[0] * 2 * s, rv[1] * 2 * s)
        bright = max(0, sum(rn[i] * light[i] for i in range(3)))
        faces.append((rn[2], p0, e1, e2, val, bright))
    for _, p0, e1, e2, val, br in sorted(faces):
        col = mix("#E6DECF", DIE, min(1, .35 + br))
        pts = [p0, (p0[0] + e1[0], p0[1] + e1[1]), (p0[0] + e1[0] + e2[0], p0[1] + e1[1] + e2[1]), (p0[0] + e2[0], p0[1] + e2[1])]
        d.add(f'<polygon points="{" ".join(f"{f(x)},{f(y)}" for x, y in pts)}" fill="{col}" stroke="#6B6476" '
              f'stroke-width="{f(s * .09)}" stroke-linejoin="round"/>')
        m = f"matrix({f(e1[0])} {f(e1[1])} {f(e2[0])} {f(e2[1])} {f(p0[0])} {f(p0[1])})"
        pip = "".join(f'<circle cx="{.25 + .25 * i}" cy="{.25 + .25 * j}" r="{.1 if val != 1 else .13}" fill="{PIP}"/>' for i, j in PIPS[val])
        d.add(f'<g transform="{m}">{pip}</g>')
    if mode == "dark":
        d.add(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(s * 1.75)}" fill="none" stroke="#FFFFFF" stroke-opacity=".18" stroke-width="{f(s * .06)}"/>')


def dice():
    out = []
    for mode in MODES:
        for n in range(1, 7):
            name = f"dice_face_{n}_{mode}"
            d = Doc(96, 96, name)
            d.shadow(50, 86, 38, 8, .3)
            die_face(d, 8, 6, 80, n, mode)
            out.append(record(d, name, "shared/dice", "shared", [mode], GAME_SCREENS, "dice"))
        for i in range(8):
            name = f"dice_roll_{i + 1:02d}_{mode}"
            d = Doc(96, 96, name)
            t = i / 8
            d.shadow(48, 88, 30 - 6 * math.sin(t * math.pi * 2), 6, .22)
            die_tumble(d, 48, 44 - 6 * abs(math.sin(t * math.pi)), 22, .6 + t * 2 * math.pi, .4 + t * 3.1, .2 + t * 1.3, mode)
            for k in range(2):
                ang = math.radians(200 + 40 * k + i * 20)
                x1, y1 = 48 + 40 * math.cos(ang), 44 + 40 * math.sin(ang)
                d.add(f'<path d="M{f(x1)} {f(y1)} A40 40 0 0 1 {f(48 + 40 * math.cos(ang + .5))} {f(44 + 40 * math.sin(ang + .5))}" '
                      f'fill="none" stroke="{"#5E6272" if mode == "light" else "#A9AEC2"}" stroke-opacity=".5" stroke-width="3" stroke-linecap="round"/>')
            out.append(record(d, name, "shared/dice", "shared", [mode], GAME_SCREENS, "dice", note="800 ms tumble, 8 frames"))
        for st in ("normal", "pressed"):
            name = f"dice_button_{st}_{mode}"
            pal = SHELL[mode]
            d = Doc(136, 136, name)
            dy = 4 if st == "pressed" else 0
            d.shadow(68, 122, 56, 10, .25 if st == "normal" else .15)
            d.slab(12, 10 + dy, 112, 108 - dy, 34, pal["accent"], band=14 - dy * 2.5)
            d.add(f'<rect x="28" y="{f(24 + dy)}" width="80" height="{f(76 - dy)}" rx="22" fill="{shade(pal["accent"], .1)}" fill-opacity=".45"/>')
            out.append(record(d, name, "shared/dice", "shared", [mode], ["snakes_game"], "dice"))
        for color in COLORS:
            name = f"dice_tray_{color}_{mode}"
            d = Doc(80, 80, name)
            pal = SHELL[mode]
            d.slab(4, 4, 72, 72, 20, PLAYER[color] if mode == "light" else desat(PLAYER[color]), band=8)
            d.add(f'<rect x="12" y="11" width="56" height="54" rx="14" fill="{pal["surface"]}" fill-opacity=".9"/>')
            out.append(record(d, name, "shared/dice", "shared", [mode], ["ludo_game"], "dice"))
    d = Doc(96, 32, "dice_shadow")
    d.shadow(48, 16, 44, 12, .34)
    out.append(record(d, "dice_shadow", "shared/dice", "shared", "tinted", GAME_SCREENS, "dice"))
    return out


# ---------------------------------------------------------------- player cards, ring, medals
def cards():
    out = []
    for mode in MODES:
        pal = SHELL[mode]
        for color in COLORS:
            c = PLAYER[color] if mode == "light" else desat(PLAYER[color])
            for st in ("inactive", "active", "disconnected", "finished"):
                name = f"card_{color}_{st}_{mode}"
                d = Doc(132, 96, name)
                if st == "active":
                    d.add(f'<rect x="3" y="3" width="126" height="90" rx="22" fill="none" stroke="{c}" stroke-opacity=".35" stroke-width="6" filter="{d.blur(2.5)}"/>')
                fill = {"inactive": pal["surface"], "active": mix(pal["surface"], c, .14 if mode == "light" else .22),
                        "disconnected": mix(pal["surface2"], "#8A8FA0", .25), "finished": mix(pal["surface"], pal["accent"], .12)}[st]
                border = {"inactive": mix(pal["surface"], c, .45), "active": c, "disconnected": "#8A8FA0", "finished": pal["accent"]}[st]
                sw = 4 if st == "active" else 2.5
                d.shadow(66, 88, 58, 6, .14 if mode == "light" else .3)
                dash = ' stroke-dasharray="7 5"' if st == "disconnected" else ""
                d.add(f'<rect x="6" y="6" width="120" height="84" rx="18" fill="{fill}"/>')
                d.add(f'<path d="M6 30 V24 a18 18 0 0 1 18 -18 H36 a30 30 0 0 1 -30 24 Z" fill="{c if st != "disconnected" else "#8A8FA0"}"/>')
                d.add(f'<rect x="{f(6 + sw / 2)}" y="{f(6 + sw / 2)}" width="{f(120 - sw)}" height="{f(84 - sw)}" rx="{f(18 - sw / 2)}" fill="none" stroke="{border}" stroke-width="{f(sw)}"{dash}/>')
                out.append(record(d, name, "shared/cards", "shared", [mode], GAME_SCREENS, "cards", nine=(30, 30, 30, 30),
                                  note="All four states are 132 × 96 with the same insets"))
        for kind, col, op in (("track", pal["text2"], .28), ("fill", pal["primary"], 1), ("warn", pal["danger"], 1)):
            name = f"timer_ring_{kind}_{mode}"
            d = Doc(64, 64, name)
            d.add(f'<circle cx="32" cy="32" r="28" fill="none" stroke="{col}" stroke-opacity="{op}" stroke-width="5" stroke-linecap="round"/>')
            out.append(record(d, name, "shared/cards", "shared", [mode], GAME_SCREENS, "cards",
                              note="Code sweeps fill/warn with a clip; warn in the last 5 s"))
    medal = {1: "#F5B700", 2: "#B8C2CC", 3: "#C9803C", 4: "#7FA3C9"}
    for n, col in medal.items():
        name = f"rank_{n}"
        d = Doc(64, 80, name)
        d.add(f'<path d="M18 2 L32 30 L46 2 Z" fill="#3E8EDE" stroke="{outline("#3E8EDE")}" stroke-width="2" stroke-linejoin="round"/>',
              f'<path d="M24 2 L32 18 L40 2 Z" fill="#D9342B"/>')
        d.shadow(33, 74, 20, 4, .22)
        d.ball(32, 48, 24, col, sw=3)
        d.add(f'<circle cx="32" cy="48" r="15" fill="none" stroke="{shade(col, .25)}" stroke-width="2"/>')
        d.text(32, 57, str(n), 26, outline(col))
        out.append(record(d, name, "shared/cards", "shared", "any", ["results"], "cards"))
    d = Doc(64, 48, "crown")
    gold = "#F5B700"
    d.shadow(32, 44, 26, 4, .2)
    d.add(f'<path d="M8 38 L5 12 L20 24 L32 6 L44 24 L59 12 L56 38 Z" fill="{gold}" stroke="{outline(gold)}" stroke-width="3" stroke-linejoin="round"/>',
          f'<path d="M8 38 L56 38 L55 31 L9 31 Z" fill="{shade(gold, .18)}"/>',
          f'<circle cx="32" cy="27" r="4.5" fill="#D9342B" stroke="{outline("#D9342B")}" stroke-width="1.5"/>',
          f'<circle cx="18" cy="31" r="3" fill="#3E8EDE"/><circle cx="46" cy="31" r="3" fill="#3D9142"/>',
          f'<path d="M16 16 L22 22" stroke="#FFFFFF" stroke-opacity=".6" stroke-width="3" stroke-linecap="round"/>')
    out.append(record(d, "crown", "shared/cards", "shared", "any", ["results", "ludo_game"], "cards"))
    d = Doc(32, 32, "wifi_off_badge")
    d.ball(16, 16, 14, "#D64545", sw=2, hl=False)
    d.add('<path d="M8.5 13a10.5 10.5 0 0 1 15 0M11.5 16.5a6 6 0 0 1 9 0M16 21h.01M8 8l16 16" fill="none" stroke="#FFFFFF" stroke-width="2.4" stroke-linecap="round"/>')
    out.append(record(d, "wifi_off_badge", "shared/cards", "shared", "any", GAME_SCREENS + ["lobby"], "cards"))
    return out


# ---------------------------------------------------------------- avatars
def eyes(d, cx, cy, dx, r, look=(0, 0), lid=None):
    for s in (-1, 1):
        x = cx + s * dx
        d.add(f'<ellipse cx="{f(x)}" cy="{f(cy)}" rx="{f(r)}" ry="{f(r * 1.12)}" fill="#FFFFFF" stroke="#2A2A35" stroke-width="{f(r * .18)}"/>',
              f'<circle cx="{f(x + look[0] * r * .3)}" cy="{f(cy + look[1] * r * .3)}" r="{f(r * .55)}" fill="#2A2A35"/>',
              f'<circle cx="{f(x + look[0] * r * .3 - r * .2)}" cy="{f(cy + look[1] * r * .3 - r * .22)}" r="{f(r * .18)}" fill="#FFFFFF"/>')
        if lid:
            d.add(f'<path d="M{f(x - r * 1.05)} {f(cy - r * .05)} A{f(r)} {f(r * 1.1)} 0 0 1 {f(x + r * 1.05)} {f(cy - r * .05)} Z" fill="{lid}" stroke="{outline(lid)}" stroke-width="{f(r * .15)}"/>')


def smile(d, cx, cy, w, col="#2A2A35", sw=6):
    d.add(f'<path d="M{f(cx - w)} {f(cy)} Q{f(cx)} {f(cy + w * .8)} {f(cx + w)} {f(cy)}" fill="none" stroke="{col}" stroke-width="{sw}" stroke-linecap="round"/>')


def cheeks(d, cx, cy, dx, r=12, col="#FF8FA3"):
    for s in (-1, 1):
        d.add(f'<ellipse cx="{f(cx + s * dx)}" cy="{f(cy)}" rx="{f(r)}" ry="{f(r * .65)}" fill="{col}" fill-opacity=".55"/>')


def blob(d, shape, fill, sw=7):
    d.add(f'{shape[:-2]} fill="{fill}" stroke="{outline(fill)}" stroke-width="{sw}" stroke-linejoin="round"/>')


AVATARS = ["fox", "owl", "cat", "frog", "panda", "bear", "penguin", "bunny", "robot", "octopus", "dino", "chick"]
AV_BG = ["#FFE1B8", "#D7E8FF", "#E6E0FF", "#D9F5D4", "#FFE0E6", "#FFE9C7", "#D3F1F7", "#FFE3F1", "#DDF3EE", "#EADBFF", "#E2F6D7", "#FFF2B8"]


def avatar_doc(i, name):
    d = Doc(256, 256, name)
    bg = AV_BG[i]
    d.add(f'<circle cx="128" cy="128" r="124" fill="{bg}" stroke="{shade(bg, .3)}" stroke-width="6"/>')
    d.add(f'<circle cx="128" cy="128" r="104" fill="{tint(bg, .35)}"/>')
    kind = AVATARS[i]
    cx, cy = 128, 140
    if kind == "fox":
        o = "#F28C38"
        for s in (-1, 1):
            blob(d, f'<path d="M{cx + s * 30} 96 L{cx + s * 70} 44 L{cx + s * 78} 110 Z"/>', o)
        blob(d, f'<path d="M{cx - 82} 130 Q{cx - 70} 70 {cx} 74 Q{cx + 70} 70 {cx + 82} 130 Q{cx + 40} 196 {cx} 204 Q{cx - 40} 196 {cx - 82} 130 Z"/>', o)
        d.add(f'<path d="M{cx - 70} 142 Q{cx - 30} 150 {cx} 204 Q{cx + 30} 150 {cx + 70} 142 Q{cx + 40} 200 {cx} 206 Q{cx - 40} 200 {cx - 70} 142 Z" fill="#FFF4E6"/>')
        eyes(d, cx, 126, 30, 13, (0, .2)); d.add(f'<ellipse cx="{cx}" cy="172" rx="11" ry="8" fill="#2A2A35"/>'); cheeks(d, cx, 158, 50)
    elif kind == "owl":
        o = "#9C6B43"
        blob(d, f'<path d="M{cx - 78} 196 Q{cx - 92} 90 {cx - 60} 66 L{cx - 40} 84 Q{cx} 66 {cx + 40} 84 L{cx + 60} 66 Q{cx + 92} 90 {cx + 78} 196 Z"/>', o)
        for s in (-1, 1):
            d.add(f'<circle cx="{cx + s * 32}" cy="128" r="30" fill="#F4E3C8" stroke="{outline("#F4E3C8")}" stroke-width="4"/>')
        eyes(d, cx, 128, 32, 16)
        d.add(f'<path d="M{cx - 9} 152 L{cx + 9} 152 L{cx} 170 Z" fill="#F5A623" stroke="{outline("#F5A623")}" stroke-width="3" stroke-linejoin="round"/>')
        d.add(f'<path d="M{cx - 40} 190 q10 -10 20 0 q10 -10 20 0 q10 -10 20 0 q10 -10 20 0" fill="none" stroke="{shade(o, .3)}" stroke-width="4" stroke-linecap="round"/>')
    elif kind == "cat":
        o = "#9AA3B5"
        for s in (-1, 1):
            blob(d, f'<path d="M{cx + s * 24} 92 L{cx + s * 64} 50 L{cx + s * 76} 112 Z"/>', o)
        blob(d, f'<ellipse cx="{cx}" cy="{cy}" rx="84" ry="70"/>', o)
        d.add(f'<path d="M{cx - 14} 78 l6 18 M{cx} 74 v20 M{cx + 14} 78 l-6 18" stroke="{shade(o, .3)}" stroke-width="5" stroke-linecap="round"/>')
        eyes(d, cx, 134, 32, 13, (.3, .1))
        d.add(f'<path d="M{cx - 8} 162 L{cx + 8} 162 L{cx} 170 Z" fill="#FF8FA3"/>'); smile(d, cx - 10, 174, 10, sw=4); smile(d, cx + 10, 174, 10, sw=4)
        for s in (-1, 1):
            d.add(f'<path d="M{cx + s * 50} 166 l{s * 36} -6 M{cx + s * 50} 176 l{s * 36} 4" stroke="#5E6272" stroke-width="3" stroke-linecap="round"/>')
        cheeks(d, cx, 160, 56)
    elif kind == "frog":
        o = "#6CC24A"
        for s in (-1, 1):
            blob(d, f'<circle cx="{cx + s * 42}" cy="92" r="30"/>', o)
        blob(d, f'<ellipse cx="{cx}" cy="{cy + 4}" rx="90" ry="62"/>', o)
        eyes(d, cx, 92, 42, 17, (0, .25))
        smile(d, cx, 158, 46, sw=6); cheeks(d, cx, 150, 62, 14)
    elif kind == "panda":
        o = "#FFFFFF"
        for s in (-1, 1):
            blob(d, f'<circle cx="{cx + s * 60}" cy="76" r="24"/>', "#3A3A48")
        blob(d, f'<ellipse cx="{cx}" cy="{cy}" rx="86" ry="74"/>', o, 6)
        for s in (-1, 1):
            d.add(f'<ellipse cx="{cx + s * 32}" cy="132" rx="22" ry="27" transform="rotate({s * -25} {cx + s * 32} 132)" fill="#3A3A48"/>')
        eyes(d, cx, 132, 32, 10)
        d.add(f'<ellipse cx="{cx}" cy="166" rx="12" ry="8" fill="#2A2A35"/>'); smile(d, cx, 178, 12, sw=4); cheeks(d, cx, 166, 54)
    elif kind == "bear":
        o = "#B9824F"
        for s in (-1, 1):
            blob(d, f'<circle cx="{cx + s * 62}" cy="78" r="26"/>', o)
            d.add(f'<circle cx="{cx + s * 62}" cy="78" r="12" fill="{tint(o, .4)}"/>')
        blob(d, f'<ellipse cx="{cx}" cy="{cy}" rx="86" ry="74"/>', o)
        d.add(f'<ellipse cx="{cx}" cy="168" rx="38" ry="28" fill="{tint(o, .55)}"/>')
        eyes(d, cx, 128, 34, 12, (0, .2))
        d.add(f'<ellipse cx="{cx}" cy="158" rx="13" ry="9" fill="#2A2A35"/>'); smile(d, cx, 174, 12, sw=4); cheeks(d, cx, 150, 58)
    elif kind == "penguin":
        o = "#3A4A66"
        blob(d, f'<ellipse cx="{cx}" cy="{cy}" rx="84" ry="80"/>', o)
        d.add(f'<path d="M{cx} 92 Q{cx - 20} 72 {cx - 50} 92 Q{cx - 74} 140 {cx - 40} 196 Q{cx} 214 {cx + 40} 196 Q{cx + 74} 140 {cx + 50} 92 Q{cx + 20} 72 {cx} 92 Z" fill="#FFFFFF"/>')
        eyes(d, cx, 128, 26, 12)
        d.add(f'<path d="M{cx - 14} 150 Q{cx} 140 {cx + 14} 150 Q{cx} 168 {cx - 14} 150 Z" fill="#F5A623" stroke="{outline("#F5A623")}" stroke-width="3"/>'); cheeks(d, cx, 158, 46)
    elif kind == "bunny":
        o = "#FFFFFF"
        for s in (-1, 1):
            blob(d, f'<ellipse cx="{cx + s * 32}" cy="62" rx="20" ry="50" transform="rotate({s * 10} {cx + s * 32} 62)"/>', o, 6)
            d.add(f'<ellipse cx="{cx + s * 32}" cy="66" rx="9" ry="34" transform="rotate({s * 10} {cx + s * 32} 66)" fill="#FFC2D6"/>')
        blob(d, f'<ellipse cx="{cx}" cy="{cy + 6}" rx="80" ry="68"/>', o, 6)
        eyes(d, cx, 140, 30, 12, (0, .2))
        d.add(f'<path d="M{cx - 9} 164 L{cx + 9} 164 L{cx} 173 Z" fill="#FF8FA3"/>'); smile(d, cx, 180, 10, sw=4); cheeks(d, cx, 166, 52, 14)
    elif kind == "robot":
        o = "#5BC0B5"
        d.add(f'<path d="M{cx} 70 V46" stroke="{outline(o)}" stroke-width="6"/><circle cx="{cx}" cy="40" r="10" fill="#FFC93C" stroke="{outline("#FFC93C")}" stroke-width="4"/>')
        d.slab(cx - 82, 70, 164, 136, 40, o, sw=7)
        d.add(f'<rect x="{cx - 62}" y="96" width="124" height="66" rx="26" fill="#2A3A4A"/>')
        for s in (-1, 1):
            d.add(f'<circle cx="{cx + s * 30}" cy="128" r="14" fill="#7DF0FF"/><circle cx="{cx + s * 30 - 4}" cy="124" r="4" fill="#FFFFFF"/>')
        d.add(f'<rect x="{cx - 28}" y="176" width="56" height="12" rx="6" fill="{shade(o, .35)}"/>')
    elif kind == "octopus":
        o = "#B07DE8"
        for k in range(5):
            x = cx - 64 + k * 32
            blob(d, f'<path d="M{x - 14} 168 Q{x - 18} 210 {x} 214 Q{x + 18} 210 {x + 14} 168 Z"/>', o, 5)
        blob(d, f'<path d="M{cx - 82} 170 Q{cx - 92} 60 {cx} 58 Q{cx + 92} 60 {cx + 82} 170 Z"/>', o)
        for p in ((-40, 90), (30, 80), (52, 120)):
            d.add(f'<circle cx="{cx + p[0]}" cy="{p[1]}" r="7" fill="{tint(o, .4)}"/>')
        eyes(d, cx, 128, 30, 15, (0, .2)); smile(d, cx, 158, 18, sw=5); cheeks(d, cx, 150, 56)
    elif kind == "dino":
        o = "#4FB38A"
        for k in range(4):
            d.add(f'<path d="M{cx - 54 + k * 34} 74 l14 -26 l14 26 Z" fill="#F5A623" stroke="{outline("#F5A623")}" stroke-width="4" stroke-linejoin="round"/>')
        blob(d, f'<path d="M{cx - 80} 160 Q{cx - 90} 74 {cx} 72 Q{cx + 84} 72 {cx + 92} 140 Q{cx + 96} 200 {cx} 202 Q{cx - 74} 202 {cx - 80} 160 Z"/>', o)
        eyes(d, cx - 10, 124, 30, 14, (.3, 0))
        smile(d, cx + 10, 166, 40, sw=6)
        d.add(f'<circle cx="{cx + 58}" cy="140" r="4" fill="{shade(o, .4)}"/><circle cx="{cx + 70}" cy="138" r="4" fill="{shade(o, .4)}"/>')
    else:  # chick
        o = "#FFD34D"
        d.add(f'<path d="M{cx - 8} 64 q8 -26 16 0 q10 -18 14 4" fill="{o}" stroke="{outline(o)}" stroke-width="4" stroke-linejoin="round"/>')
        blob(d, f'<circle cx="{cx}" cy="{cy}" r="82"/>', o)
        eyes(d, cx, 126, 30, 13)
        d.add(f'<path d="M{cx - 16} 152 L{cx + 16} 152 L{cx} 172 Z" fill="#F5852A" stroke="{outline("#F5852A")}" stroke-width="3" stroke-linejoin="round"/>')
        cheeks(d, cx, 158, 52, 14)
    return d


def avatars():
    out = []
    for i, kind in enumerate(AVATARS):
        name = f"avatar_{i + 1:02d}_{kind}"
        out.append(record(avatar_doc(i, name), name, "shared/avatars", "shared", "any",
                          ["hub", "profile", "lobby"] + GAME_SCREENS + ["results"], "avatars"))
    return out


# ---------------------------------------------------------------- UI kit
def button_doc(kind, st, mode, name):
    pal = SHELL[mode]
    if kind == "icon":
        d = Doc(56, 60, name)
        dy = 3 if st == "pressed" else 0
        fill = pal["surface"] if st != "disabled" else mix(pal["surface"], pal["text2"], .15)
        d.shadow(28, 54, 24, 5, .18 if st == "normal" else .08)
        d.add(f'<circle cx="28" cy="{f(30 + dy)}" r="26" fill="{shade(fill, .12)}"/>',
              f'<circle cx="28" cy="{f(28 + dy)}" r="25" fill="{fill}"/>',
              f'<circle cx="28" cy="{f(29 + dy)}" r="25" fill="none" stroke="{mix(fill, pal["text"], .25)}" stroke-width="2"/>')
        return d
    d = Doc(96, 60, name)
    base = {"primary": pal["primary"], "secondary": pal["surface"], "danger": pal["danger"]}[kind]
    if st == "disabled":
        base = mix(base, "#9CA0AE", .6)
    if st == "pressed":
        base = shade(base, .08)
    dy = 3 if st == "pressed" else 0
    d.shadow(48, 55, 44, 5, .2 if st == "normal" else .1)
    d.slab(2, 2 + dy, 92, 54 - dy, 18, base, band=7 - dy * 1.6, hl=st != "disabled",
           stroke=mix(base, pal["text"], .35) if kind == "secondary" else None)
    return d


def ui_kit():
    out = []
    for mode in MODES:
        pal = SHELL[mode]
        for kind in ("primary", "secondary", "danger", "icon"):
            for st in ("normal", "pressed", "disabled"):
                name = f"btn_{kind}_{st}_{mode}"
                d = button_doc(kind, st, mode, name)
                out.append(record(d, name, "shared/ui", "shared", [mode], ["all"], "ui",
                                  nine=None if kind == "icon" else (24, 22, 24, 24)))
        name = f"panel_{mode}"
        d = Doc(96, 96, name)
        d.shadow(48, 88, 44, 7, .15)
        d.add(f'<rect x="4" y="4" width="88" height="84" rx="24" fill="{pal["surface"]}" stroke="{mix(pal["surface"], pal["text"], .12)}" stroke-width="2"/>')
        out.append(record(d, name, "shared/ui", "shared", [mode], ["all"], "ui", nine=(30, 30, 30, 30)))
        name = f"dialog_{mode}"
        d = Doc(128, 128, name)
        d.add(f'<rect x="10" y="14" width="108" height="104" rx="30" fill="#000000" fill-opacity=".22" filter="{d.blur(6)}"/>')
        d.add(f'<rect x="10" y="8" width="108" height="104" rx="30" fill="{pal["surface"]}"/>')
        out.append(record(d, name, "shared/ui", "shared", [mode], ["dialogs", "pause"], "ui", nine=(42, 40, 42, 44)))
        name = f"bottom_sheet_{mode}"
        d = Doc(128, 96, name)
        d.add(f'<path d="M4 96 V30 a28 28 0 0 1 28 -28 H96 a28 28 0 0 1 28 28 V96 Z" fill="{pal["surface"]}" stroke="{mix(pal["surface"], pal["text"], .12)}" stroke-width="2"/>',
              f'<rect x="48" y="12" width="32" height="5" rx="2.5" fill="{pal["text2"]}" fill-opacity=".5"/>')
        out.append(record(d, name, "shared/ui", "shared", [mode], ["pause"], "ui", nine=(40, 40, 40, 8)))
        name = f"toast_{mode}"
        d = Doc(96, 52, name)
        tf = "#2A2A35" if mode == "light" else "#F2F3F7"
        d.shadow(48, 46, 42, 5, .2)
        d.add(f'<rect x="4" y="4" width="88" height="40" rx="20" fill="{tf}"/>')
        out.append(record(d, name, "shared/ui", "shared", [mode], GAME_SCREENS, "ui", nine=(22, 20, 22, 26)))
        name = f"ribbon_turn_{mode}"
        d = Doc(256, 84, name)
        acc = pal["accent"]
        for s in (-1, 1):
            x = 0 if s < 0 else 256
            d.add(f'<path d="M{x} 22 L{x - s * 46} 22 L{x - s * 46} 74 L{x} 74 L{x - s * 14} 48 Z" fill="{shade(acc, .2)}" stroke="{outline(acc)}" stroke-width="3" stroke-linejoin="round"/>',
                  f'<path d="M{x - s * 34} 62 L{x - s * 46} 74 L{x - s * 46} 62 Z" fill="{shade(acc, .45)}"/>')
        d.slab(34, 6, 188, 56, 12, acc, band=8)
        out.append(record(d, name, "shared/ui", "shared", [mode], GAME_SCREENS, "ui", nine=(64, 0, 64, 0), note="Turn banner; stretch the middle"))
        badges = [("extra_roll", "Extra roll!", pal["accent"], "#2A2A35"), ("ladder", "Ladder!", "#3D8BE0", "#FFFFFF"),
                  ("oops", "Oops!", "#E0563B", "#FFFFFF"), ("captured", "Captured!", "#8E5BD9", "#FFFFFF"),
                  ("winner", "Winner", "#F5B700", "#2A2A35")]
        for key, label, col, fg in badges:
            name = f"badge_{key}_{mode}"
            w = len(label) * 15 + 48
            d = Doc(w, 56, name)
            col = col if mode == "light" else desat(col, .12)
            d.shadow(w / 2, 50, w / 2 - 6, 5, .22)
            d.slab(4, 4, w - 8, 44, 22, col, band=6)
            d.text(w / 2, 34, label, 24, fg, stroke=outline(col) if fg == "#FFFFFF" else None, sw=3)
            out.append(record(d, name, "shared/ui", "shared", [mode], GAME_SCREENS, "ui"))
        name = f"chip_continue_{mode}"
        d = Doc(176, 40, name)
        d.slab(2, 2, 172, 34, 17, pal["accent"], band=5)
        d.add(f'<path d="M30 19a8 8 0 1 1-2.3-5.6M30 11v5h-5" fill="none" stroke="#2A2A35" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round" transform="translate(-6 0)"/>')
        d.text(98, 26, "Continue", 18, "#2A2A35")
        out.append(record(d, name, "shared/ui", "shared", [mode], ["hub"], "ui"))
    return out


# ---------------------------------------------------------------- icons
ICONS = {
    "play": "M8 5l11 7-11 7Z", "pause": "M9 5v14M15 5v14",
    "settings": "M12 9a3 3 0 1 0 .01 0M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1Z",
    "home": "M3 11l9-7 9 7M5 9.5V20h5v-6h4v6h5V9.5", "back": "M15 5l-7 7 7 7", "close": "M6 6l12 12M18 6L6 18",
    "check": "M5 12.5l4.5 4.5L19 7", "info": "M12 3a9 9 0 1 0 .01 0M12 11v6M12 7.5h.01",
    "stats": "M5 20V11M12 20V5M19 20v-6", "profile": "M12 4a4 4 0 1 0 .01 0M5 20a7 7 0 0 1 14 0",
    "lock": "M6 11h12v9H6zM8.5 11V8a3.5 3.5 0 0 1 7 0v3", "trophy": "M8 4h8v5a4 4 0 0 1-8 0ZM8 6H5a3 3 0 0 0 3 4M16 6h3a3 3 0 0 1-3 4M12 13v4M8.5 20h7",
    "crown": "M4 18h16M5 15L4 7l4.5 3.5L12 5l3.5 5.5L20 7l-1 8Z", "wifi": "M2.5 9a14 14 0 0 1 19 0M5.5 12.5a9.5 9.5 0 0 1 13 0M8.8 16a5 5 0 0 1 6.4 0M12 19.5h.01",
    "hotspot": "M12 12h.01M8.5 15.5a5 5 0 0 1 0-7M15.5 8.5a5 5 0 0 1 0 7M5.5 18.5a9.5 9.5 0 0 1 0-13M18.5 5.5a9.5 9.5 0 0 1 0 13",
    "qr": "M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4zM14 14h2.5v2.5H14zM17.5 17.5H20V20h-2.5zM17.5 14H20M14 17.5V20",
    "link": "M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1",
    "refresh": "M20 12a8 8 0 1 1-2.3-5.6M20 4v4.5h-4.5", "sound_on": "M4 9.5h3.5L12 5.5v13l-4.5-4H4ZM15.5 9a4 4 0 0 1 0 6M18 6.5a7.5 7.5 0 0 1 0 11",
    "sound_off": "M4 9.5h3.5L12 5.5v13l-4.5-4H4ZM16 9.5l5 5M21 9.5l-5 5", "music_on": "M9 18V6l10-2v12M9 18a2.5 2.5 0 1 1-2.5-2.5A2.5 2.5 0 0 1 9 18ZM19 16a2.5 2.5 0 1 1-2.5-2.5A2.5 2.5 0 0 1 19 16Z",
    "music_off": "M9 18V6l10-2v12M9 18a2.5 2.5 0 1 1-2.5-2.5A2.5 2.5 0 0 1 9 18ZM19 16a2.5 2.5 0 1 1-2.5-2.5A2.5 2.5 0 0 1 19 16ZM3 3l18 18",
    "haptics": "M8.5 4h7v16h-7zM4.5 8.5v7M19.5 8.5v7M2 10.5v3M22 10.5v3",
    "sun": "M12 8a4 4 0 1 0 .01 0M12 2.5v2M12 19.5v2M2.5 12h2M19.5 12h2M5.3 5.3l1.4 1.4M17.3 17.3l1.4 1.4M18.7 5.3l-1.4 1.4M6.7 17.3l-1.4 1.4",
    "moon": "M20 14.5A8 8 0 1 1 9.5 4a6.5 6.5 0 0 0 10.5 10.5Z", "auto": "M12 3.5a8.5 8.5 0 1 0 .01 0M12 3.5v17M12 3.5a8.5 8.5 0 0 1 0 17Z",
    "ai": "M6 8.5h12v10H6zM12 4.5v4M9.5 13h.01M14.5 13h.01M9.5 16h5M3 12v3M21 12v3",
    "human": "M12 4a3.5 3.5 0 1 0 .01 0M5.5 20.5a6.5 6.5 0 0 1 13 0", "snake": "M4 18c3.5 0 3.5-5 7-5s3.5 5 7 5 2.5-4 2.5-6-1.5-4-4-4-3 2-6 2M18.5 8h.01",
    "ladder": "M7.5 3v18M16.5 3v18M7.5 7.5h9M7.5 12h9M7.5 16.5h9", "dice": "M4.5 4.5h15v15h-15zM9 9h.01M15 15h.01M15 9h.01M9 15h.01M12 12h.01",
}


def icons():
    out = []
    for key, path in ICONS.items():
        name = f"icon_{key}"
        d = Doc(24, 24, name)
        fill = ' fill="#FFFFFF"' if key == "play" else ' fill="none"'
        d.add(f'<path d="{path}"{fill} stroke="#FFFFFF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>')
        out.append(record(d, name, "shared/icons", "shared", "tinted", ["all"], "icons",
                          note="White on transparent; tinted at runtime"))
    return out


# ---------------------------------------------------------------- FX
def fx():
    out = []
    shapes = ["rect", "circle", "triangle", "star", "curl", "diamond"]
    for mode in MODES:
        rim = "#FFFFFF" if mode == "dark" else None
        for color in COLORS:
            c = PLAYER[color]
            for sh in shapes:
                name = f"confetti_{sh}_{color}_{mode}"
                d = Doc(24, 24, name)
                st = f'fill="{c}" stroke="{rim or outline(c)}" stroke-width="1.4" stroke-linejoin="round"'
                el = {"rect": f'<rect x="5" y="8" width="14" height="8" rx="2" {st} transform="rotate(-20 12 12)"/>',
                      "circle": f'<circle cx="12" cy="12" r="6" {st}/>',
                      "triangle": f'<polygon points="12,4 20,18 4,18" {st}/>',
                      "star": f'<polygon points="{star_pts(12, 12.5, 8, 3.6)}" {st}/>',
                      "curl": f'<path d="M4 15c3-8 6 4 9-4s5 2 7-1" fill="none" stroke="{c}" stroke-width="3.2" stroke-linecap="round"/>',
                      "diamond": f'<polygon points="12,3 19,12 12,21 5,12" {st}/>'}[sh]
                d.add(el)
                out.append(record(d, name, "shared/fx", "shared", [mode], ["results"], "fx"))
        name = f"sparkle_{mode}"
        d = Doc(48, 48, name)
        g = d.radial([(0, "#FFFFFF", .9), (.4, "#FFE58A", .5), (1, "#FFE58A", 0)])
        d.add(f'<circle cx="24" cy="24" r="22" fill="{g}"/>',
              f'<path d="M24 4 Q26 22 44 24 Q26 26 24 44 Q22 26 4 24 Q22 22 24 4 Z" fill="#FFF6C8" stroke="#F5B700" stroke-width="1.5"/>')
        out.append(record(d, name, "shared/fx", "shared", [mode], GAME_SCREENS, "fx"))
        name = f"star_burst_{mode}"
        d = Doc(128, 128, name)
        for k in range(12):
            a = k * 30
            d.add(f'<path d="M64 64 L{f(64 + 62 * math.cos(math.radians(a - 6)))} {f(64 + 62 * math.sin(math.radians(a - 6)))} '
                  f'L{f(64 + 62 * math.cos(math.radians(a + 6)))} {f(64 + 62 * math.sin(math.radians(a + 6)))} Z" fill="#FFC93C" fill-opacity="{.55 if k % 2 else .3}"/>')
        d.add(f'<polygon points="{star_pts(64, 66, 30, 13)}" fill="#FFD34D" stroke="{outline("#FFD34D")}" stroke-width="3" stroke-linejoin="round"/>')
        out.append(record(d, name, "shared/fx", "shared", [mode], GAME_SCREENS + ["results"], "fx"))
        puff = "#FFFFFF" if mode == "light" else "#C9CEDC"
        pr = "#D7D2C8" if mode == "light" else "#6E7488"
        name = f"dust_puff_{mode}"
        d = Doc(64, 64, name)
        for x, y, r in ((22, 38, 12), (34, 32, 15), (46, 40, 11), (30, 44, 10)):
            d.add(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{puff}" stroke="{pr}" stroke-width="2.5"/>')
        out.append(record(d, name, "shared/fx", "shared", [mode], GAME_SCREENS, "fx", anchor=(0.5, 0.65)))
        for k in range(1, 5):
            name = f"capture_puff_{k}_{mode}"
            d = Doc(96, 96, name)
            spread = 10 + k * 8; op = 1 - (k - 1) * .22; r = 13 - k * 1.6
            for i in range(7):
                a = math.radians(i * 360 / 7 + k * 6)
                d.add(f'<circle cx="{f(48 + spread * math.cos(a))}" cy="{f(48 + spread * math.sin(a))}" r="{f(r)}" fill="{puff}" fill-opacity="{f(op)}" stroke="{pr}" stroke-opacity="{f(op)}" stroke-width="2.5"/>')
            if k <= 2:
                d.add(f'<polygon points="{star_pts(48, 48, 14 - k * 3, 6 - k)}" fill="#FFC93C" fill-opacity="{f(op)}"/>')
            out.append(record(d, name, "shared/fx", "shared", [mode], ["ludo_game", "snakes_game"], "fx", note="4 frames, ~60 ms each"))
    return out


# ---------------------------------------------------------------- brand
def logo_art(d, x, y, s, mode):
    """Dice Party mark: a tilted die, a little snake curling round it and a Ludo token."""
    k = s / 288
    d.shadow(x + 150 * k, y + 250 * k, 110 * k, 18 * k, .25)
    d.add(f'<g transform="translate({f(x + 152 * k)} {f(y + 140 * k)}) rotate(-12)">')
    die_face(d, -84 * k, -84 * k, 168 * k, 5, mode)
    d.add("</g>")
    body = "#8BC34A"
    path = f"M{f(x + 30 * k)} {f(y + 214 * k)} C{f(x + 70 * k)} {f(y + 270 * k)} {f(x + 200 * k)} {f(y + 270 * k)} {f(x + 236 * k)} {f(y + 220 * k)} S{f(x + 262 * k)} {f(y + 130 * k)} {f(x + 236 * k)} {f(y + 92 * k)}"
    d.add(f'<path d="{path}" fill="none" stroke="{outline(body)}" stroke-width="{f(36 * k)}" stroke-linecap="round"/>',
          f'<path d="{path}" fill="none" stroke="{body}" stroke-width="{f(28 * k)}" stroke-linecap="round"/>',
          f'<path d="{path}" fill="none" stroke="#2E7D32" stroke-width="{f(9 * k)}" stroke-linecap="round" stroke-dasharray="{f(1 * k)} {f(30 * k)}"/>')
    hx, hy = x + 236 * k, y + 84 * k
    d.add(f'<ellipse cx="{f(hx)}" cy="{f(hy)}" rx="{f(26 * k)}" ry="{f(22 * k)}" fill="{body}" stroke="{outline(body)}" stroke-width="{f(5 * k)}"/>')
    for s2 in (-1, 1):
        d.add(f'<circle cx="{f(hx + s2 * 10 * k)}" cy="{f(hy - 6 * k)}" r="{f(7 * k)}" fill="#FFFFFF" stroke="{outline(body)}" stroke-width="{f(2 * k)}"/>',
              f'<circle cx="{f(hx + s2 * 10 * k + 1.5 * k)}" cy="{f(hy - 5 * k)}" r="{f(3.6 * k)}" fill="#2A2A35"/>')
    d.add(f'<path d="M{f(hx)} {f(hy + 18 * k)} l0 {f(12 * k)} m0 0 l-{f(5 * k)} {f(6 * k)} m{f(5 * k)} -{f(6 * k)} l{f(5 * k)} {f(6 * k)}" stroke="#E53935" stroke-width="{f(3 * k)}" stroke-linecap="round" fill="none"/>')
    rim = "#FFFFFF" if mode == "dark" else None
    d.ball(x + 58 * k, y + 196 * k, 34 * k, PLAYER["red"], rim=rim, sw=4 * k)
    d.ball(x + 58 * k, y + 196 * k, 21 * k, tint(PLAYER["red"], .12), sw=2.5 * k, hl=False)
    symbol(d, "red", x + 58 * k, y + 197 * k, 13 * k)


def brand():
    out = []
    d = Doc(1024, 1024, "app_icon_1024")
    d.add('<rect width="1024" height="1024" fill="#FFC93C"/>')
    for i in range(16):
        a = math.radians(i * 22.5)
        d.add(f'<path d="M512 512 L{f(512 + 900 * math.cos(a - .09))} {f(512 + 900 * math.sin(a - .09))} L{f(512 + 900 * math.cos(a + .09))} {f(512 + 900 * math.sin(a + .09))} Z" fill="#FFD866" fill-opacity=".7"/>')
    logo_art(d, 152, 152, 720, "light")
    out.append(record(d, "app_icon_1024", "shared/brand", "shared", ["light"], ["launcher"], "brand", note="Opaque master for iOS and flutter_launcher_icons"))
    d = Doc(432, 432, "app_icon_foreground")
    logo_art(d, 72, 72, 288, "light")
    out.append(record(d, "app_icon_foreground", "shared/brand", "shared", ["light"], ["launcher"], "brand",
                      note="Android adaptive foreground; art inside the 288 px safe zone; background #FFC93C"))
    for mode in MODES:
        name = f"splash_logo_{mode}"
        d = Doc(288, 288, name)
        logo_art(d, 0, 0, 288, mode)
        out.append(record(d, name, "shared/brand", "shared", [mode], ["splash"], "brand",
                          note=f"Native splash image on {SHELL[mode]['bg']}"))
        name = f"wordmark_{mode}"
        pal = SHELL[mode]
        d = Doc(560, 168, name)
        col = pal["text"]
        d.text(258, 112, "Dice Party", 104, col, ls=-1)
        d.add(f'<path d="M64 140 C140 160 300 160 420 138" fill="none" stroke="{outline("#8BC34A")}" stroke-width="15" stroke-linecap="round"/>',
              f'<path d="M64 140 C140 160 300 160 420 138" fill="none" stroke="#8BC34A" stroke-width="10" stroke-linecap="round"/>')
        d.add(f'<ellipse cx="428" cy="136" rx="13" ry="10" fill="#8BC34A" stroke="{outline("#8BC34A")}" stroke-width="3"/>',
              '<circle cx="432" cy="132" r="3" fill="#2A2A35"/>')
        d.ball(522, 64, 26, PLAYER["red"], rim="#FFFFFF" if mode == "dark" else None, sw=3.5)
        symbol(d, "red", 522, 65, 10)
        out.append(record(d, name, "shared/brand", "shared", [mode], ["splash", "hub"], "brand"))
    return out


# ---------------------------------------------------------------- hub cards
def hub_card(game, mode, name):
    pal = SHELL[mode]
    d = Doc(340, 180, name)
    cp = d.clip('<rect x="0" y="0" width="340" height="180" rx="24"/>')
    if game == "snakes":
        a, b = ("#FFF59D", "#F9C440") if mode == "light" else ("#1E2A44", "#8A6A1C")
        d.add(f'<g clip-path="{cp}"><rect width="340" height="180" fill="{pal["surface2"]}"/>')
        d.add('<g transform="translate(170 -40) rotate(14)">')
        for r in range(6):
            for c in range(6):
                d.add(f'<rect x="{c * 40}" y="{r * 40}" width="40" height="40" fill="{a if (r + c) % 2 else b}"/>')
        rail = "#3D8BE0" if mode == "light" else "#7FB8FF"
        for x in (54, 82):
            d.add(f'<line x1="{x}" y1="210" x2="{x + 40}" y2="20" stroke="{outline(rail)}" stroke-width="9" stroke-linecap="round"/>',
                  f'<line x1="{x}" y1="210" x2="{x + 40}" y2="20" stroke="{rail}" stroke-width="5" stroke-linecap="round"/>')
        for t in range(1, 8):
            y = 210 - t * 24; x = 54 + (210 - y) * 40 / 190
            d.add(f'<line x1="{f(x)}" y1="{f(y)}" x2="{f(x + 28)}" y2="{f(y)}" stroke="{outline(rail)}" stroke-width="7" stroke-linecap="round"/>',
                  f'<line x1="{f(x)}" y1="{f(y)}" x2="{f(x + 28)}" y2="{f(y)}" stroke="{rail}" stroke-width="3.5" stroke-linecap="round"/>')
        body = "#8BC34A" if mode == "light" else "#9CCC65"
        p = "M150 40 C120 80 210 100 180 140 S110 190 140 230"
        d.add(f'<path d="{p}" fill="none" stroke="{outline(body)}" stroke-width="26" stroke-linecap="round"/>',
              f'<path d="{p}" fill="none" stroke="{body}" stroke-width="19" stroke-linecap="round"/>',
              f'<path d="{p}" fill="none" stroke="#2E7D32" stroke-width="7" stroke-linecap="round" stroke-dasharray="1 22"/>')
        d.add(f'<ellipse cx="150" cy="38" rx="20" ry="17" fill="{body}" stroke="{outline(body)}" stroke-width="4"/>')
        for s in (-1, 1):
            d.add(f'<circle cx="{150 + s * 8}" cy="33" r="6" fill="#FFFFFF" stroke="{outline(body)}" stroke-width="1.5"/><circle cx="{151 + s * 8}" cy="34" r="3" fill="#2A2A35"/>')
        d.add("</g>")
        for i, (x, y, col) in enumerate(((236, 132, "red"), (290, 108, "blue"))):
            tk = token_doc(col, "idle", mode, f"{name}-t{i}", 56)
            d.add(f'<g transform="translate({x - 28} {y - 28})">{tk.inner()}</g>')
        d.add("</g>")
    else:
        d.add(f'<g clip-path="{cp}"><rect width="340" height="180" fill="{pal["surface2"]}"/>')
        d.add('<g transform="translate(150 -22) rotate(-10)">')
        cell = 15
        cols = [("blue", 0, 0), ("yellow", 0, 9), ("red", 9, 0), ("green", 9, 9)]
        base = "#FFFFFF" if mode == "light" else "#232838"
        grid = "#D0D4DC" if mode == "light" else "#343A4F"
        d.add(f'<rect x="0" y="0" width="{cell * 15}" height="{cell * 15}" fill="{base}"/>')
        for r in range(15):
            for c in range(15):
                if (6 <= c <= 8) != (6 <= r <= 8):
                    d.add(f'<rect x="{c * cell}" y="{r * cell}" width="{cell}" height="{cell}" fill="{base}" stroke="{grid}" stroke-width="1.5"/>')
        for col, r0, c0 in cols:
            pc = PLAYER[col] if mode == "light" else desat(PLAYER[col])
            d.add(f'<rect x="{c0 * cell}" y="{r0 * cell}" width="{cell * 6}" height="{cell * 6}" fill="{pc}"/>',
                  f'<rect x="{(c0 + 1) * cell}" y="{(r0 + 1) * cell}" width="{cell * 4}" height="{cell * 4}" rx="10" fill="{base}"/>')
        d.add("</g>")
        for i, (x, y, col) in enumerate(((216, 128, "green"), (262, 140, "yellow"), (300, 96, "red"))):
            tk = token_doc(col, "idle", mode, f"{name}-t{i}", 56)
            d.add(f'<g transform="translate({x - 28} {y - 28})">{tk.inner()}</g>')
        d.add("</g>")
    # Text-safe area: the left part fades to the card colour so titles and chips never sit on the art.
    fade = d.linear([(0, pal["surface2"], 1), (.42, pal["surface2"], .96), (.62, pal["surface2"], 0)], x1=0, y1=0, x2=1, y2=0)
    d.add(f'<rect width="340" height="180" fill="{fade}" clip-path="{cp}"/>')
    d.add(f'<rect x="1.5" y="1.5" width="337" height="177" rx="23" fill="none" stroke="{mix(pal["surface2"], pal["text"], .18)}" stroke-width="3"/>')
    return d


def hub_cards():
    out = []
    for g in ("snakes", "ludo"):
        for mode in MODES:
            name = f"hub_card_{g}_{mode}"
            out.append(record(hub_card(g, mode, name), name, "shared/hub", "shared", [mode], ["hub"], "hub",
                              note="Right-side art; the card text sits on the left third"))
    return out


def all_assets():
    return brand() + hub_cards() + tokens() + dice() + cards() + avatars() + ui_kit() + icons() + fx()
