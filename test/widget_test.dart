import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/data/sources/categories_json_source.dart';
import 'package:sirah_app/features/names/presentation/detail/detail_screen.dart';
import 'package:sirah_app/features/names/presentation/home/home_screen.dart';
import 'package:sirah_app/features/names/presentation/list/list_screen.dart';
import 'package:sirah_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:sirah_app/features/profile/presentation/favorites/favorites_screen.dart';
import 'package:sirah_app/features/profile/presentation/profile/profile_screen.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

const _testName = ProphetName(
  number: 1,
  arabic: 'مُحَمَّد',
  transliteration: 'Muḥammad',
  categorySlug: 'praise',
  categoryLabel: 'Louange',
  etymology: 'Celui qui est loué',
  commentary: 'Le plus célèbre des noms.',
  references: 'Coran 3:144',
  primarySource: 'Al-Bukhārī',
  secondarySources: '',
);

const _testCategory = NameCategory(
  slug: 'praise',
  labelFr: 'Louange',
  count: 20,
);

const _testConstellation = NameConstellation(
  id: 'praise',
  titleFr: 'Constellation de la Louange',
  titleAr: 'الحمد',
  descriptionFr: 'Louange',
  nameNumbers: [1, 2],
  colorHex: '#7C6FAB',
);

const _testExperience = NameExperience(
  nameNumber: 1,
  tafakkurPromptFr: 'Prompt',
  practiceTheme: 'praise',
);

const _testActionBank = NameActionBank(
  theme: 'praise',
  actions: [
    NameActionItem(
      id: 'praise_widget_action',
      textFr: 'Remercie quelqu’un aujourd’hui.',
      editorialStatus: 'validated',
      sourceNote: 'Fixture reviewed.',
      reviewedBy: 'test-reviewer',
      validatedAt: '2026-04-30',
    ),
  ],
);

final _testJourney = JourneyRepository(
  constellations: const [_testConstellation],
  experiences: const [_testExperience],
  actionBanks: const [
    NameActionBank(
      theme: 'general',
      actions: [
        NameActionItem(
          id: 'general_widget_action',
          textFr: 'Agis avec sincérité.',
          editorialStatus: 'needs_review',
        ),
      ],
    ),
    _testActionBank,
  ],
);

Widget _wrap(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(() => _StubSettingsNotifier()),
      namesProvider.overrideWith((_) async => [_testName]),
      categoriesProvider.overrideWith((_) async => [_testCategory]),
      dailyNameProvider.overrideWith((_) async => _testName),
      journeyRepositoryProvider.overrideWith((_) async => _testJourney),
      viewedCountsProvider.overrideWithValue({}),
      ...overrides,
    ],
    child: MaterialApp(
      theme: AppTheme.build(ThemeKey.light),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: Scaffold(body: child),
    ),
  );
}

class _StubSettingsNotifier extends SettingsNotifier {
  _StubSettingsNotifier([
    this.initial = const UserState(onboardingCompletedAt: null),
  ]);

  final UserState initial;

  @override
  UserState build() => initial;

  @override
  Future<void> markViewed(int number) async {
    final viewed = Set<int>.from(state.viewed)..add(number);
    state = state.copyWith(viewed: viewed);
  }

  @override
  Future<void> markLearned(int number) async {
    final learned = Set<int>.from(state.learned)..add(number);
    state = state.copyWith(learned: learned);
  }

  @override
  Future<void> markNameMeditated(int number) async {
    final meditated = Set<int>.from(state.meditatedNames)..add(number);
    state = state.copyWith(meditatedNames: meditated);
  }

  @override
  Future<void> markNamePracticed(int number) async {
    final practiced = Set<int>.from(state.practicedNames)..add(number);
    state = state.copyWith(practicedNames: practiced);
  }

