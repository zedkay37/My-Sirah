import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sirah_app/features/journey/data/models/journey_deck.dart';

class JourneyDecksJsonSource {
  const JourneyDecksJsonSource._();

  static Future<List<JourneyDeck>> load() async {
    final raw = await rootBundle.loadString('assets/data/journey_decks.json');
    final decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(JourneyDeck.fromJson)
        .toList();
  }
}
