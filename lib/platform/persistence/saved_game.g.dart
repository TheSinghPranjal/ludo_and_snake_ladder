// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavedGame _$SavedGameFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SavedGame', json, ($checkedConvert) {
      final val = _SavedGame(
        schemaVersion: $checkedConvert(
          'schemaVersion',
          (v) => (v as num).toInt(),
        ),
        game: $checkedConvert('game', (v) => $enumDecode(_$GameTypeEnumMap, v)),
        mode: $checkedConvert('mode', (v) => $enumDecode(_$GameModeEnumMap, v)),
        config: $checkedConvert('config', (v) => v as Map<String, dynamic>),
        state: $checkedConvert('state', (v) => v as Map<String, dynamic>),
        me: $checkedConvert('me', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SavedGameToJson(_SavedGame instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'game': _$GameTypeEnumMap[instance.game]!,
      'mode': _$GameModeEnumMap[instance.mode]!,
      'config': instance.config,
      'state': instance.state,
      'me': instance.me,
    };

const _$GameTypeEnumMap = {GameType.snakes: 'snakes', GameType.ludo: 'ludo'};

const _$GameModeEnumMap = {
  GameMode.local: 'local',
  GameMode.ai: 'ai',
  GameMode.online: 'online',
};
