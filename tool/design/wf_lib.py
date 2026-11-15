"""Drawing primitives for design/wireframes.html: hand-drawn ink on paper, inline SVG."""
import html
import json
import math
import os

from design_snl_boards import catmull, centre

INK = "#23272B"
MUTED = "#5C666F"
BLUE = "#1C6DD0"
RED = "#D92D20"
RULE = "#C6CED5"
FILL = "#EEF1F3"
FILL2 = "#D9DEE2"


def esc(s):
    return html.escape(str(s), quote=True)


def f(v):
    return f"{v:.1f}".rstrip("0").rstrip(".")


class Canvas:
    """Collects shapes (wobble filter) and text (crisp) in ordered layers."""

    def __init__(self, dark=False):
        self.out, self.sh, self.tx = [], [], []
        self.dark = dark
        self.ink = "#F4F6F8" if dark else INK
        self.paper = INK if dark else "#FFFFFF"
        self.fill = "#353B41" if dark else FILL
        self.fill2 = "#4A525A" if dark else FILL2
        self.muted = "#AEB6BD" if dark else MUTED

    # layering -----------------------------------------------------------
    def layer(self):
        if self.sh:
            self.out.append('<g filter="url(#wob)">' + "".join(self.sh) + "</g>")
        if self.tx:
            self.out.append("<g>" + "".join(self.tx) + "</g>")
        self.sh, self.tx = [], []

    def render(self):
        self.layer()
        return "".join(self.out)

    def _st(self, stroke, sw, dash, fill):
        stroke = self.ink if stroke is None else stroke
        fill = "none" if fill is None else fill
        d = f' stroke-dasharray="{dash}"' if dash else ""
        return f'fill="{fill}" stroke="{stroke}" stroke-width="{f(sw)}" stroke-linecap="round" stroke-linejoin="round"{d}'

    # shapes ---------------------------------------------------------------
    def rect(self, x, y, w, h, r=10, fill=None, sw=2, dash=None, stroke=None, crisp=False):
        el = f'<rect x="{f(x)}" y="{f(y)}" width="{f(w)}" height="{f(h)}" rx="{f(r)}" {self._st(stroke, sw, dash, fill)}/>'
        (self.tx if crisp else self.sh).append(el)

    def circle(self, cx, cy, r, fill=None, sw=2, stroke=None, dash=None, crisp=False):
        el = f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(r)}" {self._st(stroke, sw, dash, fill)}/>'
        (self.tx if crisp else self.sh).append(el)

    def line(self, x1, y1, x2, y2, sw=2, stroke=None, dash=None, crisp=False):
        el = f'<line x1="{f(x1)}" y1="{f(y1)}" x2="{f(x2)}" y2="{f(y2)}" {self._st(stroke, sw, dash, None)}/>'
        (self.tx if crisp else self.sh).append(el)

    def path(self, d, fill=None, sw=2, stroke=None, dash=None, extra="", crisp=False):
        el = f'<path d="{d}" {self._st(stroke, sw, dash, fill)}{extra}/>'
        (self.tx if crisp else self.sh).append(el)

    def text(self, x, y, s, size=16, anchor="start", font="hand", weight=400, fill=None, italic=False):
        cls = "h" if font == "hand" else "b"
        fill = self.ink if fill is None else fill
        w = f' font-weight="{weight}"' if weight != 400 else ""
        it = ' font-style="italic"' if italic else ""
        self.tx.append(f'<text x="{f(x)}" y="{f(y)}" class="{cls}" font-size="{f(size)}" text-anchor="{anchor}" fill="{fill}"{w}{it}>{esc(s)}</text>')

    # placeholders ---------------------------------------------------------
    def img(self, x, y, w, h, r=8, label=None):
        self.rect(x, y, w, h, r)
        self.line(x + 6, y + 6, x + w - 6, y + h - 6, sw=1.4, stroke=self.muted)
        self.line(x + w - 6, y + 6, x + 6, y + h - 6, sw=1.4, stroke=self.muted)
        if label:
            self.rect(x + w / 2 - len(label) * 4.2 - 8, y + h / 2 - 13, len(label) * 8.4 + 16, 26, 6, fill=self.paper, sw=0, stroke=self.paper, crisp=True)
            self.text(x + w / 2, y + h / 2 + 6, label, 16, "middle")

    def squig(self, x, y, w, amp=2.4, period=11, sw=1.6, stroke=None):
        n = max(2, int(w / period)); step = w / n
        d = f"M{f(x)} {f(y)}"
        for i in range(n):
            d += f" q{f(step / 2)} {f(-amp if i % 2 else amp)} {f(step)} 0"
        self.path(d, sw=sw, stroke=self.muted if stroke is None else stroke)

    def para(self, x, y, w, n=2, gap=13):
        for i in range(n):
            self.squig(x, y + i * gap, w * (0.62 if i == n - 1 and n > 1 else 1))

    # controls -------------------------------------------------------------
    def button(self, x, y, w, h, label, kind="secondary", size=19, icon=None):
        fill = {"primary": self.fill2, "danger": None, "disabled": None}.get(kind, self.paper)
        dash = "5 5" if kind == "disabled" else None
        sw = 2.6 if kind == "primary" else 2
        self.rect(x, y, w, h, min(h / 2, 14), fill=fill, sw=sw, dash=dash)
        col = self.muted if kind == "disabled" else self.ink
        tx = x + w / 2
        if icon:
            self.icon(icon, x + 30, y + h / 2, 22)
        self.text(tx, y + h / 2 + size * .34, label, size, "middle", fill=col,
                  weight=700 if kind == "danger" else 400)
        if kind == "danger":
            self.rect(x + 3, y + 3, w - 6, h - 6, min(h / 2, 12) - 2, sw=1.2, dash="2 4")

    def chip(self, x, y, label, size=14, filled=False, icon=None):
        w = len(label) * size * .5 + 22 + (18 if icon else 0)
        self.rect(x, y, w, size + 12, (size + 12) / 2, fill=self.fill2 if filled else self.paper, sw=1.6)
        if icon:
            self.icon(icon, x + 15, y + (size + 12) / 2, 14)
        self.text(x + (w + (18 if icon else 0)) / 2, y + size + 3, label, size, "middle")
        return w

    def toggle(self, x, y, on):
        self.rect(x, y, 50, 28, 14, fill=self.fill2 if on else self.paper, sw=2)
        self.circle(x + (36 if on else 14), y + 14, 10, fill=self.ink if on else self.paper)

    def seg(self, x, y, w, h, labels, active, size=16):
        self.rect(x, y, w, h, h / 2, sw=2)
        cw = w / len(labels)
        for i, lab in enumerate(labels):
            if i == active:
                self.rect(x + i * cw + 3, y + 3, cw - 6, h - 6, (h - 6) / 2, fill=self.fill2, sw=1.6)
            elif i:
                self.line(x + i * cw, y + 8, x + i * cw, y + h - 8, sw=1.2, stroke=self.muted)
            self.text(x + i * cw + cw / 2, y + h / 2 + size * .34, lab, size, "middle")

    def stepper(self, x, y, value, lo=False, hi=False, w=150, h=48):
        self.rect(x, y, w, h, 12, sw=2)
        for i, (sym, dis) in enumerate((("−", lo), ("+", hi))):
            bx = x + (0 if i == 0 else w - h)
            self.rect(bx + 4, y + 4, h - 8, h - 8, 10, fill=None if dis else self.fill2, sw=1.6, dash="4 4" if dis else None)
            self.text(bx + h / 2, y + h / 2 + 9, sym, 26, "middle", fill=self.muted if dis else self.ink)
        self.text(x + w / 2, y + h / 2 + 9, str(value), 26, "middle")

    def field(self, x, y, w, h, value, hint=None, error=False):
        self.rect(x, y, w, h, 10, sw=2.6 if error else 2, dash="6 4" if error else None)
        if value:
            self.text(x + 14, y + h / 2 + 6, value, 18, font="body")
        if hint:
            self.text(x + w - 12, y + h / 2 + 5, hint, 13, "end", fill=self.muted)

    def avatar(self, cx, cy, r, fill=None):
        self.circle(cx, cy, r, fill=self.paper if fill is None else fill)
        self.circle(cx, cy - r * .22, r * .32, sw=1.5)
        self.path(f"M{f(cx - r * .55)} {f(cy + r * .62)} q{f(r * .55)} {f(-r * .62)} {f(r * 1.1)} 0", sw=1.5)

    def ring(self, cx, cy, r, frac, sw=4):
        """Turn-timer ring; frac = remaining fraction."""
        self.circle(cx, cy, r, sw=1, stroke=self.muted, dash="2 3")
        a = -math.pi / 2 + 2 * math.pi * frac
        large = 1 if frac > .5 else 0
        x2, y2 = cx + r * math.cos(a), cy + r * math.sin(a)
        if frac >= .999:
            self.circle(cx, cy, r, sw=sw)
        else:
            self.path(f"M{f(cx)} {f(cy - r)} A{f(r)} {f(r)} 0 {large} 1 {f(x2)} {f(y2)}", sw=sw)

    def dice(self, x, y, s, face, fill=None, sw=2.4, dash=None):
        self.rect(x, y, s, s, s * .2, fill=self.paper if fill is None else fill, sw=sw, dash=dash)
        p = {1: [(1, 1)], 2: [(0, 0), (2, 2)], 3: [(0, 0), (1, 1), (2, 2)], 4: [(0, 0), (2, 0), (0, 2), (2, 2)],
             5: [(0, 0), (2, 0), (1, 1), (0, 2), (2, 2)], 6: [(0, 0), (2, 0), (0, 1), (2, 1), (0, 2), (2, 2)]}[face]
        for i, j in p:
            self.circle(x + s * (.25 + .25 * i), y + s * (.25 + .25 * j), s * .08, fill=self.ink, sw=0)

    def token(self, cx, cy, r, color, ghost=False, movable=False, selected=False):
        dash = "3 3" if ghost else None
        if movable:
            self.circle(cx, cy, r * 1.45, sw=1.6, dash="3 3")
        if selected:
            self.circle(cx, cy, r * 1.3, sw=2.4)
        self.circle(cx, cy, r, fill=None if ghost else self.paper, sw=2, dash=dash)
        k = r * .5
        stroke = self.muted if ghost else self.ink
        fill = "none" if ghost else self.ink
        if color == "red":
            self.circle(cx, cy, k * .8, fill=fill, sw=1.2, stroke=stroke)
        elif color == "blue":
            self.rect(cx - k * .75, cy - k * .75, k * 1.5, k * 1.5, 1, fill=fill, sw=1.2, stroke=stroke)
        elif color == "yellow":
            self.path(f"M{f(cx)} {f(cy - k)} L{f(cx + k * .95)} {f(cy + k * .7)} L{f(cx - k * .95)} {f(cy + k * .7)} Z", fill=fill, sw=1.2, stroke=stroke)
        else:
            self.path(star_path(cx, cy, k * 1.05, k * .45), fill=fill, sw=1.2, stroke=stroke)

    def confetti(self, x, y, w, h, n=26, seed=3):
        import random
        rnd = random.Random(seed)
        for _ in range(n):
            px, py, a = x + rnd.random() * w, y + rnd.random() * h, rnd.random() * 180
            kind = rnd.randrange(3)
            if kind == 0:
                self.path(f"M{f(px)} {f(py)} l7 3 l-2 4 l-7 -3 Z", sw=1.3,
                          extra=f' transform="rotate({a:.0f} {f(px)} {f(py)})"')
            elif kind == 1:
                self.circle(px, py, 3, sw=1.3)
            else:
                self.path(f"M{f(px)} {f(py)} q4 -6 8 0", sw=1.5, extra=f' transform="rotate({a:.0f} {f(px)} {f(py)})"')

    # icons ----------------------------------------------------------------
    def icon(self, name, cx, cy, s=24, stroke=None):
        k = s / 24; x0, y0 = cx - 12 * k, cy - 12 * k
        P = lambda d: self.path(d, sw=2 * min(1, k + .2), stroke=stroke,
                                extra=f' transform="translate({f(x0)} {f(y0)}) scale({k:.3f})"')
        if name == "gear":
            P("M12 8a4 4 0 1 0 0.01 0M12 2v3M12 19v3M2 12h3M19 12h3M5 5l2 2M17 17l2 2M19 5l-2 2M7 17l-2 2")
        elif name == "pause":
            P("M8 5v14M16 5v14")
        elif name == "back":
            P("M15 4l-8 8 8 8")
        elif name == "close":
            P("M5 5l14 14M19 5L5 19")
        elif name == "check":
            P("M4 12l5 5L20 6")
        elif name == "play":
            P("M7 4l13 8-13 8Z")
        elif name == "wifi":
            P("M2 9a15 15 0 0 1 20 0M5 13a10 10 0 0 1 14 0M8.5 16.5a5 5 0 0 1 7 0M12 20h.01")
        elif name == "wifi_off":
            P("M2 9a15 15 0 0 1 20 0M5 13a10 10 0 0 1 14 0M8.5 16.5a5 5 0 0 1 7 0M3 3l18 18")
        elif name == "hotspot":
            P("M12 12h.01M8 16a6 6 0 0 1 0-8M16 8a6 6 0 0 1 0 8M5 19a10 10 0 0 1 0-14M19 5a10 10 0 0 1 0 14")
        elif name == "qr":
            P("M3 3h7v7H3zM14 3h7v7h-7zM3 14h7v7H3zM14 14h3v3h-3zM18 18h3v3h-3zM18 14h3M14 18v3")
        elif name == "link":
            P("M10 14a4 4 0 0 0 6 0l3-3a4 4 0 0 0-6-6l-1 1M14 10a4 4 0 0 0-6 0l-3 3a4 4 0 0 0 6 6l1-1")
        elif name == "dice":
            P("M4 4h16v16H4zM9 9h.01M15 15h.01M15 9h.01M9 15h.01")
        elif name == "crown":
            P("M3 18h18M4 16L3 7l5 4 4-6 4 6 5-4-1 9Z")
        elif name == "lock":
            P("M5 11h14v10H5zM8 11V7a4 4 0 0 1 8 0v4")
        elif name == "trophy":
            P("M7 4h10v5a5 5 0 0 1-10 0ZM7 6H4a3 3 0 0 0 3 4M17 6h3a3 3 0 0 1-3 4M12 14v4M8 21h8")
        elif name == "sound":
            P("M4 9h4l5-4v14l-5-4H4ZM16 9a4 4 0 0 1 0 6M18.5 6.5a8 8 0 0 1 0 11")
        elif name == "music":
            P("M9 18V5l11-2v13M9 18a3 3 0 1 1-3-3 3 3 0 0 1 3 3M20 16a3 3 0 1 1-3-3 3 3 0 0 1 3 3")
        elif name == "haptics":
            P("M8 3h8v18H8zM4 8v8M20 8v8M1 10v4M23 10v4")
        elif name == "sun":
            P("M12 8a4 4 0 1 0 .01 0M12 2v2M12 20v2M2 12h2M20 12h2M5 5l1.5 1.5M17.5 17.5L19 19M19 5l-1.5 1.5M6.5 17.5L5 19")
        elif name == "moon":
            P("M20 14A8 8 0 1 1 10 4a6 6 0 0 0 10 10Z")
        elif name == "ai":
            P("M5 8h14v11H5zM12 4v4M9 13h.01M15 13h.01M9 16h6M2 12v3M22 12v3")
        elif name == "human":
            P("M12 4a3.5 3.5 0 1 0 .01 0M5 21a7 7 0 0 1 14 0")
        elif name == "snake":
            P("M4 18c4 0 4-5 8-5s4 5 8 5M18 9a2 2 0 1 0 .01 0M4 18c-1 0-2-1-2-2")
        elif name == "ladder":
            P("M7 3v18M17 3v18M7 7h10M7 12h10M7 17h10")
        elif name == "stats":
            P("M4 20V10M10 20V4M16 20v-7M22 20H2")
        elif name == "info":
            P("M12 3a9 9 0 1 0 .01 0M12 11v6M12 7.5h.01")
        elif name == "home":
            P("M3 11l9-8 9 8M5 9v12h14V9")
        elif name == "refresh":
            P("M20 12a8 8 0 1 1-2.3-5.6M20 4v5h-5")
        elif name == "profile":
            P("M12 3a9 9 0 1 0 .01 0M12 8a3 3 0 1 0 .01 0M6.5 18a6 6 0 0 1 11 0")
        elif name == "book":
            P("M4 4h7a2 2 0 0 1 2 2v14a2 2 0 0 0-2-2H4ZM20 4h-7M20 4v14h-7")
        elif name == "rules":
            P("M5 3h14v18H5zM8 8h8M8 12h8M8 16h5")
        elif name == "host":
            P("M3 4h18v12H3zM8 20h8M12 16v4")
        elif name == "join":
            P("M10 17l5-5-5-5M15 12H3M14 3h6v18h-6")
        elif name == "camera":
            P("M3 7h4l2-3h6l2 3h4v13H3zM12 10a3.5 3.5 0 1 0 .01 0")

    # annotation (pencil blue, red callouts) ------------------------------------
    def callout(self, x, y, n):
        self.tx.append(f'<circle cx="{f(x)}" cy="{f(y)}" r="13" fill="{RED}"/>'
                       f'<text x="{f(x)}" y="{f(y + 6)}" class="h" font-size="18" text-anchor="middle" fill="#fff">{n}</text>')

    def note(self, x, y, text, to=None, anchor="start", size=17, bend=30):
        lines = text.split("\n")
        for i, ln in enumerate(lines):
            self.tx.append(f'<text x="{f(x)}" y="{f(y + i * (size + 2))}" class="h" font-size="{size}" text-anchor="{anchor}" fill="{BLUE}">{esc(ln)}</text>')
        if to:
            sx = x + (6 if anchor == "start" else -6 if anchor == "end" else 0)
            sy = y + (len(lines) - 1) * (size + 2) / 2 - size * .3
            if anchor == "start":
                sx = x - 6
            elif anchor == "end":
                sx = x + 6
            mx, my = (sx + to[0]) / 2, (sy + to[1]) / 2 - bend
            self.tx.append(f'<path d="M{f(sx)} {f(sy)} Q{f(mx)} {f(my)} {f(to[0])} {f(to[1])}" fill="none" stroke="{BLUE}" stroke-width="1.6" stroke-linecap="round" marker-end="url(#arr)"/>')

    def dim(self, x1, y1, x2, y2, label, size=15):
        self.tx.append(f'<line x1="{f(x1)}" y1="{f(y1)}" x2="{f(x2)}" y2="{f(y2)}" stroke="{BLUE}" stroke-width="1.4" marker-start="url(#tick)" marker-end="url(#tick)"/>')
        mx, my = (x1 + x2) / 2, (y1 + y2) / 2
        if abs(y2 - y1) > abs(x2 - x1):
            self.tx.append(f'<text x="{f(mx + 6)}" y="{f(my + 5)}" class="h" font-size="{size}" fill="{BLUE}">{esc(label)}</text>')
        else:
            self.tx.append(f'<text x="{f(mx)}" y="{f(my - 6)}" class="h" font-size="{size}" text-anchor="middle" fill="{BLUE}">{esc(label)}</text>')


