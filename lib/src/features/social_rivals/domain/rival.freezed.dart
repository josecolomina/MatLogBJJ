// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rival.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Rival {

 String get rivalUid; String get rivalName; int get wins; int get losses; int get draws;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get lastRolledAt; String get notes;
/// Create a copy of Rival
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RivalCopyWith<Rival> get copyWith => _$RivalCopyWithImpl<Rival>(this as Rival, _$identity);

  /// Serializes this Rival to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Rival&&(identical(other.rivalUid, rivalUid) || other.rivalUid == rivalUid)&&(identical(other.rivalName, rivalName) || other.rivalName == rivalName)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.losses, losses) || other.losses == losses)&&(identical(other.draws, draws) || other.draws == draws)&&(identical(other.lastRolledAt, lastRolledAt) || other.lastRolledAt == lastRolledAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rivalUid,rivalName,wins,losses,draws,lastRolledAt,notes);

@override
String toString() {
  return 'Rival(rivalUid: $rivalUid, rivalName: $rivalName, wins: $wins, losses: $losses, draws: $draws, lastRolledAt: $lastRolledAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $RivalCopyWith<$Res>  {
  factory $RivalCopyWith(Rival value, $Res Function(Rival) _then) = _$RivalCopyWithImpl;
@useResult
$Res call({
 String rivalUid, String rivalName, int wins, int losses, int draws,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime lastRolledAt, String notes
});




}
/// @nodoc
class _$RivalCopyWithImpl<$Res>
    implements $RivalCopyWith<$Res> {
  _$RivalCopyWithImpl(this._self, this._then);

  final Rival _self;
  final $Res Function(Rival) _then;

/// Create a copy of Rival
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rivalUid = null,Object? rivalName = null,Object? wins = null,Object? losses = null,Object? draws = null,Object? lastRolledAt = null,Object? notes = null,}) {
  return _then(_self.copyWith(
rivalUid: null == rivalUid ? _self.rivalUid : rivalUid // ignore: cast_nullable_to_non_nullable
as String,rivalName: null == rivalName ? _self.rivalName : rivalName // ignore: cast_nullable_to_non_nullable
as String,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,losses: null == losses ? _self.losses : losses // ignore: cast_nullable_to_non_nullable
as int,draws: null == draws ? _self.draws : draws // ignore: cast_nullable_to_non_nullable
as int,lastRolledAt: null == lastRolledAt ? _self.lastRolledAt : lastRolledAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Rival].
extension RivalPatterns on Rival {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Rival value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Rival() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Rival value)  $default,){
final _that = this;
switch (_that) {
case _Rival():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Rival value)?  $default,){
final _that = this;
switch (_that) {
case _Rival() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rivalUid,  String rivalName,  int wins,  int losses,  int draws, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime lastRolledAt,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Rival() when $default != null:
return $default(_that.rivalUid,_that.rivalName,_that.wins,_that.losses,_that.draws,_that.lastRolledAt,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rivalUid,  String rivalName,  int wins,  int losses,  int draws, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime lastRolledAt,  String notes)  $default,) {final _that = this;
switch (_that) {
case _Rival():
return $default(_that.rivalUid,_that.rivalName,_that.wins,_that.losses,_that.draws,_that.lastRolledAt,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rivalUid,  String rivalName,  int wins,  int losses,  int draws, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime lastRolledAt,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _Rival() when $default != null:
return $default(_that.rivalUid,_that.rivalName,_that.wins,_that.losses,_that.draws,_that.lastRolledAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Rival implements Rival {
  const _Rival({required this.rivalUid, required this.rivalName, required this.wins, required this.losses, required this.draws, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.lastRolledAt, required this.notes});
  factory _Rival.fromJson(Map<String, dynamic> json) => _$RivalFromJson(json);

@override final  String rivalUid;
@override final  String rivalName;
@override final  int wins;
@override final  int losses;
@override final  int draws;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime lastRolledAt;
@override final  String notes;

/// Create a copy of Rival
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RivalCopyWith<_Rival> get copyWith => __$RivalCopyWithImpl<_Rival>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RivalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rival&&(identical(other.rivalUid, rivalUid) || other.rivalUid == rivalUid)&&(identical(other.rivalName, rivalName) || other.rivalName == rivalName)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.losses, losses) || other.losses == losses)&&(identical(other.draws, draws) || other.draws == draws)&&(identical(other.lastRolledAt, lastRolledAt) || other.lastRolledAt == lastRolledAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rivalUid,rivalName,wins,losses,draws,lastRolledAt,notes);

@override
String toString() {
  return 'Rival(rivalUid: $rivalUid, rivalName: $rivalName, wins: $wins, losses: $losses, draws: $draws, lastRolledAt: $lastRolledAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$RivalCopyWith<$Res> implements $RivalCopyWith<$Res> {
  factory _$RivalCopyWith(_Rival value, $Res Function(_Rival) _then) = __$RivalCopyWithImpl;
@override @useResult
$Res call({
 String rivalUid, String rivalName, int wins, int losses, int draws,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime lastRolledAt, String notes
});




}
/// @nodoc
class __$RivalCopyWithImpl<$Res>
    implements _$RivalCopyWith<$Res> {
  __$RivalCopyWithImpl(this._self, this._then);

  final _Rival _self;
  final $Res Function(_Rival) _then;

/// Create a copy of Rival
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rivalUid = null,Object? rivalName = null,Object? wins = null,Object? losses = null,Object? draws = null,Object? lastRolledAt = null,Object? notes = null,}) {
  return _then(_Rival(
rivalUid: null == rivalUid ? _self.rivalUid : rivalUid // ignore: cast_nullable_to_non_nullable
as String,rivalName: null == rivalName ? _self.rivalName : rivalName // ignore: cast_nullable_to_non_nullable
as String,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,losses: null == losses ? _self.losses : losses // ignore: cast_nullable_to_non_nullable
as int,draws: null == draws ? _self.draws : draws // ignore: cast_nullable_to_non_nullable
as int,lastRolledAt: null == lastRolledAt ? _self.lastRolledAt : lastRolledAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
