import 'package:dice_party/platform/theme/contrast.dart';
import 'package:flutter/material.dart';

/// Colours of one Snakes & Ladders board theme in one mode, read from
/// `assets/games/snakes/themes/<theme>.json`.
@immutable
class SnakesBoardPalette {
  /// Creates a palette.
  const SnakesBoardPalette({
    required this.tileA,
    required this.tileB,
    required this.frame,
    required this.background,
    required this.number,
    required this.numberHalo,
    required this.snakeBase,
    required this.snakeBelly,
    required this.snakeOutline,
    required this.snakeSpots,
    required this.ladderRail,
    required this.ladderRung,
    required this.ladderOutline,
  });

  /// Odd squares.
  final Color tileA;

  /// Even squares.
  final Color tileB;

  /// Board frame.
  final Color frame;

  /// Behind the board, top then bottom.
  final List<Color> background;

  /// Square numbers.
  final Color number;

  /// Halo behind numbers, or null.
  final Color? numberHalo;

  /// Snake body.
  final Color snakeBase;

  /// Snake belly stripe.
  final Color snakeBelly;

  /// Snake outline.
  final Color snakeOutline;

  /// Snake spots.
  final Color snakeSpots;

  /// Ladder rails.
  final Color ladderRail;

  /// Ladder rungs.
  final Color ladderRung;

  /// Ladder outline.
  final Color ladderOutline;

  /// Reads one mode of a theme file, or returns null if a colour is
  /// missing or malformed.
  static SnakesBoardPalette? fromJson(Map<String, dynamic> m) {
    Color? c(Object? v) => parseHexColor(v);
    Map<String, dynamic> g(String k) =>
        (m[k] as Map?)?.cast<String, dynamic>() ?? const {};
    final tiles = g('tiles');
    final numbers = g('numbers');
    final snake = g('snake');
    final ladder = g('ladder');
    final bg = (m['background'] as List?)?.map(c).toList() ?? const [];
    final values = [
      c(tiles['a']),
      c(tiles['b']),
      c(m['frame']),
      c(numbers['fill']),
      c(snake['base']),
      c(snake['belly']),
      c(snake['outline']),
      c(snake['spots']),
      c(ladder['rail']),
      c(ladder['rung']),
      c(ladder['outline']),
    ];
    if (values.contains(null) || bg.length != 2 || bg.contains(null)) {
      return null;
    }
    final v = values.cast<Color>();
    return SnakesBoardPalette(
      tileA: v[0],
      tileB: v[1],
      frame: v[2],
      background: bg.cast<Color>(),
      number: v[3],
      numberHalo: c(numbers['halo']),
      snakeBase: v[4],
      snakeBelly: v[5],
      snakeOutline: v[6],
      snakeSpots: v[7],
      ladderRail: v[8],
      ladderRung: v[9],
      ladderOutline: v[10],
    );
  }
}

/// Every Snakes & Ladders board theme for the current brightness.
@immutable
class SnakesPalettes extends ThemeExtension<SnakesPalettes> {
  /// Creates the extension.
  const SnakesPalettes(this.byTheme);

  /// Palettes keyed by theme id (sunshine, sweets, jungle).
  final Map<String, SnakesBoardPalette> byTheme;

  /// The palette of [theme], falling back to any loaded one.
  SnakesBoardPalette forTheme(String theme) =>
      byTheme[theme] ?? byTheme.values.first;

  /// The palettes of the current theme.
  static SnakesPalettes of(BuildContext context) =>
      Theme.of(context).extension<SnakesPalettes>()!;

  @override
  SnakesPalettes copyWith({Map<String, SnakesBoardPalette>? byTheme}) =>
      SnakesPalettes(byTheme ?? this.byTheme);

  @override
  SnakesPalettes lerp(covariant SnakesPalettes? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
