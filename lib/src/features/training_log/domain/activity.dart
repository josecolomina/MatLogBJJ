import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
abstract class Activity with _$Activity {
  const factory Activity({
    required String activityId,
    required String userId,
    required String userName,
    required String userRank,
    required String academyName,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required DateTime timestampStart,
    required int durationMinutes,
    required String type, // gi, nogi, open_mat, seminar
    required int rpe,
    required int likesCount,
    required bool hasTechnicalNotes,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);
