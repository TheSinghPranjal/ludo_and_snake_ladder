// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameStats _$GameStatsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GameStats', json, ($checkedConvert) {
      final val = _GameStats(
        played: $checkedConvert('played', (v) => (v as num?)?.toInt() ?? 0),
        wins: $checkedConvert(
          'wins',
          (v) =>
              (v as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const <String, int>{},
        ),
        values: $checkedConvert(
          'values',
          (v) =>
              (v as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as num),
              ) ??
              const <String, num>{},
        ),
      );
      return val;
    });

Map<String, dynamic> _$GameStatsToJson(_GameStats instance) =>
    <String, dynamic>{
      'played': instance.played,
      'wins': instance.wins,
      'values': instance.values,
    };
