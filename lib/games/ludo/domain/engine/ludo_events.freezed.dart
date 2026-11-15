// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ludo_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
LudoEvent _$LudoEventFromJson(
  Map<String, dynamic> json
) {
        switch (json['kind']) {
                  case 'diceRolled':
          return DiceRolled.fromJson(
            json
          );
                case 'tokenMoved':
          return TokenMoved.fromJson(
            json
          );
                case 'tokenCaptured':
          return TokenCaptured.fromJson(
            json
          );
                case 'tokenHome':
          return TokenHome.fromJson(
            json
          );
                case 'extraRoll':
          return ExtraRoll.fromJson(
            json
          );
                case 'threeSixesForfeit':
          return ThreeSixesForfeit.fromJson(
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
  'LudoEvent',
  'Invalid union type "${json['kind']}"!'
);
        }
      
}

/// @nodoc
mixin _$LudoEvent {



  /// Serializes this LudoEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LudoEvent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LudoEvent()';
}


}

/// @nodoc
class $LudoEventCopyWith<$Res>  {
$LudoEventCopyWith(LudoEvent _, $Res Function(LudoEvent) __);
}


/// Adds pattern-matching-related methods to [LudoEvent].
extension LudoEventPatterns on LudoEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DiceRolled value)?  diceRolled,TResult Function( TokenMoved value)?  tokenMoved,TResult Function( TokenCaptured value)?  tokenCaptured,TResult Function( TokenHome value)?  tokenHome,TResult Function( ExtraRoll value)?  extraRoll,TResult Function( ThreeSixesForfeit value)?  threeSixesForfeit,TResult Function( PlayerFinished value)?  playerFinished,TResult Function( PlayerRemoved value)?  playerRemoved,TResult Function( TurnPassed value)?  turnPassed,TResult Function( GameOver value)?  gameOver,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DiceRolled() when diceRolled != null:
return diceRolled(_that);case TokenMoved() when tokenMoved != null:
return tokenMoved(_that);case TokenCaptured() when tokenCaptured != null:
return tokenCaptured(_that);case TokenHome() when tokenHome != null:
return tokenHome(_that);case ExtraRoll() when extraRoll != null:
return extraRoll(_that);case ThreeSixesForfeit() when threeSixesForfeit != null:
return threeSixesForfeit(_that);case PlayerFinished() when playerFinished != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DiceRolled value)  diceRolled,required TResult Function( TokenMoved value)  tokenMoved,required TResult Function( TokenCaptured value)  tokenCaptured,required TResult Function( TokenHome value)  tokenHome,required TResult Function( ExtraRoll value)  extraRoll,required TResult Function( ThreeSixesForfeit value)  threeSixesForfeit,required TResult Function( PlayerFinished value)  playerFinished,required TResult Function( PlayerRemoved value)  playerRemoved,required TResult Function( TurnPassed value)  turnPassed,required TResult Function( GameOver value)  gameOver,}){
final _that = this;
switch (_that) {
case DiceRolled():
return diceRolled(_that);case TokenMoved():
return tokenMoved(_that);case TokenCaptured():
return tokenCaptured(_that);case TokenHome():
return tokenHome(_that);case ExtraRoll():
return extraRoll(_that);case ThreeSixesForfeit():
return threeSixesForfeit(_that);case PlayerFinished():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DiceRolled value)?  diceRolled,TResult? Function( TokenMoved value)?  tokenMoved,TResult? Function( TokenCaptured value)?  tokenCaptured,TResult? Function( TokenHome value)?  tokenHome,TResult? Function( ExtraRoll value)?  extraRoll,TResult? Function( ThreeSixesForfeit value)?  threeSixesForfeit,TResult? Function( PlayerFinished value)?  playerFinished,TResult? Function( PlayerRemoved value)?  playerRemoved,TResult? Function( TurnPassed value)?  turnPassed,TResult? Function( GameOver value)?  gameOver,}){
final _that = this;
switch (_that) {
case DiceRolled() when diceRolled != null:
return diceRolled(_that);case TokenMoved() when tokenMoved != null:
return tokenMoved(_that);case TokenCaptured() when tokenCaptured != null:
return tokenCaptured(_that);case TokenHome() when tokenHome != null:
return tokenHome(_that);case ExtraRoll() when extraRoll != null:
return extraRoll(_that);case ThreeSixesForfeit() when threeSixesForfeit != null:
return threeSixesForfeit(_that);case PlayerFinished() when playerFinished != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PlayerId playerId,  int value)?  diceRolled,TResult Function( PlayerId playerId,  int tokenId,  int fromRel,  int toRel,  List<List<int>> path)?  tokenMoved,TResult Function( PlayerId byPlayerId,  PlayerId playerId,  int tokenId,  int fromRel)?  tokenCaptured,TResult Function( PlayerId playerId,  int tokenId)?  tokenHome,TResult Function( PlayerId playerId,  ExtraRollReason reason)?  extraRoll,TResult Function( PlayerId playerId)?  threeSixesForfeit,TResult Function( PlayerId playerId,  int rank)?  playerFinished,TResult Function( PlayerId playerId)?  playerRemoved,TResult Function( PlayerId from,  PlayerId to,  PassReason reason)?  turnPassed,TResult Function( List<PlayerId> ranking)?  gameOver,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DiceRolled() when diceRolled != null:
return diceRolled(_that.playerId,_that.value);case TokenMoved() when tokenMoved != null:
return tokenMoved(_that.playerId,_that.tokenId,_that.fromRel,_that.toRel,_that.path);case TokenCaptured() when tokenCaptured != null:
return tokenCaptured(_that.byPlayerId,_that.playerId,_that.tokenId,_that.fromRel);case TokenHome() when tokenHome != null:
return tokenHome(_that.playerId,_that.tokenId);case ExtraRoll() when extraRoll != null:
return extraRoll(_that.playerId,_that.reason);case ThreeSixesForfeit() when threeSixesForfeit != null:
return threeSixesForfeit(_that.playerId);case PlayerFinished() when playerFinished != null:
return playerFinished(_that.playerId,_that.rank);case PlayerRemoved() when playerRemoved != null:
return playerRemoved(_that.playerId);case TurnPassed() when turnPassed != null:
return turnPassed(_that.from,_that.to,_that.reason);case GameOver() when gameOver != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PlayerId playerId,  int value)  diceRolled,required TResult Function( PlayerId playerId,  int tokenId,  int fromRel,  int toRel,  List<List<int>> path)  tokenMoved,required TResult Function( PlayerId byPlayerId,  PlayerId playerId,  int tokenId,  int fromRel)  tokenCaptured,required TResult Function( PlayerId playerId,  int tokenId)  tokenHome,required TResult Function( PlayerId playerId,  ExtraRollReason reason)  extraRoll,required TResult Function( PlayerId playerId)  threeSixesForfeit,required TResult Function( PlayerId playerId,  int rank)  playerFinished,required TResult Function( PlayerId playerId)  playerRemoved,required TResult Function( PlayerId from,  PlayerId to,  PassReason reason)  turnPassed,required TResult Function( List<PlayerId> ranking)  gameOver,}) {final _that = this;
switch (_that) {
case DiceRolled():
return diceRolled(_that.playerId,_that.value);case TokenMoved():
return tokenMoved(_that.playerId,_that.tokenId,_that.fromRel,_that.toRel,_that.path);case TokenCaptured():
return tokenCaptured(_that.byPlayerId,_that.playerId,_that.tokenId,_that.fromRel);case TokenHome():
return tokenHome(_that.playerId,_that.tokenId);case ExtraRoll():
return extraRoll(_that.playerId,_that.reason);case ThreeSixesForfeit():
return threeSixesForfeit(_that.playerId);case PlayerFinished():
return playerFinished(_that.playerId,_that.rank);case PlayerRemoved():
return playerRemoved(_that.playerId);case TurnPassed():
return turnPassed(_that.from,_that.to,_that.reason);case GameOver():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PlayerId playerId,  int value)?  diceRolled,TResult? Function( PlayerId playerId,  int tokenId,  int fromRel,  int toRel,  List<List<int>> path)?  tokenMoved,TResult? Function( PlayerId byPlayerId,  PlayerId playerId,  int tokenId,  int fromRel)?  tokenCaptured,TResult? Function( PlayerId playerId,  int tokenId)?  tokenHome,TResult? Function( PlayerId playerId,  ExtraRollReason reason)?  extraRoll,TResult? Function( PlayerId playerId)?  threeSixesForfeit,TResult? Function( PlayerId playerId,  int rank)?  playerFinished,TResult? Function( PlayerId playerId)?  playerRemoved,TResult? Function( PlayerId from,  PlayerId to,  PassReason reason)?  turnPassed,TResult? Function( List<PlayerId> ranking)?  gameOver,}) {final _that = this;
switch (_that) {
case DiceRolled() when diceRolled != null:
return diceRolled(_that.playerId,_that.value);case TokenMoved() when tokenMoved != null:
return tokenMoved(_that.playerId,_that.tokenId,_that.fromRel,_that.toRel,_that.path);case TokenCaptured() when tokenCaptured != null:
return tokenCaptured(_that.byPlayerId,_that.playerId,_that.tokenId,_that.fromRel);case TokenHome() when tokenHome != null:
return tokenHome(_that.playerId,_that.tokenId);case ExtraRoll() when extraRoll != null:
return extraRoll(_that.playerId,_that.reason);case ThreeSixesForfeit() when threeSixesForfeit != null:
return threeSixesForfeit(_that.playerId);case PlayerFinished() when playerFinished != null:
return playerFinished(_that.playerId,_that.rank);case PlayerRemoved() when playerRemoved != null:
return playerRemoved(_that.playerId);case TurnPassed() when turnPassed != null:
return turnPassed(_that.from,_that.to,_that.reason);case GameOver() when gameOver != null:
return gameOver(_that.ranking);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class DiceRolled implements LudoEvent {
  const DiceRolled({required this.playerId, required this.value, final  String? $type}): $type = $type ?? 'diceRolled';
  factory DiceRolled.fromJson(Map<String, dynamic> json) => _$DiceRolledFromJson(json);

 final  PlayerId playerId;
 final  int value;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of LudoEvent
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
  return 'LudoEvent.diceRolled(playerId: $playerId, value: $value)';
}


}

/// @nodoc
abstract mixin class $DiceRolledCopyWith<$Res> implements $LudoEventCopyWith<$Res> {
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

/// Create a copy of LudoEvent
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

class TokenMoved implements LudoEvent {
  const TokenMoved({required this.playerId, required this.tokenId, required this.fromRel, required this.toRel, required final  List<List<int>> path, final  String? $type}): _path = path,$type = $type ?? 'tokenMoved';
  factory TokenMoved.fromJson(Map<String, dynamic> json) => _$TokenMovedFromJson(json);

 final  PlayerId playerId;
 final  int tokenId;
 final  int fromRel;
 final  int toRel;
 final  List<List<int>> _path;
 List<List<int>> get path {
  if (_path is EqualUnmodifiableListView) return _path;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_path);
}


@JsonKey(name: 'kind')
final String $type;


/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenMovedCopyWith<TokenMoved> get copyWith => _$TokenMovedCopyWithImpl<TokenMoved>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenMovedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenMoved&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.fromRel, fromRel) || other.fromRel == fromRel)&&(identical(other.toRel, toRel) || other.toRel == toRel)&&const DeepCollectionEquality().equals(other._path, _path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,tokenId,fromRel,toRel,const DeepCollectionEquality().hash(_path));

