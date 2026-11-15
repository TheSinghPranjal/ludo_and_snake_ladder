import 'package:dice_party/games/snakes/domain/board/coords.dart';
import 'package:dice_party/games/snakes/domain/board/jump.dart';

/// Samples per curve segment, matching the design tools.
const int curveSamplesPerSegment = 24;

/// Control points of a snake: head centre, its path, then tail centre.
List<BoardPoint> snakeControlPoints(Jump snake) => [
  squareCentre(snake.from),
  for (final p in snake.path ?? const <List<double>>[]) (x: p[0], y: p[1]),
  squareCentre(snake.to),
];

/// Samples a Catmull-Rom spline through [points], with the end points
/// repeated so the curve passes through every point.
///
/// The same curve draws the snake's body and drives its slide animation.
List<BoardPoint> catmullRom(
  List<BoardPoint> points, {
  int perSegment = curveSamplesPerSegment,
}) {
  if (points.length < 2) return List.of(points);
  final p = [points.first, ...points, points.last];
  final out = <BoardPoint>[];
  for (var i = 1; i < p.length - 2; i++) {
    final p0 = p[i - 1];
    final p1 = p[i];
    final p2 = p[i + 1];
    final p3 = p[i + 2];
    for (var s = 0; s < perSegment; s++) {
      final t = s / perSegment;
      out.add((
        x: _blend(p0.x, p1.x, p2.x, p3.x, t),
        y: _blend(p0.y, p1.y, p2.y, p3.y, t),
      ));
    }
  }
  out.add(points.last);
  return out;
}

double _blend(double a, double b, double c, double d, double t) {
  final t2 = t * t;
  final t3 = t2 * t;
  return 0.5 *
      (2 * b +
          (-a + c) * t +
          (2 * a - 5 * b + 4 * c - d) * t2 +
          (-a + 3 * b - 3 * c + d) * t3);
}
