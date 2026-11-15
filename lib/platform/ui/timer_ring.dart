import 'dart:async';
import 'dart:math' as math;

import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/timer/turn_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// The turn timer as a ring around [child]. Shows nothing while the timer
/// is idle.
class TimerRing extends StatefulWidget {
  /// Creates a ring for [timer].
  const TimerRing({
    required this.timer,
    required this.child,
    this.size = 44,
    super.key,
  });

  /// The timer to show.
  final TurnTimer timer;

  /// What the ring surrounds.
  final Widget child;

  /// Outer edge length.
  final double size;

  @override
  State<TimerRing> createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker((_) => setState(() {}));
  StreamSubscription<TimerSnapshot>? _sub;

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void didUpdateWidget(TimerRing old) {
    super.didUpdateWidget(old);
    if (old.timer != widget.timer) _listen();
  }

  void _listen() {
    unawaited(_sub?.cancel());
    _sub = widget.timer.changes.listen((_) => _sync());
    _sync();
  }

  void _sync() {
    if (!mounted) return;
    if (widget.timer.running && !_ticker.isActive) {
      unawaited(_ticker.start());
    } else if (!widget.timer.running && _ticker.isActive) {
      _ticker.stop();
    }
    setState(() {});
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final running = widget.timer.running;
    final left = widget.timer.remaining;
    final fraction = running
        ? left.inMilliseconds / widget.timer.turnLength.inMilliseconds
        : 0.0;
    final warn = running && left <= const Duration(seconds: 5);
    return Semantics(
      label: running ? '${left.inSeconds} seconds left' : null,
      child: SizedBox.square(
        dimension: widget.size,
        child: CustomPaint(
          foregroundPainter: _RingPainter(
            fraction: fraction.clamp(0, 1),
            track: c.outline,
            fill: warn ? c.danger : c.primary,
            visible: running,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.track,
    required this.fill,
    required this.visible,
  });

  final double fraction;
  final Color track;
  final Color fill;
  final bool visible;

  @override
  void paint(Canvas canvas, Size size) {
    if (!visible) return;
    final rect = (Offset.zero & size).deflate(2);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawArc(rect, 0, math.pi * 2, false, p..color = track)
      ..drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * fraction,
        false,
        p..color = fill,
      );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction ||
      old.fill != fill ||
      old.track != track ||
      old.visible != visible;
}
