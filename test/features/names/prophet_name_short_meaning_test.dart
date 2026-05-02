import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';

ProphetName _nameWithEtymology(String etymology) => ProphetName(
  number: 1,
  arabic: 'محمد',
  transliteration: 'Muhammad',
  categorySlug: 'praise',
  categoryLabel: 'Louange',
  etymology: etymology,
  commentary: '',
  references: '',
  primarySource: '',
  secondarySources: '',
);

void main() {
  group('ProphetName.shortMeaningFr', () {
    test('uses the first quoted definition when available', () {
      final name = _nameWithEtymology(
        'Participe de la racine : « celui qui loue le plus ». Suite longue.',
      );

      expect(name.shortMeaningFr, '« celui qui loue le plus »');
    });

    test('falls back to the first sentence', () {
      final name = _nameWithEtymology(
        'Composition nominale : Nabī + al-Raḥma. Il indique la miséricorde.',
      );

      expect(name.shortMeaningFr, 'Composition nominale : Nabī + al-Raḥma.');
    });

    test('is available for every bundled name', () {
      final raw = File('assets/data/names.json').readAsStringSync();
      final names = (json.decode(raw) as List<dynamic>)
          .map((entry) => ProphetName.fromJson(entry as Map<String, dynamic>))
          .toList();

      expect(names, hasLength(201));
      expect(names.every((name) => name.shortMeaningFr.isNotEmpty), isTrue);
    });
  });
}
