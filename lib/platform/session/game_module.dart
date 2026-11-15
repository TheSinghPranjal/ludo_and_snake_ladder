import 'dart:math';

import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_module.freezed.dart';
part 'game_module.g.dart';

/// Identifies a player within one game, for example `p0`.
typedef PlayerId = String;

/// The games the app can host.
enum GameType {
  /// Snakes & Ladders.
  snakes,

  /// Ludo.
  ludo,
}

/// Token colours shared by both games, in Ludo's clockwise turn order.
enum PlayerColor {
  /// Red, colour-blind symbol ●.
  red,

  /// Blue, colour-blind symbol ■.
  blue,

  /// Yellow, colour-blind symbol ▲.
  yellow,

  /// Green, colour-blind symbol ★.
  green,
}

/// Who controls a seat.
enum PlayerKind {
  /// A person on this device.
  human,

  /// A computer player run by the authority.
  ai,

  /// A person on another device.
  remote,
}

/// Computer player strength.
enum AiLevel {
  /// Plays loosely.
  easy,

  /// Plays the best move it finds.
  normal,
}

/// Network state of a seat.
enum PlayerConnection {
  /// Plays on the authority's device.
  local,

  /// Online and connected.
  connected,

  /// Online, inside the reconnect grace period.
  disconnected,

  /// Removed from the game.
  removed,
}

/// Why the engine refused an intent. A rejection never changes state.
enum RejectionCode {
  /// The game has ended.
  gameOver,

  /// The player is not in this game or was removed.
  unknownPlayer,

  /// It is another player's turn.
  notYourTurn,

  /// The intent is not legal at this point.
  illegalMove,

  /// The intent was made for an earlier decision point.
  staleTurn,
}

/// How an accepted intent affects turn flow.
enum TurnSignal {
  /// The same player has another decision in the same turn.
  sameTurn,

  /// The same player rolls again.
  extraRoll,

  /// Another player is now current.
  nextTurn,

  /// The game has ended.
  gameOver,
}

/// Configuration of one seat before a game starts.
@freezed
abstract class SeatSpec with _$SeatSpec {
  /// Creates a seat specification.
  const factory SeatSpec({
    required String name,
    required int avatar,
    required PlayerColor color,
    required PlayerKind kind,
    AiLevel? aiLevel,
    @Default(PlayerConnection.local) PlayerConnection connection,
  }) = _SeatSpec;

  /// Reads a seat from JSON.
  factory SeatSpec.fromJson(Map<String, dynamic> json) =>
      _$SeatSpecFromJson(json);
}

/// A player in a running game.
@freezed
abstract class Player with _$Player {
  /// Creates a player.
  const factory Player({
    required PlayerId id,
    required String name,
    required int avatar,
    required PlayerColor color,
    required PlayerKind kind,
    AiLevel? aiLevel,
    @Default(PlayerConnection.local) PlayerConnection connection,
    int? finishedRank,
    @Default(<String, num>{}) Map<String, num> stats,
  }) = _Player;

  const Player._();

  /// Reads a player from JSON.
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// Whether the player was removed from the game.
  bool get isRemoved => connection == PlayerConnection.removed;

  /// Whether the player has finished.
  bool get isFinished => finishedRank != null;

  /// Whether the player still takes turns.
  bool get isActive => !isRemoved && !isFinished;
}

/// Builds the players for a new game from [seats], with ids `p0`, `p1`...
List<Player> playersFromSeats(List<SeatSpec> seats) => [
  for (var i = 0; i < seats.length; i++)
    Player(
      id: 'p$i',
      name: seats[i].name,
      avatar: seats[i].avatar,
      color: seats[i].color,
      kind: seats[i].kind,
      aiLevel: seats[i].aiLevel,
      connection: seats[i].connection,
    ),
];

/// State every game exposes to the shared platform.
abstract interface class GameState {
  /// All players, including finished and removed ones.
  List<Player> get players;

  /// The player who must act, or null once the game is over.
  PlayerId? get currentPlayer;

  /// Decision-point counter; increases on every accepted intent.
  int get turnSeq;

  /// Whether the game has ended.
  bool get isOver;

  /// Normal finishers, best first.
  List<PlayerId> get ranking;

  /// Removed players, in leaving order.
  List<PlayerId> get leavers;
}

/// The final standings: finishers, then unfinished players, then leavers
/// with later leavers ranked higher.
List<PlayerId> finalRanking(GameState state) => [
  ...state.ranking,
  for (final p in state.players)
    if (!p.isRemoved && !state.ranking.contains(p.id)) p.id,
  ...state.leavers.reversed,
];

/// Result of applying an intent.
sealed class EngineResult<S, E> {
  const EngineResult();
}

/// The intent was legal.
final class Accepted<S, E> extends EngineResult<S, E> {
  /// Creates an accepted result.
  const Accepted(this.state, this.events, this.signal);

  /// The new state.
  final S state;

  /// What happened, in order, for animation and logs.
  final List<E> events;

  /// How turn flow continues.
  final TurnSignal signal;
}

/// The intent was refused and [state] is the identical input state.
final class Rejected<S, E> extends EngineResult<S, E> {
  /// Creates a rejection.
  const Rejected(this.state, this.code);

  /// The unchanged input state.
  final S state;

  /// Why it was refused.
  final RejectionCode code;
}

/// Converts a model to and from JSON.
///
/// [decode] is strict and returns null for any malformed input; it never
/// throws.
abstract interface class ModelCodec<T> {
  /// Encodes [value].
  Map<String, dynamic> encode(T value);

  /// Decodes [json], or returns null when it is malformed.
  T? decode(Object? json);
}

/// A pure-Dart game: rules, engine, AI and serialisation.
///
/// Every intent from a human, a timer, the AI or the network goes through
/// [apply].
abstract interface class GameModule<S extends GameState, I, E, C> {
  /// Which game this is.
  GameType get type;

  /// Human-readable name.
  String get displayName;

  /// Configuration used by Quick Play.
  C get defaultConfig;

  /// Starts a game.
  S newGame(List<SeatSpec> seats, C config);

  /// Applies [intent] by player [by], drawing dice only after validation.
  EngineResult<S, E> apply(S state, PlayerId by, I intent, DiceService dice);

  /// Every intent [player] may make now.
  List<I> legalIntents(S state, PlayerId player);

  /// What to play when the turn timer expires, or null if nothing.
  I? timeoutIntent(S state);

  /// An intent to play automatically without a timeout, or null.
  I? autoIntent(S state);

  /// The computer player's choice. Always one of [legalIntents].
  I chooseAi(S state, PlayerId ai, AiLevel level, Random rng);

  /// How long the computer player pretends to think.
  Duration aiThinkDelay(AiLevel level, Random rng, {required bool fast});

  /// Removes [id] from the game, passing the turn if needed.
  EngineResult<S, E> removePlayer(S state, PlayerId id);

  /// Replaces player [id] with `update(player)`. Rules are unaffected.
  S updatePlayer(S state, PlayerId id, Player Function(Player) update);

  /// Statistics recorded for [id].
  Map<String, num> statsFor(S state, PlayerId id);

  /// The state as JSON safe to broadcast.
  Map<String, dynamic> stateToPublicJson(S state);

  /// Reads a state, or returns null when [json] is malformed.
  S? stateFromJson(Map<String, dynamic> json);

  /// Codec for intents.
  ModelCodec<I> get intentCodec;

  /// Codec for events.
  ModelCodec<E> get eventCodec;

  /// Codec for configuration.
  ModelCodec<C> get configCodec;
}
