import 'dart:async';
import 'dart:collection';

import 'package:dice_party/core/clock.dart';
import 'package:dice_party/core/constants/timing.dart';
import 'package:dice_party/platform/animation/animation_gate.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/authority_session.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/timer/turn_timer.dart';
import 'package:flutter/foundation.dart';

/// Timing of one batch of events on screen.
@immutable
class BatchTiming {
  /// Creates a timing.
  const BatchTiming({this.dice, this.move = Duration.zero});

  /// The rolled value, if the batch starts with a roll.
  final int? dice;

  /// How long the board animates after the dice lands.
  final Duration move;
}

class _Batch<S, E> {
  _Batch(this.events);

  final List<E> events;
  late S state;
  final Completer<void> landed = Completer<void>();
  final Completer<void> drained = Completer<void>();

  PresentationHandle get handle =>
      PresentationHandle(diceLanded: landed.future, drained: drained.future);
}

/// Runs one local (pass-and-play or Quick Play) game on this device.
///
/// It owns an [AuthoritySession], so every action of a human, the AI or
/// the turn timer goes through the engine. It is also the session's
/// [AnimationGate]: each accepted batch is shown in order (the dice
/// tumble, then the board), and automatic actions wait for it. The game is
/// saved after every accepted intent and the save is deleted at game over.
abstract class LocalGameController<S extends GameState, I, E, C>
    extends ChangeNotifier
    implements AnimationGate {
  /// Creates a controller for [initial].
  LocalGameController({
    required this.module,
    required S initial,
    required this.config,
    required this.mode,
    required DiceService dice,
    this.me,
    Clock clock = const SystemClock(),
    bool timerEnabled = false,
    this.fast = false,
    this.onSave,
    Duration autoMoveDelay = Timing.autoMove,
    this.diceDuration = Timing.dice,
  }) : _shown = initial,
       _clock = clock {
    session = AuthoritySession<S, I, E, C>(
      module: module,
      initial: initial,
      dice: dice,
      clock: clock,
      timerEnabled: timerEnabled,
      fast: fast,
      gate: this,
      autoMoveDelay: autoMoveDelay,
    );
    _sub = session.updates.listen(_onUpdate);
  }

  /// The game's rules.
  final GameModule<S, I, E, C> module;

  /// The configuration the game started with.
  final C config;

  /// Pass-and-play or Quick Play.
  final GameMode mode;

  /// The seat this device's statistics follow, if any.
  final PlayerId? me;

  /// Whether Fast animation speed is on.
  final bool fast;

  /// Receives the save after every accepted intent, or null to delete it.
  final void Function(SavedGame? save)? onSave;

  /// Length of the dice tumble on screen.
  final Duration diceDuration;

  /// The authority.
  late final AuthoritySession<S, I, E, C> session;

  final Clock _clock;
  late final StreamSubscription<SessionUpdate<S, E>> _sub;
  final Queue<_Batch<S, E>> _queue = Queue<_Batch<S, E>>();
  final Set<Timer> _timers = {};
  _Batch<S, E>? _pending;
  S _shown;
  bool _playing = false;
  bool _rolling = false;
  bool _disposed = false;
  int? _diceFace;
  String _status = '';
  final Completer<S> _over = Completer<S>();

  /// The state the board shows: the authority's state once its batch has
  /// been presented.
  S get state => _shown;

  /// The turn timer, for the ring on the active card.
  TurnTimer get timer => session.timer;

  /// Whether the dice is tumbling.
  bool get rolling => _rolling;

  /// The face the dice shows, or null before the first roll.
  int? get diceFace => _diceFace;

  /// The status line.
  String get status => _status;

  /// Whether every batch has been shown.
  bool get idle => !_playing && _queue.isEmpty;

  /// Completes with the final state once game over has been shown.
  Future<S> get finished => _over.future;

  /// Whether the paused flag is set.
  bool get paused => session.paused;

  /// The player whose turn the board shows.
  Player? get current => _player(_shown.currentPlayer);

  /// Whether a person on this device may act now.
  bool get humanCanAct {
    final p = _player(session.state.currentPlayer);
    return idle &&
        !_disposed &&
        !session.state.isOver &&
        p != null &&
        p.kind == PlayerKind.human &&
        _shown.turnSeq == session.state.turnSeq;
  }

  /// Starts the first turn.
  void start() {
    _status = describeTurn(_shown);
    session.start();
    notifyListeners();
  }

  /// Submits [intent] for the current human player.
  EngineResult<S, E>? submit(I intent) {
    if (!humanCanAct) return null;
    final s = session.state;
    return session.submitAs(s.currentPlayer!, intent, turnSeq: s.turnSeq);
  }

  /// Pauses the timer and the computer players.
  void pause() {
    session.pause();
    notifyListeners();
  }

  /// Resumes after [pause].
  void resume() {
    session.resume();
    notifyListeners();
  }

  /// Saves the game now, e.g. before leaving to the menu.
  void saveNow() => _save(session.state);

  /// Timing of [events], which turned [before] into the next state.
  @protected
  BatchTiming timing(List<E> events, S before);

  /// Status line after [events], or null for the turn prompt.
  @protected
  String? describe(List<E> events, S before, S next);

  /// Status line at the start of a turn in [state].
  @protected
  String describeTurn(S state);

  /// Called when the dice starts tumbling.
  @protected
  void onDiceStart() {}

  /// Called when the dice of [events] lands.
  @protected
  void onDiceLanded(List<E> events) {}

  /// Called when the board starts showing [events].
  @protected
  void onBoardChange(List<E> events, S before, S next) {}

  @override
  PresentationHandle present(List<Object?> events) {
    final b = _Batch<S, E>(events.cast<E>());
    _pending = b;
    return b.handle;
  }

  void _onUpdate(SessionUpdate<S, E> u) {
    final b = _pending ?? _instant(u.events);
    _pending = null;
    b.state = u.state;
    _queue.add(b);
    _save(u.state);
    if (!_playing) unawaited(_drain());
  }

  _Batch<S, E> _instant(List<E> events) => _Batch<S, E>(events);

  void _save(S s) {
    final cb = onSave;
    if (cb == null) return;
    if (s.isOver) {
      cb(null);
      return;
    }
    cb(
      SavedGame(
        schemaVersion: saveSchemaVersion,
        game: module.type,
        mode: mode,
        config: module.configCodec.encode(config),
        state: module.stateToPublicJson(s),
        me: me,
      ),
    );
  }

  Future<void> _drain() async {
    _playing = true;
    while (_queue.isNotEmpty && !_disposed) {
      await _play(_queue.removeFirst());
    }
    if (_disposed) return;
    _playing = false;
    if (_shown.isOver) {
      if (!_over.isCompleted) _over.complete(_shown);
    } else if (_status.isEmpty) {
      _status = describeTurn(_shown);
    }
    notifyListeners();
  }

  Future<void> _play(_Batch<S, E> b) async {
    final before = _shown;
    final t = timing(b.events, before);
    final dice = t.dice;
    if (dice != null) {
      _rolling = true;
      onDiceStart();
      notifyListeners();
      await _wait(diceDuration);
      if (_disposed) return;
      _rolling = false;
      _diceFace = dice;
      onDiceLanded(b.events);
    }
    b.landed.complete();
    _shown = b.state;
    _status = describe(b.events, before, b.state) ?? describeTurn(b.state);
    onBoardChange(b.events, before, b.state);
    notifyListeners();
    if (t.move > Duration.zero) await _wait(t.move);
    if (_disposed) return;
    b.drained.complete();
  }

  /// Runs [action] after [delay] unless the controller is disposed first,
  /// e.g. a sound timed to the middle of an animation.
  @protected
  void after(Duration delay, VoidCallback action) {
    unawaited(
      _wait(delay).then((_) {
        if (!_disposed) action();
      }),
    );
  }

  /// The seats that would start this game again.
  List<SeatSpec> get replaySeats => [
    for (final p in session.state.players)
      SeatSpec(
        name: p.name,
        avatar: p.avatar,
        color: p.color,
        kind: p.kind,
        aiLevel: p.aiLevel,
      ),
  ];

  /// Final places and statistics of [finalState].
  List<ResultRow> resultRows(S finalState) {
    final order = finalRanking(finalState);
    return [
      for (var i = 0; i < order.length; i++)
        if (_find(finalState, order[i]) case final p?)
          ResultRow(
            player: p,
            place: i + 1,
            stats: module.statsFor(finalState, p.id),
          ),
    ];
  }

  static Player? _find(GameState s, PlayerId id) {
    for (final p in s.players) {
      if (p.id == id) return p;
    }
    return null;
  }

  Future<void> _wait(Duration d) {
    final c = Completer<void>();
    late final Timer timer;
    timer = _clock.timer(d, () {
      _timers.remove(timer);
      c.complete();
    });
    _timers.add(timer);
    return c.future;
  }

  Player? _player(PlayerId? id) {
    for (final p in _shown.players) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  void dispose() {
    _disposed = true;
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
    unawaited(_sub.cancel());
    session.dispose();
    super.dispose();
  }
}
