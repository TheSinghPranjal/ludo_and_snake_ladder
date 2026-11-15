import 'dart:math';

import 'package:dice_party/games/snakes/domain/ai/snakes_ai.dart';
import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_engine.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_events.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_intent.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_state.dart';
import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/game_module.dart';

/// Snakes & Ladders as a [GameModule].
///
/// It is built with the loaded boards, so the engine never does asset I/O.
class SnakesModule
    implements
        GameModule<SnakesState, SnakesIntent, SnakesEvent, SnakesConfig> {
  /// Creates the module for [boards].
  SnakesModule(
    Iterable<BoardDef> boards, {
    BotStrategy bot = const RollingBot(),
  }) : _engine = SnakesEngine(boards),
       _bot = bot;

  final SnakesEngine _engine;
  final BotStrategy _bot;

  /// Known boards by id.
  Map<String, BoardDef> get boards => _engine.boards;

  @override
  GameType get type => GameType.snakes;

  @override
  String get displayName => 'Snakes & Ladders';

  @override
  SnakesConfig get defaultConfig => const SnakesConfig();

  @override
  SnakesState newGame(List<SeatSpec> seats, SnakesConfig config) =>
      _engine.newGame(seats, config);

  @override
  EngineResult<SnakesState, SnakesEvent> apply(
    SnakesState state,
    PlayerId by,
    SnakesIntent intent,
    DiceService dice,
  ) => switch (intent) {
    SnakesRoll() => _engine.roll(state, by, dice),
  };

  @override
  List<SnakesIntent> legalIntents(SnakesState state, PlayerId player) =>
      !state.isOver && state.currentPlayer == player
      ? const [SnakesRoll()]
      : const [];

  /// On expiry the game rolls for the player, and the move then plays
  /// automatically because Snakes & Ladders has no move choice.
  @override
  SnakesIntent? timeoutIntent(SnakesState state) =>
      state.isOver ? null : const SnakesRoll();

  /// Always null: a roll already resolves the whole move.
  @override
  SnakesIntent? autoIntent(SnakesState state) => null;

  @override
  SnakesIntent chooseAi(
    SnakesState state,
    PlayerId ai,
    AiLevel level,
    Random rng,
  ) => _bot.choose(state, ai, legalIntents(state, ai), level, rng);

  @override
  Duration aiThinkDelay(AiLevel level, Random rng, {required bool fast}) =>
      snakesThinkDelay(level, fast: fast);

  @override
  EngineResult<SnakesState, SnakesEvent> removePlayer(
    SnakesState state,
    PlayerId id,
  ) => _engine.removePlayer(state, id);

  @override
  SnakesState updatePlayer(
    SnakesState state,
    PlayerId id,
    Player Function(Player) update,
  ) => state.copyWith(
    players: [
      for (final p in state.players) p.id == id ? update(p) : p,
    ],
  );

  @override
  Map<String, num> statsFor(SnakesState state, PlayerId id) =>
      state.player(id)?.stats ?? const {};

  @override
  Map<String, dynamic> stateToPublicJson(SnakesState state) => state.toJson();

  @override
  SnakesState? stateFromJson(Map<String, dynamic> json) {
    try {
      final state = SnakesState.fromJson(json);
      final board = boards[state.boardId];
      if (board == null ||
          state.snakeCount < minSnakes ||
          state.snakeCount > maxSnakes) {
        return null;
      }
      return state;
    } on Object {
      return null;
    }
  }

  @override
  ModelCodec<SnakesIntent> get intentCodec => const _IntentCodec();

  @override
  ModelCodec<SnakesEvent> get eventCodec => const _EventCodec();

  @override
  ModelCodec<SnakesConfig> get configCodec => _ConfigCodec(boards);
}

class _IntentCodec implements ModelCodec<SnakesIntent> {
  const _IntentCodec();

  @override
  Map<String, dynamic> encode(SnakesIntent value) => switch (value) {
    SnakesRoll() => {'kind': 'roll'},
  };

  @override
  SnakesIntent? decode(Object? json) {
    if (json is! Map || json.length != 1 || json['kind'] != 'roll') {
      return null;
    }
    return const SnakesRoll();
  }
}

class _EventCodec implements ModelCodec<SnakesEvent> {
  const _EventCodec();

  @override
  Map<String, dynamic> encode(SnakesEvent value) => value.toJson();

  @override
  SnakesEvent? decode(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    try {
      return SnakesEvent.fromJson(json);
    } on Object {
      return null;
    }
  }
}

class _ConfigCodec implements ModelCodec<SnakesConfig> {
  const _ConfigCodec(this.boards);

  final Map<String, BoardDef> boards;

  @override
  Map<String, dynamic> encode(SnakesConfig value) => value.toJson();

  @override
  SnakesConfig? decode(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    try {
      final config = SnakesConfig.fromJson(json);
      if (!boards.containsKey(config.boardId) ||
          config.snakeCount < minSnakes ||
          config.snakeCount > maxSnakes) {
        return null;
      }
      return config;
    } on Object {
      return null;
    }
  }
}
