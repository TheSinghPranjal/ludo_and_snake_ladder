import 'dart:ui';

import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/platform/session/game_module.dart';

/// Centre of [cell] in board-normalised coordinates (§5.6).
Offset cellCentre(Cell cell) =>
    Offset((cell.col + 0.5) / gridSize, (cell.row + 0.5) / gridSize);

/// Where a token of [color] at [rel] rests, in board-normalised
/// coordinates.
///
/// Base tokens sit on the 4 slot rings of the yard; HOME tokens sit in
/// their colour's centre triangle.
Offset tokenPoint(PlayerColor color, int rel, int tokenId) {
  if (rel == baseRel) {
    final o = yardOrigin[color]!;
    return Offset(
      (o.col + 2 + (tokenId % 2) * 2) / gridSize,
      (o.row + 2 + (tokenId ~/ 2) * 2) / gridSize,
    );
  }
  if (rel == homeRel) return homePoint(color);
  return cellCentre(cellAt(color, rel));
}

/// Centre of [color]'s HOME triangle.
Offset homePoint(PlayerColor color) {
  const c = 7.5 / gridSize;
  const d = 0.9 / gridSize;
  return switch (color) {
    PlayerColor.red => const Offset(c, c + d),
    PlayerColor.blue => const Offset(c - d, c),
    PlayerColor.yellow => const Offset(c, c - d),
    PlayerColor.green => const Offset(c + d, c),
  };
}
