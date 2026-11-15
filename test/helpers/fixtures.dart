import 'dart:io';

import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/domain/board/board_loader.dart';
import 'package:dice_party/games/snakes/domain/board/jump.dart';
import 'package:dice_party/platform/session/game_module.dart';

/// Ids of the shipped boards.
const shippedBoardIds = ['classic_sunshine', 'sugar_rush', 'jungle_temple'];

/// Loads a shipped board from the asset folder.
BoardDef loadBoard(String id) {
  final source = File('assets/games/snakes/boards/$id.json').readAsStringSync();
  final result = BoardLoader.parse(source);
  final board = result.valueOrNull;
  if (board == null) throw StateError('board $id failed to load');
  return board;
}

/// All shipped boards.
List<BoardDef> loadShippedBoards() => [
  for (final id in shippedBoardIds) loadBoard(id),
];

/// Seats for [count] players. Colours follow Ludo's clockwise order unless
/// [colors] is given.
List<SeatSpec> seats(
  int count, {
  List<PlayerColor>? colors,
  PlayerKind kind = PlayerKind.human,
  AiLevel? aiLevel,
}) {
  final c = colors ?? PlayerColor.values;
  return [
    for (var i = 0; i < count; i++)
      SeatSpec(
        name: 'P$i',
        avatar: i,
        color: c[i],
        kind: kind,
        aiLevel: aiLevel,
      ),
  ];
}

Jump _snake(String id, int rank, int from, int to) => Jump(
  id: id,
  type: JumpType.snake,
  from: from,
  to: to,
  rank: rank,
  path: const [
    [0.5, 0.5],
    [0.4, 0.6],
  ],
);

/// A rules-test board with jumps at known squares. Not a shipped board.
///
/// Ladders 3→22 and 50→70. Snakes (rank): 30→7 (1), 98→78 (2), 45→25 (3),
/// 85→55 (4), 92→72 (5), 16→6 (6), 60→40 (7), 64→44 (8).
final BoardDef testBoard = BoardDef(
  id: 'test',
  name: 'Test',
  theme: 'sunshine',
  size: 10,
  unlock: const BoardUnlock(type: UnlockType.none),
  jumps: [
    const Jump(id: 'L1', type: JumpType.ladder, from: 3, to: 22),
    const Jump(id: 'L2', type: JumpType.ladder, from: 50, to: 70),
    _snake('S1', 1, 30, 7),
    _snake('S2', 2, 98, 78),
    _snake('S3', 3, 45, 25),
    _snake('S4', 4, 85, 55),
    _snake('S5', 5, 92, 72),
    _snake('S6', 6, 16, 6),
    _snake('S7', 7, 60, 40),
    _snake('S8', 8, 64, 44),
  ],
);
