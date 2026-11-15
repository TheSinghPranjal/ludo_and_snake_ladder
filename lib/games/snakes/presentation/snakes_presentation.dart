import 'package:dice_party/games/snakes/application/board_repository.dart';
import 'package:dice_party/games/snakes/application/snakes_controller.dart';
import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_engine.dart';
import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/games/snakes/domain/snakes_module.dart';
import 'package:dice_party/games/snakes/presentation/board_select/board_select_screen.dart';
import 'package:dice_party/games/snakes/presentation/game/snakes_game_screen.dart';
import 'package:dice_party/games/snakes/presentation/rules/snakes_rules_screen.dart';
import 'package:dice_party/games/snakes/presentation/setup/snakes_setup_screen.dart';
import 'package:dice_party/games/snakes/presentation/theme/board_palette.dart';
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

/// Page name of Board Select; pass the current board id as `extra`, and
/// it pops with the chosen id.
const String snakesBoardSelectPage = 'boards';

/// Snakes & Ladders in the app shell.
class SnakesPresentation implements GamePresentation {
  /// Creates the presentation for loaded [content].
  SnakesPresentation(this.content) : module = SnakesModule(content.boards);

  /// Boards and palettes.
  final SnakesContent content;

  @override
  final SnakesModule module;

  @override
  GameType get type => GameType.snakes;

  @override
  String get tagline => 'Climb ladders, dodge snakes, race to 100.';

  @override
  String hubCard(Brightness b) =>
      SharedAssets.themed('assets/shared/hub/hub_card_snakes', b);

  @override
  String get icon => 'snake';

  @override
  MusicTrack get music => MusicTrack.snakes;

  @override
  List<HowToPlayPage> get howToPlay => const [
    HowToPlayPage(
      image: 'assets/games/snakes/howto/howto_snakes_1',
      title: 'Race to 100',
      body:
          'Take turns rolling the dice and hop forward square by square. '
          'The first to land exactly on 100 wins.',
    ),
    HowToPlayPage(
      image: 'assets/games/snakes/howto/howto_snakes_2',
      title: 'Ladders lift you up',
      body: 'Land exactly on the foot of a ladder to climb to its top.',
    ),
    HowToPlayPage(
      image: 'assets/games/snakes/howto/howto_snakes_3',
      title: 'Snakes slide you down',
      body: "Land on a snake's head and you slide all the way to its tail.",
    ),
    HowToPlayPage(
      image: 'assets/games/snakes/howto/howto_snakes_4',
      title: 'Sixes roll again',
      body:
          'A 6 gives you another roll. Three 6s in a row sends you back to '
          'where your turn started.',
    ),
    HowToPlayPage(
      image: 'assets/games/snakes/howto/howto_snakes_5',
      title: 'Exactly 100',
      body:
          'If your roll would pass 100 you stay put, unless the Bounce back '
          'house rule is on. Change house rules in Game rules.',
    ),
  ];

  @override
  List<StatSpec> get statSpecs => const [
    StatSpec(SnakesStats.laddersClimbed, 'Ladders climbed', StatKind.total),
    StatSpec(SnakesStats.snakesHit, 'Snakes hit', StatKind.total),
    StatSpec(
      SnakesStats.turns,
      'Best win (fewest turns)',
      StatKind.fewestInWin,
    ),
    StatSpec(SnakesStats.longestClimb, 'Longest climb', StatKind.highest),
    StatSpec(SnakesStats.worstSlide, 'Worst slide', StatKind.highest),
  ];

  @override
  List<StatSpec> get resultStats => const [
    StatSpec(SnakesStats.turns, 'Turns', StatKind.total),
    StatSpec(SnakesStats.laddersClimbed, 'Ladders', StatKind.total),
    StatSpec(SnakesStats.snakesHit, 'Snakes', StatKind.total),
    StatSpec(SnakesStats.longestClimb, 'Longest climb', StatKind.highest),
    StatSpec(SnakesStats.worstSlide, 'Worst slide', StatKind.highest),
  ];

  @override
  List<ThemeExtension<dynamic>> themeExtensions(Brightness b) => [
    SnakesPalettes(content.palettes[b]!),
  ];

  @override
  Widget? buildPage(BuildContext context, String name, Object? extra) =>
      name == snakesBoardSelectPage
      ? BoardSelectScreen(
          presentation: this,
          selected: extra is String ? extra : null,
        )
      : null;

  /// Board [id], or the first board.
  BoardDef board(String id) => module.boards[id] ?? content.boards.first;

  /// Whether [board] may be played with [unlocks] and [stats].
  bool isUnlocked(BoardDef board, Set<String> unlocks, GameStats stats) =>
      board.unlock.type == UnlockType.none ||
      unlocks.contains(board.id) ||
      stats.totalWins >= board.unlock.count;

  /// The saved rule settings, with a locked or unknown board replaced by
  /// the first board.
  SnakesConfig savedConfig(WidgetRef ref) {
    final json = ref.read(rulesControllerProvider)[type];
    final cfg =
        (json == null ? null : module.configCodec.decode(json)) ??
        module.defaultConfig;
    final b = module.boards[cfg.boardId];
    final ok =
        b != null &&
        isUnlocked(
          b,
          ref.read(unlocksControllerProvider),
          ref.read(statsControllerProvider.notifier).of(type),
        );
    return ok ? cfg : cfg.copyWith(boardId: content.boards.first.id);
  }

  @override
  Widget buildSetup(BuildContext context) =>
      SnakesSetupScreen(presentation: this);

  @override
  Widget buildRules(BuildContext context) =>
      SnakesRulesScreen(presentation: this);

  @override
  NewGameLaunch quickPlay(WidgetRef ref) {
    final settings = ref.read(settingsControllerProvider);
    return NewGameLaunch(
      game: type,
      seats: defaultSeats(
        profile: ref.read(profileControllerProvider),
        colors: const [PlayerColor.red, PlayerColor.blue],
        aiLevel: settings.defaultAi,
      ),
      config: module.configCodec.encode(savedConfig(ref)),
      mode: GameMode.ai,
    );
  }

  @override
  Widget buildGame(BuildContext context, GameLaunch launch) =>
      LocalGameHost<SnakesController>(
        presentation: this,
        launch: launch,
        create: (setup) => _controller(launch, setup),
        builder: (context, c, pause) =>
            SnakesGameView(controller: c, onPause: pause),
      );

  SnakesController? _controller(GameLaunch launch, LocalGameSetup setup) {
    final services = setup.services;
    final settings = setup.settings;
    switch (launch) {
      case NewGameLaunch(:final seats, :final config, :final mode):
        final cfg = module.configCodec.decode(config);
        if (cfg == null || module.boards[cfg.boardId] == null) return null;
        return SnakesController.newGame(
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
        return SnakesController(
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
    return 'Turn ${s.turnNumber} · ${s.players.length} players';
  }

  @override
  Set<String> unlocksFor(GameStats stats) => {
    for (final b in content.boards)
      if (b.unlock.type == UnlockType.snakesWins &&
          stats.totalWins >= b.unlock.count)
        b.id,
  };
}
