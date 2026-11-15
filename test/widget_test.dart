import 'package:dice_party/core/constants/app_info.dart';
import 'package:dice_party/platform/navigation/app_routes.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/shell/home/home_screen.dart';
import 'package:dice_party/shell/hub/hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'helpers/app_harness.dart';

void main() {
  testWidgets('app starts on the splash and opens Home', (tester) async {
    final app = await TestApp.create();
    await tester.pumpWidget(app.widget);
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.bySemanticsLabel(AppInfo.name), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
    await app.start(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('^${RegExp.escape(AppInfo.name)}')),
      findsOneWidget,
    );
  });

  testWidgets('Play opens the game Hub and back returns Home', (tester) async {
    final app = await TestApp.create();
    await app.start(tester);
    await tester.tap(find.text('Play'));
    await settle(tester);
    expect(find.byType(HubScreen), findsOneWidget);
    expect(find.text('Snakes & Ladders'), findsOneWidget);
    expect(find.text('Ludo'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await settle(tester);
    expect(find.byType(HubScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('a game menu opened directly still has back to the Hub', (
    tester,
  ) async {
    final app = await TestApp.create();
    await app.start(tester);
    await app.go(tester, AppRoutes.menu(GameType.ludo));
    expect(find.byTooltip('Back'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await settle(tester);
    expect(find.byType(HubScreen), findsOneWidget);
    expect(
      GoRouter.of(tester.element(find.byType(HubScreen))).state.matchedLocation,
      AppRoutes.hub,
    );
    await tester.tap(find.byTooltip('Back'));
    await settle(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home fits a 320 dp phone', (tester) async {
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final app = await TestApp.create();
    await app.start(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
