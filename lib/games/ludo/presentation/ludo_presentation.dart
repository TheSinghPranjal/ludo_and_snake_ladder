import 'package:dice_party/games/ludo/application/ludo_controller.dart';
import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_engine.dart';
import 'package:dice_party/games/ludo/domain/ludo_module.dart';
import 'package:dice_party/games/ludo/presentation/game/ludo_game_screen.dart';
import 'package:dice_party/games/ludo/presentation/rules/ludo_rules_screen.dart';
import 'package:dice_party/games/ludo/presentation/setup/ludo_setup_screen.dart';
import 'package:dice_party/games/ludo/presentation/theme/board_palette.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/platform/session/local_game_host.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/seat_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ludo in the app shell.
class LudoPresentation implements GamePresentation {
  /// Creates the presentation.
  LudoPresentation();

  @override
  final LudoModule module = const LudoModule();

  @override
  GameType get type => GameType.ludo;

  @override
  String get tagline => 'Race four tokens home. Capture to get ahead.';

  @override
  String hubCard(Brightness b) =>
      SharedAssets.themed('assets/shared/hub/hub_card_ludo', b);

  @override
  String get icon => 'dice';

  @override
  MusicTrack get music => MusicTrack.ludo;

  @override
  List<HowToPlayPage> get howToPlay => const [
    HowToPlayPage(
      image: 'assets/games/ludo/howto/howto_ludo_1',
      title: 'Roll a 6 to start',
      body: 'Your tokens wait in base until you roll a 6.',
    ),
    HowToPlayPage(
      image: 'assets/games/ludo/howto/howto_ludo_2',
      title: 'Go round the board',
      body:
          'Move one token by the number rolled, clockwise round the track '
          'and up your home column.',
    ),
    HowToPlayPage(
      image: 'assets/games/ludo/howto/howto_ludo_3',
      title: 'Capture opponents',
      body:
          'Land on an opponent to send them back to base, and roll again. '
          'Stars and start cells are safe.',
    ),
    HowToPlayPage(
      image: 'assets/games/ludo/howto/howto_ludo_4',
      title: 'Sixes and extra rolls',
      body:
          'A 6, a capture or reaching HOME gives another roll. Three 6s in '
          'a row end your turn.',
    ),
    HowToPlayPage(
      image: 'assets/games/ludo/howto/howto_ludo_5',
      title: 'Get all four HOME',
      body: 'Land each token exactly on HOME. All four home and you finish.',
    ),
  ];

  @override
  List<StatSpec> get statSpecs => const [
    StatSpec(LudoStats.captures, 'Captures', StatKind.total),
    StatSpec(LudoStats.timesCaptured, 'Times captured', StatKind.total),
    StatSpec(LudoStats.sixes, 'Sixes rolled', StatKind.total),
    StatSpec(LudoStats.tokensHome, 'Tokens home', StatKind.total),
  ];

  @override
  List<StatSpec> get resultStats => const [
    StatSpec(LudoStats.tokensHome, 'Home', StatKind.total),
    StatSpec(LudoStats.captures, 'Captures', StatKind.total),
    StatSpec(LudoStats.timesCaptured, 'Captured', StatKind.total),
    StatSpec(LudoStats.sixes, 'Sixes', StatKind.total),
  ];

  @override
  List<ThemeExtension<dynamic>> themeExtensions(Brightness b) => [
    if (b == Brightness.dark) LudoBoardPalette.dark else LudoBoardPalette.light,
  ];

  @override
  Widget? buildPage(BuildContext context, String name, Object? extra) => null;

  @override
  Widget buildSetup(BuildContext context) =>
      LudoSetupScreen(presentation: this);

  @override
  Widget buildRules(BuildContext context) => const LudoRulesScreen();

  @override
  NewGameLaunch quickPlay(WidgetRef ref) => NewGameLaunch(
    game: type,
    seats: defaultSeats(
      profile: ref.read(profileControllerProvider),
      colors: defaultColors(2),
      aiLevel: ref.read(settingsControllerProvider).defaultAi,
    ),
    config: module.configCodec.encode(module.defaultConfig),
    mode: GameMode.ai,
  );

  @override
  Widget buildGame(BuildContext context, GameLaunch launch) =>
      LocalGameHost<LudoController>(
        presentation: this,
        launch: launch,
        create: (setup) => _controller(launch, setup),
        builder: (context, c, pause) =>
            LudoGameView(controller: c, onPause: pause),
      );

  LudoController? _controller(GameLaunch launch, LocalGameSetup setup) {
    final services = setup.services;
    final settings = setup.settings;
    switch (launch) {
      case NewGameLaunch(:final seats, :final config, :final mode):
        final cfg = module.configCodec.decode(config);
        if (cfg == null) return null;
        return LudoController.newGame(
          module: module,
          seats: seats,
          config: cfg,
          mode: mode,
          dice: services.newDice(),
          audio: services.audio,
          haptics: services.haptics,
          clock: services.clock,
          timerEnabled: settings.localTimer,
          fast: settings.fast,
          onSave: setup.onSave,
        );
      case ResumeLaunch(:final save):
        final cfg = module.configCodec.decode(save.config);
        final state = module.stateFromJson(save.state);
        if (cfg == null || state == null || state.isOver) return null;
        return LudoController(
          module: module,
          initial: state,
          config: cfg,
          mode: save.mode,
          me: save.me,
          dice: services.newDice(),
          audio: services.audio,
          haptics: services.haptics,
          clock: services.clock,
          timerEnabled: settings.localTimer,
          fast: settings.fast,
          onSave: setup.onSave,
        );
    }
  }

  @override
  String describeSave(SavedGame save) {
    final s = module.stateFromJson(save.state);
    if (s == null) return 'Saved game';
    final home = s.players.fold<int>(0, (n, p) => n + s.homeCount(p.id));
    return '${s.players.length} players · $home tokens home';
  }

  @override
  Set<String> unlocksFor(GameStats stats) => const {};
}
