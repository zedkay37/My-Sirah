import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_member.freezed.dart';
part 'family_member.g.dart';

@freezed
abstract class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required String id,
    required String arabic,
    required String transliteration,
    String? kunya,
    @Default([]) List<String> laqab,
    required FamilyRole role,
    String? birth,
    String? death,
    String? bio,
    int? generation,
    int? marriageOrder,
    // Graph edges — used for BFS path traversal
    String? parentId,
    String? motherId,
    String? spouseOf,
    @Default([]) List<String> parentIds,
    @Default(false) bool isBoundary,
    @Default(false) bool isTraditional,
    String? variant,
  }) = _FamilyMember;

  factory FamilyMember.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberFromJson(json);
}

enum FamilyRole {
  prophet,
  father,
  mother,
  paternalAscendant,
  maternalAscendant,
  uncle,
  aunt,
  wife,
  child,
  grandchild,
  cousin,
  traditionalAncestor,
}
