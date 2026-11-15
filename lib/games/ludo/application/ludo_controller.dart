import 'dart:ui';

import 'package:dice_party/core/clock.dart';
import 'package:dice_party/games/ludo/application/ludo_geometry.dart';
import 'package:dice_party/games/ludo/domain/board/board_map.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_events.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_intent.dart';
import 'package:dice_party/games/ludo/domain/engine/ludo_state.dart';
import 'package:dice_party/games/ludo/domain/ludo_module.dart';
import 'package:dice_party/games/ludo/domain/rules/ludo_config.dart';
import 'package:dice_party/games/ludo/domain/rules/moves.dart';
import 'package:dice_party/platform/animation/token_motion.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/dice/dice_service.dart';
import 'package:dice_party/platform/haptics/haptics_service.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/persistence/saved_game.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/session/local_game_controller.dart';
import 'package:dice_party/platform/ui/assets.dart';

/// Animation timings of Ludo (§3.7).
abstract final class LudoTiming {
  /// One cell hop.
  static const hop = Duration(milliseconds: 150);

  /// One cell hop in Fast mode.
  static const hopFast = Duration(milliseconds: 75);

  /// Leaving base: pop onto the start cell.
  static const leaveBase = Duration(milliseconds: 250);

  /// A captured token flying back to its yard.
  static const knockBack = Duration(milliseconds: 600);
}

/// Key of token [tokenId] of [player] in motion maps and sprites.
String ludoTokenKey(PlayerId player, int tokenId) => '$player.$tokenId';

