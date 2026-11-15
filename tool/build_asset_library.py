"""Build design/asset_library.html (brief section 7.7) from the same generators as the exported assets.

    python3 tool/build_asset_library.py [--fragment OUT]

Run tool/export_assets.py and tool/generate_audio.py first (audio is embedded from assets/audio).
"""
import base64
import html
import math
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(HERE, "assets"))

import gen_ludo as L  # noqa: E402
import gen_shared as GS  # noqa: E402
import gen_snakes as G  # noqa: E402
from kit import PLAYER, SHELL, Doc, contrast, desat, f, outline  # noqa: E402

ASSETS = GS.all_assets() + G.all_assets() + L.all_assets()
BY = {a.name: a for a in ASSETS}
esc = html.escape


# ---------------------------------------------------------------- composition helpers
_N = [0]


def uniq(svg):
    """Give every id in a placed copy a fresh suffix. Chrome resolves duplicate ids to the first element,
    which may sit in a hidden (display:none) sprite cell where clip paths and gradients do not render."""
    _N[0] += 1
    k = f"u{_N[0]}"
    svg = re.sub(r'id="([^"]+)"', lambda m: f'id="{m.group(1)}-{k}"', svg)
    return re.sub(r'url\(#([^)]+)\)', lambda m: f'url(#{m.group(1)}-{k})', svg)


def put(name, x, y, w=None, h=None, tint=None):
    a = BY[name]
    w = a.w if w is None else w
    h = a.h * (w / a.w) if h is None else h
    inner = uniq(a.inner if tint is None else a.inner.replace("#FFFFFF", tint))
    return f'<g transform="translate({f(x)} {f(y)}) scale({f(w / a.w)} {f(h / a.h)})">{inner}</g>'


def nine(name, x, y, w, h):
    """Draw a 9-slice asset stretched to w x h."""
    a = BY[name]
    l, t, r, b = a.nine
    xs = [(0, l, 0, l), (l, a.w - r, l, w - r), (a.w - r, a.w, w - r, w)]
    ys = [(0, t, 0, t), (t, a.h - b, t, h - b), (a.h - b, a.h, h - b, h)]
    parts = []
    for sx0, sx1, dx0, dx1 in xs:
        for sy0, sy1, dy0, dy1 in ys:
            if sx1 - sx0 <= 0 or sy1 - sy0 <= 0 or dx1 - dx0 <= 0 or dy1 - dy0 <= 0:
                continue
            parts.append(f'<svg x="{f(x + dx0)}" y="{f(y + dy0)}" width="{f(dx1 - dx0)}" height="{f(dy1 - dy0)}" '
                         f'viewBox="{f(sx0)} {f(sy0)} {f(sx1 - sx0)} {f(sy1 - sy0)}" preserveAspectRatio="none">{uniq(a.inner)}</svg>')
    return "".join(parts)


def text(x, y, s, size, fill, weight=700, anchor="middle", family="Fredoka"):
    return (f'<text x="{f(x)}" y="{f(y)}" font-family="{family}" font-weight="{weight}" font-size="{f(size)}" '
            f'text-anchor="{anchor}" fill="{fill}">{esc(s)}</text>')


def ring(cx, cy, r, frac, mode):
    """Timer ring from the exported track/fill assets, fill clipped to the remaining fraction."""
    a = math.radians(-90 + 360 * frac)
    large = 1 if frac > .5 else 0
    pid = f"rc{mode}{int(cx)}{int(cy)}"
    clip = (f'<clipPath id="{pid}"><path d="M{f(cx)} {f(cy)} L{f(cx)} {f(cy - r * 2)} A{f(r * 2)} {f(r * 2)} 0 {large} 1 '
            f'{f(cx + r * 2 * math.cos(a))} {f(cy + r * 2 * math.sin(a))} Z"/></clipPath>')
    k = r / 28
    return (f'<defs>{clip}</defs>' + put(f"timer_ring_track_{mode}", cx - 32 * k, cy - 32 * k, 64 * k) +
            f'<g clip-path="url(#{pid})">' + put(f"timer_ring_fill_{mode}", cx - 32 * k, cy - 32 * k, 64 * k) + "</g>")


def phone(body, mode):
    pal = SHELL[mode]
    return (f'<svg viewBox="-14 -14 418 872" role="img" xmlns="http://www.w3.org/2000/svg">'
            f'<rect x="-12" y="-12" width="414" height="868" rx="56" fill="#23272B"/>'
            f'<clipPath id="scr{mode}{abs(hash(body)) % 99999}"><rect width="390" height="844" rx="44"/></clipPath>'
            f'<g clip-path="url(#scr{mode}{abs(hash(body)) % 99999})"><rect width="390" height="844" fill="{pal["bg"]}"/>{body}</g>'
            f'<rect x="133" y="10" width="124" height="30" rx="15" fill="#23272B"/>'
            f'<rect x="129" y="830" width="132" height="5" rx="2.5" fill="{pal["text"]}" opacity=".5"/></svg>')


def statusbar(mode):
    pal = SHELL[mode]
    return text(32, 32, "9:41", 15, pal["text"], 700, "start", "Nunito")


