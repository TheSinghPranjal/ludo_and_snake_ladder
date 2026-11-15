// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jump.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Jump {

 String get id; JumpType get type; int get from; int get to; int? get rank; List<List<double>>? get path;
/// Create a copy of Jump
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JumpCopyWith<Jump> get copyWith => _$JumpCopyWithImpl<Jump>(this as Jump, _$identity);

  /// Serializes this Jump to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Jump&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.rank, rank) || other.rank == rank)&&const DeepCollectionEquality().equals(other.path, path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,from,to,rank,const DeepCollectionEquality().hash(path));

@override
String toString() {
  return 'Jump(id: $id, type: $type, from: $from, to: $to, rank: $rank, path: $path)';
}


}

/// @nodoc
abstract mixin class $JumpCopyWith<$Res>  {
  factory $JumpCopyWith(Jump value, $Res Function(Jump) _then) = _$JumpCopyWithImpl;
@useResult
$Res call({
 String id, JumpType type, int from, int to, int? rank, List<List<double>>? path
});




}
/// @nodoc
class _$JumpCopyWithImpl<$Res>
    implements $JumpCopyWith<$Res> {
  _$JumpCopyWithImpl(this._self, this._then);

  final Jump _self;
  final $Res Function(Jump) _then;

/// Create a copy of Jump
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? from = null,Object? to = null,Object? rank = freezed,Object? path = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as JumpType,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int,rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as List<List<double>>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Jump].
extension JumpPatterns on Jump {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Jump value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Jump() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Jump value)  $default,){
final _that = this;
switch (_that) {
case _Jump():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Jump value)?  $default,){
final _that = this;
switch (_that) {
case _Jump() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  JumpType type,  int from,  int to,  int? rank,  List<List<double>>? path)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Jump() when $default != null:
return $default(_that.id,_that.type,_that.from,_that.to,_that.rank,_that.path);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  JumpType type,  int from,  int to,  int? rank,  List<List<double>>? path)  $default,) {final _that = this;
switch (_that) {
case _Jump():
return $default(_that.id,_that.type,_that.from,_that.to,_that.rank,_that.path);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  JumpType type,  int from,  int to,  int? rank,  List<List<double>>? path)?  $default,) {final _that = this;
switch (_that) {
case _Jump() when $default != null:
return $default(_that.id,_that.type,_that.from,_that.to,_that.rank,_that.path);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Jump extends Jump {
  const _Jump({required this.id, required this.type, required this.from, required this.to, this.rank, final  List<List<double>>? path}): _path = path,super._();
  factory _Jump.fromJson(Map<String, dynamic> json) => _$JumpFromJson(json);

@override final  String id;
@override final  JumpType type;
@override final  int from;
@override final  int to;
@override final  int? rank;
 final  List<List<double>>? _path;
@override List<List<double>>? get path {
  final value = _path;
  if (value == null) return null;
  if (_path is EqualUnmodifiableListView) return _path;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Jump
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JumpCopyWith<_Jump> get copyWith => __$JumpCopyWithImpl<_Jump>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JumpToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Jump&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.rank, rank) || other.rank == rank)&&const DeepCollectionEquality().equals(other._path, _path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,from,to,rank,const DeepCollectionEquality().hash(_path));

@override
String toString() {
  return 'Jump(id: $id, type: $type, from: $from, to: $to, rank: $rank, path: $path)';
}


}

/// @nodoc
abstract mixin class _$JumpCopyWith<$Res> implements $JumpCopyWith<$Res> {
  factory _$JumpCopyWith(_Jump value, $Res Function(_Jump) _then) = __$JumpCopyWithImpl;
@override @useResult
$Res call({
 String id, JumpType type, int from, int to, int? rank, List<List<double>>? path
});




}
/// @nodoc
class __$JumpCopyWithImpl<$Res>
    implements _$JumpCopyWith<$Res> {
  __$JumpCopyWithImpl(this._self, this._then);

  final _Jump _self;
  final $Res Function(_Jump) _then;

/// Create a copy of Jump
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? from = null,Object? to = null,Object? rank = freezed,Object? path = freezed,}) {
  return _then(_Jump(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as JumpType,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int,rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,path: freezed == path ? _self._path : path // ignore: cast_nullable_to_non_nullable
as List<List<double>>?,
  ));
}


}

// dart format on
