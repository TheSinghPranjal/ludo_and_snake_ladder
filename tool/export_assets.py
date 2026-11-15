"""Build every Dice Party image asset (brief section 7). Run from the repo root:

    python3 tool/export_assets.py            # SVG sources -> art/, PNG 1x/2x/3x -> assets/, manifest
    python3 tool/export_assets.py --check    # only verify assets/ against assets/manifest.json

Needs Python 3 with numpy, and Node with tool/node_modules (run `npm install` in tool/ once).
Audio is built separately by tool/generate_audio.py, which adds its entries to the manifest.
"""
import json
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(HERE, "assets"))

MANAGED = ["assets/shared", "assets/games/snakes/themes", "assets/games/snakes/board_select",
           "assets/games/snakes/howto", "assets/games/ludo"]


def collect():
    import gen_ludo
    import gen_shared
    import gen_snakes
    assets = gen_shared.all_assets() + gen_snakes.all_assets() + gen_ludo.all_assets()
    names = [a.name for a in assets]
    dup = {n for n in names if names.count(n) > 1}
    if dup:
        raise SystemExit(f"duplicate asset names: {sorted(dup)}")
    return assets, gen_snakes


def build():
    os.chdir(ROOT)
    assets, gen_snakes = collect()
    for d in MANAGED + ["art"]:
        if os.path.isdir(d):
            shutil.rmtree(d)
    jobs = []
    for a in assets:
        os.makedirs(os.path.dirname(a.source), exist_ok=True)
        with open(a.source, "w") as fh:
            fh.write(a.svg + "\n")
        jobs.append({"svg": a.source, "png": a.path, "w": a.w})
    jobfile = os.path.join(ROOT, "build", "asset_jobs.json")
    os.makedirs(os.path.dirname(jobfile), exist_ok=True)
    with open(jobfile, "w") as fh:
        json.dump(jobs, fh)
    subprocess.run(["node", os.path.join("tool", "render_png.mjs"), jobfile], check=True,
                   env={**os.environ, "NODE_PATH": os.path.join(HERE, "node_modules")}, cwd=ROOT)
    data = []
    for p in gen_snakes.write_theme_json():
        data.append(os.path.relpath(p, ROOT))
    os.makedirs("assets/games/snakes/boards", exist_ok=True)
    for fn in sorted(os.listdir("design/boards")):
        shutil.copy(os.path.join("design/boards", fn), os.path.join("assets/games/snakes/boards", fn))
        data.append(f"assets/games/snakes/boards/{fn}")
    write_manifest(assets, data)
    print(f"{len(assets)} images, {len(data)} data files")


def write_manifest(assets, data):
    path = "assets/manifest.json"
    old = json.load(open(path)) if os.path.exists(path) else {}
    entries = []
    for a in assets:
        e = {"name": a.name, "game": a.game, "kind": "image", "path": a.path, "source": a.source,
             "size": [a.w, a.h], "scales": [1, 2, 3], "anchor": list(a.anchor),
             "modes": a.modes, "screens": a.screens}
        if a.nine:
            e["nineSlice"] = list(a.nine)
        if a.note:
            e["note"] = a.note
        entries.append(e)
    for p in data:
        game = "snakes" if "/snakes/" in p else "shared"
        entries.append({"name": os.path.splitext(os.path.basename(p))[0], "game": game, "kind": "data", "path": p,
                        "modes": "any", "screens": ["snakes_game", "board_select", "snakes_setup"]})
    for fn in sorted(os.listdir("assets/fonts")):
        entries.append({"name": os.path.splitext(fn)[0], "game": "shared", "kind": "font" if fn.endswith(".ttf") else "license",
                        "path": f"assets/fonts/{fn}", "modes": "any", "screens": ["all"]})
    entries += [e for e in old.get("assets", []) if e["path"].startswith("assets/audio/")]
    manifest = {"schemaVersion": 1, "naming": "{group}_{name}_{variant}_{state}_{mode}; PNG at 1x with 2.0x/ and 3.0x/ subfolders",
                "assets": sorted(entries, key=lambda e: e["path"])}
    with open(path, "w") as fh:
        json.dump(manifest, fh, indent=1)
        fh.write("\n")


def check():
    """Every listed file exists (all scales); every file under assets/ is listed."""
    os.chdir(ROOT)
    m = json.load(open("assets/manifest.json"))
    expected = {"assets/manifest.json"}
    missing = []
    for e in m["assets"]:
        paths = [e["path"]]
        if e["kind"] == "image":
            d, b = os.path.split(e["path"])
            paths += [f"{d}/2.0x/{b}", f"{d}/3.0x/{b}"]
        if e["kind"] == "audio":
            paths = e["files"]
        for p in paths:
            expected.add(p)
            if not os.path.exists(p):
                missing.append(p)
    actual = {os.path.join(r, f) for r, _, fs in os.walk("assets") for f in fs if f != ".DS_Store"}
    unlisted = sorted(actual - expected)
    print(f"manifest entries {len(m['assets'])}, files {len(actual)}, missing {len(missing)}, unlisted {len(unlisted)}")
    for p in missing[:20]:
        print("  missing", p)
    for p in unlisted[:20]:
        print("  unlisted", p)
    return not missing and not unlisted


if __name__ == "__main__":
    if "--check" in sys.argv:
        sys.exit(0 if check() else 1)
    build()
    sys.exit(0 if check() else 1)
