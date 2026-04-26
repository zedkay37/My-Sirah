// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prophet_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProphetName _$ProphetNameFromJson(Map<String, dynamic> json) => _ProphetName(
  number: (json['id'] as num).toInt(),
  arabic: json['arabic'] as String,
  transliteration: json['transliteration'] as String,
  categorySlug: json['categorySlug'] as String,
  categoryLabel: json['category'] as String,
  etymology: json['etymology'] as String,
  commentary: json['commentary'] as String,
  references: json['references'] as String,
  primarySource: json['primarySource'] as String,
  secondarySources: json['secondarySources'] as String,
);

Map<String, dynamic> _$ProphetNameToJson(_ProphetName instance) =>
    <String, dynamic>{
      'id': instance.number,
      'arabic': instance.arabic,
      'transliteration': instance.transliteration,
      'categorySlug': instance.categorySlug,
      'category': instance.categoryLabel,
      'etymology': instance.etymology,
      'commentary': instance.commentary,
      'references': instance.references,
      'primarySource': instance.primarySource,
      'secondarySources': instance.secondarySources,
    };
