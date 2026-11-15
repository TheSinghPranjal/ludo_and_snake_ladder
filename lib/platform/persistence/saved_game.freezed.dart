// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavedGame {

 int get schemaVersion; GameType get game; GameMode get mode;/// The game's configuration, through its config codec.
 Map<String, dynamic> get config;/// The game's state, through `stateToPublicJson`.
 Map<String, dynamic> get state;/// The seat statistics are recorded for, or null if no seat is human.
 PlayerId? get me;
/// Create a copy of SavedGame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedGameCopyWith<SavedGame> get copyWith => _$SavedGameCopyWithImpl<SavedGame>(this as SavedGame, _$identity);

  /// Serializes this SavedGame to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedGame&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.game, game) || other.game == game)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.config, config)&&const DeepCollectionEquality().equals(other.state, state)&&(identical(other.me, me) || other.me == me));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,game,mode,const DeepCollectionEquality().hash(config),const DeepCollectionEquality().hash(state),me);

@override
String toString() {
  return 'SavedGame(schemaVersion: $schemaVersion, game: $game, mode: $mode, config: $config, state: $state, me: $me)';
}


}

/// @nodoc
abstract mixin class $SavedGameCopyWith<$Res>  {
  factory $SavedGameCopyWith(SavedGame value, $Res Function(SavedGame) _then) = _$SavedGameCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, GameType game, GameMode mode, Map<String, dynamic> config, Map<String, dynamic> state, PlayerId? me
});




}
/// @nodoc
class _$SavedGameCopyWithImpl<$Res>
    implements $SavedGameCopyWith<$Res> {
  _$SavedGameCopyWithImpl(this._self, this._then);

  final SavedGame _self;
  final $Res Function(SavedGame) _then;

/// Create a copy of SavedGame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? game = null,Object? mode = null,Object? config = null,Object? state = null,Object? me = freezed,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as GameType,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GameMode,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,me: freezed == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as PlayerId?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedGame].
extension SavedGamePatterns on SavedGame {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedGame value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedGame() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedGame value)  $default,){
final _that = this;
switch (_that) {
case _SavedGame():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedGame value)?  $default,){
final _that = this;
switch (_that) {
case _SavedGame() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  GameType game,  GameMode mode,  Map<String, dynamic> config,  Map<String, dynamic> state,  PlayerId? me)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedGame() when $default != null:
return $default(_that.schemaVersion,_that.game,_that.mode,_that.config,_that.state,_that.me);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  GameType game,  GameMode mode,  Map<String, dynamic> config,  Map<String, dynamic> state,  PlayerId? me)  $default,) {final _that = this;
switch (_that) {
case _SavedGame():
return $default(_that.schemaVersion,_that.game,_that.mode,_that.config,_that.state,_that.me);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  GameType game,  GameMode mode,  Map<String, dynamic> config,  Map<String, dynamic> state,  PlayerId? me)?  $default,) {final _that = this;
switch (_that) {
case _SavedGame() when $default != null:
return $default(_that.schemaVersion,_that.game,_that.mode,_that.config,_that.state,_that.me);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedGame implements SavedGame {
  const _SavedGame({required this.schemaVersion, required this.game, required this.mode, required final  Map<String, dynamic> config, required final  Map<String, dynamic> state, this.me}): _config = config,_state = state;
  factory _SavedGame.fromJson(Map<String, dynamic> json) => _$SavedGameFromJson(json);

@override final  int schemaVersion;
@override final  GameType game;
@override final  GameMode mode;
/// The game's configuration, through its config codec.
 final  Map<String, dynamic> _config;
/// The game's configuration, through its config codec.
@override Map<String, dynamic> get config {
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_config);
}

/// The game's state, through `stateToPublicJson`.
 final  Map<String, dynamic> _state;
/// The game's state, through `stateToPublicJson`.
@override Map<String, dynamic> get state {
  if (_state is EqualUnmodifiableMapView) return _state;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_state);
}

/// The seat statistics are recorded for, or null if no seat is human.
@override final  PlayerId? me;

/// Create a copy of SavedGame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedGameCopyWith<_SavedGame> get copyWith => __$SavedGameCopyWithImpl<_SavedGame>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedGameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedGame&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.game, game) || other.game == game)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other._config, _config)&&const DeepCollectionEquality().equals(other._state, _state)&&(identical(other.me, me) || other.me == me));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,game,mode,const DeepCollectionEquality().hash(_config),const DeepCollectionEquality().hash(_state),me);

@override
String toString() {
  return 'SavedGame(schemaVersion: $schemaVersion, game: $game, mode: $mode, config: $config, state: $state, me: $me)';
}


}

/// @nodoc
abstract mixin class _$SavedGameCopyWith<$Res> implements $SavedGameCopyWith<$Res> {
  factory _$SavedGameCopyWith(_SavedGame value, $Res Function(_SavedGame) _then) = __$SavedGameCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, GameType game, GameMode mode, Map<String, dynamic> config, Map<String, dynamic> state, PlayerId? me
});




}
/// @nodoc
class __$SavedGameCopyWithImpl<$Res>
    implements _$SavedGameCopyWith<$Res> {
  __$SavedGameCopyWithImpl(this._self, this._then);

  final _SavedGame _self;
  final $Res Function(_SavedGame) _then;

/// Create a copy of SavedGame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? game = null,Object? mode = null,Object? config = null,Object? state = null,Object? me = freezed,}) {
  return _then(_SavedGame(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,game: null == game ? _self.game : game // ignore: cast_nullable_to_non_nullable
as GameType,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GameMode,config: null == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,state: null == state ? _self._state : state // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,me: freezed == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as PlayerId?,
  ));
}


}

// dart format on
