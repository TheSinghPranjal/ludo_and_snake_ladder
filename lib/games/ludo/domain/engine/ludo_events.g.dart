// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ludo_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiceRolled _$DiceRolledFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DiceRolled', json, ($checkedConvert) {
      final val = DiceRolled(
        playerId: $checkedConvert('playerId', (v) => v as String),
        value: $checkedConvert('value', (v) => (v as num).toInt()),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$DiceRolledToJson(DiceRolled instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'value': instance.value,
      'kind': instance.$type,
    };

TokenMoved _$TokenMovedFromJson(Map<String, dynamic> json) => $checkedCreate(
  'TokenMoved',
  json,
  ($checkedConvert) {
    final val = TokenMoved(
      playerId: $checkedConvert('playerId', (v) => v as String),
      tokenId: $checkedConvert('tokenId', (v) => (v as num).toInt()),
      fromRel: $checkedConvert('fromRel', (v) => (v as num).toInt()),
      toRel: $checkedConvert('toRel', (v) => (v as num).toInt()),
      path: $checkedConvert(
        'path',
        (v) => (v as List<dynamic>)
            .map(
              (e) =>
                  (e as List<dynamic>).map((e) => (e as num).toInt()).toList(),
            )
            .toList(),
      ),
      $type: $checkedConvert('kind', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {r'$type': 'kind'},
);

Map<String, dynamic> _$TokenMovedToJson(TokenMoved instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'tokenId': instance.tokenId,
      'fromRel': instance.fromRel,
      'toRel': instance.toRel,
      'path': instance.path,
      'kind': instance.$type,
    };

TokenCaptured _$TokenCapturedFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TokenCaptured', json, ($checkedConvert) {
      final val = TokenCaptured(
        byPlayerId: $checkedConvert('byPlayerId', (v) => v as String),
        playerId: $checkedConvert('playerId', (v) => v as String),
        tokenId: $checkedConvert('tokenId', (v) => (v as num).toInt()),
        fromRel: $checkedConvert('fromRel', (v) => (v as num).toInt()),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$TokenCapturedToJson(TokenCaptured instance) =>
    <String, dynamic>{
      'byPlayerId': instance.byPlayerId,
      'playerId': instance.playerId,
      'tokenId': instance.tokenId,
      'fromRel': instance.fromRel,
      'kind': instance.$type,
    };

TokenHome _$TokenHomeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TokenHome', json, ($checkedConvert) {
      final val = TokenHome(
        playerId: $checkedConvert('playerId', (v) => v as String),
        tokenId: $checkedConvert('tokenId', (v) => (v as num).toInt()),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$TokenHomeToJson(TokenHome instance) => <String, dynamic>{
  'playerId': instance.playerId,
  'tokenId': instance.tokenId,
  'kind': instance.$type,
};

ExtraRoll _$ExtraRollFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ExtraRoll', json, ($checkedConvert) {
      final val = ExtraRoll(
        playerId: $checkedConvert('playerId', (v) => v as String),
        reason: $checkedConvert(
          'reason',
          (v) => $enumDecode(_$ExtraRollReasonEnumMap, v),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$ExtraRollToJson(ExtraRoll instance) => <String, dynamic>{
  'playerId': instance.playerId,
  'reason': _$ExtraRollReasonEnumMap[instance.reason]!,
  'kind': instance.$type,
};

const _$ExtraRollReasonEnumMap = {
  ExtraRollReason.six: 'six',
  ExtraRollReason.capture: 'capture',
  ExtraRollReason.home: 'home',
};

ThreeSixesForfeit _$ThreeSixesForfeitFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ThreeSixesForfeit', json, ($checkedConvert) {
      final val = ThreeSixesForfeit(
        playerId: $checkedConvert('playerId', (v) => v as String),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$ThreeSixesForfeitToJson(ThreeSixesForfeit instance) =>
    <String, dynamic>{'playerId': instance.playerId, 'kind': instance.$type};

PlayerFinished _$PlayerFinishedFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlayerFinished', json, ($checkedConvert) {
      final val = PlayerFinished(
        playerId: $checkedConvert('playerId', (v) => v as String),
        rank: $checkedConvert('rank', (v) => (v as num).toInt()),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$PlayerFinishedToJson(PlayerFinished instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'rank': instance.rank,
      'kind': instance.$type,
    };

PlayerRemoved _$PlayerRemovedFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlayerRemoved', json, ($checkedConvert) {
      final val = PlayerRemoved(
        playerId: $checkedConvert('playerId', (v) => v as String),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$PlayerRemovedToJson(PlayerRemoved instance) =>
    <String, dynamic>{'playerId': instance.playerId, 'kind': instance.$type};

TurnPassed _$TurnPassedFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TurnPassed', json, ($checkedConvert) {
      final val = TurnPassed(
        from: $checkedConvert('from', (v) => v as String),
        to: $checkedConvert('to', (v) => v as String),
        reason: $checkedConvert(
          'reason',
          (v) => $enumDecode(_$PassReasonEnumMap, v),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$TurnPassedToJson(TurnPassed instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'reason': _$PassReasonEnumMap[instance.reason]!,
      'kind': instance.$type,
    };

const _$PassReasonEnumMap = {
  PassReason.noMoves: 'noMoves',
  PassReason.moved: 'moved',
  PassReason.removed: 'removed',
  PassReason.finished: 'finished',
  PassReason.threeSixes: 'threeSixes',
};

GameOver _$GameOverFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GameOver', json, ($checkedConvert) {
      final val = GameOver(
        ranking: $checkedConvert(
          'ranking',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$GameOverToJson(GameOver instance) => <String, dynamic>{
  'ranking': instance.ranking,
  'kind': instance.$type,
};
