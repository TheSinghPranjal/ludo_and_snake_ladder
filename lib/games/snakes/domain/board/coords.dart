/// Square geometry of the 10×10 boustrophedon board.
///
/// Square 1 is bottom-left, row 1 runs left to right, row 2 right to left,
/// and square 100 is top-left.
library;

/// A point in board-normalised coordinates: x right, y down, 0..1.
typedef BoardPoint = ({double x, double y});

/// Number of squares on a side.
const int boardSide = 10;

/// Last square.
const int lastSquare = 100;

/// Row (0 at the bottom) and column (0 at the left) of [square], 1..100.
({int row, int col}) squareCell(int square) {
  if (square < 1 || square > lastSquare) {
    throw RangeError.range(square, 1, lastSquare, 'square');
  }
  final row = (square - 1) ~/ boardSide;
  final c = (square - 1) % boardSide;
  return (row: row, col: row.isEven ? c : boardSide - 1 - c);
}

/// Centre of [square] in board-normalised coordinates.
///
/// Position 0, the start pad, sits under square 1 outside the board.
BoardPoint squareCentre(int square) {
  if (square == 0) return (x: 0.5 / boardSide, y: 1 + 0.5 / boardSide);
  final cell = squareCell(square);
  return (
    x: (cell.col + 0.5) / boardSide,
    y: 1 - (cell.row + 0.5) / boardSide,
  );
}
