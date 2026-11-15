import 'dart:math' as math;
import 'dart:ui';

import 'package:dice_party/core/clock.dart';
import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/domain/board/coords.dart';
import 'package:dice_party/games/snakes/domain/board/curve.dart';
import 'package:dice_party/games/snakes/domain/board/jump.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_events.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_intent.dart';
import 'package:dice_party/games/snakes/domain/engine/snakes_state.dart';
import 'package:dice_party/games/snakes/domain/rules/snakes_rules.dart';
import 'package:dice_party/games/snakes/domain/snakes_module.dart';
import 'package:dice_party/platform/animation/token_motion.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/haptics/haptics_service.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/session/local_game_controller.dart';

/// Animation timings of Snakes & Ladders (§2.6).
abstract final class SnakesTiming {
  /// One square hop.
  static const hop = Duration(milliseconds: 180);

  /// One square hop in Fast mode.
  static const hopFast = Duration(milliseconds: 90);

  /// Climbing one rung.
  static const rung = Duration(milliseconds: 120);

  /// Longest ladder climb.
  static const maxClimb = Duration(milliseconds: 1200);

  /// Shortest snake slide.
  static const minSlide = Duration(milliseconds: 1000);

  /// Longest snake slide.
  static const maxSlide = Duration(milliseconds: 1600);

  /// Returning to the turn's start after three 6s, or to the start pad
  /// after a capture.
  static const jumpBack = Duration(milliseconds: 500);
}

/// Board point as an [Offset].
Offset boardOffset(int square) {
  final p = squareCentre(square);
  return Offset(p.x, p.y);
}

/// Points along [snake]'s drawn body, head to tail.
List<Offset> snakeBodyPoints(Jump snake) => [
  for (final p in catmullRom(snakeControlPoints(snake))) Offset(p.x, p.y),
];

/// Length of a polyline in board units.
double polylineLength(List<Offset> pts) {
  var d = 0.0;
  for (var i = 1; i < pts.length; i++) {
    d += (pts[i] - pts[i - 1]).distance;
  }
  return d;
}

