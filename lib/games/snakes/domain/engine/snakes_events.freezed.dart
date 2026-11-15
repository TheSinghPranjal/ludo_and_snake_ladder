// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snakes_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
SnakesEvent _$SnakesEventFromJson(
  Map<String, dynamic> json
) {
        switch (json['kind']) {
                  case 'diceRolled':
          return DiceRolled.fromJson(
            json
          );
                case 'tokenStepped':
          return TokenStepped.fromJson(
            json
          );
                case 'jumpTaken':
          return JumpTaken.fromJson(
            json
          );
                case 'moveBlocked':
          return MoveBlocked.fromJson(
            json
          );
                case 'bounced':
          return Bounced.fromJson(
            json
          );
                case 'captured':
          return Captured.fromJson(
            json
          );
                case 'extraRoll':
          return ExtraRoll.fromJson(
            json
          );
                case 'threeSixesPenalty':
          return ThreeSixesPenalty.fromJson(
            json
          );
                case 'playerFinished':
          return PlayerFinished.fromJson(
            json
          );
                case 'playerRemoved':
          return PlayerRemoved.fromJson(
            json
          );
                case 'turnPassed':
          return TurnPassed.fromJson(
            json
          );
                case 'gameOver':
          return GameOver.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'kind',
  'SnakesEvent',
  'Invalid union type "${json['kind']}"!'
);
        }
      
}

/// @nodoc
mixin _$SnakesEvent {



  /// Serializes this SnakesEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnakesEvent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SnakesEvent()';
}


}

/// @nodoc
class $SnakesEventCopyWith<$Res>  {
$SnakesEventCopyWith(SnakesEvent _, $Res Function(SnakesEvent) __);
}


