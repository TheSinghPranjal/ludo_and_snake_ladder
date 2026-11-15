import 'dart:async';

import 'package:dice_party/app/app.dart';
import 'package:dice_party/app/bootstrap.dart';
import 'package:dice_party/app/router.dart';
import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/haptics/haptics_service.dart';
import 'package:dice_party/platform/persistence/local_store.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/shell/splash/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records what the app asked the audio backend to play.
class RecordingAudioBackend implements AudioBackend {
  /// Sound effect files played.
  final List<String> sfx = [];

  /// Music loop changes; null means stopped.
  final List<String?> loops = [];

  @override
  Future<void> playSfx(String file) async => sfx.add(file);

  @override
  Future<void> playLoop(String file) async => loops.add(file);

  @override
  Future<void> stopLoop() async => loops.add(null);
}

GameCatalog? _catalog;

/// Loads the real game catalog once per test file.
Future<GameCatalog> testCatalog() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  return _catalog ??= await loadGameCatalog(rootBundle);
}

/// A running app for widget tests.
class TestApp {
  TestApp._(this.services, this.audio, this.container, this.router);

  /// Services given to the app.
  final AppServices services;

  /// What was played.
  final RecordingAudioBackend audio;

  /// Provider container.
  final ProviderContainer container;

  /// Router.
  final GoRouter router;

  /// Builds services over mock preferences [prefs].
  static Future<TestApp> create({
    Map<String, Object> prefs = const {},
    DiceService Function()? dice,
  }) async {
    final catalog = await testCatalog();
    SharedPreferences.setMockInitialValues(prefs);
    final sp = await SharedPreferences.getInstance();
    final audio = RecordingAudioBackend();
    final services = AppServices(
      store: LocalStore(sp),
      audio: AudioService(audio, extension: 'ogg'),
      haptics: HapticsService(perform: (_) async {}),
      loadCatalog: () async => catalog,
      newDice: dice ?? () => SeededDiceService(7),
    );
    final container = ProviderContainer(
      overrides: [appServicesProvider.overrideWithValue(services)],
    );
    await container.read(gameCatalogProvider.future);
    return TestApp._(services, audio, container, buildRouter(container));
  }

  /// The root widget.
  Widget get widget => UncontrolledProviderScope(
    container: container,
    child: DicePartyApp(router: router),
  );

  /// Pumps the app and lets the splash finish.
  Future<void> start(WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await settle(tester);
    await tester.pump(splashMinDuration + const Duration(milliseconds: 200));
    await settle(tester);
  }

  /// Opens [location] with [extra].
  Future<void> go(WidgetTester tester, String location, {Object? extra}) async {
    router.go(location, extra: extra);
    await settle(tester);
  }
}

/// Pumps frames for up to [max], stopping early once nothing is scheduled.
///
/// Unlike `pumpAndSettle` it tolerates endless animations such as the
/// timer ring.
Future<void> settle(
  WidgetTester tester, {
  Duration max = const Duration(seconds: 2),
}) async {
  const step = Duration(milliseconds: 50);
  var t = Duration.zero;
  await tester.pump();
  while (t < max && tester.binding.hasScheduledFrame) {
    await tester.pump(step);
    t += step;
  }
}

/// Sets the test surface to [width] × [height] logical pixels.
void setScreen(WidgetTester tester, double width, double height) {
  tester.view
    ..physicalSize = Size(width * 3, height * 3)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

/// Runs [f] with real async I/O allowed (image decoding etc.).
Future<T?> real<T>(WidgetTester tester, Future<T> Function() f) =>
    tester.runAsync(f);

/// Keeps the analyzer quiet about an intentionally unawaited future.
void fireAndForget(Future<void> f) => unawaited(f);
