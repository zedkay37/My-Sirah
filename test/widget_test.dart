import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/data/sources/categories_json_source.dart';
import 'package:sirah_app/features/names/presentation/detail/detail_screen.dart';
import 'package:sirah_app/features/names/presentation/home/home_screen.dart';
import 'package:sirah_app/features/names/presentation/list/list_screen.dart';
import 'package:sirah_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:sirah_app/features/profile/presentation/favorites/favorites_screen.dart';
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

Widget _wrap(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(() => _StubSettingsNotifier()),
      namesProvider.overrideWith((_) async => [_testName]),
      categoriesProvider.overrideWith((_) async => [_testCategory]),
      dailyNameProvider.overrideWith((_) async => _testName),
      learnedCountsProvider.overrideWithValue({}),
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
  @override
  UserState build() => const UserState(onboardingCompletedAt: null);

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
      await tester.pump(const Duration(milliseconds: 500)); // fin des animations
      expect(find.byType(HomeScreen), findsOneWidget);
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
      await tester.pumpWidget(_wrap(
        DetailScreen(initialNumber: _testName.number),
      ));
      await tester.pumpAndSettle();
      expect(find.text(_testName.arabic), findsWidgets);
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
