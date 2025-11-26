// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technique.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Technique _$TechniqueFromJson(Map<String, dynamic> json) => _Technique(
  id: json['id'] as String,
  name: json['name'] as String,
  position: json['position'] as String,
  category: json['category'] as String,
  totalRepetitions: (json['totalRepetitions'] as num).toInt(),
  masteryBelt: $enumDecode(_$MasteryBeltEnumMap, json['masteryBelt']),
  notes: json['notes'] as String? ?? '',
  lastPracticedAt: _timestampFromJson(json['lastPracticedAt'] as Timestamp),
);

Map<String, dynamic> _$TechniqueToJson(_Technique instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'category': instance.category,
      'totalRepetitions': instance.totalRepetitions,
      'masteryBelt': _$MasteryBeltEnumMap[instance.masteryBelt]!,
      'notes': instance.notes,
      'lastPracticedAt': _timestampToJson(instance.lastPracticedAt),
    };

const _$MasteryBeltEnumMap = {
  MasteryBelt.white: 'white',
  MasteryBelt.blue: 'blue',
  MasteryBelt.purple: 'purple',
  MasteryBelt.brown: 'brown',
  MasteryBelt.black: 'black',
};
