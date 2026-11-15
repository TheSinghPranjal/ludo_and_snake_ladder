"""Build design/wireframes.html (Phase 2). Run from the repo root:
    python3 tool/design/build_wireframes.py [--fragment OUT]

--fragment also writes the page without the <html>/<head>/<body> skeleton, for publishing.
"""
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import wf_screens as S  # noqa: E402
from wf_lib import (BLUE, INK, RED, START, TRACK, cell_xy, esc, ludo_board, phone, plain,  # noqa: E402
                    snl_board)
from snl_balance import stats  # noqa: E402

SNL = S.BOARDS


# ------------------------------------------------------------------ page parts
def fig(svg, title, items=(), note=None, cls=""):
    lis = "".join(f"<li>{esc(i)}</li>" for i in items)
    ol = f"<ol>{lis}</ol>" if items else ""
    nt = f"<p>{esc(note)}</p>" if note else ""
    return f'<figure class="sheet {cls}">{svg}<figcaption><strong>{esc(title)}</strong>{nt}{ol}</figcaption></figure>'


def section(sid, title, note, grid, figs):
    return (f'<section id="{sid}" aria-labelledby="{sid}-h"><h2 id="{sid}-h">{esc(title)}</h2>'
            f'<p class="note">{esc(note)}</p><div class="grid {grid}">{"".join(figs)}</div></section>')


def ph(draw, annotate=None, pad=(30, 30, 30, 30), **kw):
    return phone(draw, annotate=annotate, pad=pad, **kw)


def marks(points):
    def a(c):
        for i, (x, y) in enumerate(points, 1):
            c.callout(x, y, i)
    return a


# ------------------------------------------------------------------ app flow
def app_flow():
    def draw(c):
        W, H = 150, 54
        N = {"Splash": (20, 300), "Hub": (210, 300), "How to Play": (20, 120), "Stats": (20, 480),
             "Profile": (210, 120), "Settings": (210, 480),
             "S&L Menu": (420, 190), "Ludo Menu": (420, 410),
             "Player Setup": (630, 40), "Board Select": (630, 130), "Host Lobby": (630, 300),
             "Join": (630, 470), "Joined Lobby": (630, 580),
             "S&L Game": (860, 190), "Ludo Game": (860, 410), "Pause": (860, 300),
             "Results": (1080, 300), "Reconnecting": (1080, 470), "Host lost": (1080, 580),
             "Room full / Wrong game / Version": (360, 600)}
        def box(k):
            x, y = N[k]; w = 240 if "/" in k else W
            c.rect(x, y, w, H, 12, fill=c.fill if k.endswith("Game") else c.paper, sw=2.2 if k.endswith("Game") else 1.8,
                   dash="5 4" if k in ("Pause", "Reconnecting", "Host lost") or "/" in k else None)
            c.text(x + w / 2, y + 34, k, 19, "middle")
        for k in N:
            box(k)
        def mid(k, side):
            x, y = N[k]; w = 240 if "/" in k else W
            return {"r": (x + w, y + H / 2), "l": (x, y + H / 2), "t": (x + w / 2, y), "b": (x + w / 2, y + H)}[side]
        def arrow(a, sa, b, sb, label=None, dash=None):
            (x1, y1), (x2, y2) = mid(a, sa), mid(b, sb)
            mx = (x1 + x2) / 2
            d = f"M{x1:.0f} {y1:.0f} C{mx:.0f} {y1:.0f} {mx:.0f} {y2:.0f} {x2:.0f} {y2:.0f}" if sa in "rl" and sb in "rl" else f"M{x1:.0f} {y1:.0f} L{x2:.0f} {y2:.0f}"
            c.tx.append(f'<path d="{d}" fill="none" stroke="{INK}" stroke-width="1.8" stroke-linecap="round"' + (f' stroke-dasharray="{dash}"' if dash else "") + ' marker-end="url(#arrk)"/>')
            if label:
                c.tx.append(f'<text x="{mx:.0f}" y="{(y1 + y2) / 2 - 6:.0f}" class="h" font-size="15" text-anchor="middle" fill="{BLUE}" stroke="#fff" stroke-width="4" paint-order="stroke">{esc(label)}</text>')
        arrow("Splash", "r", "Hub", "l")
        for k, sa, sb in (("How to Play", "t", "b"), ("Profile", "t", "b"), ("Settings", "b", "t"), ("Stats", "b", "t")):
            (x1, y1) = (N["Hub"][0] + W / 2, N["Hub"][1] + (0 if sa == "t" else H))
            (x2, y2) = mid(k, sb)
            c.tx.append(f'<path d="M{x1:.0f} {y1:.0f} L{x2:.0f} {y2:.0f}" fill="none" stroke="{INK}" stroke-width="1.6" marker-end="url(#arrk)"/>')
        arrow("Hub", "r", "S&L Menu", "l"); arrow("Hub", "r", "Ludo Menu", "l")
        arrow("S&L Menu", "r", "Player Setup", "l", "Play Local")
        arrow("Player Setup", "b", "Board Select", "t")
        arrow("Ludo Menu", "r", "Player Setup", "l")
        arrow("S&L Menu", "r", "Host Lobby", "l", "Host")
        arrow("Ludo Menu", "r", "Host Lobby", "l")
        arrow("Ludo Menu", "r", "Join", "l", "Join")
        arrow("Join", "b", "Joined Lobby", "t")
        arrow("Player Setup", "r", "S&L Game", "l", "Start")
        arrow("S&L Menu", "r", "S&L Game", "l", "Quick Play vs AI", "6 4")
        arrow("Ludo Menu", "r", "Ludo Game", "l", "Quick Play vs AI", "6 4")
        arrow("Host Lobby", "r", "S&L Game", "l"); arrow("Host Lobby", "r", "Ludo Game", "l")
        arrow("Joined Lobby", "r", "Ludo Game", "l")
        arrow("S&L Game", "b", "Pause", "t"); arrow("Ludo Game", "t", "Pause", "b")
        arrow("S&L Game", "r", "Results", "l", "game over"); arrow("Ludo Game", "r", "Results", "l")
        arrow("Ludo Game", "r", "Reconnecting", "l", "socket lost", "6 4")
        arrow("Reconnecting", "t", "Results", "b", "back within 45 s → resumes game", "6 4")
        arrow("Joined Lobby", "r", "Host lost", "l", "host gone", "6 4")
        arrow("Join", "l", "Room full / Wrong game / Version", "t", "refused", "6 4")
        c.tx.append(f'<path d="M1230 327 C1330 327 1330 20 700 20 C300 20 300 300 360 318" fill="none" stroke="{INK}" stroke-width="1.6" stroke-dasharray="3 5" marker-end="url(#arrk)"/>')
        c.note(1320, 46, "Results: Play Again, Game Menu or Hub", anchor="end")
        c.note(1080, 684, "Host lost: 45 s wait, then Hub")
        c.note(20, 690, "Solid boxes are screens. Dashed boxes are overlays or dialogs. Grey fill marks the two game screens.")
    return plain(draw, 1340, 712)


