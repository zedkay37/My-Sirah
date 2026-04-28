import 'package:sirah_app/features/journey/data/models/name_action_bank.dart';
import 'package:sirah_app/features/journey/data/models/name_constellation.dart';
import 'package:sirah_app/features/journey/data/models/name_experience.dart';
import 'package:sirah_app/features/journey/data/sources/name_actions_json_source.dart';
import 'package:sirah_app/features/journey/data/sources/name_constellations_json_source.dart';
import 'package:sirah_app/features/journey/data/sources/name_experiences_json_source.dart';

export 'package:sirah_app/features/journey/data/models/name_action_bank.dart';
export 'package:sirah_app/features/journey/data/models/name_constellation.dart';
export 'package:sirah_app/features/journey/data/models/name_experience.dart';
export 'package:sirah_app/features/journey/data/models/journey_deck.dart';
export 'package:sirah_app/features/journey/data/models/journey_map_layout.dart';

class JourneyRepository {
  JourneyRepository({
    required List<NameConstellation> constellations,
    required List<NameExperience> experiences,
    required List<NameActionBank> actionBanks,
  }) : _constellations = constellations,
       _experiences = experiences,
       _actionBanks = actionBanks;

  final List<NameConstellation> _constellations;
  final List<NameExperience> _experiences;
  final List<NameActionBank> _actionBanks;

  static Future<JourneyRepository> load() async {
    final constellations = await NameConstellationsJsonSource.load();
    final experiences = await NameExperiencesJsonSource.load();
    final actionBanks = await NameActionsJsonSource.load();
    return JourneyRepository(
      constellations: constellations,
      experiences: experiences,
      actionBanks: actionBanks,
    );
  }

  List<NameConstellation> getConstellations() => _constellations;

  NameConstellation? getConstellationById(String id) {
    try {
      return _constellations.firstWhere((c) => c.id == id);
    } on StateError {
      return null;
    }
  }

  List<NameConstellation> getConstellationsForName(int number) {
    return _constellations
        .where((c) => c.nameNumbers.contains(number))
        .toList();
  }

  NameExperience? getExperienceForName(int number) {
    try {
      return _experiences.firstWhere((e) => e.nameNumber == number);
    } on StateError {
      return null;
    }
  }

  List<String> getActionsForTheme(String theme) {
    final bank = _actionBankForTheme(theme);
    if (bank != null && bank.actions.isNotEmpty) return bank.actions;
    return _actionBankForTheme('general')?.actions ?? const [];
  }

  String? getDailyActionForName(int number, DateTime date) {
    final theme = getExperienceForName(number)?.practiceTheme ?? 'general';
    final actions = getActionsForTheme(theme);
    if (actions.isEmpty) return null;
    final seed = _stableSeed('$number-${_dateKey(date)}-$theme');
    return actions[seed % actions.length];
  }

  List<String> validate({
    required Set<int> validNameNumbers,
    Set<String> validPeopleIds = const {},
  }) {
    final issues = <String>[];
    final constellationIds = <String>{};

    for (final constellation in _constellations) {
      if (!constellationIds.add(constellation.id)) {
        issues.add('Duplicate constellation id: ${constellation.id}');
      }
      if (constellation.nameNumbers.isEmpty) {
        issues.add('Constellation ${constellation.id} has no nameNumbers');
      }
      final uniqueNumbers = constellation.nameNumbers.toSet();
      if (uniqueNumbers.length != constellation.nameNumbers.length) {
        issues.add('Constellation ${constellation.id} has duplicate names');
      }
      for (final number in constellation.nameNumbers) {
        if (!validNameNumbers.contains(number)) {
          issues.add('Constellation ${constellation.id} references $number');
        }
      }
    }

    final actionThemes = _actionBanks.map((b) => b.theme).toSet();
    if (!actionThemes.contains('general')) {
      issues.add('Missing general action theme');
    }

    final experienceNumbers = <int>{};
    for (final experience in _experiences) {
      if (!experienceNumbers.add(experience.nameNumber)) {
        issues.add('Duplicate experience for name ${experience.nameNumber}');
      }
      if (!validNameNumbers.contains(experience.nameNumber)) {
        issues.add('Experience references ${experience.nameNumber}');
      }
      if (!actionThemes.contains(experience.practiceTheme)) {
        issues.add(
          'Experience ${experience.nameNumber} references missing theme '
          '${experience.practiceTheme}',
        );
      }
      for (final story in experience.stories) {
        for (final personId in story.relatedPeople) {
          if (validPeopleIds.isNotEmpty && !validPeopleIds.contains(personId)) {
            issues.add('Story ${story.id} references missing person $personId');
          }
        }
      }
    }

    for (final bank in _actionBanks) {
      if (bank.actions.isEmpty) {
        issues.add('Action theme ${bank.theme} has no actions');
      }
    }

    return issues;
  }

  NameActionBank? _actionBankForTheme(String theme) {
    try {
      return _actionBanks.firstWhere((b) => b.theme == theme);
    } on StateError {
      return null;
    }
  }

  static String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}$month$day';
  }

  static int _stableSeed(String value) {
    var hash = 0;
    for (final unit in value.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return hash;
  }
}
