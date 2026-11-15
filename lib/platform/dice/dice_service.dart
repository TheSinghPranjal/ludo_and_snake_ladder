import 'dart:math';

/// Source of die faces. Engines draw from it only after validating an intent,
/// so a rejected intent never consumes randomness.
abstract interface class DiceService {
  /// Returns a face from 1 to 6.
  int roll();
}

/// Cryptographically secure dice, used for every real game.
class SecureDiceService implements DiceService {
  /// Creates secure dice backed by `Random.secure()`.
  SecureDiceService() : _random = Random.secure();

  final Random _random;

  @override
  int roll() => _random.nextInt(6) + 1;
}

/// Reproducible dice for simulations and determinism tests.
class SeededDiceService implements DiceService {
  /// Creates dice seeded with [seed].
  SeededDiceService(int seed) : _random = Random(seed);

  final Random _random;

  @override
  int roll() => _random.nextInt(6) + 1;
}

/// Dice that return a fixed script of faces, for tests.
class ScriptedDiceService implements DiceService {
  /// Creates dice that return [faces] in order.
  ScriptedDiceService(Iterable<int> faces) : _faces = List.of(faces) {
    if (_faces.any((f) => f < 1 || f > 6)) {
      throw ArgumentError.value(faces, 'faces', 'must be 1 to 6');
    }
  }

  final List<int> _faces;
  int _next = 0;

  /// Number of faces not yet used.
  int get remaining => _faces.length - _next;

  /// Appends more faces to the script.
  void addAll(Iterable<int> faces) => _faces.addAll(faces);

  @override
  int roll() {
    if (_next >= _faces.length) {
      throw StateError('ScriptedDiceService ran out of faces');
    }
    return _faces[_next++];
  }
}