# ---------------------------------------------------------------- mockups
def mock_hub(mode):
    pal = SHELL[mode]
    b = [statusbar(mode)]
    b.append(f'<rect x="16" y="54" width="170" height="48" rx="24" fill="{pal["surface"]}" stroke="{pal["surface2"]}" stroke-width="2"/>')
    b.append(put("avatar_01_fox", 22, 58, 40))
    b.append(text(72, 85, "Asha", 19, pal["text"], 600, "start"))
    b.append(put(f"btn_icon_normal_{mode}", 318, 50, 56))
    b.append(put("icon_settings", 334, 66, 24, tint=pal["text"]))
    b.append(put(f"wordmark_{mode}", 55, 116, 280))
    for i, (g, title, sub) in enumerate((("snakes", "Snakes & Ladders", "Climb, slide, race to 100"), ("ludo", "Ludo", "Race four tokens home"))):
        y = 230 + i * 250
        b.append(f'<rect x="16" y="{y}" width="358" height="230" rx="26" fill="{pal["surface"]}"/>')
        b.append(put(f"hub_card_{g}_{mode}", 25, y + 9, 340))
        b.append(text(40, y + 52, title, 25, pal["text"], 700, "start"))
        b.append(text(40, y + 76, sub, 14, pal["text2"], 400, "start", "Nunito"))
        b.append(nine(f"btn_primary_normal_{mode}", 32, y + 160, 150, 56))
        b.append(put("icon_play", 52, y + 176, 22) + text(124, y + 194, "Play", 20, "#FFFFFF"))
        if i == 0:
            b.append(put(f"chip_continue_{mode}", 192, y + 168, 160))
    for i, (lab, ic) in enumerate((("Stats", "stats"), ("How to Play", "info"))):
        x = 16 + i * 183
        b.append(nine(f"btn_secondary_normal_{mode}", x, 744, 175, 58))
        b.append(put(f"icon_{ic}", x + 22, 760, 22, tint=pal["text"]) + text(x + 100, 779, lab, 18, pal["text"]))
    return phone("".join(b), mode)


def snl_card(x, y, w, h, color, name, sq, state, mode, ring_frac=None):
    pal = SHELL[mode]
    out = [nine(f"card_{color}_{state}_{mode}", x - 6, y - 6, w + 12, h + 12)]
    out.append(put(f"avatar_{ {'red': '01_fox', 'blue': '07_penguin', 'yellow': '09_robot', 'green': '04_frog'}[color] }", x + 10, y + 8, 30))
    if ring_frac is not None:
        out.append(ring(x + 25, y + 23, 19, ring_frac, mode))
    out.append(put(f"token_{color}_idle_{mode}", x + w - 34, y + 4, 30))
    out.append(text(x + 10, y + h - 22, name, 13, pal["text"], 700, "start", "Nunito"))
    out.append(text(x + 10, y + h - 8, f"sq {sq}", 11, pal["text2"], 400, "start", "Nunito"))
    return "".join(out)


def mock_snl(mode):
    pal = SHELL[mode]
    b = [statusbar(mode)]
    b.append(put(f"btn_icon_normal_{mode}", 10, 48, 50) + put("icon_pause", 23, 61, 24, tint=pal["text"]))
    b.append(text(178, 82, "Classic Sunshine", 20, pal["text"]))
    b.append(f'<rect x="276" y="62" width="50" height="28" rx="14" fill="{pal["surface2"]}"/>' + put("icon_snake", 282, 66, 20, tint=pal["text"]) + text(312, 82, "7", 16, pal["text"]))
    b.append(text(380, 82, "T12", 14, pal["text2"], 700, "end", "Nunito"))
    players = (("red", "Asha", 48), ("blue", "Ravi", 31), ("yellow", "Bot Mo", 63), ("green", "Lena", 20))
    for i, (col, nm, sq) in enumerate(players):
        b.append(snl_card(10 + i * 94, 114, 86, 76, col, nm, sq, "active" if i == 0 else "inactive", mode, .62 if i == 0 else None))
    d = Doc(390, 400, f"mocksnl{mode}")
    G.render_board(d, 23, 18, 344, "classic_sunshine", 7, mode, tokens=[(48, "red"), (31, "blue"), (63, "yellow"), (20, "green")])
    b.append(f'<g transform="translate(0 196)">{d.inner()}</g>')
    b.append(nine(f"toast_{mode}", 28, 604, 334, 50))
    b.append(text(195, 634, "Asha's turn. Roll the dice!", 17, "#FFFFFF" if mode == "light" else "#1D2030", 600))
    b.append(put(f"dice_button_normal_{mode}", 127, 668, 136))
    b.append(put(f"dice_face_5_{mode}", 155, 690, 80))
    return phone("".join(b), mode)


