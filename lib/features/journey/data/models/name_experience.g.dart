// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_experience.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NameStory _$NameStoryFromJson(Map<String, dynamic> json) => _NameStory(
  id: json['id'] as String,
  titleFr: json['titleFr'] as String,
  bodyFr: json['bodyFr'] as String,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  sourceNote: json['sourceNote'] as String,
  relatedPeople:
      (json['relatedPeople'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  sourceRefs:
      (json['sourceRefs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  editorialStatus: json['editorialStatus'] as String? ?? 'needs_review',
  reviewedBy: json['reviewedBy'] as String?,
  reviewNotes: json['reviewNotes'] as String?,
  validatedAt: json['validatedAt'] == null
      ? null
      : DateTime.parse(json['validatedAt'] as String),
);

Map<String, dynamic> _$NameStoryToJson(_NameStory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titleFr': instance.titleFr,
      'bodyFr': instance.bodyFr,
      'tags': instance.tags,
      'sourceNote': instance.sourceNote,
      'relatedPeople': instance.relatedPeople,
      'sourceRefs': instance.sourceRefs,
      'editorialStatus': instance.editorialStatus,
      'reviewedBy': instance.reviewedBy,
      'reviewNotes': instance.reviewNotes,
      'validatedAt': instance.validatedAt?.toIso8601String(),
    };

_NameExperience _$NameExperienceFromJson(Map<String, dynamic> json) =>
    _NameExperience(
      nameNumber: (json['nameNumber'] as num).toInt(),
      stories:
          (json['stories'] as List<dynamic>?)
              ?.map((e) => NameStory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tafakkurPromptFr: json['tafakkurPromptFr'] as String,
      practiceTheme: json['practiceTheme'] as String,
    );

Map<String, dynamic> _$NameExperienceToJson(_NameExperience instance) =>
    <String, dynamic>{
      'nameNumber': instance.nameNumber,
      'stories': instance.stories,
      'tafakkurPromptFr': instance.tafakkurPromptFr,
      'practiceTheme': instance.practiceTheme,
    };
