import 'dart:convert';

import 'package:dice_party/games/snakes/domain/board/jump.dart';
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

final module = SnakesModule([testBoard]);

SnakesState game({
  int players = 2,
  SnakesRules rules = const SnakesRules(),
  int snakeCount = 8,
  Map<String, int> at = const {},
}) {
  final s = module.newGame(
    seats(players),
    SnakesConfig(boardId: 'test', snakeCount: snakeCount, rules: rules),
  );
  return s.copyWith(
    positions: {...s.positions, ...at},
    turnStartPosition: at[s.currentPlayer] ?? 0,
  );
}

Accepted<SnakesState, SnakesEvent> roll(
  SnakesState s,
  int face, {
  String? by,
}) {
  final r = module.apply(
    s,
    by ?? s.currentPlayer!,
    const SnakesRoll(),
    ScriptedDiceService([face]),
  );
  expect(r, isA<Accepted<SnakesState, SnakesEvent>>());
  return r as Accepted<SnakesState, SnakesEvent>;
}

void main() {
  group('movement', () {
    test('basic move hops square by square and passes the turn', () {
      final r = roll(game(), 4);
      expect(r.state.positionOf('p0'), 4);
      expect(r.events.whereType<TokenStepped>().single.path, [1, 2, 3, 4]);
      expect(r.state.currentPlayer, 'p1');
      expect(r.signal, TurnSignal.nextTurn);
      expect(r.state.turnSeq, 1);
    });

    test('landing on a ladder foot climbs', () {
      final r = roll(game(), 3);
      expect(r.state.positionOf('p0'), 22);
      final jump = r.events.whereType<JumpTaken>().single;
      expect((jump.type, jump.from, jump.to), (JumpType.ladder, 3, 22));
      expect(r.state.player('p0')!.stats[SnakesStats.laddersClimbed], 1);
      expect(r.state.player('p0')!.stats[SnakesStats.longestClimb], 19);
    });

    test('landing on a snake head slides', () {
      final r = roll(game(at: {'p0': 26}), 4);
      expect(r.state.positionOf('p0'), 7);
      expect(r.events.whereType<JumpTaken>().single.type, JumpType.snake);
      expect(r.state.player('p0')!.stats[SnakesStats.worstSlide], 23);
    });

    test('exactly 100 wins', () {
      final r = roll(game(at: {'p0': 96}), 4);
      expect(r.state.positionOf('p0'), 100);
      expect(r.state.isOver, isTrue);
      expect(r.state.currentPlayer, isNull);
      expect(r.state.ranking, ['p0']);
      expect(r.events.last, isA<GameOver>());
      expect(r.signal, TurnSignal.gameOver);
    });
  });

  group('overshoot', () {
    test('stay put: the token does not move and needs the exact roll', () {
      final r = roll(game(at: {'p0': 97}), 5);
      expect(r.state.positionOf('p0'), 97);
      final blocked = r.events.whereType<MoveBlocked>().single;
      expect((blocked.reason, blocked.need), (BlockReason.overshoot, 3));
      expect(r.state.currentPlayer, 'p1');
    });

    test('bounce back walks to 100 and back by the excess', () {
      final s = game(
        rules: const SnakesRules(overshoot: Overshoot.bounce),
        at: {'p0': 99},
      );
      final r = roll(s, 4);
      expect(r.events.whereType<TokenStepped>().single.path, [100]);
      expect(r.events.whereType<Bounced>().single.path, [99, 98, 97]);
      expect(r.state.positionOf('p0'), 97);
    });

    test('bouncing onto a snake head slides', () {
      final s = game(
        rules: const SnakesRules(overshoot: Overshoot.bounce),
        at: {'p0': 96},
      );
      final r = roll(s, 6);
      expect(r.events.whereType<Bounced>().single.path, [99, 98]);
      expect(r.events.whereType<JumpTaken>().single.from, 98);
      expect(r.state.positionOf('p0'), 78);
      expect(r.signal, TurnSignal.extraRoll, reason: 'a 6 still re-rolls');
    });
  });

  group('need a 6 to start', () {
    const rules = SnakesRules(needSixToStart: true);

    test('on: a non-6 at the start is blocked', () {
      final r = roll(game(rules: rules), 5);
      expect(r.state.positionOf('p0'), 0);
      expect(
        r.events.whereType<MoveBlocked>().single.reason,
        BlockReason.needSix,
      );
      expect(r.state.currentPlayer, 'p1');
    });

    test('on: a 6 places the token on square 1 and re-rolls', () {
      final r = roll(game(rules: rules), 6);
      expect(r.state.positionOf('p0'), 1);
      expect(r.signal, TurnSignal.extraRoll);
    });

    test('off: any roll moves from the start', () {
      expect(roll(game(), 5).state.positionOf('p0'), 5);
    });
  });

  group('sixes', () {
    test('a 6 gives another roll to the same player', () {
      final r = roll(game(), 6);
      expect(r.signal, TurnSignal.extraRoll);
      expect(r.state.currentPlayer, 'p0');
      expect(r.state.consecutiveSixes, 1);
      expect(r.events.last, isA<ExtraRoll>());
    });

    test('with extra roll off, a 6 passes the turn', () {
      final r = roll(game(rules: const SnakesRules(extraRollOnSix: false)), 6);
      expect(r.state.currentPlayer, 'p1');
    });

    test('three 6s return the token to where the turn started', () {
      var s = game(at: {'p0': 44});
      s = roll(s, 6).state;
      expect(s.positionOf('p0'), 70, reason: '50 is a ladder to 70');
      s = roll(s, 6).state;
      expect(s.positionOf('p0'), 76);
      final r = roll(s, 6);
      expect(r.state.positionOf('p0'), 44);
      final p = r.events.whereType<ThreeSixesPenalty>().single;
      expect((p.from, p.to), (76, 44));
      expect(r.state.currentPlayer, 'p1');
      expect(r.state.consecutiveSixes, 0);
    });

    test('with the penalty off, a third 6 moves normally', () {
      var s = game(rules: const SnakesRules(threeSixesPenalty: false));
      s = roll(roll(s, 6).state, 6).state;
      final r = roll(s, 6);
      expect(r.state.positionOf('p0'), 18);
      expect(r.signal, TurnSignal.extraRoll);
    });

    test('a non-6 resets the six count', () {
      var s = roll(game(), 6).state;
      s = roll(s, 2).state;
      expect(s.consecutiveSixes, 0);
    });
  });

  group('capture', () {
    test('on: landing on an opponent sends them to 0', () {
      final s = game(
        rules: const SnakesRules(capture: true),
        at: {'p0': 6, 'p1': 10},
      );
      final r = roll(s, 4);
      expect(r.state.positionOf('p1'), 0);
      expect(r.events.whereType<Captured>().single.victims, ['p1']);
      expect(r.state.player('p0')!.stats[SnakesStats.captures], 1);
    });

    test('off: tokens share squares', () {
      final r = roll(game(at: {'p0': 6, 'p1': 10}), 4);
      expect(r.state.positionOf('p1'), 10);
      expect(r.events.whereType<Captured>(), isEmpty);
    });
  });

  group('finishing', () {
    const full = SnakesRules(playTo: PlayTo.fullRanking);

    test('finished players are skipped in turn order', () {
      var s = game(players: 3, rules: full, at: {'p0': 96});
      s = roll(s, 4).state;
      expect(s.isOver, isFalse);
      expect(s.player('p0')!.finishedRank, 1);
      expect(s.currentPlayer, 'p1');
      s = roll(s, 1).state;
      expect(s.currentPlayer, 'p2');
      s = roll(s, 1).state;
      expect(s.currentPlayer, 'p1', reason: 'p0 has finished');
    });

    test('full ranking plays on until one player is left', () {
      var s = game(players: 3, rules: full, at: {'p0': 96, 'p1': 97});
      s = roll(s, 4).state;
      final r = roll(s, 3);
      expect(r.state.isOver, isTrue);
      expect(r.state.ranking, ['p0', 'p1']);
      expect(finalRanking(r.state), ['p0', 'p1', 'p2']);
      expect(r.events.whereType<GameOver>().single.ranking, ['p0', 'p1', 'p2']);
    });

    test('first winner ends the game at once', () {
      final r = roll(game(players: 3, at: {'p0': 96}), 4);
      expect(r.state.isOver, isTrue);
      expect(finalRanking(r.state), ['p0', 'p1', 'p2']);
    });
  });

  group('rejections never change state or draw dice', () {
    test('wrong player, unknown player and game over', () {
      final s = game();
      final dice = ScriptedDiceService([4]);
      for (final (by, code) in [
        ('p1', RejectionCode.notYourTurn),
        ('p9', RejectionCode.unknownPlayer),
      ]) {
        final r = module.apply(s, by, const SnakesRoll(), dice);
        expect(r, isA<Rejected<SnakesState, SnakesEvent>>());
        r as Rejected<SnakesState, SnakesEvent>;
        expect(r.code, code);
        expect(identical(r.state, s), isTrue);
      }
      expect(dice.remaining, 1);

      final over = roll(game(at: {'p0': 96}), 4).state;
      final r = module.apply(over, 'p1', const SnakesRoll(), dice);
      expect((r as Rejected).code, RejectionCode.gameOver);
      expect(dice.remaining, 1);
    });
  });

  group('removal', () {
    test('removing the current player passes the turn', () {
      final s = game(players: 3);
      final r = module.removePlayer(s, 'p0');
      r as Accepted<SnakesState, SnakesEvent>;
      expect(r.state.currentPlayer, 'p1');
      expect(r.state.leavers, ['p0']);
      expect(r.state.turnSeq, s.turnSeq + 1);
      expect(module.legalIntents(r.state, 'p0'), isEmpty);
    });

    test('removing down to one player ends the game; leavers rank last', () {
      var s = game(players: 3);
      s = (module.removePlayer(s, 'p1') as Accepted<SnakesState, SnakesEvent>)
          .state;
      expect(s.turnSeq, 0, reason: 'current player unchanged');
      final r = module.removePlayer(s, 'p2');
      r as Accepted<SnakesState, SnakesEvent>;
      expect(r.state.isOver, isTrue);
      expect(finalRanking(r.state), ['p0', 'p2', 'p1']);
    });
  });

  group('serialisation', () {
    test('snake count and rules survive save and resume', () {
      var s = game(
        snakeCount: 6,
        rules: const SnakesRules(capture: true, overshoot: Overshoot.bounce),
      );
      s = roll(s, 5).state;
      final saved = jsonEncode(module.stateToPublicJson(s));
      final restored = module.stateFromJson(
        jsonDecode(saved) as Map<String, dynamic>,
      );
      expect(restored, s);
      expect(restored!.snakeCount, 6);
    });

    test('snake count is part of the broadcast state', () {
      final json = module.stateToPublicJson(game(snakeCount: 7));
      expect(json['snakeCount'], 7);
    });

    test('corrupt state JSON is rejected without throwing', () {
      expect(module.stateFromJson({'boardId': 3}), isNull);
      final json = module.stateToPublicJson(game())..['snakeCount'] = 9;
      expect(module.stateFromJson(json), isNull);
    });

    test('intent codec is strict', () {
      final codec = module.intentCodec;
      expect(
        codec.decode(codec.encode(const SnakesRoll())),
        const SnakesRoll(),
      );
      for (final bad in <Object?>[
        null,
        'roll',
        <String, Object>{},
        {'kind': 'move', 'tokenId': 1},
        {'kind': 'roll', 'value': 6},
        {'kind': 'roll', 'position': 100},
        {'kind': 'roll', 'playerId': 'p1'},
      ]) {
        expect(codec.decode(bad), isNull, reason: '$bad');
      }
    });

    test('every event round-trips through JSON', () {
      var s = game(
        players: 3,
        rules: const SnakesRules(
          capture: true,
          overshoot: Overshoot.bounce,
          playTo: PlayTo.fullRanking,
          needSixToStart: true,
        ),
        at: {'p0': 0, 'p1': 99, 'p2': 22},
      );
      final events = <SnakesEvent>[];
      // p0: needs a six (blocked), p1: bounces, p2: …
      for (final f in [5, 4, 3, 6, 6, 6]) {
        final r = roll(s, f);
        events.addAll(r.events);
        s = r.state;
      }
      events.addAll(
        (module.removePlayer(s, 'p1') as Accepted<SnakesState, SnakesEvent>)
            .events,
      );
      final kinds = events.map((e) => e.toJson()['kind']).toSet();
      expect(
        kinds,
        containsAll(<String>[
          'diceRolled',
          'moveBlocked',
          'tokenStepped',
          'bounced',
          'turnPassed',
          'playerRemoved',
        ]),
      );
      for (final e in events) {
        final back = module.eventCodec.decode(
          jsonDecode(jsonEncode(module.eventCodec.encode(e)))
              as Map<String, dynamic>,
        );
        expect(back, e);
      }
      expect(module.eventCodec.decode({'kind': 'teleport'}), isNull);
    });
  });
}