def ludo_card(x, y, w, h, color, name, home, state, mode, right=False, ring_frac=None, dice=None):
    pal = SHELL[mode]
    out = [nine(f"card_{color}_{state}_{mode}", x - 6, y - 6, w + 12, h + 12)]
    av = {"red": "01_fox", "blue": "07_penguin", "yellow": "09_robot", "green": "04_frog"}[color]
    ax = x + w - 50 if right else x + 12
    out.append(put(f"avatar_{av}", ax, y + 14, 38))
    if ring_frac is not None:
        out.append(ring(ax + 19, y + 33, 23, ring_frac, mode))
    tx = x + w - 60 if right else x + 60
    anchor = "end" if right else "start"
    out.append(text(tx, y + 34, name, 15, pal["text"], 700, anchor, "Nunito"))
    for k in range(4):
        px = tx + (-1 if right else 1) * (5 + k * 13)
        fill = PLAYER[color] if k < home else "none"
        out.append(f'<circle cx="{f(px)}" cy="{y + 52}" r="5" fill="{fill}" stroke="{pal["text2"]}" stroke-width="1.5"/>')
    if dice:
        dx = x + 8 if right else x + w - 70
        out.append(put(f"dice_tray_{color}_{mode}", dx, y + 6, 64) + put(f"dice_face_{dice}_{mode}", dx + 10, y + 13, 46))
    return "".join(out)


def mock_ludo(mode):
    pal = SHELL[mode]
    b = [statusbar(mode)]
    b.append(put(f"btn_icon_normal_{mode}", 10, 48, 50) + put("icon_pause", 23, 61, 24, tint=pal["text"]))
    b.append(text(195, 82, "Ludo", 22, pal["text"]))
    b.append(text(380, 82, "Turn 22", 14, pal["text2"], 700, "end", "Nunito"))
    b.append(ludo_card(14, 116, 176, 76, "blue", "Ravi", 1, "active", mode, ring_frac=.55, dice=3))
    b.append(ludo_card(200, 116, 176, 76, "yellow", "Bot Mo", 0, "inactive", mode, right=True))
    d = Doc(390, 390, f"mockludo{mode}")
    T = L.TRACK
    L.render_ludo(d, 18, 12, 354, mode, tokens=[(("yard", 0), "red"), (("yard", 1), "red"), (T[3], "red"), (T[30], "blue", "active"),
                                                    (("yard", 2), "blue"), (("yard", 0), "yellow"), (("yard", 3), "yellow"),
                                                    (T[44], "green"), (("home",), "green"), (("yard", 1), "green")])
    b.append(f'<g transform="translate(0 200)">{d.inner()}</g>')
    cx, cy = 18 + (T[30][1] + .5) * 354 / 15, 212 + (T[30][0] + .5) * 354 / 15
    b.append(put(f"capture_puff_2_{mode}", cx - 30, cy - 26, 60))
    b.append(put(f"token_yellow_hop_{mode}", cx + 8, cy - 64, 34))
    b.append(f'<path d="M{f(cx + 24)} {f(cy - 52)} Q{f(cx + 60)} {f(cy - 140)} {f(18 + 12 * 354 / 15)} {f(212 + 2 * 354 / 15)}" fill="none" '
             f'stroke="{pal["text2"]}" stroke-width="2.5" stroke-dasharray="3 6" stroke-linecap="round"/>')
    b.append(put(f"badge_captured_{mode}", 126, 382, 180))
    b.append(ludo_card(14, 584, 176, 76, "red", "Asha", 0, "inactive", mode))
    b.append(ludo_card(200, 584, 176, 76, "green", "Lena", 1, "inactive", mode, right=True))
    b.append(nine(f"toast_{mode}", 28, 680, 334, 50))
    b.append(text(195, 710, "Captured Yellow!", 17, "#FFFFFF" if mode == "light" else "#1D2030", 600))
    return phone("".join(b), mode)


# ---------------------------------------------------------------- sections
def cell(a):
    variant = "both" if a.modes in ("tinted", "any") or len(a.modes) == 2 else a.modes[0]
    k = 1.0
    if max(a.w, a.h) <= 32:
        k = 3
    elif max(a.w, a.h) <= 64:
        k = 1.6
    elif max(a.w, a.h) > 300:
        k = 300 / max(a.w, a.h)
    svg = a.svg.replace("<svg ", f'<svg style="width:{f(a.w * k)}px;max-width:100%;height:auto" ', 1)
    if a.modes == "tinted":
        svg = svg.replace("#FFFFFF", "#2B2F3A")
    meta = []
    if a.nine:
        meta.append(f"9-slice {','.join(str(v) for v in a.nine)}")
    if a.anchor != (0.5, 0.5):
        meta.append(f"anchor {a.anchor[0]},{a.anchor[1]}")
    m = f'<span class="meta">{esc(" · ".join(meta))}</span>' if meta else ""
    return (f'<div class="cell m-{variant}"><div class="chk">{svg}</div>'
            f'<code>{esc(a.name)}.png</code><span class="meta">{f(a.w)}×{f(a.h)}</span>{m}</div>')


def sheet(title, items, note=None):
    nt = f"<p class='snote'>{esc(note)}</p>" if note else ""
    return f'<figure class="sheet"><figcaption>{esc(title)}</figcaption>{nt}<div class="cells">{"".join(cell(a) for a in items)}</div></figure>'


def pick(pred):
    return [a for a in ASSETS if pred(a)]


