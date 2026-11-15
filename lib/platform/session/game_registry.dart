import 'package:dice_party/platform/session/game_module.dart';

/// Every game the app offers, looked up by [GameType].
///
/// The shell reaches games only through this registry, so it has no
/// game-specific branches.
class GameRegistry {
  /// Creates a registry from [modules]. Each type may appear once.
  GameRegistry(Iterable<GameModule<GameState, Object, Object, Object>> modules)
    : _modules = {for (final m in modules) m.type: m} {
    if (_modules.length != modules.length) {
      throw ArgumentError.value(modules, 'modules', 'duplicate game type');
    }
  }

  final Map<GameType, GameModule<GameState, Object, Object, Object>> _modules;

  /// Registered games, in [GameType] order.
  List<GameModule<GameState, Object, Object, Object>> get modules => [
    for (final t in GameType.values) ?_modules[t],
  ];

  /// The module for [type], or null if it is not registered.
  GameModule<GameState, Object, Object, Object>? module(GameType type) =>
      _modules[type];
}
