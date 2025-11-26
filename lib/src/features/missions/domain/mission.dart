import 'package:json_annotation/json_annotation.dart';

part 'mission.g.dart';

@JsonSerializable()
class Mission {
  final String id;
  final String title;
  final String description;
  final int currentProgress;
  final int target;
  final bool isCompleted;
  final bool isNew;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.currentProgress,
    required this.target,
    this.isCompleted = false,
    this.isNew = false,
  });

  factory Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);
  Map<String, dynamic> toJson() => _$MissionToJson(this);
}