/// Runs a local Snakes & Ladders game and turns its events into motion,
/// sound and status text.
class SnakesController
    extends
        LocalGameController<
          SnakesState,
          SnakesIntent,
          SnakesEvent,
          SnakesConfig
        > {
  /// Creates a controller.
  SnakesController({
    required SnakesModule super.module,
    required super.initial,
    required super.config,
    required super.mode,
    required super.dice,
    required this.audio,
    required this.haptics,
    super.me,
    super.clock = const SystemClock(),
    super.timerEnabled,
    super.fast,
    super.onSave,
    super.diceDuration,
  }) : board = module.boards[initial.boardId]!;

  /// Creates a controller for a new game.
  factory SnakesController.newGame({
    required SnakesModule module,
    required List<SeatSpec> seats,
    required SnakesConfig config,
    required GameMode mode,
    required DiceService dice,
    required AudioService audio,
    required HapticsService haptics,
    Clock clock = const SystemClock(),
    bool timerEnabled = false,
    bool fast = false,
    void Function(SavedGame?)? onSave,
  }) {
    final initial = module.newGame(seats, config);
    return SnakesController(
      module: module,
      initial: initial,
      config: config,
      mode: mode,
      dice: dice,
      audio: audio,
      haptics: haptics,
      me: _firstHuman(initial),
      clock: clock,
      timerEnabled: timerEnabled,
      fast: fast,
      onSave: onSave,
    );
  }

  /// The board being played.
  final BoardDef board;

  /// Sound effects.
  final AudioService audio;

  /// Haptics.
  final HapticsService haptics;

  Map<PlayerId, TokenMotion> _motions = const {};
  Map<PlayerId, TokenMotion> _pending = const {};

  /// Token paths of the batch being shown.
  Map<PlayerId, TokenMotion> get motions => _motions;

  /// The first human seat, whose statistics are recorded.
  static PlayerId? _firstHuman(SnakesState s) {
    for (final p in s.players) {
      if (p.kind == PlayerKind.human) return p.id;
    }
    return null;
  }

  /// Rolls for the current human player.
  void roll() => submit(const SnakesRoll());

  Duration get _hop => fast ? SnakesTiming.hopFast : SnakesTiming.hop;

  String _name(SnakesState s, PlayerId id) => s.player(id)?.name ?? id;

  @override
  BatchTiming timing(List<SnakesEvent> events, SnakesState before) {
    int? dice;
    for (final e in events) {
      if (e is DiceRolled) dice = e.value;
    }
    final motions = _pending = _buildMotions(events, before);
    var move = Duration.zero;
    for (final m in motions.values) {
      if (m.total > move) move = m.total;
    }
    return BatchTiming(dice: dice, move: move);
  }

  Map<PlayerId, TokenMotion> _buildMotions(
    List<SnakesEvent> events,
    SnakesState before,
  ) {
    final pts = <PlayerId, List<Offset>>{};
    final segs = <PlayerId, List<Duration>>{};
    final out = <PlayerId, TokenMotion>{};
    void go(PlayerId id, Offset to, Duration d) {
      pts.putIfAbsent(id, () => [boardOffset(before.positionOf(id))]).add(to);
      segs.putIfAbsent(id, () => []).add(d);
    }

    var moverTotal = Duration.zero;
    for (final e in events) {
      switch (e) {
        case TokenStepped(:final playerId, :final path):
        case Bounced(:final playerId, :final path):
          for (final sq in path) {
            go(playerId, boardOffset(sq), _hop);
          }
        case JumpTaken(:final playerId, :final type, :final jumpId):
          final jump = board.jumps.firstWhere((j) => j.id == jumpId);
          if (type == JumpType.ladder) {
            final a = boardOffset(jump.from);
            final b = boardOffset(jump.to);
            final rungs = ((b - a).distance * 10 * 2.5).round();
            final d = SnakesTiming.rung * rungs;
            go(
              playerId,
              b,
              d > SnakesTiming.maxClimb ? SnakesTiming.maxClimb : d,
            );
          } else {
            final body = snakeBodyPoints(jump);
            final len = polylineLength(body);
            final total = Duration(
              milliseconds: (len * 2200).round().clamp(
                SnakesTiming.minSlide.inMilliseconds,
                SnakesTiming.maxSlide.inMilliseconds,
              ),
            );
            final per = total ~/ math.max(1, body.length - 1);
            for (final p in body.skip(1)) {
              go(playerId, p, per);
            }
          }
        case ThreeSixesPenalty(:final playerId, :final to):
          go(playerId, boardOffset(to), SnakesTiming.jumpBack);
        case Captured(:final victims):
          for (final m in segs.values) {
            final t = m.fold(Duration.zero, (a, b) => a + b);
            if (t > moverTotal) moverTotal = t;
          }
          for (final v in victims) {
            go(v, boardOffset(0), SnakesTiming.jumpBack);
          }
        default:
          break;
      }
    }
    for (final id in pts.keys) {
      final victim = events.any((e) => e is Captured && e.victims.contains(id));
      out[id] = TokenMotion(
        points: pts[id]!,
        segments: segs[id]!,
        delay: victim ? moverTotal : Duration.zero,
      );
    }
    return out;
  }

  @override
  String describeTurn(SnakesState state) {
    final p = state.player(state.currentPlayer ?? '');
    if (p == null) return '';
    if (p.kind == PlayerKind.ai) return '${p.name} is thinking…';
    return '${p.name}, roll the dice';
  }

  @override
  String? describe(
    List<SnakesEvent> events,
    SnakesState before,
    SnakesState next,
  ) {
    String? main;
    var extra = false;
    for (final e in events) {
      switch (e) {
        case DiceRolled(:final playerId, :final value):
          main ??= '${_name(next, playerId)} rolled $value';
        case MoveBlocked(:final reason, :final need, :final playerId):
          main = reason == BlockReason.needSix
              ? '${_name(next, playerId)} needs a 6 to start'
              : 'Need exactly $need to win';
        case Bounced():
          main = 'Bounce back!';
        case JumpTaken(:final type, :final from, :final to):
          main = type == JumpType.ladder
              ? 'Ladder! $from → $to'
              : 'Oops, snake! $from → $to';
        case Captured(:final playerId, :final victims):
          main =
              '${_name(next, playerId)} sent '
              '${victims.map((v) => _name(next, v)).join(' and ')} '
              'back to start!';
        case ThreeSixesPenalty(:final to):
          main = 'Three 6s! Back to ${to == 0 ? 'start' : to}';
        case ExtraRoll():
          extra = true;
        case PlayerFinished(:final playerId, :final rank):
          main = rank == 1
              ? '${_name(next, playerId)} wins!'
              : '${_name(next, playerId)} finished '
                    '${rank == 2
                        ? '2nd'
                        : rank == 3
                        ? '3rd'
                        : '${rank}th'}';
        case PlayerRemoved(:final playerId):
          main = '${_name(next, playerId)} left the game';
        case TurnPassed() || GameOver() || TokenStepped():
          break;
      }
    }
    if (main == null) return null;
    return extra ? '$main Extra roll!' : main;
  }

  @override
  void onDiceStart() => audio.play(Sfx.diceRoll);

  @override
  void onDiceLanded(List<SnakesEvent> events) {
    audio.play(Sfx.diceLand);
    haptics.pulse(HapticPulse.tick);
  }

  @override
  void onBoardChange(
    List<SnakesEvent> events,
    SnakesState before,
    SnakesState next,
  ) {
    _motions = _pending;
    var at = Duration.zero;
    for (final e in events) {
      switch (e) {
        case TokenStepped(:final path) || Bounced(:final path):
          for (var i = 0; i < path.length; i++) {
            after(at, () => audio.play(Sfx.step));
            at += _hop;
          }
        case JumpTaken(:final type):
          if (type == JumpType.ladder) {
            after(at, () {
              audio.play(Sfx.ladderClimb);
              haptics.pulse(HapticPulse.light);
            });
          } else {
            after(at, () {
              audio
                ..play(Sfx.snakeGulp)
                ..play(Sfx.snakeSlide);
              haptics.pulse(HapticPulse.medium);
            });
          }
        case MoveBlocked() || ThreeSixesPenalty():
          audio.play(Sfx.blocked);
        case ExtraRoll():
          audio.play(Sfx.extraRoll);
        default:
          break;
      }
    }
  }
}
