import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Parcours {
  const Parcours({
    required this.id,
    required this.titleFr,
    required this.titleAr,
    required this.descriptionFr,
    required this.nameNumbers,
    required this.colorHex,
  });

  final String id;
  final String titleFr;
  final String titleAr;
  final String descriptionFr;
  final List<int> nameNumbers;
  final String colorHex;

  factory Parcours.fromJson(Map<String, dynamic> json) => Parcours(
        id: json['id'] as String,
        titleFr: json['titleFr'] as String,
        titleAr: json['titleAr'] as String,
        descriptionFr: json['descriptionFr'] as String,
        nameNumbers: (json['nameNumbers'] as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        colorHex: json['colorHex'] as String,
      );
}

final parcoursProvider = FutureProvider<List<Parcours>>((ref) async {
  final raw = await rootBundle.loadString('assets/data/parcours.json');
  final list = json.decode(raw) as List<dynamic>;
  return list.map((e) => Parcours.fromJson(e as Map<String, dynamic>)).toList();
});
