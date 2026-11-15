// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snakes_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SnakesState _$SnakesStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SnakesState', json, ($checkedConvert) {
      final val = _SnakesState(
        boardId: $checkedConvert('boardId', (v) => v as String),
        rules: $checkedConvert(
          'rules',
          (v) => SnakesRules.fromJson(v as Map<String, dynamic>),
        ),
        snakeCount: $checkedConvert('snakeCount', (v) => (v as num).toInt()),
        players: $checkedConvert(
          'players',
          (v) => (v as List<dynamic>)
              .map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        positions: $checkedConvert(
          'positions',
          (v) => Map<String, int>.from(v as Map),
        ),
        currentPlayer: $checkedConvert('currentPlayer', (v) => v as String?),
        phase: $checkedConvert(
          'phase',
          (v) => $enumDecode(_$SnakesPhaseEnumMap, v),
        ),
        lastRoll: $checkedConvert('lastRoll', (v) => (v as num?)?.toInt()),
        consecutiveSixes: $checkedConvert(
          'consecutiveSixes',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        turnStartPosition: $checkedConvert(
          'turnStartPosition',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        turnNumber: $checkedConvert(
          'turnNumber',
          (v) => (v as num?)?.toInt() ?? 1,
        ),
        turnSeq: $checkedConvert('turnSeq', (v) => (v as num?)?.toInt() ?? 0),
        ranking: $checkedConvert(
          'ranking',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <PlayerId>[],
        ),
        leavers: $checkedConvert(
          'leavers',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <PlayerId>[],
        ),
      );
      return val;
    });

Map<String, dynamic> _$SnakesStateToJson(_SnakesState instance) =>
    <String, dynamic>{
      'boardId': instance.boardId,
      'rules': instance.rules.toJson(),
      'snakeCount': instance.snakeCount,
      'players': instance.players.map((e) => e.toJson()).toList(),
      'positions': instance.positions,
      'currentPlayer': instance.currentPlayer,
      'phase': _$SnakesPhaseEnumMap[instance.phase]!,
      'lastRoll': instance.lastRoll,
      'consecutiveSixes': instance.consecutiveSixes,
      'turnStartPosition': instance.turnStartPosition,
      'turnNumber': instance.turnNumber,
      'turnSeq': instance.turnSeq,
      'ranking': instance.ranking,
      'leavers': instance.leavers,
    };

const _$SnakesPhaseEnumMap = {
  SnakesPhase.awaitingRoll: 'awaitingRoll',
  SnakesPhase.gameOver: 'gameOver',
};