def star_path(cx, cy, ro, ri, n=5):
    pts = []
    for i in range(n * 2):
        r = ro if i % 2 == 0 else ri
        a = -math.pi / 2 + i * math.pi / n
        pts.append(f"{f(cx + r * math.cos(a))} {f(cy + r * math.sin(a))}")
    return "M" + " L".join(pts) + " Z"


# ---------------------------------------------------------------- frames
def phone(draw, W=390, H=844, dark=False, pad=(30, 30, 30, 30), annotate=None, tablet=False):
    """Return an <svg> with a device frame; draw(c) paints the screen in 0..W x 0..H."""
    c = Canvas(dark)
    l, t, r, b = pad
    bez = 16 if not tablet else 26
    c.rect(-bez, -bez, W + 2 * bez, H + 2 * bez, 58 if not tablet else 40, fill=INK if dark else "#FFFFFF", sw=3, stroke=INK)
    c.rect(0, 0, W, H, 44 if not tablet else 18, fill=c.paper, sw=1.4, stroke=INK if not dark else "#5C666F")
    c.layer()
    draw(c)
    c.layer()
    if tablet:
        c.circle(W / 2, -bez / 2, 4, fill=INK, sw=0, stroke=INK)
    elif W >= 360:
        c.rect(W / 2 - 62, 8, 124, 30, 15, fill=INK, sw=0, stroke=INK, crisp=True)
    c.rect(W / 2 - 66, H - 12, 132, 5, 3, fill=c.ink, sw=0, crisp=True)
    if annotate:
        annotate(c)
    vb = f"{-l - bez} {-t - bez} {W + l + r + 2 * bez} {H + t + b + 2 * bez}"
    return f'<svg viewBox="{vb}" role="img" xmlns="http://www.w3.org/2000/svg">{c.render()}</svg>'


