import 'dart:async';

import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/page_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The Game Hub: one illustrated card per game. Opened from Home; back
/// returns to Home.
class HubScreen extends ConsumerWidget {
  /// Creates the Hub.
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(gameCatalogProvider).value;
    return PageFrame(
      title: 'Choose a game',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final g in catalog?.games ?? const <GamePresentation>[])
            Padding(
              padding: const EdgeInsets.only(bottom: Space.l),
              child: _GameCard(game: g),
            ),
          OutlinedButton.icon(
            onPressed: catalog == null
                ? null
                : () => unawaited(showHowToPlayPicker(context, catalog)),
            icon: const AppIcon('info', size: 20),
            label: const Text('How to Play'),
          ),
        ],
      ),
    );
  }
}

/// Lets the player pick a game, then opens its How to Play.
Future<void> showHowToPlayPicker(BuildContext context, GameCatalog catalog) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final g in catalog.games)
              ListTile(
                leading: AppIcon(g.icon),
                title: Text(g.module.displayName),
                onTap: () {
                  Navigator.of(sheet).pop();
                  unawaited(context.push(AppRoutes.howToPlay(g.type)));
                },
              ),
          ],
        ),
      ),
    );

class _GameCard extends ConsumerWidget {
  const _GameCard({required this.game});

  final GamePresentation game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final save = ref.watch(savesControllerProvider)[game.type];
    final c = AppColors.of(context);
    final b = Theme.of(context).brightness;
    final name = game.module.displayName;
    return LayoutBuilder(
      builder: (context, box) {
        final height = (box.maxWidth * 180 / 340).clamp(176.0, 260.0);
        final textWidth = box.maxWidth * 0.46;
        return Material(
          color: c.surfaceAlt,
          elevation: 2,
          shadowColor: c.shadow,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () => context.push(AppRoutes.menu(game.type)),
            child: SizedBox(
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    game.hubCard(b),
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                    excludeFromSemantics: true,
                  ),
                  Positioned(
                    left: Space.l,
                    top: Space.m,
                    bottom: Space.m,
                    width: textWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        Semantics(
                          button: true,
                          label: 'Play $name',
                          excludeSemantics: true,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: c.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Space.l,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppIcon('play', size: 18, color: c.onPrimary),
                                  const SizedBox(width: Space.xs),
                                  Text(
                                    'Play',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: c.onPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (save != null) ...[
                          const SizedBox(height: Space.s),
                          Semantics(
                            button: true,
                            label:
                                'Continue $name, '
                                '${game.describeSave(save)}',
                            excludeSemantics: true,
                            child: GestureDetector(
                              onTap: () => context.push(
                                AppRoutes.play(game.type),
                                extra: ResumeLaunch(save),
                              ),
                              child: Image.asset(
                                SharedAssets.themed(
                                  'assets/shared/ui/chip_continue',
                                  b,
                                ),
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
