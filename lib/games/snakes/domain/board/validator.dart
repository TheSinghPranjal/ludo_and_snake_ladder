import 'dart:math' as math;

import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/domain/board/coords.dart';
import 'package:dice_party/games/snakes/domain/board/curve.dart';
import 'package:dice_party/games/snakes/domain/board/jump.dart';

/// Kinds of board problems.
enum BoardIssueCode {
  /// The board is not 10×10.
  wrongSize,

  /// Two jumps share an id.
  duplicateId,

  /// A square is outside 1..100.
  outOfRange,

  /// A ladder ends at or below its foot.
  ladderGoesDown,

  /// A snake ends at or above its head.
  snakeGoesUp,

  /// A jump starts on square 100.
  startsOnLast,

  /// A snake's head is on square 1.
  snakeHeadOnFirst,

  /// Two jumps start on the same square.
  duplicateStart,

  /// A jump ends where another starts.
  chain,

  /// The snakes are not exactly 8, ranked 1 to 8.
  snakeRanks,

  /// A snake has no path, or not 2–4 points inside the board.
  missingPath,

  /// The six always-on snakes miss the 90s, 40–89 or below-40 band.
  rankBands,

  /// A snake's body covers another snake's head or a ladder's foot.
  bodyCoversStart,
}

/// One board problem.
class BoardIssue {
  /// Creates an issue.
  const BoardIssue(this.code, this.jumpId, this.detail);

  /// What is wrong.
  final BoardIssueCode code;

  /// The jump involved, if any.
  final String? jumpId;

  /// Human-readable detail.
  final String detail;

  @override
  String toString() =>
      '${code.name}${jumpId == null ? '' : ' $jumpId'}: '
      '$detail';
}

/// Checks a board against the Snakes & Ladders board rules.
abstract final class BoardValidator {
  /// Closest a snake body may come to another jump's start, in board units.
  static const double minClearance = 0.05;

  /// Fraction of the first curve segment hidden under the head sprite.
  static const double headSkip = 6 / 24;

  /// Every problem with [board]. Empty means the board is valid at 6, 7
  /// and 8 snakes.
  static List<BoardIssue> validate(BoardDef board) {
    final issues = <BoardIssue>[];
    void add(BoardIssueCode code, String? id, String detail) =>
        issues.add(BoardIssue(code, id, detail));

    if (board.size != boardSide) {
      add(BoardIssueCode.wrongSize, null, 'size ${board.size}');
    }
    final ids = <String>{};
    for (final j in board.jumps) {
      if (!ids.add(j.id)) add(BoardIssueCode.duplicateId, j.id, 'repeated');
    }
    for (final j in board.jumps) {
      _checkJump(j, add);
    }
    final starts = <int, String>{};
    for (final j in board.jumps) {
      final other = starts[j.from];
      if (other != null) {
        add(
          BoardIssueCode.duplicateStart,
          j.id,
          'shares ${j.from} with '
          '$other',
        );
      }
      starts[j.from] = j.id;
    }
    for (final j in board.jumps) {
      final next = starts[j.to];
      if (next != null) {
        add(BoardIssueCode.chain, j.id, 'ends on ${j.to}, start of $next');
      }
    }
    final ranks = [for (final s in board.snakes) s.rank]..sort(_nullLast);
    final expected = [for (var r = 1; r <= maxSnakes; r++) r];
    if (ranks.length != maxSnakes ||
        !Iterable<int>.generate(maxSnakes).every((i) => ranks[i] == i + 1)) {
      add(BoardIssueCode.snakeRanks, null, 'ranks $ranks, need $expected');
    }
    final alwaysOn = [
      for (final s in board.snakes)
        if ((s.rank ?? 99) <= minSnakes) s.from,
    ];
    if (!alwaysOn.any((h) => h >= 90) ||
        !alwaysOn.any((h) => h >= 40 && h <= 89) ||
        !alwaysOn.any((h) => h < 40)) {
      add(BoardIssueCode.rankBands, null, 'always-on heads $alwaysOn');
    }
    if (issues.isEmpty) _checkBodies(board, add);
    return issues;
  }

  static int _nullLast(int? a, int? b) => (a ?? 99).compareTo(b ?? 99);

  static void _checkJump(
    Jump j,
    void Function(BoardIssueCode, String?, String) add,
  ) {
    bool inRange(int s) => s >= 1 && s <= lastSquare;
    if (!inRange(j.from) || !inRange(j.to)) {
      add(BoardIssueCode.outOfRange, j.id, '${j.from} → ${j.to}');
      return;
    }
    if (j.from == lastSquare) {
      add(BoardIssueCode.startsOnLast, j.id, 'starts on $lastSquare');
    }
    if (j.isLadder && j.to <= j.from) {
      add(BoardIssueCode.ladderGoesDown, j.id, '${j.from} → ${j.to}');
    }
    if (j.isSnake) {
      if (j.to >= j.from) {
        add(BoardIssueCode.snakeGoesUp, j.id, '${j.from} → ${j.to}');
      }
      if (j.from == 1) {
        add(BoardIssueCode.snakeHeadOnFirst, j.id, 'head on 1');
      }
      final path = j.path;
      final validPath =
          path != null &&
          path.length >= 2 &&
          path.length <= 4 &&
          path.every(
            (p) =>
                p.length == 2 && p.every((v) => v.isFinite && v >= 0 && v <= 1),
          );
      if (!validPath) {
        add(BoardIssueCode.missingPath, j.id, 'needs 2–4 points in 0..1');
      }
    }
  }

  static void _checkBodies(
    BoardDef board,
    void Function(BoardIssueCode, String?, String) add,
  ) {
    final skip = (headSkip * curveSamplesPerSegment).toInt();
    for (final s in board.snakes) {
      final body = catmullRom(snakeControlPoints(s)).sublist(skip);
      for (final o in board.jumps) {
        if (identical(o, s)) continue;
        final q = squareCentre(o.from);
        final d = body
            .map(
              (p) => math.sqrt(math.pow(p.x - q.x, 2) + math.pow(p.y - q.y, 2)),
            )
            .reduce(math.min);
        if (d < minClearance) {
          add(
            BoardIssueCode.bodyCoversStart,
            s.id,
            'covers ${o.id} at ${o.from} (${d.toStringAsFixed(3)})',
          );
        }
      }
    }
  }
}
