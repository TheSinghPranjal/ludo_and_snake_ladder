import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/domain/board/coords.dart';
import 'package:dice_party/games/snakes/domain/board/jump.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_events.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_state.dart';
import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/game_module.dart';

/// Keys of the per-player statistics a Snakes & Ladders game records.
abstract final class SnakesStats {
  /// Turns taken.
  static const turns = 'turns';

  /// Ladders climbed.
  static const laddersClimbed = 'laddersClimbed';

  /// Snakes hit.
  static const snakesHit = 'snakesHit';

  /// Squares gained by the longest ladder climbed.
  static const longestClimb = 'longestClimb';

  /// Squares lost to the longest snake slide.
  static const worstSlide = 'worstSlide';

  /// Sixes rolled.
  static const sixes = 'sixes';

  /// Opponents sent back to the start.
  static const captures = 'captures';

  /// All keys, each starting at zero.
  static const List<String> all = [
    turns,
    laddersClimbed,
    snakesHit,
    longestClimb,
    worstSlide,
    sixes,
    captures,
  ];
}

/// Fewest players in a game.
const int minPlayers = 2;

/// Most players in a game.
const int maxPlayers = 4;

/// The Snakes & Ladders rules engine. Pure and deterministic given the dice.
class SnakesEngine {
  /// Creates an engine that knows [boards].
  SnakesEngine(Iterable<BoardDef> boards)
    : boards = {for (final b in boards) b.id: b};

  /// Known boards by id.
  final Map<String, BoardDef> boards;

  /// Starts a game. Throws [ArgumentError] on an impossible setup.
  SnakesState newGame(List<SeatSpec> seats, SnakesConfig config) {
    if (seats.length < minPlayers || seats.length > maxPlayers) {
      throw ArgumentError.value(seats.length, 'seats', 'must be 2 to 4');
    }
    if (!boards.containsKey(config.boardId)) {
      throw ArgumentError.value(config.boardId, 'boardId', 'unknown board');
    }
    if (config.snakeCount < minSnakes || config.snakeCount > maxSnakes) {
      throw ArgumentError.value(config.snakeCount, 'snakeCount', '6 to 8');
    }
    final players = [
      for (final p in playersFromSeats(seats))
        p.copyWith(stats: {for (final k in SnakesStats.all) k: 0}),
    ];
    return SnakesState(
      boardId: config.boardId,
      rules: config.rules,
      snakeCount: config.snakeCount,
      players: players,
      positions: {for (final p in players) p.id: 0},
      currentPlayer: players.first.id,
      phase: SnakesPhase.awaitingRoll,
    );
  }

