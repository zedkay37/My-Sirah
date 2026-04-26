import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';

class GenealogyJsonSource {
  GenealogyJsonSource._();

  static const _sections = [
    'paternalAscendants',
    'paternalAscendantsTraditional',
    'maternalLine',
    'paternalUncles',
    'wives',
    'children',
    'grandchildren',
    'cousins',
  ];

  static Future<List<FamilyMember>> load() async {
    final raw = await rootBundle.loadString('assets/data/genealogy.json');
    final map = json.decode(raw) as Map<String, dynamic>;

    final members = <FamilyMember>[];

    members.add(FamilyMember.fromJson(map['prophet'] as Map<String, dynamic>));

    for (final key in _sections) {
      final section = map[key] as List<dynamic>?;
      if (section == null) continue;
      members.addAll(
        section.map((e) => FamilyMember.fromJson(e as Map<String, dynamic>)),
      );
    }

    return members;
  }
}
