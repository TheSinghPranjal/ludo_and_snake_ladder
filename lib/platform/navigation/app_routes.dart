import 'package:dice_party/platform/session/game_module.dart';

/// Route paths shared by the shell and the games.
abstract final class AppRoutes {
  /// Splash.
  static const splash = '/splash';

  /// Home screen, the root of every other page.
  static const home = '/';

  /// Game Hub: choose which game to play.
  static const hub = '/games';

  /// Profile.
  static const profile = '/profile';

  /// Settings.
  static const settings = '/settings';

  /// Stats.
  static const stats = '/stats';

  /// Game Menu of [game].
  static String menu(GameType game) => '$hub/${game.name}';

  /// Player Setup of [game].
  static String setup(GameType game) => '${menu(game)}/setup';

  /// Game rules/settings of [game].
  static String rules(GameType game) => '${menu(game)}/rules';

  /// How to Play of [game].
  static String howToPlay(GameType game) => '${menu(game)}/how-to-play';

  /// Game screen of [game]; pass a `GameLaunch` as `extra`.
  static String play(GameType game) => '${menu(game)}/play';

  /// Game-specific page [name] of [game].
  static String page(GameType game, String name) => '${menu(game)}/page/$name';

  /// Results of [game]; pass a `ResultSummary` as `extra`.
  static String results(GameType game) => '${menu(game)}/results';
}