/// Adds pattern-matching-related methods to [SnakesEvent].
extension SnakesEventPatterns on SnakesEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DiceRolled value)?  diceRolled,TResult Function( TokenStepped value)?  tokenStepped,TResult Function( JumpTaken value)?  jumpTaken,TResult Function( MoveBlocked value)?  moveBlocked,TResult Function( Bounced value)?  bounced,TResult Function( Captured value)?  captured,TResult Function( ExtraRoll value)?  extraRoll,TResult Function( ThreeSixesPenalty value)?  threeSixesPenalty,TResult Function( PlayerFinished value)?  playerFinished,TResult Function( PlayerRemoved value)?  playerRemoved,TResult Function( TurnPassed value)?  turnPassed,TResult Function( GameOver value)?  gameOver,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DiceRolled() when diceRolled != null:
return diceRolled(_that);case TokenStepped() when tokenStepped != null:
return tokenStepped(_that);case JumpTaken() when jumpTaken != null:
return jumpTaken(_that);case MoveBlocked() when moveBlocked != null:
return moveBlocked(_that);case Bounced() when bounced != null:
return bounced(_that);case Captured() when captured != null:
return captured(_that);case ExtraRoll() when extraRoll != null:
return extraRoll(_that);case ThreeSixesPenalty() when threeSixesPenalty != null:
return threeSixesPenalty(_that);case PlayerFinished() when playerFinished != null:
return playerFinished(_that);case PlayerRemoved() when playerRemoved != null:
return playerRemoved(_that);case TurnPassed() when turnPassed != null:
return turnPassed(_that);case GameOver() when gameOver != null:
return gameOver(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DiceRolled value)  diceRolled,required TResult Function( TokenStepped value)  tokenStepped,required TResult Function( JumpTaken value)  jumpTaken,required TResult Function( MoveBlocked value)  moveBlocked,required TResult Function( Bounced value)  bounced,required TResult Function( Captured value)  captured,required TResult Function( ExtraRoll value)  extraRoll,required TResult Function( ThreeSixesPenalty value)  threeSixesPenalty,required TResult Function( PlayerFinished value)  playerFinished,required TResult Function( PlayerRemoved value)  playerRemoved,required TResult Function( TurnPassed value)  turnPassed,required TResult Function( GameOver value)  gameOver,}){
final _that = this;
switch (_that) {
case DiceRolled():
return diceRolled(_that);case TokenStepped():
return tokenStepped(_that);case JumpTaken():
return jumpTaken(_that);case MoveBlocked():
return moveBlocked(_that);case Bounced():
return bounced(_that);case Captured():
return captured(_that);case ExtraRoll():
return extraRoll(_that);case ThreeSixesPenalty():
return threeSixesPenalty(_that);case PlayerFinished():
return playerFinished(_that);case PlayerRemoved():
return playerRemoved(_that);case TurnPassed():
return turnPassed(_that);case GameOver():
return gameOver(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DiceRolled value)?  diceRolled,TResult? Function( TokenStepped value)?  tokenStepped,TResult? Function( JumpTaken value)?  jumpTaken,TResult? Function( MoveBlocked value)?  moveBlocked,TResult? Function( Bounced value)?  bounced,TResult? Function( Captured value)?  captured,TResult? Function( ExtraRoll value)?  extraRoll,TResult? Function( ThreeSixesPenalty value)?  threeSixesPenalty,TResult? Function( PlayerFinished value)?  playerFinished,TResult? Function( PlayerRemoved value)?  playerRemoved,TResult? Function( TurnPassed value)?  turnPassed,TResult? Function( GameOver value)?  gameOver,}){
final _that = this;
switch (_that) {
case DiceRolled() when diceRolled != null:
return diceRolled(_that);case TokenStepped() when tokenStepped != null:
return tokenStepped(_that);case JumpTaken() when jumpTaken != null:
return jumpTaken(_that);case MoveBlocked() when moveBlocked != null:
return moveBlocked(_that);case Bounced() when bounced != null:
return bounced(_that);case Captured() when captured != null:
return captured(_that);case ExtraRoll() when extraRoll != null:
return extraRoll(_that);case ThreeSixesPenalty() when threeSixesPenalty != null:
return threeSixesPenalty(_that);case PlayerFinished() when playerFinished != null:
return playerFinished(_that);case PlayerRemoved() when playerRemoved != null:
return playerRemoved(_that);case TurnPassed() when turnPassed != null:
return turnPassed(_that);case GameOver() when gameOver != null:
return gameOver(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PlayerId playerId,  int value)?  diceRolled,TResult Function( PlayerId playerId,  int from,  List<int> path)?  tokenStepped,TResult Function( PlayerId playerId,  String jumpId,  JumpType type,  int from,  int to)?  jumpTaken,TResult Function( PlayerId playerId,  BlockReason reason,  int? need)?  moveBlocked,TResult Function( PlayerId playerId,  int from,  List<int> path)?  bounced,TResult Function( PlayerId playerId,  List<PlayerId> victims,  int square)?  captured,TResult Function( PlayerId playerId)?  extraRoll,TResult Function( PlayerId playerId,  int from,  int to)?  threeSixesPenalty,TResult Function( PlayerId playerId,  int rank)?  playerFinished,TResult Function( PlayerId playerId)?  playerRemoved,TResult Function( PlayerId from,  PlayerId to)?  turnPassed,TResult Function( List<PlayerId> ranking)?  gameOver,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DiceRolled() when diceRolled != null:
return diceRolled(_that.playerId,_that.value);case TokenStepped() when tokenStepped != null:
return tokenStepped(_that.playerId,_that.from,_that.path);case JumpTaken() when jumpTaken != null:
return jumpTaken(_that.playerId,_that.jumpId,_that.type,_that.from,_that.to);case MoveBlocked() when moveBlocked != null:
return moveBlocked(_that.playerId,_that.reason,_that.need);case Bounced() when bounced != null:
return bounced(_that.playerId,_that.from,_that.path);case Captured() when captured != null:
return captured(_that.playerId,_that.victims,_that.square);case ExtraRoll() when extraRoll != null:
return extraRoll(_that.playerId);case ThreeSixesPenalty() when threeSixesPenalty != null:
return threeSixesPenalty(_that.playerId,_that.from,_that.to);case PlayerFinished() when playerFinished != null:
return playerFinished(_that.playerId,_that.rank);case PlayerRemoved() when playerRemoved != null:
return playerRemoved(_that.playerId);case TurnPassed() when turnPassed != null:
return turnPassed(_that.from,_that.to);case GameOver() when gameOver != null:
return gameOver(_that.ranking);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PlayerId playerId,  int value)  diceRolled,required TResult Function( PlayerId playerId,  int from,  List<int> path)  tokenStepped,required TResult Function( PlayerId playerId,  String jumpId,  JumpType type,  int from,  int to)  jumpTaken,required TResult Function( PlayerId playerId,  BlockReason reason,  int? need)  moveBlocked,required TResult Function( PlayerId playerId,  int from,  List<int> path)  bounced,required TResult Function( PlayerId playerId,  List<PlayerId> victims,  int square)  captured,required TResult Function( PlayerId playerId)  extraRoll,required TResult Function( PlayerId playerId,  int from,  int to)  threeSixesPenalty,required TResult Function( PlayerId playerId,  int rank)  playerFinished,required TResult Function( PlayerId playerId)  playerRemoved,required TResult Function( PlayerId from,  PlayerId to)  turnPassed,required TResult Function( List<PlayerId> ranking)  gameOver,}) {final _that = this;
switch (_that) {
case DiceRolled():
return diceRolled(_that.playerId,_that.value);case TokenStepped():
return tokenStepped(_that.playerId,_that.from,_that.path);case JumpTaken():
return jumpTaken(_that.playerId,_that.jumpId,_that.type,_that.from,_that.to);case MoveBlocked():
return moveBlocked(_that.playerId,_that.reason,_that.need);case Bounced():
return bounced(_that.playerId,_that.from,_that.path);case Captured():
return captured(_that.playerId,_that.victims,_that.square);case ExtraRoll():
return extraRoll(_that.playerId);case ThreeSixesPenalty():
return threeSixesPenalty(_that.playerId,_that.from,_that.to);case PlayerFinished():
return playerFinished(_that.playerId,_that.rank);case PlayerRemoved():
return playerRemoved(_that.playerId);case TurnPassed():
return turnPassed(_that.from,_that.to);case GameOver():
return gameOver(_that.ranking);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PlayerId playerId,  int value)?  diceRolled,TResult? Function( PlayerId playerId,  int from,  List<int> path)?  tokenStepped,TResult? Function( PlayerId playerId,  String jumpId,  JumpType type,  int from,  int to)?  jumpTaken,TResult? Function( PlayerId playerId,  BlockReason reason,  int? need)?  moveBlocked,TResult? Function( PlayerId playerId,  int from,  List<int> path)?  bounced,TResult? Function( PlayerId playerId,  List<PlayerId> victims,  int square)?  captured,TResult? Function( PlayerId playerId)?  extraRoll,TResult? Function( PlayerId playerId,  int from,  int to)?  threeSixesPenalty,TResult? Function( PlayerId playerId,  int rank)?  playerFinished,TResult? Function( PlayerId playerId)?  playerRemoved,TResult? Function( PlayerId from,  PlayerId to)?  turnPassed,TResult? Function( List<PlayerId> ranking)?  gameOver,}) {final _that = this;
switch (_that) {
case DiceRolled() when diceRolled != null:
return diceRolled(_that.playerId,_that.value);case TokenStepped() when tokenStepped != null:
return tokenStepped(_that.playerId,_that.from,_that.path);case JumpTaken() when jumpTaken != null:
return jumpTaken(_that.playerId,_that.jumpId,_that.type,_that.from,_that.to);case MoveBlocked() when moveBlocked != null:
return moveBlocked(_that.playerId,_that.reason,_that.need);case Bounced() when bounced != null:
return bounced(_that.playerId,_that.from,_that.path);case Captured() when captured != null:
return captured(_that.playerId,_that.victims,_that.square);case ExtraRoll() when extraRoll != null:
return extraRoll(_that.playerId);case ThreeSixesPenalty() when threeSixesPenalty != null:
return threeSixesPenalty(_that.playerId,_that.from,_that.to);case PlayerFinished() when playerFinished != null:
return playerFinished(_that.playerId,_that.rank);case PlayerRemoved() when playerRemoved != null:
return playerRemoved(_that.playerId);case TurnPassed() when turnPassed != null:
return turnPassed(_that.from,_that.to);case GameOver() when gameOver != null:
return gameOver(_that.ranking);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class DiceRolled implements SnakesEvent {
  const DiceRolled({required this.playerId, required this.value, final  String? $type}): $type = $type ?? 'diceRolled';
  factory DiceRolled.fromJson(Map<String, dynamic> json) => _$DiceRolledFromJson(json);

 final  PlayerId playerId;
 final  int value;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiceRolledCopyWith<DiceRolled> get copyWith => _$DiceRolledCopyWithImpl<DiceRolled>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiceRolledToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiceRolled&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,value);

@override
String toString() {
  return 'SnakesEvent.diceRolled(playerId: $playerId, value: $value)';
}


}

/// @nodoc
abstract mixin class $DiceRolledCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $DiceRolledCopyWith(DiceRolled value, $Res Function(DiceRolled) _then) = _$DiceRolledCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, int value
});




}
/// @nodoc
class _$DiceRolledCopyWithImpl<$Res>
    implements $DiceRolledCopyWith<$Res> {
  _$DiceRolledCopyWithImpl(this._self, this._then);

  final DiceRolled _self;
  final $Res Function(DiceRolled) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? value = null,}) {
  return _then(DiceRolled(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TokenStepped implements SnakesEvent {
  const TokenStepped({required this.playerId, required this.from, required final  List<int> path, final  String? $type}): _path = path,$type = $type ?? 'tokenStepped';
  factory TokenStepped.fromJson(Map<String, dynamic> json) => _$TokenSteppedFromJson(json);

 final  PlayerId playerId;
 final  int from;
 final  List<int> _path;
 List<int> get path {
  if (_path is EqualUnmodifiableListView) return _path;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_path);
}


@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenSteppedCopyWith<TokenStepped> get copyWith => _$TokenSteppedCopyWithImpl<TokenStepped>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenSteppedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenStepped&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.from, from) || other.from == from)&&const DeepCollectionEquality().equals(other._path, _path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,from,const DeepCollectionEquality().hash(_path));

@override
String toString() {
  return 'SnakesEvent.tokenStepped(playerId: $playerId, from: $from, path: $path)';
}


}

