import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_stats.freezed.dart';
part 'game_stats.g.dart';

/// How a game was played, for "wins by mode".
enum GameMode {
  /// Pass-and-play, chosen seat by seat.
  local,

  /// Quick Play against the computer.
  ai,

  /// Wi-Fi or hotspot.
  online,
}

/// How a game-specific statistic is kept.
enum StatKind {
  /// Added up over all games.
  total,

  /// The lowest value in a won game, such as fewest turns to win.
  fewestInWin,

  /// The highest value in any game.
  highest,
}

/// One statistic a game shows on the Stats screen and in Results.
@immutable
class StatSpec {
  /// Creates a specification.
  const StatSpec(this.key, this.label, this.kind);

  /// Key in the engine's per-player stats map.
  final String key;

  /// Label shown to the player.
  final String label;

  /// How it is kept across games.
  final StatKind kind;
}

/// Lifetime statistics of one game for this device's player.
@freezed
abstract class GameStats with _$GameStats {
  /// Creates statistics.
  const factory GameStats({
    @Default(0) int played,

    /// Wins keyed by [GameMode] name.
    @Default(<String, int>{}) Map<String, int> wins,

    /// Values keyed by [StatSpec.key].
    @Default(<String, num>{}) Map<String, num> values,
  }) = _GameStats;

  const GameStats._();

  /// Reads statistics from JSON.
  factory GameStats.fromJson(Map<String, dynamic> json) =>
      _$GameStatsFromJson(json);

  /// Wins in every mode.
  int get totalWins => wins.values.fold(0, (a, b) => a + b);

  /// Wins in [mode].
  int winsIn(GameMode mode) => wins[mode.name] ?? 0;

  /// Adds one finished game.
  GameStats record({
    required GameMode mode,
    required bool won,
    required Map<String, num> stats,
    required List<StatSpec> specs,
  }) {
    final next = Map<String, num>.of(values);
    for (final s in specs) {
      final v = stats[s.key];
      if (v == null) continue;
      final old = next[s.key];
      switch (s.kind) {
        case StatKind.total:
          next[s.key] = (old ?? 0) + v;
        case StatKind.highest:
          next[s.key] = old == null ? v : math.max(old, v);
        case StatKind.fewestInWin:
          if (won) next[s.key] = old == null ? v : math.min(old, v);
      }
    }
    return copyWith(
      played: played + 1,
      wins: won ? {...wins, mode.name: winsIn(mode) + 1} : wins,
      values: next,
    );
  }
}
