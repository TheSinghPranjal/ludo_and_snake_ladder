import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ludo_state.freezed.dart';
part 'ludo_state.g.dart';

/// Phase of a Ludo turn.
enum LudoPhase {
  /// The current player must roll.
  awaitingRoll,

  /// The current player must move a token with [LudoState.dice].
  awaitingMove,

  /// The game has ended.
  gameOver,
}

/// Complete state of a Ludo game.
@freezed
abstract class LudoState with _$LudoState implements GameState {
  /// Creates a state.
  const factory LudoState({
    /// Players in clockwise turn order.
    required List<Player> players,

    /// Relative progress of each player's 4 tokens, keyed by player id.
    required Map<PlayerId, List<int>> tokens,
    required PlayerId? currentPlayer,
    required LudoPhase phase,

    /// The roll waiting to be played, during [LudoPhase.awaitingMove].
    int? dice,

    /// Consecutive sixes rolled in the current turn.
    @Default(0) int sixesThisTurn,
    @Default(0) int turnSeq,
    @Default(<PlayerId>[]) List<PlayerId> ranking,
    @Default(<PlayerId>[]) List<PlayerId> leavers,
  }) = _LudoState;

  const LudoState._();

  /// Reads a state from JSON.
  factory LudoState.fromJson(Map<String, dynamic> json) =>
      _$LudoStateFromJson(json);

  @override
  bool get isOver => phase == LudoPhase.gameOver;

  /// The player with [id], or null.
  Player? player(PlayerId id) {
    for (final p in players) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Token progress of [id].
  List<int> tokensOf(PlayerId id) => tokens[id] ?? const [];

  /// Tokens of [id] that reached HOME.
  int homeCount(PlayerId id) => tokensOf(id).where((r) => r == homeRel).length;
}