# ------------------------------------------------------------------ boards
def snl_spec(bid):
    b = SNL[bid]

    def draw(c):
        snl_board(c, 30, 30, 560, b, 6, labels=True, show_inactive=True)
    return plain(draw, 620, 660)


def snl_count(n):
    def draw(c):
        snl_board(c, 24, 24, 400, SNL["classic_sunshine"], n, labels=True)
        c.text(224, 492, f"{n} snakes", 30, "middle")
    return plain(draw, 448, 510)


def stepper_closeup():
    def draw(c):
        for i, (v, lo, hi, lab) in enumerate(((6, True, False, "At 6: minus disabled"), (7, False, False, "Default 7"),
                                              (8, False, True, "At 8: plus disabled"))):
            y = 30 + i * 140
            c.stepper(40, y, v, lo, hi, w=220, h=64)
            c.note(290, y + 40, lab)
        c.note(40, 450, "48 dp buttons · value is announced to screen readers")
    return plain(draw, 448, 480)


def ludo_spec():
    def draw(c):
        size = 780; x0, y0 = 30, 30
        ludo_board(c, x0, y0, size, indices=True, labels=True)
        s = size / 15
        for col, k in START.items():
            cx, cy = cell_xy(TRACK[k], x0, y0, size)
            c.tx.append(f'<circle cx="{cx:.0f}" cy="{cy:.0f}" r="{s * .48:.0f}" fill="none" stroke="{RED}" stroke-width="2.5"/>')
        tx = 860
        c.text(tx, 70, "Board geometry (§3.1)", 34)
        rows = ["52 track cells, a closed loop", "Blue numbers: track index 0–51", "Red numbers: home column 51–55",
                "Red rings: start cells 0 · 13 · 26 · 39", "Stars: safe cells 8 · 21 · 34 · 47",
                "Diagonal corner steps: 4→5, 17→18, 30→31, 43→44", "Arrows: last track cell before the home column",
                "Centre: home triangles, one per colour", "Rel −1 base · 0–50 track · 51–55 column · 56 HOME"]
        for i, r in enumerate(rows):
            c.text(tx, 120 + i * 34, "• " + r, 19, font="body")
        c.text(tx, 450, "Turn order (clockwise)", 26)
        cx, cy, r = 980, 590, 92
        c.tx.append(f'<path d="M{cx - r} {cy} A{r} {r} 0 1 1 {cx} {cy + r}" fill="none" stroke="{BLUE}" stroke-width="3" marker-end="url(#arr)"/>')
        for i, (lab, a) in enumerate((("Red", 135), ("Blue", 225), ("Yellow", 315), ("Green", 45))):
            px, py = cx + (r + 34) * math.cos(math.radians(a)), cy + (r + 34) * math.sin(math.radians(a))
            c.text(px, py + 6, f"{i + 1}. {lab}", 20, "middle")
        c.text(tx, 760, "Hatching = player colour in these ink sketches:", 17, font="body")
        c.text(tx, 786, "Red diagonal · Blue dots · Yellow lines · Green cross", 17, font="body")
    return plain(draw, 1340, 840)


