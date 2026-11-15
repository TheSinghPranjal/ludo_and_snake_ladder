import 'package:meta/meta.dart';

/// Something a Snakes & Ladders player can do.
///
/// A roll resolves the whole move, so rolling is the only intent.
@immutable
sealed class SnakesIntent {
  const SnakesIntent();
}

/// Roll the die.
@immutable
final class SnakesRoll extends SnakesIntent {
  /// Creates a roll intent.
  const SnakesRoll();

  @override
  bool operator ==(Object other) => other is SnakesRoll;

  @override
  int get hashCode => (SnakesRoll).hashCode;

  @override
  String toString() => 'SnakesRoll';
}
