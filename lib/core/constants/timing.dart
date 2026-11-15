/// Every timing constant shared by the games and the multiplayer platform.
///
/// Nothing else in the app may hard-code these durations.
abstract final class Timing {
  /// Time a human or remote player has to act at a decision point.
  static const Duration turn = Duration(seconds: 30);

  /// Delay between committing a roll and playing a single legal Ludo move.
  static const Duration autoMove = Duration(milliseconds: 1120);

  /// Length of the dice tumble animation.
  static const Duration dice = Duration(milliseconds: 800);

  /// How long a disconnected online seat is kept before removal.
  static const Duration grace = Duration(seconds: 45);

  /// Interval between heartbeat pings.
  static const Duration heartbeat = Duration(seconds: 3);

  /// Silence after which a peer counts as disconnected.
  static const Duration silenceLimit = Duration(seconds: 9);
}
