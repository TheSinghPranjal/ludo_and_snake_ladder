/// Ludo board geometry on a 15×15 grid, exactly as specified.
///
/// Cells are `(row, col)`, 0-indexed from the top-left. A token's progress
/// is a relative step: -1 = base, 0..50 = main track (absolute cell
/// `(start + rel) % 52`), 51..55 = its own home column, 56 = HOME.
library;

import 'package:dice_party/platform/session/game_module.dart';

/// A grid cell.
typedef Cell = ({int row, int col});

/// Grid side.
const int gridSize = 15;

/// Number of main-track cells.
const int trackLength = 52;

/// Relative step of a token still in base.
const int baseRel = -1;

/// Last relative step on the main track.
const int lastTrackRel = 50;

/// First relative step of the home column.
const int firstHomeColumnRel = 51;

/// Relative step of a token that reached HOME.
const int homeRel = 56;

/// Tokens per player.
const int tokensPerPlayer = 4;

/// The 52 main-track cells in movement order, starting at Red's start.
const List<Cell> trackCells = [
  (row: 13, col: 6),
  (row: 12, col: 6),
  (row: 11, col: 6),
  (row: 10, col: 6),
  (row: 9, col: 6),
  (row: 8, col: 5),
  (row: 8, col: 4),
  (row: 8, col: 3),
  (row: 8, col: 2),
  (row: 8, col: 1),
  (row: 8, col: 0),
  (row: 7, col: 0),
  (row: 6, col: 0),
  (row: 6, col: 1),
  (row: 6, col: 2),
  (row: 6, col: 3),
  (row: 6, col: 4),
  (row: 6, col: 5),
  (row: 5, col: 6),
  (row: 4, col: 6),
  (row: 3, col: 6),
  (row: 2, col: 6),
  (row: 1, col: 6),
  (row: 0, col: 6),
  (row: 0, col: 7),
  (row: 0, col: 8),
  (row: 1, col: 8),
  (row: 2, col: 8),
  (row: 3, col: 8),
  (row: 4, col: 8),
  (row: 5, col: 8),
  (row: 6, col: 9),
  (row: 6, col: 10),
  (row: 6, col: 11),
  (row: 6, col: 12),
  (row: 6, col: 13),
  (row: 6, col: 14),
  (row: 7, col: 14),
  (row: 8, col: 14),
  (row: 8, col: 13),
  (row: 8, col: 12),
  (row: 8, col: 11),
  (row: 8, col: 10),
  (row: 8, col: 9),
  (row: 9, col: 8),
  (row: 10, col: 8),
  (row: 11, col: 8),
  (row: 12, col: 8),
  (row: 13, col: 8),
  (row: 14, col: 8),
  (row: 14, col: 7),
  (row: 14, col: 6),
];

/// Track index of each colour's start cell. Starts are 13 apart.
const Map<PlayerColor, int> startIndex = {
  PlayerColor.red: 0,
  PlayerColor.blue: 13,
  PlayerColor.yellow: 26,
  PlayerColor.green: 39,
};

/// Track indices of the four star cells.
const List<int> starIndices = [8, 21, 34, 47];

/// Track indices of the 8 safe cells: the 4 starts and the 4 stars.
final Set<int> safeIndices = {...startIndex.values, ...starIndices};

/// Each colour's home column, rel 51 to 55, leading into the centre.
const Map<PlayerColor, List<Cell>> homeColumns = {
  PlayerColor.red: [
    (row: 13, col: 7),
    (row: 12, col: 7),
    (row: 11, col: 7),
    (row: 10, col: 7),
    (row: 9, col: 7),
  ],
  PlayerColor.blue: [
    (row: 7, col: 1),
    (row: 7, col: 2),
    (row: 7, col: 3),
    (row: 7, col: 4),
    (row: 7, col: 5),
  ],
  PlayerColor.yellow: [
    (row: 1, col: 7),
    (row: 2, col: 7),
    (row: 3, col: 7),
    (row: 4, col: 7),
    (row: 5, col: 7),
  ],
  PlayerColor.green: [
    (row: 7, col: 13),
    (row: 7, col: 12),
    (row: 7, col: 11),
    (row: 7, col: 10),
    (row: 7, col: 9),
  ],
};

/// Top-left cell of each colour's 6×6 yard.
const Map<PlayerColor, Cell> yardOrigin = {
  PlayerColor.blue: (row: 0, col: 0),
  PlayerColor.yellow: (row: 0, col: 9),
  PlayerColor.green: (row: 9, col: 9),
  PlayerColor.red: (row: 9, col: 0),
};

/// The centre HOME cell.
const Cell homeCell = (row: 7, col: 7);

/// Clockwise turn order.
const List<PlayerColor> turnOrder = [
  PlayerColor.red,
  PlayerColor.blue,
  PlayerColor.yellow,
  PlayerColor.green,
];

/// Colours used for a game of [players] players, before any changes made in
/// setup: 2 players use opposite colours.
List<PlayerColor> defaultColors(int players) => switch (players) {
  2 => const [PlayerColor.red, PlayerColor.yellow],
  3 => const [PlayerColor.red, PlayerColor.blue, PlayerColor.yellow],
  _ => turnOrder,
};

/// Absolute track index of [rel] (0..50) for [color].
int absoluteIndex(PlayerColor color, int rel) =>
    (startIndex[color]! + rel) % trackLength;

/// Whether track index [index] is a safe cell.
bool isSafeIndex(int index) => safeIndices.contains(index);

/// Yard slot cell of token [tokenId] for [color]: the 2×2 slots inside the
/// yard's white inner square.
Cell yardSlot(PlayerColor color, int tokenId) {
  final o = yardOrigin[color]!;
  return (
    row: o.row + 2 + (tokenId ~/ 2) * 2,
    col: o.col + 2 + tokenId % 2 * 2,
  );
}

/// The cell a token of [color] occupies at [rel]. A token in base uses its
/// yard slot, so [tokenId] is needed there.
Cell cellAt(PlayerColor color, int rel, {int tokenId = 0}) {
  if (rel == baseRel) return yardSlot(color, tokenId);
  if (rel >= 0 && rel <= lastTrackRel) {
    return trackCells[absoluteIndex(color, rel)];
  }
  if (rel >= firstHomeColumnRel && rel < homeRel) {
    return homeColumns[color]![rel - firstHomeColumnRel];
  }
  if (rel == homeRel) return homeCell;
  throw RangeError.range(rel, baseRel, homeRel, 'rel');
}
