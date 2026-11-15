"""Synthesise every Dice Party sound and music loop (brief section 7.5). Run from the repo root:

    python3 tool/generate_audio.py

All audio is generated here from oscillators and noise; there are no third-party samples.
Writes assets/audio/<name>.ogg and .m4a, adds audio entries to assets/manifest.json, and writes
assets/audio/CREDITS.md. Needs numpy and ffmpeg (with the aac_at encoder, i.e. macOS). Output is deterministic (fixed seeds).
"""
import json
import os
import subprocess
import tempfile
import wave

import numpy as np

SR = 44100
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "assets", "audio")
LIMIT = 150 * 1024


# ---------------------------------------------------------------- building blocks
def t_of(sec):
    return np.arange(int(sec * SR)) / SR


def env(n, a=.005, d=.1, s=0.0, r=.05, hold=0.0):
    """ADSR envelope of n samples (times in seconds)."""
    e = np.zeros(n)
    ia, idd, ih = int(a * SR), int(d * SR), int(hold * SR)
    ir = int(r * SR)
    i = 0
    seg = min(ia, n); e[:seg] = np.linspace(0, 1, seg, endpoint=False); i = seg
    seg = min(idd, n - i); e[i:i + seg] = np.linspace(1, s, seg, endpoint=False); i += seg
    seg = min(ih, n - i); e[i:i + seg] = s; i += seg
    seg = min(ir, n - i); e[i:i + seg] = np.linspace(s, 0, seg, endpoint=False)
    return e


def expdecay(n, tau):
    return np.exp(-np.arange(n) / SR / tau)


def osc(freq, sec, kind="sine", phase=0.0):
    n = int(sec * SR)
    fr = np.full(n, float(freq)) if np.isscalar(freq) else np.asarray(freq, float)[:n]
    ph = 2 * np.pi * np.cumsum(fr) / SR + phase
    if kind == "sine":
        return np.sin(ph)
    if kind == "tri":
        return 2 / np.pi * np.arcsin(np.sin(ph))
    if kind == "square":
        return sum(np.sin(ph * k) / k for k in (1, 3, 5, 7)) * 4 / np.pi
    if kind == "saw":
        return sum(np.sin(ph * k) / k for k in range(1, 9)) * 2 / np.pi
    raise ValueError(kind)


def glide(f0, f1, sec, curve=1.0):
    x = np.linspace(0, 1, int(sec * SR)) ** curve
    return f0 * (f1 / f0) ** x


def lowpass(x, cutoff):
    """One-pole low-pass filter."""
    a = np.exp(-2 * np.pi * cutoff / SR)
    taps = int(np.ceil(np.log(1e-5) / np.log(a)))  # impulse response truncated at -100 dB
    h = (1 - a) * a ** np.arange(taps)
    x = np.asarray(x, float)
    return np.convolve(x, h)[:len(x)]


def noise(sec, seed=1):
    return np.random.default_rng(seed).standard_normal(int(sec * SR))


def bell(freq, sec, tau=.35):
    n = int(sec * SR)
    return (osc(freq, sec) + .45 * osc(freq * 2.76, sec) * expdecay(n, tau * .4) + .2 * osc(freq * 5.4, sec) * expdecay(n, tau * .2)) * expdecay(n, tau)


def wood(freq, sec=.12, tau=.035, seed=3):
    n = int(sec * SR)
    return (osc(freq, sec) * .8 + .3 * osc(freq * 2.3, sec)) * expdecay(n, tau) + .15 * noise(sec, seed) * expdecay(n, .006)


def place(buf, x, at, gain=1.0):
    i = int(at * SR)
    end = min(len(buf), i + len(x))
    buf[i:end] += gain * x[:end - i]
    return buf


def note(name):
    names = {"C": 0, "C#": 1, "D": 2, "D#": 3, "E": 4, "F": 5, "F#": 6, "G": 7, "G#": 8, "A": 9, "A#": 10, "B": 11}
    pitch, octave = name[:-1], int(name[-1])
    return 440 * 2 ** ((names[pitch] + 12 * (octave + 1) - 69) / 12)


