import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:dice_party/platform/timer/turn_timer.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/avatar_image.dart';
import 'package:dice_party/platform/ui/color_symbol.dart';
import 'package:dice_party/platform/ui/meadow/meadow_palette.dart';
import 'package:dice_party/platform/ui/seat_editor.dart';
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
    final tint = seatTint(player.color);
    final rank = player.finishedRank;
    final dimmed = player.isRemoved;
    Widget avatar = Container(
      width: 46,
      height: 46,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tint.bg, tint.border],
        ),
        border: Border.all(color: HomePalette.white, width: 2),
      ),
      child: AvatarImage(player.avatar, size: 36),
    );
    final t = timer;
    if (active && t != null) {
      avatar = TimerRing(timer: t, size: 50, child: avatar);
    }
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
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: active
                ? const [HomePalette.white, HomePalette.panelTop]
                : const [HomePalette.panelTop, HomePalette.cardWaiting],
          ),
          border: Border.all(
            color: active ? colour : HomePalette.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: active
                  ? colour.withValues(alpha: 0.45)
                  : HomePalette.cardShadow,
              blurRadius: active ? 12 : 6,
              offset: const Offset(0, 3),
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
                      const SizedBox(width: 6),
                      SizedBox.square(
                        dimension: 50,
                        child: Center(child: avatar),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: displayFont,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                height: 1.15,
                                color: HomePalette.navy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                ColorSymbol(player.color),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    detail,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: HomePalette.cardMuted,
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
                  width: 24,
                  height: 24,
                  excludeFromSemantics: true,
                )
              else
                ?trailing,
              const SizedBox(width: 6),
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