def mode_pair(fn, w, h, label):
    """Same drawing in light and dark, toggled with the page switch."""
    out = []
    for mode in ("light", "dark"):
        d = Doc(w, h, f"{label}{mode}")
        fn(d, mode)
        bg = SHELL[mode]["bg"]
        svg = d.svg().replace("<svg ", '<svg style="width:100%;height:auto" ', 1)
        out.append(f'<div class="render m-{mode}" style="background:{bg}">{svg}</div>')
    return "".join(out)


def section(sid, title, note, body):
    return f'<section id="{sid}" aria-labelledby="{sid}-h"><h2 id="{sid}-h">{esc(title)}</h2><p class="note">{esc(note)}</p>{body}</section>'


def build_sections():
    S = []
    S.append(section("brand", "Brand", "App icon master, adaptive foreground, native splash logos and the wordmark with its snake and token.",
                     sheet("Brand", pick(lambda a: a.section == "brand"), "Splash backgrounds: #FFF9EE light, #12141C dark. Adaptive icon background #FFC93C.")))
    S.append(section("hub", "Hub cards", "Card art for the two games, plus the Continue chip shown when a saved game exists.",
                     sheet("Hub cards", pick(lambda a: a.section == "hub" or a.name.startswith("chip_continue")))))
    S.append(section("tokens", "Tokens", "One token family for both games. Six states per colour, each with its colour-blind symbol. Dark mode adds a light rim.",
                     "".join(sheet(c.title(), pick(lambda a, c=c: a.name.startswith(f"token_{c}_"))) for c in ("red", "blue", "yellow", "green")) +
                     sheet("Shadow and stack badges", pick(lambda a: a.name == "token_shadow" or a.name.startswith("stack_badge")))))
    S.append(section("dice", "Dice", "Faces, eight tumble frames rendered from a 3D cube (opposite faces sum to 7), the roll button and per-colour trays.",
                     sheet("Faces and tumble", pick(lambda a: a.name.startswith(("dice_face", "dice_roll", "dice_shadow")))) +
                     sheet("Button and trays", pick(lambda a: a.name.startswith(("dice_button", "dice_tray"))))))
    S.append(section("cards", "Player cards", "Four states per colour at identical pixel sizes, so a card never changes size when the turn moves.",
                     sheet("Cards", pick(lambda a: a.name.startswith("card_")), "Every card is 132 × 96 with 30 px 9-slice insets.") +
                     sheet("Timer ring, medals, crown, badge", pick(lambda a: a.name.startswith(("timer_ring", "rank_", "crown", "wifi_off"))))))
    S.append(section("avatars", "Avatars", "Twelve original round avatars, 256 px.", sheet("Avatars", pick(lambda a: a.section == "avatars"))))
    S.append(section("ui", "UI kit", "Buttons in three states, panels, dialog, bottom sheet, toast, turn ribbon and badges. Stretchable pieces list their insets.",
                     sheet("Buttons", pick(lambda a: a.name.startswith("btn_"))) +
                     sheet("Surfaces and badges", pick(lambda a: a.section == "ui" and not a.name.startswith(("btn_", "chip_"))))))
    S.append(section("icons", "Icons", "34 icons on a 24 grid with a 2 px rounded stroke. Exported white and tinted at runtime; shown here in ink.",
                     sheet("Icons", pick(lambda a: a.section == "icons"))))
    S.append(section("fx", "FX", "Confetti in six shapes and four colours, sparkle, star burst, dust puff and four capture-puff frames.",
                     sheet("FX", pick(lambda a: a.section == "fx"))))
    S.append(section("snl-tiles", "S&L tiles", "Per theme: two tiles, start and goal tiles, a 9-slice frame and a seamless background tile.",
                     "".join(sheet(t.title(), pick(lambda a, t=t: a.section == "snl-tiles" and f"_{t}_" in a.name)) for t in G.THEMES)))

    def one_snake(theme):
        def draw(d, mode):
            j = {"from": 85, "to": 22, "rank": 1, "path": [[.32, .3], [.62, .5], [.3, .66]]}
            for sq in range(1, 101):
                r = (sq - 1) // 10; c = (sq - 1) % 10; col = c if r % 2 == 0 else 9 - c
                T = G.THEMES[theme][mode]
                d.add(f'<rect x="{col * 40}" y="{(9 - r) * 40}" width="40.4" height="40.4" fill="{T["tile_a"] if (r + col) % 2 == 0 else T["tile_b"]}"/>')
            G.render_snake(d, j, 0, 0, 400, theme, mode, "a")
        return draw
    snake_body = "".join(sheet(f"{t.title()} heads, tails, patterns", pick(lambda a, t=t: a.section == "snl-snakes" and f"_{t}_" in a.name)) for t in G.THEMES)
    renders = "".join(f'<figure class="sheet"><figcaption>{t.title()} snake, rendered</figcaption><div class="renders">{mode_pair(one_snake(t), 400, 400, "sn" + t)}</div></figure>' for t in G.THEMES)
    S.append(section("snl-snakes", "Snakes", "Bodies are drawn in code along the Catmull-Rom path, tapering 0.32 → 0.12 tile; patterns are stamped along it; heads and tails rotate to the tangent at their anchors.",
                     snake_body + renders))
    S.append(section("snl-ladders", "Ladders", "Rails repeat along the ladder's length; rungs are placed every 0.3 tile. Shadow spec lives in themes/<theme>.json.",
                     sheet("Rails and rungs", pick(lambda a: a.section == "snl-ladders"))))

    def board(n, bid="classic_sunshine"):
        return lambda d, mode: G.render_board(d, 34, 34, 512, bid, n, mode)
    boards = "".join(f'<figure class="sheet"><figcaption>Classic Sunshine, {n} snakes</figcaption><div class="renders">{mode_pair(board(n), 580, 580, f"cs{n}")}</div></figure>' for n in (6, 7, 8))
    boards += "".join(f'<figure class="sheet"><figcaption>{G.board(b)["name"]}, 7 snakes</figcaption><div class="renders">{mode_pair(board(7, b), 580, 580, f"o{b}")}</div></figure>' for b in ("sugar_rush", "jungle_temple"))
    S.append(section("snl-boards", "Full S&L boards", "Rendered from the board JSON with the exported pieces. Rank 7 and 8 snakes appear only at those counts.",
                     f'<div class="two">{boards}</div>' + sheet("Board select", pick(lambda a: a.section == "snl-cards"))))
    S.append(section("ludo-pieces", "Ludo board pieces", "Flame assembles the board from these 48 px cells, 288 px yards and the 144 px centre, using the §3.1 geometry.",
                     sheet("Pieces", pick(lambda a: a.section == "ludo-pieces"))))

    def ludo(d, mode):
        T = L.TRACK
        L.render_ludo(d, 30, 30, 600, mode, tokens=[(("yard", 0), "red"), (("yard", 1), "red"), (T[3], "red", "movable"), (T[13], "blue"), (T[13], "blue"),
                                                      (L.HOME["yellow"][1], "yellow"), (T[40], "green"), (("home",), "green"), (("yard", 2), "blue")],
                      ghosts=[(T[9], "red")])
    S.append(section("ludo-board", "Full Ludo board", "Assembled from the pieces. Red has a movable token with its landing ghost; Blue has a stacked pair on its start.",
                     f'<figure class="sheet"><figcaption>Ludo</figcaption><div class="renders">{mode_pair(ludo, 660, 660, "lb")}</div></figure>'))
    S.append(section("howto", "How to Play", "Five illustrations per game.", sheet("Snakes & Ladders", pick(lambda a: a.name.startswith("howto_snakes"))) +
                     sheet("Ludo", pick(lambda a: a.name.startswith("howto_ludo")))))
    S.append(section("specs", "Colour & type specs", "Palettes from §1.2, §2.7 and §3.8 with measured contrast. Text needs 4.5:1; large text and icons need 3:1.", specs()))
    S.append(section("audio", "Audio", "All sounds are synthesised by tool/generate_audio.py. Each plays here from the shipped M4A, with OGG as fallback.", audio()))
    rules = """<h3>Outlines and shading</h3><ul><li>Outline = the fill darkened 55% in lightness, never black. 2–4 px at 1×.</li>
<li>Cel shade: one darker band (16–18% darker) on the lower edge.</li><li>One highlight: white at 45–70% opacity, top-left.</li>
<li>Soft shadow: radial ellipse, #1A1426 at 22–34%, below the object.</li><li>Dark mode: tokens and dice keep their hue and gain a white rim at 70–80%.</li></ul>
<h3>Spacing</h3><p>4 · 8 · 12 · 16 · 24 · 32 · 48 dp. Tap targets ≥ 48 dp.</p>
<h3>Sizes</h3><ul><li>Player cards: S&amp;L 86 × 76 dp (70 × 60 at 320 dp); Ludo 176 × 76 dp (149 × 60). Same size in every state.</li>
<li>Board ≤ 640 dp, centred. S&amp;L tile 64 px, Ludo cell 48 px at 1×.</li><li>Tokens 64 px; drawn 1.15× larger in S&amp;L.</li></ul>
<h3>Motion</h3><ul><li>Dice tumble 800 ms (8 frames).</li><li>S&amp;L hop 180 ms (90 ms Fast); ladder 120 ms per rung, ≤ 1.2 s; snake slide 1.0–1.6 s.</li>
<li>Ludo hop 150 ms; capture flight 600 ms; capture puff 4 × 60 ms.</li><li>Auto single move 1120 ms after the roll commits.</li>
<li>Theme cross-fade 250 ms. Timer warning ticks in the last 5 s.</li></ul>"""
    mocks = "".join(f'<div class="pair"><div>{fn("light")}</div><div>{fn("dark")}</div></div><p class="cap">{cap}</p>'
                    for fn, cap in ((mock_hub, "Hub"), (mock_snl, "Snakes & Ladders: Classic Sunshine, 7 snakes, 4 tokens"),
                                    (mock_ludo, "Ludo: capture in progress, timer ring on Blue")))
    S.append(section("context", "In context", "Mockups built only from the exported assets, light then dark.",
                     f'<div class="ctx"><div class="mocks">{mocks}</div><aside class="rules">{rules}</aside></div>'))
    return S


