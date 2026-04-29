import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/data/sources/journey_decks_json_source.dart';
import 'package:sirah_app/features/journey/data/sources/journey_map_layout_json_source.dart';
import 'package:sirah_app/features/journey/data/sources/name_actions_json_source.dart';
import 'package:sirah_app/features/names/data/sources/names_json_source.dart';

const _mission = NameConstellation(
  id: 'prophethood',
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
  actions: [
    NameActionItem(
      id: 'general_a',
      textFr: 'Action générale A',
      editorialStatus: 'needs_review',
    ),
    NameActionItem(
      id: 'general_b',
      textFr: 'Action générale B',
      editorialStatus: 'validated',
      sourceNote: 'Fixture reviewed.',
      reviewedBy: 'test-reviewer',
      validatedAt: '2026-04-30',
    ),
  ],
);

const _missionActions = NameActionBank(
  theme: 'mission',
  actions: [
    NameActionItem(
      id: 'mission_a',
      textFr: 'Action mission A',
      editorialStatus: 'validated',
      sourceNote: 'Fixture reviewed.',
      reviewedBy: 'test-reviewer',
      validatedAt: '2026-04-30',
    ),
    NameActionItem(
      id: 'mission_b',
      textFr: 'Action mission B',
      editorialStatus: 'validated',
      sourceNote: 'Fixture reviewed.',
      reviewedBy: 'test-reviewer',
      validatedAt: '2026-04-30',
    ),
    NameActionItem(id: 'mission_c', textFr: 'Action mission C'),
  ],
);

const _virtuesActions = NameActionBank(
  theme: 'virtues',
  actions: [
    NameActionItem(
      id: 'virtues_a',
      textFr: 'Action vertus A',
      editorialStatus: 'validated',
      sourceNote: 'Fixture reviewed.',
      reviewedBy: 'test-reviewer',
      validatedAt: '2026-04-30',
    ),
  ],
);

