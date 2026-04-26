import 'package:sirah_app/features/names/data/models/prophet_name.dart';

// ── Types ─────────────────────────────────────────────────────────────────────

enum QuizType { qcm, flashcards }

class QcmQuestion {
  const QcmQuestion({
    required this.name,
    required this.maskedCommentary,
    required this.choices,
  });

  final ProphetName name;
  final String maskedCommentary;
  final List<ProphetName> choices; // 4 choix, mélangés, 1 correct
}

class QuizSession {
  QuizSession.qcm(this.questions)
      : type = QuizType.qcm,
        names = const [];

  QuizSession.flashcards(this.names)
      : type = QuizType.flashcards,
        questions = const [];

  final QuizType type;
  final List<QcmQuestion> questions;
  final List<ProphetName> names;
}

// ── Générateur ────────────────────────────────────────────────────────────────

class QuizGenerator {
  QuizGenerator._();

  static const int quizSize = 5;
  static const int choiceCount = 4;

  static List<ProphetName> pickRandom(List<ProphetName> all) {
    final shuffled = [...all]..shuffle();
    return shuffled.take(quizSize).toList();
  }

  static List<QcmQuestion> generateQcm(List<ProphetName> all) {
    final selected = pickRandom(all);
    return selected.map((name) => _buildQuestion(all, name)).toList();
  }

  static QcmQuestion _buildQuestion(List<ProphetName> all, ProphetName name) {
    final distractors = _distractors(all, name, choiceCount - 1);
    final choices = [name, ...distractors]..shuffle();
    return QcmQuestion(
      name: name,
      maskedCommentary: _mask(name.commentary, name.transliteration),
      choices: choices,
    );
  }

  // Masque la translittération dans le texte (insensible à la casse)
  static String _mask(String text, String transliteration) {
    if (transliteration.isEmpty || text.isEmpty) return text;
    final pattern = RegExp(RegExp.escape(transliteration), caseSensitive: false);
    return text.replaceAll(pattern, '[…]');
  }

  static List<ProphetName> _distractors(
    List<ProphetName> all,
    ProphetName target,
    int count,
  ) {
    // Préférer des noms de la même catégorie pour rendre le quiz plus pertinent
    final sameCategory = (all
          .where(
            (n) =>
                n.categorySlug == target.categorySlug &&
                n.number != target.number,
          )
          .toList()
        ..shuffle())
        .take(count)
        .toList();

    if (sameCategory.length >= count) return sameCategory;

    final needed = count - sameCategory.length;
    final others = (all
          .where(
            (n) => n.number != target.number && !sameCategory.contains(n),
          )
          .toList()
        ..shuffle())
        .take(needed)
        .toList();

    return [...sameCategory, ...others];
  }
}
