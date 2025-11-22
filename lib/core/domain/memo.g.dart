// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemoImpl _$$MemoImplFromJson(Map<String, dynamic> json) => _$MemoImpl(
  id: json['id'] as String,
  body: json['body'] as String? ?? '',
  mood: $enumDecodeNullable(_$MoodEnumMap, json['mood']) ?? Mood.calm,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$MemoImplToJson(_$MemoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'mood': _$MoodEnumMap[instance.mood]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$MoodEnumMap = {
  Mood.happy: 'happy',
  Mood.calm: 'calm',
  Mood.tired: 'tired',
  Mood.fired: 'fired',
};
