import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/avatar_image.dart';
import 'package:dice_party/platform/ui/color_symbol.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The shared Results frame with the game's own statistics per player.
class ResultsScreen extends StatelessWidget {
  /// Creates the screen.
  const ResultsScreen({required this.game, required this.summary, super.key});

  /// The game.
  final GamePresentation game;

  /// What happened.
  final ResultSummary summary;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final t = Theme.of(context).textTheme;
    final b = Theme.of(context).brightness;
    final winner = summary.rows.isEmpty ? null : summary.rows.first.player;
    final headline = winner == null
        ? 'Game over'
        : winner.id == summary.me
        ? 'You win!'
        : '${winner.name} wins!';
    final replay = summary.replay;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(AppRoutes.menu(game.type));
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Space.maxContent),
              child: ListView(
                padding: const EdgeInsets.all(Space.l),
                children: [
                  Center(
                    child: Image.asset(
                      SharedAssets.themed('assets/shared/ui/badge_winner', b),
                      height: 56,
                      excludeFromSemantics: true,
                    ),
                  ),
                  const SizedBox(height: Space.s),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      headline,
                      textAlign: TextAlign.center,
                      style: t.headlineMedium,
                    ),
                  ),
                  Text(
                    game.module.displayName,
                    textAlign: TextAlign.center,
                    style: t.bodyMedium?.copyWith(color: c.textMuted),
                  ),
                  const SizedBox(height: Space.l),
                  for (final row in summary.rows) _ResultTile(row, game),
                  const SizedBox(height: Space.l),
                  if (replay != null)
                    FilledButton(
                      onPressed: () => context.go(
                        AppRoutes.play(game.type),
                        extra: replay,
                      ),
                      child: const Text('Play Again'),
                    ),
                  const SizedBox(height: Space.s),
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.menu(game.type)),
                    child: const Text('Game Menu'),
                  ),
                  const SizedBox(height: Space.s),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => context.go(AppRoutes.hub),
                          child: const Text('Choose game'),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () => context.go(AppRoutes.home),
                          child: const Text('Home'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile(this.row, this.game);

  final ResultRow row;
  final GamePresentation game;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final p = row.player;
    final stats = [
      for (final s in game.resultStats)
        if (row.stats[s.key] case final v?) '${s.label} ${v.round()}',
    ];
    return Card(
      margin: const EdgeInsets.only(bottom: Space.m),
      child: Padding(
        padding: const EdgeInsets.all(Space.m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              SharedAssets.medal(row.place.clamp(1, 4)),
              width: 32,
              height: 32,
              semanticLabel: 'Place ${row.place}',
            ),
            const SizedBox(width: Space.s),
            AvatarImage(p.avatar),
            const SizedBox(width: Space.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ColorSymbol(p.color),
                      const SizedBox(width: Space.xs),
                      Expanded(
                        child: Text(
                          '${p.name}${p.isRemoved ? ' (left)' : ''}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(color: c.text),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Space.xs),
                  Text(
                    stats.join(' · '),
                    style: TextStyle(color: c.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
