import 'dart:convert';

import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/local_store.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/game_launch.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/settings/app_settings.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/ui/dice_view.dart';
import 'package:dice_party/platform/ui/player_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';

NewGameLaunch _launch(
  GameType game, {
  List<PlayerKind> kinds = const [PlayerKind.human, PlayerKind.ai],
  List<PlayerColor>? colors,
}) {
  final c =
      colors ??
      (game == GameType.ludo
          ? const [PlayerColor.red, PlayerColor.yellow]
          : PlayerColor.values);
  return NewGameLaunch(
    game: game,
    seats: [
      for (var i = 0; i < kinds.length; i++)
        SeatSpec(
          name: 'P$i',
          avatar: i,
          color: c[i],
          kind: kinds[i],
          aiLevel: kinds[i] == PlayerKind.ai ? AiLevel.normal : null,
        ),
    ],
    config: const {},
    mode: GameMode.local,
  );
}

Map<String, Object> _fast() => {
  LocalStore.settingsKey: jsonEncode(
    const AppSettings(speed: AnimationSpeed.fast).toJson(),
  ),
};

DiceView _dice(WidgetTester tester) =>
    tester.widget<DiceView>(find.byType(DiceView).first);

Future<void> _pumpFor(WidgetTester tester, Duration d) async {
  const step = Duration(milliseconds: 100);
  for (var t = Duration.zero; t < d; t += step) {
    await tester.pump(step);
  }
}