# ------------------------------------------------------------------ annotated main sheets
def snl_main():
    def ann(c):
        notes = [(-30, 60, "Pause opens the shared menu", (14, 76)),
                 (-30, 150, "Fixed-size cards: 86 × 76 dp.\nOnly outline, glow and ring change", (50, 170)),
                 (-30, 300, "Snake heads and ladder feet are\nnever covered by a body", (120, 330)),
                 (-30, 520, "Long-press a snake: \"92 → 42\"", (230, 300)),
                 (-30, 700, "Start pad = position 0", (30, 600)),
                 (420, 76, "Board name + active snake count", (300, 76)),
                 (420, 166, "Timer ring on the active card\n(30 s, online always on)", (40, 140)),
                 (420, 640, "Status line, also announced\nto screen readers", (370, 622)),
                 (420, 740, "Dice: tap or swipe up.\n800 ms tumble, haptic tick", (250, 720))]
        for x, y, t, to in notes:
            c.note(x, y, t, to, anchor="end" if x < 0 else "start")
        for i, (x, y) in enumerate(((34, 112), (50, 196), (195, 380), (330, 640), (195, 700)), 1):
            c.callout(x + 30, y - 10, i)
    return ph(lambda c: S.snl_game(c, "await"), ann, pad=(420, 30, 420, 30))


def ludo_main():
    def ann(c):
        notes = [(-30, 140, "Cards sit at the board corners,\nnext to their yards", (14, 150)),
                 (-30, 300, "Yards: white inner square,\n4 token slots", (14, 250)),
                 (-30, 470, "Stars and starts are safe cells", (14, 466)),
                 (-30, 640, "Active card holds the dice\nand the timer ring", (14, 650)),
                 (420, 150, "Tokens home: 0–4 pips", (320, 150)),
                 (420, 330, "Centre: four home triangles", (195, 384)),
                 (420, 520, "Entry arrows mark each\nhome column", (195, 560)),
                 (420, 740, "Status line: \"Captured Blue!\",\n\"No moves\"", (300, 732))]
        for x, y, t, to in notes:
            c.note(x, y, t, to, anchor="end" if x < 0 else "start")
        for i, (x, y) in enumerate(((100, 150), (195, 384), (100, 650), (360, 730)), 1):
            c.callout(x, y - 30, i)
    return ph(lambda c: S.ludo_game(c, "await"), ann, pad=(420, 30, 420, 30))


def small(game):
    def ann(c):
        if game == "ludo":
            c.dim(7, 584, 156, 584, "149 dp")
            c.dim(330, 136, 330, 440, "304 dp board")
            c.note(340, 90, "Cards 149 × 60 dp,\nsame size active or not", (150, 100))
            c.dim(0, 652, 320, 652, "320 dp")
        else:
            c.dim(11, 144, 81, 144, "70 dp")
            c.dim(330, 152, 330, 456, "304 dp board")
            c.note(340, 90, "4 cards × 70 dp + gaps\nfit in 304 dp", (160, 100))
            c.dim(0, 652, 320, 652, "320 dp")
            c.note(340, 520, "Under 360 dp:\npinch-zoom to 2×,\nresets each turn", (250, 400))
    draw = (lambda c: S.ludo_game(c, "await", W=320, H=640)) if game == "ludo" else (lambda c: S.snl_game(c, "await", W=320, H=640))
    return phone(draw, W=320, H=640, pad=(20, 20, 220, 40), annotate=ann)


