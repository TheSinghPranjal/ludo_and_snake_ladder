import 'dart:math' as math;

import 'package:dice_party/games/snakes/application/snakes_controller.dart';
import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/domain/board/coords.dart';
import 'package:dice_party/games/snakes/presentation/theme/board_palette.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Paints a Snakes & Ladders board: tiles, numbers, ladders and the
/// active snakes of a game with [snakeCount] snakes.
class SnakesBoardPainter extends CustomPainter {
  /// Creates a painter.
  SnakesBoardPainter({
    required this.board,
    required this.snakeCount,
    required this.palette,
    this.numbers = true,
  });

  /// The board.
  final BoardDef board;

  /// Snakes in play, 6..8.
  final int snakeCount;

  /// Colours.
  final SnakesBoardPalette palette;

  /// Whether square numbers are drawn (off for small previews).
  final bool numbers;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final cell = w / boardSide;
    final tile = Paint();
    for (var sq = 1; sq <= lastSquare; sq++) {
      final c = squareCell(sq);
      tile.color = (c.row + c.col).isEven ? palette.tileA : palette.tileB;
      canvas.drawRect(
        Rect.fromLTWH(
          c.col * cell,
          (boardSide - 1 - c.row) * cell,
          cell + 0.5,
          cell + 0.5,
        ),
        tile,
      );
    }
    if (numbers) _numbers(canvas, cell);
    final jumps = board.activeJumps(snakeCount);
    for (final j in jumps) {
      if (j.isLadder) _ladder(canvas, w, cell, j.from, j.to);
    }
    for (final j in jumps.reversed) {
      if (j.isSnake) _snake(canvas, w, cell, snakeBodyPoints(j));
    }
  }

  void _numbers(Canvas canvas, double cell) {
    final halo = palette.numberHalo;
    for (var sq = 1; sq <= lastSquare; sq++) {
      final c = squareCell(sq);
      TextPainter(
          text: TextSpan(
            text: '$sq',
            style: TextStyle(
              fontFamily: displayFont,
              fontWeight: FontWeight.w700,
              fontSize: cell * 0.3,
              color: palette.number,
              shadows: halo == null
                  ? null
                  : [Shadow(color: halo, blurRadius: cell * 0.08)],
            ),
          ),
          textDirection: TextDirection.ltr,
        )
        ..layout()
        ..paint(
          canvas,
          Offset(
            c.col * cell + cell * 0.08,
            (boardSide - 1 - c.row) * cell + cell * 0.04,
          ),
        );
    }
  }

  void _ladder(Canvas canvas, double w, double cell, int from, int to) {
    final a = boardOffset(from) * w;
    final b = boardOffset(to) * w;
    final dir = b - a;
    final len = dir.distance;
    final unit = dir / len;
    final normal = Offset(-unit.dy, unit.dx) * (cell * 0.16);
    final outline = Paint()
      ..color = palette.ladderOutline
      ..strokeWidth = cell * 0.11
      ..strokeCap = StrokeCap.round;
    final rail = Paint()
      ..color = palette.ladderRail
      ..strokeWidth = cell * 0.07
      ..strokeCap = StrokeCap.round;
    final rung = Paint()
      ..color = palette.ladderRung
      ..strokeWidth = cell * 0.06
      ..strokeCap = StrokeCap.round;
    final rungs = math.max(2, (len / (cell * 0.4)).floor());
    for (final p in [outline, rail]) {
      for (var i = 1; i < rungs; i++) {
        final m = a + dir * (i / rungs);
        canvas.drawLine(m + normal, m - normal, p == outline ? outline : rung);
      }
      canvas
        ..drawLine(a + normal, b + normal, p)
        ..drawLine(a - normal, b - normal, p);
    }
  }

  void _snake(Canvas canvas, double w, double cell, List<Offset> body) {
    final pts = [for (final p in body) p * w];
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    Paint stroke(Color c, double width) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas
      ..drawPath(path, stroke(palette.snakeOutline, cell * 0.3))
      ..drawPath(path, stroke(palette.snakeBase, cell * 0.22))
      ..drawPath(path, stroke(palette.snakeBelly, cell * 0.05));
    final spot = Paint()..color = palette.snakeSpots;
    var travelled = 0.0;
    var next = cell * 0.5;
    for (var i = 1; i < pts.length - 4; i++) {
      travelled += (pts[i] - pts[i - 1]).distance;
      if (travelled >= next) {
        canvas.drawCircle(pts[i], cell * 0.05, spot);
        next += cell * 0.55;
      }
    }
    final head = pts.first;
    final ahead = pts.length > 3 ? pts[3] : pts.last;
    final back = (head - ahead) / math.max(1, (head - ahead).distance);
    final side = Offset(-back.dy, back.dx);
    canvas
      ..drawCircle(head, cell * 0.2, Paint()..color = palette.snakeOutline)
      ..drawCircle(head, cell * 0.16, Paint()..color = palette.snakeBase);
    for (final s in [1.0, -1.0]) {
      final eye = head + back * (cell * 0.05) + side * (s * cell * 0.08);
      canvas
        ..drawCircle(eye, cell * 0.055, Paint()..color = palette.snakeBelly)
        ..drawCircle(
          eye + back * (cell * 0.015),
          cell * 0.028,
          Paint()..color = palette.snakeOutline,
        );
    }
  }

  @override
  bool shouldRepaint(SnakesBoardPainter old) =>
      old.board != board ||
      old.snakeCount != snakeCount ||
      old.palette != palette ||
      old.numbers != numbers;
}

/// A board drawing, e.g. the live preview beside the snakes stepper.
class SnakesBoardPreview extends StatelessWidget {
  /// Creates a preview.
  const SnakesBoardPreview({
    required this.board,
    required this.snakeCount,
    this.numbers = false,
    super.key,
  });

  /// The board.
  final BoardDef board;

  /// Snakes shown.
  final int snakeCount;

  /// Whether to draw numbers.
  final bool numbers;

  @override
  Widget build(BuildContext context) {
    final palette = SnakesPalettes.of(context).forTheme(board.theme);
    return Semantics(
      label: '${board.name} with $snakeCount snakes',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.frame,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: AspectRatio(
            aspectRatio: 1,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: SnakesBoardPainter(
                  board: board,
                  snakeCount: snakeCount,
                  palette: palette,
                  numbers: numbers,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