def midi(m):
    return 440 * 2 ** ((m - 69) / 12)


def normalise(x, peak=.89, rms_target=None):
    x = x - np.mean(x)
    if rms_target:
        r = np.sqrt(np.mean(x ** 2)) or 1
        x = x * (rms_target / r)
    m = np.max(np.abs(x)) or 1
    return x * min(1.0, peak / m) if rms_target else x * (peak / m)


def fade(x, a=.004, r=.02):
    n = len(x); ia, ir = int(a * SR), int(r * SR)
    x[:ia] *= np.linspace(0, 1, ia); x[n - ir:] *= np.linspace(1, 0, ir)
    return x


# ---------------------------------------------------------------- sound effects
def sfx_dice_roll():
    buf = np.zeros(int(.82 * SR)); rng = np.random.default_rng(7); t = 0.0
    for k in range(10):
        f = rng.uniform(900, 1500)
        place(buf, wood(f, .1, .02, seed=k), t, .9 - k * .05)
        t += .11 - k * .006 + rng.uniform(-.01, .01)
    return buf


def sfx_dice_land():
    sec = .3; n = int(sec * SR)
    thock = osc(glide(210, 120, sec, .3), sec) * expdecay(n, .06)
    return thock + .35 * lowpass(noise(sec, 4), 2500) * expdecay(n, .015) + .3 * wood(700, sec, .03)


def sfx_step():
    return wood(1250, .12, .03) * .9 + .3 * osc(620, .12) * expdecay(int(.12 * SR), .02)


def sfx_extra_roll():
    buf = np.zeros(int(.7 * SR))
    for i, nm in enumerate(("C5", "E5", "G5", "C6")):
        place(buf, osc(note(nm), .3, "tri") * env(int(.3 * SR), .004, .25, 0, .02), i * .09)
    return buf


def sfx_timer_tick():
    return wood(2100, .09, .012) + .4 * wood(1400, .09, .01)


def sfx_ui_tap():
    sec = .09
    return osc(glide(520, 880, sec, .5), sec) * env(int(sec * SR), .002, .08, 0, .005)


def sfx_win():
    sec = 2.4; buf = np.zeros(int(sec * SR))
    chords = [("C4", "E4", "G4"), ("F4", "A4", "C5"), ("G4", "B4", "D5"), ("C5", "E5", "G5")]
    for i, ch in enumerate(chords):
        dur = .3 if i < 3 else 1.3
        for nm in ch:
            n = int(dur * SR)
            tone = osc(note(nm), dur, "saw") * env(n, .01, .1, .6, .2, hold=max(0, dur - .32))
            place(buf, lowpass(tone, 2800), i * .3, .5)
    for i, nm in enumerate(("C6", "E6", "G6", "C7", "G6", "C7")):
        place(buf, bell(note(nm), .6, .25), .9 + i * .08, .35)
    return buf


def sfx_ladder_climb():
    buf = np.zeros(int(1.25 * SR)); scale = ("C5", "D5", "E5", "G5", "A5", "C6", "D6", "E6")
    for i, nm in enumerate(scale):
        place(buf, bell(note(nm), .4, .18), i * .12, .7)
    return buf


def sfx_snake_slide():
    sec = 1.4; n = int(sec * SR)
    f = glide(900, 140, sec, .7) * (1 + .03 * np.sin(2 * np.pi * 9 * t_of(sec)))
    whoop = osc(f, sec, "tri") * env(n, .02, .2, .8, .25, hold=sec - .5)
    hiss = lowpass(noise(sec, 9), 3500) * .12 * env(n, .1, .3, .6, .3, hold=sec - .7)
    return whoop + hiss


def sfx_snake_gulp():
    sec = .38; n = int(sec * SR)
    f = np.concatenate([glide(320, 110, .2, .5), glide(110, 190, sec - .2)])
    return osc(f, sec) * env(n, .005, .1, .7, .1, hold=.15) + .2 * lowpass(noise(sec, 11), 900) * expdecay(n, .08)


