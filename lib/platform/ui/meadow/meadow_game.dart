import 'dart:math' as math;

import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/meadow/meadow_controls.dart';
import 'package:dice_party/platform/ui/meadow/meadow_palette.dart';
import 'package:flutter/material.dart';

/// Game screen frame: the meadow behind everything (washed to night in dark
/// mode) and a safe, width-capped column for the game.
class MeadowGameFrame extends StatelessWidget {
  /// Creates the frame.
  const MeadowGameFrame({required this.child, super.key});

  /// The game layout.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: HomePalette.meadowGreen,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            SharedAssets.meadowBackground,
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            excludeFromSemantics: true,
          ),
          if (dark) const ColoredBox(color: HomePalette.nightWash),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: Space.maxBoard),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Top bar: a cream Pause button, the title on a wooden sign, then
/// [trailing] chips.
class MeadowGameTopBar extends StatelessWidget {
  /// Creates the bar.
  const MeadowGameTopBar({
    required this.title,
    required this.onPause,
    this.trailing = const [],
    super.key,
  });

  /// Title written on the sign.
  final String title;

  /// Opens the Pause menu.
  final VoidCallback onPause;

  /// Chips after the sign.
  final List<Widget> trailing;

  /// Height of the bar.
  static const double height = 60;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.s),
      child: Row(
        children: [
          MeadowIconButton(
            icon: const Icon(Icons.pause_rounded),
            label: 'Pause',
            size: 46,
            onTap: onPause,
          ),
          Expanded(child: MeadowTitleSign(title)),
          ...trailing,
        ],
      ),
    ),
  );
}

/// [text] on the leafy wooden sign.
class MeadowTitleSign extends StatelessWidget {
  /// Creates the sign.
  const MeadowTitleSign(this.text, {super.key});

  /// The title.
  final String text;

  static const double _aspect = 434 / 126;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontFamily: displayFont,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1,
    );
    return Semantics(
      header: true,
      label: text,
      excludeSemantics: true,
      child: Center(
        child: AspectRatio(
          aspectRatio: _aspect,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(SharedAssets.signBlank, excludeFromSemantics: true),
              // The plank's face, between the leaves and below the pegs.
              FractionallySizedBox(
                alignment: const Alignment(0, 0.55),
                widthFactor: 0.7,
                heightFactor: 0.42,
                child: FittedBox(
                  child: Stack(
                    children: [
                      Text(
                        text,
                        maxLines: 1,
                        style: style.copyWith(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..strokeJoin = StrokeJoin.round
                            ..color = HomePalette.signStroke,
                        ),
                      ),
                      Text(
                        text,
                        maxLines: 1,
                        style: style.copyWith(color: HomePalette.signText),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A small raised chip in the top bar: cream with an orange edge, or light
/// blue when [blue].
class MeadowStatChip extends StatelessWidget {
  /// Creates the chip.
  const MeadowStatChip({
    required this.child,
    required this.label,
    this.blue = false,
    super.key,
  });

  /// Content.
  final Widget child;

  /// Accessible label.
  final String label;

  /// Light blue instead of cream.
  final bool blue;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    excludeSemantics: true,
    child: Container(
      height: 38,
      margin: const EdgeInsets.only(left: Space.xs),
      padding: const EdgeInsets.symmetric(horizontal: Space.s + 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: blue
              ? const [HomePalette.turnTop, HomePalette.turnBottom]
              : const [HomePalette.buttonTop, HomePalette.buttonBottom],
        ),
        border: Border.all(
          color: blue ? HomePalette.white : HomePalette.chipEdge,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: HomePalette.cardShadow,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: displayFont,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: HomePalette.navy,
        ),
        child: child,
      ),
    ),
  );
}

/// Gold board surround in [base] (the board theme's frame colour): a light
/// top, a deeper edge and a soft drop shadow.
BoxDecoration meadowBoardFrame(Color base, double radius) => BoxDecoration(
  borderRadius: BorderRadius.circular(radius),
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.lerp(base, HomePalette.white, 0.35)!, base],
  ),
  border: Border.all(
    color: Color.lerp(base, HomePalette.signStroke, 0.25)!,
    width: 2,
  ),
  boxShadow: const [
    BoxShadow(color: HomePalette.shadow, blurRadius: 14, offset: Offset(0, 6)),
  ],
);

/// The turn prompt in bold navy with a white outline, between yellow
/// dashes. Announced as a live region.
class MeadowStatusLine extends StatelessWidget {
  /// Creates the line.
  const MeadowStatusLine(this.text, {super.key});

  /// The prompt.
  final String text;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontFamily: displayFont,
      fontSize: 21,
      fontWeight: FontWeight.w700,
      height: 1.15,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _Dashes(mirror: true),
        const SizedBox(width: Space.s),
        Flexible(
          child: Semantics(
            liveRegion: true,
            label: text,
            excludeSemantics: true,
            child: Stack(
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: style.copyWith(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 5
                      ..strokeJoin = StrokeJoin.round
                      ..color = HomePalette.white,
                  ),
                ),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: style.copyWith(color: HomePalette.navy),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: Space.s),
        const _Dashes(),
      ],
    );
  }
}

class _Dashes extends StatelessWidget {
  const _Dashes({this.mirror = false});

  final bool mirror;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Transform.flip(
      flipX: !mirror,
      child: CustomPaint(
        size: const Size(20, 28),
        painter: _DashesPainter(),
      ),
    ),
  );
}

class _DashesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = HomePalette.statusBurst
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    final c = Offset(size.width, size.height / 2);
    for (final a in [-0.6, 0.0, 0.6]) {
      final d = Offset(-math.cos(a), math.sin(a));
      canvas.drawLine(c + d * size.width * 0.4, c + d * size.width, p);
    }
  }

  @override
  bool shouldRepaint(_DashesPainter oldDelegate) => false;
}

