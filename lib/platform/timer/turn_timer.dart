import 'dart:async';

import 'package:dice_party/core/clock.dart';
import 'package:dice_party/core/constants/timing.dart';

/// Called when the turn timer reaches zero for decision point [turnSeq].
typedef TimerExpiry = void Function(int turnSeq);

/// Snapshot of the turn timer for the UI and for `TimerSync`.
class TimerSnapshot {
  /// Creates a snapshot.
  const TimerSnapshot({
    required this.turnSeq,
    required this.remaining,
    required this.running,
  });

  /// Decision point the timer is bound to, or null when idle.
  final int? turnSeq;

  /// Time left.
  final Duration remaining;

  /// Whether the timer is counting down.
  final bool running;
}

/// The shared 30 s turn timer.
///
/// It is bound to one decision point (`turnSeq`) at a time. When it expires
/// it reports that decision point, and the owner decides whether it still
/// applies; the timer itself never touches game state.
class TurnTimer {
  /// Creates a timer for turns of [turnLength].
  TurnTimer({required Clock clock, this.turnLength = Timing.turn})
    : _clock = clock;

  final Clock _clock;

  /// Full length of a turn.
  final Duration turnLength;

  Timer? _timer;
  DateTime? _deadline;
  int? _turnSeq;
  TimerExpiry? _onExpire;
  final StreamController<TimerSnapshot> _changes =
      StreamController<TimerSnapshot>.broadcast(sync: true);

  /// Emits whenever the timer arms, rebinds, resets or stops.
  Stream<TimerSnapshot> get changes => _changes.stream;

  /// Whether the timer is counting down.
  bool get running => _timer != null;

  /// Decision point the timer is bound to.
  int? get turnSeq => _turnSeq;

  /// Time left, or zero when idle.
  Duration get remaining {
    final deadline = _deadline;
    if (deadline == null || _timer == null) return Duration.zero;
    final left = deadline.difference(_clock.now());
    return left.isNegative ? Duration.zero : left;
  }

  /// Current snapshot.
  TimerSnapshot get snapshot =>
      TimerSnapshot(turnSeq: _turnSeq, remaining: remaining, running: running);

  /// Starts counting down from [remaining] (a full turn by default) for
  /// decision point [turnSeq].
  void arm({
    required int turnSeq,
    required TimerExpiry onExpire,
    Duration? remaining,
  }) {
    _cancel();
    _turnSeq = turnSeq;
    _onExpire = onExpire;
    _start(remaining ?? turnLength);
  }

  /// Moves a running timer to decision point [turnSeq] without changing the
  /// time left, for a second decision in the same turn.
  void rebind(int turnSeq) {
    if (_timer == null) return;
    _turnSeq = turnSeq;
    _emit();
  }

  /// Restarts a full turn for [turnSeq], used on an extra roll.
  void reset(int turnSeq) {
    final onExpire = _onExpire;
    if (onExpire == null) return;
    arm(turnSeq: turnSeq, onExpire: onExpire);
  }

  /// Stops the timer and unbinds it.
  void stop() {
    final wasActive = _timer != null || _turnSeq != null;
    _cancel();
    _turnSeq = null;
    _onExpire = null;
    if (wasActive) _emit();
  }

  /// Stops the timer and closes [changes].
  void dispose() {
    _cancel();
    unawaited(_changes.close());
  }

  void _start(Duration duration) {
    _deadline = _clock.now().add(duration);
    _timer = _clock.timer(duration, _expire);
    _emit();
  }

  void _expire() {
    final seq = _turnSeq;
    final onExpire = _onExpire;
    _timer = null;
    _deadline = null;
    _emit();
    if (seq != null && onExpire != null) onExpire(seq);
  }

  void _cancel() {
    _timer?.cancel();
    _timer = null;
    _deadline = null;
  }

  void _emit() {
    if (!_changes.isClosed) _changes.add(snapshot);
  }
}