def dark(kind):
    tokens = {"hub": ["background #12141C", "surface #1D2030 / #262A3C", "text #F2F3F7 / #A9AEC2",
                      "primary, accent 10–15% less saturated", "cards keep shadows soft, no pure black"],
              "snl": ["squares #1E2A44 / #8A6A1C", "frame #C9A227", "numbers #FFF8E1 + dark halo",
                      "snakes #9CCC65, spots #388E3C, soft glow", "ladders #7FB8FF", "tokens keep hue + light rim"],
              "ludo": ["board base #171A24", "cells #232838", "grid lines #343A4F", "player colours −10% saturation",
                       "soft glow on yards + home columns", "stars #E6E8F0 outline"]}[kind]

    def ann(c):
        for i, t in enumerate(tokens):
            c.note(420, 120 + i * 70, t)
    draw = {"hub": lambda c: S.hub(c, cont=True), "snl": lambda c: S.snl_game(c, "await"),
            "ludo": lambda c: S.ludo_game(c, "await")}[kind]
    return phone(draw, dark=True, pad=(30, 30, 380, 30), annotate=ann)


# ------------------------------------------------------------------ page
DECISIONS = [
    ("Hub layout", "Two stacked game cards (drawn), so both games show without swiping. Alternative: a carousel."),
    ("Dice position", "S&L: big dice button bottom-centre for thumb reach and swipe-up. Ludo: on the active player's card, as the brief asks."),
    ("Snake stepper", "In Player Setup under the seats, with a live mini-board (drawn). Alternative: on the Board Select screen."),
    ("Ludo cards at 320 dp", "Two rows above and below the board, 149 × 60 dp each (drawn). Alternative: overlap the board corners."),
    ("Token from a stack", "Only one colour can be movable in a stack. Tap moves the first movable token; long-press opens a picker with each token's destination (drawn)."),
    ("Replace leavers with AI", "Off by default, as a lobby toggle (drawn)."),
    ("Local turn timer", "Off by default in Settings; online games always run it (drawn)."),
    ("Start pad", "Position 0 sits under square 1, outside the board, because the board fills the width (drawn)."),
]


