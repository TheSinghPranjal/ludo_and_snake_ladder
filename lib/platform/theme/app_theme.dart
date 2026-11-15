import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:flutter/material.dart';

/// Display font family (titles, numbers).
const String displayFont = 'Fredoka';

/// Body font family.
const String bodyFont = 'Nunito';

/// How long a light/dark switch cross-fades.
const Duration themeFade = Duration(milliseconds: 250);

/// Builds the Material theme for [brightness], adding each game's
/// [extensions] (board palettes) beside [AppColors].
ThemeData buildAppTheme(
  Brightness brightness, {
  Iterable<ThemeExtension<dynamic>> extensions = const [],
}) {
  final c = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.primary,
    onPrimary: c.onPrimary,
    secondary: c.accent,
    onSecondary: c.onAccent,
    error: c.danger,
    onError: c.onDanger,
    surface: c.surface,
    onSurface: c.text,
    onSurfaceVariant: c.textMuted,
    surfaceContainerHighest: c.surfaceAlt,
    outline: c.outline,
    shadow: c.shadow,
    scrim: c.scrim,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    brightness: brightness,
    fontFamily: bodyFont,
  );
  TextStyle display(double size, FontWeight w) =>
      TextStyle(fontFamily: displayFont, fontSize: size, fontWeight: w);
  final text = base.textTheme
      .copyWith(
        displaySmall: display(34, FontWeight.w700),
        headlineMedium: display(28, FontWeight.w700),
        headlineSmall: display(24, FontWeight.w600),
        titleLarge: display(22, FontWeight.w600),
        titleMedium: display(18, FontWeight.w600),
        labelLarge: const TextStyle(
          fontFamily: bodyFont,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      )
      .apply(bodyColor: c.text, displayColor: c.text);
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Space.radius),
  );
  return base.copyWith(
    scaffoldBackgroundColor: c.background,
    canvasColor: c.background,
    textTheme: text,
    extensions: [c, ...extensions],
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: display(22, FontWeight.w600).copyWith(color: c.text),
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 1,
      shadowColor: c.shadow,
      shape: shape,
      margin: EdgeInsets.zero,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surface,
      shape: shape,
      titleTextStyle: display(22, FontWeight.w600).copyWith(color: c.text),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(Space.tap, Space.tap),
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        textStyle: display(18, FontWeight.w600),
        shape: shape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(Space.tap, Space.tap),
        foregroundColor: c.text,
        side: BorderSide(color: c.outline, width: 1.5),
        textStyle: display(18, FontWeight.w600),
        shape: shape,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(Space.tap, Space.tap),
        foregroundColor: c.text,
        textStyle: const TextStyle(
          fontFamily: bodyFont,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(Space.tap, Space.tap),
        foregroundColor: c.text,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.onPrimary : c.textMuted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.primary : c.surfaceAlt,
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: c.primary,
        selectedForegroundColor: c.onPrimary,
        foregroundColor: c.text,
        minimumSize: const Size(Space.tap, Space.tap),
      ),
    ),
    dividerTheme: DividerThemeData(color: c.outline, space: 1),
    listTileTheme: ListTileThemeData(
      iconColor: c.text,
      textColor: c.text,
      minVerticalPadding: Space.m,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.text,
      contentTextStyle: TextStyle(color: c.background, fontFamily: bodyFont),
      behavior: SnackBarBehavior.floating,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: c.text,
      unselectedLabelColor: c.textMuted,
      indicatorColor: c.primary,
      labelStyle: display(18, FontWeight.w600),
    ),
  );
}
