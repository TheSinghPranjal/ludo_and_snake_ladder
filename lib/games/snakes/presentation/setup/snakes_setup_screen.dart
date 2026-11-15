import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/games/snakes/presentation/game/board_painter.dart';
import 'package:dice_party/games/snakes/presentation/setup/snakes_stepper.dart';
import 'package:dice_party/games/snakes/presentation/snakes_presentation.dart';
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

/// Snakes & Ladders Player Setup: seats, snake count with a live preview,
/// and the board.
class SnakesSetupScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const SnakesSetupScreen({required this.presentation, super.key});

  /// The game.
  final SnakesPresentation presentation;

  @override
  ConsumerState<SnakesSetupScreen> createState() => _SnakesSetupScreenState();
}

class _SnakesSetupScreenState extends ConsumerState<SnakesSetupScreen> {
  late List<SeatSpec> _seats;
  late SnakesConfig _config;
  int _count = 2;

  @override
  void initState() {
    super.initState();
    _config = widget.presentation.savedConfig(ref);
    _seats = defaultSeats(
      profile: ref.read(profileControllerProvider),
      colors: PlayerColor.values,
      aiLevel: ref.read(settingsControllerProvider).defaultAi,
    );
  }

  Future<void> _pickBoard() async {
    final id = await context.push<String>(
      AppRoutes.page(widget.presentation.type, snakesBoardSelectPage),
      extra: _config.boardId,
    );
    if (id != null && mounted) {
      setState(() => _config = _config.copyWith(boardId: id));
    }
  }

  Future<void> _start() async {
    final p = widget.presentation;
    if (!await confirmReplaceSave(context, ref, p)) return;
    if (!mounted) return;
    await context.push(
      AppRoutes.play(p.type),
      extra: NewGameLaunch(
        game: p.type,
        seats: finalizeSeats(_seats.take(_count).toList()),
        config: p.module.configCodec.encode(_config),
        mode: GameMode.local,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final board = widget.presentation.board(_config.boardId);
    final seats = _seats.take(_count).toList();
    return PageFrame(
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
            onSelectionChanged: (v) => setState(() => _count = v.first),
          ),
          const SizedBox(height: Space.m),
          for (var i = 0; i < seats.length; i++)
            SeatEditor(
              key: ValueKey('seat$i'),
              index: i,
              seat: seats[i],
              takenColors: {
                for (var j = 0; j < seats.length; j++)
                  if (j != i) seats[j].color,
              },
              onChanged: (s) => setState(() => _seats[i] = s),
            ),
          const SectionTitle('Snakes'),
          Row(
            children: [
              SizedBox(
                width: 96,
                child: SnakesBoardPreview(
                  board: board,
                  snakeCount: _config.snakeCount,
                ),
              ),
              const SizedBox(width: Space.l),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SnakesStepper(
                    value: _config.snakeCount,
                    onChanged: (n) => setState(
                      () => _config = _config.copyWith(snakeCount: n),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SectionTitle('Board'),
          Card(
            child: ListTile(
              title: Text(board.name),
              subtitle: const Text('Tap to choose another board'),
              onTap: _pickBoard,
              minTileHeight: Space.tap + Space.m,
            ),
          ),
        ],
      ),
    );
  }
}