/// Runs a local Ludo game and turns its events into motion, sound and
/// status text.
class LudoController
    extends LocalGameController<LudoState, LudoIntent, LudoEvent, LudoConfig> {
  /// Creates a controller.
  LudoController({
    required LudoModule super.module,
    required super.initial,
    required super.config,
    required super.mode,
    required super.dice,
    required this.audio,
    required this.haptics,
    super.me,
    super.clock,
    super.timerEnabled,
    super.fast,
    super.onSave,
    super.diceDuration,
  }) : ludo = module;

  /// Creates a controller for a new game.
  factory LudoController.newGame({
    required LudoModule module,
    required List<SeatSpec> seats,
    required GameMode mode,
    required DiceService dice,
    required AudioService audio,
    required HapticsService haptics,
    LudoConfig config = const LudoConfig(),
    Clock clock = const SystemClock(),
    bool timerEnabled = false,
    bool fast = false,
    void Function(SavedGame?)? onSave,
  }) {
    final initial = module.newGame(seats, config);
    PlayerId? me;
    for (final p in initial.players) {
      if (p.kind == PlayerKind.human) {
        me = p.id;
        break;
      }
    }
    return LudoController(
      module: module,
      initial: initial,
      config: config,
      mode: mode,
      dice: dice,
      audio: audio,
      haptics: haptics,
      me: me,
      clock: clock,
      timerEnabled: timerEnabled,
      fast: fast,
      onSave: onSave,
    );
  }

  /// The module, typed.
  final LudoModule ludo;

  /// Sound effects.
  final AudioService audio;

  /// Haptics.
  final HapticsService haptics;

  Map<String, TokenMotion> _motions = const {};
  Map<String, TokenMotion> _pending = const {};

  /// Token paths of the batch being shown, keyed by [ludoTokenKey].
  Map<String, TokenMotion> get motions => _motions;

  Duration get _hop => fast ? LudoTiming.hopFast : LudoTiming.hop;

  /// Whether the current human must roll.
  bool get canRoll =>
      humanCanAct && session.state.phase == LudoPhase.awaitingRoll;

  /// Legal moves the current human may pick now.
  List<Move> get movable {
    final s = session.state;
    if (!humanCanAct || s.phase != LudoPhase.awaitingMove) return const [];
    return ludo.movesFor(s, s.currentPlayer!);
  }

  /// Rolls for the current human.
  void roll() => submit(const LudoRoll());

  /// Moves [tokenId] for the current human.
  void move(int tokenId) => submit(MoveToken(tokenId));

  String _name(LudoState s, PlayerId id) => s.player(id)?.name ?? id;

  @override
  BatchTiming timing(List<LudoEvent> events, LudoState before) {
    int? dice;
    for (final e in events) {
      if (e is DiceRolled) dice = e.value;
    }
    _pending = _buildMotions(events, before);
    var move = Duration.zero;
    for (final m in _pending.values) {
      if (m.total > move) move = m.total;
    }
    return BatchTiming(dice: dice, move: move);
  }

  Map<String, TokenMotion> _buildMotions(
    List<LudoEvent> events,
    LudoState before,
  ) {
    final out = <String, TokenMotion>{};
    var moverTotal = Duration.zero;
    for (final e in events) {
      switch (e) {
        case TokenMoved(
          :final playerId,
          :final tokenId,
          :final fromRel,
          :final toRel,
          :final path,
        ):
          final color = before.player(playerId)!.color;
          final pts = <Offset>[tokenPoint(color, fromRel, tokenId)];
          final segs = <Duration>[];
          if (fromRel == baseRel) {
            pts.add(tokenPoint(color, 0, tokenId));
            segs.add(LudoTiming.leaveBase);
          } else {
            for (var i = 0; i < path.length; i++) {
              final last = i == path.length - 1;
              pts.add(
                last && toRel == homeRel
                    ? homePoint(color)
                    : cellCentre((row: path[i][0], col: path[i][1])),
              );
              segs.add(_hop);
            }
          }
          final m = TokenMotion(points: pts, segments: segs);
          moverTotal = m.total;
          out[ludoTokenKey(playerId, tokenId)] = m;
        case TokenCaptured(:final playerId, :final tokenId, :final fromRel):
          final color = before.player(playerId)!.color;
          out[ludoTokenKey(playerId, tokenId)] = TokenMotion(
            points: [
              tokenPoint(color, fromRel, tokenId),
              tokenPoint(color, baseRel, tokenId),
            ],
            segments: const [LudoTiming.knockBack],
            delay: moverTotal,
          );
        default:
          break;
      }
    }
    return out;
  }

  @override
  String describeTurn(LudoState state) {
    final p = state.player(state.currentPlayer ?? '');
    if (p == null) return '';
    if (p.kind == PlayerKind.ai) return '${p.name} is thinking…';
    if (state.phase == LudoPhase.awaitingMove) {
      return '${p.name}, pick a token to move';
    }
    return '${p.name}, roll the dice';
  }

  @override
  String? describe(
    List<LudoEvent> events,
    LudoState before,
    LudoState next,
  ) {
    String? main;
    var extra = false;
    for (final e in events) {
      switch (e) {
        case DiceRolled(:final playerId, :final value):
          main = '${_name(next, playerId)} rolled $value';
        case TurnPassed(:final reason, :final from):
          if (reason == PassReason.noMoves) {
            main = '${main ?? _name(next, from)} · no moves';
          }
        case TokenCaptured(:final playerId):
          main = 'Captured ${colorName(next.player(playerId)!.color)}!';
        case TokenHome(:final playerId):
          main = '${_name(next, playerId)}: a token is home!';
        case ThreeSixesForfeit():
          main = 'Three 6s! Turn over';
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
        case TokenMoved() || GameOver():
          break;
      }
    }
    if (main == null) return null;
    if (events.whereType<DiceRolled>().isNotEmpty &&
        next.phase == LudoPhase.awaitingMove &&
        next.currentPlayer != null) {
      final p = next.player(next.currentPlayer!);
      if (p?.kind == PlayerKind.human) {
        final n = ludo.movesFor(next, p!.id).length;
        return n > 1 ? '$main · pick a token' : main;
      }
    }
    return extra ? '$main Extra roll!' : main;
  }

  @override
  void onDiceStart() => audio.play(Sfx.diceRoll);

  @override
  void onDiceLanded(List<LudoEvent> events) {
    audio.play(Sfx.diceLand);
    haptics.pulse(HapticPulse.tick);
  }

  @override
  void onBoardChange(
    List<LudoEvent> events,
    LudoState before,
    LudoState next,
  ) {
    _motions = _pending;
    var at = Duration.zero;
    for (final e in events) {
      switch (e) {
        case TokenMoved(:final fromRel, :final path):
          if (fromRel == baseRel) {
            audio.play(Sfx.leaveBase);
            at = LudoTiming.leaveBase;
          } else {
            for (var i = 0; i < path.length; i++) {
              after(at, () => audio.play(Sfx.step));
              at += _hop;
            }
          }
        case TokenCaptured():
          after(at, () {
            audio.play(Sfx.capture);
            haptics.pulse(HapticPulse.light);
          });
        case TokenHome():
          after(at, () => audio.play(Sfx.home));
        case ExtraRoll():
          after(at, () => audio.play(Sfx.extraRoll));
        case ThreeSixesForfeit():
          audio.play(Sfx.blocked);
        default:
          break;
      }
    }
  }
}
