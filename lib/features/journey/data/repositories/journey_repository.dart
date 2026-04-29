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

  List<NameExperience> getExperiences() => _experiences;

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

  List<NameActionItem> getActionsForTheme(
    String theme, {
    bool includeDrafts = false,
  }) {
    final actions = _actionBankForTheme(theme)?.actions ?? const [];
    if (includeDrafts) return actions;
    return actions
        .where((action) => action.editorialStatus == 'validated')
        .toList();
  }

  NameActionItem? getDailyActionForName(int number, DateTime date) {
    final theme = getExperienceForName(number)?.practiceTheme;
    if (theme == null || theme == 'general') return null;
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
    final constellationNameOwners = <int, List<String>>{};

    for (final constellation in _constellations) {
      if (!constellationIds.add(constellation.id)) {
        issues.add('Duplicate constellation id: ${constellation.id}');
      }
      if (constellation.nameNumbers.isEmpty) {
        issues.add('Constellation ${constellation.id} has no nameNumbers');
      }
      if (!_containsArabicScript(constellation.titleAr)) {
        issues.add(
          'Constellation ${constellation.id} titleAr must contain Arabic script',
        );
      }
      final uniqueNumbers = constellation.nameNumbers.toSet();
      if (uniqueNumbers.length != constellation.nameNumbers.length) {
        issues.add('Constellation ${constellation.id} has duplicate names');
      }
      for (final number in constellation.nameNumbers) {
        if (!validNameNumbers.contains(number)) {
          issues.add('Constellation ${constellation.id} references $number');
        }
        constellationNameOwners
            .putIfAbsent(number, () => <String>[])
            .add(constellation.id);
      }
    }

    for (final number in validNameNumbers) {
      if (!constellationNameOwners.containsKey(number)) {
        issues.add('Missing Journey constellation for name $number');
      }
    }
    for (final entry in constellationNameOwners.entries) {
      final owners = entry.value.toSet();
      if (owners.length > 1) {
        issues.add(
          'Name ${entry.key} appears in multiple constellations: '
          '${owners.join(', ')}',
        );
      }
    }

    final actionThemes = <String>{};
    final actionIds = <String>{};

    for (final bank in _actionBanks) {
      if (bank.theme.trim().isEmpty) {
        issues.add('Action theme cannot be empty');
      }
      if (!actionThemes.add(bank.theme)) {
        issues.add('Duplicate action theme: ${bank.theme}');
      }
      if (bank.actions.isEmpty) {
        issues.add('Action theme ${bank.theme} has no actions');
      }
      for (final action in bank.actions) {
        _validateActionItem(
          issues: issues,
          bankTheme: bank.theme,
          action: action,
          actionIds: actionIds,
          validNameNumbers: validNameNumbers,
        );
      }
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

    if (!actionThemes.contains('general')) {
      issues.add('Missing general action theme');
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

  static void _validateActionItem({
    required List<String> issues,
    required String bankTheme,
    required NameActionItem action,
    required Set<String> actionIds,
    required Set<int> validNameNumbers,
  }) {
    const validStatuses = {'draft', 'needs_review', 'validated'};
    const validDurations = {'short', 'medium', 'long'};
    const validDifficulties = {'simple', 'engaged', 'demanding'};

    if (action.id.trim().isEmpty) {
      issues.add('Action in theme $bankTheme has no id');
    } else if (!actionIds.add(action.id)) {
      issues.add('Duplicate action id: ${action.id}');
    }
    if (action.textFr.trim().isEmpty) {
      issues.add('Action ${action.id} has no textFr');
    }
    if (!validStatuses.contains(action.editorialStatus)) {
      issues.add(
        'Action ${action.id} has invalid editorialStatus '
        '${action.editorialStatus}',
      );
    }
    if (!validDurations.contains(action.duration)) {
      issues.add('Action ${action.id} has invalid duration ${action.duration}');
    }
    if (!validDifficulties.contains(action.difficulty)) {
      issues.add(
        'Action ${action.id} has invalid difficulty ${action.difficulty}',
      );
    }
    for (final number in action.nameNumbers) {
      if (!validNameNumbers.contains(number)) {
        issues.add('Action ${action.id} references $number');
      }
    }
  }

  static bool _containsArabicScript(String value) {
    for (final rune in value.runes) {
      if ((rune >= 0x0600 && rune <= 0x06FF) ||
          (rune >= 0x0750 && rune <= 0x077F) ||
          (rune >= 0x08A0 && rune <= 0x08FF) ||
          (rune >= 0xFB50 && rune <= 0xFDFF) ||
          (rune >= 0xFE70 && rune <= 0xFEFF)) {
        return true;
      }
    }
    return false;
  }
}
