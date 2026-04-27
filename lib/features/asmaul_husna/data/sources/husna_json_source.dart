import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sirah_app/features/asmaul_husna/data/models/husna_name.dart';

class HusnaJsonSource {
  HusnaJsonSource._();

  static Future<List<HusnaName>> load() async {
    final raw = await rootBundle.loadString('assets/data/asmaul_husna.json');
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => HusnaName.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
