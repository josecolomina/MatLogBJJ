// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technical_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TechnicalLog _$TechnicalLogFromJson(Map<String, dynamic> json) =>
    _TechnicalLog(
      logId: json['logId'] as String,
      activityRef: json['activityRef'] as String,
      rawInputText: json['rawInputText'] as String,
      processedTechniques: (json['processedTechniques'] as List<dynamic>)
          .map((e) => ProcessedTechnique.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiSummary: json['aiSummary'] as String,
      createdAt: _timestampFromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$TechnicalLogToJson(_TechnicalLog instance) =>
    <String, dynamic>{
      'logId': instance.logId,
      'activityRef': instance.activityRef,
      'rawInputText': instance.rawInputText,
      'processedTechniques': instance.processedTechniques,
      'aiSummary': instance.aiSummary,
      'createdAt': _timestampToJson(instance.createdAt),
    };

_ProcessedTechnique _$ProcessedTechniqueFromJson(Map<String, dynamic> json) =>
    _ProcessedTechnique(
      techniqueName: json['techniqueName'] as String,
      category: json['category'] as String,
      positionStart: json['positionStart'] as String,
      positionEnd: json['positionEnd'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      masteryLevel: (json['masteryLevel'] as num).toInt(),
    );

Map<String, dynamic> _$ProcessedTechniqueToJson(_ProcessedTechnique instance) =>
    <String, dynamic>{
      'techniqueName': instance.techniqueName,
      'category': instance.category,
      'positionStart': instance.positionStart,
      'positionEnd': instance.positionEnd,
      'tags': instance.tags,
      'masteryLevel': instance.masteryLevel,
    };