def plain(draw, w, h, dark=False):
    c = Canvas(dark)
    draw(c)
    return f'<svg viewBox="0 0 {w} {h}" role="img" xmlns="http://www.w3.org/2000/svg">{c.render()}</svg>'


def statusbar(c, W=390, small=False):
    y = 30 if not small else 18
    c.text(30 if not small else 16, y, "9:41", 15 if not small else 12, font="body", weight=700)
    x = W - (34 if not small else 18)
    c.rect(x - 22, y - 11, 22, 11, 3, sw=1.4, crisp=True)
    c.rect(x - 20, y - 9, 14, 7, 1, fill=c.ink, sw=0, crisp=True)
    c.icon("wifi", x - 40, y - 5, 14)


# ---------------------------------------------------------------- S&L board
BOARD_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "design", "boards")


def load_board(bid):
    with open(os.path.join(BOARD_DIR, bid + ".json")) as fh:
        return json.load(fh)


def sq_xy(n, x, y, size):
    u, v = centre(n)
    return x + u * size, y + v * size


def snl_board(c, x, y, size, board, n=7, labels=False, tokens=(), show_inactive=False, numbers=True,
              hide=(), start_pad=True, ghost=None):
    s = size / 10
    c.rect(x - s * .18, y - s * .18, size + s * .36, size + s * .36, s * .25, sw=3)
    d = ""
    for sq in range(1, 101):
        r = (sq - 1) // 10; cc = (sq - 1) % 10; col = cc if r % 2 == 0 else 9 - cc
        if (r + col) % 2 == 0:
            d += f"M{f(x + col * s)} {f(y + (9 - r) * s)}h{f(s)}v{f(s)}h{f(-s)}Z"
    c.path(d, fill=c.fill, sw=0, stroke="none")
    g = ""
    for i in range(11):
        g += f"M{f(x)} {f(y + i * s)}h{f(size)}M{f(x + i * s)} {f(y)}v{f(size)}"
    c.path(g, sw=1, stroke=c.muted)
    if numbers:
        for sq in range(1, 101):
            cx, cy = sq_xy(sq, x, y, size)
            c.text(cx, cy + s * .14, sq, s * .36, "middle", font="body", weight=700, fill=c.muted)
    # party popper on 100
    cx, cy = sq_xy(100, x, y, size)
    c.path(f"M{f(cx - s * .3)} {f(cy + s * .32)} l{f(s * .18)} {f(-s * .5)} l{f(s * .32)} {f(s * .32)} Z", sw=1.4)
    c.path(f"M{f(cx + s * .05)} {f(cy - s * .3)} l{f(s * .08)} {f(-s * .1)} M{f(cx + s * .22)} {f(cy - s * .18)} l{f(s * .12)} 0", sw=1.2)
    if start_pad:
        px, py = sq_xy(1, x, y, size)
        c.rect(x, y + size + s * .3, s * 1.6, s * .62, s * .2, sw=1.6, dash="4 3")
        c.text(x + s * .8, y + size + s * .74, "START", s * .3, "middle", font="body", weight=700)
    jumps = [j for j in board["jumps"] if j["id"] not in hide]
    for j in jumps:
        if j["type"] == "ladder":
            draw_ladder(c, j, x, y, size)
    for j in sorted([j for j in jumps if j["type"] == "snake"], key=lambda j: -j["rank"]):
        active = j["rank"] <= n
        if active or show_inactive:
            draw_snake(c, j, x, y, size, dashed=not active)
    if ghost:
        gx, gy = sq_xy(ghost[0], x, y, size)
        c.token(gx, gy, s * .3, ghost[1], ghost=True)
    for i, (sq, col) in enumerate(tokens):
        if sq == 0:
            tx, ty = x + s * (.35 + .32 * i), y + size + s * .62
        else:
            tx, ty = sq_xy(sq, x, y, size)
            same = [k for k, (q, _) in enumerate(tokens) if q == sq]
            if len(same) > 1:
                k = same.index(i); tx += (k - (len(same) - 1) / 2) * s * .3
        c.token(tx, ty, s * .3, col)
    if labels:
        c.layer()
        for j in jumps:
            hx, hy = sq_xy(j["from"], x, y, size)
            if j["type"] == "snake" and (j["rank"] <= n or show_inactive):
                dashed = j["rank"] > n
                c.tx.append(f'<circle cx="{f(hx + s * .3)}" cy="{f(hy - s * .3)}" r="{f(s * .2)}" fill="#fff" stroke="{RED}" stroke-width="2"' + (' stroke-dasharray="3 2"' if dashed else "") + "/>")
                c.tx.append(f'<text x="{f(hx + s * .3)}" y="{f(hy - s * .3 + s * .1)}" class="h" font-size="{f(s * .28)}" text-anchor="middle" fill="{RED}">{j["rank"]}</text>')
            if j["type"] == "ladder" or j["rank"] <= n or show_inactive:
                c.tx.append(f'<text x="{f(hx)}" y="{f(hy + s * .42)}" class="h" font-size="{f(s * .27)}" text-anchor="middle" fill="{BLUE}" stroke="#fff" stroke-width="3" paint-order="stroke">{j["from"]}→{j["to"]}</text>')


