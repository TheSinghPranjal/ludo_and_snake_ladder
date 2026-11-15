import 'package:dice_party/games/ludo/domain/engine/ludo_events.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_intent.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_state.dart';
import 'package:dice_party/games/ludo/domain/ludo_module.dart';
import 'package:dice_party/games/ludo/domain/rules/ludo_config.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

const module = LudoModule();

/// A game with [players] players (Red p0, Blue p1, Yellow p2, Green p3 for
/// 4) and the given token positions.
LudoState ludo({
  int players = 4,
  List<PlayerColor>? colors,
  Map<String, List<int>> tokens = const {},
  String? current,
  int? dice,
}) {
  final s = module.newGame(seats(players, colors: colors), const LudoConfig());
  return s.copyWith(
    tokens: {...s.tokens, ...tokens},
    currentPlayer: current ?? s.currentPlayer,
    dice: dice,
    phase: dice == null ? LudoPhase.awaitingRoll : LudoPhase.awaitingMove,
  );
}

/// Applies [intent] and expects it to be accepted.
Accepted<LudoState, LudoEvent> accept(
  LudoState s,
  LudoIntent intent, {
  List<int> dice = const [],
  String? by,
}) {
  final r = module.apply(
    s,
    by ?? s.currentPlayer!,
    intent,
    ScriptedDiceService(dice),
  );
  expect(r, isA<Accepted<LudoState, LudoEvent>>(), reason: '$intent');
  return r as Accepted<LudoState, LudoEvent>;
}

/// Applies [intent] and expects a rejection with the identical state.
RejectionCode reject(
  LudoState s,
  LudoIntent intent, {
  String? by,
  ScriptedDiceService? dice,
}) {
  final r = module.apply(
    s,
    by ?? s.currentPlayer!,
    intent,
    dice ?? ScriptedDiceService(const []),
  );
  expect(r, isA<Rejected<LudoState, LudoEvent>>(), reason: '$intent');
  r as Rejected<LudoState, LudoEvent>;
  expect(identical(r.state, s), isTrue);
  return r.code;
}

/// Rolls [face] then moves [token].
Accepted<LudoState, LudoEvent> rollMove(LudoState s, int face, int token) {
  final rolled = accept(s, const LudoRoll(), dice: [face]);
  expect(rolled.state.phase, LudoPhase.awaitingMove);
  return accept(rolled.state, MoveToken(token));
}
