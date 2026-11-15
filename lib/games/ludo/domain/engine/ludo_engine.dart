import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_events.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_state.dart';
import 'package:dice_party/games/ludo/domain/rules/moves.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/game_module.dart';

/// Keys of the per-player statistics a Ludo game records.
abstract final class LudoStats {
  /// Opponent tokens captured.
  static const captures = 'captures';

  /// Own tokens captured by opponents.
  static const timesCaptured = 'timesCaptured';

  /// Sixes rolled.
  static const sixes = 'sixes';

  /// Tokens that reached HOME.
  static const tokensHome = 'tokensHome';

  /// All keys, each starting at zero.
  static const List<String> all = [captures, timesCaptured, sixes, tokensHome];
}

/// The Ludo rules engine. Pure and deterministic given the dice.
class LudoEngine {
  /// Creates an engine.
  const LudoEngine();

  /// Starts a game with seats in clockwise colour order. Throws
  /// [ArgumentError] on an impossible setup.
  LudoState newGame(List<SeatSpec> seats) {
    if (seats.length < 2 || seats.length > 4) {
      throw ArgumentError.value(seats.length, 'seats', 'must be 2 to 4');
    }
    if (seats.map((s) => s.color).toSet().length != seats.length) {
      throw ArgumentError.value(seats, 'seats', 'colours must differ');
    }
    final players = [
      for (final p in playersFromSeats(seats))
        p.copyWith(stats: {for (final k in LudoStats.all) k: 0}),
    ]..sort((a, b) => a.color.index - b.color.index);
    return LudoState(
      players: players,
      tokens: {
        for (final p in players) p.id: List.filled(tokensPerPlayer, baseRel),
      },
      currentPlayer: players.first.id,
      phase: LudoPhase.awaitingRoll,
    );
  }

  Rejected<LudoState, LudoEvent>? _validate(
    LudoState state,
    PlayerId by,
    LudoPhase phase,
  ) {
    if (state.isOver) return Rejected(state, RejectionCode.gameOver);
    final player = state.player(by);
    if (player == null || player.isRemoved) {
      return Rejected(state, RejectionCode.unknownPlayer);
    }
    if (state.currentPlayer != by) {
      return Rejected(state, RejectionCode.notYourTurn);
    }
    if (state.phase != phase) return Rejected(state, RejectionCode.illegalMove);
    return null;
  }

  /// Rolls for [by]. A third consecutive 6 forfeits the turn; a roll with no
  /// legal move passes it.
  EngineResult<LudoState, LudoEvent> roll(
    LudoState state,
    PlayerId by,
    DiceService dice,
  ) {
    final rejected = _validate(state, by, LudoPhase.awaitingRoll);
    if (rejected != null) return rejected;

    final r = dice.roll();
    final t = _Step(state, by)
      ..events.add(LudoEvent.diceRolled(playerId: by, value: r));
    if (r == 6) t.bump(by, LudoStats.sixes, 1);
    final sixes = r == 6 ? state.sixesThisTurn + 1 : 0;
    if (sixes >= 3) {
      t.events.add(LudoEvent.threeSixesForfeit(playerId: by));
      return t.passTurn(PassReason.threeSixes);
    }
    if (legalMoves(state, by, r).isEmpty) {
      return t.passTurn(PassReason.noMoves);
    }
    return Accepted(
      t.build(
        currentPlayer: by,
        phase: LudoPhase.awaitingMove,
        dice: r,
        sixesThisTurn: sixes,
      ),
      t.events,
      TurnSignal.sameTurn,
    );
  }

  /// Moves token [tokenId] of [by] by the pending roll.
  EngineResult<LudoState, LudoEvent> move(
    LudoState state,
    PlayerId by,
    int tokenId,
  ) {
    final rejected = _validate(state, by, LudoPhase.awaitingMove);
    if (rejected != null) return rejected;
    final die = state.dice;
    if (die == null) return Rejected(state, RejectionCode.illegalMove);
    Move? move;
    for (final m in legalMoves(state, by, die)) {
      if (m.tokenId == tokenId) move = m;
    }
    if (move == null) return Rejected(state, RejectionCode.illegalMove);

    final player = state.player(by)!;
    final t = _Step(state, by);
    final path = move.leavesBase
        ? [cellAt(player.color, 0)]
        : [
            for (var r = move.fromRel + 1; r <= move.toRel; r++)
              cellAt(player.color, r),
          ];
    t.tokens[by]![tokenId] = move.toRel;
    t.events.add(
      LudoEvent.tokenMoved(
        playerId: by,
        tokenId: tokenId,
        fromRel: move.fromRel,
        toRel: move.toRel,
        path: [
          for (final c in path) [c.row, c.col],
        ],
      ),
    );
    for (final c in move.captures) {
      t.tokens[c.playerId]![c.tokenId] = baseRel;
      t
        ..bump(by, LudoStats.captures, 1)
        ..bump(c.playerId, LudoStats.timesCaptured, 1)
        ..events.add(
          LudoEvent.tokenCaptured(
            byPlayerId: by,
            playerId: c.playerId,
            tokenId: c.tokenId,
            fromRel: c.rel,
          ),
        );
    }
    if (move.reachesHome) {
      t
        ..bump(by, LudoStats.tokensHome, 1)
        ..events.add(LudoEvent.tokenHome(playerId: by, tokenId: tokenId));
      if (t.tokens[by]!.every((r) => r == homeRel)) return t.finish();
    }
    final reason = move.reachesHome
        ? ExtraRollReason.home
        : move.captures.isNotEmpty
        ? ExtraRollReason.capture
        : die == 6
        ? ExtraRollReason.six
        : null;
    if (reason == null) return t.passTurn(PassReason.moved);
    t.events.add(LudoEvent.extraRoll(playerId: by, reason: reason));
    return Accepted(
      t.build(
        currentPlayer: by,
        phase: LudoPhase.awaitingRoll,
        sixesThisTurn: state.sixesThisTurn,
      ),
      t.events,
      TurnSignal.extraRoll,
    );
  }

