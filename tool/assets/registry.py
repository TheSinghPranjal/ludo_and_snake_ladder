"""Asset records shared by every generator, plus naming rules (brief section 7.6)."""
from dataclasses import dataclass, field

MODES = ("light", "dark")


@dataclass
class Asset:
    """One exported image. `name` follows {group}_{name}_{variant}_{state}_{mode}."""
    name: str
    folder: str                 # under assets/, e.g. "shared/tokens"
    game: str                   # shared | snakes | ludo
    w: float                    # logical (1x) size
    h: float
    svg: str
    modes: object               # ["light"], ["dark"] or "tinted"
    screens: list
    anchor: tuple = (0.5, 0.5)
    nine: tuple = None          # (left, top, right, bottom) insets in logical px
    note: str = ""
    inner: str = ""             # svg body for compositing in the asset library
    section: str = ""           # asset-library section id
    extra: dict = field(default_factory=dict)

    @property
    def path(self):
        return f"assets/{self.folder}/{self.name}.png"

    @property
    def source(self):
        return f"art/{self.folder}/{self.name}.svg"


def record(doc, name, folder, game, modes, screens, section, **kw):
    return Asset(name=name, folder=folder, game=game, w=doc.w, h=doc.h, svg=doc.svg(), inner=doc.inner(),
                 modes=modes, screens=screens, section=section, **kw)
