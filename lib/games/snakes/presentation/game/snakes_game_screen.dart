import 'dart:math' as math;

import 'package:dice_party/games/snakes/application/snakes_controller.dart';
import 'package:dice_party/games/snakes/domain/board/coords.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_state.dart';
import 'package:dice_party/games/snakes/presentation/game/board_painter.dart';
import 'package:dice_party/games/snakes/presentation/theme/board_palette.dart';
import 'package:dice_party/platform/animation/token_motion.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/dice_view.dart';
import 'package:dice_party/platform/ui/meadow/meadow_controls.dart';
import 'package:dice_party/platform/ui/meadow/meadow_game.dart';
import 'package:dice_party/platform/ui/player_card.dart';
import 'package:dice_party/platform/ui/token_layer.dart';
import 'package:flutter/material.dart';

/// The Snakes & Ladders game screen: top bar, player strip, board, status
/// line and dice.
class SnakesGameView extends StatelessWidget {
  /// Creates the view.
  const SnakesGameView({
    required this.controller,
    required this.onPause,
    super.key,
  });

  /// The game.
  final SnakesController controller;

  /// Opens the Pause menu.
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final s = c.state;
    final canRoll = c.humanCanAct;
    final height = MediaQuery.sizeOf(context).height;
    final diceSize = (height * 0.095).clamp(54.0, 84.0);
    return MeadowGameFrame(
      child: Column(
        children: [
          MeadowGameTopBar(
            title: c.board.name,
            onPause: onPause,
            trailing: [
              MeadowStatChip(
                label: '${s.snakeCount} snakes',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MeadowIcon('snake', size: 22),
                    const SizedBox(width: Space.xs),
                    Text('${s.snakeCount}'),
                  ],
                ),
              ),
              MeadowStatChip(
                label: 'Turn ${s.turnNumber}',
                blue: true,
                child: Text('Turn ${s.turnNumber}'),
              ),
            ],
          ),
          const SizedBox(height: Space.xs),
          _PlayerStrip(controller: c),
          const SizedBox(height: Space.s),
          Expanded(child: _Board(controller: c)),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.l,
              vertical: Space.xs,
            ),
            child: MeadowStatusLine(c.status),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Space.xs, bottom: Space.s),
            child: MeadowDiceStage(
              diceSize: diceSize,
              glowing: canRoll && !c.rolling,
              dice: DiceView(
                size: diceSize,
                face: c.diceFace,
                rolling: c.rolling,
                swipeToRoll: true,
                onRoll: canRoll ? c.roll : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _square(int pos) => pos == 0 ? 'Start' : 'Square $pos';
}

/// Player cards, two per row so names stay readable on narrow phones.
class _PlayerStrip extends StatelessWidget {
  const _PlayerStrip({required this.controller});

  final SnakesController controller;

  @override
  Widget build(BuildContext context) {
    final s = controller.state;
    final players = s.players;
    Widget card(int i) {
      if (i >= players.length) {
        return const SizedBox(height: playerCardHeight);
      }
      final p = players[i];
      return PlayerCard(
        player: p,
        active: p.id == s.currentPlayer && !s.isOver,
        detail: SnakesGameView._square(s.positionOf(p.id)),
        timer: controller.timer,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.s),
      child: Column(
        children: [
          for (var row = 0; row < players.length; row += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.xs),
              child: Row(
                children: [
                  for (final i in [row, row + 1])
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: card(i),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({required this.controller});

  final SnakesController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final s = c.state;
    final palette = SnakesPalettes.of(context).forTheme(c.board.theme);
    return LayoutBuilder(
      builder: (context, box) {
        final w = math.min(
          box.maxWidth - Space.xl,
          (box.maxHeight - Space.s) / 1.14,
        );
        final cell = w / boardSide;
        return Center(
          child: SizedBox(
            width: w,
            height: w * 1.14,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -cell * 0.16,
                  top: -cell * 0.16,
                  width: w + cell * 0.32,
                  height: w + cell * 0.32,
                  child: DecoratedBox(
                    decoration: meadowBoardFrame(palette.frame, cell * 0.3),
                  ),
                ),
                Positioned(
                  left: -cell * 0.1,
                  top: w + cell * 0.22,
                  width: cell * 1.6,
                  height: cell * 0.68,
                  child: DecoratedBox(
                    decoration: meadowBoardFrame(palette.frame, cell * 0.34),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  width: w,
                  height: w,
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: SnakesBoardPainter(
                        board: c.board,
                        snakeCount: s.snakeCount,
                        palette: palette,
                      ),
                    ),
                  ),
                ),
                TokenLayer(
                  size: w,
                  tokenSize: cell * 0.62,
                  tokens: _tokens(s, c.motions, cell / w),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<TokenSprite> _tokens(
    SnakesState s,
    Map<PlayerId, TokenMotion> motions,
    double cell,
  ) {
    final bySquare = <int, List<Player>>{};
    for (final p in s.players) {
      if (p.isRemoved) continue;
      bySquare.putIfAbsent(s.positionOf(p.id), () => []).add(p);
    }
    final out = <TokenSprite>[];
    for (final entry in bySquare.entries) {
      final offsets = stackOffsets(entry.value.length);
      final centre = boardOffset(entry.key);
      for (var i = 0; i < entry.value.length; i++) {
        final p = entry.value[i];
        final active = p.id == s.currentPlayer && !s.isOver;
        out.add(
          TokenSprite(
            id: p.id,
            color: p.color,
            position: centre + offsets[i] * cell,
            label:
                '${colorName(p.color)} token, '
                '${entry.key == 0 ? 'start' : 'square ${entry.key}'}',
            state: active ? 'active' : 'idle',
            motion: motions[p.id],
          ),
        );
      }
    }
    final current = s.currentPlayer;
    out.sort((a, b) => (a.id == current ? 1 : 0) - (b.id == current ? 1 : 0));
    return out;
  }
}
