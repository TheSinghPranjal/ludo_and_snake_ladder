import 'package:dice_party/games/snakes/domain/board/jump.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'snakes_events.freezed.dart';
part 'snakes_events.g.dart';

/// Why a token did not move.
enum BlockReason {
  /// A 6 is needed to leave the start pad.
  needSix,

  /// The roll passes 100 and the overshoot rule is "stay put".
  overshoot,
}

/// Something that happened in a Snakes & Ladders game, in order.
@Freezed(unionKey: 'kind')
sealed class SnakesEvent with _$SnakesEvent {
  /// A die was rolled.
  const factory SnakesEvent.diceRolled({
    required PlayerId playerId,
    required int value,
  }) = DiceRolled;

  /// The token hopped through [path], one square per entry.
  const factory SnakesEvent.tokenStepped({
    required PlayerId playerId,
    required int from,
    required List<int> path,
  }) = TokenStepped;

  /// The token climbed a ladder or slid down a snake.
  const factory SnakesEvent.jumpTaken({
    required PlayerId playerId,
    required String jumpId,
    required JumpType type,
    required int from,
    required int to,
  }) = JumpTaken;

  /// The token could not move. [need] is the exact roll needed to finish,
  /// for the overshoot reason.
  const factory SnakesEvent.moveBlocked({
    required PlayerId playerId,
    required BlockReason reason,
    int? need,
  }) = MoveBlocked;

  /// The token reached 100 and walked back through [path].
  const factory SnakesEvent.bounced({
    required PlayerId playerId,
    required int from,
    required List<int> path,
  }) = Bounced;

  /// Opponents on the landing square were sent to 0.
  const factory SnakesEvent.captured({
    required PlayerId playerId,
    required List<PlayerId> victims,
    required int square,
  }) = Captured;

  /// The player rolls again.
  const factory SnakesEvent.extraRoll({required PlayerId playerId}) = ExtraRoll;

  /// A third 6: the turn ends and the token returns to [to].
  const factory SnakesEvent.threeSixesPenalty({
    required PlayerId playerId,
    required int from,
    required int to,
  }) = ThreeSixesPenalty;

  /// The player reached 100 and took [rank].
  const factory SnakesEvent.playerFinished({
    required PlayerId playerId,
    required int rank,
  }) = PlayerFinished;

  /// A player was removed from the game.
  const factory SnakesEvent.playerRemoved({required PlayerId playerId}) =
      PlayerRemoved;

  /// The turn passed to [to].
  const factory SnakesEvent.turnPassed({
    required PlayerId from,
    required PlayerId to,
  }) = TurnPassed;

  /// The game ended with [ranking], best first.
  const factory SnakesEvent.gameOver({required List<PlayerId> ranking}) =
      GameOver;

  /// Reads an event from JSON.
  factory SnakesEvent.fromJson(Map<String, dynamic> json) =>
      _$SnakesEventFromJson(json);
}
