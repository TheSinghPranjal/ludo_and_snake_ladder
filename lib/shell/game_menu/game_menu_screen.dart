import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/ui/page_frame.dart';
import 'package:dice_party/platform/ui/replace_save.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// One game's menu: local play, Quick Play, How to Play and rules.
class GameMenuScreen extends ConsumerWidget {
  /// Creates the menu for [game].
  const GameMenuScreen({required this.game, super.key});

  /// The game.
  final GamePresentation game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final save = ref.watch(savesControllerProvider)[game.type];
    return PageFrame(
      title: game.module.displayName,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (save != null)
            MenuTile(
              icon: 'refresh',
              title: 'Continue',
              subtitle: game.describeSave(save),
              primary: true,
              onTap: () => context.push(
                AppRoutes.play(game.type),
                extra: ResumeLaunch(save),
              ),
            ),
          MenuTile(
            icon: 'human',
            title: 'Play Local',
            subtitle: 'Pass and play on this phone, with optional AI seats',
            primary: save == null,
            onTap: () => context.push(AppRoutes.setup(game.type)),
          ),
          MenuTile(
            icon: 'ai',
            title: 'Quick Play vs AI',
            subtitle: 'Jump straight into a game against the computer',
            onTap: () async {
              if (!await confirmReplaceSave(context, ref, game)) return;
              if (!context.mounted) return;
              await context.push(
                AppRoutes.play(game.type),
                extra: game.quickPlay(ref),
              );
            },
          ),
          MenuTile(
            icon: 'info',
            title: 'How to Play',
            onTap: () => context.push(AppRoutes.howToPlay(game.type)),
          ),
          MenuTile(
            icon: 'settings',
            title: 'Game rules',
            subtitle: 'House rules and defaults for this game',
            onTap: () => context.push(AppRoutes.rules(game.type)),
          ),
        ],
      ),
    );
  }
}