def build():
    secs = []
    secs.append(section("flow", "App flow", "Every screen of the shell and both games, with reconnect paths.", "wide",
                        [fig(app_flow(), "Screen map", note="Both games share the shell, lobby, results frame, pause menu and dialogs.")]))
    secs.append(section("hub", "Hub & profile", "First launch, the game hub with and without saved games, profile and stats.", "four", [
        fig(ph(S.splash), "Splash", ["Logo lockup, preloads shared assets"]),
        fig(ph(S.hub, marks([(40, 60), (370, 60), (40, 218), (195, 774)])), "Hub, no saves",
            ["Profile chip opens Profile", "Settings", "Each card: mini board, title, Play", "Stats and How to Play"]),
        fig(ph(lambda c: S.hub(c, cont=True), marks([(40, 352)])), "Hub, Continue on both cards",
            ["Continue chip resumes the saved local game for that game only"]),
        fig(ph(S.profile, marks([(330, 300), (100, 410)])), "Profile", ["Name, 12 characters max", "12 original avatars"]),
        fig(ph(lambda c: S.stats(c, 0)), "Stats, Snakes & Ladders tab", note="Games, wins by mode, ladders, snakes, best win."),
        fig(ph(lambda c: S.stats(c, 1)), "Stats, Ludo tab", note="Captures, times captured, sixes rolled."),
    ]))
    secs.append(section("settings", "Settings & pause", "Global settings and the shared in-game menu.", "two", [
        fig(ph(S.settings, marks([(24, 130), (40, 210), (206, 446), (24, 600)])), "Settings",
            ["Appearance: System, Light, Dark. Switches live with a 250 ms cross-fade",
             "Sound, Music and Haptics really mute their services", "Turn timer for local games, default Off",
             "Reset stats asks to confirm"]),
        fig(ph(S.pause_menu, marks([(32, 386), (32, 520), (32, 640), (32, 700)])), "Pause menu",
            ["Resume", "Sound, Music, Haptics toggles", "Appearance, same control as Settings", "Leave game, with confirm"]),
    ]))
    secs.append(section("snl-setup", "Snakes & Ladders: menu & setup", "Choosing how to play, who plays and how many snakes.", "four", [
        fig(ph(lambda c: S.game_menu(c, "snl")), "Game Menu", note="Same layout for both games."),
        fig(ph(lambda c: S.snl_setup(c, 2)), "Player Setup, 2 players"),
        fig(ph(lambda c: S.snl_setup(c, 4), marks([(226, 444), (24, 538), (296, 528)])), "Player Setup, 4 players, 2 AI",
            ["AI difficulty chip per AI seat", "Snakes stepper, 6 to 8", "Live preview redraws at each step"]),
        fig(ph(S.board_select, marks([(195, 299), (195, 560)])), "Board Select, locked board",
            ["Lock overlay on the board art", "Unlock hint: Sugar Rush after 1 win, Jungle Temple after 3"]),
    ]))
    states = [("await", "Awaiting roll, timer running"), ("rolling", "Dice rolling, 800 ms"), ("hop", "Hopping, 180 ms per square"),
              ("ladder", "Ladder climb along the rails"), ("snake", "Snake slide along the body"), ("extra", "Extra roll on a 6"),
              ("penalty", "Three 6s: back to turn start"), ("need3", "Need exactly 3 to win"), ("banner", "Turn banner"),
              ("ai", "AI thinking, 600–900 ms")]
    secs.append(section("snl-game", "Snakes & Ladders: game", "Classic Sunshine with 7 snakes and 4 players. The main sheet, then each state.", "four",
                        [fig(snl_main(), "Game screen, annotated", ["Pause", "Player strip", "Board", "Status line", "Dice button"], cls="span")] +
                        [fig(ph(lambda c, st=st: S.snl_game(c, st)), lab) for st, lab in states]))
    def snakes(bid):
        return [f"Snake {j['from']} → {j['to']}" + (" (on at 7+)" if j["rank"] == 7 else " (on at 8)" if j["rank"] == 8 else "")
                for j in sorted((j for j in SNL[bid]["jumps"] if j["type"] == "snake"), key=lambda j: j["rank"])]

    def ladders(bid):
        return "Ladders: " + ", ".join(f"{j['from']} → {j['to']}" for j in SNL[bid]["jumps"] if j["type"] == "ladder")
    secs.append(section("snl-boards", "Snakes & Ladders: boards",
                        "Source of truth for the board JSON. Red circles are snake ranks; ranks 7 and 8 are dashed. Blue labels are from → to.", "two",
                        [fig(snl_spec(b), SNL[b]["name"], snakes(b), ladders(b)) for b in ("classic_sunshine", "sugar_rush", "jungle_temple")] +
                        [fig(plain(_balance, 620, 300),
                             "Balance check", note="Exact mean and median turns per player; tool/design/check_snl_boards.py")]))
    secs.append(section("snl-count", "Snake count", "Classic Sunshine as the snake count changes. Ranks 1–6 are always on.", "four",
                        [fig(snl_count(n), f"Classic Sunshine, {n} snakes") for n in (6, 7, 8)] +
                        [fig(stepper_closeup(), "Stepper close-up")]))
    secs.append(section("snl-results", "Snakes & Ladders: results", "Shared results frame with the S&L stats panel.", "two", [
        fig(ph(lambda c: S.snl_results(c, False), marks([(195, 72), (40, 186), (24, 440)])), "Results, 2 players",
            ["Confetti (off with reduce-motion)", "Ranked list with medals", "Panel: turns, ladders, snakes, longest climb, worst slide"]),
        fig(ph(lambda c: S.snl_results(c, True)), "Results, full ranking with a leaver", note="Leavers rank below all finishers."),
    ]))
    secs.append(section("ludo-board", "Ludo: board spec", "The 15 × 15 grid exactly as §3.1, with every track index.", "wide",
                        [fig(ludo_spec(), "Ludo geometry")]))
    secs.append(section("ludo-setup", "Ludo: menu & setup", "Same menu layout as Snakes & Ladders.", "four", [
        fig(ph(lambda c: S.game_menu(c, "ludo")), "Game Menu"),
        fig(ph(lambda c: S.ludo_setup(c, 2)), "Player Setup, 2 players", note="Opposite colours by default."),
        fig(ph(lambda c: S.ludo_setup(c, 4)), "Player Setup, 4 players with AI"),
    ]))
    lstates = [("await", "Awaiting roll, timer on Red"), ("rolling", "Dice rolling on the card"),
               ("moves", "Legal moves pulse, ghosts show landing"), ("hop", "Hop cell by cell, 150 ms"),
               ("capture", "Capture: knock-back, flight to base"), ("home", "Token home, sparkle"),
               ("extra", "Extra roll"), ("forfeit", "Three 6s forfeit"), ("nomoves", "No moves, turn passes"),
               ("auto", "Single legal move, auto in 1120 ms"), ("ai", "AI thinking"),
               ("reconnect", "Opponent reconnecting 0:45"), ("stack", "Stack picker on long-press")]
    secs.append(section("ludo-game", "Ludo: game", "Four players, Red to move. The main sheet, then each state.", "four",
                        [fig(ludo_main(), "Game screen, annotated", ["Opponent cards", "Board", "Active card with dice", "Status line"], cls="span")] +
                        [fig(ph(lambda c, st=st: S.ludo_game(c, st)), lab) for st, lab in lstates]))
    secs.append(section("small", "Small screens", "Both games at 320 × 640 dp, with no overflow.", "two", [
        fig(small("ludo"), "Ludo at 320 dp"), fig(small("snl"), "Snakes & Ladders at 320 dp")]))
    secs.append(section("ludo-results", "Ludo: results", "Shared frame with the Ludo stats panel.", "two", [
        fig(ph(lambda c: S.ludo_results(c, False)), "Results, 4 players"),
        fig(ph(lambda c: S.ludo_results(c, True)), "Results online, with a removed seat")]))
    secs.append(section("host-join", "Host & join", "Wi-Fi and hotspot multiplayer for both games.", "four", [
        fig(ph(lambda c: S.lobby(c, "snl"), marks([(36, 128), (178, 180), (40, 292), (316, 620)])), "Host Lobby, Snakes & Ladders",
            ["QR with diceparty:// link", "Room code and real host IPs", "Game settings summary, host only", "Replace leavers with AI, default off"]),
        fig(ph(lambda c: S.lobby(c, "ludo", full=True)), "Host Lobby, Ludo, full and ready"),
        fig(ph(lambda c: S.join(c, "list")), "Join, nearby rooms by game"),
        fig(ph(lambda c: S.join(c, "manual")), "Join, address with an error"),
        fig(ph(lambda c: S.join(c, "qr")), "Join, QR scanner"),
        fig(ph(lambda c: S.lobby(c, "snl", client=True)), "Joined lobby (client)"),
    ]))
    secs.append(section("dialogs", "Connection dialogs", "Shared dialogs. None of them show technical errors.", "four", [
        fig(ph(lambda c: S.conn_dialog(c, "reconnecting")), "Reconnecting (you)"),
        fig(ph(lambda c: S.conn_dialog(c, "hostlost")), "Host lost"),
        fig(ph(lambda c: S.conn_dialog(c, "full")), "Room full"),
        fig(ph(lambda c: S.conn_dialog(c, "wrong")), "Wrong game and version mismatch"),
    ]))
    secs.append(section("dark", "Dark mode", "A designed night version. Ink-filled phones, with the palette tokens alongside.", "two",
                        [fig(dark("hub"), "Hub, dark"), fig(dark("snl"), "Snakes & Ladders, dark"), fig(dark("ludo"), "Ludo, dark")]))
    secs.append(section("tablet", "Tablet", "10-inch portrait. The board caps at 640 dp, centred.", "two", [
        fig(phone(S.tablet_hub, W=800, H=1280, tablet=True, pad=(30, 30, 30, 30)), "Hub, tablet"),
        fig(phone(S.tablet_ludo, W=800, H=1280, tablet=True, pad=(30, 30, 30, 30)), "Ludo, tablet")]))
    return secs


