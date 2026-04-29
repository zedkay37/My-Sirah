// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_action_bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NameActionBank _$NameActionBankFromJson(Map<String, dynamic> json) =>
    _NameActionBank(
      theme: json['theme'] as String,
      actions:
          (json['actions'] as List<dynamic>?)
              ?.map((e) => NameActionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$NameActionBankToJson(_NameActionBank instance) =>
    <String, dynamic>{'theme': instance.theme, 'actions': instance.actions};

_NameActionItem _$NameActionItemFromJson(Map<String, dynamic> json) =>
    _NameActionItem(
      id: json['id'] as String,
      textFr: json['textFr'] as String,
      editorialStatus: json['editorialStatus'] as String? ?? 'needs_review',
      duration: json['duration'] as String? ?? 'short',
      difficulty: json['difficulty'] as String? ?? 'simple',
      contexts:
          (json['contexts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nameNumbers:
          (json['nameNumbers'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      sourceNote: json['sourceNote'] as String? ?? '',
    );

Map<String, dynamic> _$NameActionItemToJson(_NameActionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'textFr': instance.textFr,
      'editorialStatus': instance.editorialStatus,
      'duration': instance.duration,
      'difficulty': instance.difficulty,
      'contexts': instance.contexts,
      'nameNumbers': instance.nameNumbers,
      'sourceNote': instance.sourceNote,
    };
