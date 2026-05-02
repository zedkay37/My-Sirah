import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/husna_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/asmaul_husna/data/models/husna_name.dart';
import 'package:sirah_app/features/library/presentation/library_deck_screen.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/data/sources/categories_json_source.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _names = [
  ProphetName(
    number: 1,
    arabic: 'محمد',
    transliteration: 'Muhammad',
    categorySlug: 'praise',
    categoryLabel: 'Louange',
    etymology: '',
    commentary: '',
    references: '',
    primarySource: '',
    secondarySources: '',
  ),
  ProphetName(
    number: 2,
    arabic: 'أحمد',
    transliteration: 'Ahmad',
    categorySlug: 'praise',
    categoryLabel: 'Louange',
    etymology: '',
    commentary: '',
    references: '',
    primarySource: '',
    secondarySources: '',
  ),
];

const _husnaNames = [
  HusnaName(
    id: 1,
    arabic: 'الله',
    transliteration: 'Allah',
    meaningFr: 'Le Nom propre de Dieu',
  ),
  HusnaName(
    id: 2,
    arabic: 'الرحمن',
    transliteration: 'Ar-Rahman',
    meaningFr: 'Le Tout Misericordieux',
  ),
  HusnaName(
    id: 3,
    arabic: 'الرحيم',
    transliteration: 'Ar-Rahim',
    meaningFr: 'Le Tres Misericordieux',
  ),
  HusnaName(
    id: 4,
    arabic: 'الملك',
    transliteration: 'Al-Malik',
    meaningFr: 'Le Souverain',
  ),
  HusnaName(
    id: 5,
    arabic: 'القدوس',
    transliteration: 'Al-Quddus',
    meaningFr: 'Le Tres Saint',
  ),
];

class _StubSettingsNotifier extends SettingsNotifier {
  @override
  UserState build() => const UserState();
}

Widget _wrap({String initialLocation = '/library/deck/prophet_names'}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/library/deck/:deckId',
        builder: (_, state) => LibraryDeckScreen(
          deckId: state.pathParameters['deckId'] ?? 'prophet_names',
        ),
      ),
      GoRoute(
        path: '/name/:number/experience',
        builder: (_, state) =>
            Text('experience:${state.pathParameters['number']}'),
      ),
      GoRoute(
        path: '/library/deck/asmaul_husna/:id',
        builder: (_, state) => Text('husna:${state.pathParameters['id']}'),
      ),
      GoRoute(path: '/quiz/qcm', builder: (_, __) => const Text('qcm')),
      GoRoute(
        path: '/quiz/flashcards',
        builder: (_, __) => const Text('flashcards'),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(_StubSettingsNotifier.new),
      namesProvider.overrideWith((_) async => _names),
      husnaProvider.overrideWith((_) async => _husnaNames),
      categoriesProvider.overrideWith(
        (_) async => const [
          NameCategory(slug: 'praise', labelFr: 'Louange', count: 2),
        ],
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.build(ThemeKey.light),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('Prophet names deck keeps practice tools inside the deck', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('Tous les noms'), findsOneWidget);
    expect(find.textContaining('entra'), findsOneWidget);
    expect(find.text('QCM'), findsNothing);

    await tester.tap(find.textContaining('entra'));
    await tester.pumpAndSettle();

    expect(find.text('QCM'), findsOneWidget);
    expect(find.text('Flashcards'), findsOneWidget);
  });

  testWidgets('Husna deck exposes practice tools inside the deck', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(initialLocation: '/library/deck/asmaul_husna'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Asmāʾ al-Ḥusnā'), findsOneWidget);
    expect(find.text('Tous les noms'), findsOneWidget);
    expect(find.textContaining('entra'), findsOneWidget);
    expect(find.text('QCM'), findsNothing);

    await tester.tap(find.textContaining('entra'));
    await tester.pumpAndSettle();

    expect(find.text('S’entraîner avec les Noms d’Allah'), findsOneWidget);
    expect(find.text('QCM'), findsOneWidget);
    expect(find.text('Flashcards'), findsOneWidget);
  });
}
