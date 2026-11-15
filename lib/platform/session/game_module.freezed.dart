// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SeatSpec {

 String get name; int get avatar; PlayerColor get color; PlayerKind get kind; AiLevel? get aiLevel; PlayerConnection get connection;
/// Create a copy of SeatSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeatSpecCopyWith<SeatSpec> get copyWith => _$SeatSpecCopyWithImpl<SeatSpec>(this as SeatSpec, _$identity);

  /// Serializes this SeatSpec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeatSpec&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.color, color) || other.color == color)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.aiLevel, aiLevel) || other.aiLevel == aiLevel)&&(identical(other.connection, connection) || other.connection == connection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,avatar,color,kind,aiLevel,connection);

@override
String toString() {
  return 'SeatSpec(name: $name, avatar: $avatar, color: $color, kind: $kind, aiLevel: $aiLevel, connection: $connection)';
}


}

/// @nodoc
abstract mixin class $SeatSpecCopyWith<$Res>  {
  factory $SeatSpecCopyWith(SeatSpec value, $Res Function(SeatSpec) _then) = _$SeatSpecCopyWithImpl;
@useResult
$Res call({
 String name, int avatar, PlayerColor color, PlayerKind kind, AiLevel? aiLevel, PlayerConnection connection
});




}
/// @nodoc
class _$SeatSpecCopyWithImpl<$Res>
    implements $SeatSpecCopyWith<$Res> {
  _$SeatSpecCopyWithImpl(this._self, this._then);

  final SeatSpec _self;
  final $Res Function(SeatSpec) _then;

/// Create a copy of SeatSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? avatar = null,Object? color = null,Object? kind = null,Object? aiLevel = freezed,Object? connection = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as PlayerColor,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PlayerKind,aiLevel: freezed == aiLevel ? _self.aiLevel : aiLevel // ignore: cast_nullable_to_non_nullable
as AiLevel?,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as PlayerConnection,
  ));
}

}


/// Adds pattern-matching-related methods to [SeatSpec].
extension SeatSpecPatterns on SeatSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeatSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeatSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeatSpec value)  $default,){
final _that = this;
switch (_that) {
case _SeatSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeatSpec value)?  $default,){
final _that = this;
switch (_that) {
case _SeatSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int avatar,  PlayerColor color,  PlayerKind kind,  AiLevel? aiLevel,  PlayerConnection connection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeatSpec() when $default != null:
return $default(_that.name,_that.avatar,_that.color,_that.kind,_that.aiLevel,_that.connection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int avatar,  PlayerColor color,  PlayerKind kind,  AiLevel? aiLevel,  PlayerConnection connection)  $default,) {final _that = this;
switch (_that) {
case _SeatSpec():
return $default(_that.name,_that.avatar,_that.color,_that.kind,_that.aiLevel,_that.connection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int avatar,  PlayerColor color,  PlayerKind kind,  AiLevel? aiLevel,  PlayerConnection connection)?  $default,) {final _that = this;
switch (_that) {
case _SeatSpec() when $default != null:
return $default(_that.name,_that.avatar,_that.color,_that.kind,_that.aiLevel,_that.connection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeatSpec implements SeatSpec {
  const _SeatSpec({required this.name, required this.avatar, required this.color, required this.kind, this.aiLevel, this.connection = PlayerConnection.local});
  factory _SeatSpec.fromJson(Map<String, dynamic> json) => _$SeatSpecFromJson(json);

@override final  String name;
@override final  int avatar;
@override final  PlayerColor color;
@override final  PlayerKind kind;
@override final  AiLevel? aiLevel;
@override@JsonKey() final  PlayerConnection connection;

/// Create a copy of SeatSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeatSpecCopyWith<_SeatSpec> get copyWith => __$SeatSpecCopyWithImpl<_SeatSpec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeatSpecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeatSpec&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.color, color) || other.color == color)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.aiLevel, aiLevel) || other.aiLevel == aiLevel)&&(identical(other.connection, connection) || other.connection == connection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,avatar,color,kind,aiLevel,connection);

@override
String toString() {
  return 'SeatSpec(name: $name, avatar: $avatar, color: $color, kind: $kind, aiLevel: $aiLevel, connection: $connection)';
}


}

/// @nodoc
abstract mixin class _$SeatSpecCopyWith<$Res> implements $SeatSpecCopyWith<$Res> {
  factory _$SeatSpecCopyWith(_SeatSpec value, $Res Function(_SeatSpec) _then) = __$SeatSpecCopyWithImpl;
@override @useResult
$Res call({
 String name, int avatar, PlayerColor color, PlayerKind kind, AiLevel? aiLevel, PlayerConnection connection
});




}
/// @nodoc
class __$SeatSpecCopyWithImpl<$Res>
    implements _$SeatSpecCopyWith<$Res> {
  __$SeatSpecCopyWithImpl(this._self, this._then);

  final _SeatSpec _self;
  final $Res Function(_SeatSpec) _then;

/// Create a copy of SeatSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? avatar = null,Object? color = null,Object? kind = null,Object? aiLevel = freezed,Object? connection = null,}) {
  return _then(_SeatSpec(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as PlayerColor,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PlayerKind,aiLevel: freezed == aiLevel ? _self.aiLevel : aiLevel // ignore: cast_nullable_to_non_nullable
as AiLevel?,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as PlayerConnection,
  ));
}


}


/// @nodoc
mixin _$Player {

 PlayerId get id; String get name; int get avatar; PlayerColor get color; PlayerKind get kind; AiLevel? get aiLevel; PlayerConnection get connection; int? get finishedRank; Map<String, num> get stats;
/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerCopyWith<Player> get copyWith => _$PlayerCopyWithImpl<Player>(this as Player, _$identity);

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Player&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.color, color) || other.color == color)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.aiLevel, aiLevel) || other.aiLevel == aiLevel)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.finishedRank, finishedRank) || other.finishedRank == finishedRank)&&const DeepCollectionEquality().equals(other.stats, stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatar,color,kind,aiLevel,connection,finishedRank,const DeepCollectionEquality().hash(stats));

