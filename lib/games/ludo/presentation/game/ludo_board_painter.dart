import 'dart:math' as math;

import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/games/ludo/presentation/theme/board_palette.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter/material.dart';

/// Paints the Ludo board from the §3.1 geometry: yards, track, safe cells,
/// home columns and the four-triangle centre.
class LudoBoardPainter extends CustomPainter {
  /// Creates a painter.
  LudoBoardPainter(this.palette);

  /// Colours.
  final LudoBoardPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / gridSize;
    Rect r(int row, int col, [int h = 1, int w = 1]) =>
        Rect.fromLTWH(col * cell, row * cell, w * cell, h * cell);
    final fill = Paint();
    final grid = Paint()
      ..color = palette.grid
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1, cell * 0.03);
    canvas.drawRect(Offset.zero & size, fill..color = palette.base);

    for (final color in PlayerColor.values) {
      final o = yardOrigin[color]!;
      final c = palette.player(color);
      canvas
        ..drawRRect(
          RRect.fromRectAndRadius(
            r(o.row, o.col, 6, 6).deflate(cell * 0.08),
            Radius.circular(cell * 0.4),
          ),
          fill..color = c,
        )
        ..drawRRect(
          RRect.fromRectAndRadius(
            r(o.row + 1, o.col + 1, 4, 4),
            Radius.circular(cell * 0.5),
          ),
          fill..color = palette.yardInner,
        );
      for (final d in const [(2, 2), (4, 2), (2, 4), (4, 4)]) {
        final centre = Offset((o.col + d.$1) * cell, (o.row + d.$2) * cell);
        canvas
          ..drawCircle(
            centre,
            cell * 0.62,
            fill..color = c.withValues(alpha: 0.22),
          )
          ..drawCircle(
            centre,
            cell * 0.62,
            Paint()
              ..color = c
              ..style = PaintingStyle.stroke
              ..strokeWidth = cell * 0.08,
          );
      }
    }

    for (var i = 0; i < trackCells.length; i++) {
      final t = trackCells[i];
      PlayerColor? start;
      startIndex.forEach((color, idx) {
        if (idx == i) start = color;
      });
      final rect = r(t.row, t.col);
      canvas.drawRect(
        rect,
        fill..color = start == null ? palette.cell : palette.player(start!),
      );
      if (start != null) {
        _star(canvas, rect, palette.onPlayer);
      } else if (starIndices.contains(i)) {
        _star(canvas, rect, palette.star);
      }
      canvas.drawRect(rect, grid);
    }
    for (final e in homeColumns.entries) {
      for (final cellPos in e.value) {
        final rect = r(cellPos.row, cellPos.col);
        canvas
          ..drawRect(rect, fill..color = palette.player(e.key))
          ..drawRect(rect, grid);
      }
    }

    final centre = r(6, 6, 3, 3);
    final m = centre.center;
    void tri(Offset a, Offset b, PlayerColor c) {
      canvas.drawPath(
        Path()
          ..moveTo(a.dx, a.dy)
          ..lineTo(b.dx, b.dy)
          ..lineTo(m.dx, m.dy)
          ..close(),
        fill..color = palette.player(c),
      );
    }

    tri(centre.bottomLeft, centre.bottomRight, PlayerColor.red);
    tri(centre.topLeft, centre.bottomLeft, PlayerColor.blue);
    tri(centre.topLeft, centre.topRight, PlayerColor.yellow);
    tri(centre.topRight, centre.bottomRight, PlayerColor.green);
    canvas.drawRect(centre, grid);
  }

  void _star(Canvas canvas, Rect rect, Color color) {
    final c = rect.center;
    final outer = rect.width * 0.32;
    final inner = outer * 0.45;
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final rad = i.isEven ? outer : inner;
      final a = -math.pi / 2 + i * math.pi / 5;
      final p = c + Offset(math.cos(a), math.sin(a)) * rad;
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = rect.width * 0.07
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(LudoBoardPainter old) => old.palette != palette;
}
