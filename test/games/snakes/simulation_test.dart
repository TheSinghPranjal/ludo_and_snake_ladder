// The brief asks for the simulation table to be printed.
// ignore_for_file: avoid_print

import 'package:dice_party/games/snakes/domain/engine/snakes_engine.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_events.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_intent.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_state.dart';
import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/games/snakes/domain/snakes_module.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

const _games = 10000;
const _turnCap = 1000;

/// Plays one game and returns the rounds (turns of the player who took the
/// most), or null if it hit the cap.
int? _play(SnakesModule module, String board, int snakes, DiceService dice) {
  var s = module.newGame(
    seats(2),
    SnakesConfig(boardId: board, snakeCount: snakes),
  );
  while (!s.isOver) {
    final r = module.apply(s, s.currentPlayer!, const SnakesRoll(), dice);
    s = (r as Accepted<SnakesState, SnakesEvent>).state;
    if (s.turnNumber > _turnCap * 2) return null;
  }
  return s.players
      .map((p) => p.stats[SnakesStats.turns]!.toInt())
      .reduce((a, b) => a > b ? a : b);
}

List<int> _games_(String board, int snakes, int seed) {
  final module = SnakesModule(loadShippedBoards());
  final dice = SeededDiceService(seed);
  return [
    for (var g = 0; g < _games; g++)
      _play(module, board, snakes, dice) ?? _turnCap + 1,
  ];
}

void main() {
  test(
    '10,000 two-player games per board and snake count stay in range',
    () {
      final rows = <String>[
        '${'board'.padRight(18)} snakes   mean  median   max',
      ];
      var seed = 1;
      for (final board in shippedBoardIds) {
        for (final n in [6, 7, 8]) {
          final turns = _games_(board, n, seed++)..sort();
          final mean = turns.reduce((a, b) => a + b) / turns.length;
          final median = turns[turns.length ~/ 2];
          rows.add(
            '${board.padRight(18)} ${n.toString().padLeft(6)} '
            '${mean.toStringAsFixed(2).padLeft(6)} '
            '${median.toString().padLeft(7)} '
            '${turns.last.toString().padLeft(5)}',
          );
          expect(turns.last, lessThanOrEqualTo(_turnCap), reason: '$board/$n');
          expect(mean, inInclusiveRange(20, 45), reason: '$board/$n');
        }
      }
      print(rows.join('\n'));
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test('same seed gives the same game', () {
    List<Map<String, dynamic>> log(int seed) {
      final module = SnakesModule(loadShippedBoards());
      final dice = SeededDiceService(seed);
      var s = module.newGame(
        seats(4),
        const SnakesConfig(
          rules: SnakesRules(capture: true, playTo: PlayTo.fullRanking),
        ),
      );
      final events = <Map<String, dynamic>>[];
      while (!s.isOver) {
        final r =
            module.apply(s, s.currentPlayer!, const SnakesRoll(), dice)
                as Accepted<SnakesState, SnakesEvent>;
        events.addAll(r.events.map((e) => e.toJson()));
        s = r.state;
      }
      return events;
    }

    final a = log(99);
    expect(a, isNotEmpty);
    expect(log(99), a);
    expect(log(100), isNot(a));
  });
}
