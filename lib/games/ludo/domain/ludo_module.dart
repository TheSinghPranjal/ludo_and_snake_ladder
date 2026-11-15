import 'dart:math';

import 'package:dice_party/games/ludo/domain/ai/ludo_ai.dart';
import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_engine.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_events.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_intent.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_state.dart';
import 'package:dice_party/games/ludo/domain/rules/ludo_config.dart';
import 'package:dice_party/games/ludo/domain/rules/moves.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/game_module.dart';

/// Ludo as a [GameModule].
class LudoModule
    implements GameModule<LudoState, LudoIntent, LudoEvent, LudoConfig> {
  /// Creates the module.
  const LudoModule({LudoAi ai = const LudoAi()}) : _ai = ai;

  static const LudoEngine _engine = LudoEngine();
  final LudoAi _ai;

  @override
  GameType get type => GameType.ludo;

  @override
  String get displayName => 'Ludo';

  @override
  LudoConfig get defaultConfig => const LudoConfig();

  @override
  LudoState newGame(List<SeatSpec> seats, LudoConfig config) =>
      _engine.newGame(seats);

  @override
  EngineResult<LudoState, LudoEvent> apply(
    LudoState state,
    PlayerId by,
    LudoIntent intent,
    DiceService dice,
  ) => switch (intent) {
    LudoRoll() => _engine.roll(state, by, dice),
    MoveToken(:final tokenId) => _engine.move(state, by, tokenId),
  };

  /// Legal moves for the current roll, by token index.
  List<Move> movesFor(LudoState state, PlayerId player) {
    final die = state.dice;
    if (state.phase != LudoPhase.awaitingMove ||
        state.currentPlayer != player ||
        die == null) {
      return const [];
    }
    return legalMoves(state, player, die);
  }

  @override
  List<LudoIntent> legalIntents(LudoState state, PlayerId player) {
    if (state.isOver || state.currentPlayer != player) return const [];
    if (state.phase == LudoPhase.awaitingRoll) return const [LudoRoll()];
    return [for (final m in movesFor(state, player)) MoveToken(m.tokenId)];
  }

  /// Before the roll, roll. After it, play the single legal move or apply
  /// the timeout policy.
  @override
  LudoIntent? timeoutIntent(LudoState state) {
    final current = state.currentPlayer;
    if (state.isOver || current == null) return null;
    if (state.phase == LudoPhase.awaitingRoll) return const LudoRoll();
    final moves = movesFor(state, current);
    if (moves.isEmpty) return null;
    return MoveToken(timeoutMove(moves, state.player(current)!.color).tokenId);
  }

  /// The single legal move, played after the auto-move delay. Moves that
  /// differ only in which identical token moves (for example, leaving base
  /// with several tokens there) count as one.
  @override
  LudoIntent? autoIntent(LudoState state) {
    final current = state.currentPlayer;
    if (state.isOver || current == null) return null;
    final moves = movesFor(state, current);
    if (!allEquivalent(moves)) return null;
    return MoveToken(moves.first.tokenId);
  }

  @override
  LudoIntent chooseAi(LudoState state, PlayerId ai, AiLevel level, Random rng) {
    if (state.phase == LudoPhase.awaitingRoll) return const LudoRoll();
    final moves = movesFor(state, ai);
    if (moves.isEmpty) return const LudoRoll();
    return MoveToken(_ai.choose(state, ai, moves, level, rng).tokenId);
  }

  @override
  Duration aiThinkDelay(AiLevel level, Random rng, {required bool fast}) =>
      ludoThinkDelay(rng, fast: fast);

  @override
  EngineResult<LudoState, LudoEvent> removePlayer(
    LudoState state,
    PlayerId id,
  ) => _engine.removePlayer(state, id);

  @override
  LudoState updatePlayer(
    LudoState state,
    PlayerId id,
    Player Function(Player) update,
  ) => state.copyWith(
    players: [for (final p in state.players) p.id == id ? update(p) : p],
  );

  @override
  Map<String, num> statsFor(LudoState state, PlayerId id) =>
      state.player(id)?.stats ?? const {};

  @override
  Map<String, dynamic> stateToPublicJson(LudoState state) => state.toJson();

  @override
  LudoState? stateFromJson(Map<String, dynamic> json) {
    try {
      final state = LudoState.fromJson(json);
      for (final p in state.players) {
        final t = state.tokens[p.id];
        if (t == null ||
            t.length != tokensPerPlayer ||
            t.any((r) => r < baseRel || r > homeRel)) {
          return null;
        }
      }
      return state;
    } on Object {
      return null;
    }
  }

  @override
  ModelCodec<LudoIntent> get intentCodec => const _IntentCodec();

  @override
  ModelCodec<LudoEvent> get eventCodec => const _EventCodec();

  @override
  ModelCodec<LudoConfig> get configCodec => const _ConfigCodec();
}

class _IntentCodec implements ModelCodec<LudoIntent> {
  const _IntentCodec();

  @override
  Map<String, dynamic> encode(LudoIntent value) => switch (value) {
    LudoRoll() => {'kind': 'roll'},
    MoveToken(:final tokenId) => {'kind': 'move', 'tokenId': tokenId},
  };

  @override
  LudoIntent? decode(Object? json) {
    if (json is! Map) return null;
    switch (json['kind']) {
      case 'roll' when json.length == 1:
        return const LudoRoll();
      case 'move' when json.length == 2:
        final id = json['tokenId'];
        if (id is int && id >= 0 && id < tokensPerPlayer) return MoveToken(id);
        return null;
      default:
        return null;
    }
  }
}

class _EventCodec implements ModelCodec<LudoEvent> {
  const _EventCodec();

  @override
  Map<String, dynamic> encode(LudoEvent value) => value.toJson();

  @override
  LudoEvent? decode(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    try {
      return LudoEvent.fromJson(json);
    } on Object {
      return null;
    }
  }
}

class _ConfigCodec implements ModelCodec<LudoConfig> {
  const _ConfigCodec();

  @override
  Map<String, dynamic> encode(LudoConfig value) => value.toJson();

  @override
  LudoConfig? decode(Object? json) {
    if (json is! Map<String, dynamic> || json.isNotEmpty) return null;
    return const LudoConfig();
  }
}
