import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/games/ludo/presentation/ludo_presentation.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/page_frame.dart';
import 'package:dice_party/platform/ui/replace_save.dart';
import 'package:dice_party/platform/ui/seat_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ludo Player Setup: 2, 3 or 4 seats with colour, name and Human/AI.
class LudoSetupScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const LudoSetupScreen({required this.presentation, super.key});

  /// The game.
  final LudoPresentation presentation;

  @override
  ConsumerState<LudoSetupScreen> createState() => _LudoSetupScreenState();
}

class _LudoSetupScreenState extends ConsumerState<LudoSetupScreen> {
  int _count = 2;
  late List<SeatSpec> _seats = _defaults(2);

  List<SeatSpec> _defaults(int n) => defaultSeats(
    profile: ref.read(profileControllerProvider),
    colors: defaultColors(n),
    aiLevel: ref.read(settingsControllerProvider).defaultAi,
  );

  void _setCount(int n) {
    final next = _defaults(n);
    for (var i = 0; i < n && i < _seats.length; i++) {
      next[i] = next[i].copyWith(
        name: _seats[i].name,
        kind: _seats[i].kind,
        aiLevel: _seats[i].aiLevel,
        avatar: _seats[i].avatar,
      );
    }
    setState(() {
      _count = n;
      _seats = next;
    });
  }

  Future<void> _start() async {
    final p = widget.presentation;
    if (!await confirmReplaceSave(context, ref, p)) return;
    if (!mounted) return;
    await context.push(
      AppRoutes.play(p.type),
      extra: NewGameLaunch(
        game: p.type,
        seats: finalizeSeats(_seats),
        config: p.module.configCodec.encode(p.module.defaultConfig),
        mode: GameMode.local,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Player Setup',
    bottom: FilledButton(onPressed: _start, child: const Text('Start')),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle('Players'),
        SegmentedButton<int>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: 2, label: Text('2')),
            ButtonSegment(value: 3, label: Text('3')),
            ButtonSegment(value: 4, label: Text('4')),
          ],
          selected: {_count},
          onSelectionChanged: (v) => _setCount(v.first),
        ),
        const SizedBox(height: Space.s),
        Text(
          'Turns go clockwise: Red, Blue, Yellow, Green. '
          'Tap a token to change colour.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Space.m),
        for (var i = 0; i < _seats.length; i++)
          SeatEditor(
            key: ValueKey('seat$i'),
            index: i,
            seat: _seats[i],
            takenColors: {
              for (var j = 0; j < _seats.length; j++)
                if (j != i) _seats[j].color,
            },
            onChanged: (s) => setState(() => _seats[i] = s),
          ),
      ],
    ),
  );
}