/// @nodoc
abstract mixin class $TokenSteppedCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $TokenSteppedCopyWith(TokenStepped value, $Res Function(TokenStepped) _then) = _$TokenSteppedCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, int from, List<int> path
});




}
/// @nodoc
class _$TokenSteppedCopyWithImpl<$Res>
    implements $TokenSteppedCopyWith<$Res> {
  _$TokenSteppedCopyWithImpl(this._self, this._then);

  final TokenStepped _self;
  final $Res Function(TokenStepped) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? from = null,Object? path = null,}) {
  return _then(TokenStepped(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self._path : path // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class JumpTaken implements SnakesEvent {
  const JumpTaken({required this.playerId, required this.jumpId, required this.type, required this.from, required this.to, final  String? $type}): $type = $type ?? 'jumpTaken';
  factory JumpTaken.fromJson(Map<String, dynamic> json) => _$JumpTakenFromJson(json);

 final  PlayerId playerId;
 final  String jumpId;
 final  JumpType type;
 final  int from;
 final  int to;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JumpTakenCopyWith<JumpTaken> get copyWith => _$JumpTakenCopyWithImpl<JumpTaken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JumpTakenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JumpTaken&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.jumpId, jumpId) || other.jumpId == jumpId)&&(identical(other.type, type) || other.type == type)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,jumpId,type,from,to);