def swatch(name, hexv):
    return f'<div class="sw"><span style="background:{hexv}"></span><code>{esc(name)}</code><code>{hexv}</code></div>'


def specs():
    rows = []
    checks = []
    for mode in ("light", "dark"):
        P = SHELL[mode]
        rows.append(f'<div class="pal"><h3>Shell, {mode}</h3>{"".join(swatch(k, v) for k, v in P.items())}</div>')
        checks += [(f"Shell {mode}: text on background", P["text"], P["bg"], 4.5), (f"Shell {mode}: secondary text on surface", P["text2"], P["surface"], 4.5),
                   (f"Shell {mode}: text on surface 2", P["text"], P["surface2"], 4.5), (f"Shell {mode}: button label on primary (large)", "#FFFFFF", P["primary"], 3),
                   (f"Shell {mode}: ink on accent", "#2A2A35", P["accent"], 4.5)]
        for t in G.THEMES:
            T = G.THEMES[t][mode]
            for k in ("tile_a", "tile_b"):
                checks.append((f"S&L {t} {mode}: number on {k} (large)", T["number"], T[k], 3))
        for c in PLAYER:
            col = PLAYER[c] if mode == "light" else desat(PLAYER[c], .1)
            checks.append((f"Ludo {mode}: {c} token outline vs board (icon)", outline(col) if mode == "light" else "#FFFFFF", L.PAL[mode]["base"], 3))
    rows.append('<div class="pal"><h3>Players</h3>' + "".join(swatch(k, v) for k, v in PLAYER.items()) + "</div>")
    for t in G.THEMES:
        for mode in ("light", "dark"):
            T = G.THEMES[t][mode]
            rows.append(f'<div class="pal"><h3>{t.title()}, {mode}</h3>' + "".join(swatch(k, v) for k, v in T.items() if isinstance(v, str)) + "</div>")
    trs = []
    for label, fg, bg, need in checks:
        r = contrast(fg, bg)
        ok = "pass" if r >= need else "fail"
        trs.append(f'<tr><td>{esc(label)}</td><td><span class="chip" style="color:{fg};background:{bg}">Aa 42</span></td>'
                   f'<td class="num">{r:.2f}:1</td><td class="num">{need}:1</td><td class="{ok}">{ok.upper()}</td></tr>')
    table = ('<div class="tw"><table><thead><tr><th>Pair</th><th>Sample</th><th>Ratio</th><th>Needs</th><th></th></tr></thead><tbody>'
             + "".join(trs) + "</tbody></table></div>")
    y_fill = contrast(PLAYER["yellow"], L.PAL["light"]["base"])
    y_line = contrast(outline(PLAYER["yellow"]), L.PAL["light"]["base"])
    yel = (f'<p class="snote">The yellow fill on the white Ludo board measures {y_fill:.1f}:1, under the 3:1 icon minimum, so tokens are '
           f'separated from the board by their dark-tint outline ({y_line:.1f}:1) in light mode and a white rim in dark mode, plus the ▲ '
           'symbol. The table checks those edges, not the fills.</p>')
    type_spec = ('<div class="type"><p style="font:700 40px Fredoka">Fredoka 700 · Dice Party 1234567890</p>'
                 '<p style="font:600 28px Fredoka">Fredoka 600 · Extra roll! Ladder! Oops!</p>'
                 '<p style="font:700 18px Nunito">Nunito 700 · Asha · sq 48 · 0:45</p>'
                 '<p style="font:400 16px Nunito">Nunito 400 · Race four tokens home. Need exactly 3 to win.</p></div>')
    return f'<div class="pals">{"".join(rows)}</div>{type_spec}{table}{yel}'


