import 'package:dice_party/platform/session/game_module.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Settings → Appearance.
enum AppearanceMode {
  /// Follow the phone, live.
  system,

  /// Always light.
  light,

  /// Always dark.
  dark,
}

/// Settings → Animation speed.
enum AnimationSpeed {
  /// Standard timings.
  normal,

  /// Hops at half length and AI think time halved.
  fast,
}

/// Global settings, saved in shared preferences.
@freezed
abstract class AppSettings with _$AppSettings {
  /// Creates settings. The defaults are the first-run values.
  const factory AppSettings({
    @Default(AppearanceMode.system) AppearanceMode appearance,
    @Default(true) bool sound,
    @Default(true) bool music,
    @Default(true) bool haptics,
    @Default(AnimationSpeed.normal) AnimationSpeed speed,

    /// Whether local games use the 30 s turn timer.
    @Default(false) bool localTimer,
    @Default(AiLevel.normal) AiLevel defaultAi,
  }) = _AppSettings;

  const AppSettings._();

  /// Reads settings from JSON.
  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  /// Whether Fast animation speed is on.
  bool get fast => speed == AnimationSpeed.fast;
}

/// The player's profile: default local player 1 and online name.
@freezed
abstract class Profile with _$Profile {
  /// Creates a profile.
  const factory Profile({
    @Default('Player') String name,
    @Default(0) int avatar,
  }) = _Profile;

  /// Reads a profile from JSON.
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