def sfx_blocked():
    sec = .3; n = int(sec * SR)
    return lowpass(osc(110, sec, "square"), 1400) * env(n, .003, .12, .3, .1, hold=.05) * .8


def sfx_leave_base():
    sec = .28; n = int(sec * SR)
    return osc(glide(300, 950, .12).tolist() + [950] * (n - int(.12 * SR)), sec) * env(n, .002, .2, 0, .02) + .2 * wood(1800, sec, .01)


def sfx_capture():
    sec = .55; n = int(sec * SR)
    bonk = osc(glide(260, 90, .25, .4).tolist() + [90] * (n - int(.25 * SR)), sec) * expdecay(n, .09)
    boing = osc(glide(400, 600, sec) * (1 + .08 * np.sin(2 * np.pi * 14 * t_of(sec))), sec, "tri") * env(n, .05, .2, .4, .2, hold=.1) * .4
    return bonk + boing + .3 * lowpass(noise(sec, 13), 1800) * expdecay(n, .03)


def sfx_home():
    buf = np.zeros(int(1.0 * SR))
    for i, nm in enumerate(("G5", "C6", "E6", "G6", "C7")):
        place(buf, bell(note(nm), .6, .3), i * .07, .6)
    sh = noise(1.0, 21) * .05
    return buf + lowpass(sh, 9000) * np.linspace(1, 0, len(sh))


SFX = {
    "dice_roll": ("shared", sfx_dice_roll, ["snakes_game", "ludo_game"]),
    "dice_land": ("shared", sfx_dice_land, ["snakes_game", "ludo_game"]),
    "step": ("shared", sfx_step, ["snakes_game", "ludo_game"]),
    "extra_roll": ("shared", sfx_extra_roll, ["snakes_game", "ludo_game"]),
    "timer_tick": ("shared", sfx_timer_tick, ["snakes_game", "ludo_game"]),
    "win": ("shared", sfx_win, ["results"]),
    "ui_tap": ("shared", sfx_ui_tap, ["all"]),
    "ladder_climb": ("snakes", sfx_ladder_climb, ["snakes_game"]),
    "snake_slide": ("snakes", sfx_snake_slide, ["snakes_game"]),
    "snake_gulp": ("snakes", sfx_snake_gulp, ["snakes_game"]),
    "blocked": ("snakes", sfx_blocked, ["snakes_game"]),
    "leave_base": ("ludo", sfx_leave_base, ["ludo_game"]),
    "capture": ("ludo", sfx_capture, ["ludo_game"]),
    "home": ("ludo", sfx_home, ["ludo_game"]),
}


# ---------------------------------------------------------------- music
MUSIC = {
    "music_hub": dict(game="shared", bpm=120, root=60, scale=(0, 2, 4, 7, 9), prog=((0, 4, 7), (9, 12, 16), (5, 9, 12), (7, 11, 14)),
                      lead="marimba", seed=3, screens=["hub", "game_menu", "settings"]),
    "music_snakes": dict(game="snakes", bpm=120, root=65, scale=(0, 2, 4, 7, 9), prog=((0, 4, 7), (5, 9, 12), (2, 5, 9), (7, 11, 14)),
                         lead="pluck", seed=5, screens=["snakes_game"]),
    "music_ludo": dict(game="ludo", bpm=120, root=67, scale=(0, 2, 4, 5, 7, 9, 11), prog=((0, 4, 7), (5, 9, 12), (9, 12, 16), (7, 11, 14)),
                       lead="flute", seed=8, screens=["ludo_game"]),
}
LOOP_SEC = 64.0