def audio():
    import json
    m = json.load(open(os.path.join(ROOT, "assets", "manifest.json")))
    rows = []
    for e in m["assets"]:
        if e.get("kind") != "audio":
            continue
        srcs = []
        for p, mime in ((e["files"][1], "audio/mp4"), (e["files"][0], "audio/ogg")):
            data = base64.b64encode(open(os.path.join(ROOT, p), "rb").read()).decode()
            srcs.append(f'<source src="data:{mime};base64,{data}" type="{mime}">')
        sizes = " · ".join(f"{os.path.basename(p)} {os.path.getsize(os.path.join(ROOT, p)) / 1024:.0f} KB" for p in e["files"])
        rows.append(f'<div class="aud"><div><code>{esc(e["name"])}</code><span class="meta">{e["game"]} · {e["durationMs"] / 1000:.2f} s'
                    f'{" · loop" if e["loop"] else ""} · {esc(sizes)}</span></div><audio controls preload="none">{"".join(srcs)}</audio></div>')
    return f'<div class="auds">{"".join(rows)}</div>'


CSS = """:root{
  /* Layout: a dark title band, sticky section nav, then one column of sprite sheets ending in the in-context mockups. */
  --band:#2B2F3A; --paper:#F1F4F8; --sheet:#FFFFFF; --muted:#566070; --line:#CBD3DD;
  --sun:#FFC93C; --road:#1C5FBF;
  --display:'Fredoka','Trebuchet MS',sans-serif; --body:'Nunito',system-ui,sans-serif;
  --mono:ui-monospace,'SF Mono',Menlo,Consolas,monospace; --ink:#20242C;
  color-scheme:light;
}
html{background:var(--paper)}
body{margin:0;background:var(--paper);color:var(--ink);font:16px/1.5 var(--body)}
body::before{content:"";position:fixed;inset:0 0 auto;height:env(safe-area-inset-top,0px);z-index:10;background:var(--paper)}
.band{background:var(--band);color:#fff;border-bottom:6px dashed var(--sun)}
.band .in{max-width:1240px;margin:0 auto;padding-block:48px 22px;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px))}
.band h1{font-family:var(--display);font-weight:700;font-size:clamp(44px,8vw,72px);line-height:1;color:var(--sun);margin:0 0 14px;text-wrap:balance}
.band p{color:#DDE3EC;max-width:62ch;margin:0 0 22px}
.strip{display:flex;height:8px;border-radius:4px;overflow:hidden;max-width:320px}.strip span{flex:1}
nav.top{position:sticky;top:env(safe-area-inset-top,0px);z-index:5;background:var(--paper);border-bottom:1px solid var(--line)}
nav.top .in{max-width:1240px;margin:0 auto;padding-block:10px;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px));display:flex;flex-wrap:wrap;gap:6px 22px;align-items:center}
nav.top .grp{display:flex;flex-wrap:wrap;gap:4px 12px;align-items:baseline}
nav.top .lab{font:600 13px var(--display);color:var(--muted);text-transform:uppercase;letter-spacing:.06em}
nav.top a{font:500 17px var(--display);color:var(--road);text-decoration:none}
nav.top a:hover{text-decoration:underline}
nav.top a:focus-visible,.toggle button:focus-visible{outline:2px solid var(--road);outline-offset:2px;border-radius:4px}
.toggle{margin-left:auto;display:flex;border:1px solid var(--line);border-radius:999px;overflow:hidden;background:#fff}
.toggle button{font:600 15px var(--display);border:0;background:transparent;color:var(--ink);padding:6px 14px;cursor:pointer}
.toggle button[aria-pressed="true"]{background:var(--band);color:#fff}
main{max-width:1240px;margin:0 auto;padding-block:40px 80px;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px));display:flex;flex-direction:column;gap:52px}
section{display:flex;flex-direction:column;gap:14px;scroll-margin-top:90px;min-width:0}
h2{font:600 32px/1.15 var(--display);margin:0}
h3{font:600 18px var(--display);margin:0 0 6px}
.note{color:var(--muted);max-width:65ch;margin:0}
figure.sheet{margin:0;background:var(--sheet);border:1px solid var(--line);border-radius:14px;padding:16px;min-width:0}
figure.sheet figcaption{font:600 18px var(--display);margin-bottom:8px}
.snote{color:var(--muted);font-size:14px;margin:0 0 10px;max-width:70ch}
.cells{display:grid;grid-template-columns:repeat(auto-fill,minmax(150px,1fr));gap:14px}
.cell{display:flex;flex-direction:column;gap:3px;min-width:0}
.chk{display:flex;align-items:center;justify-content:center;min-height:120px;padding:10px;border-radius:10px;border:1px solid var(--line);
  background-color:#fff;background-image:linear-gradient(45deg,#E3E8EF 25%,transparent 25%),linear-gradient(-45deg,#E3E8EF 25%,transparent 25%),linear-gradient(45deg,transparent 75%,#E3E8EF 75%),linear-gradient(-45deg,transparent 75%,#E3E8EF 75%);
  background-size:16px 16px;background-position:0 0,0 8px,8px -8px,-8px 0}
.cell code{font:12px/1.3 var(--mono);word-break:break-all}
.meta{font:11px/1.3 var(--mono);color:var(--muted)}
body.dark-on .m-light, body:not(.dark-on) .m-dark{display:none}
body.dark-on .chk{background-color:#2A2E3A;background-image:linear-gradient(45deg,#232733 25%,transparent 25%),linear-gradient(-45deg,#232733 25%,transparent 25%),linear-gradient(45deg,transparent 75%,#232733 75%),linear-gradient(-45deg,transparent 75%,#232733 75%)}
.renders{display:block}.render{border-radius:10px;overflow:hidden}
.two{display:grid;grid-template-columns:repeat(auto-fill,minmax(min(100%,520px),1fr));gap:20px}
.pals{display:grid;grid-template-columns:repeat(auto-fill,minmax(min(100%,260px),1fr));gap:14px}
.pal{background:#fff;border:1px solid var(--line);border-radius:14px;padding:14px}
.sw{display:grid;grid-template-columns:28px 1fr auto;gap:8px;align-items:center;font-size:12px}
.sw span{width:28px;height:20px;border-radius:5px;border:1px solid rgba(0,0,0,.15)}
.sw code{font:12px var(--mono)}
.type{background:#fff;border:1px solid var(--line);border-radius:14px;padding:6px 18px}.type p{margin:10px 0}
.tw{overflow-x:auto;background:#fff;border:1px solid var(--line);border-radius:14px}
table{border-collapse:collapse;width:100%;font-size:14px}
th,td{text-align:left;padding:8px 12px;border-bottom:1px solid var(--line)}
td.num{font-variant-numeric:tabular-nums;white-space:nowrap}
.pass{color:#1B7A3A;font-weight:700}.fail{color:#B42318;font-weight:700}
.chip{display:inline-block;padding:2px 10px;border-radius:999px;font:700 15px var(--display);border:1px solid rgba(0,0,0,.12)}
.auds{display:grid;grid-template-columns:repeat(auto-fill,minmax(min(100%,360px),1fr));gap:12px}
.aud{background:#fff;border:1px solid var(--line);border-radius:14px;padding:12px;display:flex;flex-direction:column;gap:8px;min-width:0}
.aud audio{width:100%}
.ctx{display:grid;grid-template-columns:minmax(0,3fr) minmax(0,2fr);gap:28px}
.mocks .pair{display:grid;grid-template-columns:1fr 1fr;gap:14px}
.mocks svg{width:100%;height:auto;display:block}
.cap{font:600 16px var(--display);margin:6px 0 22px;color:var(--muted)}
.rules{background:#fff;border:1px solid var(--line);border-radius:14px;padding:18px;align-self:start;position:sticky;top:80px}
.rules ul{padding-left:18px;margin:0 0 14px}.rules p{margin:0 0 14px}
@media (max-width:760px){.ctx{grid-template-columns:1fr}.rules{position:static}}
"""

