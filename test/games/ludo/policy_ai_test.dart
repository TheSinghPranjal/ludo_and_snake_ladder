import 'dart:math';

import 'package:dice_party/games/ludo/domain/ai/ludo_ai.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_events.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_intent.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_state.dart';
import 'package:dice_party/games/ludo/domain/rules/moves.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';
import 'ludo_fixtures.dart';

int? timeoutToken(LudoState s) =>
    (module.timeoutIntent(s) as MoveToken?)?.tokenId;

void main() {
  group('timeout policy order', () {
    test('1. reach HOME beats everything', () {
      // Token 3 reaches home; token 0 could capture; token 1 could leave base.
      final s = ludo(
        tokens: {
          'p0': [0, -1, 20, 50],
          'p1': [45, -1, -1, -1],
        },
        dice: 6,
      );
      expect(timeoutToken(s), 3);
    });

    test('2. capture beats leaving base', () {
      final s = ludo(
        tokens: {
          'p0': [-1, 0, 20, -1],
          'p1': [45, -1, -1, -1],
        },
        dice: 6,
      );
      expect(timeoutToken(s), 1);
    });

    test('3. leave base on a 6 beats a safe landing', () {
      // Token 2 at 2 + 6 = 8, a star.
      final s = ludo(
        tokens: {
          'p0': [-1, 30, 2, -1],
        },
        dice: 6,
      );
      expect(timeoutToken(s), 0, reason: 'lowest index among base tokens');
    });

    test('4. a safe landing beats advancing the furthest', () {
      final s = ludo(
        tokens: {
          'p0': [5, 30, 56, 56],
        },
        dice: 3,
      );
      expect(timeoutToken(s), 0, reason: '5 + 3 = 8 is a star');
    });

    test('5. otherwise advance the furthest token, ties to lowest index', () {
      final s = ludo(
        tokens: {
          'p0': [10, 30, 30, 56],
        },
        dice: 2,
      );
      expect(timeoutToken(s), 1);
    });

    test('before the roll the timeout intent is a roll', () {
      expect(module.timeoutIntent(ludo()), const LudoRoll());
    });
  });

  group('auto intent', () {
    test('0 legal moves: none', () {
      expect(
        module.autoIntent(
          ludo(
            tokens: {
              'p0': [53, 54, 55, 56],
            },
            dice: 4,
          ),
        ),
        isNull,
      );
    });

    test('1 legal move: that move', () {
      final s = ludo(
        tokens: {
          'p0': [10, -1, -1, -1],
        },
        dice: 3,
      );
      expect(module.autoIntent(s), const MoveToken(0));
    });

    test('identical moves count as one', () {
      final s = ludo(dice: 6);
      expect(module.autoIntent(s), const MoveToken(0));
    });

    test('several different moves: none', () {
      final s = ludo(
        tokens: {
          'p0': [10, 20, -1, -1],
        },
        dice: 3,
      );
      expect(module.autoIntent(s), isNull);
    });

    test('never before the roll', () {
      expect(module.autoIntent(ludo()), isNull);
    });
  });

  group('AI', () {
    const ai = LudoAi();
    Move pick(LudoState s) => ai.choose(
      s,
      'p0',
      legalMoves(s, 'p0', s.dice!),
      AiLevel.normal,
      Random(1),
    );

    test('prefers a capture over reaching home', () {
      // Blue rel 42 is absolute 3, where Red token 1 lands.
      final s = ludo(
        tokens: {
          'p0': [53, 0, -1, -1],
          'p1': [42, -1, -1, -1],
        },
        dice: 3,
      );
      expect(pick(s).tokenId, 1);
    });

    test('prefers reaching home over leaving base', () {
      final s = ludo(
        tokens: {
          'p0': [50, -1, -1, -1],
        },
        dice: 6,
      );
      expect(pick(s).tokenId, 0);
    });

    test('leaves base when few tokens are out', () {
      final s = ludo(
        tokens: {
          'p0': [20, -1, -1, -1],
        },
        dice: 6,
      );
      expect(pick(s).tokenId, 1);
    });

    test('avoids a risky square when a safe option exists', () {
      // Green rel 20 is absolute 7. Token 0 to 12 sits 5 ahead of it;
      // token 1 to 8 lands on a star.
      final s = ludo(
        tokens: {
          'p0': [10, 6, -1, -1],
          'p3': [20, -1, -1, -1],
        },
        dice: 2,
      );
      expect(LudoAi.threatened(s, 'p0', 12, null), isTrue);
      expect(pick(s).tokenId, 1);
    });

    test('easy picks among the top 3, always legally', () {
      final s = ludo(
        tokens: {
          'p0': [10, 20, 30, 40],
        },
        dice: 3,
      );
      final picks = {
        for (var seed = 0; seed < 50; seed++)
          ai
              .choose(
                s,
                'p0',
                legalMoves(s, 'p0', 3),
                AiLevel.easy,
                Random(seed),
              )
              .tokenId,
      };
      expect(picks.length, inInclusiveRange(2, 3));
    });

    test('AI games use only legal intents and always finish', () {
      for (var seed = 0; seed < 30; seed++) {
        final rng = Random(seed);
        final dice = SeededDiceService(seed);
        var s = module.newGame(
          seats(4, kind: PlayerKind.ai, aiLevel: AiLevel.values[seed % 2]),
          module.defaultConfig,
        );
        var steps = 0;
        while (!s.isOver) {
          final p = s.currentPlayer!;
          final level = s.player(p)!.aiLevel!;
          final intent = module.chooseAi(s, p, level, rng);
          expect(module.legalIntents(s, p), contains(intent));
          final r = module.apply(s, p, intent, dice);
          expect(r, isA<Accepted<LudoState, LudoEvent>>());
          s = (r as Accepted<LudoState, LudoEvent>).state;
          expect(++steps, lessThan(20000));
        }
        expect(finalRanking(s).toSet().length, 4);
        expect(s.ranking.length, 3);
      }
    });

    test('think time is 600–900 ms, halved in Fast', () {
      final rng = Random(3);
      for (var i = 0; i < 100; i++) {
        final d = module.aiThinkDelay(AiLevel.normal, rng, fast: false);
        expect(d.inMilliseconds, inInclusiveRange(600, 900));
        final f = module.aiThinkDelay(AiLevel.easy, rng, fast: true);
        expect(f.inMilliseconds, inInclusiveRange(300, 450));
      }
    });
  });
}
