import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/quiz/data/quiz_generator.dart';

// ── Fixtures ──────────────────────────────────────────────────────────────────

ProphetName _name(int n, {String slug = 'prophethood'}) => ProphetName(
  number: n,
  arabic: 'اسم$n',
  transliteration: 'Name$n',
  categorySlug: slug,
  categoryLabel: 'Cat',
  etymology: 'Etymology $n',
  commentary: 'Commentary for Name$n number $n',
  references: '',
  primarySource: '',
  secondarySources: '',
);

/// 10 noms en prophethood + 10 en mercy pour couvrir les distracteurs
/// cross-catégorie.
final _pool = [
  for (var i = 1; i <= 10; i++) _name(i, slug: 'prophethood'),
  for (var i = 11; i <= 20; i++) _name(i, slug: 'mercy'),
];

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('QuizGenerator', () {
    group('pickRandom', () {
      test('retourne exactement quizSize éléments quand pool suffisant', () {
        final picked = QuizGenerator.pickRandom(_pool);
        expect(picked.length, QuizGenerator.quizSize);
      });

      test('ne retourne pas plus que quizSize même si pool plus grand', () {
        final big = [for (var i = 1; i <= 100; i++) _name(i)];
        final picked = QuizGenerator.pickRandom(big);
        expect(picked.length, QuizGenerator.quizSize);
      });

      test('retourne tous les éléments si pool < quizSize', () {
        final tiny = [_name(1), _name(2)];
        final picked = QuizGenerator.pickRandom(tiny);
        expect(picked.length, tiny.length);
      });

      test('les éléments retournés font partie du pool source', () {
        final picked = QuizGenerator.pickRandom(_pool);
        for (final p in picked) {
          expect(_pool, contains(p));
        }
      });
    });

    group('generateQcm', () {
      late List<QcmQuestion> questions;

      setUp(() {
        questions = QuizGenerator.generateQcm(_pool);
      });

      test('retourne exactement quizSize questions', () {
        expect(questions.length, QuizGenerator.quizSize);
      });

      test('chaque question contient exactement choiceCount choix', () {
        for (final q in questions) {
          expect(
            q.choices.length,
            QuizGenerator.choiceCount,
            reason:
                'Question pour ${q.name.transliteration} a ${q.choices.length} choix',
          );
        }
      });

      test('la bonne réponse est toujours incluse dans les choix', () {
        for (final q in questions) {
          expect(
            q.choices.any((c) => c.number == q.name.number),
            isTrue,
            reason: '${q.name.transliteration} absent de ses propres choix',
          );
        }
      });

      test('aucun doublon dans les choix d\'une question', () {
        for (final q in questions) {
          final numbers = q.choices.map((c) => c.number).toList();
          expect(
            numbers.toSet().length,
            numbers.length,
            reason:
                'Doublons détectés dans les choix de ${q.name.transliteration}',
          );
        }
      });

      test('les distracteurs ne contiennent pas la bonne réponse', () {
        for (final q in questions) {
          final distractors = q.choices
              .where((c) => c.number != q.name.number)
              .toList();
          expect(distractors.any((c) => c.number == q.name.number), isFalse);
        }
      });

      test(
        'maskedCommentary ne contient pas la translittération du nom (insensible casse)',
        () {
          for (final q in questions) {
            // Si la translittération apparaît dans le commentary, elle doit être masquée
            if (q.name.commentary.toLowerCase().contains(
              q.name.transliteration.toLowerCase(),
            )) {
              expect(
                q.maskedCommentary.toLowerCase().contains(
                  q.name.transliteration.toLowerCase(),
                ),
                isFalse,
                reason:
                    '${q.name.transliteration} pas masqué dans le commentary',
              );
            }
          }
        },
      );
    });

    group('generateQcm — pool minimal (exactement choiceCount noms)', () {
      test('fonctionne avec un pool de taille exactement choiceCount', () {
        final minPool = [
          for (var i = 1; i <= QuizGenerator.choiceCount; i++) _name(i),
        ];
        // quizSize (5) > minPool.length (4) → pickRandom retourne les 4
        final questions = QuizGenerator.generateQcm(minPool);
        for (final q in questions) {
          expect(q.choices, isNotEmpty);
          expect(q.choices.any((c) => c.number == q.name.number), isTrue);
          final numbers = q.choices.map((c) => c.number).toList();
          expect(numbers.toSet().length, numbers.length);
        }
      });
    });
  });
}