HEAD = ('<title>dice_party Asset Library</title>\n<meta name="claude:viewport-fit-sides" content="cover">\n'
        '<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>\n'
        '<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fredoka:wght@500;600;700&family=Nunito:wght@400;700&display=swap">\n'
        f"<style>{CSS}</style>")

NAV = [("Shared", [("brand", "Brand"), ("hub", "Hub"), ("tokens", "Tokens"), ("dice", "Dice"), ("cards", "Cards"), ("avatars", "Avatars"),
                   ("ui", "UI kit"), ("icons", "Icons"), ("fx", "FX"), ("specs", "Specs"), ("context", "In context")]),
       ("Snakes & Ladders", [("snl-tiles", "Tiles"), ("snl-snakes", "Snakes"), ("snl-ladders", "Ladders"), ("snl-boards", "Boards"), ("howto", "How to Play")]),
       ("Ludo", [("ludo-pieces", "Pieces"), ("ludo-board", "Board")]),
       ("Audio", [("audio", "Sounds")])]

SCRIPT = """<script>
(function(){
  var KEY='dp-assets-mode', btns=document.querySelectorAll('.toggle button');
  function set(m){document.body.classList.toggle('dark-on',m==='dark');
    btns.forEach(function(b){b.setAttribute('aria-pressed',String(b.dataset.mode===m));});
    try{localStorage.setItem(KEY,m);}catch(e){}}
  btns.forEach(function(b){b.addEventListener('click',function(){set(b.dataset.mode);});});
  var saved='light'; try{saved=localStorage.getItem(KEY)||'light';}catch(e){}
  set(saved==='dark'?'dark':'light');
})();
</script>"""


