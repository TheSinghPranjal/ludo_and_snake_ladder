// Separate start and submit calls read as the steps of each scenario.
// ignore_for_file: cascade_invocations

import 'dart:math';

import 'package:dice_party/games/ludo/domain/engine/ludo_events.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_intent.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_state.dart';
import 'package:dice_party/games/ludo/domain/ludo_module.dart';
import 'package:dice_party/games/ludo/domain/rules/ludo_config.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_events.dart'
    as snl;
import 'package:dice_party/games/snakes/domain/engine/snakes_intent.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_state.dart';
import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/games/snakes/domain/snakes_module.dart';
import 'package:dice_party/platform/animation/animation_gate.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/authority_session.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fixtures.dart';

typedef LudoSession =
    AuthoritySession<LudoState, LudoIntent, LudoEvent, LudoConfig>;

const ludo = LudoModule();

/// A gate whose dice land after [diceDelay] and drain after [drainDelay].
class SlowGate implements AnimationGate {
  SlowGate({required this.diceDelay, required this.drainDelay});

  final Duration diceDelay;
  final Duration drainDelay;

  @override
  PresentationHandle present(List<Object?> events) => PresentationHandle(
    diceLanded: Future<void>.delayed(diceDelay),
    drained: Future<void>.delayed(drainDelay),
  );
}

LudoState ludoState(Map<String, List<int>> tokens, {int players = 2}) {
  final s = ludo.newGame(
    seats(players, colors: const [PlayerColor.red, PlayerColor.yellow]),
    const LudoConfig(),
  );
  return s.copyWith(tokens: {...s.tokens, ...tokens});
}

LudoSession session(
  LudoState initial,
  List<int> faces, {
  bool timer = true,
  AnimationGate gate = const ImmediateGate(),
}) => AuthoritySession(
  module: ludo,
  initial: initial,
  dice: ScriptedDiceService(faces),
  timerEnabled: timer,
  gate: gate,
  aiRandom: Random(1),
);

