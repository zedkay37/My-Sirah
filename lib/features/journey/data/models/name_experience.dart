import 'package:freezed_annotation/freezed_annotation.dart';

part 'name_experience.freezed.dart';
part 'name_experience.g.dart';

@freezed
abstract class NameStory with _$NameStory {
  const factory NameStory({
    required String id,
    required String titleFr,
    required String bodyFr,
    @Default([]) List<String> tags,
    required String sourceNote,
    @Default([]) List<String> relatedPeople,
    @Default([]) List<String> sourceRefs,
    @Default('needs_review') String editorialStatus,
    String? reviewedBy,
    String? reviewNotes,
    DateTime? validatedAt,
  }) = _NameStory;

  factory NameStory.fromJson(Map<String, dynamic> json) =>
      _$NameStoryFromJson(json);
}

@freezed
abstract class NameExperience with _$NameExperience {
  const factory NameExperience({
    required int nameNumber,
    @Default([]) List<NameStory> stories,
    required String tafakkurPromptFr,
    required String practiceTheme,
  }) = _NameExperience;

  factory NameExperience.fromJson(Map<String, dynamic> json) =>
      _$NameExperienceFromJson(json);
}
