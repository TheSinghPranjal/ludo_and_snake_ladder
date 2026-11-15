import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One page of How to Play.
@immutable
class HowToPlayPage {
  /// Creates a page.
  const HowToPlayPage({
    required this.image,
    required this.title,
    required this.body,
  });

  /// Asset path without the `_light.png` / `_dark.png` suffix.
  final String image;

  /// Short heading.
  final String title;

  /// One or two sentences.
  final String body;
}

/// The Flutter side of a game: screens, art and texts.
///
/// The shell reaches every game through this interface and
/// [GameModule], so it has no game-specific branches.
abstract interface class GamePresentation {
  /// The game's rules.
  GameModule<GameState, Object, Object, Object> get module;

  /// Which game.
  GameType get type;

  /// One-line description on the Hub card.
  String get tagline;

  /// Hub card illustration for [brightness].
  String hubCard(Brightness brightness);

  /// Monochrome icon asset for menus.
  String get icon;

  /// Music for this game's screens.
  MusicTrack get music;

  /// How to Play pages.
  List<HowToPlayPage> get howToPlay;

  /// Statistics on the Stats screen.
  List<StatSpec> get statSpecs;

  /// Statistics in the Results panel.
  List<StatSpec> get resultStats;

  /// Board palettes and other theme extensions for [brightness].
  List<ThemeExtension<dynamic>> themeExtensions(Brightness brightness);

  /// An extra page below the Game Menu, e.g. Board Select, opened at
  /// `AppRoutes.page(type, name)`; null for an unknown [name].
  Widget? buildPage(BuildContext context, String name, Object? extra);

  /// Player Setup.
  Widget buildSetup(BuildContext context);

  /// Game rules/settings.
  Widget buildRules(BuildContext context);

  /// The game screen for [launch].
  Widget buildGame(BuildContext context, GameLaunch launch);

  /// A Quick Play game against the computer with the saved defaults.
  NewGameLaunch quickPlay(WidgetRef ref);

  /// Short description of a save for the Continue chip, e.g. "Turn 12".
  String describeSave(SavedGame save);

  /// Content ids unlocked by [stats], e.g. boards.
  Set<String> unlocksFor(GameStats stats);
}

/// The registered games and their presentations.
@immutable
class GameCatalog {
  /// Creates a catalog. Each game appears once.
  GameCatalog(Iterable<GamePresentation> presentations)
    : _byType = {for (final p in presentations) p.type: p};

  final Map<GameType, GamePresentation> _byType;

  /// Every game, in [GameType] order.
  List<GamePresentation> get games => [
    for (final t in GameType.values) ?_byType[t],
  ];

  /// The presentation of [type], or null.
  GamePresentation? operator [](GameType type) => _byType[type];

  /// Theme extensions of every game for [brightness].
  List<ThemeExtension<dynamic>> themeExtensions(Brightness brightness) => [
    for (final g in games) ...g.themeExtensions(brightness),
  ];
}
