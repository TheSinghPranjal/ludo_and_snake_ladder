// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snakes_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SnakesState {

 String get boardId; SnakesRules get rules; int get snakeCount; List<Player> get players;/// Square of each player's token, 0 = start pad, keyed by player id.
 Map<PlayerId, int> get positions; PlayerId? get currentPlayer; SnakesPhase get phase; int? get lastRoll;/// Sixes rolled in a row in the current turn.
 int get consecutiveSixes;/// Where the current player's token was when the turn began.
 int get turnStartPosition;/// Turns started so far, from 1.
 int get turnNumber; int get turnSeq; List<PlayerId> get ranking; List<PlayerId> get leavers;
/// Create a copy of SnakesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnakesStateCopyWith<SnakesState> get copyWith => _$SnakesStateCopyWithImpl<SnakesState>(this as SnakesState, _$identity);

  /// Serializes this SnakesState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnakesState&&(identical(other.boardId, boardId) || other.boardId == boardId)&&(identical(other.rules, rules) || other.rules == rules)&&(identical(other.snakeCount, snakeCount) || other.snakeCount == snakeCount)&&const DeepCollectionEquality().equals(other.players, players)&&const DeepCollectionEquality().equals(other.positions, positions)&&(identical(other.currentPlayer, currentPlayer) || other.currentPlayer == currentPlayer)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.lastRoll, lastRoll) || other.lastRoll == lastRoll)&&(identical(other.consecutiveSixes, consecutiveSixes) || other.consecutiveSixes == consecutiveSixes)&&(identical(other.turnStartPosition, turnStartPosition) || other.turnStartPosition == turnStartPosition)&&(identical(other.turnNumber, turnNumber) || other.turnNumber == turnNumber)&&(identical(other.turnSeq, turnSeq) || other.turnSeq == turnSeq)&&const DeepCollectionEquality().equals(other.ranking, ranking)&&const DeepCollectionEquality().equals(other.leavers, leavers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,boardId,rules,snakeCount,const DeepCollectionEquality().hash(players),const DeepCollectionEquality().hash(positions),currentPlayer,phase,lastRoll,consecutiveSixes,turnStartPosition,turnNumber,turnSeq,const DeepCollectionEquality().hash(ranking),const DeepCollectionEquality().hash(leavers));

@override
String toString() {
  return 'SnakesState(boardId: $boardId, rules: $rules, snakeCount: $snakeCount, players: $players, positions: $positions, currentPlayer: $currentPlayer, phase: $phase, lastRoll: $lastRoll, consecutiveSixes: $consecutiveSixes, turnStartPosition: $turnStartPosition, turnNumber: $turnNumber, turnSeq: $turnSeq, ranking: $ranking, leavers: $leavers)';
}


}

/// @nodoc
abstract mixin class $SnakesStateCopyWith<$Res>  {
  factory $SnakesStateCopyWith(SnakesState value, $Res Function(SnakesState) _then) = _$SnakesStateCopyWithImpl;
@useResult
$Res call({
 String boardId, SnakesRules rules, int snakeCount, List<Player> players, Map<PlayerId, int> positions, PlayerId? currentPlayer, SnakesPhase phase, int? lastRoll, int consecutiveSixes, int turnStartPosition, int turnNumber, int turnSeq, List<PlayerId> ranking, List<PlayerId> leavers
});


$SnakesRulesCopyWith<$Res> get rules;

}
/// @nodoc
class _$SnakesStateCopyWithImpl<$Res>
    implements $SnakesStateCopyWith<$Res> {
  _$SnakesStateCopyWithImpl(this._self, this._then);

  final SnakesState _self;
  final $Res Function(SnakesState) _then;

/// Create a copy of SnakesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? boardId = null,Object? rules = null,Object? snakeCount = null,Object? players = null,Object? positions = null,Object? currentPlayer = freezed,Object? phase = null,Object? lastRoll = freezed,Object? consecutiveSixes = null,Object? turnStartPosition = null,Object? turnNumber = null,Object? turnSeq = null,Object? ranking = null,Object? leavers = null,}) {
  return _then(_self.copyWith(
boardId: null == boardId ? _self.boardId : boardId // ignore: cast_nullable_to_non_nullable
as String,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as SnakesRules,snakeCount: null == snakeCount ? _self.snakeCount : snakeCount // ignore: cast_nullable_to_non_nullable
as int,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,positions: null == positions ? _self.positions : positions // ignore: cast_nullable_to_non_nullable
as Map<PlayerId, int>,currentPlayer: freezed == currentPlayer ? _self.currentPlayer : currentPlayer // ignore: cast_nullable_to_non_nullable
as PlayerId?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as SnakesPhase,lastRoll: freezed == lastRoll ? _self.lastRoll : lastRoll // ignore: cast_nullable_to_non_nullable
as int?,consecutiveSixes: null == consecutiveSixes ? _self.consecutiveSixes : consecutiveSixes // ignore: cast_nullable_to_non_nullable
as int,turnStartPosition: null == turnStartPosition ? _self.turnStartPosition : turnStartPosition // ignore: cast_nullable_to_non_nullable
as int,turnNumber: null == turnNumber ? _self.turnNumber : turnNumber // ignore: cast_nullable_to_non_nullable
as int,turnSeq: null == turnSeq ? _self.turnSeq : turnSeq // ignore: cast_nullable_to_non_nullable
as int,ranking: null == ranking ? _self.ranking : ranking // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,leavers: null == leavers ? _self.leavers : leavers // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,
  ));
}
/// Create a copy of SnakesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SnakesRulesCopyWith<$Res> get rules {
  
  return $SnakesRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}
}