def draw_ladder(c, j, x, y, size, sw=2.2):
    s = size / 10
    ax, ay = sq_xy(j["from"], x, y, size); bx, by = sq_xy(j["to"], x, y, size)
    L = math.hypot(bx - ax, by - ay); ux, uy = (bx - ax) / L, (by - ay) / L; nx, ny = -uy, ux
    o = s * .17
    for k in (-1, 1):
        c.line(ax + nx * o * k, ay + ny * o * k, bx + nx * o * k, by + ny * o * k, sw=sw)
    steps = int(L / (s * .32))
    for i in range(1, steps):
        t = i / steps; px, py = ax + (bx - ax) * t, ay + (by - ay) * t
        c.line(px - nx * o, py - ny * o, px + nx * o, py + ny * o, sw=sw * .7)


def snake_points(j, x, y, size):
    pts = [centre(j["from"])] + [tuple(p) for p in j["path"]] + [centre(j["to"])]
    return [(x + u * size, y + v * size) for u, v in catmull(pts, 16)]


def draw_snake(c, j, x, y, size, dashed=False, pos=None):
    s = size / 10
    P = snake_points(j, x, y, size); N = len(P)
    left, right = [], []
    for i, (px, py) in enumerate(P):
        a = P[max(0, i - 1)]; b = P[min(N - 1, i + 1)]
        dx, dy = b[0] - a[0], b[1] - a[1]; L = math.hypot(dx, dy) or 1
        nx, ny = -dy / L, dx / L
        w = s * (.32 - .2 * i / (N - 1)) / 2
        left.append((px + nx * w, py + ny * w)); right.append((px - nx * w, py - ny * w))
    pts = left + right[::-1]
    d = "M" + " L".join(f"{f(a)} {f(b)}" for a, b in pts) + " Z"
    c.path(d, fill=None if dashed else c.paper, sw=1.8, dash="5 4" if dashed else None)
    if not dashed:
        for i in range(4, N - 4, 5):
            px, py = P[i]
            c.circle(px, py, s * .045, fill=c.fill2, sw=0, stroke=c.fill2)
    hx, hy = P[0]; ax, ay = P[2]
    ux, uy = hx - ax, hy - ay; L = math.hypot(ux, uy) or 1; ux, uy = ux / L, uy / L; nx, ny = -uy, ux
    c.circle(hx, hy, s * .2, fill=None if dashed else c.paper, sw=2, dash="4 3" if dashed else None)
    if not dashed:
        for k in (-1, 1):
            c.circle(hx + ux * s * .06 + nx * s * .09 * k, hy + uy * s * .06 + ny * s * .09 * k, s * .035, fill=c.ink, sw=0)
        tx, ty = hx + ux * s * .2, hy + uy * s * .2
        c.path(f"M{f(tx)} {f(ty)} l{f(ux * s * .12)} {f(uy * s * .12)} m0 0 l{f(ux * s * .06 + nx * s * .05)} {f(uy * s * .06 + ny * s * .05)} m{f(-ux * s * .06 - nx * s * .05)} {f(-uy * s * .06 - ny * s * .05)} l{f(ux * s * .06 - nx * s * .05)} {f(uy * s * .06 - ny * s * .05)}", sw=1.3)
    return P


