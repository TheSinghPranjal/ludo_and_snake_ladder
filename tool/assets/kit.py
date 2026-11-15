"""Art kit for Dice Party assets: colour helpers, an SVG document builder and cartoon primitives.

Style rules (brief section 7.1): rounded shapes, outlines in a dark tint of the fill (never black),
simple cel shading, one highlight, soft drop shadows.
"""
import colorsys
import math
from dataclasses import dataclass, field

FONT_DISPLAY = "Fredoka"
FONT_BODY = "Nunito"

PLAYER = {"red": "#D9342B", "blue": "#3E8EDE", "yellow": "#ECCB3A", "green": "#3D9142"}
COLORS = ("red", "blue", "yellow", "green")

SHELL = {
    "light": dict(bg="#FFF9EE", surface="#FFFFFF", surface2="#FFF3D6", text="#2A2A35", text2="#5E6272",
                  primary="#2F7DE1", accent="#FFC93C", danger="#D64545", ink="#2A2A35"),
    "dark": dict(bg="#12141C", surface="#1D2030", surface2="#262A3C", text="#F2F3F7", text2="#A9AEC2",
                 primary="#4B86CF", accent="#EBC55A", danger="#D06060", ink="#F2F3F7"),
}


# ---------------------------------------------------------------- colour
def _rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i + 2], 16) / 255 for i in (0, 2, 4))


def _hex(rgb):
    return "#" + "".join(f"{max(0, min(255, round(c * 255))):02X}" for c in rgb)


def mix(a, b, t):
    ra, rb = _rgb(a), _rgb(b)
    return _hex(tuple(x + (y - x) * t for x, y in zip(ra, rb)))


def shade(c, k=0.25):
    """Darker, slightly more saturated version of c (used for cel shade and outlines)."""
    h, l, s = colorsys.rgb_to_hls(*_rgb(c))
    return _hex(colorsys.hls_to_rgb(h, max(0, l * (1 - k)), min(1, s * (1 + k * .25))))


def tint(c, k=0.25):
    h, l, s = colorsys.rgb_to_hls(*_rgb(c))
    return _hex(colorsys.hls_to_rgb(h, l + (1 - l) * k, s))


def outline(c):
    """The outline colour for a fill: a dark tint of the fill, never black."""
    return shade(c, .55)


def desat(c, k=0.1):
    h, l, s = colorsys.rgb_to_hls(*_rgb(c))
    return _hex(colorsys.hls_to_rgb(h, l, s * (1 - k)))


def luminance(c):
    def ch(v):
        return v / 12.92 if v <= .03928 else ((v + .055) / 1.055) ** 2.4
    r, g, b = (ch(v) for v in _rgb(c))
    return .2126 * r + .7152 * g + .0722 * b


def contrast(a, b):
    la, lb = sorted((luminance(a), luminance(b)), reverse=True)
    return (la + .05) / (lb + .05)


def f(v):
    return f"{v:.2f}".rstrip("0").rstrip(".")