void main() {
  group('turn timer', () {
    test('starts at 30 s for a human decision point', () {
      fakeAsync((fa) {
        final s = session(ludoState({}), [])..start();
        fa.flushMicrotasks();
        expect(s.timer.running, isTrue);
        expect(s.timer.remaining, const Duration(seconds: 30));
        fa.elapse(const Duration(seconds: 10));
        expect(s.timer.remaining, const Duration(seconds: 20));
        s.dispose();
      });
    });

    test(
      'keeps running into the move decision and resets on an extra roll',
      () {
        fakeAsync((fa) {
          final s = session(
            ludoState({
              'p0': [10, 20, -1, -1],
            }),
            [6, 2],
          )..start();
          fa
            ..flushMicrotasks()
            ..elapse(const Duration(seconds: 10));
          s.submitAs('p0', const LudoRoll());
          fa.flushMicrotasks();
          expect(s.state.phase, LudoPhase.awaitingMove);
          expect(s.timer.remaining, const Duration(seconds: 20));
          expect(s.timer.turnSeq, s.state.turnSeq);
          fa.elapse(const Duration(seconds: 5));
          s.submitAs('p0', const MoveToken(0));
          fa.flushMicrotasks();
          expect(s.state.currentPlayer, 'p0', reason: 'extra roll on 6');
          expect(s.timer.remaining, const Duration(seconds: 30));
          s.dispose();
        });
      },
    );

    test('expiry before the roll auto-rolls', () {
      fakeAsync((fa) {
        final s = session(ludoState({}), [3])..start();
        final events = <LudoEvent>[];
        s.updates.listen((u) => events.addAll(u.events));
        fa.elapse(const Duration(seconds: 29, milliseconds: 999));
        expect(events, isEmpty);
        fa.elapse(const Duration(milliseconds: 1));
        expect(events.first, isA<DiceRolled>());
        expect(s.state.currentPlayer, 'p1', reason: 'no moves, passed');
        s.dispose();
      });
    });

    test('expiry with several moves applies the timeout policy after the '
        'dice lands', () {
      fakeAsync((fa) {
        final s = session(
          ludoState({
            'p0': [5, 20, -1, -1],
          }),
          [3],
          gate: SlowGate(
            diceDelay: const Duration(milliseconds: 800),
            drainDelay: const Duration(milliseconds: 800),
          ),
        )..start();
        fa.elapse(const Duration(seconds: 30));
        expect(s.state.phase, LudoPhase.awaitingMove);
        fa.elapse(const Duration(milliseconds: 799));
        expect(s.state.phase, LudoPhase.awaitingMove);
        fa.elapse(const Duration(milliseconds: 1));
        expect(s.state.tokensOf('p0'), [8, 20, -1, -1], reason: 'safe star');
        s.dispose();
      });
    });

    test('never acts after the turn moved on', () {
      fakeAsync((fa) {
        final s = session(ludoState({}), [2, 2])..start();
        fa.elapse(const Duration(seconds: 20));
        s.submitAs('p0', const LudoRoll());
        expect(s.state.currentPlayer, 'p1');
        fa.elapse(const Duration(seconds: 10));
        expect(
          s.state.currentPlayer,
          'p1',
          reason: "p0's old timer did not fire for p1",
        );
        expect(s.timer.remaining, const Duration(seconds: 20));
        s.dispose();
      });
    });

    test('never acts after game over', () {
      fakeAsync((fa) {
        final s = session(
          ludoState({
            'p0': [56, 56, 56, 53],
          }),
          [3],
        )..start();
        var updates = 0;
        s.updates.listen((_) => updates++);
        s.submitAs('p0', const LudoRoll());
        fa.elapse(const Duration(seconds: 5));
        expect(s.state.isOver, isTrue);
        final count = updates;
        fa.elapse(const Duration(minutes: 5));
        expect(updates, count);
        expect(s.timer.running, isFalse);
        expect(s.scheduler.pendingCount, 0);
        s.dispose();
      });
    });

    test('timer expiry racing the auto-move acts exactly once', () {
      fakeAsync((fa) {
        final s = session(
          ludoState({
            'p0': [10, -1, -1, -1],
          }),
          [3],
        )..start();
        final moved = <TokenMoved>[];
        s.updates.listen((u) => moved.addAll(u.events.whereType<TokenMoved>()));
        fa.elapse(const Duration(seconds: 29, milliseconds: 500));
        s.submitAs('p0', const LudoRoll());
        // Timer expires at 30 s, the auto-move is due at 30.62 s.
        fa.elapse(const Duration(seconds: 3));
        expect(moved, hasLength(1));
        expect(s.state.tokensOf('p0')[0], 13);
        s.dispose();
      });
    });

    test('stale turnSeq is rejected', () {
      fakeAsync((fa) {
        final s = session(ludoState({}), [2])..start();
        final r = s.submitAs('p0', const LudoRoll(), turnSeq: 5);
        expect((r as Rejected).code, RejectionCode.staleTurn);
        s.dispose();
      });
    });
  });

  group('auto single move', () {
    test('fires at exactly 1120 ms after the roll', () {
      fakeAsync((fa) {
        final s = session(
          ludoState({
            'p0': [10, -1, -1, -1],
          }),
          [3],
          timer: false,
          gate: SlowGate(
            diceDelay: const Duration(milliseconds: 800),
            drainDelay: const Duration(milliseconds: 800),
          ),
        )..start();
        s.submitAs('p0', const LudoRoll());
        fa.elapse(const Duration(milliseconds: 1119));
        expect(s.state.phase, LudoPhase.awaitingMove);
        fa.elapse(const Duration(milliseconds: 1));
        expect(s.state.tokensOf('p0')[0], 13);
        s.dispose();
      });
    });

    test('never fires before a slow dice animation lands', () {
      fakeAsync((fa) {
        final s = session(
          ludoState({
            'p0': [10, -1, -1, -1],
          }),
          [3],
          timer: false,
          gate: SlowGate(
            diceDelay: const Duration(milliseconds: 2000),
            drainDelay: const Duration(milliseconds: 2000),
          ),
        )..start();
        s.submitAs('p0', const LudoRoll());
        fa.elapse(const Duration(milliseconds: 1999));
        expect(s.state.phase, LudoPhase.awaitingMove);
        fa.elapse(const Duration(milliseconds: 1));
        expect(s.state.tokensOf('p0')[0], 13);
        s.dispose();
      });
    });

    test('a human move before the auto-move cancels it', () {
      fakeAsync((fa) {
        final s = session(
          ludoState({
            'p0': [10, -1, -1, -1],
          }),
          [3, 1],
          timer: false,
        )..start();
        s.submitAs('p0', const LudoRoll());
        fa.elapse(const Duration(milliseconds: 500));
        s.submitAs('p0', const MoveToken(0));
        fa.elapse(const Duration(seconds: 2));
        expect(s.state.tokensOf('p0')[0], 13);
        expect(s.state.currentPlayer, 'p1');
        s.dispose();
      });
    });

    test('several legal moves wait for the player', () {
      fakeAsync((fa) {
        final s = session(
          ludoState({
            'p0': [10, 20, -1, -1],
          }),
          [3],
          timer: false,
        )..start();
        s.submitAs('p0', const LudoRoll());
        fa.elapse(const Duration(minutes: 1));
        expect(s.state.phase, LudoPhase.awaitingMove);
        s.dispose();
      });
    });
  });

  group('AI and removal through the session', () {
    test('a 4-AI Ludo game plays to the end', () {
      fakeAsync((fa) {
        final s = AuthoritySession(
          module: ludo,
          initial: ludo.newGame(
            seats(4, kind: PlayerKind.ai, aiLevel: AiLevel.normal),
            const LudoConfig(),
          ),
          dice: SeededDiceService(5),
          aiRandom: Random(5),
        )..start();
        fa.elapse(const Duration(hours: 3));
        expect(s.state.isOver, isTrue);
        expect(s.state.ranking, hasLength(3));
        s.dispose();
      });
    });

    test('a Snakes & Ladders game of AI and timed-out humans finishes', () {
      fakeAsync((fa) {
        final module = SnakesModule(loadShippedBoards());
        final s =
            AuthoritySession<
                SnakesState,
                SnakesIntent,
                snl.SnakesEvent,
                SnakesConfig
              >(
                module: module,
                initial: module.newGame([
                  ...seats(2),
                  ...seats(
                    4,
                    kind: PlayerKind.ai,
                    aiLevel: AiLevel.easy,
                  ).sublist(2),
                ], const SnakesConfig()),
                dice: SeededDiceService(8),
                timerEnabled: true,
              )
              ..start();
        fa.elapse(const Duration(hours: 4));
        expect(s.state.isOver, isTrue);
        s.dispose();
      });
    });

    test('S&L AI waits its think time before rolling', () {
      fakeAsync((fa) {
        final module = SnakesModule(loadShippedBoards());
        final s =
            AuthoritySession<
                SnakesState,
                SnakesIntent,
                snl.SnakesEvent,
                SnakesConfig
              >(
                module: module,
                initial: module.newGame(
                  seats(2, kind: PlayerKind.ai, aiLevel: AiLevel.normal),
                  const SnakesConfig(),
                ),
                dice: ScriptedDiceService([2, 2]),
              )
              ..start();
        fa.elapse(const Duration(milliseconds: 599));
        expect(s.state.turnSeq, 0);
        fa.elapse(const Duration(milliseconds: 1));
        expect(s.state.turnSeq, 1);
        s.dispose();
      });
    });

    test('a seat taken over by AI on its turn is played by the AI', () {
      fakeAsync((fa) {
        final s = session(ludoState({}), [2, 2])..start();
        s.updatePlayer(
          'p0',
          (p) => p.copyWith(kind: PlayerKind.ai, aiLevel: AiLevel.normal),
        );
        fa.elapse(const Duration(seconds: 1));
        expect(s.state.currentPlayer, 'p1');
        s.dispose();
      });
    });

    test('removing the current player re-arms the timer for the next', () {
      fakeAsync((fa) {
        final s = AuthoritySession(
          module: ludo,
          initial: ludo.newGame(seats(3), const LudoConfig()),
          dice: ScriptedDiceService(const []),
          timerEnabled: true,
        )..start();
        fa.elapse(const Duration(seconds: 12));
        s.removePlayer('p0');
        fa.flushMicrotasks();
        expect(s.state.currentPlayer, 'p1');
        expect(s.timer.remaining, const Duration(seconds: 30));
        expect(s.timer.turnSeq, s.state.turnSeq);
        s.dispose();
      });
    });
  });

  test('scheduler claims each decision point once', () {
    fakeAsync((fa) {
      final s = session(ludoState({}), []);
      expect(s.scheduler.claim(0), isTrue);
      expect(s.scheduler.claim(0), isFalse);
      expect(s.scheduler.claim(1), isFalse, reason: 'not current');
      var ran = 0;
      s.scheduler.schedule(
        turnSeq: 0,
        delay: Duration.zero,
        action: () => ran++,
      );
      fa.elapse(Duration.zero);
      expect(ran, 0, reason: 'already claimed');
      s.dispose();
    });
  });
}