@override
String toString() {
  return 'SnakesEvent.jumpTaken(playerId: $playerId, jumpId: $jumpId, type: $type, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $JumpTakenCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $JumpTakenCopyWith(JumpTaken value, $Res Function(JumpTaken) _then) = _$JumpTakenCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, String jumpId, JumpType type, int from, int to
});




}
/// @nodoc
class _$JumpTakenCopyWithImpl<$Res>
    implements $JumpTakenCopyWith<$Res> {
  _$JumpTakenCopyWithImpl(this._self, this._then);

  final JumpTaken _self;
  final $Res Function(JumpTaken) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? jumpId = null,Object? type = null,Object? from = null,Object? to = null,}) {
  return _then(JumpTaken(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,jumpId: null == jumpId ? _self.jumpId : jumpId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as JumpType,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MoveBlocked implements SnakesEvent {
  const MoveBlocked({required this.playerId, required this.reason, this.need, final  String? $type}): $type = $type ?? 'moveBlocked';
  factory MoveBlocked.fromJson(Map<String, dynamic> json) => _$MoveBlockedFromJson(json);

 final  PlayerId playerId;
 final  BlockReason reason;
 final  int? need;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveBlockedCopyWith<MoveBlocked> get copyWith => _$MoveBlockedCopyWithImpl<MoveBlocked>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoveBlockedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MoveBlocked&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.need, need) || other.need == need));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,reason,need);

