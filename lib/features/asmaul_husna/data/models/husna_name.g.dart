// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'husna_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HusnaName _$HusnaNameFromJson(Map<String, dynamic> json) => _HusnaName(
  id: (json['id'] as num).toInt(),
  arabic: json['arabic'] as String,
  transliteration: json['transliteration'] as String,
  meaningFr: json['meaningFr'] as String,
  etymology: json['etymology'] as String? ?? '',
  reference: json['reference'] as String? ?? '',
);

Map<String, dynamic> _$HusnaNameToJson(_HusnaName instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabic': instance.arabic,
      'transliteration': instance.transliteration,
      'meaningFr': instance.meaningFr,
      'etymology': instance.etymology,
      'reference': instance.reference,
    };
