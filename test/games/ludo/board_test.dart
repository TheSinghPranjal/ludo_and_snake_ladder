import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter_test/flutter_test.dart';

bool _orthogonal(Cell a, Cell b) =>
    (a.row - b.row).abs() + (a.col - b.col).abs() == 1;

bool _diagonal(Cell a, Cell b) =>
    (a.row - b.row).abs() == 1 && (a.col - b.col).abs() == 1;

void main() {
  test('the track has exactly 52 unique cells inside the grid', () {
    expect(trackCells.length, 52);
    expect(trackCells.toSet().length, 52);
    for (final c in trackCells) {
      expect(c.row, inInclusiveRange(0, gridSize - 1));
      expect(c.col, inInclusiveRange(0, gridSize - 1));
    }
  });

  test('the track is a closed loop of adjacent cells', () {
    final diagonals = <int>[];
    for (var i = 0; i < trackLength; i++) {
      final a = trackCells[i];
      final b = trackCells[(i + 1) % trackLength];
      if (_diagonal(a, b)) {
        diagonals.add(i);
      } else {
        expect(_orthogonal(a, b), isTrue, reason: 'step $i → ${i + 1}');
      }
    }
    expect(diagonals, [4, 17, 30, 43], reason: 'only the 4 corner steps');
  });

  test('starts are 0/13/26/39 at the specified cells', () {
    expect(startIndex, {
      PlayerColor.red: 0,
      PlayerColor.blue: 13,
      PlayerColor.yellow: 26,
      PlayerColor.green: 39,
    });
    expect(trackCells[0], (row: 13, col: 6));
    expect(trackCells[13], (row: 6, col: 1));
    expect(trackCells[26], (row: 1, col: 8));
    expect(trackCells[39], (row: 8, col: 13));
  });

  test('turn order is clockwise Red → Blue → Yellow → Green', () {
    expect(turnOrder, [
      PlayerColor.red,
      PlayerColor.blue,
      PlayerColor.yellow,
      PlayerColor.green,
    ]);
    for (var i = 1; i < turnOrder.length; i++) {
      expect(
        startIndex[turnOrder[i]]! - startIndex[turnOrder[i - 1]]!,
        13,
      );
    }
  });

  test('exactly 8 safe cells: 4 starts and 4 stars', () {
    expect(safeIndices, {0, 8, 13, 21, 26, 34, 39, 47});
    expect(
      [for (final i in starIndices) trackCells[i]],
      [
        (row: 8, col: 2),
        (row: 2, col: 6),
        (row: 6, col: 12),
        (row: 12, col: 8),
      ],
    );
  });

  test('last track cells and home columns match the table', () {
    expect(cellAt(PlayerColor.red, 50), (row: 14, col: 7));
    expect(cellAt(PlayerColor.blue, 50), (row: 7, col: 0));
    expect(cellAt(PlayerColor.yellow, 50), (row: 0, col: 7));
    expect(cellAt(PlayerColor.green, 50), (row: 7, col: 14));
    expect(homeColumns[PlayerColor.red]!.first, (row: 13, col: 7));
    expect(homeColumns[PlayerColor.blue]!.first, (row: 7, col: 1));
    expect(homeColumns[PlayerColor.yellow]!.first, (row: 1, col: 7));
    expect(homeColumns[PlayerColor.green]!.first, (row: 7, col: 13));
  });

  test('home columns are adjacent paths that avoid the track and '
      'each other', () {
    final seen = <Cell>{...trackCells, homeCell};
    for (final color in PlayerColor.values) {
      final column = homeColumns[color]!;
      expect(column.length, 5);
      expect(_orthogonal(cellAt(color, 50), column.first), isTrue);
      for (var i = 1; i < column.length; i++) {
        expect(_orthogonal(column[i - 1], column[i]), isTrue);
      }
      // The column ends against the 3×3 centre, whose middle is HOME.
      final last = column.last;
      expect(
        (last.row - homeCell.row).abs() + (last.col - homeCell.col).abs(),
        2,
      );
      for (final c in column) {
        expect(seen.add(c), isTrue, reason: '$color $c overlaps');
      }
    }
  });

  test('a token takes exactly 56 steps from start to HOME', () {
    for (final color in PlayerColor.values) {
      final cells = [for (var r = 0; r <= homeRel; r++) cellAt(color, r)];
      expect(cells.toSet().length, 57);
      expect(cells.last, homeCell);
    }
  });
}