def instrument(kind, freq, dur):
    n = int(dur * SR)
    if kind == "marimba":
        return (osc(freq, dur) + .3 * osc(freq * 4, dur) * expdecay(n, .05)) * expdecay(n, .25)
    if kind == "pluck":
        return lowpass(osc(freq, dur, "saw"), 2400) * expdecay(n, .18)
    if kind == "flute":
        return (osc(freq * (1 + .004 * np.sin(2 * np.pi * 5 * t_of(dur))), dur) + .15 * osc(freq * 2, dur)) * env(n, .04, .1, .7, .08, hold=max(0, dur - .22))
    if kind == "bass":
        return lowpass(osc(freq, dur, "tri"), 900) * env(n, .01, .15, .6, .06, hold=max(0, dur - .22))
    if kind == "pad":
        return lowpass(osc(freq, dur, "saw") + osc(freq * 1.005, dur, "saw"), 1100) * env(n, .4, .3, .7, .5, hold=max(0, dur - 1.2)) * .5
    raise ValueError(kind)


def music(cfg):
    rng = np.random.default_rng(cfg["seed"])
    beat = 60 / cfg["bpm"]; bar = 4 * beat
    bars = int(round(LOOP_SEC / bar))
    total = int(bars * bar * SR)
    buf = np.zeros(total + 3 * SR)
    root = cfg["root"]
    scale = [root + 12 + s for s in cfg["scale"]] + [root + 24 + s for s in cfg["scale"]]
    phrase = [[int(rng.integers(0, len(scale) - 3)) if rng.random() > .2 else -1 for _ in range(8)] for _ in range(2)]
    for b in range(bars):
        t0 = b * bar
        chord = cfg["prog"][b % 4]
        for iv in chord:
            place(buf, instrument("pad", midi(root - 12 + iv), bar), t0, .07)
        for k, iv in enumerate((chord[0], chord[0], chord[2] - 12, chord[0])):
            place(buf, instrument("bass", midi(root - 24 + iv), beat * .9), t0 + k * beat, .32)
        for k in range(4):
            place(buf, wood(1800 if k % 2 else 1100, .08, .015, seed=b * 4 + k) * (.5 if k % 2 else .7), t0 + k * beat, .12)
            place(buf, lowpass(noise(.05, b * 8 + k), 7000) * expdecay(int(.05 * SR), .01), t0 + k * beat + beat / 2, .05)
        section = (b // 8) % 4
        if section == 3 and b % 2:
            continue
        mel = phrase[0] if section in (0, 2) else phrase[1]
        for k, idx in enumerate(mel):
            if idx < 0:
                continue
            step = idx + (b % 2) * (1 if section == 1 else 0)
            m = scale[min(step, len(scale) - 1)]
            nearest = min(chord, key=lambda c: abs((root + 12 + c) % 12 - m % 12))
            if k % 2 == 0:
                m = m - ((m - (root + 12 + nearest)) % 12) if (m - (root + 12 + nearest)) % 12 <= 2 else m
            place(buf, instrument(cfg["lead"], midi(m), beat * .5), t0 + k * beat / 2, .2)
    tail = buf[total:total + 3 * SR].copy()
    loop = buf[:total].copy()
    loop[:len(tail)] += tail  # wrap the release tails so the loop is seamless
    return loop


# ---------------------------------------------------------------- encode
def write_wav(path, x):
    pcm = (np.clip(x, -1, 1) * 32767).astype("<i2")
    with wave.open(path, "wb") as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR); w.writeframes(pcm.tobytes())


def encode(x, name, is_music):
    os.makedirs(OUT, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        wav = os.path.join(tmp, name + ".wav")
        write_wav(wav, x)
        ogg = os.path.join(OUT, name + ".ogg"); m4a = os.path.join(OUT, name + ".m4a")
        # The native ffmpeg Vorbis encoder is stereo-only and outputs silence at -q:a 0, so music starts at
        # quality 1 (22.05 kHz) and steps down only if a file would exceed the 150 KB budget.
        for q in (["-ar", "22050", "-q:a", "1"], ["-ar", "22050", "-q:a", "0.75"], ["-ar", "16000", "-q:a", "1"]) if is_music else (["-q:a", "3"],):
            subprocess.run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-y", "-i", wav, "-ac", "2", "-c:a", "vorbis", "-strict", "-2", *q,
                            "-map_metadata", "-1", ogg], check=True)
            if os.path.getsize(ogg) <= LIMIT:
                break
        aac = (["-ac", "1", "-ar", "32000", "-c:a", "aac_at", "-profile:a", "4", "-b:a", "16k"] if is_music
               else ["-ac", "1", "-c:a", "aac", "-b:a", "96k"])
        subprocess.run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-y", "-i", wav, *aac, "-map_metadata", "-1",
                        "-movflags", "+faststart", m4a], check=True)
    return ogg, m4a


