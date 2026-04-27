// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Parcours _$ParcoursFromJson(Map<String, dynamic> json) => _Parcours(
  id: json['id'] as String,
  titleFr: json['titleFr'] as String,
  titleAr: json['titleAr'] as String,
  descriptionFr: json['descriptionFr'] as String,
  nameNumbers: (json['nameNumbers'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  colorHex: json['colorHex'] as String,
);

Map<String, dynamic> _$ParcoursToJson(_Parcours instance) => <String, dynamic>{
  'id': instance.id,
  'titleFr': instance.titleFr,
  'titleAr': instance.titleAr,
  'descriptionFr': instance.descriptionFr,
  'nameNumbers': instance.nameNumbers,
  'colorHex': instance.colorHex,
};
