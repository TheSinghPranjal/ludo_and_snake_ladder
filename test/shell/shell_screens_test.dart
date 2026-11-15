import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/local_store.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';

const _sizes = [Size(390, 844), Size(320, 640), Size(800, 1280)];

void main() {
  for (final size in _sizes) {
    final tag = '${size.width.toInt()}×${size.height.toInt()}';

    testWidgets('Home and Hub render without overflow at $tag', (
      tester,
    ) async {
      setScreen(tester, size.width, size.height);
      final app = await TestApp.create();
      await app.start(tester);
      expect(find.text('Play'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await app.go(tester, AppRoutes.hub);
      expect(find.text('Snakes & Ladders'), findsOneWidget);
      expect(find.text('Ludo'), findsOneWidget);
      expect(find.text('Play'), findsNWidgets(2));
      expect(find.byTooltip('Back'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    for (final game in GameType.values) {
      testWidgets('${game.name} menu, setup and rules fit $tag', (
        tester,
      ) async {
        setScreen(tester, size.width, size.height);
        final app = await TestApp.create();
        await app.start(tester);
        await app.go(tester, AppRoutes.menu(game));
        expect(find.text('Play Local'), findsOneWidget);
        expect(find.text('Quick Play vs AI'), findsOneWidget);
        expect(tester.takeException(), isNull, reason: 'menu');
        await app.go(tester, AppRoutes.setup(game));
        expect(find.text('Player Setup'), findsOneWidget);
        expect(find.text('Start'), findsOneWidget);
        expect(tester.takeException(), isNull, reason: 'setup');
        await app.go(tester, AppRoutes.rules(game));
        expect(find.text('Game rules'), findsOneWidget);
        expect(tester.takeException(), isNull, reason: 'rules');
        await app.go(tester, AppRoutes.howToPlay(game));
        expect(find.text('Next'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Profile, Settings and Stats render at 320 dp', (tester) async {
    setScreen(tester, 320, 640);
    final app = await TestApp.create();
    await app.start(tester);
    for (final r in [AppRoutes.profile, AppRoutes.settings, AppRoutes.stats]) {
      await app.go(tester, r);
      expect(tester.takeException(), isNull, reason: r);
    }
    expect(find.text('Games played'), findsOneWidget);
  });

  testWidgets('the snakes stepper stays within 6–8 and updates the preview', (
    tester,
  ) async {
    final app = await TestApp.create();
    await app.start(tester);
    await app.go(tester, AppRoutes.setup(GameType.snakes));
    final more = find.bySemanticsLabel('More snakes');
    final fewer = find.bySemanticsLabel('Fewer snakes');
    await tester.ensureVisible(more);
    expect(find.bySemanticsLabel('7 snakes'), findsOneWidget);
    await tester.tap(more);
    await settle(tester);
    expect(find.bySemanticsLabel('8 snakes'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Classic Sunshine with 8 snakes'),
      findsOneWidget,
    );
    expect(tester.getSemantics(more), isNot(_enabled));
    await tester.tap(fewer);
    await tester.pump();
    await tester.tap(fewer);
    await settle(tester);
    expect(find.bySemanticsLabel('6 snakes'), findsOneWidget);
    expect(tester.getSemantics(fewer), isNot(_enabled));
  });

  testWidgets('the Sound toggle really mutes the audio service', (
    tester,
  ) async {
    final app = await TestApp.create();
    await app.start(tester);
    await app.go(tester, AppRoutes.settings);
    expect(app.services.audio.soundEnabled, isTrue);
    await tester.tap(find.text('Sound effects'));
    await settle(tester);
    expect(app.services.audio.soundEnabled, isFalse);
    app.services.audio.play(Sfx.uiTap);
    expect(app.audio.sfx, isEmpty);
    await tester.tap(find.text('Music'));
    await settle(tester);
    expect(app.audio.loops.last, isNull);
    expect(
      app.services.store.readJson(LocalStore.settingsKey)?['sound'],
      isFalse,
    );
  });

  testWidgets('Appearance switches live, and System follows the platform', (
    tester,
  ) async {
    final app = await TestApp.create();
    await app.start(tester);
    await app.go(tester, AppRoutes.settings);
    Brightness now() =>
        Theme.of(tester.element(find.text('Settings').first)).brightness;
    expect(now(), Brightness.light);
    await tester.tap(find.text('Dark'));
    await settle(tester);
    expect(now(), Brightness.dark);
    await tester.tap(find.text('System'));
    await settle(tester);
    expect(now(), Brightness.light);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await settle(tester);
    expect(now(), Brightness.dark);
  });

  testWidgets('Stats show recorded games', (tester) async {
    final app = await TestApp.create();
    app.container
        .read(statsControllerProvider.notifier)
        .record(
          game: GameType.ludo,
          mode: GameMode.ai,
          won: true,
          stats: const {'captures': 4},
          specs: const [StatSpec('captures', 'Captures', StatKind.total)],
        );
    await app.start(tester);
    await app.go(tester, AppRoutes.stats);
    await tester.tap(find.text('Ludo'));
    await settle(tester);
    expect(find.text('Captures'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });
}

final Matcher _enabled = matchesSemantics(
  isButton: true,
  hasEnabledState: true,
  isEnabled: true,
  isFocusable: true,
  hasTapAction: true,
);
