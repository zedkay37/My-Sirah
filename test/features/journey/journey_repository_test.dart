import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/data/sources/journey_decks_json_source.dart';
import 'package:sirah_app/features/journey/data/sources/journey_map_layout_json_source.dart';
import 'package:sirah_app/features/names/data/sources/names_json_source.dart';

const _mission = NameConstellation(
  id: 'mission',
  titleFr: 'Mission',
  titleAr: 'الرسالة',
  descriptionFr: 'Mission prophétique',
  nameNumbers: [1, 2],
  colorHex: '#4A6A8E',
);

const _virtues = NameConstellation(
  id: 'virtues',
  titleFr: 'Vertus',
  titleAr: 'الأخلاق',
  descriptionFr: 'Nobles caractères',
  nameNumbers: [3],
  colorHex: '#4A8E6A',
);

const _experience = NameExperience(
  nameNumber: 1,
  stories: [
    NameStory(
      id: 'story_1',
      titleFr: 'Récit',
      bodyFr: 'Un récit court.',
      tags: ['mission'],
      sourceNote: 'Source éditoriale.',
      relatedPeople: ['muhammad'],
    ),
  ],
  tafakkurPromptFr: 'Que puis-je vivre aujourd’hui ?',
  practiceTheme: 'mission',
);

const _generalActions = NameActionBank(
  theme: 'general',
  actions: ['Action générale A', 'Action générale B'],
);

const _missionActions = NameActionBank(
  theme: 'mission',
  actions: ['Action mission A', 'Action mission B', 'Action mission C'],
);

