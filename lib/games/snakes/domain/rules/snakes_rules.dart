import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'snakes_rules.freezed.dart';
part 'snakes_rules.g.dart';

/// What happens when a roll would pass square 100.
enum Overshoot {
  /// The token does not move.
  stay,

  /// The token walks to 100 and back by the excess.
  bounce,
}

/// When the game ends.
enum PlayTo {
  /// As soon as one player reaches 100.
  firstWinner,

  /// When only one player is left, giving a full ranking.
  fullRanking,
}

/// House rules for Snakes & Ladders. The defaults are the Classic ruleset.
@freezed
abstract class SnakesRules with _$SnakesRules {
  /// Creates a ruleset.
  const factory SnakesRules({
    /// A token at 0 needs a 6, which places it on square 1.
    @Default(false) bool needSixToStart,

    /// What happens on a roll past 100.
    @Default(Overshoot.stay) Overshoot overshoot,

    /// A 6 gives another roll.
    @Default(true) bool extraRollOnSix,

    /// A third 6 in a row ends the turn and returns the token to where it
    /// started the turn.
    @Default(true) bool threeSixesPenalty,

    /// Landing on an opponent sends them to 0.
    @Default(false) bool capture,

    /// When the game ends.
    @Default(PlayTo.firstWinner) PlayTo playTo,
  }) = _SnakesRules;

  /// Reads rules from JSON.
  factory SnakesRules.fromJson(Map<String, dynamic> json) =>
      _$SnakesRulesFromJson(json);
}

/// Everything chosen before a Snakes & Ladders game.
@freezed
abstract class SnakesConfig with _$SnakesConfig {
  /// Creates a configuration.
  const factory SnakesConfig({
    @Default('classic_sunshine') String boardId,
    @Default(defaultSnakes) int snakeCount,
    @Default(SnakesRules()) SnakesRules rules,
  }) = _SnakesConfig;

  /// Reads a configuration from JSON.
  factory SnakesConfig.fromJson(Map<String, dynamic> json) =>
      _$SnakesConfigFromJson(json);
}
