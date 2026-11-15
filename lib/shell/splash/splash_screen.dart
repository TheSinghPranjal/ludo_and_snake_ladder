import 'dart:async';

import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_wordmark.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// How long the splash stays up at least, so its intro animation can play.
const splashMinDuration = Duration(milliseconds: 1600);

/// Pops the logo in while the games and shared art load, then opens Home.
class SplashScreen extends ConsumerStatefulWidget {
  /// Creates the splash.
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final Animation<double> _logoScale = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0, 0.6, curve: Curves.elasticOut),
  );
  late final Animation<double> _logoTurn = Tween<double>(begin: -0.08, end: 0)
      .animate(
        CurvedAnimation(
          parent: _intro,
          curve: const Interval(0, 0.6, curve: Curves.easeOutBack),
        ),
      );
  late final Animation<double> _nameFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.45, 1, curve: Curves.easeOut),
  );

  bool _started = false;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _intro.value = 1;
    } else {
      unawaited(_intro.forward());
    }
    unawaited(_load());
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final b = Theme.of(context).brightness;
    final images = [
      SharedAssets.splashLogo(b),
      SharedAssets.themed('assets/shared/hub/hub_card_snakes', b),
      SharedAssets.themed('assets/shared/hub/hub_card_ludo', b),
      SharedAssets.themed('assets/shared/ui/chip_continue', b),
    ];
    for (final i in images) {
      unawaited(precacheImage(AssetImage(i), context));
    }
    try {
      await Future.wait<void>([
        ref.read(gameCatalogProvider.future),
        Future<void>.delayed(splashMinDuration),
      ]);
      if (mounted) context.go(AppRoutes.home);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final c = AppColors.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: _logoTurn,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    SharedAssets.splashLogo(b),
                    width: 180,
                    height: 180,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
              const SizedBox(height: Space.xl),
              FadeTransition(
                opacity: _nameFade,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(_nameFade),
                  child: const AppWordmark(),
                ),
              ),
              const SizedBox(height: Space.xxl),
              if (_error == null)
                SizedBox.square(
                  dimension: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: c.primary,
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(Space.xl),
                  child: Text(
                    'The game files could not be loaded. '
                    'Please reinstall the app.',
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
