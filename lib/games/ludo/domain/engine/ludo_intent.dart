import 'package:meta/meta.dart';

/// Something a Ludo player can do.
@immutable
sealed class LudoIntent {
  const LudoIntent();
}

/// Roll the die.
@immutable
final class LudoRoll extends LudoIntent {
  /// Creates a roll intent.
  const LudoRoll();

  @override
  bool operator ==(Object other) => other is LudoRoll;

  @override
  int get hashCode => (LudoRoll).hashCode;

  @override
  String toString() => 'LudoRoll';
}

/// Move token [tokenId] by the rolled value.
@immutable
final class MoveToken extends LudoIntent {
  /// Creates a move intent.
  const MoveToken(this.tokenId);

  /// Token to move, 0 to 3.
  final int tokenId;

  @override
  bool operator ==(Object other) =>
      other is MoveToken && other.tokenId == tokenId;

  @override
  int get hashCode => Object.hash(MoveToken, tokenId);

  @override
  String toString() => 'MoveToken($tokenId)';
}
