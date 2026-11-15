/// Identity of the app, shared by the shell and the network protocol.
abstract final class AppInfo {
  /// Display name.
  static const String name = 'Ludo & Snake Ladder';

  /// Version shown in Settings and sent in `Hello`. Must match `pubspec.yaml`.
  static const String version = '1.0.0';

  /// Longest allowed profile or seat name.
  static const int maxNameLength = 12;

  /// Number of original avatars.
  static const int avatarCount = 12;
}
