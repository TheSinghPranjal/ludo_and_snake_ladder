import 'dart:async';

import 'package:dice_party/platform/ui/assets.dart';
import 'package:flutter/material.dart';

/// The shared dice: a face, or the tumble frames while [rolling].
///
/// Tapping it, or swiping up when [swipeToRoll] is set, calls [onRoll]
/// while it is enabled.
class DiceView extends StatefulWidget {
  /// Creates a dice.
  const DiceView({
    required this.face,
    required this.rolling,
    this.onRoll,
    this.size = 72,
    this.swipeToRoll = false,
    super.key,
  });

  /// The face shown when not rolling, or null before the first roll.
  final int? face;

  /// Whether the tumble is playing.
  final bool rolling;

  /// Rolls the dice, or null when rolling is not allowed now.
  final VoidCallback? onRoll;

  /// Edge length.
  final double size;

  /// Whether an upward swipe also rolls.
  final bool swipeToRoll;

  @override
  State<DiceView> createState() => _DiceViewState();
}

class _DiceViewState extends State<DiceView> {
  Timer? _frames;
  int _frame = 1;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(DiceView old) {
    super.didUpdateWidget(old);
    if (old.rolling != widget.rolling) _sync();
  }

  void _sync() {
    _frames?.cancel();
    _frames = null;
    if (widget.rolling) {
      _frames = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() => _frame = _frame % 8 + 1);
      });
    }
  }

  @override
  void dispose() {
    _frames?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final face = widget.face;
    final asset = widget.rolling
        ? SharedAssets.diceRoll(_frame, b)
        : SharedAssets.diceFace(face ?? 6, b);
    final enabled = widget.onRoll != null && !widget.rolling;
    final label = widget.rolling
        ? 'Dice rolling'
        : face == null
        ? 'Dice'
        : 'Dice showing $face';
    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: label,
      hint: enabled ? 'Roll the dice' : null,
      child: GestureDetector(
        onTap: enabled ? widget.onRoll : null,
        onVerticalDragEnd: enabled && widget.swipeToRoll
            ? (d) {
                if ((d.primaryVelocity ?? 0) < -200) widget.onRoll!();
              }
            : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: enabled || widget.rolling ? 1 : 0.55,
          child: Image.asset(
            asset,
            width: widget.size,
            height: widget.size,
            gaplessPlayback: true,
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }
}
