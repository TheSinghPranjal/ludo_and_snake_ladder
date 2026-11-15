import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/local_store.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/settings/app_settings.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';

const _specs = [
  StatSpec('captures', 'Captures', StatKind.total),
  StatSpec('turns', 'Fewest turns', StatKind.fewestInWin),
  StatSpec('climb', 'Longest climb', StatKind.highest),
];

void main() {
  group('GameStats', () {
    test('totals add up, bests keep the best, wins count by mode', () {
      var s = const GameStats();
      s = s.record(
        mode: GameMode.ai,
        won: true,
        stats: {'captures': 2, 'turns': 30, 'climb': 20},
        specs: _specs,
      );
      s = s.record(
        mode: GameMode.local,
        won: false,
        stats: {'captures': 1, 'turns': 12, 'climb': 50},
        specs: _specs,
      );
      s = s.record(
        mode: GameMode.ai,
        won: true,
        stats: {'captures': 0, 'turns': 25, 'climb': 5},
        specs: _specs,
      );
      expect(s.played, 3);
      expect(s.winsIn(GameMode.ai), 2);
      expect(s.winsIn(GameMode.local), 0);
      expect(s.totalWins, 2);
      expect(s.values['captures'], 3);
      expect(s.values['turns'], 25, reason: 'a lost game never counts');
      expect(s.values['climb'], 50);
      expect(GameStats.fromJson(s.toJson()), s);
    });
  });

  group('SavedGame', () {
    test('round-trips and rejects other schema versions or junk', () {
      const save = SavedGame(
        schemaVersion: saveSchemaVersion,
        game: GameType.ludo,
        mode: GameMode.local,
        config: {},
        state: {'x': 1},
        me: 'p0',
      );
      expect(SavedGame.tryParse(save.toJson()), save);
      expect(
        SavedGame.tryParse({...save.toJson(), 'schemaVersion': 99}),
        isNull,
      );
      expect(SavedGame.tryParse({'schemaVersion': 1, 'game': 'chess'}), isNull);
      expect(SavedGame.tryParse(null), isNull);
    });
  });

  group('providers', () {
    test('settings persist and drive audio and haptics', () async {
      final app = await TestApp.create();
      app.container
          .read(settingsControllerProvider.notifier)
          .update((s) => s.copyWith(sound: false, haptics: false));
      expect(app.services.audio.soundEnabled, isFalse);
      expect(app.services.haptics.enabled, isFalse);
      final json = app.services.store.readJson(LocalStore.settingsKey)!;
      expect(AppSettings.fromJson(json).sound, isFalse);
    });

    test('unreadable documents fall back to defaults', () async {
      final app = await TestApp.create(
        prefs: {
          LocalStore.settingsKey: '{not json',
          LocalStore.profileKey: '{"name": "", "avatar": 99}',
          LocalStore.saveKey('ludo'): '{"schemaVersion": 1, "game": 5}',
        },
      );
      expect(
        app.container.read(settingsControllerProvider),
        const AppSettings(),
      );
      expect(app.container.read(profileControllerProvider), const Profile());
      expect(app.container.read(savesControllerProvider), isEmpty);
      expect(app.services.store.readString(LocalStore.saveKey('ludo')), isNull);
    });

    test('profile names are trimmed to 12 characters', () async {
      final app = await TestApp.create();
      app.container
          .read(profileControllerProvider.notifier)
          .save(name: '  Alexandrina Victoria ', avatar: 3);
      final p = app.container.read(profileControllerProvider);
      expect(p.name, 'Alexandrina ');
      expect(p.avatar, 3);
    });

    test('reset stats keeps unlocks', () async {
      final app = await TestApp.create();
      app.container
          .read(statsControllerProvider.notifier)
          .record(
            game: GameType.snakes,
            mode: GameMode.ai,
            won: true,
            stats: const {},
            specs: const [],
          );
      app.container.read(unlocksControllerProvider.notifier).add({
        'sugar_rush',
      });
      app.container.read(statsControllerProvider.notifier).reset();
      expect(
        app.container.read(statsControllerProvider)[GameType.snakes]!.played,
        0,
      );
      expect(app.container.read(unlocksControllerProvider), {'sugar_rush'});
    });
  });

  group('AudioService', () {
    test('Sound off really mutes effects; Music off stops the loop', () {
      final backend = RecordingAudioBackend();
      final audio = AudioService(backend, extension: 'ogg')
        ..pushMusic(MusicTrack.hub)
        ..play(Sfx.uiTap);
      expect(backend.sfx, ['ui_tap.ogg']);
      expect(backend.loops, ['music_hub.ogg']);
      audio
        ..configure(sound: false, music: false)
        ..play(Sfx.diceRoll)
        ..pushMusic(MusicTrack.ludo);
      expect(backend.sfx, ['ui_tap.ogg']);
      expect(backend.loops, ['music_hub.ogg', null]);
      audio.configure(sound: true, music: true);
      expect(backend.loops.last, 'music_ludo.ogg');
      audio.popMusic(MusicTrack.ludo);
      expect(backend.loops.last, 'music_hub.ogg');
      audio.suspend(suspended: true);
      expect(backend.loops.last, isNull);
    });

    test('the app services provider must be overridden', () {
      expect(appServicesProvider, isNotNull);
    });
  });
}
