import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_state.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:meta/meta.dart';

/// An opponent token a move would capture.
@immutable
class CaptureTarget {
  /// Creates a capture target.
  const CaptureTarget(this.playerId, this.tokenId, this.rel);

  /// Owner of the captured token.
  final PlayerId playerId;

  /// Captured token.
  final int tokenId;

  /// Its progress before capture.
  final int rel;

  @override
  bool operator ==(Object other) =>
      other is CaptureTarget &&
      other.playerId == playerId &&
      other.tokenId == tokenId &&
      other.rel == rel;

  @override
  int get hashCode => Object.hash(playerId, tokenId, rel);
}

/// A legal Ludo move.
@immutable
class Move {
  /// Creates a move.
  const Move({
    required this.tokenId,
    required this.fromRel,
    required this.toRel,
    required this.captures,
  });

  /// Token being moved.
  final int tokenId;

  /// Progress before the move.
  final int fromRel;

  /// Progress after the move.
  final int toRel;

  /// Opponent tokens sent back to base.
  final List<CaptureTarget> captures;

  /// Whether the token leaves base.
  bool get leavesBase => fromRel == baseRel;

  /// Whether the token reaches HOME.
  bool get reachesHome => toRel == homeRel;

  /// Whether the move enters the home column from the track.
  bool get entersHomeColumn =>
      fromRel <= lastTrackRel && toRel >= firstHomeColumnRel;

  @override
  bool operator ==(Object other) =>
      other is Move &&
      other.tokenId == tokenId &&
      other.fromRel == fromRel &&
      other.toRel == toRel;

  @override
  int get hashCode => Object.hash(tokenId, fromRel, toRel);

  @override
  String toString() => 'Move(token $tokenId: $fromRel → $toRel)';
}

/// Whether a token at [rel] is on the main track.
bool onTrack(int rel) => rel >= 0 && rel <= lastTrackRel;

/// Where a token at [fromRel] lands with [die], or null if it cannot move.
///
/// A token leaves base only on a 6, onto its start cell. Overshooting HOME
/// is illegal.
int? targetRel(int fromRel, int die) {
  if (fromRel == homeRel) return null;
  if (fromRel == baseRel) return die == 6 ? 0 : null;
  final to = fromRel + die;
  return to > homeRel ? null : to;
}

/// Opponent tokens on track index [index], excluding removed players.
/// Empty on safe cells, where nothing can be captured.
List<CaptureTarget> capturesAt(LudoState state, PlayerId mover, int index) {
  if (isSafeIndex(index)) return const [];
  return [
    for (final p in state.players)
      if (p.id != mover && !p.isRemoved)
        for (final (tokenId, rel) in state.tokensOf(p.id).indexed)
          if (onTrack(rel) && absoluteIndex(p.color, rel) == index)
            CaptureTarget(p.id, tokenId, rel),
  ];
}

/// Every legal move for [player] with [die], by token index.
List<Move> legalMoves(LudoState state, PlayerId player, int die) {
  final p = state.player(player);
  if (p == null) return const [];
  final moves = <Move>[];
  for (final (tokenId, rel) in state.tokensOf(player).indexed) {
    final to = targetRel(rel, die);
    if (to == null) continue;
    moves.add(
      Move(
        tokenId: tokenId,
        fromRel: rel,
        toRel: to,
        captures: onTrack(to)
            ? capturesAt(state, player, absoluteIndex(p.color, to))
            : const [],
      ),
    );
  }
  return moves;
}

/// Whether every move in [moves] has the same outcome: the same start and
/// end, so only which identical token moves differs.
bool allEquivalent(List<Move> moves) =>
    moves.isNotEmpty &&
    moves.every(
      (m) => m.fromRel == moves.first.fromRel && m.toRel == moves.first.toRel,
    );

/// Whether the move lands on one of the 8 safe track cells.
bool landsSafe(Move move, PlayerColor color) =>
    onTrack(move.toRel) && isSafeIndex(absoluteIndex(color, move.toRel));

/// The timeout policy: the move played when the turn timer expires with
/// several legal moves.
///
/// In order: (1) reach HOME, (2) capture, (3) leave base on a 6, (4) land on
/// a safe cell, (5) advance the furthest token. Ties go to the lowest token
/// index.
Move timeoutMove(List<Move> moves, PlayerColor color) {
  if (moves.isEmpty) throw ArgumentError.value(moves, 'moves', 'empty');
  final sorted = List.of(moves)..sort((a, b) => a.tokenId - b.tokenId);
  for (final test in <bool Function(Move)>[
    (m) => m.reachesHome,
    (m) => m.captures.isNotEmpty,
    (m) => m.leavesBase,
    (m) => landsSafe(m, color),
  ]) {
    for (final m in sorted) {
      if (test(m)) return m;
    }
  }
  var best = sorted.first;
  for (final m in sorted) {
    if (m.fromRel > best.fromRel) best = m;
  }
  return best;
}
