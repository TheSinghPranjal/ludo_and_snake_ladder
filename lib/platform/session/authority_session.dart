import 'dart:async';
import 'dart:math';

import 'package:dice_party/core/clock.dart';
import 'package:dice_party/core/constants/timing.dart';
import 'package:dice_party/platform/animation/animation_gate.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/timer/auto_play_scheduler.dart';
import 'package:dice_party/platform/timer/turn_timer.dart';

/// One change to the authoritative state.
class SessionUpdate<S, E> {
  /// Creates an update.
  const SessionUpdate({
    required this.state,
    required this.events,
    this.signal,
    this.actor,
  });

  /// The new state.
  final S state;

  /// What happened, in order. Empty for player updates.
  final List<E> events;

  /// Turn flow after an accepted intent, or null for player updates.
  final TurnSignal? signal;

  /// Who acted, or null for removals and player updates.
  final PlayerId? actor;
}

/// The single owner of engine calls, the turn timer, automatic moves and
/// AI for one game.
///
/// Local and Wi-Fi sessions both wrap it, so timing behaviour cannot differ
/// between them. Every action, human or automatic, goes through
/// [GameModule.apply].
class AuthoritySession<S extends GameState, I, E, C> {
  /// Creates a session for [initial].
  AuthoritySession({
    required this.module,
    required S initial,
    required DiceService dice,
    Clock clock = const SystemClock(),
    this.timerEnabled = false,
    this.fast = false,
    AnimationGate gate = const ImmediateGate(),
    Random? aiRandom,
    this.autoMoveDelay = Timing.autoMove,
    Duration turnLength = Timing.turn,
  }) : _state = initial,
       _dice = dice,
       _gate = gate,
       _aiRandom = aiRandom ?? Random() {
    timer = TurnTimer(clock: clock, turnLength: turnLength);
    scheduler = AutoPlayScheduler(
      clock: clock,
      currentTurnSeq: () => _state.turnSeq,
      isOver: () => _state.isOver,
    );
  }

  /// The game's rules.
  final GameModule<S, I, E, C> module;

  /// Whether human and remote seats get the turn timer.
  final bool timerEnabled;

  /// Whether AI think time is halved.
  final bool fast;

  /// Delay from committing a roll to playing a single legal move.
  final Duration autoMoveDelay;

  /// The turn timer.
  late final TurnTimer timer;

  /// Guards for automatic actions.
  late final AutoPlayScheduler scheduler;

  final DiceService _dice;
  final AnimationGate _gate;
  final Random _aiRandom;
  final StreamController<SessionUpdate<S, E>> _updates =
      StreamController<SessionUpdate<S, E>>.broadcast(sync: true);
  S _state;
  bool _timedOut = false;
  bool _started = false;
  bool _disposed = false;
  bool _paused = false;
  PresentationHandle _lastHandle = PresentationHandle.immediate();

  /// The authoritative state.
  S get state => _state;

  /// Every accepted change, in order.
  Stream<SessionUpdate<S, E>> get updates => _updates.stream;

  /// Begins the first decision point. Call once.
  void start() {
    if (_started || _disposed) return;
    _started = true;
    _plan(PresentationHandle.immediate());
  }

  /// Applies [intent] for player [by]. When [turnSeq] is given it must match
  /// the current decision point, otherwise the intent is stale.
  EngineResult<S, E> submitAs(PlayerId by, I intent, {int? turnSeq}) {
    if (_disposed) return Rejected(_state, RejectionCode.gameOver);
    if (turnSeq != null && turnSeq != _state.turnSeq) {
      return Rejected(_state, RejectionCode.staleTurn);
    }
    final result = module.apply(_state, by, intent, _dice);
    if (result is Accepted<S, E>) _accept(result, by);
    return result;
  }

  /// Whether [pause] is in effect.
  bool get paused => _paused;

  /// Stops the turn timer and every pending automatic action, e.g. while a
  /// local game's pause menu is open. Human intents are still accepted.
  void pause() {
    if (_paused || _disposed) return;
    _paused = true;
    timer.stop();
    scheduler.cancelAll();
  }

  /// Resumes after [pause]. The current decision point is planned again,
  /// still waiting for the last batch's animations, and a running turn
  /// timer restarts from its full length.
  void resume() {
    if (!_paused || _disposed) return;
    _paused = false;
    if (_started) _plan(_lastHandle);
  }

