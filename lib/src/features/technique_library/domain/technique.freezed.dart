// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technique.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Technique {

 String get id; String get name; String get position; String get category; int get totalRepetitions; MasteryBelt get masteryBelt; String get notes;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get lastPracticedAt;
/// Create a copy of Technique
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechniqueCopyWith<Technique> get copyWith => _$TechniqueCopyWithImpl<Technique>(this as Technique, _$identity);

  /// Serializes this Technique to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Technique&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.category, category) || other.category == category)&&(identical(other.totalRepetitions, totalRepetitions) || other.totalRepetitions == totalRepetitions)&&(identical(other.masteryBelt, masteryBelt) || other.masteryBelt == masteryBelt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.lastPracticedAt, lastPracticedAt) || other.lastPracticedAt == lastPracticedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position,category,totalRepetitions,masteryBelt,notes,lastPracticedAt);

@override
String toString() {
  return 'Technique(id: $id, name: $name, position: $position, category: $category, totalRepetitions: $totalRepetitions, masteryBelt: $masteryBelt, notes: $notes, lastPracticedAt: $lastPracticedAt)';
}


}

/// @nodoc
abstract mixin class $TechniqueCopyWith<$Res>  {
  factory $TechniqueCopyWith(Technique value, $Res Function(Technique) _then) = _$TechniqueCopyWithImpl;
@useResult
$Res call({
 String id, String name, String position, String category, int totalRepetitions, MasteryBelt masteryBelt, String notes,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime lastPracticedAt
});




}
/// @nodoc
class _$TechniqueCopyWithImpl<$Res>
    implements $TechniqueCopyWith<$Res> {
  _$TechniqueCopyWithImpl(this._self, this._then);

  final Technique _self;
  final $Res Function(Technique) _then;

/// Create a copy of Technique
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? position = null,Object? category = null,Object? totalRepetitions = null,Object? masteryBelt = null,Object? notes = null,Object? lastPracticedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,totalRepetitions: null == totalRepetitions ? _self.totalRepetitions : totalRepetitions // ignore: cast_nullable_to_non_nullable
as int,masteryBelt: null == masteryBelt ? _self.masteryBelt : masteryBelt // ignore: cast_nullable_to_non_nullable
as MasteryBelt,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,lastPracticedAt: null == lastPracticedAt ? _self.lastPracticedAt : lastPracticedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Technique].
extension TechniquePatterns on Technique {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Technique value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Technique() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Technique value)  $default,){
final _that = this;
switch (_that) {
case _Technique():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Technique value)?  $default,){
final _that = this;
switch (_that) {
case _Technique() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String position,  String category,  int totalRepetitions,  MasteryBelt masteryBelt,  String notes, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime lastPracticedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Technique() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.category,_that.totalRepetitions,_that.masteryBelt,_that.notes,_that.lastPracticedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String position,  String category,  int totalRepetitions,  MasteryBelt masteryBelt,  String notes, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime lastPracticedAt)  $default,) {final _that = this;
switch (_that) {
case _Technique():
return $default(_that.id,_that.name,_that.position,_that.category,_that.totalRepetitions,_that.masteryBelt,_that.notes,_that.lastPracticedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String position,  String category,  int totalRepetitions,  MasteryBelt masteryBelt,  String notes, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime lastPracticedAt)?  $default,) {final _that = this;
switch (_that) {
case _Technique() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.category,_that.totalRepetitions,_that.masteryBelt,_that.notes,_that.lastPracticedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Technique extends Technique {
  const _Technique({required this.id, required this.name, required this.position, required this.category, required this.totalRepetitions, required this.masteryBelt, this.notes = '', @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.lastPracticedAt}): super._();
  factory _Technique.fromJson(Map<String, dynamic> json) => _$TechniqueFromJson(json);

@override final  String id;
@override final  String name;
@override final  String position;
@override final  String category;
@override final  int totalRepetitions;
@override final  MasteryBelt masteryBelt;
@override@JsonKey() final  String notes;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime lastPracticedAt;

/// Create a copy of Technique
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechniqueCopyWith<_Technique> get copyWith => __$TechniqueCopyWithImpl<_Technique>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechniqueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Technique&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.category, category) || other.category == category)&&(identical(other.totalRepetitions, totalRepetitions) || other.totalRepetitions == totalRepetitions)&&(identical(other.masteryBelt, masteryBelt) || other.masteryBelt == masteryBelt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.lastPracticedAt, lastPracticedAt) || other.lastPracticedAt == lastPracticedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position,category,totalRepetitions,masteryBelt,notes,lastPracticedAt);

@override
String toString() {
  return 'Technique(id: $id, name: $name, position: $position, category: $category, totalRepetitions: $totalRepetitions, masteryBelt: $masteryBelt, notes: $notes, lastPracticedAt: $lastPracticedAt)';
}


}

/// @nodoc
abstract mixin class _$TechniqueCopyWith<$Res> implements $TechniqueCopyWith<$Res> {
  factory _$TechniqueCopyWith(_Technique value, $Res Function(_Technique) _then) = __$TechniqueCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String position, String category, int totalRepetitions, MasteryBelt masteryBelt, String notes,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime lastPracticedAt
});




}
/// @nodoc
class __$TechniqueCopyWithImpl<$Res>
    implements _$TechniqueCopyWith<$Res> {
  __$TechniqueCopyWithImpl(this._self, this._then);

  final _Technique _self;
  final $Res Function(_Technique) _then;

/// Create a copy of Technique
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? position = null,Object? category = null,Object? totalRepetitions = null,Object? masteryBelt = null,Object? notes = null,Object? lastPracticedAt = null,}) {
  return _then(_Technique(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,totalRepetitions: null == totalRepetitions ? _self.totalRepetitions : totalRepetitions // ignore: cast_nullable_to_non_nullable
as int,masteryBelt: null == masteryBelt ? _self.masteryBelt : masteryBelt // ignore: cast_nullable_to_non_nullable
as MasteryBelt,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,lastPracticedAt: null == lastPracticedAt ? _self.lastPracticedAt : lastPracticedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
