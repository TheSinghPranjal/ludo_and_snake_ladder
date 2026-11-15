import 'package:flutter/painting.dart';

/// Colours of the Home screen, sampled from its daytime illustration. Home
/// always shows that artwork, so these do not follow the light/dark theme.
abstract final class HomePalette {
  /// Background below the artwork.
  static const cream = Color(0xFFFEEDCF);

  /// Labels on the cream controls.
  static const ink = Color(0xFF272634);

  /// Profile pill and Settings button.
  static const chip = Color(0xFFFCF8F2);

  /// Top of the Stats / How to Play buttons.
  static const buttonTop = Color(0xFFFFFBF5);

  /// Bottom of the Stats / How to Play buttons.
  static const buttonBottom = Color(0xFFFCEBD3);

  /// Play button gradient, top.
  static const playTop = Color(0xFF2DA8FF);

  /// Play button gradient, middle.
  static const playMid = Color(0xFF0A6DFC);

  /// Play button gradient, bottom.
  static const playBottom = Color(0xFF0052E0);

  /// Blue glow under the Play button.
  static const playGlow = Color(0x660067FC);

  /// Shadow under the Play label.
  static const playShade = Color(0x66003C9E);

  /// Shadow under the play triangle.
  static const playShadeSoft = Color(0x55003C9E);

  /// Avatar ring, top.
  static const ringLight = Color(0xFFFDD280);

  /// Avatar ring, bottom.
  static const ringDark = Color(0xFFF39A2E);

  /// Soft shadow under the cream controls.
  static const shadow = Color(0x40A8763E);

  /// Soft light around the Play button rim.
  static const rimGlow = Color(0x33FFFFFF);

  /// Borders, the play icon and the gloss.
  static const white = Color(0xFFFFFFFF);

  /// Fully transparent, for fades.
  static const clear = Color(0x00FFFFFF);
}
