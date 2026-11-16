import 'dart:async';

import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/meadow/meadow_frame.dart';
import 'package:dice_party/platform/ui/meadow/meadow_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The Game Hub: an illustrated card per game on the meadow, then How to
/// Play.
class HubScreen extends ConsumerWidget {
  /// Creates the Hub.
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(gameCatalogProvider).value;
    final saves = ref.watch(savesControllerProvider);
    final audio = ref.watch(appServicesProvider).audio;

    Widget card(GameType type, String name, String asset, double aspect) {
      final save = saves[type];
      return _GameCard(
        name: name,
        cardAsset: asset,
        aspect: aspect,
        onTap: () {
          audio.play(Sfx.uiTap);
          unawaited(context.push(AppRoutes.menu(type)));
        },
        saveText: save == null ? null : catalog?[type]?.describeSave(save),
        onResume: save == null
            ? null
            : () {
                audio.play(Sfx.uiTap);
                unawaited(
                  context.push(AppRoutes.play(type), extra: ResumeLaunch(save)),
                );
              },
      );
    }

    return MeadowFrame(
      title: 'Choose a game',
      signAsset: SharedAssets.signChooseGame,
      signAspect: 533 / 208,
      signWidthFactor: 0.64,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          card(
            GameType.snakes,
            'Snakes & Ladders',
            SharedAssets.hubCardSnakes,
            789 / 432,
          ),
          const SizedBox(height: Space.l),
          card(GameType.ludo, 'Ludo', SharedAssets.hubCardLudo, 789 / 385),
          const SizedBox(height: Space.xl),
          Center(
            child: _HowToPlayButton(
              onTap: catalog == null
                  ? null
                  : () {
                      audio.play(Sfx.uiTap);
                      unawaited(showHowToPlayPicker(context, catalog));
                    },
            ),
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

/// One illustrated game card. The artwork carries the title and the Play
/// button; the whole card is the tap target.
class _GameCard extends StatefulWidget {
  const _GameCard({
    required this.name,
    required this.cardAsset,
    required this.aspect,
    required this.onTap,
    this.saveText,
    this.onResume,
  });

  final String name;
  final String cardAsset;
  final double aspect;
  final VoidCallback onTap;
  final String? saveText;
  final VoidCallback? onResume;

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final radius = BorderRadius.circular(w * 0.071);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Semantics(
              button: true,
              label: '${widget.name}, Play',
              excludeSemantics: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => setState(() => _pressed = true),
                onTapUp: (_) => setState(() => _pressed = false),
                onTapCancel: () => setState(() => _pressed = false),
                onTap: widget.onTap,
                child: AnimatedScale(
                  scale: _pressed ? 0.97 : 1,
                  duration: const Duration(milliseconds: 100),
                  child: AspectRatio(
                    aspectRatio: widget.aspect,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        boxShadow: const [
                          BoxShadow(
                            color: HomePalette.shadow,
                            blurRadius: 14,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Invisible, for finders; the artwork shows them.
                          Opacity(
                            opacity: 0,
                            child: Column(
                              children: [Text(widget.name), const Text('Play')],
                            ),
                          ),
                          Image.asset(
                            widget.cardAsset,
                            fit: BoxFit.fill,
                            excludeFromSemantics: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.onResume != null)
              Positioned(
                right: w * 0.04,
                top: -Space.s,
                child: _ResumeChip(
                  label: 'Continue ${widget.name}, ${widget.saveText ?? ''}',
                  onTap: widget.onResume!,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ResumeChip extends StatelessWidget {
  const _ResumeChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
          padding: const EdgeInsets.symmetric(horizontal: Space.m),
          decoration: BoxDecoration(
            color: HomePalette.continueBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: HomePalette.continueBorder, width: 2),
            boxShadow: const [
              BoxShadow(
                color: HomePalette.cardShadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle_fill_rounded,
                size: 18,
                color: HomePalette.continueIcon,
              ),
              SizedBox(width: Space.xs),
              Text(
                'Resume',
                style: TextStyle(
                  fontFamily: displayFont,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HomePalette.continueText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HowToPlayButton extends StatefulWidget {
  const _HowToPlayButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  State<_HowToPlayButton> createState() => _HowToPlayButtonState();
}

class _HowToPlayButtonState extends State<_HowToPlayButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'How to Play',
      enabled: widget.onTap != null,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1,
          duration: const Duration(milliseconds: 100),
          child: const SizedBox(
            width: 260,
            child: MeadowPill(
              height: 56,
              padding: EdgeInsets.symmetric(horizontal: Space.l + Space.xs),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 30,
                    color: HomePalette.navy,
                  ),
                  SizedBox(width: Space.m),
                  Expanded(
                    child: Text(
                      'How to Play',
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: displayFont,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: HomePalette.navy,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 30,
                    color: HomePalette.navy,
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