  /// Removes player [id] from the game.
  EngineResult<S, E> removePlayer(PlayerId id) {
    if (_disposed) return Rejected(_state, RejectionCode.gameOver);
    final before = _state.turnSeq;
    final result = module.removePlayer(_state, id);
    if (result is Accepted<S, E>) {
      if (result.state.turnSeq == before) {
        _state = result.state;
        _emit(SessionUpdate(state: _state, events: result.events));
      } else {
        _accept(result, null);
      }
    }
    return result;
  }

  /// Updates player [id], for example a connection change or a takeover by
  /// AI. If the current player's kind changes, the decision is re-planned.
  void updatePlayer(PlayerId id, Player Function(Player) update) {
    if (_disposed) return;
    final before = _player(id)?.kind;
    _state = module.updatePlayer(_state, id, update);
    _emit(SessionUpdate(state: _state, events: const []));
    if (_started && id == _state.currentPlayer && _player(id)?.kind != before) {
      timer.stop();
      scheduler.cancelAll();
      _plan(PresentationHandle.immediate());
    }
  }

  /// Stops all timers and closes [updates].
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    scheduler.dispose();
    timer.dispose();
    unawaited(_updates.close());
  }

  Player? _player(PlayerId? id) {
    for (final p in _state.players) {
      if (p.id == id) return p;
    }
    return null;
  }

  void _emit(SessionUpdate<S, E> update) {
    if (!_updates.isClosed) _updates.add(update);
  }

  void _accept(Accepted<S, E> result, PlayerId? actor) {
    _state = result.state;
    scheduler.cancelAll();
    final handle = _gate.present(result.events);
    _lastHandle = handle;
    _emit(
      SessionUpdate(
        state: _state,
        events: result.events,
        signal: result.signal,
        actor: actor,
      ),
    );
    if (_state.isOver) {
      timer.stop();
      return;
    }
    if (result.signal == TurnSignal.sameTurn) {
      timer.rebind(_state.turnSeq);
    } else {
      timer.stop();
      _timedOut = false;
    }
    if (_started) _plan(handle);
  }

  /// Schedules whatever should happen at the current decision point.
  void _plan(PresentationHandle handle) {
    if (_paused) return;
    final seq = _state.turnSeq;
    final current = _player(_state.currentPlayer);
    if (_state.isOver || current == null) return;

    final auto = module.autoIntent(_state);
    if (auto != null) {
      scheduler.schedule(
        turnSeq: seq,
        delay: autoMoveDelay,
        gate: handle.diceLanded,
        action: () => submitAs(current.id, auto),
      );
      return;
    }
    if (current.kind == PlayerKind.ai) {
      timer.stop();
      final delay = module.aiThinkDelay(
        current.aiLevel ?? AiLevel.normal,
        _aiRandom,
        fast: fast,
      );
      unawaited(
        handle.drained.then((_) {
          if (_disposed || _paused || _state.turnSeq != seq) return;
          scheduler.schedule(
            turnSeq: seq,
            delay: delay,
            action: () => submitAs(
              current.id,
              module.chooseAi(
                _state,
                current.id,
                current.aiLevel ?? AiLevel.normal,
                _aiRandom,
              ),
            ),
          );
        }),
      );
      return;
    }
    if (_timedOut) {
      final intent = module.timeoutIntent(_state);
      if (intent != null) {
        scheduler.schedule(
          turnSeq: seq,
          delay: Duration.zero,
          gate: handle.diceLanded,
          action: () => submitAs(current.id, intent),
        );
      }
      return;
    }
    if (timerEnabled && !timer.running) {
      unawaited(
        handle.drained.then((_) {
          if (_disposed || _paused || _state.isOver) return;
          if (_state.turnSeq != seq) return;
          if (!timer.running) timer.arm(turnSeq: seq, onExpire: _onExpire);
        }),
      );
    }
  }

  void _onExpire(int seq) {
    scheduler.runNow(seq, () {
      final intent = module.timeoutIntent(_state);
      final current = _state.currentPlayer;
      if (intent == null || current == null) return;
      _timedOut = true;
      submitAs(current, intent);
    });
  }
}
