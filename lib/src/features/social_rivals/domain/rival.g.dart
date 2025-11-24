// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rival.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Rival _$RivalFromJson(Map<String, dynamic> json) => _Rival(
  rivalUid: json['rivalUid'] as String,
  rivalName: json['rivalName'] as String,
  wins: (json['wins'] as num).toInt(),
  losses: (json['losses'] as num).toInt(),
  draws: (json['draws'] as num).toInt(),
  lastRolledAt: _timestampFromJson(json['lastRolledAt'] as Timestamp),
  notes: json['notes'] as String,
);

Map<String, dynamic> _$RivalToJson(_Rival instance) => <String, dynamic>{
  'rivalUid': instance.rivalUid,
  'rivalName': instance.rivalName,
  'wins': instance.wins,
  'losses': instance.losses,
  'draws': instance.draws,
  'lastRolledAt': _timestampToJson(instance.lastRolledAt),
  'notes': instance.notes,
};
