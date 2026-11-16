import 'dart:math' as math;

import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/meadow/meadow_palette.dart';
import 'package:flutter/material.dart';

/// Screen frame for the Hub and Settings: the meadow background, a hanging
/// wooden sign with a cream back button beside it, and the dice and pawns
/// resting on the grass at the bottom.
class MeadowFrame extends StatelessWidget {
  /// Creates the meadow frame.
  const MeadowFrame({
    required this.title,
    required this.signAsset,
    required this.signAspect,
    required this.child,
    this.signWidthFactor = 0.6,
    this.showBackButton = true,
    this.onBack,
    this.bottomClearance = 0.16,
    super.key,
  });

  /// The screen title, for accessibility and test lookups (the sign artwork
  /// carries the visible title).
  final String title;

  /// Wooden sign image.
  final String signAsset;

  /// Width / height of [signAsset].
  final double signAspect;

  /// Sign width as a fraction of the content width.
  final double signWidthFactor;

  /// Main screen content; it scrolls when it does not fit.
  final Widget child;

  /// Whether to show the back button (only when the route can pop).
  final bool showBackButton;

  /// Optional back action override.
  final VoidCallback? onBack;

  /// Space left below the content, as a fraction of screen height, so the
  /// dice and pawns stay visible once scrolled to the end.
  final double bottomClearance;

  /// Widest the frame's content gets on tablets.
  static const double maxWidth = 460;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pad = MediaQuery.paddingOf(context);
    final canPop = Navigator.of(context).canPop();
    final w = math.min(size.width, maxWidth);
    final gutter = w * 0.04 + Space.xs;
    final signW = w * signWidthFactor;

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

          // Dice and pawns on the grass, behind the content so they never
          // hide a control.
          Positioned(
            left: size.width * 0.07,
            bottom: pad.bottom + size.height * 0.012,
            width: w * 0.19,
            child: IgnorePointer(
              child: Image.asset(
                SharedAssets.meadowDice,
                excludeFromSemantics: true,
              ),
            ),
          ),
          Positioned(
            right: size.width * 0.06,
            bottom: pad.bottom + size.height * 0.008,
            width: w * 0.22,
            child: IgnorePointer(
              child: Image.asset(
                SharedAssets.meadowPawns,
                excludeFromSemantics: true,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Center(
              child: SizedBox(
                width: w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The sign hangs from the top; the back button sits to
                    // its left, level with the board.
                    SizedBox(
                      height: signW / signAspect,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Semantics(
                            header: true,
                            label: title,
                            excludeSemantics: true,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Invisible, for finders; the sign shows it.
                                Opacity(opacity: 0, child: Text(title)),
                                Image.asset(
                                  signAsset,
                                  width: signW,
                                  excludeFromSemantics: true,
                                ),
                              ],
                            ),
                          ),
                          if (showBackButton && canPop)
                            Positioned(
                              left: gutter,
                              top: signW / signAspect * 0.28,
                              child: MeadowBackButton(onTap: onBack),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          gutter,
                          Space.m,
                          gutter,
                          size.height * bottomClearance + pad.bottom,
                        ),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cream rounded-square back button with a navy chevron.
class MeadowBackButton extends StatefulWidget {
  /// Creates the back button.
  const MeadowBackButton({this.onTap, super.key});

  /// Called when the button is tapped; pops the route by default.
  final VoidCallback? onTap;

  @override
  State<MeadowBackButton> createState() => _MeadowBackButtonState();
}

class _MeadowBackButtonState extends State<MeadowBackButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Back',
      child: Semantics(
        button: true,
        label: 'Back',
        excludeSemantics: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap ?? () => Navigator.of(context).maybePop(),
          child: AnimatedScale(
            scale: _pressed ? 0.9 : 1,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [HomePalette.buttonTop, HomePalette.buttonBottom],
                ),
                border: Border.all(color: HomePalette.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: HomePalette.creamEdge,
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: HomePalette.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 24,
                color: HomePalette.navy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Raised cream pill used for the How to Play button and the settings rows.
class MeadowPill extends StatelessWidget {
  /// Creates the pill.
  const MeadowPill({
    required this.child,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: Space.l),
    super.key,
  });

  /// Pill content.
  final Widget child;

  /// Pill height.
  final double height;

  /// Inner padding.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [HomePalette.buttonTop, HomePalette.pillCream],
        ),
        border: Border.all(color: HomePalette.troughBorder, width: 1.5),
        boxShadow: const [
          BoxShadow(color: HomePalette.creamEdge, offset: Offset(0, 3)),
          BoxShadow(
            color: HomePalette.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
