// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyMember _$FamilyMemberFromJson(Map<String, dynamic> json) =>
    _FamilyMember(
      id: json['id'] as String,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      kunya: json['kunya'] as String?,
      laqab:
          (json['laqab'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      role: $enumDecode(_$FamilyRoleEnumMap, json['role']),
      birth: json['birth'] as String?,
      death: json['death'] as String?,
      bio: json['bio'] as String?,
      generation: (json['generation'] as num?)?.toInt(),
      marriageOrder: (json['marriageOrder'] as num?)?.toInt(),
      parentId: json['parentId'] as String?,
      motherId: json['motherId'] as String?,
      spouseOf: json['spouseOf'] as String?,
      parentIds:
          (json['parentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isBoundary: json['isBoundary'] as bool? ?? false,
      isTraditional: json['isTraditional'] as bool? ?? false,
      variant: json['variant'] as String?,
    );

Map<String, dynamic> _$FamilyMemberToJson(_FamilyMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'arabic': instance.arabic,
      'transliteration': instance.transliteration,
      'kunya': instance.kunya,
      'laqab': instance.laqab,
      'role': _$FamilyRoleEnumMap[instance.role]!,
      'birth': instance.birth,
      'death': instance.death,
      'bio': instance.bio,
      'generation': instance.generation,
      'marriageOrder': instance.marriageOrder,
      'parentId': instance.parentId,
      'motherId': instance.motherId,
      'spouseOf': instance.spouseOf,
      'parentIds': instance.parentIds,
      'isBoundary': instance.isBoundary,
      'isTraditional': instance.isTraditional,
      'variant': instance.variant,
    };

const _$FamilyRoleEnumMap = {
  FamilyRole.prophet: 'prophet',
  FamilyRole.father: 'father',
  FamilyRole.mother: 'mother',
  FamilyRole.paternalAscendant: 'paternalAscendant',
  FamilyRole.maternalAscendant: 'maternalAscendant',
  FamilyRole.uncle: 'uncle',
  FamilyRole.aunt: 'aunt',
  FamilyRole.wife: 'wife',
  FamilyRole.child: 'child',
  FamilyRole.grandchild: 'grandchild',
  FamilyRole.cousin: 'cousin',
  FamilyRole.traditionalAncestor: 'traditionalAncestor',
};