# ---------------------------------------------------------------- Ludo board
TRACK = [(13, 6), (12, 6), (11, 6), (10, 6), (9, 6), (8, 5), (8, 4), (8, 3), (8, 2), (8, 1), (8, 0), (7, 0), (6, 0),
         (6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (5, 6), (4, 6), (3, 6), (2, 6), (1, 6), (0, 6), (0, 7), (0, 8),
         (1, 8), (2, 8), (3, 8), (4, 8), (5, 8), (6, 9), (6, 10), (6, 11), (6, 12), (6, 13), (6, 14), (7, 14),
         (8, 14), (8, 13), (8, 12), (8, 11), (8, 10), (8, 9), (9, 8), (10, 8), (11, 8), (12, 8), (13, 8), (14, 8),
         (14, 7), (14, 6)]
HOME = {"red": [(13, 7), (12, 7), (11, 7), (10, 7), (9, 7)], "blue": [(7, 1), (7, 2), (7, 3), (7, 4), (7, 5)],
        "yellow": [(1, 7), (2, 7), (3, 7), (4, 7), (5, 7)], "green": [(7, 13), (7, 12), (7, 11), (7, 10), (7, 9)]}
START = {"red": 0, "blue": 13, "yellow": 26, "green": 39}
STARS = [8, 21, 34, 47]
YARD = {"blue": (0, 0), "yellow": (0, 9), "green": (9, 9), "red": (9, 0)}
ARROW = {"red": ((14, 7), "up"), "blue": ((7, 0), "right"), "yellow": ((0, 7), "down"), "green": ((7, 14), "left")}
PAT = {"red": "pr", "blue": "pb", "yellow": "py", "green": "pg"}


def cell_xy(rc, x, y, size):
    s = size / 15
    return x + (rc[1] + .5) * s, y + (rc[0] + .5) * s


def track_cell(color, rel):
    if rel <= 50:
        return TRACK[(START[color] + rel) % 52]
    if rel <= 55:
        return HOME[color][rel - 51]
    return None


def yard_slot(color, k, x, y, size):
    s = size / 15; r0, c0 = YARD[color]
    return x + (c0 + 2 + 2 * (k % 2)) * s, y + (r0 + 2 + 2 * (k // 2)) * s


def ludo_board(c, x, y, size, indices=False, tokens=(), ghosts=(), movable=(), labels=True, glow=False):
    s = size / 15; dk = "d" if c.dark else ""
    c.rect(x - 4, y - 4, size + 8, size + 8, 8, sw=3)
    for col, (r0, c0) in YARD.items():
        c.rect(x + c0 * s, y + r0 * s, 6 * s, 6 * s, 4, fill=f"url(#{PAT[col]}{dk})", sw=2)
        if glow:
            c.rect(x + c0 * s + 3, y + r0 * s + 3, 6 * s - 6, 6 * s - 6, 4, sw=1, dash="2 3")
        c.rect(x + (c0 + 1) * s, y + (r0 + 1) * s, 4 * s, 4 * s, 6, fill=c.paper, sw=2)
        for k in range(4):
            sx, sy = yard_slot(col, k, x, y, size)
            c.circle(sx, sy, s * .62, sw=1.6)
        if labels:
            c.text(x + (c0 + 3) * s, y + (r0 + 3) * s + 5, col.upper(), s * .55, "middle", font="body", weight=700, fill=c.muted)
    cells = [(r, cc) for r in range(15) for cc in range(15)
             if (6 <= cc <= 8 and (r <= 5 or r >= 9)) or (6 <= r <= 8 and (cc <= 5 or cc >= 9))]
    owner = {}
    for col, k in START.items():
        owner[TRACK[k]] = col
    for col, hs in HOME.items():
        for h in hs:
            owner[h] = col
    for rc in cells:
        fill = f"url(#{PAT[owner[rc]]}{dk})" if rc in owner else c.paper
        c.rect(x + rc[1] * s, y + rc[0] * s, s, s, 1, fill=fill, sw=1.1, stroke=c.muted)
    for k in STARS:
        cx, cy = cell_xy(TRACK[k], x, y, size)
        c.path(star_path(cx, cy, s * .36, s * .15), sw=1.5)
    for col, (rc, d) in ARROW.items():
        cx, cy = cell_xy(rc, x, y, size); v = {"up": (0, -1), "down": (0, 1), "left": (-1, 0), "right": (1, 0)}[d]
        q = s * .3
        c.path(f"M{f(cx - v[0] * q)} {f(cy - v[1] * q)} L{f(cx + v[0] * q)} {f(cy + v[1] * q)} M{f(cx + v[0] * q - v[1] * q * .6 - v[0] * q * .6)} {f(cy + v[1] * q + v[0] * q * .6 - v[1] * q * .6)} L{f(cx + v[0] * q)} {f(cy + v[1] * q)} L{f(cx + v[0] * q + v[1] * q * .6 - v[0] * q * .6)} {f(cy + v[1] * q - v[0] * q * .6 - v[1] * q * .6)}", sw=1.8)
    cx0, cy0 = x + 7.5 * s, y + 7.5 * s
    tri = {"red": [(6, 9), (9, 9)], "blue": [(6, 6), (6, 9)], "yellow": [(6, 6), (9, 6)], "green": [(9, 6), (9, 9)]}
    for col, ((a1, a2), (b1, b2)) in tri.items():
        c.path(f"M{f(x + a1 * s)} {f(y + a2 * s)} L{f(x + b1 * s)} {f(y + b2 * s)} L{f(cx0)} {f(cy0)} Z", fill=f"url(#{PAT[col]}{dk})", sw=1.6)
    if indices:
        c.layer()
        for i, rc in enumerate(TRACK):
            cx, cy = cell_xy(rc, x, y, size)
            c.tx.append(f'<text x="{f(cx)}" y="{f(cy + s * .16)}" class="b" font-size="{f(s * .4)}" font-weight="700" text-anchor="middle" fill="{BLUE}" stroke="#fff" stroke-width="2.5" paint-order="stroke">{i}</text>')
        for col, hs in HOME.items():
            for k, rc in enumerate(hs):
                cx, cy = cell_xy(rc, x, y, size)
                c.tx.append(f'<text x="{f(cx)}" y="{f(cy + s * .14)}" class="b" font-size="{f(s * .34)}" text-anchor="middle" fill="{RED}" stroke="#fff" stroke-width="2.5" paint-order="stroke">{51 + k}</text>')
    for g in ghosts:
        gx, gy = cell_xy(g[0], x, y, size)
        c.token(gx, gy, s * .36, g[1], ghost=True)
    by_cell = {}
    for t in tokens:
        by_cell.setdefault(t[0], []).append(t)
    for key, group in by_cell.items():
        for k, t in enumerate(group):
            where, col = t[0], t[1]
            if where[0] == "yard":
                tx, ty = yard_slot(col, where[1], x, y, size)
            elif where[0] == "home":
                tx, ty = cx0, cy0
            else:
                tx, ty = cell_xy(where, x, y, size)
            n = len(group)
            if n == 2:
                tx += (k - .5) * s * .38; ty += (k - .5) * s * .18
            elif n > 2:
                tx += (k % 2 - .5) * s * .32; ty += (k // 2 - .5) * s * .32
            c.token(tx, ty, s * .34, col, movable=t in movable or (len(t) > 2 and t[2] == "m"),
                    selected=len(t) > 2 and t[2] == "s")
        if len(group) > 2:
            tx, ty = cell_xy(key, x, y, size) if key[0] not in ("yard", "home") else (cx0, cy0)
            c.layer()
            c.tx.append(f'<circle cx="{f(tx + s * .42)}" cy="{f(ty - s * .42)}" r="{f(s * .24)}" fill="{c.ink}"/>'
                        f'<text x="{f(tx + s * .42)}" y="{f(ty - s * .42 + s * .12)}" class="b" font-size="{f(s * .32)}" font-weight="700" text-anchor="middle" fill="{c.paper}">{len(group)}</text>')