@override
String toString() {
  return 'SnakesEvent.moveBlocked(playerId: $playerId, reason: $reason, need: $need)';
}


}

/// @nodoc
abstract mixin class $MoveBlockedCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $MoveBlockedCopyWith(MoveBlocked value, $Res Function(MoveBlocked) _then) = _$MoveBlockedCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, BlockReason reason, int? need
});




}
/// @nodoc
class _$MoveBlockedCopyWithImpl<$Res>
    implements $MoveBlockedCopyWith<$Res> {
  _$MoveBlockedCopyWithImpl(this._self, this._then);

  final MoveBlocked _self;
  final $Res Function(MoveBlocked) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? reason = null,Object? need = freezed,}) {
  return _then(MoveBlocked(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as BlockReason,need: freezed == need ? _self.need : need // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class Bounced implements SnakesEvent {
  const Bounced({required this.playerId, required this.from, required final  List<int> path, final  String? $type}): _path = path,$type = $type ?? 'bounced';
  factory Bounced.fromJson(Map<String, dynamic> json) => _$BouncedFromJson(json);

 final  PlayerId playerId;
 final  int from;
 final  List<int> _path;
 List<int> get path {
  if (_path is EqualUnmodifiableListView) return _path;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_path);
}


@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BouncedCopyWith<Bounced> get copyWith => _$BouncedCopyWithImpl<Bounced>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BouncedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bounced&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.from, from) || other.from == from)&&const DeepCollectionEquality().equals(other._path, _path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,from,const DeepCollectionEquality().hash(_path));

@override
String toString() {
  return 'SnakesEvent.bounced(playerId: $playerId, from: $from, path: $path)';
}


}

/// @nodoc
abstract mixin class $BouncedCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $BouncedCopyWith(Bounced value, $Res Function(Bounced) _then) = _$BouncedCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, int from, List<int> path
});




}
/// @nodoc
class _$BouncedCopyWithImpl<$Res>
    implements $BouncedCopyWith<$Res> {
  _$BouncedCopyWithImpl(this._self, this._then);

  final Bounced _self;
  final $Res Function(Bounced) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? from = null,Object? path = null,}) {
  return _then(Bounced(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self._path : path // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class Captured implements SnakesEvent {
  const Captured({required this.playerId, required final  List<PlayerId> victims, required this.square, final  String? $type}): _victims = victims,$type = $type ?? 'captured';
  factory Captured.fromJson(Map<String, dynamic> json) => _$CapturedFromJson(json);

 final  PlayerId playerId;
 final  List<PlayerId> _victims;
 List<PlayerId> get victims {
  if (_victims is EqualUnmodifiableListView) return _victims;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_victims);
}

 final  int square;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CapturedCopyWith<Captured> get copyWith => _$CapturedCopyWithImpl<Captured>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CapturedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Captured&&(identical(other.playerId, playerId) || other.playerId == playerId)&&const DeepCollectionEquality().equals(other._victims, _victims)&&(identical(other.square, square) || other.square == square));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,const DeepCollectionEquality().hash(_victims),square);

@override
String toString() {
  return 'SnakesEvent.captured(playerId: $playerId, victims: $victims, square: $square)';
}


}

