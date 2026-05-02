import 'package:sirah_app/features/asmaul_husna/data/models/husna_name.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';

enum QuizType { qcm, flashcards }

enum PracticeDeckType { prophetNames, asmaulHusna }

class PracticeItem {
  const PracticeItem({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.promptText,
    required this.detailText,
    required this.deckType,
    this.categorySlug,
    this.categoryLabel,
  });

  factory PracticeItem.fromProphetName(ProphetName name) {
    return PracticeItem(
      id: name.number,
      arabic: name.arabic,
      transliteration: name.transliteration,
      promptText: name.commentary,
      detailText: name.etymology,
      deckType: PracticeDeckType.prophetNames,
      categorySlug: name.categorySlug,
      categoryLabel: name.categoryLabel,
    );
  }

  factory PracticeItem.fromHusnaName(HusnaName name) {
    final prompt = name.meaningFr.trim().isNotEmpty
        ? name.meaningFr
        : name.etymology.trim().isNotEmpty
        ? name.etymology
        : name.transliteration;
    final detail = name.etymology.trim().isNotEmpty ? name.etymology : prompt;
    return PracticeItem(
      id: name.id,
      arabic: name.arabic,
      transliteration: name.transliteration,
      promptText: prompt,
      detailText: detail,
      deckType: PracticeDeckType.asmaulHusna,
    );
  }

  final int id;
  final String arabic;
  final String transliteration;
  final String promptText;
  final String detailText;
  final PracticeDeckType deckType;
  final String? categorySlug;
  final String? categoryLabel;
}

class QcmQuestion {
  const QcmQuestion({
    required this.item,
    required this.prompt,
    required this.choices,
  });

  final PracticeItem item;
  final String prompt;
  final List<PracticeItem> choices;
}

class QuizSession {
  QuizSession.qcm({required this.deckType, required this.questions})
    : type = QuizType.qcm,
      items = const [];

  QuizSession.flashcards({required this.deckType, required this.items})
    : type = QuizType.flashcards,
      questions = const [];

  final QuizType type;
  final PracticeDeckType deckType;
  final List<QcmQuestion> questions;
  final List<PracticeItem> items;
}

class QuizGenerator {
  QuizGenerator._();

  static const int quizSize = 5;
  static const int choiceCount = 4;

  static List<ProphetName> pickRandom(List<ProphetName> all) {
    final shuffled = [...all]..shuffle();
    return shuffled.take(quizSize).toList();
  }

  static List<QcmQuestion> generateQcm(List<ProphetName> all) {
    return generateProphetQcm(all);
  }

  static List<PracticeItem> pickRandomProphet(List<ProphetName> all) {
    return pickRandom(all).map(PracticeItem.fromProphetName).toList();
  }

  static List<QcmQuestion> generateProphetQcm(List<ProphetName> all) {
    final selected = pickRandom(all);
    return selected.map((name) => _buildProphetQuestion(all, name)).toList();
  }

  static List<PracticeItem> pickRandomHusna(List<HusnaName> all) {
    final shuffled = [...all]..shuffle();
    return shuffled.take(quizSize).map(PracticeItem.fromHusnaName).toList();
  }

  static List<QcmQuestion> generateHusnaQcm(List<HusnaName> all) {
    final shuffled = [...all]..shuffle();
    return shuffled
        .take(quizSize)
        .map((name) => _buildHusnaQuestion(all, name))
        .toList();
  }

  static QcmQuestion _buildProphetQuestion(
    List<ProphetName> all,
    ProphetName name,
  ) {
    final item = PracticeItem.fromProphetName(name);
    final choices = [
      item,
      ..._prophetDistractors(
        all,
        name,
        choiceCount - 1,
      ).map(PracticeItem.fromProphetName),
    ]..shuffle();
    return QcmQuestion(
      item: item,
      prompt: _mask(name.commentary, name.transliteration),
      choices: choices,
    );
  }

  static QcmQuestion _buildHusnaQuestion(List<HusnaName> all, HusnaName name) {
    final item = PracticeItem.fromHusnaName(name);
    final choices = [
      item,
      ..._husnaDistractors(
        all,
        name,
        choiceCount - 1,
      ).map(PracticeItem.fromHusnaName),
    ]..shuffle();
    return QcmQuestion(item: item, prompt: item.promptText, choices: choices);
  }

  static String _mask(String text, String transliteration) {
    if (transliteration.isEmpty || text.isEmpty) return text;
    final pattern = RegExp(
      RegExp.escape(transliteration),
      caseSensitive: false,
    );
    return text.replaceAll(pattern, '[...]');
  }

  static List<ProphetName> _prophetDistractors(
    List<ProphetName> all,
    ProphetName target,
    int count,
  ) {
    final sameCategory =
        (all
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
    final others =
        (all
                .where(
                  (n) => n.number != target.number && !sameCategory.contains(n),
                )
                .toList()
              ..shuffle())
            .take(needed)
            .toList();

    return [...sameCategory, ...others];
  }

  static List<HusnaName> _husnaDistractors(
    List<HusnaName> all,
    HusnaName target,
    int count,
  ) {
    return (all.where((name) => name.id != target.id).toList()..shuffle())
        .take(count)
        .toList();
  }
}
