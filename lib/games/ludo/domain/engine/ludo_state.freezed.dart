// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ludo_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LudoState {

/// Players in clockwise turn order.
 List<Player> get players;/// Relative progress of each player's 4 tokens, keyed by player id.
 Map<PlayerId, List<int>> get tokens; PlayerId? get currentPlayer; LudoPhase get phase;/// The roll waiting to be played, during [LudoPhase.awaitingMove].
 int? get dice;/// Consecutive sixes rolled in the current turn.
 int get sixesThisTurn; int get turnSeq; List<PlayerId> get ranking; List<PlayerId> get leavers;
/// Create a copy of LudoState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LudoStateCopyWith<LudoState> get copyWith => _$LudoStateCopyWithImpl<LudoState>(this as LudoState, _$identity);

  /// Serializes this LudoState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LudoState&&const DeepCollectionEquality().equals(other.players, players)&&const DeepCollectionEquality().equals(other.tokens, tokens)&&(identical(other.currentPlayer, currentPlayer) || other.currentPlayer == currentPlayer)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.dice, dice) || other.dice == dice)&&(identical(other.sixesThisTurn, sixesThisTurn) || other.sixesThisTurn == sixesThisTurn)&&(identical(other.turnSeq, turnSeq) || other.turnSeq == turnSeq)&&const DeepCollectionEquality().equals(other.ranking, ranking)&&const DeepCollectionEquality().equals(other.leavers, leavers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),const DeepCollectionEquality().hash(tokens),currentPlayer,phase,dice,sixesThisTurn,turnSeq,const DeepCollectionEquality().hash(ranking),const DeepCollectionEquality().hash(leavers));

@override
String toString() {
  return 'LudoState(players: $players, tokens: $tokens, currentPlayer: $currentPlayer, phase: $phase, dice: $dice, sixesThisTurn: $sixesThisTurn, turnSeq: $turnSeq, ranking: $ranking, leavers: $leavers)';
}


}

/// @nodoc
abstract mixin class $LudoStateCopyWith<$Res>  {
  factory $LudoStateCopyWith(LudoState value, $Res Function(LudoState) _then) = _$LudoStateCopyWithImpl;
@useResult
$Res call({
 List<Player> players, Map<PlayerId, List<int>> tokens, PlayerId? currentPlayer, LudoPhase phase, int? dice, int sixesThisTurn, int turnSeq, List<PlayerId> ranking, List<PlayerId> leavers
});




}
/// @nodoc
class _$LudoStateCopyWithImpl<$Res>
    implements $LudoStateCopyWith<$Res> {
  _$LudoStateCopyWithImpl(this._self, this._then);

  final LudoState _self;
  final $Res Function(LudoState) _then;

/// Create a copy of LudoState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? tokens = null,Object? currentPlayer = freezed,Object? phase = null,Object? dice = freezed,Object? sixesThisTurn = null,Object? turnSeq = null,Object? ranking = null,Object? leavers = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as Map<PlayerId, List<int>>,currentPlayer: freezed == currentPlayer ? _self.currentPlayer : currentPlayer // ignore: cast_nullable_to_non_nullable
as PlayerId?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as LudoPhase,dice: freezed == dice ? _self.dice : dice // ignore: cast_nullable_to_non_nullable
as int?,sixesThisTurn: null == sixesThisTurn ? _self.sixesThisTurn : sixesThisTurn // ignore: cast_nullable_to_non_nullable
as int,turnSeq: null == turnSeq ? _self.turnSeq : turnSeq // ignore: cast_nullable_to_non_nullable
as int,ranking: null == ranking ? _self.ranking : ranking // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,leavers: null == leavers ? _self.leavers : leavers // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,
  ));
}

}


