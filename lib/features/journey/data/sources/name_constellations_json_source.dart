import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sirah_app/features/journey/data/models/name_constellation.dart';

class NameConstellationsJsonSource {
  NameConstellationsJsonSource._();

  static Future<List<NameConstellation>> load() async {
    final raw = await rootBundle.loadString(
      'assets/data/name_constellations.json',
    );
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => NameConstellation.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