def _balance(c):
    rows = []
    c.text(20, 40, "Balance, 2 players, first winner", 26)
    for bid in ("classic_sunshine", "sugar_rush", "jungle_temple"):
        rows.append((SNL[bid]["name"], [stats(SNL[bid]["jumps"], n)[:2] for n in (6, 7, 8)]))
    c.text(20, 80, "Board", 18, font="body", weight=700)
    for i, n in enumerate((6, 7, 8)):
        c.text(300 + i * 105, 80, f"{n} snakes", 18, "middle", font="body", weight=700)
    for r, (name, vals) in enumerate(rows):
        y = 124 + r * 46
        c.line(20, y - 30, 600, y - 30, sw=1, stroke=c.fill2)
        c.text(20, y, name, 20)
        for i, (m, md) in enumerate(vals):
            c.text(300 + i * 105, y, f"{m:.1f} / {md}", 19, "middle", font="body")
    c.text(20, 270, "mean / median turns. Target 25–40 at every count.", 16, font="body", fill=c.muted)


NAV = [("Shell", [("flow", "App flow"), ("hub", "Hub & profile"), ("settings", "Settings")]),
       ("Snakes & Ladders", [("snl-setup", "Setup"), ("snl-game", "Game"), ("snl-boards", "Boards"),
                             ("snl-count", "Snake count"), ("snl-results", "Results")]),
       ("Ludo", [("ludo-board", "Board spec"), ("ludo-setup", "Setup"), ("ludo-game", "Game"), ("small", "320 dp"),
                 ("ludo-results", "Results")]),
       ("Multiplayer", [("host-join", "Host & join"), ("dialogs", "Dialogs")]),
       ("Themes", [("dark", "Dark"), ("tablet", "Tablet")])]