  /// Resolves a whole roll for [by]: dice, steps, jumps, captures, finish
  /// and turn flow. Validation runs before the die is drawn.
  EngineResult<SnakesState, SnakesEvent> roll(
    SnakesState state,
    PlayerId by,
    DiceService dice,
  ) {
    if (state.isOver) return Rejected(state, RejectionCode.gameOver);
    final player = state.player(by);
    if (player == null || player.isRemoved) {
      return Rejected(state, RejectionCode.unknownPlayer);
    }
    if (state.currentPlayer != by) {
      return Rejected(state, RejectionCode.notYourTurn);
    }
    final board = boards[state.boardId];
    if (board == null) return Rejected(state, RejectionCode.illegalMove);

    final r = dice.roll();
    final t = _Turn(state, by);
    t.events.add(SnakesEvent.diceRolled(playerId: by, value: r));
    if (state.consecutiveSixes == 0) t.bump(by, SnakesStats.turns, 1);
    if (r == 6) t.bump(by, SnakesStats.sixes, 1);
    final sixes = r == 6 ? state.consecutiveSixes + 1 : 0;
    final rules = state.rules;
    final pos = state.positionOf(by);

    if (r == 6 && sixes >= 3 && rules.threeSixesPenalty) {
      t.positions[by] = state.turnStartPosition;
      t.events.add(
        SnakesEvent.threeSixesPenalty(
          playerId: by,
          from: pos,
          to: state.turnStartPosition,
        ),
      );
      return t.passTurn();
    }

    int? landed;
    if (pos == 0 && rules.needSixToStart) {
      if (r == 6) {
        t.events.add(
          SnakesEvent.tokenStepped(playerId: by, from: 0, path: [1]),
        );
        landed = 1;
      } else {
        t.events.add(
          SnakesEvent.moveBlocked(playerId: by, reason: BlockReason.needSix),
        );
      }
    } else if (pos + r > lastSquare) {
      if (rules.overshoot == Overshoot.stay) {
        t.events.add(
          SnakesEvent.moveBlocked(
            playerId: by,
            reason: BlockReason.overshoot,
            need: lastSquare - pos,
          ),
        );
      } else {
        final back = lastSquare - (pos + r - lastSquare);
        t.events
          ..add(
            SnakesEvent.tokenStepped(
              playerId: by,
              from: pos,
              path: [for (var s = pos + 1; s <= lastSquare; s++) s],
            ),
          )
          ..add(
            SnakesEvent.bounced(
              playerId: by,
              from: lastSquare,
              path: [for (var s = lastSquare - 1; s >= back; s--) s],
            ),
          );
        landed = back;
      }
    } else {
      t.events.add(
        SnakesEvent.tokenStepped(
          playerId: by,
          from: pos,
          path: [for (var s = pos + 1; s <= pos + r; s++) s],
        ),
      );
      landed = pos + r;
    }

    if (landed != null) {
      t.positions[by] = _land(t, board, landed);
    }
    if (t.positions[by] == lastSquare) return t.finish();
    if (r == 6 && rules.extraRollOnSix) {
      t.events.add(SnakesEvent.extraRoll(playerId: by));
      return t.accept(
        TurnSignal.extraRoll,
        consecutiveSixes: sixes,
      );
    }
    return t.passTurn();
  }

  /// Applies a jump and the capture rule at [square]. Returns the final
  /// square.
  int _land(_Turn t, BoardDef board, int square) {
    final by = t.by;
    var at = square;
    final jump = board.jumpMap(t.state.snakeCount)[at];
    if (jump != null) {
      t.events.add(
        SnakesEvent.jumpTaken(
          playerId: by,
          jumpId: jump.id,
          type: jump.type,
          from: jump.from,
          to: jump.to,
        ),
      );
      final length = (jump.to - jump.from).abs();
      if (jump.type == JumpType.ladder) {
        t
          ..bump(by, SnakesStats.laddersClimbed, 1)
          ..max(by, SnakesStats.longestClimb, length);
      } else {
        t
          ..bump(by, SnakesStats.snakesHit, 1)
          ..max(by, SnakesStats.worstSlide, length);
      }
      at = jump.to;
    }
    if (t.state.rules.capture && at != lastSquare) {
      final victims = [
        for (final p in t.state.players)
          if (p.id != by && p.isActive && t.positions[p.id] == at) p.id,
      ];
      if (victims.isNotEmpty) {
        for (final v in victims) {
          t.positions[v] = 0;
        }
        t
          ..bump(by, SnakesStats.captures, victims.length)
          ..events.add(
            SnakesEvent.captured(playerId: by, victims: victims, square: at),
          );
      }
    }
    return at;
  }

  /// Removes [id] from the game. Its token leaves the board and, if it was
  /// that player's turn, the turn passes.
  EngineResult<SnakesState, SnakesEvent> removePlayer(
    SnakesState state,
    PlayerId id,
  ) {
    if (state.isOver) return Rejected(state, RejectionCode.gameOver);
    final player = state.player(id);
    if (player == null || player.isRemoved) {
      return Rejected(state, RejectionCode.unknownPlayer);
    }
    final t = _Turn(state, id);
    t.players[t.indexOf(id)] = player.copyWith(
      connection: PlayerConnection.removed,
    );
    t.positions[id] = 0;
    t.leavers.add(id);
    t.events.add(SnakesEvent.playerRemoved(playerId: id));
    if (t.activeCount <= 1) return t.endGame();
    if (state.currentPlayer == id) return t.passTurn();
    return t.accept(TurnSignal.sameTurn, bumpSeq: false);
  }
}