# ---------------------------------------------------------------- document
@dataclass
class Doc:
    """One SVG document. All ids are prefixed so documents can be nested in a page safely."""
    w: float
    h: float
    pid: str
    parts: list = field(default_factory=list)
    defs: list = field(default_factory=list)
    _n: int = 0

    def id(self, name):
        self._n += 1
        return f"{self.pid}-{name}{self._n}"

    def add(self, *s):
        self.parts.extend(s)
        return self

    def svg(self):
        d = f"<defs>{''.join(self.defs)}</defs>" if self.defs else ""
        return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{f(self.w)}" height="{f(self.h)}" '
                f'viewBox="0 0 {f(self.w)} {f(self.h)}">{d}{"".join(self.parts)}</svg>')

    def inner(self):
        """Body without the <svg> wrapper, for compositing (defs included)."""
        d = f"<defs>{''.join(self.defs)}</defs>" if self.defs else ""
        return d + "".join(self.parts)

    # defs helpers
    def radial(self, stops, cx=.5, cy=.5, r=.5):
        i = self.id("rg")
        s = "".join(f'<stop offset="{o}" stop-color="{c}" stop-opacity="{a}"/>' for o, c, a in stops)
        self.defs.append(f'<radialGradient id="{i}" cx="{cx}" cy="{cy}" r="{r}">{s}</radialGradient>')
        return f"url(#{i})"

    def linear(self, stops, x1=0, y1=0, x2=0, y2=1):
        i = self.id("lg")
        s = "".join(f'<stop offset="{o}" stop-color="{c}" stop-opacity="{a}"/>' for o, c, a in stops)
        self.defs.append(f'<linearGradient id="{i}" x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}">{s}</linearGradient>')
        return f"url(#{i})"

    def clip(self, shape):
        i = self.id("cp")
        self.defs.append(f'<clipPath id="{i}">{shape}</clipPath>')
        return f"url(#{i})"

    def blur(self, sd):
        i = self.id("bl")
        self.defs.append(f'<filter id="{i}" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="{f(sd)}"/></filter>')
        return f"url(#{i})"

    # primitives ----------------------------------------------------------
    def shadow(self, cx, cy, rx, ry, op=.28, color="#1A1426"):
        g = self.radial([(0, color, op), (.6, color, op * .55), (1, color, 0)])
        return self.add(f'<ellipse cx="{f(cx)}" cy="{f(cy)}" rx="{f(rx)}" ry="{f(ry)}" fill="{g}"/>')

    def ball(self, cx, cy, r, fill, rim=None, sw=None, hl=True, shade_k=.18):
        """Cel-shaded disc: base shade, lighter body offset up-left, one highlight, dark-tint outline."""
        sw = r * .1 if sw is None else sw
        cp = self.clip(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(r)}"/>')
        self.add(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(r)}" fill="{shade(fill, shade_k)}"/>',
                 f'<circle cx="{f(cx - r * .1)}" cy="{f(cy - r * .12)}" r="{f(r * .92)}" fill="{fill}" clip-path="{cp}"/>')
        if hl:
            self.add(f'<ellipse cx="{f(cx - r * .38)}" cy="{f(cy - r * .45)}" rx="{f(r * .3)}" ry="{f(r * .17)}" '
                     f'transform="rotate(-35 {f(cx - r * .38)} {f(cy - r * .45)})" fill="#FFFFFF" fill-opacity=".55"/>')
        self.add(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(r - sw / 2)}" fill="none" stroke="{outline(fill)}" stroke-width="{f(sw)}"/>')
        if rim:
            self.add(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(r + sw * .2)}" fill="none" stroke="{rim}" stroke-opacity=".8" stroke-width="{f(sw * .55)}"/>')
        return self

    def slab(self, x, y, w, h, r, fill, sw=None, band=None, hl=True, stroke=None):
        """Cel-shaded rounded rectangle: bottom shade band, top highlight, dark-tint outline."""
        sw = max(1.5, min(w, h) * .05) if sw is None else sw
        band = h * .14 if band is None else band
        cp = self.clip(f'<rect x="{f(x)}" y="{f(y)}" width="{f(w)}" height="{f(h)}" rx="{f(r)}"/>')
        self.add(f'<rect x="{f(x)}" y="{f(y)}" width="{f(w)}" height="{f(h)}" rx="{f(r)}" fill="{shade(fill, .16)}"/>',
                 f'<rect x="{f(x)}" y="{f(y - 1)}" width="{f(w)}" height="{f(h - band + 1)}" rx="{f(r)}" fill="{fill}" clip-path="{cp}"/>')
        if hl:
            self.add(f'<rect x="{f(x + r * .7)}" y="{f(y + sw * 1.4)}" width="{f(max(0, w - r * 1.4))}" height="{f(max(1.5, h * .07))}" '
                     f'rx="{f(h * .035)}" fill="#FFFFFF" fill-opacity=".45"/>')
        self.add(f'<rect x="{f(x + sw / 2)}" y="{f(y + sw / 2)}" width="{f(w - sw)}" height="{f(h - sw)}" rx="{f(max(0, r - sw / 2))}" '
                 f'fill="none" stroke="{stroke or outline(fill)}" stroke-width="{f(sw)}"/>')
        return self

    def text(self, x, y, s, size, fill, weight=700, anchor="middle", family=FONT_DISPLAY, stroke=None, sw=0, ls=0):
        st = f' stroke="{stroke}" stroke-width="{f(sw)}" paint-order="stroke" stroke-linejoin="round"' if stroke else ""
        l = f' letter-spacing="{f(ls)}"' if ls else ""
        return self.add(f'<text x="{f(x)}" y="{f(y)}" font-family="{family}" font-weight="{weight}" font-size="{f(size)}" '
                        f'text-anchor="{anchor}" fill="{fill}"{st}{l}>{s}</text>')


def star_pts(cx, cy, ro, ri, n=5, rot=-90):
    pts = []
    for i in range(n * 2):
        r = ro if i % 2 == 0 else ri
        a = math.radians(rot + i * 180 / n)
        pts.append(f"{f(cx + r * math.cos(a))},{f(cy + r * math.sin(a))}")
    return " ".join(pts)


def symbol(d, color, cx, cy, k, fill="#FFFFFF", stroke=None, sw=None):
    """Colour-blind symbol: red circle, blue square, yellow triangle, green star."""
    stroke = stroke or outline(PLAYER.get(color, color))
    sw = k * .16 if sw is None else sw
    st = f'fill="{fill}" stroke="{stroke}" stroke-width="{f(sw)}" stroke-linejoin="round"'
    if color == "red":
        d.add(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{f(k * .62)}" {st}/>')
    elif color == "blue":
        d.add(f'<rect x="{f(cx - k * .56)}" y="{f(cy - k * .56)}" width="{f(k * 1.12)}" height="{f(k * 1.12)}" rx="{f(k * .16)}" {st}/>')
    elif color == "yellow":
        d.add(f'<polygon points="{f(cx)},{f(cy - k * .72)} {f(cx + k * .74)},{f(cy + k * .56)} {f(cx - k * .74)},{f(cy + k * .56)}" {st}/>')
    else:
        d.add(f'<polygon points="{star_pts(cx, cy + k * .05, k * .78, k * .34)}" {st}/>')
