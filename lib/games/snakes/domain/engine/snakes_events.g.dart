// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snakes_events.dart';

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

TokenStepped _$TokenSteppedFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TokenStepped', json, ($checkedConvert) {
      final val = TokenStepped(
        playerId: $checkedConvert('playerId', (v) => v as String),
        from: $checkedConvert('from', (v) => (v as num).toInt()),
        path: $checkedConvert(
          'path',
          (v) => (v as List<dynamic>).map((e) => (e as num).toInt()).toList(),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$TokenSteppedToJson(TokenStepped instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'from': instance.from,
      'path': instance.path,
      'kind': instance.$type,
    };

JumpTaken _$JumpTakenFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JumpTaken', json, ($checkedConvert) {
      final val = JumpTaken(
        playerId: $checkedConvert('playerId', (v) => v as String),
        jumpId: $checkedConvert('jumpId', (v) => v as String),
        type: $checkedConvert('type', (v) => $enumDecode(_$JumpTypeEnumMap, v)),
        from: $checkedConvert('from', (v) => (v as num).toInt()),
        to: $checkedConvert('to', (v) => (v as num).toInt()),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$JumpTakenToJson(JumpTaken instance) => <String, dynamic>{
  'playerId': instance.playerId,
  'jumpId': instance.jumpId,
  'type': _$JumpTypeEnumMap[instance.type]!,
  'from': instance.from,
  'to': instance.to,
  'kind': instance.$type,
};

const _$JumpTypeEnumMap = {JumpType.ladder: 'ladder', JumpType.snake: 'snake'};

MoveBlocked _$MoveBlockedFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MoveBlocked', json, ($checkedConvert) {
      final val = MoveBlocked(
        playerId: $checkedConvert('playerId', (v) => v as String),
        reason: $checkedConvert(
          'reason',
          (v) => $enumDecode(_$BlockReasonEnumMap, v),
        ),
        need: $checkedConvert('need', (v) => (v as num?)?.toInt()),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$MoveBlockedToJson(MoveBlocked instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'reason': _$BlockReasonEnumMap[instance.reason]!,
      'need': instance.need,
      'kind': instance.$type,
    };

const _$BlockReasonEnumMap = {
  BlockReason.needSix: 'needSix',
  BlockReason.overshoot: 'overshoot',
};

Bounced _$BouncedFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Bounced', json, ($checkedConvert) {
      final val = Bounced(
        playerId: $checkedConvert('playerId', (v) => v as String),
        from: $checkedConvert('from', (v) => (v as num).toInt()),
        path: $checkedConvert(
          'path',
          (v) => (v as List<dynamic>).map((e) => (e as num).toInt()).toList(),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$BouncedToJson(Bounced instance) => <String, dynamic>{
  'playerId': instance.playerId,
  'from': instance.from,
  'path': instance.path,
  'kind': instance.$type,
};

Captured _$CapturedFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Captured', json, ($checkedConvert) {
      final val = Captured(
        playerId: $checkedConvert('playerId', (v) => v as String),
        victims: $checkedConvert(
          'victims',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        square: $checkedConvert('square', (v) => (v as num).toInt()),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$CapturedToJson(Captured instance) => <String, dynamic>{
  'playerId': instance.playerId,
  'victims': instance.victims,
  'square': instance.square,
  'kind': instance.$type,
};

ExtraRoll _$ExtraRollFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ExtraRoll', json, ($checkedConvert) {
      final val = ExtraRoll(
        playerId: $checkedConvert('playerId', (v) => v as String),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$ExtraRollToJson(ExtraRoll instance) => <String, dynamic>{
  'playerId': instance.playerId,
  'kind': instance.$type,
};

ThreeSixesPenalty _$ThreeSixesPenaltyFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ThreeSixesPenalty', json, ($checkedConvert) {
      final val = ThreeSixesPenalty(
        playerId: $checkedConvert('playerId', (v) => v as String),
        from: $checkedConvert('from', (v) => (v as num).toInt()),
        to: $checkedConvert('to', (v) => (v as num).toInt()),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$ThreeSixesPenaltyToJson(ThreeSixesPenalty instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'from': instance.from,
      'to': instance.to,
      'kind': instance.$type,
    };

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
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$TurnPassedToJson(TurnPassed instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'kind': instance.$type,
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
