// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snakes_rules.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SnakesRules {

/// A token at 0 needs a 6, which places it on square 1.
 bool get needSixToStart;/// What happens on a roll past 100.
 Overshoot get overshoot;/// A 6 gives another roll.
 bool get extraRollOnSix;/// A third 6 in a row ends the turn and returns the token to where it
/// started the turn.
 bool get threeSixesPenalty;/// Landing on an opponent sends them to 0.
 bool get capture;/// When the game ends.
 PlayTo get playTo;
/// Create a copy of SnakesRules
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnakesRulesCopyWith<SnakesRules> get copyWith => _$SnakesRulesCopyWithImpl<SnakesRules>(this as SnakesRules, _$identity);

  /// Serializes this SnakesRules to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnakesRules&&(identical(other.needSixToStart, needSixToStart) || other.needSixToStart == needSixToStart)&&(identical(other.overshoot, overshoot) || other.overshoot == overshoot)&&(identical(other.extraRollOnSix, extraRollOnSix) || other.extraRollOnSix == extraRollOnSix)&&(identical(other.threeSixesPenalty, threeSixesPenalty) || other.threeSixesPenalty == threeSixesPenalty)&&(identical(other.capture, capture) || other.capture == capture)&&(identical(other.playTo, playTo) || other.playTo == playTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,needSixToStart,overshoot,extraRollOnSix,threeSixesPenalty,capture,playTo);

@override
String toString() {
  return 'SnakesRules(needSixToStart: $needSixToStart, overshoot: $overshoot, extraRollOnSix: $extraRollOnSix, threeSixesPenalty: $threeSixesPenalty, capture: $capture, playTo: $playTo)';
}


}

/// @nodoc
abstract mixin class $SnakesRulesCopyWith<$Res>  {
  factory $SnakesRulesCopyWith(SnakesRules value, $Res Function(SnakesRules) _then) = _$SnakesRulesCopyWithImpl;
@useResult
$Res call({
 bool needSixToStart, Overshoot overshoot, bool extraRollOnSix, bool threeSixesPenalty, bool capture, PlayTo playTo
});




}
/// @nodoc
class _$SnakesRulesCopyWithImpl<$Res>
    implements $SnakesRulesCopyWith<$Res> {
  _$SnakesRulesCopyWithImpl(this._self, this._then);

  final SnakesRules _self;
  final $Res Function(SnakesRules) _then;

/// Create a copy of SnakesRules
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? needSixToStart = null,Object? overshoot = null,Object? extraRollOnSix = null,Object? threeSixesPenalty = null,Object? capture = null,Object? playTo = null,}) {
  return _then(_self.copyWith(
needSixToStart: null == needSixToStart ? _self.needSixToStart : needSixToStart // ignore: cast_nullable_to_non_nullable
as bool,overshoot: null == overshoot ? _self.overshoot : overshoot // ignore: cast_nullable_to_non_nullable
as Overshoot,extraRollOnSix: null == extraRollOnSix ? _self.extraRollOnSix : extraRollOnSix // ignore: cast_nullable_to_non_nullable
as bool,threeSixesPenalty: null == threeSixesPenalty ? _self.threeSixesPenalty : threeSixesPenalty // ignore: cast_nullable_to_non_nullable
as bool,capture: null == capture ? _self.capture : capture // ignore: cast_nullable_to_non_nullable
as bool,playTo: null == playTo ? _self.playTo : playTo // ignore: cast_nullable_to_non_nullable
as PlayTo,
  ));
}

}


