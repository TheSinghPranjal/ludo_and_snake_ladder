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
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/meadow/meadow_controls.dart';
import 'package:dice_party/platform/ui/meadow/meadow_frame.dart';
import 'package:dice_party/platform/ui/meadow/meadow_palette.dart';
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
    return MeadowFrame(
      title: 'Player Setup',
      signAsset: SharedAssets.signPlayerSetup,
      signAspect: 538 / 158,
      bottomClearance: 0.1,
      child: MeadowPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MeadowHeader(icon: 'players', title: 'Players'),
            MeadowPlayerCount(
              selected: _count,
              onChanged: (n) => setState(() => _count = n),
            ),
            const SizedBox(height: Space.l),
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
            const MeadowDivider(),
            const MeadowHeader(icon: 'snake', title: 'Snakes'),
            Row(
              children: [
                const SizedBox(width: Space.s),
                Container(
                  width: 108,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [HomePalette.frameTop, HomePalette.frameBottom],
                    ),
                    border: Border.all(color: HomePalette.frameEdge, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: HomePalette.shadow,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SnakesBoardPreview(
                      board: board,
                      snakeCount: _config.snakeCount,
                    ),
                  ),
                ),
                const SizedBox(width: Space.m),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SnakesMeadowStepper(
                      value: _config.snakeCount,
                      onChanged: (n) => setState(
                        () => _config = _config.copyWith(snakeCount: n),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const MeadowDivider(),
            const MeadowHeader(icon: 'board', title: 'Board'),
            MeadowChoiceRow(
              thumbnail: Image.asset(
                SharedAssets.themed(
                  'assets/games/snakes/board_select/board_card_${board.id}',
                  Brightness.light,
                ),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                excludeFromSemantics: true,
              ),
              title: board.name,
              subtitle: 'Tap to choose another board',
              onTap: _pickBoard,
            ),
            const SizedBox(height: Space.xl),
            MeadowStartButton(onTap: _start),
          ],
        ),
      ),
    );
  }
}
