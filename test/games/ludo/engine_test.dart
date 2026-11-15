import 'dart:convert';

import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_engine.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_events.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_intent.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_state.dart';
import 'package:dice_party/games/ludo/domain/rules/moves.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';
import 'ludo_fixtures.dart';

void main() {
  group('setup', () {
    test('players sit in clockwise colour order, tokens in base', () {
      final s = module.newGame(
        seats(
          3,
          colors: const [
            PlayerColor.yellow,
            PlayerColor.red,
            PlayerColor.blue,
          ],
        ),
        module.defaultConfig,
      );
      expect(s.players.map((p) => p.color), [
        PlayerColor.red,
        PlayerColor.blue,
        PlayerColor.yellow,
      ]);
      expect(s.currentPlayer, 'p1', reason: 'Red moves first');
      expect(
        s.tokens.values.expand((t) => t).every((r) => r == baseRel),
        isTrue,
      );
    });

    test('default colours: 2 players opposite, 3 players R/B/Y', () {
      expect(defaultColors(2), [PlayerColor.red, PlayerColor.yellow]);
      expect(defaultColors(3), [
        PlayerColor.red,
        PlayerColor.blue,
        PlayerColor.yellow,
      ]);
    });

    test('duplicate colours are refused', () {
      expect(
        () => module.newGame(
          seats(2, colors: const [PlayerColor.red, PlayerColor.red]),
          module.defaultConfig,
        ),
        throwsArgumentError,
      );
    });
  });

  group('movement', () {
    test('a token leaves base only on a 6, onto its start cell', () {
      for (var f = 1; f <= 5; f++) {
        final r = accept(ludo(), const LudoRoll(), dice: [f]);
        expect(
          r.events.whereType<TurnPassed>().single.reason,
          PassReason.noMoves,
        );
        expect(r.state.currentPlayer, 'p1');
      }
      final r = rollMove(ludo(), 6, 0);
      expect(r.state.tokensOf('p0')[0], 0);
      final moved = r.events.whereType<TokenMoved>().single;
      expect(moved.path, [
        [13, 6],
      ]);
    });

    test('every face advances exactly that many steps', () {
      for (var f = 1; f <= 6; f++) {
        final s = ludo(
          tokens: {
            'p0': [10, -1, -1, -1],
          },
        );
        final r = rollMove(s, f, 0);
        expect(r.state.tokensOf('p0')[0], 10 + f);
        expect(r.events.whereType<TokenMoved>().single.path.length, f);
      }
    });

    test('Blue wraps across track cell 51 → 0', () {
      // Blue rel 37 is absolute 50.
      final s = ludo(
        tokens: {
          'p1': [37, -1, -1, -1],
        },
        current: 'p1',
      );
      final r = rollMove(s, 3, 0);
      expect(r.state.tokensOf('p1')[0], 40);
      expect(r.events.whereType<TokenMoved>().single.path, [
        [14, 6],
        [13, 6],
        [12, 6],
      ]);
    });

    test('a token enters its home column after rel 50', () {
      final r = rollMove(
        ludo(
          tokens: {
            'p0': [48, -1, -1, -1],
          },
        ),
        5,
        0,
      );
      expect(r.state.tokensOf('p0')[0], 53);
      expect(r.events.whereType<TokenMoved>().single.path, [
        [14, 8],
        [14, 7],
        [13, 7],
        [12, 7],
        [11, 7],
      ]);
    });

    test('an exact roll reaches HOME', () {
      final r = rollMove(
        ludo(
          tokens: {
            'p0': [50, -1, -1, -1],
          },
        ),
        6,
        0,
      );
      expect(r.state.tokensOf('p0')[0], homeRel);
      expect(r.events.whereType<TokenHome>(), hasLength(1));
    });

    test('overshooting HOME is illegal and leaves state unchanged', () {
      final s = ludo(
        tokens: {
          'p0': [53, 20, -1, -1],
        },
        dice: 4,
      );
      expect(reject(s, const MoveToken(0)), RejectionCode.illegalMove);
      expect(legalMoves(s, 'p0', 4).map((m) => m.tokenId), [1]);
    });

    test('1–5 with all tokens in base passes the turn', () {
      final r = accept(ludo(), const LudoRoll(), dice: [3]);
      expect(r.signal, TurnSignal.nextTurn);
      expect(r.state.phase, LudoPhase.awaitingRoll);
    });

    test('no legal move passes the turn even on a 6', () {
      final s = ludo(
        tokens: {
          'p0': [53, 54, 55, 56],
        },
      );
      final r = accept(s, const LudoRoll(), dice: [6]);
      expect(r.state.currentPlayer, 'p1');
    });
  });

  group('extra rolls', () {
    test('a 6 gives one extra roll', () {
      final r = rollMove(
        ludo(
          tokens: {
            'p0': [10, -1, -1, -1],
          },
        ),
        6,
        0,
      );
      expect(
        r.events.whereType<ExtraRoll>().single.reason,
        ExtraRollReason.six,
      );
      expect(r.state.currentPlayer, 'p0');
      expect(r.state.phase, LudoPhase.awaitingRoll);
      expect(r.signal, TurnSignal.extraRoll);
    });

    test('a capture gives one extra roll', () {
      // Blue rel 41 is absolute 2; Red moves 0 → 2.
      final s = ludo(
        tokens: {
          'p0': [0, -1, -1, -1],
          'p1': [41, -1, -1, -1],
        },
      );
      final r = rollMove(s, 2, 0);
      expect(
        r.events.whereType<ExtraRoll>().single.reason,
        ExtraRollReason.capture,
      );
    });

    test('reaching HOME gives one extra roll', () {
      final r = rollMove(
        ludo(
          tokens: {
            'p0': [53, -1, -1, -1],
          },
        ),
        3,
        0,
      );
      expect(
        r.events.whereType<ExtraRoll>().single.reason,
        ExtraRollReason.home,
      );
    });

    test('a 6 that also captures gives only one extra roll', () {
      final s = ludo(
        tokens: {
          'p0': [0, -1, -1, -1],
          'p1': [45, -1, -1, -1],
        },
      );
      final r = rollMove(s, 6, 0);
      expect(r.events.whereType<TokenCaptured>(), hasLength(1));
      expect(r.events.whereType<ExtraRoll>(), hasLength(1));
      final again = accept(r.state, const LudoRoll(), dice: [2]);
      expect(again.state.phase, LudoPhase.awaitingMove);
      final done = accept(again.state, const MoveToken(0));
      expect(
        done.state.currentPlayer,
        'p1',
        reason:
            'extra rolls do not '
            'stack',
      );
    });

    test('the third consecutive 6 is forfeited and the turn ends', () {
      var s = ludo(
        tokens: {
          'p0': [10, -1, -1, -1],
        },
      );
      s = rollMove(s, 6, 0).state;
      s = rollMove(s, 6, 0).state;
      expect(s.tokensOf('p0')[0], 22);
      final r = accept(s, const LudoRoll(), dice: [6]);
      expect(r.events.whereType<ThreeSixesForfeit>(), hasLength(1));
      expect(r.state.tokensOf('p0')[0], 22, reason: 'earlier moves stand');
      expect(r.state.currentPlayer, 'p1');
    });

    test('a non-6 resets the six count', () {
      var s = ludo(
        tokens: {
          'p0': [10, -1, -1, -1],
          'p1': [30, -1, -1, -1],
        },
      );
      s = rollMove(s, 6, 0).state;
      expect(s.sixesThisTurn, 1);
      // Capture with a 3 (Blue rel 30 is absolute 43; Red 16 + 3 = 19 no).
      s = s.copyWith(
        tokens: {
          ...s.tokens,
          'p1': [3, -1, -1, -1],
        },
      );
      // Blue rel 3 is absolute 16; Red 16 → 19 does not capture.
      final r = rollMove(s, 3, 0);
      expect(r.state.sixesThisTurn, 0);
    });
  });

  group('validation', () {
    test('the wrong player cannot roll or move', () {
      expect(
        reject(ludo(), const LudoRoll(), by: 'p1'),
        RejectionCode.notYourTurn,
      );
      final s = ludo(
        tokens: {
          'p0': [10, -1, -1, -1],
        },
        dice: 3,
      );
      expect(
        reject(s, const MoveToken(0), by: 'p1'),
        RejectionCode.notYourTurn,
      );
      expect(
        reject(s, const LudoRoll(), by: 'p9'),
        RejectionCode.unknownPlayer,
      );
    });

    test('rolling twice or moving before rolling is illegal', () {
      final s = ludo(
        tokens: {
          'p0': [10, -1, -1, -1],
        },
      );
      expect(reject(s, const MoveToken(0)), RejectionCode.illegalMove);
      final waiting = s.copyWith(phase: LudoPhase.awaitingMove, dice: 2);
      final dice = ScriptedDiceService([4]);
      expect(
        reject(waiting, const LudoRoll(), dice: dice),
        RejectionCode.illegalMove,
      );
      expect(dice.remaining, 1, reason: 'rejections draw no dice');
    });

    test('a token that cannot move or does not exist is rejected', () {
      final s = ludo(
        tokens: {
          'p0': [10, -1, -1, -1],
        },
        dice: 3,
      );
      expect(reject(s, const MoveToken(1)), RejectionCode.illegalMove);
      expect(reject(s, const MoveToken(7)), RejectionCode.illegalMove);
    });

    test('fabricated dice values and positions are rejected by the codec', () {
      final codec = module.intentCodec;
      expect(codec.decode({'kind': 'roll'}), const LudoRoll());
      expect(codec.decode({'kind': 'move', 'tokenId': 2}), const MoveToken(2));
      for (final bad in <Object?>[
        {'kind': 'roll', 'value': 6},
        {'kind': 'roll', 'dice': 6},
        {'kind': 'move', 'tokenId': 2, 'toRel': 56},
        {'kind': 'move', 'tokenId': 2, 'value': 6},
        {'kind': 'move', 'tokenId': 4},
        {'kind': 'move', 'tokenId': '2'},
        {'kind': 'move'},
        {'kind': 'teleport'},
        'roll',
        null,
      ]) {
        expect(codec.decode(bad), isNull, reason: '$bad');
      }
    });

    test('commands after game over are rejected', () {
      final s = ludo(
        players: 2,
        tokens: {
          'p0': [56, 56, 56, 53],
        },
      );
      final over = rollMove(s, 3, 3).state;
      expect(over.isOver, isTrue);
      expect(reject(over, const LudoRoll(), by: 'p1'), RejectionCode.gameOver);
      expect(
        reject(over, const MoveToken(0), by: 'p0'),
        RejectionCode.gameOver,
      );
    });
  });

  group('capture', () {
    test('landing on an unsafe cell captures the opponent', () {
      final s = ludo(
        tokens: {
          'p0': [0, -1, -1, -1],
          'p1': [41, -1, -1, -1],
        },
      );
      final r = rollMove(s, 2, 0);
      expect(r.state.tokensOf('p1')[0], baseRel);
      final c = r.events.whereType<TokenCaptured>().single;
      expect((c.playerId, c.tokenId, c.fromRel), ('p1', 0, 41));
      expect(r.state.player('p0')!.stats[LudoStats.captures], 1);
      expect(r.state.player('p1')!.stats[LudoStats.timesCaptured], 1);
    });

    test('a stacked opponent pair is captured together', () {
      final s = ludo(
        tokens: {
          'p0': [0, -1, -1, -1],
          'p1': [41, 41, -1, -1],
        },
      );
      final r = rollMove(s, 2, 0);
      expect(r.events.whereType<TokenCaptured>(), hasLength(2));
      expect(r.state.tokensOf('p1'), [-1, -1, -1, -1]);
    });

    test('nothing is captured on any of the 8 safe cells', () {
      for (final safe in safeIndices) {
        // Put a Green token on the safe cell and land Red there.
        final greenRel = (safe - startIndex[PlayerColor.green]!) % 52;
        final redRel = safe; // Red's rel equals the absolute index.
        if (redRel == 0 || greenRel > lastTrackRel) continue;
        final from = redRel - 1;
        final s = ludo(
          tokens: {
            'p0': [from, -1, -1, -1],
            'p3': [greenRel, -1, -1, -1],
          },
        );
        final r = rollMove(s, 1, 0);
        expect(r.events.whereType<TokenCaptured>(), isEmpty, reason: '$safe');
        expect(r.state.tokensOf('p3')[0], greenRel);
      }
      // Red's own start (0) is checked by leaving base onto a Blue token.
      final s = ludo(
        tokens: {
          'p1': [39, -1, -1, -1],
        },
      );
      final r = rollMove(s, 6, 0);
      expect(r.events.whereType<TokenCaptured>(), isEmpty);
    });

    test('same-colour tokens stack and never capture each other', () {
      final s = ludo(
        tokens: {
          'p0': [10, 12, -1, -1],
        },
      );
      final r = rollMove(s, 2, 0);
      expect(r.state.tokensOf('p0'), [12, 12, -1, -1]);
      expect(r.events.whereType<TokenCaptured>(), isEmpty);
    });

    test('home columns and HOME never take part in captures', () {
      // Red in its home column and Blue on the track never share a cell,
      // and tokens in a home column are never capture targets.
      final s = ludo(
        tokens: {
          'p0': [52, -1, -1, -1],
          'p1': [53, 56, -1, -1],
        },
      );
      for (var i = 0; i < trackLength; i++) {
        expect(
          capturesAt(s, 'p2', i).where((c) => c.playerId != 'p2'),
          isEmpty,
        );
      }
      final r = rollMove(s, 2, 0);
      expect(r.events.whereType<TokenCaptured>(), isEmpty);
    });
  });

  group('winning', () {
    test('4 tokens home finishes the player and play continues', () {
      final s = ludo(
        tokens: {
          'p0': [56, 56, 56, 55],
        },
      );
      final r = rollMove(s, 1, 3);
      expect(r.events.whereType<PlayerFinished>().single.rank, 1);
      expect(
        r.events.whereType<ExtraRoll>(),
        isEmpty,
        reason: 'a finisher does not use an extra roll',
      );
      expect(r.state.isOver, isFalse);
      expect(r.state.currentPlayer, 'p1');
      expect(module.legalIntents(r.state, 'p0'), isEmpty);
    });

    test('ranks 1–4 are correct and the last player is ranked last', () {
      var s = ludo(
        tokens: {
          'p0': [56, 56, 56, 55],
          'p1': [56, 56, 56, 55],
          'p2': [56, 56, 56, 55],
        },
      );
      s = rollMove(s, 1, 3).state; // Red 1st
      s = rollMove(s, 1, 3).state; // Blue 2nd
      final r = rollMove(s, 1, 3); // Yellow 3rd, Green is left
      expect(r.state.isOver, isTrue);
      expect(r.state.ranking, ['p0', 'p1', 'p2']);
      expect(finalRanking(r.state), ['p0', 'p1', 'p2', 'p3']);
    });

    test('leavers rank below finishers; later leavers rank higher', () {
      var s = ludo(
        tokens: {
          'p0': [56, 56, 56, 55],
        },
      );
      s = rollMove(s, 1, 3).state; // Red finishes, Blue to play
      s = (module.removePlayer(s, 'p2') as Accepted).state as LudoState;
      expect(s.currentPlayer, 'p1');
      final r = module.removePlayer(s, 'p1');
      r as Accepted<LudoState, LudoEvent>;
      expect(r.state.isOver, isTrue);
      expect(finalRanking(r.state), ['p0', 'p3', 'p1', 'p2']);
    });

    test("a removed player's tokens leave the board and are skipped", () {
      final s = ludo(
        tokens: {
          'p1': [20, 30, -1, -1],
        },
      );
      final r = module.removePlayer(s, 'p1') as Accepted<LudoState, LudoEvent>;
      expect(r.state.tokensOf('p1'), [-1, -1, -1, -1]);
      final next = accept(r.state, const LudoRoll(), dice: [2]);
      expect(next.state.currentPlayer, 'p2', reason: 'Blue is skipped');
    });
  });

  test('state, events and config round-trip through JSON', () {
    var s = ludo(
      tokens: {
        'p0': [0, -1, -1, -1],
        'p1': [41, -1, -1, -1],
      },
    );
    final r = rollMove(s, 2, 0);
    s = r.state;
    expect(module.stateFromJson(module.stateToPublicJson(s)), s);
    for (final e in r.events) {
      expect(module.eventCodec.decode(module.eventCodec.encode(e)), e);
    }
    expect(
      module.configCodec.decode(
        module.configCodec.encode(module.defaultConfig),
      ),
      module.defaultConfig,
    );
    final bad =
        jsonDecode(jsonEncode(module.stateToPublicJson(s)))
            as Map<String, dynamic>;
    (bad['tokens'] as Map<String, dynamic>)['p0'] = [0, 0, 0, 99];
    expect(module.stateFromJson(bad), isNull);
    expect(module.stateFromJson({'nope': 1}), isNull);
  });
}
