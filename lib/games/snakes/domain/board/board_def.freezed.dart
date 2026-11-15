// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_def.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BoardUnlock {

 UnlockType get type; int get count;
/// Create a copy of BoardUnlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardUnlockCopyWith<BoardUnlock> get copyWith => _$BoardUnlockCopyWithImpl<BoardUnlock>(this as BoardUnlock, _$identity);

  /// Serializes this BoardUnlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardUnlock&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,count);

@override
String toString() {
  return 'BoardUnlock(type: $type, count: $count)';
}


}

/// @nodoc
abstract mixin class $BoardUnlockCopyWith<$Res>  {
  factory $BoardUnlockCopyWith(BoardUnlock value, $Res Function(BoardUnlock) _then) = _$BoardUnlockCopyWithImpl;
@useResult
$Res call({
 UnlockType type, int count
});




}
/// @nodoc
class _$BoardUnlockCopyWithImpl<$Res>
    implements $BoardUnlockCopyWith<$Res> {
  _$BoardUnlockCopyWithImpl(this._self, this._then);

  final BoardUnlock _self;
  final $Res Function(BoardUnlock) _then;

/// Create a copy of BoardUnlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? count = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as UnlockType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardUnlock].
extension BoardUnlockPatterns on BoardUnlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardUnlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardUnlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardUnlock value)  $default,){
final _that = this;
switch (_that) {
case _BoardUnlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardUnlock value)?  $default,){
final _that = this;
switch (_that) {
case _BoardUnlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UnlockType type,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardUnlock() when $default != null:
return $default(_that.type,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UnlockType type,  int count)  $default,) {final _that = this;
switch (_that) {
case _BoardUnlock():
return $default(_that.type,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UnlockType type,  int count)?  $default,) {final _that = this;
switch (_that) {
case _BoardUnlock() when $default != null:
return $default(_that.type,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BoardUnlock implements BoardUnlock {
  const _BoardUnlock({required this.type, this.count = 0});
  factory _BoardUnlock.fromJson(Map<String, dynamic> json) => _$BoardUnlockFromJson(json);

@override final  UnlockType type;
@override@JsonKey() final  int count;

/// Create a copy of BoardUnlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardUnlockCopyWith<_BoardUnlock> get copyWith => __$BoardUnlockCopyWithImpl<_BoardUnlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoardUnlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardUnlock&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,count);

@override
String toString() {
  return 'BoardUnlock(type: $type, count: $count)';
}


}

/// @nodoc
abstract mixin class _$BoardUnlockCopyWith<$Res> implements $BoardUnlockCopyWith<$Res> {
  factory _$BoardUnlockCopyWith(_BoardUnlock value, $Res Function(_BoardUnlock) _then) = __$BoardUnlockCopyWithImpl;
@override @useResult
$Res call({
 UnlockType type, int count
});




}
/// @nodoc
class __$BoardUnlockCopyWithImpl<$Res>
    implements _$BoardUnlockCopyWith<$Res> {
  __$BoardUnlockCopyWithImpl(this._self, this._then);

  final _BoardUnlock _self;
  final $Res Function(_BoardUnlock) _then;

/// Create a copy of BoardUnlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? count = null,}) {
  return _then(_BoardUnlock(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as UnlockType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BoardDef {

 String get id; String get name; String get theme; int get size; BoardUnlock get unlock; List<Jump> get jumps;
/// Create a copy of BoardDef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardDefCopyWith<BoardDef> get copyWith => _$BoardDefCopyWithImpl<BoardDef>(this as BoardDef, _$identity);

  /// Serializes this BoardDef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardDef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.size, size) || other.size == size)&&(identical(other.unlock, unlock) || other.unlock == unlock)&&const DeepCollectionEquality().equals(other.jumps, jumps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,theme,size,unlock,const DeepCollectionEquality().hash(jumps));

@override
String toString() {
  return 'BoardDef(id: $id, name: $name, theme: $theme, size: $size, unlock: $unlock, jumps: $jumps)';
}


}

/// @nodoc
abstract mixin class $BoardDefCopyWith<$Res>  {
  factory $BoardDefCopyWith(BoardDef value, $Res Function(BoardDef) _then) = _$BoardDefCopyWithImpl;
@useResult
$Res call({
 String id, String name, String theme, int size, BoardUnlock unlock, List<Jump> jumps
});


$BoardUnlockCopyWith<$Res> get unlock;

}
/// @nodoc
class _$BoardDefCopyWithImpl<$Res>
    implements $BoardDefCopyWith<$Res> {
  _$BoardDefCopyWithImpl(this._self, this._then);

  final BoardDef _self;
  final $Res Function(BoardDef) _then;

/// Create a copy of BoardDef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? theme = null,Object? size = null,Object? unlock = null,Object? jumps = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,unlock: null == unlock ? _self.unlock : unlock // ignore: cast_nullable_to_non_nullable
as BoardUnlock,jumps: null == jumps ? _self.jumps : jumps // ignore: cast_nullable_to_non_nullable
as List<Jump>,
  ));
}
/// Create a copy of BoardDef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardUnlockCopyWith<$Res> get unlock {
  
  return $BoardUnlockCopyWith<$Res>(_self.unlock, (value) {
    return _then(_self.copyWith(unlock: value));
  });
}
}


/// Adds pattern-matching-related methods to [BoardDef].
extension BoardDefPatterns on BoardDef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardDef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardDef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardDef value)  $default,){
final _that = this;
switch (_that) {
case _BoardDef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardDef value)?  $default,){
final _that = this;
switch (_that) {
case _BoardDef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String theme,  int size,  BoardUnlock unlock,  List<Jump> jumps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardDef() when $default != null:
return $default(_that.id,_that.name,_that.theme,_that.size,_that.unlock,_that.jumps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String theme,  int size,  BoardUnlock unlock,  List<Jump> jumps)  $default,) {final _that = this;
switch (_that) {
case _BoardDef():
return $default(_that.id,_that.name,_that.theme,_that.size,_that.unlock,_that.jumps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String theme,  int size,  BoardUnlock unlock,  List<Jump> jumps)?  $default,) {final _that = this;
switch (_that) {
case _BoardDef() when $default != null:
return $default(_that.id,_that.name,_that.theme,_that.size,_that.unlock,_that.jumps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BoardDef extends BoardDef {
  const _BoardDef({required this.id, required this.name, required this.theme, required this.size, required this.unlock, required final  List<Jump> jumps}): _jumps = jumps,super._();
  factory _BoardDef.fromJson(Map<String, dynamic> json) => _$BoardDefFromJson(json);

@override final  String id;
@override final  String name;
@override final  String theme;
@override final  int size;
@override final  BoardUnlock unlock;
 final  List<Jump> _jumps;
@override List<Jump> get jumps {
  if (_jumps is EqualUnmodifiableListView) return _jumps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jumps);
}


/// Create a copy of BoardDef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardDefCopyWith<_BoardDef> get copyWith => __$BoardDefCopyWithImpl<_BoardDef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoardDefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardDef&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.size, size) || other.size == size)&&(identical(other.unlock, unlock) || other.unlock == unlock)&&const DeepCollectionEquality().equals(other._jumps, _jumps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,theme,size,unlock,const DeepCollectionEquality().hash(_jumps));

@override
String toString() {
  return 'BoardDef(id: $id, name: $name, theme: $theme, size: $size, unlock: $unlock, jumps: $jumps)';
}


}

/// @nodoc
abstract mixin class _$BoardDefCopyWith<$Res> implements $BoardDefCopyWith<$Res> {
  factory _$BoardDefCopyWith(_BoardDef value, $Res Function(_BoardDef) _then) = __$BoardDefCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String theme, int size, BoardUnlock unlock, List<Jump> jumps
});


@override $BoardUnlockCopyWith<$Res> get unlock;

}
/// @nodoc
class __$BoardDefCopyWithImpl<$Res>
    implements _$BoardDefCopyWith<$Res> {
  __$BoardDefCopyWithImpl(this._self, this._then);

  final _BoardDef _self;
  final $Res Function(_BoardDef) _then;

/// Create a copy of BoardDef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? theme = null,Object? size = null,Object? unlock = null,Object? jumps = null,}) {
  return _then(_BoardDef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,unlock: null == unlock ? _self.unlock : unlock // ignore: cast_nullable_to_non_nullable
as BoardUnlock,jumps: null == jumps ? _self._jumps : jumps // ignore: cast_nullable_to_non_nullable
as List<Jump>,
  ));
}

/// Create a copy of BoardDef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardUnlockCopyWith<$Res> get unlock {
  
  return $BoardUnlockCopyWith<$Res>(_self.unlock, (value) {
    return _then(_self.copyWith(unlock: value));
  });
}
}

// dart format on
