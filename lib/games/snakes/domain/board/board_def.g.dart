// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_def.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BoardUnlock _$BoardUnlockFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_BoardUnlock',
  json,
  ($checkedConvert) {
    final val = _BoardUnlock(
      type: $checkedConvert('type', (v) => $enumDecode(_$UnlockTypeEnumMap, v)),
      count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 0),
    );
    return val;
  },
);

Map<String, dynamic> _$BoardUnlockToJson(_BoardUnlock instance) =>
    <String, dynamic>{
      'type': _$UnlockTypeEnumMap[instance.type]!,
      'count': instance.count,
    };

const _$UnlockTypeEnumMap = {
  UnlockType.none: 'none',
  UnlockType.snakesWins: 'snakesWins',
};

_BoardDef _$BoardDefFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_BoardDef', json, ($checkedConvert) {
      final val = _BoardDef(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        theme: $checkedConvert('theme', (v) => v as String),
        size: $checkedConvert('size', (v) => (v as num).toInt()),
        unlock: $checkedConvert(
          'unlock',
          (v) => BoardUnlock.fromJson(v as Map<String, dynamic>),
        ),
        jumps: $checkedConvert(
          'jumps',
          (v) => (v as List<dynamic>)
              .map((e) => Jump.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BoardDefToJson(_BoardDef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'theme': instance.theme,
  'size': instance.size,
  'unlock': instance.unlock.toJson(),
  'jumps': instance.jumps.map((e) => e.toJson()).toList(),
};
