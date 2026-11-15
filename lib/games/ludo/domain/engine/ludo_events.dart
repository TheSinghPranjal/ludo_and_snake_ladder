import 'package:dice_party/platform/session/game_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ludo_events.freezed.dart';
part 'ludo_events.g.dart';

/// Why a Ludo extra roll was granted.
enum ExtraRollReason {
  /// A 6 was rolled.
  six,

  /// An opponent token was captured.
  capture,

  /// A token reached HOME.
  home,
}

/// Why a Ludo turn passed.
enum PassReason {
  /// The roll left no legal move.
  noMoves,

  /// The move was made and gave no extra roll.
  moved,

  /// The current player was removed.
  removed,

  /// The current player finished.
  finished,

  /// A third six in a row.
  threeSixes,
}

/// Something that happened in a Ludo game, in order.
@Freezed(unionKey: 'kind')
sealed class LudoEvent with _$LudoEvent {
  /// A die was rolled.
  const factory LudoEvent.diceRolled({
    required PlayerId playerId,
    required int value,
  }) = DiceRolled;

  /// A token moved. [path] lists every cell it passes, as `[row, col]`.
  const factory LudoEvent.tokenMoved({
    required PlayerId playerId,
    required int tokenId,
    required int fromRel,
    required int toRel,
    required List<List<int>> path,
  }) = TokenMoved;

  /// An opponent token was sent back to base.
  const factory LudoEvent.tokenCaptured({
    required PlayerId byPlayerId,
    required PlayerId playerId,
    required int tokenId,
    required int fromRel,
  }) = TokenCaptured;

  /// A token reached HOME.
  const factory LudoEvent.tokenHome({
    required PlayerId playerId,
    required int tokenId,
  }) = TokenHome;

  /// The player rolls again.
  const factory LudoEvent.extraRoll({
    required PlayerId playerId,
    required ExtraRollReason reason,
  }) = ExtraRoll;

  /// The third consecutive 6 is not played and the turn ends.
  const factory LudoEvent.threeSixesForfeit({required PlayerId playerId}) =
      ThreeSixesForfeit;

  /// All four tokens are home; the player took [rank].
  const factory LudoEvent.playerFinished({
    required PlayerId playerId,
    required int rank,
  }) = PlayerFinished;

  /// A player was removed; their tokens left the board.
  const factory LudoEvent.playerRemoved({required PlayerId playerId}) =
      PlayerRemoved;

  /// The turn passed to [to].
  const factory LudoEvent.turnPassed({
    required PlayerId from,
    required PlayerId to,
    required PassReason reason,
  }) = TurnPassed;

  /// The game ended with [ranking], best first.
  const factory LudoEvent.gameOver({required List<PlayerId> ranking}) =
      GameOver;

  /// Reads an event from JSON.
  factory LudoEvent.fromJson(Map<String, dynamic> json) =>
      _$LudoEventFromJson(json);
}
