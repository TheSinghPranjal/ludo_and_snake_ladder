"""Every wireframe screen. Each function paints one screen on a Canvas in 0..W x 0..H."""
import math

from wf_lib import HOME, TRACK, cell_xy, draw_snake, ludo_board, load_board, snl_board, sq_xy, statusbar

CLASSIC = load_board("classic_sunshine")
BOARDS = {b: load_board(b) for b in ("classic_sunshine", "sugar_rush", "jungle_temple")}
SYM = {"red": "●", "blue": "■", "yellow": "▲", "green": "★"}


# ------------------------------------------------------------------ shared pieces
def topbar(c, title, left="back", right=None, W=390, y=52, sub=None):
    if left:
        c.rect(14, y, 48, 48, 14, sw=1.6)
        c.icon(left, 38, y + 24, 24)
    c.text(W / 2, y + 32 if not sub else y + 24, title, 24, "middle")
    if sub:
        c.text(W / 2, y + 44, sub, 14, "middle", font="body", fill=c.muted)
    if right:
        x = W - 62
        for name in (right if isinstance(right, (list, tuple)) else [right])[::-1]:
            c.rect(x, y, 48, 48, 14, sw=1.6)
            c.icon(name, x + 24, y + 24, 24)
            x -= 56


def dim_overlay(c, W=390, H=844):
    c.layer()
    c.rect(0, 0, W, H, 44, fill="rgba(35,39,43,.38)", sw=0, stroke="none")
    c.layer()


def sheet(c, y, h, W=390):
    c.rect(0, y, W, h + 40, 28, fill=c.paper, sw=2)
    c.rect(W / 2 - 24, y + 10, 48, 5, 3, fill=c.fill2, sw=0)


def dialog(c, y, h, title, body_lines=2, icon=None, buttons=(("OK", "primary"),), W=390, extra=None):
    c.rect(28, y, W - 56, h, 22, fill=c.paper, sw=2.4)
    yy = y + 36
    if icon:
        c.circle(W / 2, y + 46, 28, fill=c.fill, sw=2)
        c.icon(icon, W / 2, y + 46, 30)
        yy = y + 110
    c.text(W / 2, yy, title, 24, "middle")
    c.para(64, yy + 28, W - 128, body_lines)
    if extra:
        extra(yy + 28 + body_lines * 13)
    by = y + h - 70
    bw = (W - 56 - 40 - 12 * (len(buttons) - 1)) / len(buttons)
    for i, (lab, kind) in enumerate(buttons):
        c.button(48 + i * (bw + 12), by, bw, 50, lab, kind, 18)


# ------------------------------------------------------------------ shell
def splash(c):
    statusbar(c)
    c.img(135, 280, 120, 120, 30, "logo")
    c.text(195, 456, "Dice Party", 46, "middle")
    c.text(195, 486, "Snakes & Ladders · Ludo", 16, "middle", font="body", fill=c.muted)
    c.rect(115, 600, 160, 8, 4, sw=1.6)
    c.rect(115, 600, 96, 8, 4, fill=c.ink, sw=0)
    c.text(195, 636, "Loading…", 15, "middle", font="body", fill=c.muted)


def game_card(c, x, y, w, h, title, sub, cont=False, kind="snl"):
    c.rect(x, y, w, h, 22, fill=c.paper, sw=2.4)
    c.img(x + 14, y + 14, 132, 132, 14, "mini board")
    c.text(x + 162, y + 48, title, 26)
    c.text(x + 162, y + 74, sub, 14, font="body", fill=c.muted)
    c.icon("snake" if kind == "snl" else "dice", x + w - 30, y + 30, 22)
    c.button(x + 162, y + 96, w - 178, 50, "Play", "primary", 20, icon="play")
    if cont:
        c.chip(x + 14, y + 160, "Continue · turn 14" if kind == "snl" else "Continue · turn 22", 14, filled=True, icon="refresh")
        c.text(x + w - 16, y + 180, "saved 2 min ago", 13, "end", font="body", fill=c.muted)
    else:
        c.text(x + 14, y + 180, "2–4 players · local, AI or Wi-Fi", 14, font="body", fill=c.muted)


def hub(c, cont=False, W=390, H=844):
    statusbar(c, W)
    c.rect(14, 54, 178, 48, 24, sw=1.6)
    c.avatar(38, 78, 18)
    c.text(64, 84, "Asha", 20)
    c.text(176, 84, "›", 20, "end")
    c.rect(W - 62, 54, 48, 48, 14, sw=1.6); c.icon("gear", W - 38, 78, 24)
    c.text(24, 156, "Pick a game", 34)
    game_card(c, 16, 180, W - 32, 200, "Snakes & Ladders", "Climb, slide, race to 100", cont, "snl")
    game_card(c, 16, 400, W - 32, 200, "Ludo", "Race four tokens home", cont, "ludo")
    c.button(16, 740, (W - 44) / 2, 56, "Stats", icon="stats")
    c.button(28 + (W - 44) / 2, 740, (W - 44) / 2, 56, "How to Play", icon="book")


