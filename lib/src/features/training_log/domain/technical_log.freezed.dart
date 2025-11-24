// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'technical_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TechnicalLog {

 String get logId; String get activityRef; String get rawInputText; List<ProcessedTechnique> get processedTechniques; String get aiSummary;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get createdAt;
/// Create a copy of TechnicalLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicalLogCopyWith<TechnicalLog> get copyWith => _$TechnicalLogCopyWithImpl<TechnicalLog>(this as TechnicalLog, _$identity);

  /// Serializes this TechnicalLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicalLog&&(identical(other.logId, logId) || other.logId == logId)&&(identical(other.activityRef, activityRef) || other.activityRef == activityRef)&&(identical(other.rawInputText, rawInputText) || other.rawInputText == rawInputText)&&const DeepCollectionEquality().equals(other.processedTechniques, processedTechniques)&&(identical(other.aiSummary, aiSummary) || other.aiSummary == aiSummary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,logId,activityRef,rawInputText,const DeepCollectionEquality().hash(processedTechniques),aiSummary,createdAt);

@override
String toString() {
  return 'TechnicalLog(logId: $logId, activityRef: $activityRef, rawInputText: $rawInputText, processedTechniques: $processedTechniques, aiSummary: $aiSummary, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TechnicalLogCopyWith<$Res>  {
  factory $TechnicalLogCopyWith(TechnicalLog value, $Res Function(TechnicalLog) _then) = _$TechnicalLogCopyWithImpl;
@useResult
$Res call({
 String logId, String activityRef, String rawInputText, List<ProcessedTechnique> processedTechniques, String aiSummary,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime createdAt
});




}
/// @nodoc
class _$TechnicalLogCopyWithImpl<$Res>
    implements $TechnicalLogCopyWith<$Res> {
  _$TechnicalLogCopyWithImpl(this._self, this._then);

  final TechnicalLog _self;
  final $Res Function(TechnicalLog) _then;

/// Create a copy of TechnicalLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logId = null,Object? activityRef = null,Object? rawInputText = null,Object? processedTechniques = null,Object? aiSummary = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
logId: null == logId ? _self.logId : logId // ignore: cast_nullable_to_non_nullable
as String,activityRef: null == activityRef ? _self.activityRef : activityRef // ignore: cast_nullable_to_non_nullable
as String,rawInputText: null == rawInputText ? _self.rawInputText : rawInputText // ignore: cast_nullable_to_non_nullable
as String,processedTechniques: null == processedTechniques ? _self.processedTechniques : processedTechniques // ignore: cast_nullable_to_non_nullable
as List<ProcessedTechnique>,aiSummary: null == aiSummary ? _self.aiSummary : aiSummary // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicalLog].
extension TechnicalLogPatterns on TechnicalLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicalLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicalLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicalLog value)  $default,){
final _that = this;
switch (_that) {
case _TechnicalLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicalLog value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicalLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String logId,  String activityRef,  String rawInputText,  List<ProcessedTechnique> processedTechniques,  String aiSummary, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicalLog() when $default != null:
return $default(_that.logId,_that.activityRef,_that.rawInputText,_that.processedTechniques,_that.aiSummary,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String logId,  String activityRef,  String rawInputText,  List<ProcessedTechnique> processedTechniques,  String aiSummary, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TechnicalLog():
return $default(_that.logId,_that.activityRef,_that.rawInputText,_that.processedTechniques,_that.aiSummary,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String logId,  String activityRef,  String rawInputText,  List<ProcessedTechnique> processedTechniques,  String aiSummary, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TechnicalLog() when $default != null:
return $default(_that.logId,_that.activityRef,_that.rawInputText,_that.processedTechniques,_that.aiSummary,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TechnicalLog implements TechnicalLog {
  const _TechnicalLog({required this.logId, required this.activityRef, required this.rawInputText, required final  List<ProcessedTechnique> processedTechniques, required this.aiSummary, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.createdAt}): _processedTechniques = processedTechniques;
  factory _TechnicalLog.fromJson(Map<String, dynamic> json) => _$TechnicalLogFromJson(json);

@override final  String logId;
@override final  String activityRef;
@override final  String rawInputText;
 final  List<ProcessedTechnique> _processedTechniques;
@override List<ProcessedTechnique> get processedTechniques {
  if (_processedTechniques is EqualUnmodifiableListView) return _processedTechniques;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_processedTechniques);
}

@override final  String aiSummary;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime createdAt;

/// Create a copy of TechnicalLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicalLogCopyWith<_TechnicalLog> get copyWith => __$TechnicalLogCopyWithImpl<_TechnicalLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicalLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicalLog&&(identical(other.logId, logId) || other.logId == logId)&&(identical(other.activityRef, activityRef) || other.activityRef == activityRef)&&(identical(other.rawInputText, rawInputText) || other.rawInputText == rawInputText)&&const DeepCollectionEquality().equals(other._processedTechniques, _processedTechniques)&&(identical(other.aiSummary, aiSummary) || other.aiSummary == aiSummary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,logId,activityRef,rawInputText,const DeepCollectionEquality().hash(_processedTechniques),aiSummary,createdAt);

@override
String toString() {
  return 'TechnicalLog(logId: $logId, activityRef: $activityRef, rawInputText: $rawInputText, processedTechniques: $processedTechniques, aiSummary: $aiSummary, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TechnicalLogCopyWith<$Res> implements $TechnicalLogCopyWith<$Res> {
  factory _$TechnicalLogCopyWith(_TechnicalLog value, $Res Function(_TechnicalLog) _then) = __$TechnicalLogCopyWithImpl;
@override @useResult
$Res call({
 String logId, String activityRef, String rawInputText, List<ProcessedTechnique> processedTechniques, String aiSummary,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime createdAt
});




}
/// @nodoc
class __$TechnicalLogCopyWithImpl<$Res>
    implements _$TechnicalLogCopyWith<$Res> {
  __$TechnicalLogCopyWithImpl(this._self, this._then);

  final _TechnicalLog _self;
  final $Res Function(_TechnicalLog) _then;

/// Create a copy of TechnicalLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logId = null,Object? activityRef = null,Object? rawInputText = null,Object? processedTechniques = null,Object? aiSummary = null,Object? createdAt = null,}) {
  return _then(_TechnicalLog(
logId: null == logId ? _self.logId : logId // ignore: cast_nullable_to_non_nullable
as String,activityRef: null == activityRef ? _self.activityRef : activityRef // ignore: cast_nullable_to_non_nullable
as String,rawInputText: null == rawInputText ? _self.rawInputText : rawInputText // ignore: cast_nullable_to_non_nullable
as String,processedTechniques: null == processedTechniques ? _self._processedTechniques : processedTechniques // ignore: cast_nullable_to_non_nullable
as List<ProcessedTechnique>,aiSummary: null == aiSummary ? _self.aiSummary : aiSummary // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ProcessedTechnique {

 String get techniqueName; String get category; String get positionStart; String get positionEnd; List<String> get tags; int get masteryLevel;
/// Create a copy of ProcessedTechnique
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessedTechniqueCopyWith<ProcessedTechnique> get copyWith => _$ProcessedTechniqueCopyWithImpl<ProcessedTechnique>(this as ProcessedTechnique, _$identity);

  /// Serializes this ProcessedTechnique to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcessedTechnique&&(identical(other.techniqueName, techniqueName) || other.techniqueName == techniqueName)&&(identical(other.category, category) || other.category == category)&&(identical(other.positionStart, positionStart) || other.positionStart == positionStart)&&(identical(other.positionEnd, positionEnd) || other.positionEnd == positionEnd)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.masteryLevel, masteryLevel) || other.masteryLevel == masteryLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,techniqueName,category,positionStart,positionEnd,const DeepCollectionEquality().hash(tags),masteryLevel);

@override
String toString() {
  return 'ProcessedTechnique(techniqueName: $techniqueName, category: $category, positionStart: $positionStart, positionEnd: $positionEnd, tags: $tags, masteryLevel: $masteryLevel)';
}


}

/// @nodoc
abstract mixin class $ProcessedTechniqueCopyWith<$Res>  {
  factory $ProcessedTechniqueCopyWith(ProcessedTechnique value, $Res Function(ProcessedTechnique) _then) = _$ProcessedTechniqueCopyWithImpl;
@useResult
$Res call({
 String techniqueName, String category, String positionStart, String positionEnd, List<String> tags, int masteryLevel
});




}
/// @nodoc
class _$ProcessedTechniqueCopyWithImpl<$Res>
    implements $ProcessedTechniqueCopyWith<$Res> {
  _$ProcessedTechniqueCopyWithImpl(this._self, this._then);

  final ProcessedTechnique _self;
  final $Res Function(ProcessedTechnique) _then;

/// Create a copy of ProcessedTechnique
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? techniqueName = null,Object? category = null,Object? positionStart = null,Object? positionEnd = null,Object? tags = null,Object? masteryLevel = null,}) {
  return _then(_self.copyWith(
techniqueName: null == techniqueName ? _self.techniqueName : techniqueName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,positionStart: null == positionStart ? _self.positionStart : positionStart // ignore: cast_nullable_to_non_nullable
as String,positionEnd: null == positionEnd ? _self.positionEnd : positionEnd // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,masteryLevel: null == masteryLevel ? _self.masteryLevel : masteryLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProcessedTechnique].
extension ProcessedTechniquePatterns on ProcessedTechnique {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProcessedTechnique value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProcessedTechnique() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProcessedTechnique value)  $default,){
final _that = this;
switch (_that) {
case _ProcessedTechnique():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProcessedTechnique value)?  $default,){
final _that = this;
switch (_that) {
case _ProcessedTechnique() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String techniqueName,  String category,  String positionStart,  String positionEnd,  List<String> tags,  int masteryLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProcessedTechnique() when $default != null:
return $default(_that.techniqueName,_that.category,_that.positionStart,_that.positionEnd,_that.tags,_that.masteryLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String techniqueName,  String category,  String positionStart,  String positionEnd,  List<String> tags,  int masteryLevel)  $default,) {final _that = this;
switch (_that) {
case _ProcessedTechnique():
return $default(_that.techniqueName,_that.category,_that.positionStart,_that.positionEnd,_that.tags,_that.masteryLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String techniqueName,  String category,  String positionStart,  String positionEnd,  List<String> tags,  int masteryLevel)?  $default,) {final _that = this;
switch (_that) {
case _ProcessedTechnique() when $default != null:
return $default(_that.techniqueName,_that.category,_that.positionStart,_that.positionEnd,_that.tags,_that.masteryLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProcessedTechnique implements ProcessedTechnique {
  const _ProcessedTechnique({required this.techniqueName, required this.category, required this.positionStart, required this.positionEnd, required final  List<String> tags, required this.masteryLevel}): _tags = tags;
  factory _ProcessedTechnique.fromJson(Map<String, dynamic> json) => _$ProcessedTechniqueFromJson(json);

@override final  String techniqueName;
@override final  String category;
@override final  String positionStart;
@override final  String positionEnd;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  int masteryLevel;

/// Create a copy of ProcessedTechnique
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProcessedTechniqueCopyWith<_ProcessedTechnique> get copyWith => __$ProcessedTechniqueCopyWithImpl<_ProcessedTechnique>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProcessedTechniqueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProcessedTechnique&&(identical(other.techniqueName, techniqueName) || other.techniqueName == techniqueName)&&(identical(other.category, category) || other.category == category)&&(identical(other.positionStart, positionStart) || other.positionStart == positionStart)&&(identical(other.positionEnd, positionEnd) || other.positionEnd == positionEnd)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.masteryLevel, masteryLevel) || other.masteryLevel == masteryLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,techniqueName,category,positionStart,positionEnd,const DeepCollectionEquality().hash(_tags),masteryLevel);

@override
String toString() {
  return 'ProcessedTechnique(techniqueName: $techniqueName, category: $category, positionStart: $positionStart, positionEnd: $positionEnd, tags: $tags, masteryLevel: $masteryLevel)';
}


}

/// @nodoc
abstract mixin class _$ProcessedTechniqueCopyWith<$Res> implements $ProcessedTechniqueCopyWith<$Res> {
  factory _$ProcessedTechniqueCopyWith(_ProcessedTechnique value, $Res Function(_ProcessedTechnique) _then) = __$ProcessedTechniqueCopyWithImpl;
@override @useResult
$Res call({
 String techniqueName, String category, String positionStart, String positionEnd, List<String> tags, int masteryLevel
});




}
/// @nodoc
class __$ProcessedTechniqueCopyWithImpl<$Res>
    implements _$ProcessedTechniqueCopyWith<$Res> {
  __$ProcessedTechniqueCopyWithImpl(this._self, this._then);

  final _ProcessedTechnique _self;
  final $Res Function(_ProcessedTechnique) _then;

/// Create a copy of ProcessedTechnique
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? techniqueName = null,Object? category = null,Object? positionStart = null,Object? positionEnd = null,Object? tags = null,Object? masteryLevel = null,}) {
  return _then(_ProcessedTechnique(
techniqueName: null == techniqueName ? _self.techniqueName : techniqueName // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,positionStart: null == positionStart ? _self.positionStart : positionStart // ignore: cast_nullable_to_non_nullable
as String,positionEnd: null == positionEnd ? _self.positionEnd : positionEnd // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,masteryLevel: null == masteryLevel ? _self.masteryLevel : masteryLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
