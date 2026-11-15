import 'dart:convert';

import 'package:dice_party/core/result.dart';
import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/domain/board/board_loader.dart';
import 'package:dice_party/games/snakes/presentation/theme/board_palette.dart';
import 'package:flutter/services.dart';

/// Board ids in display order.
const List<String> snakesBoardIds = [
  'classic_sunshine',
  'sugar_rush',
  'jungle_temple',
];

/// The loaded boards and their theme palettes.
class SnakesContent {
  /// Creates the content.
  const SnakesContent({required this.boards, required this.palettes});

  /// Boards in display order.
  final List<BoardDef> boards;

  /// Palettes per brightness, keyed by theme id.
  final Map<Brightness, Map<String, SnakesBoardPalette>> palettes;

  /// Loads and validates every board and theme from [bundle].
  ///
  /// A board that fails validation is a build error, so it throws.
  static Future<SnakesContent> load(AssetBundle bundle) async {
    final boards = <BoardDef>[];
    for (final id in snakesBoardIds) {
      final src = await bundle.loadString(
        'assets/games/snakes/boards/$id.json',
      );
      switch (BoardLoader.parse(src)) {
        case Ok(:final value):
          boards.add(value);
        case Err(:final error):
          throw StateError('board $id is invalid: ${error.join('; ')}');
      }
    }
    final palettes = <Brightness, Map<String, SnakesBoardPalette>>{
      Brightness.light: {},
      Brightness.dark: {},
    };
    for (final theme in {for (final b in boards) b.theme}) {
      final json =
          jsonDecode(
                await bundle.loadString(
                  'assets/games/snakes/themes/$theme.json',
                ),
              )
              as Map<String, dynamic>;
      final modes = (json['modes'] as Map).cast<String, dynamic>();
      for (final b in Brightness.values) {
        final p = SnakesBoardPalette.fromJson(
          (modes[b.name] as Map).cast<String, dynamic>(),
        );
        if (p == null) throw StateError('theme $theme ${b.name} is invalid');
        palettes[b]![theme] = p;
      }
    }
    return SnakesContent(boards: boards, palettes: palettes);
  }
}
