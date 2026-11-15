// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ludo_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LudoState _$LudoStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LudoState', json, ($checkedConvert) {
      final val = _LudoState(
        players: $checkedConvert(
          'players',
          (v) => (v as List<dynamic>)
              .map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        tokens: $checkedConvert(
          'tokens',
          (v) => (v as Map<String, dynamic>).map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList(),
            ),
          ),
        ),
        currentPlayer: $checkedConvert('currentPlayer', (v) => v as String?),
        phase: $checkedConvert(
          'phase',
          (v) => $enumDecode(_$LudoPhaseEnumMap, v),
        ),
        dice: $checkedConvert('dice', (v) => (v as num?)?.toInt()),
        sixesThisTurn: $checkedConvert(
          'sixesThisTurn',
          (v) => (v as num?)?.toInt() ?? 0,
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

Map<String, dynamic> _$LudoStateToJson(_LudoState instance) =>
    <String, dynamic>{
      'players': instance.players.map((e) => e.toJson()).toList(),
      'tokens': instance.tokens,
      'currentPlayer': instance.currentPlayer,
      'phase': _$LudoPhaseEnumMap[instance.phase]!,
      'dice': instance.dice,
      'sixesThisTurn': instance.sixesThisTurn,
      'turnSeq': instance.turnSeq,
      'ranking': instance.ranking,
      'leavers': instance.leavers,
    };

const _$LudoPhaseEnumMap = {
  LudoPhase.awaitingRoll: 'awaitingRoll',
  LudoPhase.awaitingMove: 'awaitingMove',
  LudoPhase.gameOver: 'gameOver',
};