DEFS = f"""<svg width="0" height="0" style="position:absolute" aria-hidden="true" focusable="false"><defs>
<filter id="wob" x="-2%" y="-2%" width="104%" height="104%"><feTurbulence type="fractalNoise" baseFrequency="0.035" numOctaves="2" seed="7"/><feDisplacementMap in="SourceGraphic" scale="1.2"/></filter>
<marker id="arr" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 1 L9 5 L0 9" fill="none" stroke="{BLUE}" stroke-width="1.6" stroke-linecap="round"/></marker>
<marker id="arrk" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 1 L9 5 L0 9" fill="none" stroke="{INK}" stroke-width="1.6" stroke-linecap="round"/></marker>
<marker id="tick" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="8" markerHeight="8" orient="auto"><path d="M5 0 V10" stroke="{BLUE}" stroke-width="1.6"/></marker>
""" + "".join(
    f'<pattern id="{pid}{sfx}" width="8" height="8" patternUnits="userSpaceOnUse"{rot}><rect width="8" height="8" fill="{bg}"/>{shape.format(st=st)}</pattern>'
    for sfx, bg, st in (("", "#FFFFFF", "#AEB6BD"), ("d", INK, "#6F7880"))
    for pid, rot, shape in (("pr", ' patternTransform="rotate(45)"', '<line x1="2" y1="0" x2="2" y2="8" stroke="{st}" stroke-width="2"/>'),
                            ("pb", "", '<circle cx="4" cy="4" r="1.6" fill="{st}"/>'),
                            ("py", "", '<line x1="0" y1="4" x2="8" y2="4" stroke="{st}" stroke-width="1.8"/>'),
                            ("pg", "", '<path d="M0 0L8 8M8 0L0 8" stroke="{st}" stroke-width="1.2"/>'))) + "</defs></svg>"

