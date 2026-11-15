import 'dart:math';

import 'package:dice_party/games/snakes/domain/engine/snakes_intent.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_state.dart';
import 'package:dice_party/platform/session/game_module.dart';

/// Chooses a Snakes & Ladders intent for a computer player.
///
/// The Classic rules leave no choices, so the default strategy always rolls.
/// The interface exists for future rule variants that add choices.
abstract interface class BotStrategy {
  /// Picks one of [legal] for [ai].
  SnakesIntent choose(
    SnakesState state,
    PlayerId ai,
    List<SnakesIntent> legal,
    AiLevel level,
    Random rng,
  );
}

/// The strategy for the Classic rules: roll.
class RollingBot implements BotStrategy {
  /// Creates the strategy.
  const RollingBot();

  @override
  SnakesIntent choose(
    SnakesState state,
    PlayerId ai,
    List<SnakesIntent> legal,
    AiLevel level,
    Random rng,
  ) => legal.isEmpty ? const SnakesRoll() : legal.first;
}

/// Think time before an AI roll: Easy 900 ms, Normal 600 ms, halved in Fast.
Duration snakesThinkDelay(AiLevel level, {required bool fast}) {
  final ms = switch (level) {
    AiLevel.easy => 900,
    AiLevel.normal => 600,
  };
  return Duration(milliseconds: fast ? ms ~/ 2 : ms);
}
