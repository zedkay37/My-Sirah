import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sirah_app/features/journey/data/models/journey_map_layout.dart';

class JourneyMapLayoutJsonSource {
  const JourneyMapLayoutJsonSource._();

  static Future<JourneyMapLayout> load() async {
    final raw = await rootBundle.loadString(
      'assets/data/journey_map_layout.json',
    );
    return JourneyMapLayout.fromJson(json.decode(raw) as Map<String, dynamic>);
  }
}