def body():
    strip = "".join(f'<span style="background:{c}"></span>' for c in PLAYER.values())
    nav = "".join(f'<div class="grp"><span class="lab">{esc(g)}</span>' + "".join(f'<a href="#{i}">{esc(l)}</a>' for i, l in links) + "</div>"
                  for g, links in NAV)
    toggle = ('<div class="toggle" role="group" aria-label="Sprite mode"><button type="button" data-mode="light" aria-pressed="true">Light</button>'
              '<button type="button" data-mode="dark" aria-pressed="false">Dark</button></div>')
    n_img = len(ASSETS)
    return (f'<header class="band"><div class="in"><h1>dice_party Asset Library</h1><p>Every image and sound that Dice Party ships: '
            f'{n_img} images exported as PNG at 1×, 2× and 3× from hand-built SVG, 17 synthesised sounds, and the board renders they '
            f'add up to. Switch Light and Dark to swap each sprite sheet to its night variant.</p><div class="strip" aria-hidden="true">{strip}</div></div></header>'
            f'<nav class="top" aria-label="Sections"><div class="in">{nav}{toggle}</div></nav>'
            f'<main>{"".join(build_sections())}</main>{SCRIPT}')


if __name__ == "__main__":
    os.chdir(ROOT)
    b = body()
    out = os.path.join("design", "asset_library.html")
    with open(out, "w") as fh:
        fh.write('<!doctype html>\n<html lang="en"><head><meta charset="utf-8">'
                 '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">' + HEAD + "</head><body>" + b + "</body></html>\n")
    print(out, round(os.path.getsize(out) / 1024), "KB")
    if "--fragment" in sys.argv:
        frag = sys.argv[sys.argv.index("--fragment") + 1]
        with open(frag, "w") as fh:
            fh.write(HEAD + b + "\n")
        print(frag)
    fails = re.findall(r'<td>([^<]*)</td><td><span[^>]*>Aa 42</span></td><td class="num">([^<]*)</td><td class="num">[^<]*</td><td class="fail">', b)
    for label, ratio in fails:
        print("CONTRAST FAIL:", html.unescape(label), ratio)
