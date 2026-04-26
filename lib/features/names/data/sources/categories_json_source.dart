import 'dart:convert';

import 'package:flutter/services.dart';

class NameCategory {
  const NameCategory({
    required this.slug,
    required this.labelFr,
    required this.count,
  });

  final String slug;
  final String labelFr;
  final int count;

  factory NameCategory.fromJson(Map<String, dynamic> json) => NameCategory(
        slug: json['slug'] as String,
        labelFr: json['labelFr'] as String,
        count: json['count'] as int,
      );
}

class CategoriesJsonSource {
  CategoriesJsonSource._();

  static Future<List<NameCategory>> load() async {
    final raw = await rootBundle.loadString('assets/data/categories.json');
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => NameCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
