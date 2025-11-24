// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
  activityId: json['activityId'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  userRank: json['userRank'] as String,
  academyName: json['academyName'] as String,
  timestampStart: _timestampFromJson(json['timestampStart'] as Timestamp),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  type: json['type'] as String,
  rpe: (json['rpe'] as num).toInt(),
  likesCount: (json['likesCount'] as num).toInt(),
  hasTechnicalNotes: json['hasTechnicalNotes'] as bool,
);

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
  'activityId': instance.activityId,
  'userId': instance.userId,
  'userName': instance.userName,
  'userRank': instance.userRank,
  'academyName': instance.academyName,
  'timestampStart': _timestampToJson(instance.timestampStart),
  'durationMinutes': instance.durationMinutes,
  'type': instance.type,
  'rpe': instance.rpe,
  'likesCount': instance.likesCount,
  'hasTechnicalNotes': instance.hasTechnicalNotes,
};