  @override
  Future<void> toggleFavorite(int number) async {
    final favs = Set<int>.from(state.favorites);
    if (favs.contains(number)) {
      favs.remove(number);
    } else {
      favs.add(number);
    }
    state = state.copyWith(favorites: favs);
  }
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('Progress providers', () {
    test(
      'viewedCountsProvider compte les noms découverts par catégorie',
      () async {
        final container = ProviderContainer(
          overrides: [
            settingsProvider.overrideWith(
              () => _StubSettingsNotifier(const UserState(viewed: {1})),
            ),
            namesProvider.overrideWith((_) async => [_testName]),
          ],
        );
        addTearDown(container.dispose);

        await container.read(namesProvider.future);
        final counts = container.read(viewedCountsProvider);

        expect(counts, {'praise': 1});
      },
    );
  });

  group('OnboardingScreen', () {
    testWidgets('affiche la page de bienvenue', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(() => _StubSettingsNotifier()),
          ],
          child: MaterialApp(
            theme: AppTheme.build(ThemeKey.light),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('fr'),
            home: const OnboardingScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Commencer'), findsOneWidget);
    });
  });

  group('HomeScreen', () {
    testWidgets('affiche le chargement puis le nom du jour', (tester) async {
      await tester.pumpWidget(_wrap(const HomeScreen()));
      await tester.pump(); // résolution des futures
      await tester.pump(
        const Duration(milliseconds: 500),
      ); // fin des animations
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Découvrir ce nom'), findsOneWidget);
      expect(find.text('Remercie quelqu’un aujourd’hui.'), findsOneWidget);
      expect(find.text('Je l’ai vécue'), findsNothing);
      expect(find.text('Continuer mon voyage'), findsNothing);
      expect(find.text('Voyage'), findsNothing);
      expect(find.text('Bibliothèque'), findsNothing);
      expect(
        find.text('0 découverts · 0 contemplés · 0 reconnus'),
        findsOneWidget,
      );
      expect(find.text('Explorer par catégorie'), findsNothing);
    });
  });

  group('ListScreen', () {
    testWidgets('affiche la barre de recherche', (tester) async {
      await tester.pumpWidget(_wrap(const ListScreen()));
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('filtre les noms par requête', (tester) async {
      await tester.pumpWidget(_wrap(const ListScreen()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Muḥammad');
      await tester.pump();
      // Au moins un résultat visible
      expect(find.text('Muḥammad'), findsWidgets);
    });
  });

  group('DetailScreen', () {
    testWidgets('affiche le texte arabe du nom', (tester) async {
      await tester.pumpWidget(
        _wrap(DetailScreen(initialNumber: _testName.number)),
      );
      await tester.pumpAndSettle();
      expect(find.text(_testName.arabic), findsWidgets);
    });

    testWidgets('marque le nom vu sans apprentissage automatique', (
      tester,
    ) async {
      late _StubSettingsNotifier notifier;

      await tester.pumpWidget(
        _wrap(
          DetailScreen(initialNumber: _testName.number),
          overrides: [
            settingsProvider.overrideWith(() {
              notifier = _StubSettingsNotifier();
              return notifier;
            }),
          ],
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 9));

      expect(notifier.state.viewed, contains(_testName.number));
      expect(notifier.state.learned, isNot(contains(_testName.number)));
    });
  });

  group('ProfileScreen', () {
    testWidgets('affiche une synthese Journey V2', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ProfileScreen(),
          overrides: [
            settingsProvider.overrideWith(
              () => _StubSettingsNotifier(
                UserState(
                  viewed: {1},
                  meditatedNames: {1},
                  practicedNames: {1},
                  recognizedNames: {1},
                  learned: {1},
                  lastSeen: {1: DateTime.now()},
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1/1 étoiles découvertes'), findsOneWidget);
      expect(find.text('découvertes'), findsOneWidget);
      expect(find.text('contemplées'), findsOneWidget);
      expect(find.text('vécues'), findsOneWidget);
      expect(find.text('reconnues'), findsOneWidget);
      expect(find.textContaining('Rituel quotidien'), findsOneWidget);
    });
  });

  group('FavoritesScreen', () {
    testWidgets('affiche le message vide quand aucun favori', (tester) async {
      await tester.pumpWidget(_wrap(const FavoritesScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Aucun favori pour l\'instant'), findsOneWidget);
    });
  });
}
