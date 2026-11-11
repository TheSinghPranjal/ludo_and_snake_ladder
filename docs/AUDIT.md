# Phase 0 Audit

Date: 2026-11-11. Scope: this project folder only. No source, config or platform file was changed.

## 1. Summary

The project is an unmodified `flutter create` template: the counter demo plus generated platform folders. It has no game, networking, audio, persistence or asset code, so Dice Party starts fresh here and there is nothing to migrate.

The brief itself was also checked, because every later phase depends on it. The Ludo geometry is correct. Section 8 lists the places where the brief conflicts with itself, the toolchain or the platforms.

## 2. Current state

| Area | Finding |
|---|---|
| Source | `lib/main.dart` (122 lines, counter demo) and `test/widget_test.dart` (30 lines, counter test). No other Dart files. |
| Architecture | None. One `StatefulWidget` using `setState`. |
| State management | None beyond `setState`. |
| Dependencies | `flutter`, `cupertino_icons`. Dev: `flutter_test`, `flutter_lints`. |
| Rendering | Material widgets. No Flame. |
| Networking | None. |
| Audio, persistence, assets | None. No `assets/` folder and no `flutter: assets:` entries. |
| Package name | `ludo_and_snake_ladder` (`pubspec.yaml:1`) |
| Android id | `com.the_lazy_bear_club.ludo_and_snake_ladder` (`android/app/build.gradle.kts:9,24`) |
| iOS id | `com.thelazybearclub.ludoAndSnakeLadder` (`ios/Runner.xcodeproj/project.pbxproj:376`) |
| Android SDK | `flutter.minSdkVersion`, which is 24 on this SDK (`android/app/build.gradle.kts:27`) |
| iOS minimum | 13.0 (`project.pbxproj:353`), already matches the brief |
| Version control | Not a git repository. |
| Reference images | `ref/` does not exist. Neither image was found in this project, Downloads or Desktop. |

## 3. Toolchain

| Check | Result |
|---|---|
| `flutter analyze` | Exit 0. No issues found. |
| `flutter test` | Exit 0. 1 test passed (the template counter test). |
| Flutter / Dart | 3.41.6 / 3.11.4. Doctor reports a non-standard channel (`[user-branch]`) with an unknown upstream. |
| Android | SDK 36.1.0. Some Android licences are not accepted. |
| Xcode | 26.6, OK. |
| Devices seen | iPhone 14 and iPad (wireless), a Pixel 9a emulator, iOS simulators. No physical Android device. |
| SVG to PNG | `rsvg-convert`, Inkscape, ImageMagick and `cairosvg` are absent. Node, Chrome and Pillow are present, so export can use headless Chrome or an npm renderer. |
| Audio encoding | `ffmpeg` has `aac`, `libopus` and an experimental `vorbis` encoder. No `libvorbis`. |

All packages proposed in brief section 5.1 resolve together on this SDK, tested in a throwaway folder: `flame` 1.38.2, `flame_audio` 2.12.2, `flutter_riverpod` 3.3.1, `riverpod_generator` 4.0.3, `freezed` 3.2.5, `go_router` 17.5.0, `nsd` 5.0.1, `network_info_plus` 8.2.2, `mobile_scanner` 7.5.0, `qr_flutter` 4.1.0, `flutter_secure_storage` 11.2.0, `very_good_analysis` 10.2.0. `crypto` 3.0.8 is also needed for SHA-256 and is not in the brief's list.

## 4. What works and can be reused

| Item | Path | Note |
|---|---|---|
| Android, iOS Gradle and Xcode scaffolding | `android/`, `ios/` | Reuse. Ids, labels and permissions change in Milestone 8. |
| `.gitignore` | `.gitignore` | Reuse. Add `key.properties` in Milestone 8. |

No application code is reusable.

## 5. Bugs and incomplete features

### Requested checks

| # | Check | Result |
|---|---|---|
| 1 | Reconnect tokens in broadcast game-state JSON | Not applicable. No networking or game state exists. |
| 2 | 45 s constant not wired into a real reconnect flow | Not applicable. No such constant or flow exists. |
| 3 | Auto single-move delay not 1120 ms, or firing before the dice ends | Not applicable. No dice or auto-move exists. |
| 4 | Sound toggle that changes nothing | Not applicable. No sound or settings exist. |

Evidence: a case-insensitive search of `lib`, `test` and `pubspec.yaml` for `reconnect`, `websocket`, `HttpServer`, `socket`, `flame`, `riverpod`, `audioplayers`, `Timer(`, `1120`, `seconds: 45`, `sound` and `dice` returned no matches.

### Template items the brief requires changing

| Location | Issue | Fixed in |
|---|---|---|
| `lib/main.dart:7-122` | Counter demo | Milestone 2 |
| `test/widget_test.dart:11,14` | Imports the old package name and tests the counter, so it breaks on rename | Milestone 1 |
| `pubspec.yaml:1-2` | Template name and description | Milestone 1 |
| `analysis_options.yaml` | `flutter_lints` instead of `very_good_analysis` | Milestone 1 |
| `android/app/build.gradle.kts:23,35` | Template TODOs (the brief bans TODOs) | Milestone 8 |
| `android/app/build.gradle.kts:37` | Release build signed with debug keys | Milestone 8 |
| `android/app/src/main/AndroidManifest.xml:1-5` | Template label, none of the required permissions | Milestone 8 |
| `ios/Runner/Info.plist:9-10,56-68` | Template name, landscape allowed, no local-network or camera keys | Milestone 8 |

