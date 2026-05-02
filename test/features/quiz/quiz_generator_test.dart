import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/features/asmaul_husna/data/models/husna_name.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/quiz/data/quiz_generator.dart';

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

HusnaName _husna(int n) => HusnaName(
  id: n,
  arabic: 'الحسنى$n',
  transliteration: 'Husna$n',
  meaningFr: 'Sens $n',
  etymology: 'Etymologie $n',
  reference: '',
);

final _pool = [
  for (var i = 1; i <= 10; i++) _name(i, slug: 'prophethood'),
  for (var i = 11; i <= 20; i++) _name(i, slug: 'mercy'),
];

void main() {
  group('QuizGenerator', () {
    group('pickRandom', () {
      test('retourne exactement quizSize elements quand pool suffisant', () {
        final picked = QuizGenerator.pickRandom(_pool);
        expect(picked.length, QuizGenerator.quizSize);
      });

      test('ne retourne pas plus que quizSize meme si pool plus grand', () {
        final big = [for (var i = 1; i <= 100; i++) _name(i)];
        final picked = QuizGenerator.pickRandom(big);
        expect(picked.length, QuizGenerator.quizSize);
      });

      test('retourne tous les elements si pool < quizSize', () {
        final tiny = [_name(1), _name(2)];
        final picked = QuizGenerator.pickRandom(tiny);
        expect(picked.length, tiny.length);
      });

      test('les elements retournes font partie du pool source', () {
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
                'Question pour ${q.item.transliteration} a ${q.choices.length} choix',
          );
        }
      });

      test('la bonne reponse est toujours incluse dans les choix', () {
        for (final q in questions) {
          expect(
            q.choices.any((c) => c.id == q.item.id),
            isTrue,
            reason: '${q.item.transliteration} absent de ses propres choix',
          );
        }
      });

      test('aucun doublon dans les choix', () {
        for (final q in questions) {
          final numbers = q.choices.map((c) => c.id).toList();
          expect(
            numbers.toSet().length,
            numbers.length,
            reason:
                'Doublons detectes dans les choix de ${q.item.transliteration}',
          );
        }
      });

      test('les distracteurs ne contiennent pas la bonne reponse', () {
        for (final q in questions) {
          final distractors = q.choices
              .where((c) => c.id != q.item.id)
              .toList();
          expect(distractors.any((c) => c.id == q.item.id), isFalse);
        }
      });

      test('masque la translitteration du nom', () {
        for (final q in questions) {
          if (q.item.promptText.toLowerCase().contains(
            q.item.transliteration.toLowerCase(),
          )) {
            expect(
              q.prompt.toLowerCase().contains(
                q.item.transliteration.toLowerCase(),
              ),
              isFalse,
              reason: '${q.item.transliteration} pas masque dans le commentary',
            );
          }
        }
      });
    });

    group('generateQcm pool minimal', () {
      test('fonctionne avec un pool de taille exactement choiceCount', () {
        final minPool = [
          for (var i = 1; i <= QuizGenerator.choiceCount; i++) _name(i),
        ];
        final questions = QuizGenerator.generateQcm(minPool);
        for (final q in questions) {
          expect(q.choices, isNotEmpty);
          expect(q.choices.any((c) => c.id == q.item.id), isTrue);
          final numbers = q.choices.map((c) => c.id).toList();
          expect(numbers.toSet().length, numbers.length);
        }
      });
    });

    group('generateHusnaQcm', () {
      test('produit des questions avec sens et choix Husna', () {
        final pool = [for (var i = 1; i <= 8; i++) _husna(i)];
        final questions = QuizGenerator.generateHusnaQcm(pool);

        expect(questions.length, QuizGenerator.quizSize);
        for (final question in questions) {
          expect(question.item.deckType, PracticeDeckType.asmaulHusna);
          expect(question.prompt, startsWith('Sens'));
          expect(
            question.choices.any((item) => item.id == question.item.id),
            isTrue,
          );
          expect(
            question.choices.map((item) => item.id).toSet().length,
            question.choices.length,
          );
        }
      });
    });
  });
}
