import 'dart:io';

import 'package:dice_party/app/app.dart';
import 'package:dice_party/app/router.dart';
import 'package:dice_party/games/ludo/presentation/ludo_presentation.dart';
import 'package:dice_party/games/snakes/application/board_repository.dart';
import 'package:dice_party/games/snakes/presentation/snakes_presentation.dart';
import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/audio/flame_audio_backend.dart';
import 'package:dice_party/platform/haptics/haptics_service.dart';
import 'package:dice_party/platform/persistence/local_store.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Loads every game: Snakes & Ladders boards and palettes, and Ludo.
Future<GameCatalog> loadGameCatalog(AssetBundle bundle) async {
  final snakes = await SnakesContent.load(bundle);
  return GameCatalog([SnakesPresentation(snakes), LudoPresentation()]);
}

/// Builds the root widget with [services], wiring the router to the same
/// provider container.
Widget buildRoot(AppServices services) {
  final container = ProviderContainer(
    overrides: [appServicesProvider.overrideWithValue(services)],
  );
  return UncontrolledProviderScope(
    container: container,
    child: DicePartyApp(router: buildRouter(container)),
  );
}

/// Creates the production services.
Future<AppServices> createServices() async {
  final prefs = await SharedPreferences.getInstance();
  final backend = FlameAudioBackend();
  await backend.initialize();
  return AppServices(
    store: LocalStore(prefs),
    audio: AudioService(backend, extension: Platform.isIOS ? 'm4a' : 'ogg'),
    haptics: HapticsService(),
    loadCatalog: () => loadGameCatalog(rootBundle),
  );
}
