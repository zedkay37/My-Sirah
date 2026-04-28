import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/presentation/map/galaxy_map_screen.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _prophetDeck = JourneyDeck(
  id: 'prophet_names',
  titleFr: 'Noms du Prophete',
  subtitleFr: '201 etoiles pour connaitre et aimer le Prophete',
  itemType: 'prophet_name',
  totalItems: 201,
  status: 'active',
);

const _husnaDeck = JourneyDeck(
  id: 'asmaul_husna',
  titleFr: 'Asma al-Husna',
  subtitleFr: '99 noms',
  itemType: 'husna_name',
  totalItems: 99,
  status: 'library_only',
);

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/journey',
    routes: [
      GoRoute(path: '/journey', builder: (_, __) => const GalaxyMapScreen()),
      GoRoute(
        path: '/journey/deck/:deckId',
        builder: (_, state) => Text('deck:${state.pathParameters['deckId']}'),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      journeyDecksProvider.overrideWith(
        (_) async => [_prophetDeck, _husnaDeck],
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
  testWidgets('GalaxyMapScreen renders active galaxy only and opens deck', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('Voyage'), findsOneWidget);
    expect(find.text('Noms du Prophete'), findsOneWidget);
    expect(find.text('Asma al-Husna'), findsNothing);
    expect(
      find.text('Touchez la galaxie active pour entrer dans le voyage.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Noms du Prophete'));
    await tester.pumpAndSettle();

    expect(find.text('deck:prophet_names'), findsOneWidget);
  });
}
