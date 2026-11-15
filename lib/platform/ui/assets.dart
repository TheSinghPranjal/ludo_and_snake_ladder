import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter/widgets.dart';

/// Paths of shared assets from `assets/manifest.json`.
abstract final class SharedAssets {
  /// Adds the `_light` / `_dark` suffix for [brightness] to [base].
  static String themed(String base, Brightness brightness) =>
      '${base}_${brightness == Brightness.dark ? 'dark' : 'light'}.png';

  /// File stems of the 12 avatars, in index order.
  static const List<String> avatarNames = [
    'avatar_01_fox',
    'avatar_02_owl',
    'avatar_03_cat',
    'avatar_04_frog',
    'avatar_05_panda',
    'avatar_06_bear',
    'avatar_07_penguin',
    'avatar_08_bunny',
    'avatar_09_robot',
    'avatar_10_octopus',
    'avatar_11_dino',
    'avatar_12_chick',
  ];

  /// Avatar [index], wrapped into range.
  static String avatar(int index) =>
      'assets/shared/avatars/${avatarNames[index % avatarNames.length]}.png';

  /// Readable name of avatar [index], for semantics.
  static String avatarLabel(int index) =>
      avatarNames[index % avatarNames.length].split('_').last;

  /// Monochrome icon [name], tinted at runtime.
  static String icon(String name) => 'assets/shared/icons/icon_$name.png';

  /// A token of [color] in [state] (idle, active, movable, selected, hop,
  /// ghost).
  static String token(PlayerColor color, String state, Brightness b) =>
      themed('assets/shared/tokens/token_${color.name}_$state', b);

  /// Dice face [value] (1..6).
  static String diceFace(int value, Brightness b) =>
      themed('assets/shared/dice/dice_face_$value', b);

  /// Dice tumble frame [frame] (1..8).
  static String diceRoll(int frame, Brightness b) => themed(
    'assets/shared/dice/dice_roll_${frame.toString().padLeft(2, '0')}',
    b,
  );

  /// Medal for [rank] (1..4).
  static String medal(int rank) => 'assets/shared/cards/rank_$rank.png';

  /// The splash wordmark.
  static String wordmark(Brightness b) =>
      themed('assets/shared/brand/wordmark', b);

  /// The illustrated Home background, title included.
  static const String homeBackground = 'assets/shared/home/home_bg.webp';

  /// The dice-and-snake logo shown on the splash.
  static String splashLogo(Brightness b) =>
      themed('assets/shared/brand/splash_logo', b);
}

/// Colour-blind symbol of each token colour.
String colorSymbol(PlayerColor c) => switch (c) {
  PlayerColor.red => '●',
  PlayerColor.blue => '■',
  PlayerColor.yellow => '▲',
  PlayerColor.green => '★',
};

/// Capitalised colour name.
String colorName(PlayerColor c) => switch (c) {
  PlayerColor.red => 'Red',
  PlayerColor.blue => 'Blue',
  PlayerColor.yellow => 'Yellow',
  PlayerColor.green => 'Green',
};
