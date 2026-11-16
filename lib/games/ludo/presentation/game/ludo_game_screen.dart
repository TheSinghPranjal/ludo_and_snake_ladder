import 'dart:math' as math;

import 'package:dice_party/games/ludo/application/ludo_controller.dart';
import 'package:dice_party/games/ludo/application/ludo_geometry.dart';
import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/games/ludo/presentation/game/ludo_board_painter.dart';
import 'package:dice_party/games/ludo/presentation/theme/board_palette.dart';
import 'package:dice_party/platform/animation/token_motion.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/dice_view.dart';
import 'package:dice_party/platform/ui/meadow/meadow_game.dart';
import 'package:dice_party/platform/ui/player_card.dart';
import 'package:dice_party/platform/ui/token_layer.dart';
import 'package:flutter/material.dart';

/// The Ludo game screen: the board with a fixed-size player card at each
/// corner beside its yard, the dice on the active card, and a status line.
class LudoGameView extends StatelessWidget {
  /// Creates the view.
  const LudoGameView({
    required this.controller,
    required this.onPause,
    super.key,
  });

  /// The game.
  final LudoController controller;

  /// Opens the Pause menu.
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    Widget corner(PlayerColor color) => Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.xs),
        child: _CornerCard(controller: c, color: color),
      ),
    );
    return MeadowGameFrame(
      child: Column(
        children: [
          MeadowGameTopBar(
            title: 'Ludo',
            onPause: onPause,
            // Balances the Pause button so the sign stays centred.
            trailing: const [SizedBox(width: 46)],
          ),
          const SizedBox(height: Space.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.xs),
            child: Row(
              children: [
                corner(PlayerColor.blue),
                corner(PlayerColor.yellow),
              ],
            ),
          ),
          const SizedBox(height: Space.m),
          Expanded(child: _Board(controller: c)),
          const SizedBox(height: Space.m),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.xs),
            child: Row(
              children: [
                corner(PlayerColor.red),
                corner(PlayerColor.green),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Space.s),
            child: SizedBox(
              height: 52,
              child: Center(child: MeadowStatusLine(c.status)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerCard extends StatelessWidget {
  const _CornerCard({required this.controller, required this.color});

  final LudoController controller;
  final PlayerColor color;

  @override
  Widget build(BuildContext context) {
    final s = controller.state;
    Player? player;
    for (final p in s.players) {
      if (p.color == color) player = p;
    }
    if (player == null) return const SizedBox(height: playerCardHeight);
    final active = player.id == s.currentPlayer && !s.isOver;
    return PlayerCard(
      player: player,
      active: active,
      detail: 'Home ${s.homeCount(player.id)}/$tokensPerPlayer',
      timer: controller.timer,
      trailing: active
          ? DiceView(
              size: 44,
              face: controller.diceFace,
              rolling: controller.rolling,
              onRoll: controller.canRoll ? controller.roll : null,
            )
          : null,
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({required this.controller});

  final LudoController controller;

  @override
  Widget build(BuildContext context) {
    final palette = LudoBoardPalette.of(context);
    return LayoutBuilder(
      builder: (context, box) {
        final w = math.min(box.maxWidth - Space.l, box.maxHeight);
        final cell = w / gridSize;
        return Center(
          child: Container(
            padding: EdgeInsets.all(cell * 0.15),
            decoration: meadowBoardFrame(palette.frame, cell * 0.4),
            child: SizedBox.square(
              dimension: w - cell * 0.3,
              child: LayoutBuilder(
                builder: (context, inner) {
                  final size = inner.maxWidth;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      RepaintBoundary(
                        child: CustomPaint(
                          size: Size.square(size),
                          painter: LudoBoardPainter(palette),
                        ),
                      ),
                      TokenLayer(
                        size: size,
                        tokenSize: size / gridSize * 0.92,
                        tokens: _tokens(controller),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  static List<TokenSprite> _tokens(LudoController c) {
    final s = c.state;
    final movable = {for (final m in c.movable) m.tokenId: m};
    final groups = <String, List<(Player, int, Offset)>>{};
    for (final p in s.players) {
      if (p.isRemoved) continue;
      final rels = s.tokensOf(p.id);
      for (var i = 0; i < rels.length; i++) {
        final pt = tokenPoint(p.color, rels[i], i);
        final key = '${(pt.dx * 1000).round()},${(pt.dy * 1000).round()}';
        groups.putIfAbsent(key, () => []).add((p, i, pt));
      }
    }
    const cell = 1 / gridSize;
    final out = <TokenSprite>[];
    for (final g in groups.values) {
      final offsets = stackOffsets(g.length);
      for (var k = 0; k < g.length; k++) {
        final (p, i, pt) = g[k];
        final rel = s.tokensOf(p.id)[i];
        final mine = p.id == s.currentPlayer;
        final canMove = mine && movable.containsKey(i);
        out.add(
          TokenSprite(
            id: ludoTokenKey(p.id, i),
            color: p.color,
            position: pt + offsets[k] * cell,
            label:
                '${colorName(p.color)} token ${i + 1}, ${_where(rel)}'
                '${canMove ? ', can move' : ''}',
            state: canMove ? 'movable' : 'idle',
            onTap: canMove ? () => c.move(i) : null,
            motion: c.motions[ludoTokenKey(p.id, i)],
          ),
        );
      }
    }
    final current = s.currentPlayer;
    final color = current == null ? null : s.player(current)?.color;
    if (color != null) {
      for (final m in movable.values) {
        out.insert(
          0,
          TokenSprite(
            id: 'ghost.${m.tokenId}',
            color: color,
            position: tokenPoint(color, m.toRel, m.tokenId),
            label: 'Destination of token ${m.tokenId + 1}',
            state: 'ghost',
          ),
        );
      }
    }
    out.sort(
      (a, b) => (a.state == 'movable' ? 1 : 0) - (b.state == 'movable' ? 1 : 0),
    );
    return out;
  }

  static String _where(int rel) => rel == baseRel
      ? 'in base'
      : rel == homeRel
      ? 'home'
      : rel > lastTrackRel
      ? 'home column'
      : 'step $rel';
}
