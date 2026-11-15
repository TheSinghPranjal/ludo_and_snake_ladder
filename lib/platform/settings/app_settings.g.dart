// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AppSettings', json, ($checkedConvert) {
      final val = _AppSettings(
        appearance: $checkedConvert(
          'appearance',
          (v) =>
              $enumDecodeNullable(_$AppearanceModeEnumMap, v) ??
              AppearanceMode.system,
        ),
        sound: $checkedConvert('sound', (v) => v as bool? ?? true),
        music: $checkedConvert('music', (v) => v as bool? ?? true),
        haptics: $checkedConvert('haptics', (v) => v as bool? ?? true),
        speed: $checkedConvert(
          'speed',
          (v) =>
              $enumDecodeNullable(_$AnimationSpeedEnumMap, v) ??
              AnimationSpeed.normal,
        ),
        localTimer: $checkedConvert('localTimer', (v) => v as bool? ?? false),
        defaultAi: $checkedConvert(
          'defaultAi',
          (v) => $enumDecodeNullable(_$AiLevelEnumMap, v) ?? AiLevel.normal,
        ),
      );
      return val;
    });

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'appearance': _$AppearanceModeEnumMap[instance.appearance]!,
      'sound': instance.sound,
      'music': instance.music,
      'haptics': instance.haptics,
      'speed': _$AnimationSpeedEnumMap[instance.speed]!,
      'localTimer': instance.localTimer,
      'defaultAi': _$AiLevelEnumMap[instance.defaultAi]!,
    };

const _$AppearanceModeEnumMap = {
  AppearanceMode.system: 'system',
  AppearanceMode.light: 'light',
  AppearanceMode.dark: 'dark',
};

const _$AnimationSpeedEnumMap = {
  AnimationSpeed.normal: 'normal',
  AnimationSpeed.fast: 'fast',
};

const _$AiLevelEnumMap = {AiLevel.easy: 'easy', AiLevel.normal: 'normal'};

_Profile _$ProfileFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Profile', json, ($checkedConvert) {
      final val = _Profile(
        name: $checkedConvert('name', (v) => v as String? ?? 'Player'),
        avatar: $checkedConvert('avatar', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'name': instance.name,
  'avatar': instance.avatar,
};
