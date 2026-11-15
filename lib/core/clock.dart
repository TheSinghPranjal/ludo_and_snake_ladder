import 'dart:async';

import 'package:clock/clock.dart' as pkg;

/// Source of time and timers, injectable so tests can control time.
abstract interface class Clock {
  /// The current time.
  DateTime now();

  /// Starts a one-shot timer that calls [callback] after [duration].
  Timer timer(Duration duration, void Function() callback);
}

/// The production [Clock].
///
/// It reads `package:clock` and uses zone timers, so it follows
/// `fake_async` automatically inside tests.
class SystemClock implements Clock {
  /// Creates a system clock.
  const SystemClock();

  @override
  DateTime now() => pkg.clock.now();

  @override
  Timer timer(Duration duration, void Function() callback) =>
      Timer(duration, callback);
}
