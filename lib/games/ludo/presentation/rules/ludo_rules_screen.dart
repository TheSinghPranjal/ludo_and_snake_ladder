import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/page_frame.dart';
import 'package:flutter/material.dart';

/// The Ludo rules used by this app. Ludo has no house-rule options.
class LudoRulesScreen extends StatelessWidget {
  /// Creates the screen.
  const LudoRulesScreen({super.key});

  static const _rules = [
    ('Leaving base', 'A token leaves base only on a 6, onto its start cell.'),
    (
      'Moving',
      'Move one token exactly the number rolled. It enters its home column '
          'after going once round the board, and must land on HOME exactly.',
    ),
    (
      'Capturing',
      'Land on an opponent outside a safe cell to send every token there '
          'back to base. Starts and stars are safe.',
    ),
    (
      'Extra rolls',
      'A 6, a capture or reaching HOME gives one more roll. They never '
          'stack. A third 6 in a row ends the turn.',
    ),
    (
      'Turn timer',
      'If time runs out the game rolls for you and plays the best move: '
          'reach HOME, capture, leave base, land safe, then advance the '
          'furthest token. A single legal move always plays by itself.',
    ),
    (
      'Winning',
      'Get all 4 tokens HOME to finish. Play continues until one player '
          'is left.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return PageFrame(
      title: 'Game rules',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (title, body) in _rules) ...[
            SectionTitle(title),
            Text(body, style: t.bodyLarge),
          ],
          const SizedBox(height: Space.l),
        ],
      ),
    );
  }
}
