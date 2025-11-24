import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'technical_log.freezed.dart';
part 'technical_log.g.dart';

@freezed
class TechnicalLog with _$TechnicalLog {
  const factory TechnicalLog({
    required String logId,
    required String activityRef,
    required String rawInputText,
    required List<ProcessedTechnique> processedTechniques,
    required String aiSummary,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
  }) = _TechnicalLog;

  factory TechnicalLog.fromJson(Map<String, dynamic> json) =>
      _$TechnicalLogFromJson(json);
}

@freezed
class ProcessedTechnique with _$ProcessedTechnique {
  const factory ProcessedTechnique({
    required String techniqueName,
    required String category,
    required String positionStart,
    required String positionEnd,
    required List<String> tags,
    required int masteryLevel,
  }) = _ProcessedTechnique;

  factory ProcessedTechnique.fromJson(Map<String, dynamic> json) =>
      _$ProcessedTechniqueFromJson(json);
}

DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);
