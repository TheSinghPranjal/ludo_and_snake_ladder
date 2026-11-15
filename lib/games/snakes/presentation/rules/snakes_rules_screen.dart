import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/games/snakes/presentation/setup/snakes_stepper.dart';
import 'package:dice_party/games/snakes/presentation/snakes_presentation.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/ui/page_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Snakes & Ladders house rules and the default snake count.
class SnakesRulesScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const SnakesRulesScreen({required this.presentation, super.key});

  /// The game.
  final SnakesPresentation presentation;

  @override
  ConsumerState<SnakesRulesScreen> createState() => _SnakesRulesScreenState();
}

class _SnakesRulesScreenState extends ConsumerState<SnakesRulesScreen> {
  late SnakesConfig _config = widget.presentation.savedConfig(ref);

  void _set(SnakesConfig c) {
    setState(() => _config = c);
    final p = widget.presentation;
    ref
        .read(rulesControllerProvider.notifier)
        .write(p.type, p.module.configCodec.encode(c));
  }

  void _rules(SnakesRules Function(SnakesRules) f) =>
      _set(_config.copyWith(rules: f(_config.rules)));

  @override
  Widget build(BuildContext context) {
    final r = _config.rules;
    Widget toggle(
      String title,
      String sub, {
      required bool v,
      required ValueChanged<bool> f,
    }) => SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(sub),
      value: v,
      onChanged: f,
    );
    return PageFrame(
      title: 'Game rules',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('House rules'),
          toggle(
            'Need a 6 to start',
            'A 6 places your token on square 1',
            v: r.needSixToStart,
            f: (v) => _rules((r) => r.copyWith(needSixToStart: v)),
          ),
          toggle(
            'Extra roll on 6',
            'Rolling a 6 gives another roll',
            v: r.extraRollOnSix,
            f: (v) => _rules((r) => r.copyWith(extraRollOnSix: v)),
          ),
          toggle(
            'Three 6s penalty',
            'A third 6 in a row sends you back to where the turn began',
            v: r.threeSixesPenalty,
            f: (v) => _rules((r) => r.copyWith(threeSixesPenalty: v)),
          ),
          toggle(
            'Capture',
            'Landing on an opponent sends them back to start',
            v: r.capture,
            f: (v) => _rules((r) => r.copyWith(capture: v)),
          ),
          const SectionTitle('Overshoot at 100'),
          SegmentedButton<Overshoot>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: Overshoot.stay, label: Text('Stay put')),
              ButtonSegment(
                value: Overshoot.bounce,
                label: Text('Bounce back'),
              ),
            ],
            selected: {r.overshoot},
            onSelectionChanged: (v) =>
                _rules((r) => r.copyWith(overshoot: v.first)),
          ),
          const SectionTitle('Play to'),
          SegmentedButton<PlayTo>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: PlayTo.firstWinner,
                label: Text('First winner'),
              ),
              ButtonSegment(
                value: PlayTo.fullRanking,
                label: Text('Full ranking'),
              ),
            ],
            selected: {r.playTo},
            onSelectionChanged: (v) =>
                _rules((r) => r.copyWith(playTo: v.first)),
          ),
          const SectionTitle('Default number of snakes'),
          Center(
            child: SnakesStepper(
              value: _config.snakeCount,
              onChanged: (n) => _set(_config.copyWith(snakeCount: n)),
            ),
          ),
        ],
      ),
    );
  }
}
