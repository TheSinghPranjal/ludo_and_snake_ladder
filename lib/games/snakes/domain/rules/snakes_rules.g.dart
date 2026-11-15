// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snakes_rules.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SnakesRules _$SnakesRulesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SnakesRules', json, ($checkedConvert) {
      final val = _SnakesRules(
        needSixToStart: $checkedConvert(
          'needSixToStart',
          (v) => v as bool? ?? false,
        ),
        overshoot: $checkedConvert(
          'overshoot',
          (v) => $enumDecodeNullable(_$OvershootEnumMap, v) ?? Overshoot.stay,
        ),
        extraRollOnSix: $checkedConvert(
          'extraRollOnSix',
          (v) => v as bool? ?? true,
        ),
        threeSixesPenalty: $checkedConvert(
          'threeSixesPenalty',
          (v) => v as bool? ?? true,
        ),
        capture: $checkedConvert('capture', (v) => v as bool? ?? false),
        playTo: $checkedConvert(
          'playTo',
          (v) => $enumDecodeNullable(_$PlayToEnumMap, v) ?? PlayTo.firstWinner,
        ),
      );
      return val;
    });

Map<String, dynamic> _$SnakesRulesToJson(_SnakesRules instance) =>
    <String, dynamic>{
      'needSixToStart': instance.needSixToStart,
      'overshoot': _$OvershootEnumMap[instance.overshoot]!,
      'extraRollOnSix': instance.extraRollOnSix,
      'threeSixesPenalty': instance.threeSixesPenalty,
      'capture': instance.capture,
      'playTo': _$PlayToEnumMap[instance.playTo]!,
    };

const _$OvershootEnumMap = {Overshoot.stay: 'stay', Overshoot.bounce: 'bounce'};

const _$PlayToEnumMap = {
  PlayTo.firstWinner: 'firstWinner',
  PlayTo.fullRanking: 'fullRanking',
};

_SnakesConfig _$SnakesConfigFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SnakesConfig', json, ($checkedConvert) {
      final val = _SnakesConfig(
        boardId: $checkedConvert(
          'boardId',
          (v) => v as String? ?? 'classic_sunshine',
        ),
        snakeCount: $checkedConvert(
          'snakeCount',
          (v) => (v as num?)?.toInt() ?? defaultSnakes,
        ),
        rules: $checkedConvert(
          'rules',
          (v) => v == null
              ? const SnakesRules()
              : SnakesRules.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SnakesConfigToJson(_SnakesConfig instance) =>
    <String, dynamic>{
      'boardId': instance.boardId,
      'snakeCount': instance.snakeCount,
      'rules': instance.rules.toJson(),
    };