/// Mutable working copy of one state transition.
class _Turn {
  _Turn(this.state, this.by)
    : players = List.of(state.players),
      positions = Map.of(state.positions),
      ranking = List.of(state.ranking),
      leavers = List.of(state.leavers);

  final SnakesState state;
  final PlayerId by;
  final List<Player> players;
  final Map<PlayerId, int> positions;
  final List<PlayerId> ranking;
  final List<PlayerId> leavers;
  final List<SnakesEvent> events = [];

  int indexOf(PlayerId id) => players.indexWhere((p) => p.id == id);

  int get activeCount => players.where((p) => p.isActive).length;

  void bump(PlayerId id, String key, num by) {
    final i = indexOf(id);
    final p = players[i];
    players[i] = p.copyWith(stats: {...p.stats, key: (p.stats[key] ?? 0) + by});
  }

  void max(PlayerId id, String key, num value) {
    final i = indexOf(id);
    final p = players[i];
    if ((p.stats[key] ?? 0) >= value) return;
    players[i] = p.copyWith(stats: {...p.stats, key: value});
  }

  Accepted<SnakesState, SnakesEvent> finish() {
    final rank = ranking.length + 1;
    final i = indexOf(by);
    players[i] = players[i].copyWith(finishedRank: rank);
    ranking.add(by);
    events.add(SnakesEvent.playerFinished(playerId: by, rank: rank));
    if (state.rules.playTo == PlayTo.firstWinner || activeCount <= 1) {
      return endGame();
    }
    return passTurn();
  }

  Accepted<SnakesState, SnakesEvent> endGame() {
    final next = _build(currentPlayer: null, phase: SnakesPhase.gameOver);
    events.add(SnakesEvent.gameOver(ranking: finalRanking(next)));
    return Accepted(next, events, TurnSignal.gameOver);
  }

  Accepted<SnakesState, SnakesEvent> passTurn() {
    final start = players.indexWhere((p) => p.id == by);
    for (var k = 1; k <= players.length; k++) {
      final p = players[(start + k) % players.length];
      if (p.isActive) {
        events.add(SnakesEvent.turnPassed(from: by, to: p.id));
        return Accepted(
          _build(
            currentPlayer: p.id,
            phase: SnakesPhase.awaitingRoll,
            turnStartPosition: positions[p.id] ?? 0,
            turnNumber: state.turnNumber + 1,
          ),
          events,
          TurnSignal.nextTurn,
        );
      }
    }
    return endGame();
  }

  Accepted<SnakesState, SnakesEvent> accept(
    TurnSignal signal, {
    int? consecutiveSixes,
    bool bumpSeq = true,
  }) => Accepted(
    _build(
      currentPlayer: state.currentPlayer,
      phase: state.phase,
      consecutiveSixes: consecutiveSixes ?? state.consecutiveSixes,
      turnStartPosition: state.turnStartPosition,
      turnNumber: state.turnNumber,
      bumpSeq: bumpSeq,
    ),
    events,
    signal,
  );

  SnakesState _build({
    required PlayerId? currentPlayer,
    required SnakesPhase phase,
    int consecutiveSixes = 0,
    int? turnStartPosition,
    int? turnNumber,
    bool bumpSeq = true,
  }) {
    final rolled = events.whereType<DiceRolled>().map((e) => e.value);
    return state.copyWith(
      players: List.unmodifiable(players),
      positions: Map.unmodifiable(positions),
      ranking: List.unmodifiable(ranking),
      leavers: List.unmodifiable(leavers),
      currentPlayer: currentPlayer,
      phase: phase,
      lastRoll: rolled.isEmpty ? state.lastRoll : rolled.last,
      consecutiveSixes: consecutiveSixes,
      turnStartPosition: turnStartPosition ?? state.turnStartPosition,
      turnNumber: turnNumber ?? state.turnNumber,
      turnSeq: bumpSeq ? state.turnSeq + 1 : state.turnSeq,
    );
  }
}
