// The brief asks for the counts and χ² to be printed.
// ignore_for_file: avoid_print

import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:flutter_test/flutter_test.dart';

const _rolls = 120000;
const double _expected = _rolls / 6;

/// χ² critical value for 5 degrees of freedom at p = 0.001.
const _chiCritical = 20.515;

void _checkFairness(String name, DiceService dice) {
  final counts = List.filled(7, 0);
  for (var i = 0; i < _rolls; i++) {
    counts[dice.roll()]++;
  }
  expect(counts[0], 0, reason: 'no zero faces');
  var chi = 0.0;
  for (var f = 1; f <= 6; f++) {
    final d = counts[f] - _expected;
    chi += d * d / _expected;
    expect(
      (counts[f] - _expected).abs(),
      lessThanOrEqualTo(_expected * 0.03),
      reason: 'face $f count ${counts[f]} not within ±3% of 20000',
    );
  }
  print(
    '$name: faces 1-6 = ${counts.sublist(1)}, '
    'χ² = ${chi.toStringAsFixed(3)}',
  );
  expect(chi, lessThan(_chiCritical));
}

void main() {
  test('SeededDiceService (seed 42) is fair over 120,000 rolls', () {
    _checkFairness('SeededDiceService(42)', SeededDiceService(42));
  });

  test('SecureDiceService is fair over 120,000 rolls', () {
    _checkFairness('SecureDiceService', SecureDiceService());
  });

  test('SeededDiceService is reproducible', () {
    final a = SeededDiceService(7);
    final b = SeededDiceService(7);
    expect(
      List.generate(50, (_) => a.roll()),
      List.generate(50, (_) => b.roll()),
    );
  });

  test('ScriptedDiceService plays its script and rejects bad faces', () {
    final dice = ScriptedDiceService([3, 6, 1]);
    expect([dice.roll(), dice.roll(), dice.roll()], [3, 6, 1]);
    expect(dice.remaining, 0);
    expect(dice.roll, throwsStateError);
    expect(() => ScriptedDiceService([7]), throwsArgumentError);
  });
}