/// Adds pattern-matching-related methods to [SnakesRules].
extension SnakesRulesPatterns on SnakesRules {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnakesRules value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnakesRules() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnakesRules value)  $default,){
final _that = this;
switch (_that) {
case _SnakesRules():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnakesRules value)?  $default,){
final _that = this;
switch (_that) {
case _SnakesRules() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool needSixToStart,  Overshoot overshoot,  bool extraRollOnSix,  bool threeSixesPenalty,  bool capture,  PlayTo playTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnakesRules() when $default != null:
return $default(_that.needSixToStart,_that.overshoot,_that.extraRollOnSix,_that.threeSixesPenalty,_that.capture,_that.playTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool needSixToStart,  Overshoot overshoot,  bool extraRollOnSix,  bool threeSixesPenalty,  bool capture,  PlayTo playTo)  $default,) {final _that = this;
switch (_that) {
case _SnakesRules():
return $default(_that.needSixToStart,_that.overshoot,_that.extraRollOnSix,_that.threeSixesPenalty,_that.capture,_that.playTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool needSixToStart,  Overshoot overshoot,  bool extraRollOnSix,  bool threeSixesPenalty,  bool capture,  PlayTo playTo)?  $default,) {final _that = this;
switch (_that) {
case _SnakesRules() when $default != null:
return $default(_that.needSixToStart,_that.overshoot,_that.extraRollOnSix,_that.threeSixesPenalty,_that.capture,_that.playTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SnakesRules implements SnakesRules {
  const _SnakesRules({this.needSixToStart = false, this.overshoot = Overshoot.stay, this.extraRollOnSix = true, this.threeSixesPenalty = true, this.capture = false, this.playTo = PlayTo.firstWinner});
  factory _SnakesRules.fromJson(Map<String, dynamic> json) => _$SnakesRulesFromJson(json);

/// A token at 0 needs a 6, which places it on square 1.
@override@JsonKey() final  bool needSixToStart;
/// What happens on a roll past 100.
@override@JsonKey() final  Overshoot overshoot;
/// A 6 gives another roll.
@override@JsonKey() final  bool extraRollOnSix;
/// A third 6 in a row ends the turn and returns the token to where it
/// started the turn.
@override@JsonKey() final  bool threeSixesPenalty;
/// Landing on an opponent sends them to 0.
@override@JsonKey() final  bool capture;
/// When the game ends.
@override@JsonKey() final  PlayTo playTo;

/// Create a copy of SnakesRules
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnakesRulesCopyWith<_SnakesRules> get copyWith => __$SnakesRulesCopyWithImpl<_SnakesRules>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnakesRulesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnakesRules&&(identical(other.needSixToStart, needSixToStart) || other.needSixToStart == needSixToStart)&&(identical(other.overshoot, overshoot) || other.overshoot == overshoot)&&(identical(other.extraRollOnSix, extraRollOnSix) || other.extraRollOnSix == extraRollOnSix)&&(identical(other.threeSixesPenalty, threeSixesPenalty) || other.threeSixesPenalty == threeSixesPenalty)&&(identical(other.capture, capture) || other.capture == capture)&&(identical(other.playTo, playTo) || other.playTo == playTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,needSixToStart,overshoot,extraRollOnSix,threeSixesPenalty,capture,playTo);

@override
String toString() {
  return 'SnakesRules(needSixToStart: $needSixToStart, overshoot: $overshoot, extraRollOnSix: $extraRollOnSix, threeSixesPenalty: $threeSixesPenalty, capture: $capture, playTo: $playTo)';
}


}

/// @nodoc
abstract mixin class _$SnakesRulesCopyWith<$Res> implements $SnakesRulesCopyWith<$Res> {
  factory _$SnakesRulesCopyWith(_SnakesRules value, $Res Function(_SnakesRules) _then) = __$SnakesRulesCopyWithImpl;
@override @useResult
$Res call({
 bool needSixToStart, Overshoot overshoot, bool extraRollOnSix, bool threeSixesPenalty, bool capture, PlayTo playTo
});




}
/// @nodoc
class __$SnakesRulesCopyWithImpl<$Res>
    implements _$SnakesRulesCopyWith<$Res> {
  __$SnakesRulesCopyWithImpl(this._self, this._then);

  final _SnakesRules _self;
  final $Res Function(_SnakesRules) _then;

/// Create a copy of SnakesRules
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? needSixToStart = null,Object? overshoot = null,Object? extraRollOnSix = null,Object? threeSixesPenalty = null,Object? capture = null,Object? playTo = null,}) {
  return _then(_SnakesRules(
needSixToStart: null == needSixToStart ? _self.needSixToStart : needSixToStart // ignore: cast_nullable_to_non_nullable
as bool,overshoot: null == overshoot ? _self.overshoot : overshoot // ignore: cast_nullable_to_non_nullable
as Overshoot,extraRollOnSix: null == extraRollOnSix ? _self.extraRollOnSix : extraRollOnSix // ignore: cast_nullable_to_non_nullable
as bool,threeSixesPenalty: null == threeSixesPenalty ? _self.threeSixesPenalty : threeSixesPenalty // ignore: cast_nullable_to_non_nullable
as bool,capture: null == capture ? _self.capture : capture // ignore: cast_nullable_to_non_nullable
as bool,playTo: null == playTo ? _self.playTo : playTo // ignore: cast_nullable_to_non_nullable
as PlayTo,
  ));
}


}


/// @nodoc
mixin _$SnakesConfig {

 String get boardId; int get snakeCount; SnakesRules get rules;
/// Create a copy of SnakesConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnakesConfigCopyWith<SnakesConfig> get copyWith => _$SnakesConfigCopyWithImpl<SnakesConfig>(this as SnakesConfig, _$identity);

  /// Serializes this SnakesConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnakesConfig&&(identical(other.boardId, boardId) || other.boardId == boardId)&&(identical(other.snakeCount, snakeCount) || other.snakeCount == snakeCount)&&(identical(other.rules, rules) || other.rules == rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,boardId,snakeCount,rules);

@override
String toString() {
  return 'SnakesConfig(boardId: $boardId, snakeCount: $snakeCount, rules: $rules)';
}


}

/// @nodoc
abstract mixin class $SnakesConfigCopyWith<$Res>  {
  factory $SnakesConfigCopyWith(SnakesConfig value, $Res Function(SnakesConfig) _then) = _$SnakesConfigCopyWithImpl;
@useResult
$Res call({
 String boardId, int snakeCount, SnakesRules rules
});


$SnakesRulesCopyWith<$Res> get rules;

}
/// @nodoc
class _$SnakesConfigCopyWithImpl<$Res>
    implements $SnakesConfigCopyWith<$Res> {
  _$SnakesConfigCopyWithImpl(this._self, this._then);

  final SnakesConfig _self;
  final $Res Function(SnakesConfig) _then;

/// Create a copy of SnakesConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? boardId = null,Object? snakeCount = null,Object? rules = null,}) {
  return _then(_self.copyWith(
boardId: null == boardId ? _self.boardId : boardId // ignore: cast_nullable_to_non_nullable
as String,snakeCount: null == snakeCount ? _self.snakeCount : snakeCount // ignore: cast_nullable_to_non_nullable
as int,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as SnakesRules,
  ));
}
/// Create a copy of SnakesConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnakesRulesCopyWith<$Res> get rules {
  
  return $SnakesRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}
}


/// Adds pattern-matching-related methods to [SnakesConfig].
extension SnakesConfigPatterns on SnakesConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnakesConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnakesConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnakesConfig value)  $default,){
final _that = this;
switch (_that) {
case _SnakesConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnakesConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SnakesConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String boardId,  int snakeCount,  SnakesRules rules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnakesConfig() when $default != null:
return $default(_that.boardId,_that.snakeCount,_that.rules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String boardId,  int snakeCount,  SnakesRules rules)  $default,) {final _that = this;
switch (_that) {
case _SnakesConfig():
return $default(_that.boardId,_that.snakeCount,_that.rules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String boardId,  int snakeCount,  SnakesRules rules)?  $default,) {final _that = this;
switch (_that) {
case _SnakesConfig() when $default != null:
return $default(_that.boardId,_that.snakeCount,_that.rules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SnakesConfig implements SnakesConfig {
  const _SnakesConfig({this.boardId = 'classic_sunshine', this.snakeCount = defaultSnakes, this.rules = const SnakesRules()});
  factory _SnakesConfig.fromJson(Map<String, dynamic> json) => _$SnakesConfigFromJson(json);

@override@JsonKey() final  String boardId;
@override@JsonKey() final  int snakeCount;
@override@JsonKey() final  SnakesRules rules;

/// Create a copy of SnakesConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnakesConfigCopyWith<_SnakesConfig> get copyWith => __$SnakesConfigCopyWithImpl<_SnakesConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnakesConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnakesConfig&&(identical(other.boardId, boardId) || other.boardId == boardId)&&(identical(other.snakeCount, snakeCount) || other.snakeCount == snakeCount)&&(identical(other.rules, rules) || other.rules == rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,boardId,snakeCount,rules);

@override
String toString() {
  return 'SnakesConfig(boardId: $boardId, snakeCount: $snakeCount, rules: $rules)';
}


}

/// @nodoc
abstract mixin class _$SnakesConfigCopyWith<$Res> implements $SnakesConfigCopyWith<$Res> {
  factory _$SnakesConfigCopyWith(_SnakesConfig value, $Res Function(_SnakesConfig) _then) = __$SnakesConfigCopyWithImpl;
@override @useResult
$Res call({
 String boardId, int snakeCount, SnakesRules rules
});


@override $SnakesRulesCopyWith<$Res> get rules;

}
/// @nodoc
class __$SnakesConfigCopyWithImpl<$Res>
    implements _$SnakesConfigCopyWith<$Res> {
  __$SnakesConfigCopyWithImpl(this._self, this._then);

  final _SnakesConfig _self;
  final $Res Function(_SnakesConfig) _then;

/// Create a copy of SnakesConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? boardId = null,Object? snakeCount = null,Object? rules = null,}) {
  return _then(_SnakesConfig(
boardId: null == boardId ? _self.boardId : boardId // ignore: cast_nullable_to_non_nullable
as String,snakeCount: null == snakeCount ? _self.snakeCount : snakeCount // ignore: cast_nullable_to_non_nullable
as int,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as SnakesRules,
  ));
}

/// Create a copy of SnakesConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnakesRulesCopyWith<$Res> get rules {
  
  return $SnakesRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}
}

// dart format on