@override
String toString() {
  return 'Player(id: $id, name: $name, avatar: $avatar, color: $color, kind: $kind, aiLevel: $aiLevel, connection: $connection, finishedRank: $finishedRank, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $PlayerCopyWith<$Res>  {
  factory $PlayerCopyWith(Player value, $Res Function(Player) _then) = _$PlayerCopyWithImpl;
@useResult
$Res call({
 PlayerId id, String name, int avatar, PlayerColor color, PlayerKind kind, AiLevel? aiLevel, PlayerConnection connection, int? finishedRank, Map<String, num> stats
});




}
/// @nodoc
class _$PlayerCopyWithImpl<$Res>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._self, this._then);

  final Player _self;
  final $Res Function(Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatar = null,Object? color = null,Object? kind = null,Object? aiLevel = freezed,Object? connection = null,Object? finishedRank = freezed,Object? stats = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as PlayerId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as PlayerColor,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PlayerKind,aiLevel: freezed == aiLevel ? _self.aiLevel : aiLevel // ignore: cast_nullable_to_non_nullable
as AiLevel?,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as PlayerConnection,finishedRank: freezed == finishedRank ? _self.finishedRank : finishedRank // ignore: cast_nullable_to_non_nullable
as int?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Map<String, num>,
  ));
}

}


/// Adds pattern-matching-related methods to [Player].
extension PlayerPatterns on Player {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Player value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Player() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Player value)  $default,){
final _that = this;
switch (_that) {
case _Player():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Player value)?  $default,){
final _that = this;
switch (_that) {
case _Player() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlayerId id,  String name,  int avatar,  PlayerColor color,  PlayerKind kind,  AiLevel? aiLevel,  PlayerConnection connection,  int? finishedRank,  Map<String, num> stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.id,_that.name,_that.avatar,_that.color,_that.kind,_that.aiLevel,_that.connection,_that.finishedRank,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlayerId id,  String name,  int avatar,  PlayerColor color,  PlayerKind kind,  AiLevel? aiLevel,  PlayerConnection connection,  int? finishedRank,  Map<String, num> stats)  $default,) {final _that = this;
switch (_that) {
case _Player():
return $default(_that.id,_that.name,_that.avatar,_that.color,_that.kind,_that.aiLevel,_that.connection,_that.finishedRank,_that.stats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlayerId id,  String name,  int avatar,  PlayerColor color,  PlayerKind kind,  AiLevel? aiLevel,  PlayerConnection connection,  int? finishedRank,  Map<String, num> stats)?  $default,) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.id,_that.name,_that.avatar,_that.color,_that.kind,_that.aiLevel,_that.connection,_that.finishedRank,_that.stats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Player extends Player {
  const _Player({required this.id, required this.name, required this.avatar, required this.color, required this.kind, this.aiLevel, this.connection = PlayerConnection.local, this.finishedRank, final  Map<String, num> stats = const <String, num>{}}): _stats = stats,super._();
  factory _Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

@override final  PlayerId id;
@override final  String name;
@override final  int avatar;
@override final  PlayerColor color;
@override final  PlayerKind kind;
@override final  AiLevel? aiLevel;
@override@JsonKey() final  PlayerConnection connection;
@override final  int? finishedRank;
 final  Map<String, num> _stats;
@override@JsonKey() Map<String, num> get stats {
  if (_stats is EqualUnmodifiableMapView) return _stats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_stats);
}


/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerCopyWith<_Player> get copyWith => __$PlayerCopyWithImpl<_Player>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Player&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.color, color) || other.color == color)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.aiLevel, aiLevel) || other.aiLevel == aiLevel)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.finishedRank, finishedRank) || other.finishedRank == finishedRank)&&const DeepCollectionEquality().equals(other._stats, _stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatar,color,kind,aiLevel,connection,finishedRank,const DeepCollectionEquality().hash(_stats));

@override
String toString() {
  return 'Player(id: $id, name: $name, avatar: $avatar, color: $color, kind: $kind, aiLevel: $aiLevel, connection: $connection, finishedRank: $finishedRank, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$PlayerCopyWith(_Player value, $Res Function(_Player) _then) = __$PlayerCopyWithImpl;
@override @useResult
$Res call({
 PlayerId id, String name, int avatar, PlayerColor color, PlayerKind kind, AiLevel? aiLevel, PlayerConnection connection, int? finishedRank, Map<String, num> stats
});




}
/// @nodoc
class __$PlayerCopyWithImpl<$Res>
    implements _$PlayerCopyWith<$Res> {
  __$PlayerCopyWithImpl(this._self, this._then);

  final _Player _self;
  final $Res Function(_Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatar = null,Object? color = null,Object? kind = null,Object? aiLevel = freezed,Object? connection = null,Object? finishedRank = freezed,Object? stats = null,}) {
  return _then(_Player(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as PlayerId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as PlayerColor,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PlayerKind,aiLevel: freezed == aiLevel ? _self.aiLevel : aiLevel // ignore: cast_nullable_to_non_nullable
as AiLevel?,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as PlayerConnection,finishedRank: freezed == finishedRank ? _self.finishedRank : finishedRank // ignore: cast_nullable_to_non_nullable
as int?,stats: null == stats ? _self._stats : stats // ignore: cast_nullable_to_non_nullable
as Map<String, num>,
  ));
}


}

// dart format on