JourneyRepository _repo({
  List<NameConstellation> constellations = const [_mission, _virtues],
  List<NameExperience> experiences = const [_experience],
  List<NameActionBank> actionBanks = const [
    _generalActions,
    _missionActions,
    _virtuesActions,
  ],
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

      expect(repo.getConstellationById('prophethood'), _mission);
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

    test('getActionsForTheme returns validated actions only', () {
      final repo = _repo();

      expect(repo.getActionsForTheme('mission').map((action) => action.id), [
        'mission_a',
        'mission_b',
      ]);
      expect(
        repo
            .getActionsForTheme('mission', includeDrafts: true)
            .map((action) => action.id),
        ['mission_a', 'mission_b', 'mission_c'],
      );
      expect(repo.getActionsForTheme('unknown'), isEmpty);
    });

    test(
      'getActionsForTheme hides validated actions without review metadata',
      () {
        final repo = _repo(
          actionBanks: const [
            _generalActions,
            _virtuesActions,
            NameActionBank(
              theme: 'mission',
              actions: [
                NameActionItem(
                  id: 'mission_unreviewed',
                  textFr: 'Action non relue',
                  editorialStatus: 'validated',
                ),
              ],
            ),
          ],
        );

        expect(repo.getActionsForTheme('mission'), isEmpty);
        expect(
          repo
              .getActionsForTheme('mission', includeDrafts: true)
              .map((action) => action.id),
          ['mission_unreviewed'],
        );
      },
    );

    test('getDailyActionForName is deterministic for same name and date', () {
      final repo = _repo();
      final date = DateTime(2026, 4, 28);

      final first = repo.getDailyActionForName(1, date);
      final second = repo.getDailyActionForName(1, date);

      expect(first, isNotNull);
      expect(first, second);
      expect(
        _missionActions.actions.where(
          (action) => action.editorialStatus == 'validated',
        ),
        contains(first),
      );
    });

    test('getDailyActionForName falls back to constellation theme', () {
      final repo = _repo();
      final action = repo.getDailyActionForName(2, DateTime(2026, 4, 28));

      expect(action, isNotNull);
      expect(
        _missionActions.actions.where(
          (item) => item.editorialStatus == 'validated',
        ),
        contains(action),
      );
    });

    test('getDailyActionForName prefers direct name actions', () {
      const directAction = NameActionItem(
        id: 'direct_name_2',
        textFr: 'Action directe',
        editorialStatus: 'validated',
        sourceNote: 'Fixture reviewed.',
        reviewedBy: 'test-reviewer',
        validatedAt: '2026-04-30',
        nameNumbers: [2],
      );
      final repo = _repo(
        actionBanks: const [
          _generalActions,
          _missionActions,
          _virtuesActions,
          NameActionBank(theme: 'trust', actions: [directAction]),
        ],
      );

      final action = repo.getDailyActionForName(2, DateTime(2026, 4, 28));

      expect(action, directAction);
    });

    test('getDailyActionForName does not fall back to general actions', () {
      final repo = _repo(
        actionBanks: const [
          _generalActions,
          NameActionBank(
            theme: 'mission',
            actions: [
              NameActionItem(
                id: 'mission_draft',
                textFr: 'Brouillon mission',
                editorialStatus: 'needs_review',
              ),
            ],
          ),
          _virtuesActions,
        ],
      );

      final action = repo.getDailyActionForName(2, DateTime(2026, 4, 28));

      expect(action, isNull);
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

    test('validate exposes malformed action metadata', () {
      final repo = _repo(
        actionBanks: const [
          _generalActions,
          NameActionBank(
            theme: 'mission',
            actions: [
              NameActionItem(
                id: 'general_a',
                textFr: '',
                editorialStatus: 'published',
                duration: 'instant',
                difficulty: 'hard',
                nameNumbers: [999],
              ),
            ],
          ),
        ],
      );

      final issues = repo.validate(validNameNumbers: {1, 2, 3});

      expect(issues, contains('Duplicate action id: general_a'));
      expect(issues, contains('Action general_a has no textFr'));
      expect(
        issues.any((issue) => issue.contains('invalid editorialStatus')),
        isTrue,
      );
      expect(issues.any((issue) => issue.contains('invalid duration')), isTrue);
      expect(
        issues.any((issue) => issue.contains('invalid difficulty')),
        isTrue,
      );
      expect(issues, contains('Action general_a references 999'));
    });

    test('validate requires review metadata for validated actions', () {
      final repo = _repo(
        actionBanks: const [
          _generalActions,
          _virtuesActions,
          NameActionBank(
            theme: 'mission',
            actions: [
              NameActionItem(
                id: 'mission_unreviewed',
                textFr: 'Action mission',
                editorialStatus: 'validated',
                validatedAt: 'not-a-date',
              ),
            ],
          ),
        ],
      );

      final issues = repo.validate(validNameNumbers: {1, 2, 3});

      expect(
        issues,
        contains('Action mission_unreviewed is validated without reviewedBy'),
      );
      expect(
        issues,
        contains(
          'Action mission_unreviewed has invalid validatedAt not-a-date',
        ),
      );
      expect(
        issues,
        contains(
          'Action mission_unreviewed is validated without sourceNote or sourceRefs',
        ),
      );
    });

    test('load reads real assets and validates name references', () async {
      final repo = await JourneyRepository.load();
      final names = await NamesJsonSource.load();
      final validNameNumbers = names.map((n) => n.number).toSet();

      final issues = repo.validate(validNameNumbers: validNameNumbers);

      expect(repo.getConstellations(), isNotEmpty);
      expect(
        repo.getActionsForTheme('general', includeDrafts: true),
        isNotEmpty,
      );
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

    test('real story assets carry explicit editorial status', () async {
      final repo = await JourneyRepository.load();
      final stories = repo
          .getExperiences()
          .expand((experience) => experience.stories)
          .toList();

      expect(stories, isNotEmpty);
      expect(
        stories.every((story) => story.editorialStatus.isNotEmpty),
        isTrue,
      );
      expect(
        stories.where((story) => story.editorialStatus == 'needs_review'),
        isNotEmpty,
      );
    });

    test('real action assets expose only reviewed actions', () async {
      final repo = await JourneyRepository.load();
      final banks = await NameActionsJsonSource.load();
      final actions = banks.expand((bank) => bank.actions).toList();
      final validated = actions
          .where((action) => action.editorialStatus == 'validated')
          .toList();
      final needsReview = actions
          .where((action) => action.editorialStatus == 'needs_review')
          .toList();

      expect(
        banks.map((bank) => bank.theme).toSet(),
        containsAll({
          'general',
          'praise',
          'mission',
          'trust',
          'nobility',
          'intercession',
          'eschatology',
          'purity',
          'virtues',
          'miraj',
          'guidance',
          'light',
          'devotion',
        }),
      );
      expect(actions, isNotEmpty);
      expect(actions.length, 43);
      expect(validated.length, 40);
      expect(needsReview.length, 3);
      expect(
        needsReview.every(
          (action) =>
              action.id == 'general_intention_001' ||
              action.id == 'general_speech_001' ||
              action.id == 'general_gratitude_001',
        ),
        isTrue,
      );
      expect(actions.every((action) => action.nameNumbers.isEmpty), isFalse);
      expect(
        validated.every(
          (action) =>
              action.reviewedBy == 'project_owner' &&
              action.validatedAt == '2026-04-30' &&
              action.sourceNote.isNotEmpty,
        ),
        isTrue,
      );
      expect(
        banks
            .where((bank) => bank.theme == 'praise')
            .single
            .actions
            .where((action) => action.editorialStatus == 'validated')
            .length,
        4,
      );
      expect(
        banks
            .where((bank) => bank.theme == 'mission')
            .single
            .actions
            .where((action) => action.editorialStatus == 'validated')
            .length,
        4,
      );
      expect(
        banks
            .where((bank) => bank.theme == 'light')
            .single
            .actions
            .where((action) => action.editorialStatus == 'validated')
            .length,
        3,
      );
      expect(
        banks
            .where((bank) => bank.theme == 'trust')
            .single
            .actions
            .where((action) => action.editorialStatus == 'validated')
            .length,
        4,
      );
      expect(
        banks
            .where((bank) => bank.theme == 'nobility')
            .single
            .actions
            .where((action) => action.editorialStatus == 'validated')
            .length,
        4,
      );
      expect(
        banks
            .where((bank) => bank.theme == 'virtues')
            .single
            .actions
            .where((action) => action.editorialStatus == 'validated')
            .length,
        3,
      );
      expect(repo.getActionsForTheme('trust'), hasLength(4));
      for (final theme in const {
        'intercession',
        'eschatology',
        'purity',
        'miraj',
        'guidance',
        'devotion',
      }) {
        expect(repo.getActionsForTheme(theme), hasLength(3));
      }
      expect(repo.getActionsForTheme('general'), isEmpty);
      expect(repo.getActionsForTheme('praise'), hasLength(4));
      expect(
        repo.getDailyActionForName(1, DateTime(2026, 4, 30))?.id,
        'praise_name_001',
      );
      expect(
        repo.getDailyActionForName(21, DateTime(2026, 4, 30))?.id,
        'trust_name_021',
      );
      expect(
        repo.getDailyActionForName(78, DateTime(2026, 4, 30))?.id,
        'nobility_name_078',
      );
      final virtuesAction = repo.getDailyActionForName(
        22,
        DateTime(2026, 4, 30),
      );
      expect(virtuesAction, isNotNull);
      expect(virtuesAction!.id.startsWith('virtues_'), isTrue);
      final lightAction = repo.getDailyActionForName(56, DateTime(2026, 4, 30));
      expect(lightAction, isNotNull);
      expect(lightAction!.id.startsWith('light_'), isTrue);
      final intercessionAction = repo.getDailyActionForName(
        6,
        DateTime(2026, 4, 30),
      );
      expect(intercessionAction, isNotNull);
      expect(intercessionAction!.id.startsWith('intercession_'), isTrue);
      final eschatologyAction = repo.getDailyActionForName(
        8,
        DateTime(2026, 4, 30),
      );
      expect(eschatologyAction, isNotNull);
      expect(eschatologyAction!.id.startsWith('eschatology_'), isTrue);
      final purityAction = repo.getDailyActionForName(
        18,
        DateTime(2026, 4, 30),
      );
      expect(purityAction, isNotNull);
      expect(purityAction!.id.startsWith('purity_'), isTrue);
      final mirajAction = repo.getDailyActionForName(42, DateTime(2026, 4, 30));
      expect(mirajAction, isNotNull);
      expect(mirajAction!.id.startsWith('miraj_'), isTrue);
      final guidanceAction = repo.getDailyActionForName(
        54,
        DateTime(2026, 4, 30),
      );
      expect(guidanceAction, isNotNull);
      expect(guidanceAction!.id.startsWith('guidance_'), isTrue);
      final devotionAction = repo.getDailyActionForName(
        88,
        DateTime(2026, 4, 30),
      );
      expect(devotionAction, isNotNull);
      expect(devotionAction!.id.startsWith('devotion_'), isTrue);
      for (final theme in const {
        'praise',
        'mission',
        'intercession',
        'eschatology',
        'purity',
        'virtues',
        'miraj',
        'guidance',
        'light',
        'nobility',
        'devotion',
      }) {
        expect(
          banks.where((bank) => bank.theme == theme).single.actions.length,
          greaterThanOrEqualTo(3),
          reason: 'Each constellation theme needs several reviewable actions.',
        );
      }
    });
  });
}
