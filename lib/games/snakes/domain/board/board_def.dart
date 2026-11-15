import 'package:dice_party/games/snakes/domain/board/jump.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_def.freezed.dart';
part 'board_def.g.dart';

/// Fewest snakes a game may use.
const int minSnakes = 6;

/// Most snakes a game may use, and the number every board defines.
const int maxSnakes = 8;

/// Snake count used when nothing else is chosen.
const int defaultSnakes = 7;

/// How a board is unlocked.
enum UnlockType {
  /// Always available.
  none,

  /// Unlocked after a number of Snakes & Ladders wins.
  snakesWins,
}

/// Unlock requirement of a board.
@freezed
abstract class BoardUnlock with _$BoardUnlock {
  /// Creates an unlock requirement.
  const factory BoardUnlock({required UnlockType type, @Default(0) int count}) =
      _BoardUnlock;

  /// Reads an unlock requirement from JSON.
  factory BoardUnlock.fromJson(Map<String, dynamic> json) =>
      _$BoardUnlockFromJson(json);
}

/// A Snakes & Ladders board: its ladders and its 8 ranked snakes.
@freezed
abstract class BoardDef with _$BoardDef {
  /// Creates a board.
  const factory BoardDef({
    required String id,
    required String name,
    required String theme,
    required int size,
    required BoardUnlock unlock,
    required List<Jump> jumps,
  }) = _BoardDef;

  const BoardDef._();

  /// Reads a board from JSON.
  factory BoardDef.fromJson(Map<String, dynamic> json) =>
      _$BoardDefFromJson(json);

  /// Every ladder.
  List<Jump> get ladders => [
    for (final j in jumps)
      if (j.isLadder) j,
  ];

  /// Every snake, by rank.
  List<Jump> get snakes => [
    for (final j in jumps)
      if (j.isSnake) j,
  ]..sort((a, b) => (a.rank ?? 0).compareTo(b.rank ?? 0));

  /// All ladders plus the snakes ranked 1 to [snakeCount].
  ///
  /// This is the only source of jumps for the engine and the renderer, so a
  /// rank-8 snake can never trigger in a 7-snake game.
  List<Jump> activeJumps(int snakeCount) => [
    for (final j in jumps)
      if (j.isLadder || (j.rank ?? maxSnakes + 1) <= snakeCount) j,
  ];

  /// Active jumps keyed by start square.
  Map<int, Jump> jumpMap(int snakeCount) => {
    for (final j in activeJumps(snakeCount)) j.from: j,
  };
}
