import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter/material.dart';

/// Ludo board colours for one mode (§3.8).
///
/// Like `AppColors`, this is a palette file and may hold colour literals.
@immutable
class LudoBoardPalette extends ThemeExtension<LudoBoardPalette> {
  /// Creates a palette.
  const LudoBoardPalette({
    required this.base,
    required this.cell,
    required this.grid,
    required this.star,
    required this.frame,
    required this.yardInner,
    required this.onPlayer,
    required this.red,
    required this.blue,
    required this.yellow,
    required this.green,
  });

  /// Light: white cells, thin grey lines, flat bold yards.
  static const LudoBoardPalette light = LudoBoardPalette(
    base: Color(0xFFFFFFFF),
    cell: Color(0xFFFFFFFF),
    grid: Color(0xFFC9CED8),
    star: Color(0xFF5E6272),
    frame: Color(0xFFE2DCCD),
    yardInner: Color(0xFFFFFFFF),
    onPlayer: Color(0xFFFFFFFF),
    red: Color(0xFFD9342B),
    blue: Color(0xFF3E8EDE),
    yellow: Color(0xFFECCB3A),
    green: Color(0xFF3D9142),
  );

  /// Dark: navy board, player colours 10% less saturated.
  static const LudoBoardPalette dark = LudoBoardPalette(
    base: Color(0xFF171A24),
    cell: Color(0xFF232838),
    grid: Color(0xFF343A4F),
    star: Color(0xFFE6E8F0),
    frame: Color(0xFF262A3C),
    yardInner: Color(0xFF232838),
    onPlayer: Color(0xFFFFFFFF),
    red: Color(0xFFD03C34),
    blue: Color(0xFF468ED6),
    yellow: Color(0xFFE3C543),
    green: Color(0xFF418D46),
  );

  /// Board base under the cells.
  final Color base;

  /// Track cells.
  final Color cell;

  /// Grid lines.
  final Color grid;

  /// Star outlines on safe cells.
  final Color star;

  /// Frame around the board.
  final Color frame;

  /// Inner square of each yard.
  final Color yardInner;

  /// Marks drawn on player-coloured cells.
  final Color onPlayer;

  /// Red.
  final Color red;

  /// Blue.
  final Color blue;

  /// Yellow.
  final Color yellow;

  /// Green.
  final Color green;

  /// Colour of [c].
  Color player(PlayerColor c) => switch (c) {
    PlayerColor.red => red,
    PlayerColor.blue => blue,
    PlayerColor.yellow => yellow,
    PlayerColor.green => green,
  };

  /// The palette of the current theme.
  static LudoBoardPalette of(BuildContext context) =>
      Theme.of(context).extension<LudoBoardPalette>() ?? light;

  @override
  LudoBoardPalette copyWith() => this;

  @override
  LudoBoardPalette lerp(covariant LudoBoardPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return LudoBoardPalette(
      base: l(base, other.base),
      cell: l(cell, other.cell),
      grid: l(grid, other.grid),
      star: l(star, other.star),
      frame: l(frame, other.frame),
      yardInner: l(yardInner, other.yardInner),
      onPlayer: l(onPlayer, other.onPlayer),
      red: l(red, other.red),
      blue: l(blue, other.blue),
      yellow: l(yellow, other.yellow),
      green: l(green, other.green),
    );
  }
}
