import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mastery_belt.dart';

part 'technique.freezed.dart';
part 'technique.g.dart';

@freezed
abstract class Technique with _$Technique {
  const Technique._();

  const factory Technique({
    required String id,
    required String name,
    required String position,
    required String category,
    required int totalRepetitions,
    required MasteryBelt masteryBelt,
    @Default('') String notes,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required DateTime lastPracticedAt,
  }) = _Technique;

  factory Technique.fromJson(Map<String, dynamic> json) =>
      _$TechniqueFromJson(json);
      
  // Helper to check if a level up occurred compared to a previous count
  bool hasLeveledUp(int previousCount) {
    final oldBelt = MasteryBelt.fromRepetitions(previousCount);
    final newBelt = MasteryBelt.fromRepetitions(totalRepetitions);
    return newBelt.index > oldBelt.index;
  }
}

DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);
