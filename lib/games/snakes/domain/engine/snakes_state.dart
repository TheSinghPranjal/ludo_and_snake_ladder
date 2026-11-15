import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'snakes_state.freezed.dart';
part 'snakes_state.g.dart';

/// Phase of a Snakes & Ladders game.
enum SnakesPhase {
  /// The current player must roll.
  awaitingRoll,

  /// The game has ended.
  gameOver,
}

/// Complete state of a Snakes & Ladders game.
///
/// A roll resolves the whole move inside one `apply`, so the only phase
/// before game over is [SnakesPhase.awaitingRoll].
@freezed
abstract class SnakesState with _$SnakesState implements GameState {
  /// Creates a state.
  const factory SnakesState({
    required String boardId,
    required SnakesRules rules,
    required int snakeCount,
    required List<Player> players,

    /// Square of each player's token, 0 = start pad, keyed by player id.
    required Map<PlayerId, int> positions,
    required PlayerId? currentPlayer,
    required SnakesPhase phase,
    int? lastRoll,

    /// Sixes rolled in a row in the current turn.
    @Default(0) int consecutiveSixes,

    /// Where the current player's token was when the turn began.
    @Default(0) int turnStartPosition,

    /// Turns started so far, from 1.
    @Default(1) int turnNumber,
    @Default(0) int turnSeq,
    @Default(<PlayerId>[]) List<PlayerId> ranking,
    @Default(<PlayerId>[]) List<PlayerId> leavers,
  }) = _SnakesState;

  const SnakesState._();

  /// Reads a state from JSON.
  factory SnakesState.fromJson(Map<String, dynamic> json) =>
      _$SnakesStateFromJson(json);

  @override
  bool get isOver => phase == SnakesPhase.gameOver;

  /// The player with [id], or null.
  Player? player(PlayerId id) {
    for (final p in players) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Square of [id]'s token.
  int positionOf(PlayerId id) => positions[id] ?? 0;
}