@override
String toString() {
  return 'LudoEvent.tokenMoved(playerId: $playerId, tokenId: $tokenId, fromRel: $fromRel, toRel: $toRel, path: $path)';
}


}

/// @nodoc
abstract mixin class $TokenMovedCopyWith<$Res> implements $LudoEventCopyWith<$Res> {
  factory $TokenMovedCopyWith(TokenMoved value, $Res Function(TokenMoved) _then) = _$TokenMovedCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, int tokenId, int fromRel, int toRel, List<List<int>> path
});




}
/// @nodoc
class _$TokenMovedCopyWithImpl<$Res>
    implements $TokenMovedCopyWith<$Res> {
  _$TokenMovedCopyWithImpl(this._self, this._then);

  final TokenMoved _self;
  final $Res Function(TokenMoved) _then;

/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? tokenId = null,Object? fromRel = null,Object? toRel = null,Object? path = null,}) {
  return _then(TokenMoved(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as int,fromRel: null == fromRel ? _self.fromRel : fromRel // ignore: cast_nullable_to_non_nullable
as int,toRel: null == toRel ? _self.toRel : toRel // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self._path : path // ignore: cast_nullable_to_non_nullable
as List<List<int>>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TokenCaptured implements LudoEvent {
  const TokenCaptured({required this.byPlayerId, required this.playerId, required this.tokenId, required this.fromRel, final  String? $type}): $type = $type ?? 'tokenCaptured';
  factory TokenCaptured.fromJson(Map<String, dynamic> json) => _$TokenCapturedFromJson(json);

 final  PlayerId byPlayerId;
 final  PlayerId playerId;
 final  int tokenId;
 final  int fromRel;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenCapturedCopyWith<TokenCaptured> get copyWith => _$TokenCapturedCopyWithImpl<TokenCaptured>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenCapturedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenCaptured&&(identical(other.byPlayerId, byPlayerId) || other.byPlayerId == byPlayerId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.fromRel, fromRel) || other.fromRel == fromRel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,byPlayerId,playerId,tokenId,fromRel);

@override
String toString() {
  return 'LudoEvent.tokenCaptured(byPlayerId: $byPlayerId, playerId: $playerId, tokenId: $tokenId, fromRel: $fromRel)';
}


}

/// @nodoc
abstract mixin class $TokenCapturedCopyWith<$Res> implements $LudoEventCopyWith<$Res> {
  factory $TokenCapturedCopyWith(TokenCaptured value, $Res Function(TokenCaptured) _then) = _$TokenCapturedCopyWithImpl;
@useResult
$Res call({
 PlayerId byPlayerId, PlayerId playerId, int tokenId, int fromRel
});




}
/// @nodoc
class _$TokenCapturedCopyWithImpl<$Res>
    implements $TokenCapturedCopyWith<$Res> {
  _$TokenCapturedCopyWithImpl(this._self, this._then);

  final TokenCaptured _self;
  final $Res Function(TokenCaptured) _then;

/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? byPlayerId = null,Object? playerId = null,Object? tokenId = null,Object? fromRel = null,}) {
  return _then(TokenCaptured(
byPlayerId: null == byPlayerId ? _self.byPlayerId : byPlayerId // ignore: cast_nullable_to_non_nullable
as PlayerId,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as int,fromRel: null == fromRel ? _self.fromRel : fromRel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TokenHome implements LudoEvent {
  const TokenHome({required this.playerId, required this.tokenId, final  String? $type}): $type = $type ?? 'tokenHome';
  factory TokenHome.fromJson(Map<String, dynamic> json) => _$TokenHomeFromJson(json);

 final  PlayerId playerId;
 final  int tokenId;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenHomeCopyWith<TokenHome> get copyWith => _$TokenHomeCopyWithImpl<TokenHome>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenHomeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenHome&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,tokenId);

@override
String toString() {
  return 'LudoEvent.tokenHome(playerId: $playerId, tokenId: $tokenId)';
}


}

/// @nodoc
abstract mixin class $TokenHomeCopyWith<$Res> implements $LudoEventCopyWith<$Res> {
  factory $TokenHomeCopyWith(TokenHome value, $Res Function(TokenHome) _then) = _$TokenHomeCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, int tokenId
});




}
/// @nodoc
class _$TokenHomeCopyWithImpl<$Res>
    implements $TokenHomeCopyWith<$Res> {
  _$TokenHomeCopyWithImpl(this._self, this._then);

  final TokenHome _self;
  final $Res Function(TokenHome) _then;

/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? tokenId = null,}) {
  return _then(TokenHome(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ExtraRoll implements LudoEvent {
  const ExtraRoll({required this.playerId, required this.reason, final  String? $type}): $type = $type ?? 'extraRoll';
  factory ExtraRoll.fromJson(Map<String, dynamic> json) => _$ExtraRollFromJson(json);

 final  PlayerId playerId;
 final  ExtraRollReason reason;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of LudoEvent
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtraRoll&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,reason);

@override
String toString() {
  return 'LudoEvent.extraRoll(playerId: $playerId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ExtraRollCopyWith<$Res> implements $LudoEventCopyWith<$Res> {
  factory $ExtraRollCopyWith(ExtraRoll value, $Res Function(ExtraRoll) _then) = _$ExtraRollCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId, ExtraRollReason reason
});




}
/// @nodoc
class _$ExtraRollCopyWithImpl<$Res>
    implements $ExtraRollCopyWith<$Res> {
  _$ExtraRollCopyWithImpl(this._self, this._then);

  final ExtraRoll _self;
  final $Res Function(ExtraRoll) _then;

/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? reason = null,}) {
  return _then(ExtraRoll(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ExtraRollReason,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ThreeSixesForfeit implements LudoEvent {
  const ThreeSixesForfeit({required this.playerId, final  String? $type}): $type = $type ?? 'threeSixesForfeit';
  factory ThreeSixesForfeit.fromJson(Map<String, dynamic> json) => _$ThreeSixesForfeitFromJson(json);

 final  PlayerId playerId;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThreeSixesForfeitCopyWith<ThreeSixesForfeit> get copyWith => _$ThreeSixesForfeitCopyWithImpl<ThreeSixesForfeit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThreeSixesForfeitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThreeSixesForfeit&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId);

@override
String toString() {
  return 'LudoEvent.threeSixesForfeit(playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $ThreeSixesForfeitCopyWith<$Res> implements $LudoEventCopyWith<$Res> {
  factory $ThreeSixesForfeitCopyWith(ThreeSixesForfeit value, $Res Function(ThreeSixesForfeit) _then) = _$ThreeSixesForfeitCopyWithImpl;
@useResult
$Res call({
 PlayerId playerId
});




}
/// @nodoc
class _$ThreeSixesForfeitCopyWithImpl<$Res>
    implements $ThreeSixesForfeitCopyWith<$Res> {
  _$ThreeSixesForfeitCopyWithImpl(this._self, this._then);

  final ThreeSixesForfeit _self;
  final $Res Function(ThreeSixesForfeit) _then;

/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,}) {
  return _then(ThreeSixesForfeit(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as PlayerId,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlayerFinished implements LudoEvent {
  const PlayerFinished({required this.playerId, required this.rank, final  String? $type}): $type = $type ?? 'playerFinished';
  factory PlayerFinished.fromJson(Map<String, dynamic> json) => _$PlayerFinishedFromJson(json);

 final  PlayerId playerId;
 final  int rank;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of LudoEvent
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
  return 'LudoEvent.playerFinished(playerId: $playerId, rank: $rank)';
}


}

/// @nodoc
abstract mixin class $PlayerFinishedCopyWith<$Res> implements $LudoEventCopyWith<$Res> {
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

/// Create a copy of LudoEvent
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

class PlayerRemoved implements LudoEvent {
  const PlayerRemoved({required this.playerId, final  String? $type}): $type = $type ?? 'playerRemoved';
  factory PlayerRemoved.fromJson(Map<String, dynamic> json) => _$PlayerRemovedFromJson(json);

 final  PlayerId playerId;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of LudoEvent
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
  return 'LudoEvent.playerRemoved(playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $PlayerRemovedCopyWith<$Res> implements $LudoEventCopyWith<$Res> {
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

/// Create a copy of LudoEvent
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

class TurnPassed implements LudoEvent {
  const TurnPassed({required this.from, required this.to, required this.reason, final  String? $type}): $type = $type ?? 'turnPassed';
  factory TurnPassed.fromJson(Map<String, dynamic> json) => _$TurnPassedFromJson(json);

 final  PlayerId from;
 final  PlayerId to;
 final  PassReason reason;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of LudoEvent
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TurnPassed&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,reason);

@override
String toString() {
  return 'LudoEvent.turnPassed(from: $from, to: $to, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $TurnPassedCopyWith<$Res> implements $LudoEventCopyWith<$Res> {
  factory $TurnPassedCopyWith(TurnPassed value, $Res Function(TurnPassed) _then) = _$TurnPassedCopyWithImpl;
@useResult
$Res call({
 PlayerId from, PlayerId to, PassReason reason
});




}
/// @nodoc
class _$TurnPassedCopyWithImpl<$Res>
    implements $TurnPassedCopyWith<$Res> {
  _$TurnPassedCopyWithImpl(this._self, this._then);

  final TurnPassed _self;
  final $Res Function(TurnPassed) _then;

/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? reason = null,}) {
  return _then(TurnPassed(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as PlayerId,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as PlayerId,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as PassReason,
  ));
}


}

/// @nodoc
@JsonSerializable()

class GameOver implements LudoEvent {
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


/// Create a copy of LudoEvent
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
  return 'LudoEvent.gameOver(ranking: $ranking)';
}


}

/// @nodoc
abstract mixin class $GameOverCopyWith<$Res> implements $LudoEventCopyWith<$Res> {
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

/// Create a copy of LudoEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ranking = null,}) {
  return _then(GameOver(
ranking: null == ranking ? _self._ranking : ranking // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,
  ));
}


}

// dart format on
