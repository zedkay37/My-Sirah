import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';

class NamesJsonSource {
  NamesJsonSource._();

  static Future<List<ProphetName>> load() async {
    final raw = await rootBundle.loadString('assets/data/names.json');
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => ProphetName.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
