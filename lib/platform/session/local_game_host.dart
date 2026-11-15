import 'dart:async';

import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/audio/music_scope.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/platform/session/local_game_controller.dart';
import 'package:dice_party/platform/settings/app_settings.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/ui/pause_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// What a game needs to build its controller.
class LocalGameSetup {
  /// Creates a setup.
  const LocalGameSetup({
    required this.services,
    required this.settings,
    required this.onSave,
  });

  /// App services (dice, clock, audio, haptics).
  final AppServices services;

  /// Settings when the game opened.
  final AppSettings settings;

  /// Stores or deletes the save.
  final void Function(SavedGame? save) onSave;
}

/// Hosts a local game screen: creates and starts the controller, saves
/// after every turn, pauses on Back, plays the game's music, and at game
/// over records statistics and unlocks and opens Results.
class LocalGameHost<
  T extends LocalGameController<GameState, Object?, Object?, Object?>
>
    extends ConsumerStatefulWidget {
  /// Creates a host.
  const LocalGameHost({
    required this.presentation,
    required this.launch,
    required this.create,
    required this.builder,
    super.key,
  });

  /// The game.
  final GamePresentation presentation;

  /// New game or resume.
  final GameLaunch launch;

  /// Builds the controller, or returns null when a save cannot be read.
  final T? Function(LocalGameSetup setup) create;

  /// Builds the game screen; call `pause` from the pause button.
  final Widget Function(BuildContext context, T controller, VoidCallback pause)
  builder;

  @override
  ConsumerState<LocalGameHost<T>> createState() => _LocalGameHostState<T>();
}

class _LocalGameHostState<
  T extends LocalGameController<GameState, Object?, Object?, Object?>
>
    extends ConsumerState<LocalGameHost<T>> {
  T? _controller;
  bool _left = false;
  bool _pauseOpen = false;

  GameType get _type => widget.presentation.type;

  @override
  void initState() {
    super.initState();
    final saves = ref.read(savesControllerProvider.notifier);
    final c = widget.create(
      LocalGameSetup(
        services: ref.read(appServicesProvider),
        settings: ref.read(settingsControllerProvider),
        onSave: (save) {
          if (_left) return;
          if (save == null) {
            saves.delete(_type);
          } else {
            saves.write(save);
          }
        },
      ),
    );
    _controller = c;
    if (c == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        saves.delete(_type);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "That saved game couldn't be opened, so it was removed.",
            ),
          ),
        );
        context.go(AppRoutes.menu(_type));
      });
      return;
    }
    c.start();
    unawaited(c.finished.then(_onFinished));
  }

  void _onFinished(GameState finalState) {
    final c = _controller;
    if (!mounted || c == null) return;
    final me = c.me;
    final rows = c.resultRows(finalState);
    if (me != null) {
      final stats = ref
          .read(statsControllerProvider.notifier)
          .record(
            game: _type,
            mode: c.mode,
            won: rows.isNotEmpty && rows.first.player.id == me,
            stats: c.module.statsFor(finalState, me),
            specs: widget.presentation.statSpecs,
          );
      final fresh = ref
          .read(unlocksControllerProvider.notifier)
          .add(widget.presentation.unlocksFor(stats));
      if (fresh.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New board unlocked!')),
        );
      }
    }
    ref.read(appServicesProvider).audio.play(Sfx.win);
    context.go(
      AppRoutes.results(_type),
      extra: ResultSummary(
        game: _type,
        rows: rows,
        me: me,
        replay: NewGameLaunch(
          game: _type,
          seats: c.replaySeats,
          config: c.module.configCodec.encode(c.config),
          mode: c.mode,
        ),
      ),
    );
  }

  Future<void> _pause() async {
    final c = _controller;
    if (c == null || _pauseOpen) return;
    _pauseOpen = true;
    c.pause();
    var choice = await showPauseMenu(context);
    while (choice == PauseChoice.rules) {
      if (!mounted) return;
      await context.push(AppRoutes.howToPlay(_type));
      if (!mounted) return;
      choice = await showPauseMenu(context);
    }
    _pauseOpen = false;
    if (!mounted) return;
    switch (choice) {
      case PauseChoice.resume:
      case PauseChoice.rules:
        c.resume();
      case PauseChoice.saveAndExit:
        c.saveNow();
        _leave();
      case PauseChoice.quit:
        _left = true;
        ref.read(savesControllerProvider.notifier).delete(_type);
        _leave();
    }
  }

  void _leave() {
    _left = true;
    context.go(AppRoutes.menu(_type));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final audio = ref.watch(appServicesProvider).audio;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_pause());
      },
      child: MusicScope(
        audio: audio,
        track: widget.presentation.music,
        child: c == null
            ? const Scaffold()
            : ListenableBuilder(
                listenable: c,
                builder: (context, _) => widget.builder(context, c, () {
                  unawaited(_pause());
                }),
              ),
      ),
    );
  }
}
