import 'package:dice_party/games/snakes/domain/board/coords.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('squares map to boustrophedon cells', () {
    expect(squareCell(1), (row: 0, col: 0));
    expect(squareCell(10), (row: 0, col: 9));
    expect(squareCell(11), (row: 1, col: 9));
    expect(squareCell(20), (row: 1, col: 0));
    expect(squareCell(91), (row: 9, col: 9));
    expect(squareCell(100), (row: 9, col: 0));
  });

  test('centres are normalised with y pointing down', () {
    expect(squareCentre(1), (x: 0.05, y: 0.95));
    expect(squareCentre(10).x, closeTo(0.95, 1e-9));
    expect(squareCentre(100).x, closeTo(0.05, 1e-9));
    expect(squareCentre(100).y, closeTo(0.05, 1e-9));
    expect(squareCentre(0).y, greaterThan(1), reason: 'start pad is below');
  });

  test('out-of-range squares throw', () {
    expect(() => squareCell(0), throwsRangeError);
    expect(() => squareCell(101), throwsRangeError);
  });
}
