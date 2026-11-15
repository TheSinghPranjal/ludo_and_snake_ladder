import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:dice_party/platform/timer/turn_timer.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/avatar_image.dart';
import 'package:dice_party/platform/ui/color_symbol.dart';
import 'package:dice_party/platform/ui/timer_ring.dart';
import 'package:flutter/material.dart';

/// Height of every player card.
const double playerCardHeight = 64;

/// A player's card. Its size never depends on its state: only colours,
/// the glow and the timer ring change.
class PlayerCard extends StatelessWidget {
  /// Creates a card.
  const PlayerCard({
    required this.player,
    required this.active,
    required this.detail,
    this.timer,
    this.trailing,
    super.key,
  });

  /// The player.
  final Player player;

  /// Whether it is this player's turn.
  final bool active;

  /// Second line, e.g. "Square 42" or "Home 2/4".
  final String detail;

  /// The turn timer, shown as a ring while [active].
  final TurnTimer? timer;

  /// Optional widget at the end, e.g. the dice in Ludo.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final colour = c.player(player.color);
    final rank = player.finishedRank;
    final dimmed = player.isRemoved;
    Widget avatar = AvatarImage(player.avatar, size: 36);
    final t = timer;
    avatar = active && t != null
        ? TimerRing(timer: t, child: avatar)
        : SizedBox.square(
            dimension: 44,
            child: Padding(padding: const EdgeInsets.all(4), child: avatar),
          );
    final state = player.isRemoved
        ? 'left the game'
        : rank != null
        ? 'finished ${_ordinal(rank)}'
        : active
        ? 'playing now'
        : 'waiting';
    final label =
        '${colorName(player.color)} ${colorSymbol(player.color)}, '
        '${player.name}'
        '${player.kind == PlayerKind.ai ? ', computer' : ''}, $detail, '
        '$state';
    return Semantics(
      container: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: playerCardHeight,
        decoration: BoxDecoration(
          color: active ? c.surface : c.surfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? colour : c.outline,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: active ? colour.withValues(alpha: 0.45) : c.shadow,
              blurRadius: active ? 12 : 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Opacity(
          opacity: dimmed ? 0.5 : 1,
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  container: true,
                  label: label,
                  excludeSemantics: true,
                  child: Row(
                    children: [
                      const SizedBox(width: 2),
                      avatar,
                      const SizedBox(width: 2),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: displayFont,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: c.text,
                              ),
                            ),
                            Row(
                              children: [
                                ColorSymbol(player.color, size: 10),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    detail,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: c.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (rank != null)
                Image.asset(
                  SharedAssets.medal(rank.clamp(1, 4)),
                  width: 22,
                  height: 22,
                  excludeFromSemantics: true,
                )
              else
                ?trailing,
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  static String _ordinal(int n) => switch (n) {
    1 => '1st',
    2 => '2nd',
    3 => '3rd',
    _ => '${n}th',
  };
}
