import 'dart:convert';
import 'dart:io';

import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/domain/board/board_loader.dart';
import 'package:dice_party/games/snakes/domain/board/jump.dart';
import 'package:dice_party/games/snakes/domain/board/validator.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_events.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_intent.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_state.dart';
import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/games/snakes/domain/snakes_module.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

Set<BoardIssueCode> codes(BoardDef b) =>
    BoardValidator.validate(b).map((i) => i.code).toSet();

BoardDef withJump(BoardDef b, String id, Jump Function(Jump) f) => b.copyWith(
  jumps: [for (final j in b.jumps) j.id == id ? f(j) : j],
);

void main() {
  final classic = loadBoard('classic_sunshine');

  group('shipped boards', () {
    for (final id in shippedBoardIds) {
      test('$id loads, validates and has 8 ranked snakes', () {
        final b = loadBoard(id);
        expect(BoardValidator.validate(b), isEmpty);
        expect(b.snakes.map((s) => s.rank), [1, 2, 3, 4, 5, 6, 7, 8]);
        expect(b.ladders.length, inInclusiveRange(8, 9));
      });

      for (final n in [6, 7, 8]) {
        test('$id activeJumps($n) is all ladders plus $n snakes', () {
          final b = loadBoard(id);
          final active = b.activeJumps(n);
          expect(active.where((j) => j.isSnake).length, n);
          expect(active.where((j) => j.isLadder).length, b.ladders.length);
          expect(
            active.where((j) => j.isSnake).every((s) => s.rank! <= n),
            isTrue,
          );
        });
      }
    }

    test('assets copy of each board matches design/boards', () {
      for (final id in shippedBoardIds) {
        final a = jsonDecode(
          File('assets/games/snakes/boards/$id.json').readAsStringSync(),
        );
        final d = jsonDecode(File('design/boards/$id.json').readAsStringSync());
        expect(a, d, reason: id);
      }
    });
  });

  group('validator catches', () {
    test('a square out of range', () {
      expect(
        codes(withJump(classic, 'L1', (j) => j.copyWith(to: 101))),
        contains(BoardIssueCode.outOfRange),
      );
      expect(
        codes(withJump(classic, 'L1', (j) => j.copyWith(from: 0))),
        contains(BoardIssueCode.outOfRange),
      );
    });

    test('a ladder going down', () {
      expect(
        codes(withJump(classic, 'L1', (j) => j.copyWith(from: 20, to: 2))),
        contains(BoardIssueCode.ladderGoesDown),
      );
    });

    test('a snake going up', () {
      expect(
        codes(withJump(classic, 'S1', (j) => j.copyWith(from: 42, to: 92))),
        contains(BoardIssueCode.snakeGoesUp),
      );
    });

    test('a jump starting on 100', () {
      expect(
        codes(withJump(classic, 'S1', (j) => j.copyWith(from: 100))),
        contains(BoardIssueCode.startsOnLast),
      );
    });

    test('a snake head on 1', () {
      final b = withJump(classic, 'S5', (j) => j.copyWith(from: 1, to: 1));
      expect(codes(b), contains(BoardIssueCode.snakeHeadOnFirst));
    });

    test('duplicate starts', () {
      final from = classic.jumps.firstWhere((j) => j.id == 'L2').from;
      expect(
        codes(withJump(classic, 'L1', (j) => j.copyWith(from: from))),
        contains(BoardIssueCode.duplicateStart),
      );
    });

    test('chains', () {
      final head = classic.jumps.firstWhere((j) => j.id == 'S1').from;
      expect(
        codes(withJump(classic, 'L9', (j) => j.copyWith(to: head))),
        contains(BoardIssueCode.chain),
      );
    });

    test('not exactly 8 ranked snakes', () {
      final seven = classic.copyWith(
        jumps: [
          for (final j in classic.jumps)
            if (j.rank != 8) j,
        ],
      );
      expect(codes(seven), contains(BoardIssueCode.snakeRanks));
      final dupRank = withJump(classic, 'S8', (j) => j.copyWith(rank: 7));
      expect(codes(dupRank), contains(BoardIssueCode.snakeRanks));
      final unranked = withJump(classic, 'S8', (j) => j.copyWith(rank: null));
      expect(codes(unranked), contains(BoardIssueCode.snakeRanks));
    });

    test('a missing or malformed path', () {
      expect(
        codes(withJump(classic, 'S2', (j) => j.copyWith(path: null))),
        contains(BoardIssueCode.missingPath),
      );
      expect(
        codes(
          withJump(
            classic,
            'S2',
            (j) => j.copyWith(
              path: const [
                [0.5, 0.5],
              ],
            ),
          ),
        ),
        contains(BoardIssueCode.missingPath),
      );
      expect(
        codes(
          withJump(
            classic,
            'S2',
            (j) => j.copyWith(
              path: const [
                [0.5, 1.5],
                [0.5, 0.5],
              ],
            ),
          ),
        ),
        contains(BoardIssueCode.missingPath),
      );
    });

    test('always-on snakes missing a band', () {
      // Swap ranks so S4 (head 36, the only always-on head below 40)
      // becomes rank 7.
      final b = classic.copyWith(
        jumps: [
          for (final j in classic.jumps)
            if (j.id == 'S4')
              j.copyWith(rank: 7)
            else if (j.id == 'S7')
              j.copyWith(rank: 4)
            else
              j,
        ],
      );
      expect(codes(b), contains(BoardIssueCode.rankBands));
    });

    test('a snake body covering another start', () {
      final s1 = classic.jumps.firstWhere((j) => j.id == 'S1');
      final l1 = classic.jumps.firstWhere((j) => j.id == 'L1');
      // Route S1's body straight through L1's foot.
      final b = withJump(
        classic,
        'S1',
        (j) => j.copyWith(
          path: [
            [0.5, 0.5],
            [0.15, 0.95],
          ],
        ),
      );
      expect(s1.id, 'S1');
      expect(l1.from, 2);
      expect(codes(b), contains(BoardIssueCode.bodyCoversStart));
    });

    test('a wrong size and duplicate ids', () {
      expect(
        codes(classic.copyWith(size: 8)),
        contains(BoardIssueCode.wrongSize),
      );
      expect(
        codes(withJump(classic, 'L2', (j) => j.copyWith(id: 'L1'))),
        contains(BoardIssueCode.duplicateId),
      );
    });

    test('malformed JSON through the loader, without throwing', () {
      expect(BoardLoader.parse('nope').isOk, isFalse);
      expect(BoardLoader.parse('[]').isOk, isFalse);
      expect(BoardLoader.parse('{"id": 3}').isOk, isFalse);
    });
  });

  group('snake count', () {
    final module = SnakesModule([testBoard]);
    SnakesState at62(int count) {
      final s = module.newGame(
        seats(2),
        SnakesConfig(boardId: 'test', snakeCount: count),
      );
      return s.copyWith(positions: {...s.positions, 'p0': 62});
    }

    test('a rank-8 snake never triggers in a 7-snake game', () {
      final r = module.apply(
        at62(7),
        'p0',
        const SnakesRoll(),
        ScriptedDiceService([2]),
      );
      r as Accepted<SnakesState, SnakesEvent>;
      expect(r.state.positionOf('p0'), 64);
      expect(r.events.whereType<JumpTaken>(), isEmpty);
    });

    test('the rank-8 snake triggers in an 8-snake game', () {
      final r = module.apply(
        at62(8),
        'p0',
        const SnakesRoll(),
        ScriptedDiceService([2]),
      );
      r as Accepted<SnakesState, SnakesEvent>;
      expect(r.state.positionOf('p0'), 44);
    });

    test('counts outside 6 to 8 are refused', () {
      for (final n in [5, 9]) {
        expect(
          () => module.newGame(
            seats(2),
            SnakesConfig(boardId: 'test', snakeCount: n),
          ),
          throwsArgumentError,
        );
        expect(
          module.configCodec.decode(
            SnakesConfig(boardId: 'test', snakeCount: n).toJson(),
          ),
          isNull,
        );
      }
    });
  });
}