JourneyRepository _repo({
  List<NameConstellation> constellations = const [_mission, _virtues],
  List<NameExperience> experiences = const [_experience],
  List<NameActionBank> actionBanks = const [_generalActions, _missionActions],
}) {
  return JourneyRepository(
    constellations: constellations,
    experiences: experiences,
    actionBanks: actionBanks,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JourneyRepository', () {
    test('getConstellations returns configured constellations', () {
      final repo = _repo();

      expect(repo.getConstellations(), [_mission, _virtues]);
    });

    test('getConstellationById returns matching constellation or null', () {
      final repo = _repo();

      expect(repo.getConstellationById('mission'), _mission);
      expect(repo.getConstellationById('unknown'), isNull);
    });

    test('getConstellationsForName returns constellations containing name', () {
      final repo = _repo();

      expect(repo.getConstellationsForName(1), [_mission]);
      expect(repo.getConstellationsForName(3), [_virtues]);
      expect(repo.getConstellationsForName(999), isEmpty);
    });

    test('getExperienceForName returns experience or null', () {
      final repo = _repo();

      expect(repo.getExperienceForName(1), _experience);
      expect(repo.getExperienceForName(2), isNull);
    });

    test('getActionsForTheme falls back to general for unknown theme', () {
      final repo = _repo();

      expect(repo.getActionsForTheme('mission'), _missionActions.actions);
      expect(repo.getActionsForTheme('unknown'), _generalActions.actions);
    });

    test('getDailyActionForName is deterministic for same name and date', () {
      final repo = _repo();
      final date = DateTime(2026, 4, 28);

      final first = repo.getDailyActionForName(1, date);
      final second = repo.getDailyActionForName(1, date);

      expect(first, isNotNull);
      expect(first, second);
      expect(_missionActions.actions, contains(first));
    });

    test('getDailyActionForName uses general fallback without experience', () {
      final repo = _repo();
      final action = repo.getDailyActionForName(2, DateTime(2026, 4, 28));

      expect(_generalActions.actions, contains(action));
    });

    test('validate returns no issues for coherent data', () {
      final repo = _repo();

      final issues = repo.validate(
        validNameNumbers: {1, 2, 3},
        validPeopleIds: {'muhammad'},
      );

      expect(issues, isEmpty);
    });

    test('validate exposes invalid name numbers and missing action themes', () {
      final repo = _repo(
        constellations: [
          _mission,
          const NameConstellation(
            id: 'bad',
            titleFr: 'Bad',
            titleAr: 'Bad',
            descriptionFr: 'Bad',
            nameNumbers: [999, 999],
            colorHex: '#000000',
          ),
        ],
        experiences: [
          const NameExperience(
            nameNumber: 999,
            tafakkurPromptFr: 'Prompt',
            practiceTheme: 'missing',
          ),
        ],
      );

      final issues = repo.validate(validNameNumbers: {1, 2, 3});

      expect(issues.any((i) => i.contains('references 999')), isTrue);
      expect(issues.any((i) => i.contains('duplicate names')), isTrue);
      expect(issues.any((i) => i.contains('missing theme missing')), isTrue);
    });

    test('validate exposes names missing from Journey constellations', () {
      final repo = _repo(constellations: const [_mission]);

      final issues = repo.validate(validNameNumbers: {1, 2, 3});

      expect(issues, contains('Missing Journey constellation for name 3'));
    });

    test('validate exposes names duplicated across constellations', () {
      final repo = _repo(
        constellations: const [
          _mission,
          NameConstellation(
            id: 'duplicate',
            titleFr: 'Duplicate',
            titleAr: 'Duplicate',
            descriptionFr: 'Duplicate',
            nameNumbers: [2, 3],
            colorHex: '#000000',
          ),
        ],
      );

      final issues = repo.validate(validNameNumbers: {1, 2, 3});

      expect(
        issues.any(
          (issue) =>
              issue.contains('Name 2 appears in multiple constellations'),
        ),
        isTrue,
      );
    });

    test('load reads real assets and validates name references', () async {
      final repo = await JourneyRepository.load();
      final names = await NamesJsonSource.load();
      final validNameNumbers = names.map((n) => n.number).toSet();

      final issues = repo.validate(validNameNumbers: validNameNumbers);

      expect(repo.getConstellations(), isNotEmpty);
      expect(repo.getActionsForTheme('general'), isNotEmpty);
      expect(repo.getExperienceForName(1), isNotNull);
      expect(issues, isEmpty);
    });

    test('journey decks asset exposes prophet names as active deck', () async {
      final decks = await JourneyDecksJsonSource.load();
      final prophetDeck = decks.firstWhere((d) => d.id == 'prophet_names');

      expect(decks, isNotEmpty);
      expect(prophetDeck.isActive, isTrue);
      expect(prophetDeck.totalItems, 201);
      expect(
        decks.where((d) => d.id == 'asmaul_husna').single.status,
        'library_only',
      );
    });

    test(
      'journey map layout references existing constellations and stars',
      () async {
        final repo = await JourneyRepository.load();
        final layout = await JourneyMapLayoutJsonSource.load();
        final constellationIds = repo
            .getConstellations()
            .map((c) => c.id)
            .toSet();

        expect(layout.deckId, 'prophet_names');
        expect(layout.constellations, isNotEmpty);
        for (final node in layout.constellations) {
          expect(constellationIds, contains(node.id));
          expect(node.x, inInclusiveRange(0, 1));
          expect(node.y, inInclusiveRange(0, 1));
        }
        for (final constellation in repo.getConstellations()) {
          final numbers = constellation.nameNumbers.toSet();
          final stars = layout.starsFor(constellation.id);
          expect(stars, isNotEmpty);
          for (final star in stars) {
            expect(numbers, contains(star.number));
            expect(star.x, inInclusiveRange(0, 1));
            expect(star.y, inInclusiveRange(0, 1));
          }
        }
      },
    );

    test('all prophet names are represented exactly once in Journey', () async {
      final repo = await JourneyRepository.load();
      final names = await NamesJsonSource.load();
      final validNameNumbers = names.map((name) => name.number).toSet();
      final journeyNumbers = repo
          .getConstellations()
          .expand((constellation) => constellation.nameNumbers)
          .toList();

      expect(names.length, 201);
      expect(journeyNumbers.length, 201);
      expect(journeyNumbers.toSet(), validNameNumbers);
    });

    test(
      'journey map layout and constellation data cover same names',
      () async {
        final repo = await JourneyRepository.load();
        final layout = await JourneyMapLayoutJsonSource.load();
        final journeyNumbers = repo
            .getConstellations()
            .expand((constellation) => constellation.nameNumbers)
            .toSet();
        final starNumbers = layout.stars.values
            .expand((stars) => stars)
            .map((star) => star.number)
            .toList();

        expect(starNumbers.length, 201);
        expect(starNumbers.toSet(), journeyNumbers);
        expect(starNumbers.toSet().length, starNumbers.length);

        for (final constellation in repo.getConstellations()) {
          final stars = layout.starsFor(constellation.id);
          expect(
            stars.map((star) => star.number).toSet(),
            constellation.nameNumbers.toSet(),
            reason: 'Layout stars must match ${constellation.id}.',
          );
        }
      },
    );

    test(
      'active prophet names deck is valid and library-only decks stay out',
      () async {
        final decks = await JourneyDecksJsonSource.load();
        final activeDecks = decks.where((deck) => deck.isActive).toList();
        final prophetDeck = activeDecks.singleWhere(
          (deck) => deck.id == 'prophet_names',
        );

        expect(prophetDeck.itemType, 'prophet_name');
        expect(prophetDeck.totalItems, 201);
        expect(
          activeDecks.map((deck) => deck.id),
          isNot(contains('asmaul_husna')),
        );
        expect(
          decks.where((deck) => deck.status == 'library_only').map((d) => d.id),
          contains('asmaul_husna'),
        );
      },
    );
  });
}