CSS = """:root{
  /* Layout: pinned paper sheets on a drafting desk, grouped by section, sticky pill nav. */
  --desk:#E8ECEF; --sheet:#FFFFFF; --ink:#23272B; --muted:#5C666F;
  --pencil-blue:#1C6DD0; --mark:#D92D20; --rule:#C6CED5;
  --display:'Patrick Hand','Chalkboard SE','Comic Sans MS',cursive;
  --body:'Nunito',system-ui,sans-serif;
}
html{background:var(--desk)}
body{margin:0;background:var(--desk);color:var(--ink);font:16px/1.5 var(--body)}
body::before{content:"";position:fixed;inset:0 0 auto;height:env(safe-area-inset-top,0px);z-index:10;background:var(--desk)}
.wrap{max-width:1500px;margin:0 auto;padding-block:32px 64px;padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px));display:flex;flex-direction:column;gap:40px}
header h1{font-family:var(--display);font-weight:400;font-size:clamp(44px,8vw,76px);line-height:1;margin:0 0 12px;text-wrap:balance}
header p{color:var(--muted);max-width:65ch;margin:0}
nav.top{position:sticky;top:env(safe-area-inset-top,0px);z-index:5;background:var(--desk);border-bottom:1.5px dashed var(--rule);padding-block:10px;display:flex;flex-wrap:wrap;gap:10px 22px}
nav.top .grp{display:flex;flex-wrap:wrap;align-items:center;gap:8px}
nav.top .lab{font-family:var(--display);font-size:18px;color:var(--muted)}
nav.top a{font-family:var(--display);font-size:21px;line-height:1.1;color:var(--ink);text-decoration:none;background:#fff;border:1.5px solid var(--ink);border-radius:12px;padding:4px 12px}
nav.top a:hover,nav.top a:focus-visible{background:#FFEC99;outline:2px solid var(--pencil-blue);outline-offset:1px}
.decide{background:#fff;border:2px solid var(--mark);border-radius:14px;padding:18px 24px}
.decide h2{font-family:var(--display);font-weight:400;color:var(--mark);font-size:28px;margin:0 0 8px}
.decide ul{margin:0;padding-left:20px;display:grid;gap:6px}
.decide b{font-weight:700}
section{display:flex;flex-direction:column;gap:10px;scroll-margin-top:120px}
section h2{font-family:var(--display);font-weight:400;font-size:36px;line-height:1.1;margin:0}
.note{color:var(--muted);margin:0 0 8px;max-width:65ch}
.grid{display:grid;gap:24px}
.grid.wide{grid-template-columns:1fr}
.grid.two{grid-template-columns:repeat(auto-fill,minmax(min(100%,560px),1fr))}
.grid.four{grid-template-columns:repeat(auto-fill,minmax(min(100%,300px),1fr))}
.grid.four .span{grid-column:1/-1}
figure.sheet{margin:0;background:var(--sheet);box-shadow:0 1px 0 var(--rule),0 3px 10px rgba(35,39,43,.10);padding:14px;display:flex;flex-direction:column;gap:10px;min-width:0}
figure.sheet svg{width:100%;height:auto;display:block}
figure.sheet.span svg{max-height:1000px}
figcaption{font-size:14px;color:var(--ink)}
figcaption strong{font-family:var(--display);font-weight:400;font-size:21px;display:block}
figcaption p{margin:2px 0 0;color:var(--muted)}
figcaption ol{margin:6px 0 0;padding-left:22px;color:var(--ink)}
figcaption ol li::marker{color:var(--mark);font-weight:700}
.h{font-family:var(--display)}
.b{font-family:var(--body)}
@media (prefers-reduced-motion:no-preference){html{scroll-behavior:smooth}}
"""

HEAD = """<title>dice_party Wireframes</title>
<meta name="claude:viewport-fit-sides" content="cover">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;700&family=Patrick+Hand&display=swap">
<style>""" + CSS + "</style>"


def body():
    nav = "".join(f'<div class="grp"><span class="lab">{esc(g)}</span>' + "".join(f'<a href="#{i}">{esc(l)}</a>' for i, l in links) + "</div>"
                  for g, links in NAV)
    dec = "".join(f"<li><b>{esc(k)}.</b> {esc(v)}</li>" for k, v in DECISIONS)
    return (DEFS + '<div class="wrap"><header><h1>dice_party Wireframes</h1><p>Grayscale ink wireframes for Dice Party: the shared shell, '
            "Snakes &amp; Ladders, Ludo, Wi-Fi play and both themes. Boards are drawn to the real geometry: the S&amp;L sheets are "
            "the source of truth for the board JSON, and the Ludo sheet follows §3.1 cell for cell. Blue is annotation, red numbers "
            "match each caption's list.</p></header>"
            f'<nav class="top" aria-label="Sections">{nav}</nav>'
            f'<aside class="decide" aria-labelledby="dec-h"><h2 id="dec-h">Decisions to make</h2><ul>{dec}</ul>'
            '<p class="note" style="margin:10px 0 0">Each is drawn with the recommended option. Reply with any you want changed.</p></aside>'
            + "".join(build()) + "</div>")


if __name__ == "__main__":
    out = os.path.join("design", "wireframes.html")
    b = body()
    with open(out, "w") as fh:
        fh.write('<!doctype html>\n<html lang="en"><head><meta charset="utf-8">'
                 '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">'
                 + HEAD + "</head><body>" + b + "</body></html>\n")
    print(out, round(os.path.getsize(out) / 1024), "KB")
    if "--fragment" in sys.argv:
        frag = sys.argv[sys.argv.index("--fragment") + 1]
        with open(frag, "w") as fh:
            fh.write(HEAD + b + "\n")
        print(frag)
