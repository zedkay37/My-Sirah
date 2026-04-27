import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/features/study/data/models/parcours.dart';

export 'package:sirah_app/features/study/data/models/parcours.dart' show Parcours;

final parcoursProvider = FutureProvider<List<Parcours>>((ref) async {
  final raw = await rootBundle.loadString('assets/data/parcours.json');
  final list = json.decode(raw) as List<dynamic>;
  return list.map((e) => Parcours.fromJson(e as Map<String, dynamic>)).toList();
});
