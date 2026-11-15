// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameStats {

 int get played;/// Wins keyed by [GameMode] name.
 Map<String, int> get wins;/// Values keyed by [StatSpec.key].
 Map<String, num> get values;
/// Create a copy of GameStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStatsCopyWith<GameStats> get copyWith => _$GameStatsCopyWithImpl<GameStats>(this as GameStats, _$identity);

  /// Serializes this GameStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStats&&(identical(other.played, played) || other.played == played)&&const DeepCollectionEquality().equals(other.wins, wins)&&const DeepCollectionEquality().equals(other.values, values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,played,const DeepCollectionEquality().hash(wins),const DeepCollectionEquality().hash(values));

@override
String toString() {
  return 'GameStats(played: $played, wins: $wins, values: $values)';
}


}

/// @nodoc
abstract mixin class $GameStatsCopyWith<$Res>  {
  factory $GameStatsCopyWith(GameStats value, $Res Function(GameStats) _then) = _$GameStatsCopyWithImpl;
@useResult
$Res call({
 int played, Map<String, int> wins, Map<String, num> values
});




}
/// @nodoc
class _$GameStatsCopyWithImpl<$Res>
    implements $GameStatsCopyWith<$Res> {
  _$GameStatsCopyWithImpl(this._self, this._then);

  final GameStats _self;
  final $Res Function(GameStats) _then;

/// Create a copy of GameStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? played = null,Object? wins = null,Object? values = null,}) {
  return _then(_self.copyWith(
played: null == played ? _self.played : played // ignore: cast_nullable_to_non_nullable
as int,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as Map<String, int>,values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, num>,
  ));
}

}


/// Adds pattern-matching-related methods to [GameStats].
extension GameStatsPatterns on GameStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameStats value)  $default,){
final _that = this;
switch (_that) {
case _GameStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameStats value)?  $default,){
final _that = this;
switch (_that) {
case _GameStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int played,  Map<String, int> wins,  Map<String, num> values)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameStats() when $default != null:
return $default(_that.played,_that.wins,_that.values);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int played,  Map<String, int> wins,  Map<String, num> values)  $default,) {final _that = this;
switch (_that) {
case _GameStats():
return $default(_that.played,_that.wins,_that.values);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int played,  Map<String, int> wins,  Map<String, num> values)?  $default,) {final _that = this;
switch (_that) {
case _GameStats() when $default != null:
return $default(_that.played,_that.wins,_that.values);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameStats extends GameStats {
  const _GameStats({this.played = 0, final  Map<String, int> wins = const <String, int>{}, final  Map<String, num> values = const <String, num>{}}): _wins = wins,_values = values,super._();
  factory _GameStats.fromJson(Map<String, dynamic> json) => _$GameStatsFromJson(json);

@override@JsonKey() final  int played;
/// Wins keyed by [GameMode] name.
 final  Map<String, int> _wins;
/// Wins keyed by [GameMode] name.
@override@JsonKey() Map<String, int> get wins {
  if (_wins is EqualUnmodifiableMapView) return _wins;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_wins);
}

/// Values keyed by [StatSpec.key].
 final  Map<String, num> _values;
/// Values keyed by [StatSpec.key].
@override@JsonKey() Map<String, num> get values {
  if (_values is EqualUnmodifiableMapView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_values);
}


/// Create a copy of GameStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStatsCopyWith<_GameStats> get copyWith => __$GameStatsCopyWithImpl<_GameStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameStats&&(identical(other.played, played) || other.played == played)&&const DeepCollectionEquality().equals(other._wins, _wins)&&const DeepCollectionEquality().equals(other._values, _values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,played,const DeepCollectionEquality().hash(_wins),const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'GameStats(played: $played, wins: $wins, values: $values)';
}


}

/// @nodoc
abstract mixin class _$GameStatsCopyWith<$Res> implements $GameStatsCopyWith<$Res> {
  factory _$GameStatsCopyWith(_GameStats value, $Res Function(_GameStats) _then) = __$GameStatsCopyWithImpl;
@override @useResult
$Res call({
 int played, Map<String, int> wins, Map<String, num> values
});




}
/// @nodoc
class __$GameStatsCopyWithImpl<$Res>
    implements _$GameStatsCopyWith<$Res> {
  __$GameStatsCopyWithImpl(this._self, this._then);

  final _GameStats _self;
  final $Res Function(_GameStats) _then;

/// Create a copy of GameStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? played = null,Object? wins = null,Object? values = null,}) {
  return _then(_GameStats(
played: null == played ? _self.played : played // ignore: cast_nullable_to_non_nullable
as int,wins: null == wins ? _self._wins : wins // ignore: cast_nullable_to_non_nullable
as Map<String, int>,values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as Map<String, num>,
  ));
}


}

// dart format on