## 6. Address formats currently supported

None. There is no address handling, so no existing format needs preserving. The Milestone 5 parser baseline is the brief's list:

| Format | Example |
|---|---|
| Bare IPv4 | `192.168.1.5` |
| IPv4 and port | `192.168.1.5:47821` |
| WebSocket URL | `ws://192.168.1.5:47821` |
| Deep link | `diceparty://192.168.1.5:47821/ABCD?g=ludo` |
| mDNS hostname and port | `pixel-7.local:47821` |

## 7. Reuse, refactor, replace

| Module | Action | Reason |
|---|---|---|
| `lib/main.dart` | Replace | Demo code only |
| `test/widget_test.dart` | Replace | Tests the demo |
| `pubspec.yaml` | Refactor | Keep the file, rename, add the stack |
| `analysis_options.yaml` | Refactor | Stricter lint set |
| `android/`, `ios/` | Refactor | Keep the scaffolding, change ids and config |
| `web/`, `macos/`, `linux/`, `windows/` | Leave untouched | Out of scope. Not built, tested or supported. |
| Shell, `platform/`, `core/`, both `games/` | New | Nothing exists |

### Plan for the two-game structure

1. Milestone 1 renames the Dart package to `dice_party`, adds the stack, and creates `core/`, `platform/` and both `games/<game>/domain` folders.
2. Milestone 2 replaces `lib/main.dart` with the `app/` and `shell/` entry points.
3. Milestone 8 applies the final bundle id, Android namespace, `MainActivity` package path, display names and permissions.

No existing Ludo code has to move unless a sibling project is brought in (decision 8.1).

## 8. Findings in the brief

### 8.1 Possible code outside this folder

The four requested bug checks describe a specific existing codebase, but this folder has no such code. Four sibling folders exist in `StudioProjects`: `ludo_unbiased`, `ludo_game`, `ludo_matcha` and `snake_ladder`. They were not opened, because the brief scopes the audit to this project.

### 8.2 The Classic Sunshine layout is an existing game's board

All 17 jumps in section 2.3 are on the published Chutes and Ladders board (Milton Bradley, now Hasbro), which has those 9 ladders and 10 chutes. The brief requires originality, so Classic Sunshine will keep its name, palette and art direction but use a newly authored layout. The Phase 2 board sheet will be its source of truth.

### 8.3 The listed layout misses the balance target

Simulation of the section 2.3 layout: default rules, 2 players, first winner, 10,000 games per count, fixed seed. Turns are those taken by the winner.

| Snakes | Mean | Median | Longest game | Section 2.3 (25-40) | Section 9.9 (20-45) |
|---|---|---|---|---|---|
| 6 | 20.02 | 18 | 107 | Fail | Pass, barely |
| 7 | 21.07 | 19 | 98 | Fail | Pass |
| 8 | 21.49 | 19 | 121 | Fail | Pass |

Sections 2.3 and 9.9 also state different ranges. The plan is to design all boards to the tighter 25-40 and keep 20-45 as the test bound, measured as above.

### 8.4 Android API 23 is not reachable with current packages

`flutter_secure_storage` 11.2.0 and `shared_preferences_android` 2.4.23 require API 24. Flutter 3.41.6 defaults to 24 and warns below it. Staying on 23 means pinning older plugin versions, including the storage that holds reconnect tokens.

### 8.5 UDP discovery on iOS needs an Apple entitlement

Sending UDP broadcast or multicast from an iOS app requires `com.apple.developer.networking.multicast`, which Apple grants on request. The brief's iOS list does not include it. This comes from Apple's documented policy and has not been tested here. The same limit rules out the raw-socket `multicast_dns` package on iOS, so `nsd` (native Bonjour) is the choice. Plan: UDP fallback on Android only, with iOS using Bonjour, QR and manual entry.

### 8.6 Verified correct

The Ludo geometry in section 3.1 passes every check: 52 unique cells, a closed loop, diagonals only at steps 4, 17, 30 and 43, starts 13 apart, stars and last-track cells matching the table, each last-track cell adjacent to its home column, and 20 home-column cells with no overlap.

### 8.7 Rule assumptions (change any by saying so)

- With Need-a-6 on, the 6 places the token on square 1, any jump on square 1 applies, and the 6 still grants its extra roll.
- The S&L capture house rule is checked on the final square, after any ladder or snake.
- Portrait-only on iPad needs `UIRequiresFullScreen`, which will be set in Milestone 8.
- The `SecureDiceService` chi-square test cannot be seeded, so at p = 0.001 it will fail falsely about 1 run in 1,000. It stays as specified.
- Work continues on the installed Flutter 3.41.6, since the whole stack resolves on it.

### 8.8 Needed from you before later phases

| Needed | By |
|---|---|
| The two reference images in `ref/` | Phase 2 for style checks, Phase 3 at the latest |
| `flutter doctor --android-licenses` | First Android build |
| A physical Android phone for hotspot tests, if Android hotspot is to be verified | Milestone 8 |
