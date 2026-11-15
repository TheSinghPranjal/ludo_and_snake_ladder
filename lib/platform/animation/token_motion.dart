import 'dart:ui';

/// A token's path for one batch of events, in board-normalised
/// coordinates (0..1 on both axes).
///
/// Each batch creates a new instance; the token layer restarts its
/// animation when the instance changes.
class TokenMotion {
  /// Creates a motion through [points]; [segments] has one duration per
  /// step between consecutive points.
  TokenMotion({
    required this.points,
    required this.segments,
    this.delay = Duration.zero,
  }) : assert(
         points.length == segments.length + 1,
         'one duration per segment',
       );

  /// Waypoints, first to last.
  final List<Offset> points;

  /// Duration of each segment.
  final List<Duration> segments;

  /// Wait before moving, e.g. a captured token waiting for the attacker.
  final Duration delay;

  /// Total length including [delay].
  Duration get total => segments.fold(delay, (a, b) => a + b);

  /// Position after [elapsed].
  Offset at(Duration elapsed) {
    var t = elapsed - delay;
    if (t <= Duration.zero || segments.isEmpty) return points.first;
    for (var i = 0; i < segments.length; i++) {
      final d = segments[i];
      if (t < d) {
        final f = d == Duration.zero
            ? 1.0
            : t.inMicroseconds / d.inMicroseconds;
        return Offset.lerp(points[i], points[i + 1], f)!;
      }
      t -= d;
    }
    return points.last;
  }
}

/// Offsets, in cells, that spread [count] tokens sharing one cell.
///
/// One token sits centred; two sit side by side; three or four form a
/// cluster.
List<Offset> stackOffsets(int count) => switch (count) {
  <= 1 => const [Offset.zero],
  2 => const [Offset(-0.18, 0), Offset(0.18, 0)],
  3 => const [Offset(-0.18, -0.14), Offset(0.18, -0.14), Offset(0, 0.16)],
  _ => const [
    Offset(-0.18, -0.16),
    Offset(0.18, -0.16),
    Offset(-0.18, 0.16),
    Offset(0.18, 0.16),
  ],
};
