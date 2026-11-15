import 'package:dice_party/games/ludo/application/ludo_controller.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_state.dart';
import 'package:dice_party/games/ludo/domain/ludo_module.dart';
import 'package:dice_party/games/ludo/domain/rules/ludo_config.dart';
import 'package:dice_party/games/snakes/application/snakes_controller.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_state.dart';
import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/games/snakes/domain/snakes_module.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/haptics/haptics_service.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';
import '../helpers/fixtures.dart';

const _ludo = LudoModule();

LudoController _ludoController({
  required List<int> dice,
  List<SeatSpec>? seatList,
  Duration? diceDuration,
  void Function(SavedGame?)? onSave,
  AudioService? audio,
}) {
  final s = seatList ?? seats(2, colors: [PlayerColor.red, PlayerColor.yellow]);
  return LudoController(
    module: _ludo,
    initial: _ludo.newGame(s, const LudoConfig()),
    config: const LudoConfig(),
    mode: GameMode.local,
    dice: ScriptedDiceService(dice),
    audio: audio ?? AudioService(RecordingAudioBackend(), extension: 'ogg'),
    haptics: HapticsService(perform: (_) async {}),
    me: 'p0',
    onSave: onSave,
    diceDuration: diceDuration ?? const Duration(milliseconds: 800),
  );
}

void main() {
  group('Ludo local controller', () {
    test('a single legal move plays at exactly 1120 ms after the roll', () {
      fakeAsync((async) {
        final c = _ludoController(dice: [6])
          ..start()
          ..roll();
        expect(c.session.state.phase, LudoPhase.awaitingMove);
        async.elapse(const Duration(milliseconds: 1119));
        expect(c.session.state.tokensOf('p0')[0], -1);
        async.elapse(const Duration(milliseconds: 1));
        expect(c.session.state.tokensOf('p0')[0], 0);
        c.dispose();
      });
    });

    test('with a slow 2 s dice the auto move waits for the landing', () {
      fakeAsync((async) {
        final c =
            _ludoController(
                dice: [6],
                diceDuration: const Duration(seconds: 2),
              )
              ..start()
              ..roll();
        async.elapse(const Duration(milliseconds: 1500));
        expect(c.session.state.tokensOf('p0')[0], -1);
        expect(c.rolling, isTrue);
        async.elapse(const Duration(milliseconds: 500));
        expect(c.session.state.tokensOf('p0')[0], 0);
        c.dispose();
      });
    });

    test('the board shows the roll only after the dice lands', () {
      fakeAsync((async) {
        final c = _ludoController(dice: [3])..start();
        expect(c.humanCanAct, isTrue);
        c.roll();
        expect(c.rolling, isTrue);
        expect(c.humanCanAct, isFalse);
        expect(c.diceFace, isNull);
        async.elapse(const Duration(milliseconds: 800));
        expect(c.rolling, isFalse);
        expect(c.diceFace, 3);
        expect(c.status, 'P0 rolled 3 · no moves');
        c.dispose();
      });
    });

    test('saves a resumable state after every intent', () {
      fakeAsync((async) {
        final saves = <SavedGame?>[];
        final c = _ludoController(dice: [3, 4], onSave: saves.add)
          ..start()
          ..roll();
        expect(saves.last, isNotNull);
        final restored = _ludo.stateFromJson(saves.last!.state);
        expect(restored, c.session.state);
        expect(saves.last!.mode, GameMode.local);
        expect(saves.last!.me, 'p0');
        c.dispose();
      });
    });

    test('pause stops computer players; resume continues', () {
      fakeAsync((async) {
        final c = _ludoController(
          dice: List.filled(50, 3),
          seatList: seats(2, kind: PlayerKind.ai, aiLevel: AiLevel.normal),
        )..start();
        async.elapse(const Duration(seconds: 3));
        final seq = c.session.state.turnSeq;
        expect(seq, greaterThan(0));
        c.pause();
        async.elapse(const Duration(seconds: 10));
        expect(c.session.state.turnSeq, seq);
        c.resume();
        async.elapse(const Duration(seconds: 3));
        expect(c.session.state.turnSeq, greaterThan(seq));
        c.dispose();
      });
    });

    test('an all-AI game finishes and reports places for everyone', () {
      fakeAsync((async) {
        final audio = RecordingAudioBackend();
        final saves = <SavedGame?>[];
        final c = LudoController(
          module: _ludo,
          initial: _ludo.newGame(
            seats(4, kind: PlayerKind.ai, aiLevel: AiLevel.normal),
            const LudoConfig(),
          ),
          config: const LudoConfig(),
          mode: GameMode.ai,
          dice: SeededDiceService(3),
          audio: AudioService(audio, extension: 'ogg'),
          haptics: HapticsService(perform: (_) async {}),
          fast: true,
          onSave: saves.add,
        )..start();
        LudoState? done;
        c.finished.then((s) => done = s).ignore();
        for (var i = 0; i < 4000 && done == null; i++) {
          async.elapse(const Duration(seconds: 1));
        }
        expect(done, isNotNull);
        expect(done!.isOver, isTrue);
        final rows = c.resultRows(done!);
        expect(rows.map((r) => r.place), [1, 2, 3, 4]);
        expect(saves.length, greaterThan(10));
        expect(saves.last, isNull, reason: 'the save is deleted at game over');
        expect(audio.sfx, contains('dice_roll.ogg'));
        c.dispose();
      });
    });
  });

  group('Snakes local controller', () {
    late SnakesModule module;
    setUpAll(() async {
      final catalog = await testCatalog();
      module = catalog.games.first.module as SnakesModule;
    });

    test('a ladder climb shows a motion ending on the ladder top', () {
      final ladder = module.boards['classic_sunshine']!.ladders.firstWhere(
        (l) => l.from <= 6,
      );
      fakeAsync((async) {
        final c =
            SnakesController.newGame(
                module: module,
                seats: seats(2),
                config: const SnakesConfig(),
                mode: GameMode.local,
                dice: ScriptedDiceService([ladder.from]),
                audio: AudioService(RecordingAudioBackend(), extension: 'ogg'),
                haptics: HapticsService(perform: (_) async {}),
              )
              ..start()
              ..roll();
        async.elapse(const Duration(milliseconds: 800));
        final m = c.motions['p0']!;
        expect(m.points.last, boardOffset(ladder.to));
        expect(c.status, 'Ladder! ${ladder.from} → ${ladder.to}');
        c.dispose();
      });
    });

    test('an all-AI game finishes', () {
      fakeAsync((async) {
        final c = SnakesController.newGame(
          module: module,
          seats: seats(3, kind: PlayerKind.ai, aiLevel: AiLevel.easy),
          config: const SnakesConfig(snakeCount: 8),
          mode: GameMode.ai,
          dice: SeededDiceService(11),
          audio: AudioService(RecordingAudioBackend(), extension: 'ogg'),
          haptics: HapticsService(perform: (_) async {}),
          fast: true,
        )..start();
        SnakesState? done;
        c.finished.then((s) => done = s).ignore();
        for (var i = 0; i < 4000 && done == null; i++) {
          async.elapse(const Duration(seconds: 1));
        }
        expect(done?.isOver, isTrue);
        expect(c.module.statsFor(done!, 'p0'), contains('turns'));
        c.dispose();
      });
    });
  });
}
