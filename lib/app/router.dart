import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/shell/game_menu/game_menu_screen.dart';
import 'package:dice_party/shell/home/home_screen.dart';
import 'package:dice_party/shell/how_to_play/how_to_play_screen.dart';
import 'package:dice_party/shell/hub/hub_screen.dart';
import 'package:dice_party/shell/profile/profile_screen.dart';
import 'package:dice_party/shell/results/results_screen.dart';
import 'package:dice_party/shell/settings/settings_screen.dart';
import 'package:dice_party/shell/splash/splash_screen.dart';
import 'package:dice_party/shell/stats/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Builds the app's router. Every game page looks its game up in the
/// loaded [GameCatalog]; until the catalog is loaded, every route shows
/// the splash.
///
/// Every page is nested under Home (and every game page under the Hub), so
/// `go` to any location builds the pages below it and back always leads
/// towards Home.
GoRouter buildRouter(ProviderContainer container) => GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (context, state) {
    final loaded = container.read(gameCatalogProvider).hasValue;
    if (!loaded && state.matchedLocation != AppRoutes.splash) {
      return AppRoutes.splash;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: _child(AppRoutes.hub),
          builder: (context, state) => const HubScreen(),
          routes: [
            GoRoute(
              path: ':game',
              builder: (context, state) =>
                  _game(container, state, (g) => GameMenuScreen(game: g)),
              routes: [
                GoRoute(
                  path: 'setup',
                  builder: (context, state) =>
                      _game(container, state, (g) => g.buildSetup(context)),
                ),
                GoRoute(
                  path: 'rules',
                  builder: (context, state) =>
                      _game(container, state, (g) => g.buildRules(context)),
                ),
                GoRoute(
                  path: 'how-to-play',
                  builder: (context, state) =>
                      _game(container, state, (g) => HowToPlayScreen(game: g)),
                ),
                GoRoute(
                  path: 'page/:page',
                  builder: (context, state) => _game(
                    container,
                    state,
                    (g) => g.buildPage(
                      context,
                      state.pathParameters['page'] ?? '',
                      state.extra,
                    ),
                  ),
                ),
                GoRoute(
                  path: 'play',
                  builder: (context, state) => _game(container, state, (g) {
                    final launch = state.extra;
                    return launch is GameLaunch && launch.game == g.type
                        ? g.buildGame(context, launch)
                        : null;
                  }),
                ),
                GoRoute(
                  path: 'results',
                  builder: (context, state) => _game(container, state, (g) {
                    final summary = state.extra;
                    return summary is ResultSummary
                        ? ResultsScreen(game: g, summary: summary)
                        : null;
                  }),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: _child(AppRoutes.profile),
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: _child(AppRoutes.settings),
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: _child(AppRoutes.stats),
          builder: (context, state) => const StatsScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const _Missing(),
);

/// [path] without its leading `/`, for a route nested under Home.
String _child(String path) => path.substring(1);

Widget _game(
  ProviderContainer container,
  GoRouterState state,
  Widget? Function(GamePresentation game) build,
) {
  final name = state.pathParameters['game'];
  final type = GameType.values.where((t) => t.name == name).firstOrNull;
  final catalog = container.read(gameCatalogProvider).value;
  final game = type == null ? null : catalog?[type];
  return (game == null ? null : build(game)) ?? const _Missing();
}

class _Missing extends StatelessWidget {
  const _Missing();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('This page is not available.'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    ),
  );
}
