import 'package:dice_party/core/clock.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/haptics/haptics_service.dart';
import 'package:dice_party/platform/persistence/local_store.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_services.g.dart';

/// Long-lived services, created once by the composition root.
class AppServices {
  /// Creates the services.
  AppServices({
    required this.store,
    required this.audio,
    required this.haptics,
    required this.loadCatalog,
    this.clock = const SystemClock(),
    DiceService Function()? newDice,
  }) : newDice = newDice ?? SecureDiceService.new;

  /// Persistent JSON documents.
  final LocalStore store;

  /// Sound effects and music.
  final AudioService audio;

  /// Haptic feedback.
  final HapticsService haptics;

  /// Loads the games (boards and palettes) once, during the splash.
  final Future<GameCatalog> Function() loadCatalog;

  /// Time source for sessions.
  final Clock clock;

  /// Creates the dice for a new local session.
  final DiceService Function() newDice;
}

/// The app's services. The composition root must override this.
@Riverpod(keepAlive: true)
AppServices appServices(Ref ref) =>
    throw StateError('appServicesProvider must be overridden');

/// The loaded games.
@Riverpod(keepAlive: true)
Future<GameCatalog> gameCatalog(Ref ref) =>
    ref.watch(appServicesProvider).loadCatalog();
