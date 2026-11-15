import 'dart:async';

import 'package:dice_party/core/clock.dart';

/// Runs automatic actions (timer expiry, single-move auto play, AI) with the
/// guards every automatic action needs.
///
/// 1. An action is bound to the `turnSeq` it was scheduled for.
/// 2. It fires at the later of its delay and its gate future.
/// 3. At fire time it is dropped if the decision point moved on or the game
///    is over.
/// 4. Each decision point can be claimed by one action only.
class AutoPlayScheduler {
  /// Creates a scheduler that reads the live decision point through
  /// [currentTurnSeq] and [isOver].
  AutoPlayScheduler({
    required Clock clock,
    required int Function() currentTurnSeq,
    required bool Function() isOver,
  }) : _clock = clock,
       _currentTurnSeq = currentTurnSeq,
       _isOver = isOver;

  final Clock _clock;
  final int Function() _currentTurnSeq;
  final bool Function() _isOver;
  final Set<int> _claimed = {};
  final Set<_Pending> _pending = {};
  bool _disposed = false;

  /// Number of actions waiting to fire.
  int get pendingCount => _pending.length;

  /// Whether decision point [turnSeq] has already been acted on.
  bool isClaimed(int turnSeq) => _claimed.contains(turnSeq);

  /// Claims [turnSeq] for an action. Returns false if it was already
  /// claimed, has moved on, or the game is over.
  bool claim(int turnSeq) {
    if (_disposed || _isOver() || _currentTurnSeq() != turnSeq) return false;
    return _claimed.add(turnSeq);
  }

  /// Schedules [action] for decision point [turnSeq] after [delay], and not
  /// before [gate] completes.
  void schedule({
    required int turnSeq,
    required Duration delay,
    required void Function() action,
    Future<void>? gate,
  }) {
    if (_disposed) return;
    final pending = _Pending(turnSeq, action);
    _pending.add(pending);
    var waiting = gate == null ? 1 : 2;
    void ready() {
      waiting--;
      if (waiting == 0) _fire(pending);
    }

    pending.timer = _clock.timer(delay, ready);
    if (gate != null) {
      unawaited(gate.then((_) => ready(), onError: (Object _) => ready()));
    }
  }

  /// Runs [action] now if [turnSeq] can be claimed. Returns whether it ran.
  bool runNow(int turnSeq, void Function() action) {
    if (!claim(turnSeq)) return false;
    action();
    return true;
  }

  /// Drops every pending action.
  void cancelAll() {
    for (final p in _pending) {
      p.timer?.cancel();
      p.cancelled = true;
    }
    _pending.clear();
  }

  /// Drops pending actions and refuses new ones.
  void dispose() {
    cancelAll();
    _disposed = true;
  }

  void _fire(_Pending pending) {
    if (pending.cancelled) return;
    _pending.remove(pending);
    runNow(pending.turnSeq, pending.action);
  }
}

class _Pending {
  _Pending(this.turnSeq, this.action);

  final int turnSeq;
  final void Function() action;
  Timer? timer;
  bool cancelled = false;
}
