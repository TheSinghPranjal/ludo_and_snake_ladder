import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter/material.dart';

/// Shell colours for one brightness, from the §1.2 palette.
///
/// This file and the per-game board palettes are the only places in `lib/`
/// allowed to contain colour literals.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// Creates a palette.
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.text,
    required this.textMuted,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.onAccent,
    required this.danger,
    required this.onDanger,
    required this.success,
    required this.outline,
    required this.shadow,
    required this.scrim,
    required this.red,
    required this.blue,
    required this.yellow,
    required this.green,
    required this.tokenRim,
  });

  /// Light mode.
  static const AppColors light = AppColors(
    background: Color(0xFFFFF9EE),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFFFF3D6),
    text: Color(0xFF2A2A35),
    textMuted: Color(0xFF5E6272),
    primary: Color(0xFF2F7DE1),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFFFC93C),
    onAccent: Color(0xFF2A2A35),
    danger: Color(0xFFD64545),
    onDanger: Color(0xFFFFFFFF),
    success: Color(0xFF2E7D32),
    outline: Color(0xFFE3D9C4),
    shadow: Color(0x1F2A2A35),
    scrim: Color(0x992A2A35),
    red: Color(0xFFD9342B),
    blue: Color(0xFF3E8EDE),
    yellow: Color(0xFFECCB3A),
    green: Color(0xFF3D9142),
    tokenRim: Color(0xFF2A2A35),
  );

  /// Dark mode: a designed night palette with accents 10–15% less saturated.
  static const AppColors dark = AppColors(
    background: Color(0xFF12141C),
    surface: Color(0xFF1D2030),
    surfaceAlt: Color(0xFF262A3C),
    text: Color(0xFFF2F3F7),
    textMuted: Color(0xFFA9AEC2),
    primary: Color(0xFF4B86CF),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFEBC55A),
    onAccent: Color(0xFF2A2A35),
    danger: Color(0xFFD06060),
    onDanger: Color(0xFFFFFFFF),
    success: Color(0xFF81C784),
    outline: Color(0xFF343A4F),
    shadow: Color(0x66000000),
    scrim: Color(0xB3000000),
    red: Color(0xFFD03C34),
    blue: Color(0xFF468ED6),
    yellow: Color(0xFFE3C543),
    green: Color(0xFF418D46),
    tokenRim: Color(0xFFFFFFFF),
  );

  /// Page background.
  final Color background;

  /// Cards and sheets.
  final Color surface;

  /// Secondary surfaces such as chips and list groups.
  final Color surfaceAlt;

  /// Main text.
  final Color text;

  /// Secondary text.
  final Color textMuted;

  /// Primary buttons and active controls.
  final Color primary;

  /// Labels on [primary].
  final Color onPrimary;

  /// Highlights such as the Continue chip.
  final Color accent;

  /// Labels on [accent].
  final Color onAccent;

  /// Destructive actions.
  final Color danger;

  /// Labels on [danger].
  final Color onDanger;

  /// Positive state.
  final Color success;

  /// Hairlines and borders.
  final Color outline;

  /// Drop shadows.
  final Color shadow;

  /// Dialog barriers.
  final Color scrim;

  /// Red token colour.
  final Color red;

  /// Blue token colour.
  final Color blue;

  /// Yellow token colour.
  final Color yellow;

  /// Green token colour.
  final Color green;

  /// Edge drawn around tokens so they stand out from any board.
  final Color tokenRim;

  /// Colour of [color] tokens in this mode.
  Color player(PlayerColor color) => switch (color) {
    PlayerColor.red => red,
    PlayerColor.blue => blue,
    PlayerColor.yellow => yellow,
    PlayerColor.green => green,
  };

  /// The palette of the current theme.
  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? light;

  @override
  AppColors copyWith({Color? background, Color? surface, Color? text}) =>
      AppColors(
        background: background ?? this.background,
        surface: surface ?? this.surface,
        surfaceAlt: surfaceAlt,
        text: text ?? this.text,
        textMuted: textMuted,
        primary: primary,
        onPrimary: onPrimary,
        accent: accent,
        onAccent: onAccent,
        danger: danger,
        onDanger: onDanger,
        success: success,
        outline: outline,
        shadow: shadow,
        scrim: scrim,
        red: red,
        blue: blue,
        yellow: yellow,
        green: green,
        tokenRim: tokenRim,
      );

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceAlt: l(surfaceAlt, other.surfaceAlt),
      text: l(text, other.text),
      textMuted: l(textMuted, other.textMuted),
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      danger: l(danger, other.danger),
      onDanger: l(onDanger, other.onDanger),
      success: l(success, other.success),
      outline: l(outline, other.outline),
      shadow: l(shadow, other.shadow),
      scrim: l(scrim, other.scrim),
      red: l(red, other.red),
      blue: l(blue, other.blue),
      yellow: l(yellow, other.yellow),
      green: l(green, other.green),
      tokenRim: l(tokenRim, other.tokenRim),
    );
  }
}
