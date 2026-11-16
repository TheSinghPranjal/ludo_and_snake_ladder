import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:dice_party/platform/ui/meadow/meadow_controls.dart';
import 'package:dice_party/platform/ui/meadow/meadow_palette.dart';
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

/// The snake-count stepper in the meadow style of Player Setup: raised
/// cream − and + buttons around the count.
class SnakesMeadowStepper extends StatelessWidget {
  /// Creates a stepper.
  const SnakesMeadowStepper({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Current count.
  final int value;

  /// Receives the new count.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      MeadowIconButton(
        label: 'Fewer snakes',
        icon: const Icon(Icons.remove_rounded),
        onTap: value > minSnakes ? () => onChanged(value - 1) : null,
      ),
      const SizedBox(width: Space.m),
      Semantics(
        liveRegion: true,
        label: '$value snakes',
        excludeSemantics: true,
        child: SizedBox(
          width: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppIcon('snake', color: HomePalette.meadowInk),
              const SizedBox(width: Space.xs),
              Text(
                '$value',
                style: const TextStyle(
                  fontFamily: displayFont,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: HomePalette.meadowInk,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: Space.m),
      MeadowIconButton(
        label: 'More snakes',
        icon: const Icon(Icons.add_rounded),
        onTap: value < maxSnakes ? () => onChanged(value + 1) : null,
      ),
    ],
  );
}
