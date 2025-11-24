// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Activity {

 String get activityId; String get userId; String get userName; String get userRank; String get academyName;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get timestampStart; int get durationMinutes; String get type;// gi, nogi, open_mat, seminar
 int get rpe; int get likesCount; bool get hasTechnicalNotes;
/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityCopyWith<Activity> get copyWith => _$ActivityCopyWithImpl<Activity>(this as Activity, _$identity);

  /// Serializes this Activity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Activity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userRank, userRank) || other.userRank == userRank)&&(identical(other.academyName, academyName) || other.academyName == academyName)&&(identical(other.timestampStart, timestampStart) || other.timestampStart == timestampStart)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.type, type) || other.type == type)&&(identical(other.rpe, rpe) || other.rpe == rpe)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.hasTechnicalNotes, hasTechnicalNotes) || other.hasTechnicalNotes == hasTechnicalNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,userId,userName,userRank,academyName,timestampStart,durationMinutes,type,rpe,likesCount,hasTechnicalNotes);

@override
String toString() {
  return 'Activity(activityId: $activityId, userId: $userId, userName: $userName, userRank: $userRank, academyName: $academyName, timestampStart: $timestampStart, durationMinutes: $durationMinutes, type: $type, rpe: $rpe, likesCount: $likesCount, hasTechnicalNotes: $hasTechnicalNotes)';
}


}

/// @nodoc
abstract mixin class $ActivityCopyWith<$Res>  {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) _then) = _$ActivityCopyWithImpl;
@useResult
$Res call({
 String activityId, String userId, String userName, String userRank, String academyName,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime timestampStart, int durationMinutes, String type, int rpe, int likesCount, bool hasTechnicalNotes
});




}
/// @nodoc
class _$ActivityCopyWithImpl<$Res>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._self, this._then);

  final Activity _self;
  final $Res Function(Activity) _then;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityId = null,Object? userId = null,Object? userName = null,Object? userRank = null,Object? academyName = null,Object? timestampStart = null,Object? durationMinutes = null,Object? type = null,Object? rpe = null,Object? likesCount = null,Object? hasTechnicalNotes = null,}) {
  return _then(_self.copyWith(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userRank: null == userRank ? _self.userRank : userRank // ignore: cast_nullable_to_non_nullable
as String,academyName: null == academyName ? _self.academyName : academyName // ignore: cast_nullable_to_non_nullable
as String,timestampStart: null == timestampStart ? _self.timestampStart : timestampStart // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,rpe: null == rpe ? _self.rpe : rpe // ignore: cast_nullable_to_non_nullable
as int,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,hasTechnicalNotes: null == hasTechnicalNotes ? _self.hasTechnicalNotes : hasTechnicalNotes // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Activity].
extension ActivityPatterns on Activity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Activity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Activity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Activity value)  $default,){
final _that = this;
switch (_that) {
case _Activity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Activity value)?  $default,){
final _that = this;
switch (_that) {
case _Activity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String activityId,  String userId,  String userName,  String userRank,  String academyName, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime timestampStart,  int durationMinutes,  String type,  int rpe,  int likesCount,  bool hasTechnicalNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.activityId,_that.userId,_that.userName,_that.userRank,_that.academyName,_that.timestampStart,_that.durationMinutes,_that.type,_that.rpe,_that.likesCount,_that.hasTechnicalNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String activityId,  String userId,  String userName,  String userRank,  String academyName, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime timestampStart,  int durationMinutes,  String type,  int rpe,  int likesCount,  bool hasTechnicalNotes)  $default,) {final _that = this;
switch (_that) {
case _Activity():
return $default(_that.activityId,_that.userId,_that.userName,_that.userRank,_that.academyName,_that.timestampStart,_that.durationMinutes,_that.type,_that.rpe,_that.likesCount,_that.hasTechnicalNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String activityId,  String userId,  String userName,  String userRank,  String academyName, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime timestampStart,  int durationMinutes,  String type,  int rpe,  int likesCount,  bool hasTechnicalNotes)?  $default,) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.activityId,_that.userId,_that.userName,_that.userRank,_that.academyName,_that.timestampStart,_that.durationMinutes,_that.type,_that.rpe,_that.likesCount,_that.hasTechnicalNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Activity implements Activity {
  const _Activity({required this.activityId, required this.userId, required this.userName, required this.userRank, required this.academyName, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.timestampStart, required this.durationMinutes, required this.type, required this.rpe, required this.likesCount, required this.hasTechnicalNotes});
  factory _Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

@override final  String activityId;
@override final  String userId;
@override final  String userName;
@override final  String userRank;
@override final  String academyName;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime timestampStart;
@override final  int durationMinutes;
@override final  String type;
// gi, nogi, open_mat, seminar
@override final  int rpe;
@override final  int likesCount;
@override final  bool hasTechnicalNotes;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityCopyWith<_Activity> get copyWith => __$ActivityCopyWithImpl<_Activity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Activity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userRank, userRank) || other.userRank == userRank)&&(identical(other.academyName, academyName) || other.academyName == academyName)&&(identical(other.timestampStart, timestampStart) || other.timestampStart == timestampStart)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.type, type) || other.type == type)&&(identical(other.rpe, rpe) || other.rpe == rpe)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.hasTechnicalNotes, hasTechnicalNotes) || other.hasTechnicalNotes == hasTechnicalNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,userId,userName,userRank,academyName,timestampStart,durationMinutes,type,rpe,likesCount,hasTechnicalNotes);

@override
String toString() {
  return 'Activity(activityId: $activityId, userId: $userId, userName: $userName, userRank: $userRank, academyName: $academyName, timestampStart: $timestampStart, durationMinutes: $durationMinutes, type: $type, rpe: $rpe, likesCount: $likesCount, hasTechnicalNotes: $hasTechnicalNotes)';
}


}

/// @nodoc
abstract mixin class _$ActivityCopyWith<$Res> implements $ActivityCopyWith<$Res> {
  factory _$ActivityCopyWith(_Activity value, $Res Function(_Activity) _then) = __$ActivityCopyWithImpl;
@override @useResult
$Res call({
 String activityId, String userId, String userName, String userRank, String academyName,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime timestampStart, int durationMinutes, String type, int rpe, int likesCount, bool hasTechnicalNotes
});




}
/// @nodoc
class __$ActivityCopyWithImpl<$Res>
    implements _$ActivityCopyWith<$Res> {
  __$ActivityCopyWithImpl(this._self, this._then);

  final _Activity _self;
  final $Res Function(_Activity) _then;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityId = null,Object? userId = null,Object? userName = null,Object? userRank = null,Object? academyName = null,Object? timestampStart = null,Object? durationMinutes = null,Object? type = null,Object? rpe = null,Object? likesCount = null,Object? hasTechnicalNotes = null,}) {
  return _then(_Activity(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userRank: null == userRank ? _self.userRank : userRank // ignore: cast_nullable_to_non_nullable
as String,academyName: null == academyName ? _self.academyName : academyName // ignore: cast_nullable_to_non_nullable
as String,timestampStart: null == timestampStart ? _self.timestampStart : timestampStart // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,rpe: null == rpe ? _self.rpe : rpe // ignore: cast_nullable_to_non_nullable
as int,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,hasTechnicalNotes: null == hasTechnicalNotes ? _self.hasTechnicalNotes : hasTechnicalNotes // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