/// The dice standing on a red and gold pedestal with a sunburst behind it.
/// The stage is about twice the dice wide and one and a half times as tall.
class MeadowDiceStage extends StatelessWidget {
  /// Creates the stage around [dice], built at [diceSize].
  const MeadowDiceStage({
    required this.dice,
    required this.diceSize,
    required this.glowing,
    super.key,
  });

  /// The dice widget.
  final Widget dice;

  /// Edge of [dice].
  final double diceSize;

  /// Whether the sunburst shows (the dice can be rolled now).
  final bool glowing;

  @override
  Widget build(BuildContext context) {
    final w = diceSize * 2.1;
    final h = diceSize * 1.45;
    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: CustomPaint(
                painter: _StagePainter(diceSize: diceSize, glowing: glowing),
              ),
            ),
          ),
          Positioned(top: diceSize * 0.02, child: dice),
        ],
      ),
    );
  }
}

class _StagePainter extends CustomPainter {
  _StagePainter({required this.diceSize, required this.glowing});

  final double diceSize;
  final bool glowing;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final d = diceSize;
    final diceCentre = Offset(cx, d * 0.52);

    if (glowing) {
      canvas.drawCircle(
        diceCentre,
        d * 0.95,
        Paint()
          ..shader = const RadialGradient(
            colors: [HomePalette.glow, HomePalette.clear],
          ).createShader(Rect.fromCircle(center: diceCentre, radius: d * 0.95)),
      );
      final ray = Paint()
        ..color = HomePalette.ray
        ..strokeWidth = d * 0.07
        ..strokeCap = StrokeCap.round;
      // Rays fan out to either side of the dice, clear of the prompt above.
      for (final deg in [166, 186, 206, 334, 354, 374]) {
        final a = deg * math.pi / 180;
        final dir = Offset(math.cos(a), math.sin(a));
        canvas.drawLine(
          diceCentre + dir * d * 0.72,
          diceCentre + dir * d * (deg.isEven ? 0.92 : 1.02),
          ray,
        );
      }
    }

    // Pedestal: gold base disc, then the red drum on it.
    final top = d * 0.86;
    void disc(double y, double rx, double ry, double depth, Color face,
        Color side) {
      final faceRect = Rect.fromCenter(
        center: Offset(cx, y),
        width: rx * 2,
        height: ry * 2,
      );
      final sideRect = faceRect.shift(Offset(0, depth));
      canvas
        ..drawOval(sideRect, Paint()..color = side)
        ..drawRect(
          Rect.fromLTRB(faceRect.left, y, faceRect.right, y + depth),
          Paint()..color = side,
        )
        ..drawOval(
          faceRect,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.lerp(face, HomePalette.white, 0.25)!, face],
            ).createShader(faceRect),
        );
    }

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, top + d * 0.42),
        width: d * 2,
        height: d * 0.32,
      ),
      Paint()
        ..color = HomePalette.cardShadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    disc(
      top + d * 0.2,
      d * 0.98,
      d * 0.24,
      d * 0.1,
      HomePalette.pedestalGold,
      HomePalette.pedestalGoldDark,
    );
    disc(
      top,
      d * 0.82,
      d * 0.2,
      d * 0.13,
      HomePalette.pedestalRed,
      HomePalette.pedestalRedDark,
    );
  }

  @override
  bool shouldRepaint(_StagePainter old) =>
      old.diceSize != diceSize || old.glowing != glowing;
}
