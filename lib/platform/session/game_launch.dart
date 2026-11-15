import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter/foundation.dart';

/// How a game screen starts: a new game or a saved one.
@immutable
sealed class GameLaunch {
  const GameLaunch();

  /// Which game.
  GameType get game;
}

/// A new local game.
final class NewGameLaunch extends GameLaunch {
  /// Creates a launch.
  const NewGameLaunch({
    required this.game,
    required this.seats,
    required this.config,
    required this.mode,
  });

  @override
  final GameType game;

  /// Seats in turn order.
  final List<SeatSpec> seats;

  /// The game's configuration, encoded with its config codec.
  final Map<String, dynamic> config;

  /// Local pass-and-play or Quick Play.
  final GameMode mode;
}

/// A saved local game being continued.
final class ResumeLaunch extends GameLaunch {
  /// Creates a launch.
  const ResumeLaunch(this.save);

  /// The save.
  final SavedGame save;

  @override
  GameType get game => save.game;
}

/// One line of the Results screen.
@immutable
class ResultRow {
  /// Creates a row.
  const ResultRow({
    required this.player,
    required this.place,
    required this.stats,
  });

  /// The player, as at game over.
  final Player player;

  /// Final place, from 1.
  final int place;

  /// The player's game statistics.
  final Map<String, num> stats;
}

/// Everything the shared Results frame shows.
@immutable
class ResultSummary {
  /// Creates a summary.
  const ResultSummary({
    required this.game,
    required this.rows,
    required this.replay,
    this.me,
  });

  /// Which game.
  final GameType game;

  /// Players in final order.
  final List<ResultRow> rows;

  /// The seat statistics were recorded for, if any.
  final PlayerId? me;

  /// Starts the same game again, or null when it cannot be replayed here.
  final NewGameLaunch? replay;
}