/// @nodoc
abstract mixin class $CapturedCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $CapturedCopyWith(Captured value, $Res Function(Captured) _then) = _$CapturedCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, List<PlayerId> victims, int square
});




}
/// @nodoc
class _$CapturedCopyWithImpl<$Res>
    implements $CapturedCopyWith<$Res> {
  _$CapturedCopyWithImpl(this._self, this._then);

  final Captured _self;
  final $Res Function(Captured) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? victims = null,Object? square = null,}) {
  return _then(Captured(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,victims: null == victims ? _self._victims : victims // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,square: null == square ? _self.square : square // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ExtraRoll implements SnakesEvent {
  const ExtraRoll({required this.playerId, final  String? $type}): $type = $type ?? 'extraRoll';
  factory ExtraRoll.fromJson(Map<String, dynamic> json) => _$ExtraRollFromJson(json);

 final  PlayerId playerId;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtraRollCopyWith<ExtraRoll> get copyWith => _$ExtraRollCopyWithImpl<ExtraRoll>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtraRollToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtraRoll&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId);

@override
String toString() {
  return 'SnakesEvent.extraRoll(playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $ExtraRollCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $ExtraRollCopyWith(ExtraRoll value, $Res Function(ExtraRoll) _then) = _$ExtraRollCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId
});




}
/// @nodoc
class _$ExtraRollCopyWithImpl<$Res>
    implements $ExtraRollCopyWith<$Res> {
  _$ExtraRollCopyWithImpl(this._self, this._then);

  final ExtraRoll _self;
  final $Res Function(ExtraRoll) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,}) {
  return _then(ExtraRoll(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ThreeSixesPenalty implements SnakesEvent {
  const ThreeSixesPenalty({required this.playerId, required this.from, required this.to, final  String? $type}): $type = $type ?? 'threeSixesPenalty';
  factory ThreeSixesPenalty.fromJson(Map<String, dynamic> json) => _$ThreeSixesPenaltyFromJson(json);

 final  PlayerId playerId;
 final  int from;
 final  int to;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreeSixesPenaltyCopyWith<ThreeSixesPenalty> get copyWith => _$ThreeSixesPenaltyCopyWithImpl<ThreeSixesPenalty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThreeSixesPenaltyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreeSixesPenalty&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,from,to);

@override
String toString() {
  return 'SnakesEvent.threeSixesPenalty(playerId: $playerId, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $ThreeSixesPenaltyCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $ThreeSixesPenaltyCopyWith(ThreeSixesPenalty value, $Res Function(ThreeSixesPenalty) _then) = _$ThreeSixesPenaltyCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, int from, int to
});




}
/// @nodoc
class _$ThreeSixesPenaltyCopyWithImpl<$Res>
    implements $ThreeSixesPenaltyCopyWith<$Res> {
  _$ThreeSixesPenaltyCopyWithImpl(this._self, this._then);

  final ThreeSixesPenalty _self;
  final $Res Function(ThreeSixesPenalty) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? from = null,Object? to = null,}) {
  return _then(ThreeSixesPenalty(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlayerFinished implements SnakesEvent {
  const PlayerFinished({required this.playerId, required this.rank, final  String? $type}): $type = $type ?? 'playerFinished';
  factory PlayerFinished.fromJson(Map<String, dynamic> json) => _$PlayerFinishedFromJson(json);

 final  PlayerId playerId;
 final  int rank;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerFinishedCopyWith<PlayerFinished> get copyWith => _$PlayerFinishedCopyWithImpl<PlayerFinished>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerFinishedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerFinished&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.rank, rank) || other.rank == rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,rank);

@override
String toString() {
  return 'SnakesEvent.playerFinished(playerId: $playerId, rank: $rank)';
}


}

/// @nodoc
abstract mixin class $PlayerFinishedCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $PlayerFinishedCopyWith(PlayerFinished value, $Res Function(PlayerFinished) _then) = _$PlayerFinishedCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, int rank
});




}
/// @nodoc
class _$PlayerFinishedCopyWithImpl<$Res>
    implements $PlayerFinishedCopyWith<$Res> {
  _$PlayerFinishedCopyWithImpl(this._self, this._then);

  final PlayerFinished _self;
  final $Res Function(PlayerFinished) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? rank = null,}) {
  return _then(PlayerFinished(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlayerRemoved implements SnakesEvent {
  const PlayerRemoved({required this.playerId, final  String? $type}): $type = $type ?? 'playerRemoved';
  factory PlayerRemoved.fromJson(Map<String, dynamic> json) => _$PlayerRemovedFromJson(json);

 final  PlayerId playerId;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerRemovedCopyWith<PlayerRemoved> get copyWith => _$PlayerRemovedCopyWithImpl<PlayerRemoved>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerRemovedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerRemoved&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId);

@override
String toString() {
  return 'SnakesEvent.playerRemoved(playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $PlayerRemovedCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $PlayerRemovedCopyWith(PlayerRemoved value, $Res Function(PlayerRemoved) _then) = _$PlayerRemovedCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId
});




}
/// @nodoc
class _$PlayerRemovedCopyWithImpl<$Res>
    implements $PlayerRemovedCopyWith<$Res> {
  _$PlayerRemovedCopyWithImpl(this._self, this._then);

  final PlayerRemoved _self;
  final $Res Function(PlayerRemoved) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,}) {
  return _then(PlayerRemoved(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TurnPassed implements SnakesEvent {
  const TurnPassed({required this.from, required this.to, final  String? $type}): $type = $type ?? 'turnPassed';
  factory TurnPassed.fromJson(Map<String, dynamic> json) => _$TurnPassedFromJson(json);

 final  PlayerId from;
 final  PlayerId to;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TurnPassedCopyWith<TurnPassed> get copyWith => _$TurnPassedCopyWithImpl<TurnPassed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TurnPassedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TurnPassed&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'SnakesEvent.turnPassed(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $TurnPassedCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $TurnPassedCopyWith(TurnPassed value, $Res Function(TurnPassed) _then) = _$TurnPassedCopyWithImpl;
@useResult
$Res call({
 PlayerId from, PlayerId to
});




}
/// @nodoc
class _$TurnPassedCopyWithImpl<$Res>
    implements $TurnPassedCopyWith<$Res> {
  _$TurnPassedCopyWithImpl(this._self, this._then);

  final TurnPassed _self;
  final $Res Function(TurnPassed) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(TurnPassed(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as PlayerId,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as PlayerId,
  ));
}


}

/// @nodoc
@JsonSerializable()

class GameOver implements SnakesEvent {
  const GameOver({required final  List<PlayerId> ranking, final  String? $type}): _ranking = ranking,$type = $type ?? 'gameOver';
  factory GameOver.fromJson(Map<String, dynamic> json) => _$GameOverFromJson(json);

 final  List<PlayerId> _ranking;
 List<PlayerId> get ranking {
  if (_ranking is EqualUnmodifiableListView) return _ranking;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ranking);
}


@JsonKey(name: 'kind')
final String $type;


/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameOverCopyWith<GameOver> get copyWith => _$GameOverCopyWithImpl<GameOver>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameOverToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameOver&&const DeepCollectionEquality().equals(other._ranking, _ranking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ranking));

@override
String toString() {
  return 'SnakesEvent.gameOver(ranking: $ranking)';
}


}

/// @nodoc
abstract mixin class $GameOverCopyWith<$Res> implements $SnakesEventCopyWith<$Res> {
  factory $GameOverCopyWith(GameOver value, $Res Function(GameOver) _then) = _$GameOverCopyWithImpl;
@useResult
$Res call({
 List<PlayerId> ranking
});




}
/// @nodoc
class _$GameOverCopyWithImpl<$Res>
    implements $GameOverCopyWith<$Res> {
  _$GameOverCopyWithImpl(this._self, this._then);

  final GameOver _self;
  final $Res Function(GameOver) _then;

/// Create a copy of SnakesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ranking = null,}) {
  return _then(GameOver(
ranking: null == ranking ? _self._ranking : ranking // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,
  ));
}


}

// dart format on
