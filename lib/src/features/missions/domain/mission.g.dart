// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mission _$MissionFromJson(Map<String, dynamic> json) => Mission(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  currentProgress: (json['currentProgress'] as num).toInt(),
  target: (json['target'] as num).toInt(),
  isCompleted: json['isCompleted'] as bool? ?? false,
  isNew: json['isNew'] as bool? ?? false,
);

Map<String, dynamic> _$MissionToJson(Mission instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'currentProgress': instance.currentProgress,
  'target': instance.target,
  'isCompleted': instance.isCompleted,
  'isNew': instance.isNew,
};
