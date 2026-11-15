import 'dart:async';

import 'package:dice_party/core/constants/app_info.dart';
import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/local_store.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/settings/app_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

T? _read<T>(Map<String, dynamic>? json, T Function(Map<String, dynamic>) f) {
  if (json == null) return null;
  try {
    return f(json);
  } on Object {
    return null;
  }
}

/// Global settings. Changes apply at once to audio and haptics and are
/// saved.
@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  AppSettings build() {
    final services = ref.watch(appServicesProvider);
    final s =
        _read(
          services.store.readJson(LocalStore.settingsKey),
          AppSettings.fromJson,
        ) ??
        const AppSettings();
    _apply(services, s);
    return s;
  }

  /// Replaces the settings with `change(current)`.
  void update(AppSettings Function(AppSettings) change) {
    final next = change(state);
    final services = ref.read(appServicesProvider);
    _apply(services, next);
    state = next;
    unawaited(services.store.writeJson(LocalStore.settingsKey, next.toJson()));
  }

  void _apply(AppServices services, AppSettings s) {
    services.audio.configure(sound: s.sound, music: s.music);
    services.haptics.enabled = s.haptics;
  }
}

/// The player's profile.
@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  Profile build() {
    final store = ref.watch(appServicesProvider).store;
    final p = _read(store.readJson(LocalStore.profileKey), Profile.fromJson);
    if (p == null ||
        p.name.trim().isEmpty ||
        p.name.length > AppInfo.maxNameLength ||
        p.avatar < 0 ||
        p.avatar >= AppInfo.avatarCount) {
      return const Profile();
    }
    return p;
  }

  /// Saves a new name (trimmed, at most 12 characters) and avatar.
  void save({required String name, required int avatar}) {
    final trimmed = name.trim();
    final next = Profile(
      name: trimmed.isEmpty
          ? state.name
          : trimmed.substring(
              0,
              trimmed.length.clamp(0, AppInfo.maxNameLength),
            ),
      avatar: avatar.clamp(0, AppInfo.avatarCount - 1),
    );
    state = next;
    unawaited(
      ref
          .read(appServicesProvider)
          .store
          .writeJson(LocalStore.profileKey, next.toJson()),
    );
  }
}

/// Lifetime statistics per game.
@Riverpod(keepAlive: true)
class StatsController extends _$StatsController {
  @override
  Map<GameType, GameStats> build() {
    final store = ref.watch(appServicesProvider).store;
    return {
      for (final g in GameType.values)
        g:
            _read(
              store.readJson(LocalStore.statsKey(g.name)),
              GameStats.fromJson,
            ) ??
            const GameStats(),
    };
  }

  /// Statistics of [game].
  GameStats of(GameType game) => state[game] ?? const GameStats();

  /// Adds a finished game and returns the new statistics of [game].
  GameStats record({
    required GameType game,
    required GameMode mode,
    required bool won,
    required Map<String, num> stats,
    required List<StatSpec> specs,
  }) {
    final next = of(
      game,
    ).record(mode: mode, won: won, stats: stats, specs: specs);
    state = {...state, game: next};
    unawaited(
      ref
          .read(appServicesProvider)
          .store
          .writeJson(LocalStore.statsKey(game.name), next.toJson()),
    );
    return next;
  }

  /// Clears every game's statistics. Unlocked content stays unlocked.
  void reset() {
    final store = ref.read(appServicesProvider).store;
    state = {for (final g in GameType.values) g: const GameStats()};
    for (final g in GameType.values) {
      unawaited(store.remove(LocalStore.statsKey(g.name)));
    }
  }
}

/// Unlocked content ids, such as boards. Never re-locked.
@Riverpod(keepAlive: true)
class UnlocksController extends _$UnlocksController {
  @override
  Set<String> build() => ref
      .watch(appServicesProvider)
      .store
      .readList(LocalStore.unlocksKey)
      .toSet();

  /// Adds [ids] and returns those that were new.
  Set<String> add(Set<String> ids) {
    final fresh = ids.difference(state);
    if (fresh.isEmpty) return fresh;
    state = {...state, ...fresh};
    unawaited(
      ref
          .read(appServicesProvider)
          .store
          .writeList(LocalStore.unlocksKey, state.toList()..sort()),
    );
    return fresh;
  }
}

/// The saved local game of each game, one slot per game.
@Riverpod(keepAlive: true)
class SavesController extends _$SavesController {
  @override
  Map<GameType, SavedGame> build() {
    final store = ref.watch(appServicesProvider).store;
    final out = <GameType, SavedGame>{};
    for (final g in GameType.values) {
      final key = LocalStore.saveKey(g.name);
      final save = SavedGame.tryParse(store.readJson(key));
      if (save != null && save.game == g) {
        out[g] = save;
      } else if (store.readString(key) != null) {
        unawaited(store.remove(key));
      }
    }
    return out;
  }

  /// Stores [save] in its game's slot.
  void write(SavedGame save) {
    state = {...state, save.game: save};
    unawaited(
      ref
          .read(appServicesProvider)
          .store
          .writeJson(LocalStore.saveKey(save.game.name), save.toJson()),
    );
  }

  /// Empties the slot of [game].
  void delete(GameType game) {
    if (!state.containsKey(game)) return;
    state = {...state}..remove(game);
    unawaited(
      ref.read(appServicesProvider).store.remove(LocalStore.saveKey(game.name)),
    );
  }
}

/// Saved rule settings per game, encoded with each game's config codec.
@Riverpod(keepAlive: true)
class RulesController extends _$RulesController {
  @override
  Map<GameType, Map<String, dynamic>> build() {
    final store = ref.watch(appServicesProvider).store;
    return {
      for (final g in GameType.values)
        g: ?store.readJson(LocalStore.rulesKey(g.name)),
    };
  }

  /// Stores the rule settings of [game].
  void write(GameType game, Map<String, dynamic> config) {
    state = {...state, game: config};
    unawaited(
      ref
          .read(appServicesProvider)
          .store
          .writeJson(LocalStore.rulesKey(game.name), config),
    );
  }
}
