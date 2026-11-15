import 'dart:math';

import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_state.dart';
import 'package:dice_party/games/ludo/domain/rules/moves.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:meta/meta.dart';

/// Every weight the Ludo AI uses, in one place.
@immutable
class LudoAiWeights {
  /// Creates a weight set. The defaults are the shipped tuning.
  const LudoAiWeights({
    this.capture = 50,
    this.captureProgress = 30,
    this.home = 45,
    this.homeColumn = 20,
    this.leaveBase = 25,
    this.leaveBaseFewOut = 15,
    this.safe = 12,
    this.danger = 30,
    this.escape = 10,
    this.breakStack = 6,
    this.progress = 2,
  });

  /// Bonus for each captured token.
  final double capture;

  /// Extra capture bonus scaled by how far the victim had travelled.
  final double captureProgress;

  /// Bonus for reaching HOME.
  final double home;

  /// Bonus for entering the home column from the track.
  final double homeColumn;

  /// Bonus for leaving base.
  final double leaveBase;

  /// Extra leave-base bonus scaled by how few tokens are out.
  final double leaveBaseFewOut;

  /// Bonus for landing on a safe cell.
  final double safe;

  /// Penalty for ending 1–6 cells in front of an opponent on an unsafe cell.
  final double danger;

  /// Bonus for moving a threatened token out of danger.
  final double escape;

  /// Penalty for moving a token off a cell it shares with its own tokens.
  final double breakStack;

  /// Bonus per step advanced.
  final double progress;
}

/// Ludo computer player: scores every legal move and picks one.
///
/// Easy picks randomly among the top 3; Normal picks the best, with ties
/// going to the lowest token index.
class LudoAi {
  /// Creates an AI with [weights].
  const LudoAi([this.weights = const LudoAiWeights()]);

  /// Scoring weights.
  final LudoAiWeights weights;

  /// Chooses a move for [ai] from [moves]. [moves] must not be empty.
  Move choose(
    LudoState state,
    PlayerId ai,
    List<Move> moves,
    AiLevel level,
    Random rng,
  ) {
    final scored =
        [
          for (final m in moves) (move: m, score: score(state, ai, m)),
        ]..sort((a, b) {
          final byScore = b.score.compareTo(a.score);
          return byScore != 0 ? byScore : a.move.tokenId - b.move.tokenId;
        });
    if (level == AiLevel.easy) {
      return scored[rng.nextInt(min(3, scored.length))].move;
    }
    return scored.first.move;
  }

  /// Score of [move] for [ai]; higher is better.
  double score(LudoState state, PlayerId ai, Move move) {
    final w = weights;
    final color = state.player(ai)!.color;
    var s = 0.0;
    for (final c in move.captures) {
      s += w.capture + w.captureProgress * c.rel / lastTrackRel;
    }
    if (move.reachesHome) s += w.home;
    if (move.entersHomeColumn) s += w.homeColumn;
    if (move.leavesBase) {
      final out = state.tokensOf(ai).where((r) => r >= 0 && r < homeRel).length;
      s +=
          w.leaveBase +
          w.leaveBaseFewOut * (tokensPerPlayer - out) / tokensPerPlayer;
    }
    if (landsSafe(move, color)) s += w.safe;
    final destThreat =
        onTrack(move.toRel) &&
        !isSafeIndex(absoluteIndex(color, move.toRel)) &&
        threatened(state, ai, absoluteIndex(color, move.toRel), move);
    if (destThreat) s -= w.danger;
    final fromThreat =
        onTrack(move.fromRel) &&
        !isSafeIndex(absoluteIndex(color, move.fromRel)) &&
        threatened(state, ai, absoluteIndex(color, move.fromRel), null);
    if (fromThreat && !destThreat) s += w.escape;
    if (onTrack(move.fromRel) &&
        !isSafeIndex(absoluteIndex(color, move.fromRel)) &&
        state.tokensOf(ai).where((r) => r == move.fromRel).length > 1) {
      s -= w.breakStack;
    }
    if (!move.leavesBase) s += w.progress * (move.toRel - move.fromRel);
    return s;
  }

  /// Whether an opponent token sits 1–6 cells behind track index [index]
  /// and could reach it on its own route. Tokens [move] would capture do
  /// not count.
  static bool threatened(
    LudoState state,
    PlayerId ai,
    int index,
    Move? move,
  ) {
    for (final p in state.players) {
      if (p.id == ai || !p.isActive) continue;
      for (final (tokenId, rel) in state.tokensOf(p.id).indexed) {
        if (!onTrack(rel)) continue;
        if (move != null &&
            move.captures.any(
              (c) => c.playerId == p.id && c.tokenId == tokenId,
            )) {
          continue;
        }
        final behind = (index - absoluteIndex(p.color, rel)) % trackLength;
        if (behind >= 1 && behind <= 6 && rel + behind <= lastTrackRel) {
          return true;
        }
      }
    }
    return false;
  }
}

/// Ludo AI think time: 600–900 ms, halved in Fast.
Duration ludoThinkDelay(Random rng, {required bool fast}) {
  final ms = 600 + rng.nextInt(301);
  return Duration(milliseconds: fast ? ms ~/ 2 : ms);
}