def loudness_db(path):
    """RMS level of the decoded file in dBFS; used to catch silent encodes."""
    raw = subprocess.run(["ffmpeg", "-v", "error", "-i", path, "-ac", "1", "-f", "f32le", "-"], capture_output=True, check=True).stdout
    y = np.frombuffer(raw, "<f4")
    return 20 * np.log10(np.sqrt(np.mean(y ** 2)) + 1e-12)


def main():
    entries = []
    for name, (game, fn, screens) in SFX.items():
        x = fade(normalise(fn(), .89, rms_target=.2))
        ogg, m4a = encode(x, name, False)
        entries.append((name, game, screens, len(x) / SR, False, ogg, m4a))
    for name, cfg in MUSIC.items():
        x = normalise(music(cfg), .8, rms_target=.14)
        ogg, m4a = encode(x, name, True)
        entries.append((name, cfg["game"], cfg["screens"], len(x) / SR, True, ogg, m4a))
    mpath = os.path.join(ROOT, "assets", "manifest.json")
    m = json.load(open(mpath))
    m["assets"] = [e for e in m["assets"] if not e["path"].startswith("assets/audio/")]
    m["assets"].append({"name": "CREDITS", "game": "shared", "kind": "license", "path": "assets/audio/CREDITS.md", "modes": "any", "screens": []})
    over = []
    silent = []
    print(f"{'name':14} {'sec':>6} {'ogg KB':>7} {'m4a KB':>7} {'ogg dB':>7} {'m4a dB':>7}")
    for name, game, screens, sec, loop, ogg, m4a in entries:
        so, sm = os.path.getsize(ogg), os.path.getsize(m4a)
        lo, lm = loudness_db(ogg), loudness_db(m4a)
        print(f"{name:14} {sec:6.2f} {so / 1024:7.1f} {sm / 1024:7.1f} {lo:7.1f} {lm:7.1f}")
        over += [p for p, s in ((ogg, so), (m4a, sm)) if s > LIMIT]
        silent += [p for p, level in ((ogg, lo), (m4a, lm)) if level < -40]
        rel = [os.path.relpath(p, ROOT) for p in (ogg, m4a)]
        m["assets"].append({"name": name, "game": game, "kind": "audio", "path": rel[1], "files": rel, "durationMs": round(sec * 1000),
                            "loop": loop, "modes": "any", "screens": screens})
    m["assets"].sort(key=lambda e: e["path"])
    with open(mpath, "w") as fh:
        json.dump(m, fh, indent=1); fh.write("\n")
    with open(os.path.join(OUT, "CREDITS.md"), "w") as fh:
        fh.write("# Audio credits\n\nEvery sound effect and music loop in this folder is original. Each one is synthesised from "
                 "oscillators and noise by `tool/generate_audio.py`, with fixed seeds, so the files can be rebuilt exactly. "
                 "No third-party samples, loops or presets are used, so there is nothing to attribute.\n\n"
                 "| File | Kind | Length |\n|---|---|---|\n")
        for name, game, screens, sec, loop, *_ in entries:
            fh.write(f"| {name} | {'music loop' if loop else 'effect'} ({game}) | {sec:.2f} s |\n")
    if over or silent:
        raise SystemExit(f"over 150 KB: {over}; silent: {silent}")


if __name__ == "__main__":
    main()
