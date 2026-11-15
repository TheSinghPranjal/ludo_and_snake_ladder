import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:flutter/material.dart';

/// Chooses the number of snakes, 6 to 8. The ends disable the buttons.
class SnakesStepper extends StatelessWidget {
  /// Creates a stepper.
  const SnakesStepper({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Current count.
  final int value;

  /// Receives the new count.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    Widget button(String label, String hint, int? next) => Semantics(
      button: true,
      enabled: next != null,
      label: hint,
      excludeSemantics: true,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(Space.tap, Space.tap),
          padding: EdgeInsets.zero,
        ),
        onPressed: next == null ? null : () => onChanged(next),
        child: Text(label, style: t.headlineSmall),
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        button('−', 'Fewer snakes', value > minSnakes ? value - 1 : null),
        const SizedBox(width: Space.m),
        Semantics(
          liveRegion: true,
          label: '$value snakes',
          excludeSemantics: true,
          child: Row(
            children: [
              const AppIcon('snake', size: 22),
              const SizedBox(width: Space.xs),
              Text('$value', style: t.headlineSmall),
            ],
          ),
        ),
        const SizedBox(width: Space.m),
        button('+', 'More snakes', value < maxSnakes ? value + 1 : null),
      ],
    );
  }
}