/// Adds pattern-matching-related methods to [SnakesState].
extension SnakesStatePatterns on SnakesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnakesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnakesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnakesState value)  $default,){
final _that = this;
switch (_that) {
case _SnakesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnakesState value)?  $default,){
final _that = this;
switch (_that) {
case _SnakesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String boardId,  SnakesRules rules,  int snakeCount,  List<Player> players,  Map<PlayerId, int> positions,  PlayerId? currentPlayer,  SnakesPhase phase,  int? lastRoll,  int consecutiveSixes,  int turnStartPosition,  int turnNumber,  int turnSeq,  List<PlayerId> ranking,  List<PlayerId> leavers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnakesState() when $default != null:
return $default(_that.boardId,_that.rules,_that.snakeCount,_that.players,_that.positions,_that.currentPlayer,_that.phase,_that.lastRoll,_that.consecutiveSixes,_that.turnStartPosition,_that.turnNumber,_that.turnSeq,_that.ranking,_that.leavers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String boardId,  SnakesRules rules,  int snakeCount,  List<Player> players,  Map<PlayerId, int> positions,  PlayerId? currentPlayer,  SnakesPhase phase,  int? lastRoll,  int consecutiveSixes,  int turnStartPosition,  int turnNumber,  int turnSeq,  List<PlayerId> ranking,  List<PlayerId> leavers)  $default,) {final _that = this;
switch (_that) {
case _SnakesState():
return $default(_that.boardId,_that.rules,_that.snakeCount,_that.players,_that.positions,_that.currentPlayer,_that.phase,_that.lastRoll,_that.consecutiveSixes,_that.turnStartPosition,_that.turnNumber,_that.turnSeq,_that.ranking,_that.leavers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String boardId,  SnakesRules rules,  int snakeCount,  List<Player> players,  Map<PlayerId, int> positions,  PlayerId? currentPlayer,  SnakesPhase phase,  int? lastRoll,  int consecutiveSixes,  int turnStartPosition,  int turnNumber,  int turnSeq,  List<PlayerId> ranking,  List<PlayerId> leavers)?  $default,) {final _that = this;
switch (_that) {
case _SnakesState() when $default != null:
return $default(_that.boardId,_that.rules,_that.snakeCount,_that.players,_that.positions,_that.currentPlayer,_that.phase,_that.lastRoll,_that.consecutiveSixes,_that.turnStartPosition,_that.turnNumber,_that.turnSeq,_that.ranking,_that.leavers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SnakesState extends SnakesState {
  const _SnakesState({required this.boardId, required this.rules, required this.snakeCount, required final  List<Player> players, required final  Map<PlayerId, int> positions, required this.currentPlayer, required this.phase, this.lastRoll, this.consecutiveSixes = 0, this.turnStartPosition = 0, this.turnNumber = 1, this.turnSeq = 0, final  List<PlayerId> ranking = const <PlayerId>[], final  List<PlayerId> leavers = const <PlayerId>[]}): _players = players,_positions = positions,_ranking = ranking,_leavers = leavers,super._();
  factory _SnakesState.fromJson(Map<String, dynamic> json) => _$SnakesStateFromJson(json);

@override final  String boardId;
@override final  SnakesRules rules;
@override final  int snakeCount;
 final  List<Player> _players;
@override List<Player> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

/// Square of each player's token, 0 = start pad, keyed by player id.
 final  Map<PlayerId, int> _positions;
/// Square of each player's token, 0 = start pad, keyed by player id.
@override Map<PlayerId, int> get positions {
  if (_positions is EqualUnmodifiableMapView) return _positions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_positions);
}

@override final  PlayerId? currentPlayer;
@override final  SnakesPhase phase;
@override final  int? lastRoll;
/// Sixes rolled in a row in the current turn.
@override@JsonKey() final  int consecutiveSixes;
/// Where the current player's token was when the turn began.
@override@JsonKey() final  int turnStartPosition;
/// Turns started so far, from 1.
@override@JsonKey() final  int turnNumber;
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


/// Create a copy of SnakesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnakesStateCopyWith<_SnakesState> get copyWith => __$SnakesStateCopyWithImpl<_SnakesState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnakesStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnakesState&&(identical(other.boardId, boardId) || other.boardId == boardId)&&(identical(other.rules, rules) || other.rules == rules)&&(identical(other.snakeCount, snakeCount) || other.snakeCount == snakeCount)&&const DeepCollectionEquality().equals(other._players, _players)&&const DeepCollectionEquality().equals(other._positions, _positions)&&(identical(other.currentPlayer, currentPlayer) || other.currentPlayer == currentPlayer)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.lastRoll, lastRoll) || other.lastRoll == lastRoll)&&(identical(other.consecutiveSixes, consecutiveSixes) || other.consecutiveSixes == consecutiveSixes)&&(identical(other.turnStartPosition, turnStartPosition) || other.turnStartPosition == turnStartPosition)&&(identical(other.turnNumber, turnNumber) || other.turnNumber == turnNumber)&&(identical(other.turnSeq, turnSeq) || other.turnSeq == turnSeq)&&const DeepCollectionEquality().equals(other._ranking, _ranking)&&const DeepCollectionEquality().equals(other._leavers, _leavers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,boardId,rules,snakeCount,const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_positions),currentPlayer,phase,lastRoll,consecutiveSixes,turnStartPosition,turnNumber,turnSeq,const DeepCollectionEquality().hash(_ranking),const DeepCollectionEquality().hash(_leavers));

@override
String toString() {
  return 'SnakesState(boardId: $boardId, rules: $rules, snakeCount: $snakeCount, players: $players, positions: $positions, currentPlayer: $currentPlayer, phase: $phase, lastRoll: $lastRoll, consecutiveSixes: $consecutiveSixes, turnStartPosition: $turnStartPosition, turnNumber: $turnNumber, turnSeq: $turnSeq, ranking: $ranking, leavers: $leavers)';
}


}

/// @nodoc
abstract mixin class _$SnakesStateCopyWith<$Res> implements $SnakesStateCopyWith<$Res> {
  factory _$SnakesStateCopyWith(_SnakesState value, $Res Function(_SnakesState) _then) = __$SnakesStateCopyWithImpl;
@override @useResult
$Res call({
 String boardId, SnakesRules rules, int snakeCount, List<Player> players, Map<PlayerId, int> positions, PlayerId? currentPlayer, SnakesPhase phase, int? lastRoll, int consecutiveSixes, int turnStartPosition, int turnNumber, int turnSeq, List<PlayerId> ranking, List<PlayerId> leavers
});


@override $SnakesRulesCopyWith<$Res> get rules;

}
/// @nodoc
class __$SnakesStateCopyWithImpl<$Res>
    implements _$SnakesStateCopyWith<$Res> {
  __$SnakesStateCopyWithImpl(this._self, this._then);

  final _SnakesState _self;
  final $Res Function(_SnakesState) _then;

/// Create a copy of SnakesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? boardId = null,Object? rules = null,Object? snakeCount = null,Object? players = null,Object? positions = null,Object? currentPlayer = freezed,Object? phase = null,Object? lastRoll = freezed,Object? consecutiveSixes = null,Object? turnStartPosition = null,Object? turnNumber = null,Object? turnSeq = null,Object? ranking = null,Object? leavers = null,}) {
  return _then(_SnakesState(
boardId: null == boardId ? _self.boardId : boardId // ignore: cast_nullable_to_non_nullable
as String,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as SnakesRules,snakeCount: null == snakeCount ? _self.snakeCount : snakeCount // ignore: cast_nullable_to_non_nullable
as int,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,positions: null == positions ? _self._positions : positions // ignore: cast_nullable_to_non_nullable
as Map<PlayerId, int>,currentPlayer: freezed == currentPlayer ? _self.currentPlayer : currentPlayer // ignore: cast_nullable_to_non_nullable
as PlayerId?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as SnakesPhase,lastRoll: freezed == lastRoll ? _self.lastRoll : lastRoll // ignore: cast_nullable_to_non_nullable
as int?,consecutiveSixes: null == consecutiveSixes ? _self.consecutiveSixes : consecutiveSixes // ignore: cast_nullable_to_non_nullable
as int,turnStartPosition: null == turnStartPosition ? _self.turnStartPosition : turnStartPosition // ignore: cast_nullable_to_non_nullable
as int,turnNumber: null == turnNumber ? _self.turnNumber : turnNumber // ignore: cast_nullable_to_non_nullable
as int,turnSeq: null == turnSeq ? _self.turnSeq : turnSeq // ignore: cast_nullable_to_non_nullable
as int,ranking: null == ranking ? _self._ranking : ranking // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,leavers: null == leavers ? _self._leavers : leavers // ignore: cast_nullable_to_non_nullable
as List<PlayerId>,
  ));
}

/// Create a copy of SnakesState
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
