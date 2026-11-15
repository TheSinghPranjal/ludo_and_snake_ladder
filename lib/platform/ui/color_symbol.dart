import 'dart:math' as math;

import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// The colour-blind symbol of [color] (● ■ ▲ ★), drawn as a shape so it
/// never depends on a font having the glyph.
class ColorSymbol extends StatelessWidget {
  /// Creates a symbol.
  const ColorSymbol(this.color, {this.size = 12, super.key});

  /// Which player colour.
  final PlayerColor color;

  /// Edge length.
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      size: Size.square(size),
      painter: _SymbolPainter(color, AppColors.of(context).player(color)),
    ),
  );
}

class _SymbolPainter extends CustomPainter {
  _SymbolPainter(this.kind, this.color);

  final PlayerColor kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    final r = size.width / 2;
    final c = size.center(Offset.zero);
    switch (kind) {
      case PlayerColor.red:
        canvas.drawCircle(c, r * 0.9, p);
      case PlayerColor.blue:
        canvas.drawRect(Rect.fromCircle(center: c, radius: r * 0.8), p);
      case PlayerColor.yellow:
        canvas.drawPath(
          Path()
            ..moveTo(c.dx, c.dy - r)
            ..lineTo(c.dx + r, c.dy + r * 0.8)
            ..lineTo(c.dx - r, c.dy + r * 0.8)
            ..close(),
          p,
        );
      case PlayerColor.green:
        final path = Path();
        for (var i = 0; i < 10; i++) {
          final rad = i.isEven ? r : r * 0.45;
          final a = -math.pi / 2 + i * math.pi / 5;
          final pt = c + Offset(math.cos(a), math.sin(a)) * rad;
          i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
        }
        canvas.drawPath(path..close(), p);
    }
  }

  @override
  bool shouldRepaint(_SymbolPainter old) =>
      old.kind != kind || old.color != color;
}