def profile(c):
    statusbar(c); topbar(c, "Profile")
    c.avatar(195, 190, 56)
    c.text(195, 278, "Your name", 16, "middle", font="body", fill=c.muted)
    c.field(40, 290, 310, 54, "Asha", "4/12")
    c.text(40, 386, "Avatar", 20)
    for i in range(12):
        x = 52 + (i % 4) * 76; y = 430 + (i // 4) * 80
        c.avatar(x + 20, y, 28)
        if i == 2:
            c.circle(x + 20, y, 35, sw=3)
    c.text(195, 690, "Used for player 1 and your name online", 14, "middle", font="body", fill=c.muted)
    c.button(40, 730, 310, 56, "Save", "primary")


def stats(c, tab=0):
    statusbar(c); topbar(c, "Stats")
    c.seg(24, 116, 342, 46, ["Snakes & Ladders", "Ludo"], tab, 17)
    for i, (n, lab) in enumerate((("42", "games"), ("19", "wins"), ("45%", "win rate"))):
        x = 24 + i * 118
        c.rect(x, 184, 106, 88, 16, sw=2)
        c.text(x + 53, 230, n, 32, "middle")
        c.text(x + 53, 256, lab, 14, "middle", font="body", fill=c.muted)
    c.text(24, 314, "Wins by mode", 20)
    for i, (m, v) in enumerate((("Local", "8"), ("vs AI", "7"), ("Wi-Fi", "4"))):
        y = 332 + i * 44
        c.text(24, y + 26, m, 18, font="body")
        c.rect(110, y + 12, 200 * int(v) / 8, 16, 6, fill=c.fill2, sw=1.4)
        c.text(366, y + 26, v, 18, "end", font="body", weight=700)
    c.text(24, 494, "This game", 20)
    rows = ([("Ladders climbed", "131"), ("Snakes hit", "118"), ("Best win", "11 turns")] if tab == 0 else
            [("Captures", "57"), ("Times captured", "49"), ("Sixes rolled", "302")])
    for i, (k, v) in enumerate(rows):
        y = 512 + i * 54
        c.rect(24, y, 342, 46, 12, sw=1.6)
        c.icon(("ladder", "snake", "trophy")[i] if tab == 0 else ("crown", "close", "dice")[i], 48, y + 23, 20)
        c.text(70, y + 30, k, 17, font="body")
        c.text(352, y + 30, v, 18, "end", font="body", weight=700)
    c.button(24, 760, 342, 50, "Reset stats in Settings", "secondary", 16)


def settings(c):
    statusbar(c); topbar(c, "Settings")
    y = 116
    c.text(24, y + 20, "Appearance", 18); c.seg(24, y + 32, 342, 44, ["System", "Light", "Dark"], 0, 16)
    y = 210
    for i, (lab, icon, on) in enumerate((("Sound effects", "sound", True), ("Music", "music", True), ("Haptics", "haptics", True))):
        yy = y + i * 54
        c.icon(icon, 40, yy + 22, 22); c.text(64, yy + 29, lab, 18, font="body"); c.toggle(316, yy + 8, on)
        c.line(24, yy + 50, 366, yy + 50, sw=1, stroke=c.fill2)
    y = 380
    for i, (lab, opts, a) in enumerate((("Animation speed", ["Normal", "Fast"], 0), ("Turn timer (local)", ["Off", "30 s"], 0),
                                         ("Default AI", ["Easy", "Normal"], 1))):
        yy = y + i * 66
        c.text(24, yy + 22, lab, 17, font="body"); c.seg(206, yy + 2, 160, 40, opts, a, 15)
    c.button(24, 590, 342, 50, "Reset stats", "danger", 17)
    c.rect(24, 656, 342, 80, 14, sw=1.6, dash="5 4")
    c.icon("info", 46, 680, 20); c.text(66, 686, "Privacy", 17)
    c.para(46, 708, 296, 2)
    c.text(195, 776, "Version 1.0.0 (1)", 14, "middle", font="body", fill=c.muted)


def pause_menu(c):
    snl_game(c, plain=True)
    dim_overlay(c)
    sheet(c, 300, 544)
    c.text(195, 352, "Paused", 30, "middle")
    c.button(32, 376, 326, 56, "Resume", "primary", 20, icon="play")
    c.button(32, 444, 326, 50, "Rules", "secondary", 18, icon="rules")
    for i, (ic, lab) in enumerate((("sound", "Sound"), ("music", "Music"), ("haptics", "Haptics"))):
        x = 32 + i * 112
        c.rect(x, 510, 102, 70, 14, fill=c.fill2 if i != 1 else None, sw=1.8)
        c.icon(ic, x + 51, 534, 22); c.text(x + 51, 568, lab + (" off" if i == 1 else ""), 15, "middle")
    c.text(32, 616, "Appearance", 17); c.seg(32, 628, 326, 42, ["System", "Light", "Dark"], 0, 15)
    c.button(32, 692, 326, 52, "Leave game", "danger", 18)
    c.text(195, 770, "Asks to confirm. Local games stay saved.", 14, "middle", font="body", fill=c.muted)


def game_menu(c, game="snl"):
    statusbar(c); topbar(c, "Snakes & Ladders" if game == "snl" else "Ludo")
    c.img(24, 116, 342, 150, 18, "game art")
    items = [("Play Local", "human", "primary"), ("Quick Play vs AI", "ai", "secondary"),
             ("Host Wi-Fi Game", "host", "secondary"), ("Join Wi-Fi Game", "join", "secondary"),
             ("How to Play", "book", "secondary"), ("Game rules", "rules", "secondary")]
    for i, (lab, ic, k) in enumerate(items):
        c.button(24, 290 + i * 70, 342, 56, lab, k, 20, icon=ic)
    c.text(195, 730, "Classic Sunshine · 7 snakes" if game == "snl" else "Classic Ludo", 15, "middle", font="body", fill=c.muted)


def seat_row(c, y, i, name, col, kind, level=None):
    c.rect(24, y, 342, 64, 14, sw=1.8)
    c.token(52, y + 32, 16, col)
    c.field(80, y + 10, 128, 44, name, None)
    c.seg(218, y + 12, 136, 40, ["Human", "AI"], 1 if kind == "ai" else 0, 15)
    if level:
        c.chip(226, y + 56, level, 12, filled=True)


def snl_setup(c, players=2):
    statusbar(c); topbar(c, "Player Setup", sub="Snakes & Ladders")
    c.text(24, 140, "Players", 18); c.seg(126, 116, 240, 40, ["2", "3", "4"], players - 2, 17)
    seats = [("Asha", "red", "human", None), ("Ravi", "blue", "human", None), ("Bot Mo", "yellow", "ai", "Normal"),
             ("Bot Kit", "green", "ai", "Easy")][:players]
    for i, s in enumerate(seats):
        seat_row(c, 172 + i * 84, i, *s)
    y = 172 + players * 84 + 10
    c.text(24, y + 20, "Snakes", 20)
    c.stepper(24, y + 34, 7, w=160)
    c.text(24, y + 106, "6 to 8 · default 7", 14, font="body", fill=c.muted)
    b = CLASSIC
    snl_board(c, 236, y + 6, 120, b, 7, numbers=False, start_pad=False)
    c.text(296, y + 146, "live preview", 13, "middle", font="body", fill=c.muted)
    y2 = y + 162
    c.rect(24, y2, 342, 52, 14, sw=1.8); c.text(44, y2 + 33, "Board", 17, font="body")
    c.text(346, y2 + 33, "Classic Sunshine ›", 18, "end")
    c.button(24, 766, 342, 56, "Start game", "primary", 20, icon="play")


def board_select(c):
    statusbar(c); topbar(c, "Choose a board")
    c.rect(-60, 160, 70, 400, 22, sw=1.6, dash="4 4")
    c.rect(380, 160, 70, 400, 22, sw=1.6, dash="4 4")
    c.rect(36, 140, 318, 460, 24, fill=c.paper, sw=2.4)
    snl_board(c, 56, 160, 278, BOARDS["sugar_rush"], 7, numbers=False, start_pad=False)
    c.layer()
    c.rect(56, 160, 278, 278, 6, fill="rgba(255,255,255,.72)" if not c.dark else "rgba(35,39,43,.7)", sw=0, stroke="none")
    c.circle(195, 299, 40, fill=c.paper, sw=2.4); c.icon("lock", 195, 299, 36)
    c.text(195, 484, "Sugar Rush", 28, "middle")
    c.text(195, 514, "Win 1 Snakes & Ladders game to unlock", 15, "middle", font="body", fill=c.muted)
    c.chip(140, 540, "1 / 1 wins needed", 13)
    for i in range(3):
        c.circle(171 + i * 24, 630, 6, fill=c.ink if i == 1 else None, sw=1.6)
    c.button(24, 760, 342, 56, "Locked", "disabled", 20, icon="lock")


# ------------------------------------------------------------------ S&L game
SNL_PLAYERS = [("Asha", "red", 48), ("Ravi", "blue", 31), ("Bot Mo", "yellow", 63), ("Lena", "green", 20)]


def snl_card(c, x, y, w, h, name, col, pos, state="inactive", timer=None, ai=False, small=False):
    sw = 3.4 if state == "active" else 1.8
    c.rect(x, y, w, h, 14, fill=c.fill if state == "finished" else c.paper, sw=sw,
           dash="5 4" if state == "disconnected" else None)
    r = 15 if not small else 12
    ax, ay = x + r + 8, y + r + 8
    c.avatar(ax, ay, r)
    if timer is not None:
        c.ring(ax, ay, r + 5, timer)
    c.token(x + w - 16, y + 18, 9 if not small else 7, col)
    c.text(x + 8, y + h - 24 + (2 if small else 0), name, 15 if not small else 12, font="body", weight=700)
    sub = {"disconnected": "0:45 …", "finished": "1st"}.get(state, f"sq {pos}" if pos else "start")
    c.text(x + 8, y + h - 8, sub, 13 if not small else 11, font="body", fill=c.muted)
    if ai:
        c.icon("ai", x + w - 16, y + h - 16, 14)
    if state == "disconnected":
        c.icon("wifi_off", x + w - 16, y + h - 16, 14)


def snl_game(c, state="await", plain=False, W=390, H=844, dark_labels=False, board="classic_sunshine", n=7):
    small = W < 360
    statusbar(c, W, small)
    b = BOARDS[board]
    ty = 52 if not small else 28
    bh = 48 if not small else 40
    c.rect(10, ty, bh, bh, 12, sw=1.6); c.icon("pause", 10 + bh / 2, ty + bh / 2, 22)
    c.text(W / 2, ty + bh / 2 + 7, b["name"], 20 if not small else 16, "middle")
    cw = c.chip(W - (128 if not small else 112), ty + (10 if not small else 6), str(n), 14, icon="snake")
    c.text(W - 12, ty + bh / 2 + 6, "T12" if small else "Turn 12", 15 if not small else 12, "end", font="body", fill=c.muted)
    cy = ty + bh + 12
    cardw = 86 if not small else 70; cardh = 76 if not small else 60; gap = (W - 4 * cardw) / 5
    active = {"ai": 2, "banner": 1}.get(state, 0)
    for i, (nm, col, pos) in enumerate(SNL_PLAYERS):
        st = "active" if i == active else "inactive"
        timer = (.7 if state == "await" else .55) if i == active and state not in ("ai",) else None
        snl_card(c, gap + i * (cardw + gap), cy, cardw, cardh, nm, col, pos, st, timer, ai=i == 2, small=small)
    bsize = W - 20 if not small else W - 16
    bx = (W - bsize) / 2; by = cy + cardh + 14
    toks = [(48 if state not in ("ladder", "snake", "hop", "need3", "penalty") else
             {"ladder": 25, "snake": 92, "hop": 23, "need3": 97, "penalty": 68}[state], "red"),
            (31, "blue"), (63, "yellow"), (20, "green")]
    snl_board(c, bx, by, bsize, b, n, tokens=[] if state in ("ladder", "snake", "hop") else toks,
              ghost=(100, "red") if state == "need3" else None)
    s = bsize / 10
    if state in ("ladder", "snake", "hop"):
        for q, col in toks[1:]:
            px, py = sq_xy(q, bx, by, bsize); c.token(px, py, s * .3, col)
    if state == "hop":
        x1, y1 = sq_xy(23, bx, by, bsize); x2, y2 = sq_xy(26, bx, by, bsize)
        c.path(f"M{x1:.1f} {y1:.1f} Q{(x1 + x2) / 2:.1f} {y1 - s * 1.4:.1f} {x2:.1f} {y2:.1f}", sw=1.6, dash="3 4")
        for q in (24, 25):
            px, py = sq_xy(q, bx, by, bsize); c.circle(px, py + s * .3, s * .08, sw=1.2)
        c.token((x1 + x2) / 2, y1 - s * .75, s * .3, "red")
        c.path(f"M{(x1 + x2) / 2 - s * .25:.1f} {y1 + s * .35:.1f} h{s * .5:.1f}", sw=3, stroke=c.fill2)
    if state == "ladder":
        j = [j for j in b["jumps"] if j["from"] == 25][0]
        ax, ay = sq_xy(25, bx, by, bsize); qx, qy = sq_xy(j["to"], bx, by, bsize)
        c.token(ax + (qx - ax) * .55, ay + (qy - ay) * .55, s * .3, "red")
        c.path(f"M{ax:.1f} {ay:.1f} L{ax + (qx - ax) * .45:.1f} {ay + (qy - ay) * .45:.1f}", sw=3, dash="2 5")
    if state == "snake":
        j = [j for j in b["jumps"] if j["from"] == 92][0]
        P = draw_snake(c, j, bx, by, bsize)
        px, py = P[int(len(P) * .4)]
        c.token(px, py, s * .3, "red")
        hx, hy = P[0]
        c.circle(hx, hy, s * .3, sw=1.4, dash="2 3")
    c.layer()
    sy = by + bsize + s * 1.0 + 4  # clears the START pad under square 1
    status = {"await": "Asha's turn. Roll the dice!", "rolling": "Rolling…", "hop": "Asha moves 23 → 26",
              "ladder": "Ladder! 25 → 48", "snake": "Oops, snake! 92 → 42", "extra": "Rolled a 6. Roll again!",
              "penalty": "Three 6s! Back to 68", "need3": "Need exactly 3 to win", "banner": "Ravi's turn",
              "ai": "Bot Mo is thinking…"}[state]
    c.rect(16, sy, W - 32, 38 if not small else 30, 12, fill=c.fill, sw=1.4)
    c.text(W / 2, sy + (26 if not small else 21), status, 19 if not small else 15, "middle")
    ds = 104 if not small else 84
    dy = sy + (60 if not small else 44)
    dx = W / 2 - ds / 2
    face = {"rolling": 3, "extra": 6, "penalty": 6, "need3": 5, "ladder": 2, "snake": 4, "hop": 3}.get(state, 5)
    if state == "rolling":
        c.dice(dx + 6, dy - 4, ds, face, sw=1.2, dash="3 4")
        for k in range(3):
            c.path(f"M{dx - 30:.1f} {dy + 20 + k * 22:.1f} h20", sw=1.6)
    c.dice(dx, dy, ds, face, dash="6 5" if state in ("ai", "banner") else None)
    if state == "await":
        c.rect(dx - 8, dy - 8, ds + 16, ds + 16, 26, sw=1.4, dash="2 5")
    if state == "penalty":
        for k in range(3):
            c.dice(14 + k * 40, dy + 30, 32, 6, sw=1.4)
        c.line(10, dy + 70, 132, dy + 26, sw=3, stroke=c.ink)
    if not small:
        c.text(W / 2, dy + ds + 30, "Tap or swipe up to roll" if state != "ai" else "Waiting for Bot Mo", 15, "middle", font="body", fill=c.muted)
    if state == "extra":
        c.layer(); ribbon(c, W / 2, by + bsize / 2, "Extra roll!")
    if state == "banner":
        c.layer(); ribbon(c, W / 2, by + bsize / 2, "Ravi's turn", big=True)
    if state == "ai":
        c.layer()
        x = gap + 2 * (cardw + gap)
        c.rect(x + 8, cy + cardh + 4, 70, 26, 13, fill=c.paper, sw=1.6)
        for k in range(3):
            c.circle(x + 28 + k * 14, cy + cardh + 17, 3.5, fill=c.ink, sw=0)
    if state == "ladder":
        c.layer(); badge(c, W - 120, by + 24, "Ladder!")
    if state == "snake":
        c.layer(); badge(c, W - 120, by + 24, "Oops!")


def ribbon(c, cx, cy, label, big=False):
    w = 260 if big else 200; h = 64 if big else 52
    c.path(f"M{cx - w / 2 - 24:.1f} {cy - h / 2 + 10:.1f} l24 0 l0 {h - 8} l-24 0 l12 {-(h - 8) / 2:.1f} Z", fill=c.fill2, sw=2)
    c.path(f"M{cx + w / 2 + 24:.1f} {cy - h / 2 + 10:.1f} l-24 0 l0 {h - 8} l24 0 l-12 {-(h - 8) / 2:.1f} Z", fill=c.fill2, sw=2)
    c.rect(cx - w / 2, cy - h / 2, w, h, 10, fill=c.paper, sw=2.6)
    c.text(cx, cy + (11 if big else 9), label, 32 if big else 26, "middle")


def badge(c, x, y, label):
    c.rect(x, y, 104, 36, 18, fill=c.paper, sw=2.4)
    c.text(x + 52, y + 25, label, 20, "middle")


def snl_results(c, leaver=False):
    statusbar(c)
    if not leaver:
        c.confetti(20, 50, 350, 220)
    c.text(195, 110, "Asha wins!", 40, "middle")
    c.icon("crown", 195, 148, 34)
    rows = [("Asha", "red", "1st", "100"), ("Ravi", "blue", "2nd", "87"), ("Bot Mo", "yellow", "3rd", "64"),
            ("Lena", "green", "4th", "left")]
    if not leaver:
        rows = rows[:2]; rows[1] = ("Ravi", "blue", "2nd", "sq 87")
    for i, (nm, col, rk, pos) in enumerate(rows):
        y = 180 + i * 64
        c.rect(24, y, 342, 54, 14, fill=c.fill if i == 0 else c.paper, sw=2.2 if i == 0 else 1.6, dash="5 4" if pos == "left" else None)
        c.circle(54, y + 27, 17, sw=2); c.text(54, y + 33, rk[0], 18, "middle")
        c.token(94, y + 27, 12, col)
        c.text(118, y + 34, nm, 19, font="body", weight=700)
        c.text(350, y + 34, "Left the game" if pos == "left" else pos, 15, "end", font="body", fill=c.muted)
    y = 180 + len(rows) * 64 + 16
    c.text(24, y + 20, "Asha's game", 20)
    st = [("Turns", "27"), ("Ladders climbed", "5"), ("Snakes hit", "3"), ("Longest climb", "25 → 48"), ("Worst slide", "92 → 42")]
    for i, (k, v) in enumerate(st):
        yy = y + 34 + i * 40
        c.text(24, yy + 22, k, 17, font="body"); c.text(366, yy + 22, v, 18, "end", font="body", weight=700)
        c.line(24, yy + 34, 366, yy + 34, sw=1, stroke=c.fill2)
    c.button(24, 664, 342, 56, "Play Again", "primary", 20, icon="refresh")
    c.button(24, 732, 166, 52, "Game Menu", "secondary", 17)
    c.button(200, 732, 166, 52, "Hub", "secondary", 17, icon="home")


# ------------------------------------------------------------------ Ludo game
LUDO_TOKENS = [(("yard", 0), "red"), (("yard", 1), "red"), (TRACK[3], "red"), (TRACK[30], "red"),
               (("yard", 0), "blue"), (TRACK[20], "blue"), (TRACK[24], "blue"), (HOME["blue"][2], "blue"),
               (("yard", 2), "yellow"), (("yard", 3), "yellow"), (TRACK[40], "yellow"), (TRACK[33], "yellow"),
               (TRACK[45], "green"), (TRACK[47], "green"), (("yard", 1), "green"), (("home",), "green")]


def ludo_card(c, x, y, w, h, name, col, home, state="inactive", timer=None, dice=None, right=False, ai=False, small=False):
    sw = 3.4 if state == "active" else 1.8
    c.rect(x, y, w, h, 14, fill=c.fill if state == "finished" else c.paper, sw=sw, dash="5 4" if state == "disconnected" else None)
    r = 18 if not small else 14
    ax = x + (w - r - 10 if right else r + 10); ay = y + h / 2
    c.avatar(ax, ay, r)
    if timer is not None:
        c.ring(ax, ay, r + 5, timer)
    name_x = x + (w - 2 * r - 22 if right else 2 * r + 22)
    anc = "end" if right else "start"
    c.text(name_x, y + h / 2 - 4, name, 16 if not small else 13, anc, font="body", weight=700)
    for k in range(4):
        px = name_x + (-1 if right else 1) * (6 + k * (14 if not small else 11))
        c.circle(px, y + h / 2 + 14, 4.5 if not small else 3.5, fill=c.ink if k < home else None, sw=1.4)
    if state == "disconnected":
        c.icon("wifi_off", name_x + (-1 if right else 1) * 72, y + h / 2 + 12, 14)
        c.text(name_x + (-1 if right else 1) * 84, y + h / 2 + 18, "0:45", 13, anc, font="body", fill=c.muted)
    if ai:
        c.icon("ai", name_x + (-1 if right else 1) * 72, y + h / 2 + 12, 14)
    if dice:
        ds = h - 18
        dx = x + 8 if right else x + w - ds - 8
        c.dice(dx, y + 9, ds, dice[0], dash="3 4" if dice[1] == "rolling" else None)
        if dice[1] == "ready":
            c.rect(dx - 4, y + 5, ds + 8, ds + 8, 12, sw=1.2, dash="2 4")
    if state == "finished":
        c.icon("crown", name_x + (-1 if right else 1) * 72, y + h / 2 + 12, 16)


def ludo_game(c, state="await", W=390, H=844):
    small = W < 360
    statusbar(c, W, small)
    ty = 52 if not small else 28; bh = 48 if not small else 40
    c.rect(10, ty, bh, bh, 12, sw=1.6); c.icon("pause", 10 + bh / 2, ty + bh / 2, 22)
    c.text(W / 2, ty + bh / 2 + 7, "Ludo", 22 if not small else 17, "middle")
    c.text(W - 12, ty + bh / 2 + 6, "Turn 22", 15 if not small else 12, "end", font="body", fill=c.muted)
    cw = (W - 30) / 2 if not small else (W - 22) / 2
    ch = 76 if not small else 60
    gx = 10 if not small else 7
    y1 = ty + bh + 12
    bsize = W - 20 if not small else W - 16
    by = y1 + ch + 10
    y2 = by + bsize + 10
    cur = {"capture": "red", "await": "red", "rolling": "red", "moves": "red", "hop": "red", "home": "red",
           "extra": "red", "forfeit": "red", "nomoves": "red", "auto": "red", "ai": "yellow", "reconnect": "blue",
           "stack": "red"}[state]
    face = {"await": 5, "rolling": 2, "moves": 6, "hop": 4, "capture": 3, "home": 5, "extra": 6, "forfeit": 6,
            "nomoves": 3, "auto": 4, "ai": 4, "reconnect": 2, "stack": 2}[state]
    dstate = "ready" if state == "await" else "rolling" if state == "rolling" else "shown"
    cards = [("Ravi", "blue", 1, gx, y1, False), ("Bot Mo", "yellow", 0, gx + cw + 10 if not small else gx + cw + 8, y1, True),
             ("Asha", "red", 0, gx, y2, False), ("Lena", "green", 1, gx + cw + 10 if not small else gx + cw + 8, y2, True)]
    for nm, col, home, x, y, right in cards:
        st = "active" if col == cur else "inactive"
        if state == "reconnect" and col == "blue":
            st = "disconnected"
        timer = .62 if col == cur and state not in ("ai",) else (.4 if state == "reconnect" and col == "blue" else None)
        ludo_card(c, x, y, cw, ch, nm, col, home, st, timer, dice=(face, dstate) if col == cur else None,
                  right=right, ai=col == "yellow", small=small)
    toks = list(LUDO_TOKENS)
    ghosts, movable = [], []
    s = bsize / 15
    if state == "moves":
        toks = [(t[0], t[1], "m") if t[1] == "red" else t for t in toks]
        ghosts = [(TRACK[9], "red"), (TRACK[36], "red"), (TRACK[0], "red")]
    if state == "capture":
        toks = [t for t in toks if not (t[1] == "red" and t[0] == TRACK[30]) and not (t[1] == "yellow" and t[0] == TRACK[33])]
        toks.append((TRACK[33], "red"))
    if state == "home":
        toks = [t for t in toks if not (t[1] == "red" and t[0] == TRACK[30])] + [(("home",), "red")]
    if state == "stack":
        toks = [t for t in toks if not (t[1] == "red" and t[0] in (TRACK[3], TRACK[30]))]
        toks += [(TRACK[13], "red", "m"), (TRACK[13], "red", "m"), (TRACK[13], "blue")]
    if state == "auto":
        toks = [t for t in toks if not (t[1] == "red" and t[0] == TRACK[3])]
        toks = [(t[0], t[1], "m") if t[1] == "red" and t[0] == TRACK[30] else t for t in toks]
        ghosts = [(TRACK[34], "red")]
    ludo_board(c, (W - bsize) / 2, by, bsize, tokens=toks, ghosts=ghosts, labels=not small)
    bx = (W - bsize) / 2
    if state == "hop":
        pts = [cell_xy(TRACK[k], bx, by, bsize) for k in range(3, 8)]
        d = f"M{pts[0][0]:.1f} {pts[0][1]:.1f}" + "".join(f" Q{(a[0] + b[0]) / 2:.1f} {(a[1] + b[1]) / 2 - s * .8:.1f} {b[0]:.1f} {b[1]:.1f}" for a, b in zip(pts, pts[1:]))
        c.path(d, sw=1.6, dash="3 3")
    if state == "capture":
        vx, vy = cell_xy(TRACK[33], bx, by, bsize); yx, yy = bx + 11 * s, by + 4 * s  # Yellow yard slot
        c.path(f"M{vx:.1f} {vy:.1f} Q{vx + s * 2:.1f} {vy - s * 3:.1f} {yx:.1f} {yy:.1f}", sw=1.8, dash="4 4")
        c.token(vx + s * 1.2, vy - s * 1.8, s * .34, "yellow")
        for k in range(5):
            c.circle(vx + s * (.5 - k * .25), vy + s * (.4 - (k % 2) * .5), s * .12, sw=1.2)
    if state == "home":
        cx, cy = bx + 7.5 * s, by + 7.5 * s
        for k in range(6):
            a = k * math.pi / 3
            c.line(cx + s * .6 * math.cos(a), cy + s * .6 * math.sin(a), cx + s * 1.1 * math.cos(a), cy + s * 1.1 * math.sin(a), sw=1.6)
    c.layer()
    sy = y2 + ch + (14 if not small else 10)
    status = {"await": "Your turn, Asha. Tap your dice", "rolling": "Rolling…", "moves": "Rolled 6. Pick a token",
              "hop": "Asha moves 4", "capture": "Captured Yellow!", "home": "Token home! Roll again",
              "extra": "Rolled a 6. Roll again!", "forfeit": "Three 6s. Turn over", "nomoves": "No moves. Turn passes",
              "auto": "Only move. Playing in 1.1 s", "ai": "Bot Mo is thinking…", "reconnect": "Ravi is reconnecting… 0:45",
              "stack": "Tap moves the first. Hold to choose"}[state]
    c.rect(10, sy, W - 20, 38 if not small else 30, 12, fill=c.fill, sw=1.4)
    c.text(W / 2, sy + (26 if not small else 21), status, 18 if not small else 14, "middle")
    if state == "extra":
        ribbon(c, W / 2, by + bsize / 2, "Extra roll!")
    if state == "forfeit":
        c.rect(W / 2 - 120, by + bsize / 2 - 50, 240, 100, 18, fill=c.paper, sw=2.4)
        for k in range(3):
            c.dice(W / 2 - 96 + k * 66, by + bsize / 2 - 30, 60, 6, sw=1.8)
        c.line(W / 2 - 110, by + bsize / 2 + 40, W / 2 + 110, by + bsize / 2 - 40, sw=3)
    if state == "nomoves":
        c.rect(W / 2 - 110, by + bsize / 2 - 30, 220, 60, 16, fill=c.paper, sw=2.4)
        c.text(W / 2, by + bsize / 2 + 9, "No moves", 26, "middle")
    if state == "auto":
        tx, ty2 = cell_xy(TRACK[30], bx, by, bsize)
        c.circle(tx, ty2, s * .75, sw=3, dash="14 6")
        c.rect(tx - 60, ty2 - s * 2.2, 120, 30, 15, fill=c.paper, sw=1.8)
        c.text(tx, ty2 - s * 2.2 + 21, "auto in 1.1 s", 15, "middle")
    if state == "ai":
        x = gx + cw + 10
        c.rect(x + 20, y1 + ch + 2, 70, 24, 12, fill=c.paper, sw=1.6)
        for k in range(3):
            c.circle(x + 40 + k * 14, y1 + ch + 14, 3.5, fill=c.ink, sw=0)
    if state == "stack":
        tx, ty2 = cell_xy(TRACK[13], bx, by, bsize)
        c.rect(tx - 20, ty2 - 132, 150, 112, 16, fill=c.paper, sw=2.4)
        c.path(f"M{tx:.1f} {ty2 - 20:.1f} l10 12 l10 -12", fill=c.paper, sw=2)
        for k in range(2):
            yy = ty2 - 120 + k * 50
            c.token(tx + 6, yy + 20, 13, "red", movable=True)
            c.text(tx + 30, yy + 26, ("Token 1 → 17", "Token 3 → 17")[k], 16)
        c.text(tx + 55, ty2 - 136, "long-press picker", 13, "middle", font="body", fill=c.muted)


def ludo_results(c, online=False):
    statusbar(c)
    if not online:
        c.confetti(20, 50, 350, 200, seed=8)
    c.text(195, 110, "Lena wins!" if not online else "Game over", 40, "middle")
    c.icon("crown", 195, 148, 34)
    rows = [("Lena", "green", "1st", "4 home"), ("Asha", "red", "2nd", "4 home"), ("Bot Mo", "yellow", "3rd", "4 home"),
            ("Ravi", "blue", "4th", "3 home")]
    if online:
        rows = [("Asha", "red", "1st", "4 home"), ("Lena", "green", "2nd", "2 home"), ("Ravi", "blue", "3rd", "Left the game")]
    for i, (nm, col, rk, v) in enumerate(rows):
        y = 180 + i * 64
        c.rect(24, y, 342, 54, 14, fill=c.fill if i == 0 else c.paper, sw=2.2 if i == 0 else 1.6, dash="5 4" if "Left" in v else None)
        c.circle(54, y + 27, 17, sw=2); c.text(54, y + 33, rk[0], 18, "middle")
        c.token(94, y + 27, 12, col)
        c.text(118, y + 34, nm, 19, font="body", weight=700)
        c.text(350, y + 34, v, 15, "end", font="body", fill=c.muted)
    y = 180 + len(rows) * 64 + 16
    c.text(24, y + 20, "Your game", 20)
    st = [("Tokens home", "4"), ("Captures made", "5"), ("Times captured", "2"), ("Sixes rolled", "9")]
    for i, (k, v) in enumerate(st):
        yy = y + 34 + i * 40
        c.text(24, yy + 22, k, 17, font="body"); c.text(366, yy + 22, v, 18, "end", font="body", weight=700)
        c.line(24, yy + 34, 366, yy + 34, sw=1, stroke=c.fill2)
    c.button(24, 664, 342, 56, "Play Again" if not online else "Back to Lobby", "primary", 20, icon="refresh")
    c.button(24, 732, 166, 52, "Game Menu", "secondary", 17)
    c.button(200, 732, 166, 52, "Hub", "secondary", 17, icon="home")


def ludo_setup(c, players=2):
    statusbar(c); topbar(c, "Player Setup", sub="Ludo")
    c.text(24, 140, "Players", 18); c.seg(126, 116, 240, 40, ["2", "3", "4"], players - 2, 17)
    seats = ([("Asha", "red", "human", None), ("Ravi", "yellow", "human", None)] if players == 2 else
             [("Asha", "red", "human", None), ("Ravi", "blue", "human", None), ("Bot Mo", "yellow", "ai", "Normal"), ("Bot Kit", "green", "ai", "Easy")])
    for i, s in enumerate(seats):
        seat_row(c, 172 + i * 84, i, *s)
    y = 172 + len(seats) * 84 + 8
    c.text(24, y + 22, "Colours", 18)
    for i, col in enumerate(("red", "blue", "yellow", "green")):
        c.token(140 + i * 52, y + 16, 16, col, selected=col in [s[1] for s in seats])
    c.text(24, y + 66, "2 players sit opposite (Red + Yellow)" if players == 2 else "Turn order: Red → Blue → Yellow → Green",
           14, font="body", fill=c.muted)
    c.button(24, 766, 342, 56, "Start game", "primary", 20, icon="play")


# ------------------------------------------------------------------ multiplayer
def lobby(c, game="snl", full=False, client=False):
    statusbar(c); topbar(c, "Lobby" if not client else "Joined", left="close")
    c.rect(24, 116, 342, 150, 18, sw=2)
    c.img(36, 128, 126, 126, 8, "QR")
    c.text(178, 152, "Room", 15, font="body", fill=c.muted)
    c.text(178, 192, "K7PQ", 40)
    c.text(178, 220, "192.168.1.23:47821", 14, font="body")
    c.text(178, 242, "hotspot 192.168.43.1", 13, font="body", fill=c.muted)
    summary = "Snakes & Ladders · Classic Sunshine · 7 snakes" if game == "snl" else "Ludo · classic rules · timer 30 s"
    c.rect(24, 280, 342, 64, 14, fill=c.fill, sw=1.4)
    c.text(40, 306, summary if len(summary) < 40 else "Snakes & Ladders", 16, font="body", weight=700)
    c.text(40, 330, "Classic Sunshine · 7 snakes · extra roll on 6" if game == "snl" else "Capture on · timer 30 s", 14, font="body", fill=c.muted)
    if client:
        c.icon("lock", 346, 312, 16)
    seats = [("Asha (host)", "red", "ready"), ("Ravi", "blue", "ready" if full else "connected"),
             ("Bot Mo", "yellow", "AI"), ("Empty seat", "green", "empty")]
    if full:
        seats[3] = ("Lena", "green", "ready")
    if client:
        seats[1] = ("Ravi (you)", "blue", "not ready")
    for i, (nm, col, st) in enumerate(seats):
        y = 358 + i * 62
        c.rect(24, y, 342, 52, 14, sw=1.6, dash="5 4" if st == "empty" else None)
        c.token(50, y + 26, 13, col, ghost=st == "empty")
        c.text(74, y + 32, nm, 17, font="body", weight=700 if st != "empty" else 400, fill=c.muted if st == "empty" else None)
        lab = {"ready": "Ready ✓", "connected": "Not ready", "AI": "AI · Normal", "empty": "Add AI", "not ready": "Not ready"}[st]
        c.chip(366 - len(lab) * 7 - 30, y + 12, lab, 13, filled=st == "ready")
    if not client:
        c.text(24, 626, "Replace leavers with AI", 17, font="body"); c.toggle(316, 606, False)
        c.button(24, 660, 342, 56, "Start", "primary" if full else "disabled", 20, icon="play")
        c.text(195, 744, "Start when every player is ready" if not full else "Everyone is ready", 14, "middle", font="body", fill=c.muted)
    else:
        c.button(24, 660, 342, 56, "I'm ready", "primary", 20, icon="check")
        c.text(195, 744, "The host sets the rules", 14, "middle", font="body", fill=c.muted)


def join(c, mode="list"):
    statusbar(c); topbar(c, "Join Wi-Fi Game")
    c.seg(24, 116, 342, 44, ["Nearby", "Address", "Scan QR"], {"list": 0, "manual": 1, "qr": 2}[mode], 16)
    if mode == "list":
        c.text(24, 194, "Rooms on this network", 18)
        c.icon("refresh", 350, 188, 20)
        rooms = [("snake", "Snakes & Ladders", "K7PQ · Asha · 2 seats free", True),
                 ("dice", "Ludo", "M3XW · Pixel 7 · 1 seat free", False),
                 ("dice", "Ludo", "R8TB · full", False)]
        for i, (ic, g, d, ok) in enumerate(rooms):
            y = 212 + i * 84
            c.rect(24, y, 342, 72, 16, sw=2 if ok else 1.6, dash=None if i < 2 else "5 4")
            c.icon(ic, 54, y + 36, 26)
            c.text(84, y + 32, g, 19)
            c.text(84, y + 56, d, 14, font="body", fill=c.muted)
            c.chip(286, y + 22, "Join" if i < 2 else "Full", 14, filled=i < 2)
        c.text(195, 486, "You chose Ludo: Snakes & Ladders rooms open", 13, "middle", font="body", fill=c.muted)
        c.text(195, 504, "a Wrong game prompt", 13, "middle", font="body", fill=c.muted)
        c.para(60, 560, 270, 2)
    elif mode == "manual":
        c.text(24, 200, "Host address", 18)
        c.field(24, 214, 342, 56, "192.168.1.300", None, error=True)
        c.icon("info", 40, 300, 18)
        c.text(58, 306, "Number 300 is too big. Each part is 0–255.", 15, font="body")
        c.text(24, 352, "Accepted formats", 17)
        for i, ex in enumerate(("192.168.1.5", "192.168.1.5:47821", "ws://192.168.1.5:47821",
                                "diceparty://…/ABCD?g=ludo", "pixel-7.local:47821")):
            c.text(40, 384 + i * 28, ex, 15, font="body", fill=c.muted)
        c.button(24, 560, 342, 56, "Connect", "disabled", 20, icon="link")
        c.text(24, 650, "Last host: 192.168.1.23:47821", 14, font="body", fill=c.muted)
    else:
        c.rect(24, 180, 342, 420, 20, fill=c.fill2, sw=2)
        for (x, y, dx, dy) in ((84, 270, 1, 1), (306, 270, -1, 1), (84, 510, 1, -1), (306, 510, -1, -1)):
            c.path(f"M{x} {y + dy * 40} L{x} {y} L{x + dx * 40} {y}", sw=5)
        c.icon("camera", 195, 390, 40)
        c.text(195, 640, "Point at the QR on the host's lobby", 16, "middle", font="body")
        c.text(195, 666, "Needs camera permission", 13, "middle", font="body", fill=c.muted)
        c.button(24, 700, 342, 52, "Type an address instead", "secondary", 17, icon="link")


def conn_dialog(c, kind):
    if kind in ("reconnecting", "hostlost"):
        ludo_game(c, "await")
    else:
        join(c, "list")
    dim_overlay(c)
    if kind == "reconnecting":
        dialog(c, 300, 260, "Reconnecting…", 2, "wifi_off", (("Leave game", "danger"),),
               extra=lambda y: c.text(195, y + 26, "0:38 left to rejoin", 20, "middle"))
    elif kind == "hostlost":
        dialog(c, 300, 270, "Host lost, waiting…", 2, "wifi_off", (("Back to Hub", "secondary"),),
               extra=lambda y: c.text(195, y + 26, "Returning to the Hub in 0:31", 17, "middle"))
    elif kind == "full":
        dialog(c, 300, 250, "Room full", 2, "lock", (("Find another room", "primary"),))
    else:
        dialog(c, 150, 250, "Wrong game", 2, "dice", (("Cancel", "secondary"), ("Switch to S&L", "primary")))
        dialog(c, 440, 250, "Update needed", 2, "info", (("OK", "primary"),),
               extra=lambda y: c.text(195, y + 14, "Host 1.1.0 · you 1.0.0", 15, "middle", font="body"))


# ------------------------------------------------------------------ tablet
def tablet_hub(c, W=800, H=1280):
    statusbar(c, W)
    c.rect(24, 54, 220, 56, 28, sw=1.6); c.avatar(54, 82, 22); c.text(86, 90, "Asha", 22)
    c.rect(W - 80, 54, 56, 56, 16, sw=1.6); c.icon("gear", W - 52, 82, 26)
    c.text(W / 2, 200, "Pick a game", 44, "middle")
    for i, (t, k) in enumerate((("Snakes & Ladders", "snl"), ("Ludo", "ludo"))):
        x = 60 + i * 350
        c.rect(x, 250, 330, 520, 26, fill=c.paper, sw=2.4)
        c.img(x + 20, 270, 290, 290, 16, "mini board")
        c.text(x + 24, 604, t, 30)
        c.para(x + 24, 630, 260, 2)
        c.button(x + 24, 680, 282, 60, "Play", "primary", 22, icon="play")
    c.button(60, 820, 330, 64, "Stats", icon="stats")
    c.button(410, 820, 330, 64, "How to Play", icon="book")


def tablet_ludo(c, W=800, H=1280):
    statusbar(c, W)
    c.rect(24, 50, 56, 56, 14, sw=1.6); c.icon("pause", 52, 78, 24)
    c.text(W / 2, 88, "Ludo", 30, "middle")
    bsize = 640; bx = 80; by = 260
    cw = 300; ch = 96
    for nm, col, x, y, right in (("Ravi", "blue", 80, 140, False), ("Bot Mo", "yellow", W - 80 - cw, 140, True),
                                 ("Asha", "red", 80, by + bsize + 24, False), ("Lena", "green", W - 80 - cw, by + bsize + 24, True)):
        ludo_card(c, x, y, cw, ch, nm, col, 1, "active" if col == "red" else "inactive", .62 if col == "red" else None,
                  dice=(5, "ready") if col == "red" else None, right=right, ai=col == "yellow")
    ludo_board(c, bx, by, bsize, tokens=LUDO_TOKENS)
    c.rect(80, by + bsize + 140, 640, 50, 14, fill=c.fill, sw=1.4)
    c.text(W / 2, by + bsize + 174, "Your turn, Asha. Tap your dice", 22, "middle")
