// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SeatSpec _$SeatSpecFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_SeatSpec',
  json,
  ($checkedConvert) {
    final val = _SeatSpec(
      name: $checkedConvert('name', (v) => v as String),
      avatar: $checkedConvert('avatar', (v) => (v as num).toInt()),
      color: $checkedConvert(
        'color',
        (v) => $enumDecode(_$PlayerColorEnumMap, v),
      ),
      kind: $checkedConvert('kind', (v) => $enumDecode(_$PlayerKindEnumMap, v)),
      aiLevel: $checkedConvert(
        'aiLevel',
        (v) => $enumDecodeNullable(_$AiLevelEnumMap, v),
      ),
      connection: $checkedConvert(
        'connection',
        (v) =>
            $enumDecodeNullable(_$PlayerConnectionEnumMap, v) ??
            PlayerConnection.local,
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$SeatSpecToJson(_SeatSpec instance) => <String, dynamic>{
  'name': instance.name,
  'avatar': instance.avatar,
  'color': _$PlayerColorEnumMap[instance.color]!,
  'kind': _$PlayerKindEnumMap[instance.kind]!,
  'aiLevel': _$AiLevelEnumMap[instance.aiLevel],
  'connection': _$PlayerConnectionEnumMap[instance.connection]!,
};

const _$PlayerColorEnumMap = {
  PlayerColor.red: 'red',
  PlayerColor.blue: 'blue',
  PlayerColor.yellow: 'yellow',
  PlayerColor.green: 'green',
};

const _$PlayerKindEnumMap = {
  PlayerKind.human: 'human',
  PlayerKind.ai: 'ai',
  PlayerKind.remote: 'remote',
};

const _$AiLevelEnumMap = {AiLevel.easy: 'easy', AiLevel.normal: 'normal'};

const _$PlayerConnectionEnumMap = {
  PlayerConnection.local: 'local',
  PlayerConnection.connected: 'connected',
  PlayerConnection.disconnected: 'disconnected',
  PlayerConnection.removed: 'removed',
};

_Player _$PlayerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_Player', json, ($checkedConvert) {
  final val = _Player(
    id: $checkedConvert('id', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String),
    avatar: $checkedConvert('avatar', (v) => (v as num).toInt()),
    color: $checkedConvert(
      'color',
      (v) => $enumDecode(_$PlayerColorEnumMap, v),
    ),
    kind: $checkedConvert('kind', (v) => $enumDecode(_$PlayerKindEnumMap, v)),
    aiLevel: $checkedConvert(
      'aiLevel',
      (v) => $enumDecodeNullable(_$AiLevelEnumMap, v),
    ),
    connection: $checkedConvert(
      'connection',
      (v) =>
          $enumDecodeNullable(_$PlayerConnectionEnumMap, v) ??
          PlayerConnection.local,
    ),
    finishedRank: $checkedConvert('finishedRank', (v) => (v as num?)?.toInt()),
    stats: $checkedConvert(
      'stats',
      (v) =>
          (v as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as num)) ??
          const <String, num>{},
    ),
  );
  return val;
});

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar': instance.avatar,
  'color': _$PlayerColorEnumMap[instance.color]!,
  'kind': _$PlayerKindEnumMap[instance.kind]!,
  'aiLevel': _$AiLevelEnumMap[instance.aiLevel],
  'connection': _$PlayerConnectionEnumMap[instance.connection]!,
  'finishedRank': instance.finishedRank,
  'stats': instance.stats,
};
