import 'dart:async';

import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/audio/music_scope.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:dice_party/platform/ui/app_wordmark.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/avatar_image.dart';
import 'package:dice_party/shell/hub/hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The Home screen: logo, a big Play button that opens the game Hub, and
/// links to Profile, Settings, Stats and How to Play.
class HomeScreen extends ConsumerWidget {
  /// Creates Home.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(gameCatalogProvider).value;
    final profile = ref.watch(profileControllerProvider);
    final saves = ref.watch(savesControllerProvider);
    final audio = ref.watch(appServicesProvider).audio;
    final c = AppColors.of(context);
    final t = Theme.of(context).textTheme;
    return MusicScope(
      audio: audio,
      track: MusicTrack.hub,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Space.maxContent),
              child: LayoutBuilder(
                builder: (context, box) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    Space.l,
                    Space.s,
                    Space.l,
                    Space.xl,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: box.maxHeight - Space.s - Space.xl,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _ProfileChip(
                                  name: profile.name,
                                  avatar: profile.avatar,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Settings',
                                onPressed: () =>
                                    context.push(AppRoutes.settings),
                                icon: const AppIcon('settings'),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const SizedBox(height: Space.xl),
                          const Center(child: _BouncingLogo()),
                          const SizedBox(height: Space.l),
                          const AppWordmark(size: 44),
                          const SizedBox(height: Space.s),
                          Text(
                            'Roll the dice and race your friends',
                            textAlign: TextAlign.center,
                            style: t.bodyLarge?.copyWith(color: c.textMuted),
                          ),
                          const Spacer(),
                          const SizedBox(height: Space.xl),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(64),
                              textStyle: t.titleLarge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Space.radius,
                                ),
                              ),
                            ),
                            onPressed: () => context.push(AppRoutes.hub),
                            icon: AppIcon('play', size: 28, color: c.onPrimary),
                            label: Text(
                              saves.isEmpty ? 'Play' : 'Play  ·  Continue',
                            ),
                          ),
                          const SizedBox(height: Space.m),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      context.push(AppRoutes.stats),
                                  icon: const AppIcon('stats', size: 20),
                                  label: const Text('Stats'),
                                ),
                              ),
                              const SizedBox(width: Space.m),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: catalog == null
                                      ? null
                                      : () => unawaited(
                                          showHowToPlayPicker(
                                            context,
                                            catalog,
                                          ),
                                        ),
                                  icon: const AppIcon('info', size: 20),
                                  label: const Text('How to Play'),
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
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({required this.name, required this.avatar});

  final String name;

  final int avatar;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Profile, $name',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push(AppRoutes.profile),
        child: Padding(
          padding: const EdgeInsets.all(Space.xs),
          child: Row(
            children: [
              AvatarImage(avatar),
              const SizedBox(width: Space.s),
              Flexible(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The app logo, gently bobbing. Still when the system asks for reduced
/// motion.
class _BouncingLogo extends StatefulWidget {
  const _BouncingLogo();

  @override
  State<_BouncingLogo> createState() => _BouncingLogoState();
}

class _BouncingLogoState extends State<_BouncingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _bob.stop();
    } else if (!_bob.isAnimating) {
      unawaited(_bob.repeat(reverse: true));
    }
  }

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    return AnimatedBuilder(
      animation: _bob,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -10 * Curves.easeInOut.transform(_bob.value)),
        child: child,
      ),
      child: Image.asset(
        SharedAssets.splashLogo(b),
        width: 160,
        height: 160,
        excludeFromSemantics: true,
      ),
    );
  }
}
