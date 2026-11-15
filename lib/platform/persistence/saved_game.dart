import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_game.freezed.dart';
part 'saved_game.g.dart';

/// Version of the [SavedGame] layout. A save with any other version is
/// discarded.
const int saveSchemaVersion = 1;

/// A local game in progress, one slot per game.
@freezed
abstract class SavedGame with _$SavedGame {
  /// Creates a save.
  const factory SavedGame({
    required int schemaVersion,
    required GameType game,
    required GameMode mode,

    /// The game's configuration, through its config codec.
    required Map<String, dynamic> config,

    /// The game's state, through `stateToPublicJson`.
    required Map<String, dynamic> state,

    /// The seat statistics are recorded for, or null if no seat is human.
    PlayerId? me,
  }) = _SavedGame;

  /// Reads a save from JSON.
  factory SavedGame.fromJson(Map<String, dynamic> json) =>
      _$SavedGameFromJson(json);

  /// Reads a save, or returns null when [json] is malformed or from another
  /// schema version.
  static SavedGame? tryParse(Map<String, dynamic>? json) {
    if (json == null || json['schemaVersion'] != saveSchemaVersion) {
      return null;
    }
    try {
      return SavedGame.fromJson(json);
    } on Object {
      return null;
    }
  }
}