/// Adds pattern-matching-related methods to [LudoState].
extension LudoStatePatterns on LudoState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LudoState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LudoState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LudoState value)  $default,){
final _that = this;
switch (_that) {
case _LudoState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LudoState value)?  $default,){
final _that = this;
switch (_that) {
case _LudoState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Player> players,  Map<PlayerId, List<int>> tokens,  PlayerId? currentPlayer,  LudoPhase phase,  int? dice,  int sixesThisTurn,  int turnSeq,  List<PlayerId> ranking,  List<PlayerId> leavers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LudoState() when $default != null:
return $default(_that.players,_that.tokens,_that.currentPlayer,_that.phase,_that.dice,_that.sixesThisTurn,_that.turnSeq,_that.ranking,_that.leavers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Player> players,  Map<PlayerId, List<int>> tokens,  PlayerId? currentPlayer,  LudoPhase phase,  int? dice,  int sixesThisTurn,  int turnSeq,  List<PlayerId> ranking,  List<PlayerId> leavers)  $default,) {final _that = this;
switch (_that) {
case _LudoState():
return $default(_that.players,_that.tokens,_that.currentPlayer,_that.phase,_that.dice,_that.sixesThisTurn,_that.turnSeq,_that.ranking,_that.leavers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Player> players,  Map<PlayerId, List<int>> tokens,  PlayerId? currentPlayer,  LudoPhase phase,  int? dice,  int sixesThisTurn,  int turnSeq,  List<PlayerId> ranking,  List<PlayerId> leavers)?  $default,) {final _that = this;
switch (_that) {
case _LudoState() when $default != null:
return $default(_that.players,_that.tokens,_that.currentPlayer,_that.phase,_that.dice,_that.sixesThisTurn,_that.turnSeq,_that.ranking,_that.leavers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LudoState extends LudoState {
  const _LudoState({required final  List<Player> players, required final  Map<PlayerId, List<int>> tokens, required this.currentPlayer, required this.phase, this.dice, this.sixesThisTurn = 0, this.turnSeq = 0, final  List<PlayerId> ranking = const <PlayerId>[], final  List<PlayerId> leavers = const <PlayerId>[]}): _players = players,_tokens = tokens,_ranking = ranking,_leavers = leavers,super._();
  factory _LudoState.fromJson(Map<String, dynamic> json) => _$LudoStateFromJson(json);

/// Players in clockwise turn order.
 final  List<Player> _players;
/// Players in clockwise turn order.
@override List<Player> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

/// Relative progress of each player's 4 tokens, keyed by player id.
 final  Map<PlayerId, List<int>> _tokens;
/// Relative progress of each player's 4 tokens, keyed by player id.
@override Map<PlayerId, List<int>> get tokens {
  if (_tokens is EqualUnmodifiableMapView) return _tokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_tokens);
}

@override final  PlayerId? currentPlayer;
@override final  LudoPhase phase;
/// The roll waiting to be played, during [LudoPhase.awaitingMove].
@override final  int? dice;
/// Consecutive sixes rolled in the current turn.
@override@JsonKey() final  int sixesThisTurn;
@override@JsonKey() final  int turnSeq;
 final  List<PlayerId> _ranking;
@override@JsonKey() List<PlayerId> get ranking {
  if (_ranking is EqualUnmodifiableListView) return _ranking;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ranking);
}

 final  List<PlayerId> _leavers;
@override@JsonKey() List<PlayerId> get leavers {
  if (_leavers is EqualUnmodifiableListView) return _leavers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leavers);
}


/// Create a copy of LudoState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LudoStateCopyWith<_LudoState> get copyWith => __$LudoStateCopyWithImpl<_LudoState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LudoStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LudoState&&const DeepCollectionEquality().equals(other._players, _players)&&const DeepCollectionEquality().equals(other._tokens, _tokens)&&(identical(other.currentPlayer, currentPlayer) || other.currentPlayer == currentPlayer)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.dice, dice) || other.dice == dice)&&(identical(other.sixesThisTurn, sixesThisTurn) || other.sixesThisTurn == sixesThisTurn)&&(identical(other.turnSeq, turnSeq) || other.turnSeq == turnSeq)&&const DeepCollectionEquality().equals(other._ranking, _ranking)&&const DeepCollectionEquality().equals(other._leavers, _leavers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_tokens),currentPlayer,phase,dice,sixesThisTurn,turnSeq,const DeepCollectionEquality().hash(_ranking),const DeepCollectionEquality().hash(_leavers));

@override
String toString() {
  return 'LudoState(players: $players, tokens: $tokens, currentPlayer: $currentPlayer, phase: $phase, dice: $dice, sixesThisTurn: $sixesThisTurn, turnSeq: $turnSeq, ranking: $ranking, leavers: $leavers)';
}


}

/// @nodoc
abstract mixin class _$LudoStateCopyWith<$Res> implements $LudoStateCopyWith<$Res> {
  factory _$LudoStateCopyWith(_LudoState value, $Res Function(_LudoState) _then) = __$LudoStateCopyWithImpl;
@override @useResult
$Res call({
 List<Player> players, Map<PlayerId, List<int>> tokens, PlayerId? currentPlayer, LudoPhase phase, int? dice, int sixesThisTurn, int turnSeq, List<PlayerId> ranking, List<PlayerId> leavers
});




}
/// @nodoc
class __$LudoStateCopyWithImpl<$Res>
    implements _$LudoStateCopyWith<$Res> {
  __$LudoStateCopyWithImpl(this._self, this._then);

  final _LudoState _self;
  final $Res Function(_LudoState) _then;

/// Create a copy of LudoState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? tokens = null,Object? currentPlayer = freezed,Object? phase = null,Object? dice = freezed,Object? sixesThisTurn = null,Object? turnSeq = null,Object? ranking = null,Object? leavers = null,}) {
  return _then(_LudoState(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,tokens: null == tokens ? _self._tokens : tokens // ignore: cast_nullable_to_non_nullable
as Map<PlayerId, List<int>>,currentPlayer: freezed == currentPlayer ? _self.currentPlayer : currentPlayer // ignore: cast_nullable_to_non_nullable
as PlayerId?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as LudoPhase,dice: freezed == dice ? _self.dice : dice // ignore: cast_nullable_to_non_nullable
as int?,sixesThisTurn: null == sixesThisTurn ? _self.sixesThisTurn : sixesThisTurn // ignore: cast_nullable_to_non_nullable
as int,turnSeq: null == turnSeq ? _self.turnSeq : turnSeq // ignore: cast_nullable_to_non_nullable
as int,ranking: null == ranking ? _self._ranking : ranking // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,leavers: null == leavers ? _self._leavers : leavers // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,
  ));
}


}

// dart format on