void main() {
  for (final game in GameType.values) {
    for (final size in const [
      Size(390, 844),
      Size(320, 640),
      Size(800, 1280),
    ]) {
      testWidgets(
        '${game.name} game renders at ${size.width.toInt()} dp, no overflow',
        (tester) async {
          setScreen(tester, size.width, size.height);
          final app = await TestApp.create();
          await app.start(tester);
          await app.go(
            tester,
            AppRoutes.play(game),
            extra: _launch(
              game,
              kinds: const [
                PlayerKind.human,
                PlayerKind.ai,
                PlayerKind.ai,
                PlayerKind.ai,
              ],
              colors: PlayerColor.values,
            ),
          );
          expect(find.byType(PlayerCard), findsNWidgets(4));
          expect(find.byType(DiceView), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('${game.name}: cards keep their size and the dice updates', (
      tester,
    ) async {
      final app = await TestApp.create(
        dice: () => ScriptedDiceService([3, 2, 5, 4, 1]),
      );
      await app.start(tester);
      await app.go(tester, AppRoutes.play(game), extra: _launch(game));
      final cards = find.byType(PlayerCard);
      final before = [
        for (final e in cards.evaluate())
          tester.getSize(find.byWidget(e.widget)),
      ];
      bool active(int i) => tester
          .widgetList<PlayerCard>(cards)
          .firstWhere((c) => c.player.id == 'p$i')
          .active;
      expect(active(0), isTrue);
      expect(_dice(tester).onRoll, isNotNull);
      await tester.tap(find.byType(DiceView).first);
      await tester.pump();
      expect(_dice(tester).rolling, isTrue);
      await _pumpFor(tester, const Duration(milliseconds: 900));
      expect(find.bySemanticsLabel('Dice showing 3'), findsOneWidget);
      expect(active(1), isTrue, reason: 'the turn passed to the AI');
      expect(active(0), isFalse);
      final after = [
        for (final e in cards.evaluate())
          tester.getSize(find.byWidget(e.widget)),
      ];
      expect(after, before);
      expect(tester.takeException(), isNull);
    });

    testWidgets('${game.name}: switching appearance keeps the game state', (
      tester,
    ) async {
      final app = await TestApp.create(
        dice: () => ScriptedDiceService([4, 2, 2, 2]),
      );
      await app.start(tester);
      await app.go(tester, AppRoutes.play(game), extra: _launch(game));
      await tester.tap(find.byType(DiceView).first);
      await _pumpFor(tester, const Duration(seconds: 3));
      final saved = app.container.read(savesControllerProvider)[game];
      expect(saved, isNotNull);
      final settings = app.container.read(settingsControllerProvider.notifier);
      for (final m in AppearanceMode.values.reversed) {
        settings.update((s) => s.copyWith(appearance: m));
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(app.container.read(savesControllerProvider)[game], saved);
      expect(find.byType(DiceView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a full Snakes & Ladders game against the AI reaches Results '
      'and records stats', (tester) async {
    final app = await TestApp.create(
      prefs: _fast(),
      dice: () => SeededDiceService(21),
    );
    await app.start(tester);
    await app.go(
      tester,
      AppRoutes.play(GameType.snakes),
      extra: _launch(GameType.snakes),
    );
    for (var i = 0; i < 3000; i++) {
      if (find.text('Play Again').evaluate().isNotEmpty) break;
      final dice = find.byType(DiceView);
      if (dice.evaluate().isNotEmpty && _dice(tester).onRoll != null) {
        await tester.tap(dice.first);
      }
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Play Again'), findsOneWidget);
    expect(find.textContaining('win'), findsWidgets);
    final stats = app.container.read(statsControllerProvider)[GameType.snakes]!;
    expect(stats.played, 1);
    expect(stats.values, contains('laddersClimbed'));
    expect(app.container.read(savesControllerProvider), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a 4-player all-AI Ludo game plays to Results', (tester) async {
    final app = await TestApp.create(
      prefs: _fast(),
      dice: () => SeededDiceService(5),
    );
    await app.start(tester);
    await app.go(
      tester,
      AppRoutes.play(GameType.ludo),
      extra: _launch(
        GameType.ludo,
        kinds: List.filled(4, PlayerKind.ai),
        colors: PlayerColor.values,
      ),
    );
    for (var i = 0; i < 6000; i++) {
      if (find.text('Play Again').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 500));
    }
    expect(find.text('Play Again'), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a saved game shows Continue on the Hub and resumes exactly', (
    tester,
  ) async {
    final app = await TestApp.create(
      dice: () => ScriptedDiceService([5, 3, 4, 4]),
    );
    await app.start(tester);
    await app.go(
      tester,
      AppRoutes.play(GameType.snakes),
      extra: _launch(GameType.snakes),
    );
    await tester.tap(find.byType(DiceView).first);
    await _pumpFor(tester, const Duration(seconds: 4));
    final save = app.container.read(savesControllerProvider)[GameType.snakes]!;
    await app.go(tester, AppRoutes.hub);
    final chip = find.bySemanticsLabel(RegExp('^Continue Snakes & Ladders'));
    expect(chip, findsOneWidget);
    await tester.tap(chip);
    await settle(tester);
    expect(find.byType(DiceView), findsOneWidget);
    expect(
      app.container.read(savesControllerProvider)[GameType.snakes]?.state,
      save.state,
    );
    expect(find.textContaining('Square 5'), findsOneWidget);
  });

  testWidgets('a corrupt save is discarded with a friendly message', (
    tester,
  ) async {
    final app = await TestApp.create();
    await app.start(tester);
    app.container
        .read(savesControllerProvider.notifier)
        .write(
          const SavedGameStub().save,
        );
    await app.go(
      tester,
      AppRoutes.play(GameType.ludo),
      extra: ResumeLaunch(const SavedGameStub().save),
    );
    await settle(tester);
    expect(find.textContaining("couldn't be opened"), findsOneWidget);
    expect(app.container.read(savesControllerProvider), isEmpty);
    expect(find.text('Play Local'), findsOneWidget);
  });
}

/// A save whose state is not a Ludo state.
class SavedGameStub {
  /// Creates the stub.
  const SavedGameStub();

  /// The broken save.
  SavedGame get save => const SavedGame(
    schemaVersion: saveSchemaVersion,
    game: GameType.ludo,
    mode: GameMode.local,
    config: {},
    state: {'players': 'nope'},
  );
}
