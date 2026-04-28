import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/data/repositories/names_repository.dart';

// ── Fixtures ──────────────────────────────────────────────────────────────────

const _n1 = ProphetName(
  number: 1,
  arabic: 'مُحَمَّد',
  transliteration: 'Muḥammad',
  categorySlug: 'prophethood',
  categoryLabel: 'Prophétie',
  etymology: 'Celui qui est loué maintes fois',
  commentary: 'Le nom le plus connu du Prophète.',
  references: 'Coran 3:144',
  primarySource: 'Al-Bukhārī',
  secondarySources: '',
);

const _n2 = ProphetName(
  number: 2,
  arabic: 'أَحْمَد',
  transliteration: 'Aḥmad',
  categorySlug: 'prophethood',
  categoryLabel: 'Prophétie',
  etymology: 'Celui qui loue le plus',
  commentary: 'Nom cité dans le Coran et annoncé par Jésus.',
  references: 'Coran 61:6',
  primarySource: 'Muslim',
  secondarySources: '',
);

const _n3 = ProphetName(
  number: 3,
  arabic: 'الْمَاحِي',
  transliteration: 'Al-Māḥī',
  categorySlug: 'mercy',
  categoryLabel: 'Miséricorde',
  etymology: 'Celui qui efface',
  commentary: 'Allah efface par lui la mécréance.',
  references: 'Bukhārī 4896',
  primarySource: 'Al-Bukhārī',
  secondarySources: 'Muslim 2354',
);

final _allNames = [_n1, _n2, _n3];

NamesRepository _makeRepo() => NamesRepository(_allNames);

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('NamesRepository', () {
    group('getAll', () {
      test('retourne toute la liste fournie', () {
        final repo = _makeRepo();
        expect(repo.getAll(), equals(_allNames));
        expect(repo.getAll().length, 3);
      });

      test('retourne une liste vide si construite avec une liste vide', () {
        final repo = NamesRepository([]);
        expect(repo.getAll(), isEmpty);
      });
    });

    group('getByNumber', () {
      test('retourne le bon nom pour un numéro connu', () {
        final repo = _makeRepo();
        expect(repo.getByNumber(1), equals(_n1));
        expect(repo.getByNumber(3), equals(_n3));
      });

      test('retourne null pour un numéro inconnu', () {
        final repo = _makeRepo();
        expect(repo.getByNumber(999), isNull);
        expect(repo.getByNumber(0), isNull);
      });
    });

    group('getByCategory', () {
      test('filtre correctement par categorySlug', () {
        final repo = _makeRepo();
        final prophethood = repo.getByCategory('prophethood');
        expect(prophethood.length, 2);
        expect(
          prophethood.every((n) => n.categorySlug == 'prophethood'),
          isTrue,
        );
      });

      test('retourne seulement les noms de la catégorie demandée', () {
        final repo = _makeRepo();
        final mercy = repo.getByCategory('mercy');
        expect(mercy.length, 1);
        expect(mercy.first, equals(_n3));
      });

      test('retourne une liste vide pour une catégorie inexistante', () {
        final repo = _makeRepo();
        expect(repo.getByCategory('unknown_slug'), isEmpty);
      });
    });

    group('search', () {
      test('retourne tout si la requête est vide', () {
        final repo = _makeRepo();
        expect(repo.search('').length, 3);
      });

      test('trouve par texte arabe (correspondance exacte)', () {
        final repo = _makeRepo();
        final results = repo.search('مُحَمَّد');
        expect(results.length, 1);
        expect(results.first, equals(_n1));
      });

      test('trouve par translittération (insensible à la casse)', () {
        final repo = _makeRepo();
        // Recherche en minuscule
        final results = repo.search('aḥmad');
        expect(results.length, 1);
        expect(results.first, equals(_n2));
      });

      test('trouve par étymologie', () {
        final repo = _makeRepo();
        final results = repo.search('efface');
        expect(results.length, 1);
        expect(results.first, equals(_n3));
      });

      test('trouve par commentaire', () {
        final repo = _makeRepo();
        final results = repo.search('Jésus');
        expect(results.length, 1);
        expect(results.first, equals(_n2));
      });

      test('retourne plusieurs résultats si plusieurs noms correspondent', () {
        final repo = _makeRepo();
        // "lou" apparaît dans l'étymologie de _n1 ("loué") et _n2 ("loue")
        final results = repo.search('lou');
        expect(results.length, greaterThanOrEqualTo(2));
      });

      test('retourne une liste vide si aucun nom ne correspond', () {
        final repo = _makeRepo();
        expect(repo.search('xxxxinexistantxxxx'), isEmpty);
      });
    });
  });
}