  /// Removes [id]: its tokens leave the board and, if it was that player's
  /// turn, the turn passes.
  EngineResult<LudoState, LudoEvent> removePlayer(
    LudoState state,
    PlayerId id,
  ) {
    if (state.isOver) return Rejected(state, RejectionCode.gameOver);
    final player = state.player(id);
    if (player == null || player.isRemoved) {
      return Rejected(state, RejectionCode.unknownPlayer);
    }
    final t = _Step(state, id);
    t.players[t.indexOf(id)] = player.copyWith(
      connection: PlayerConnection.removed,
    );
    t.tokens[id] = List.filled(tokensPerPlayer, baseRel);
    t.leavers.add(id);
    t.events.add(LudoEvent.playerRemoved(playerId: id));
    if (t.activeCount <= 1) return t.endGame();
    if (state.currentPlayer == id) return t.passTurn(PassReason.removed);
    return Accepted(
      t.build(
        currentPlayer: state.currentPlayer,
        phase: state.phase,
        dice: state.dice,
        sixesThisTurn: state.sixesThisTurn,
        bumpSeq: false,
      ),
      t.events,
      TurnSignal.sameTurn,
    );
  }
}

/// Mutable working copy of one state transition.
class _Step {
  _Step(this.state, this.by)
    : players = List.of(state.players),
      tokens = {for (final e in state.tokens.entries) e.key: List.of(e.value)},
      ranking = List.of(state.ranking),
      leavers = List.of(state.leavers);

  final LudoState state;
  final PlayerId by;
  final List<Player> players;
  final Map<PlayerId, List<int>> tokens;
  final List<PlayerId> ranking;
  final List<PlayerId> leavers;
  final List<LudoEvent> events = [];

  int indexOf(PlayerId id) => players.indexWhere((p) => p.id == id);

  int get activeCount => players.where((p) => p.isActive).length;

  void bump(PlayerId id, String key, num by) {
    final i = indexOf(id);
    final p = players[i];
    players[i] = p.copyWith(stats: {...p.stats, key: (p.stats[key] ?? 0) + by});
  }

  Accepted<LudoState, LudoEvent> finish() {
    final rank = ranking.length + 1;
    final i = indexOf(by);
    players[i] = players[i].copyWith(finishedRank: rank);
    ranking.add(by);
    events.add(LudoEvent.playerFinished(playerId: by, rank: rank));
    if (activeCount <= 1) return endGame();
    return passTurn(PassReason.finished);
  }

  Accepted<LudoState, LudoEvent> endGame() {
    final next = build(currentPlayer: null, phase: LudoPhase.gameOver);
    events.add(LudoEvent.gameOver(ranking: finalRanking(next)));
    return Accepted(next, events, TurnSignal.gameOver);
  }

  Accepted<LudoState, LudoEvent> passTurn(PassReason reason) {
    final start = indexOf(by);
    for (var k = 1; k <= players.length; k++) {
      final p = players[(start + k) % players.length];
      if (p.isActive) {
        events.add(LudoEvent.turnPassed(from: by, to: p.id, reason: reason));
        return Accepted(
          build(currentPlayer: p.id, phase: LudoPhase.awaitingRoll),
          events,
          TurnSignal.nextTurn,
        );
      }
    }
    return endGame();
  }

  LudoState build({
    required PlayerId? currentPlayer,
    required LudoPhase phase,
    int? dice,
    int sixesThisTurn = 0,
    bool bumpSeq = true,
  }) => state.copyWith(
    players: List.unmodifiable(players),
    tokens: Map.unmodifiable({
      for (final e in tokens.entries) e.key: List<int>.unmodifiable(e.value),
    }),
    ranking: List.unmodifiable(ranking),
    leavers: List.unmodifiable(leavers),
    currentPlayer: currentPlayer,
    phase: phase,
    dice: dice,
    sixesThisTurn: sixesThisTurn,
    turnSeq: bumpSeq ? state.turnSeq + 1 : state.turnSeq,
  );
}
