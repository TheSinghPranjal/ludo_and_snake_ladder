// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jump.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Jump _$JumpFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Jump', json, ($checkedConvert) {
      final val = _Jump(
        id: $checkedConvert('id', (v) => v as String),
        type: $checkedConvert('type', (v) => $enumDecode(_$JumpTypeEnumMap, v)),
        from: $checkedConvert('from', (v) => (v as num).toInt()),
        to: $checkedConvert('to', (v) => (v as num).toInt()),
        rank: $checkedConvert('rank', (v) => (v as num?)?.toInt()),
        path: $checkedConvert(
          'path',
          (v) => (v as List<dynamic>?)
              ?.map(
                (e) => (e as List<dynamic>)
                    .map((e) => (e as num).toDouble())
                    .toList(),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$JumpToJson(_Jump instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$JumpTypeEnumMap[instance.type]!,
  'from': instance.from,
  'to': instance.to,
  'rank': instance.rank,
  'path': instance.path,
};

const _$JumpTypeEnumMap = {JumpType.ladder: 'ladder', JumpType.snake: 'snake'};
