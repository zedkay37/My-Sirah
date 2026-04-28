import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sirah_app/features/journey/data/models/name_action_bank.dart';

class NameActionsJsonSource {
  NameActionsJsonSource._();

  static Future<List<NameActionBank>> load() async {
    final raw = await rootBundle.loadString('assets/data/name_actions.json');
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => NameActionBank.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
