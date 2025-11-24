import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'rival.freezed.dart';
part 'rival.g.dart';

@freezed
abstract class Rival with _$Rival {
  const factory Rival({
    required String rivalUid,
    required String rivalName,
    required int wins,
    required int losses,
    required int draws,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime lastRolledAt,
    required String notes,
  }) = _Rival;

  factory Rival.fromJson(Map<String, dynamic> json) => _$RivalFromJson(json);
}

DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);
