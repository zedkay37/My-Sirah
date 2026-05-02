import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sirah_app/features/journey/data/models/name_experience.dart';

class NameExperiencesJsonSource {
  NameExperiencesJsonSource._();

  static Future<List<NameExperience>> load() async {
    final raw = await rootBundle.loadString(
      'assets/data/name_experiences.json',
    );
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => NameExperience.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
