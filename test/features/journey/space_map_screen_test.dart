import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/presentation/map/constellation_space_map_screen.dart';
import 'package:sirah_app/features/journey/presentation/map/deck_space_map_screen.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _name1 = ProphetName(
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
);

const _name2 = ProphetName(
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
);

const _constellation = NameConstellation(
  id: 'praise',
  titleFr: 'Constellation de la Louange',
  titleAr: 'الحمد',
  descriptionFr: 'Les noms de la louange.',
  nameNumbers: [1, 2],
  colorHex: '#7C6FAB',
);

const _layout = JourneyMapLayout(
  deckId: 'prophet_names',
  galaxy: MapNode(x: 0.5, y: 0.45, radius: 0.22),
  constellations: [
    ConstellationMapNode(id: 'praise', x: 0.5, y: 0.45, radius: 0.14),
  ],
  stars: {
    'praise': [
      StarMapNode(number: 1, x: 0.35, y: 0.4, size: 1.2),
      StarMapNode(number: 2, x: 0.62, y: 0.56, size: 1.0),
    ],
  },
);

final _journey = JourneyRepository(
  constellations: const [_constellation],
  experiences: const [],
  actionBanks: const [
    NameActionBank(
      theme: 'general',
      actions: [
        NameActionItem(
          id: 'general_space_map_action',
          textFr: 'Agis.',
          editorialStatus: 'needs_review',
        ),
      ],
    ),
  ],
);

Widget _wrap(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => child),
      GoRoute(
        path: '/journey/deck/prophet_names/constellation/:id',
        builder: (_, state) => ConstellationSpaceMapScreen(
          deckId: 'prophet_names',
          constellationId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/name/:number/experience',
        builder: (_, state) => Text('name:${state.pathParameters['number']}'),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(() => _StubSettingsNotifier()),
      journeyRepositoryProvider.overrideWith((_) async => _journey),
      journeyMapLayoutProvider.overrideWith((_) async => _layout),
      namesProvider.overrideWith((_) async => [_name1, _name2]),
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

class _StubSettingsNotifier extends SettingsNotifier {
  @override
  UserState build() => const UserState(viewed: {1});
}

void main() {
  testWidgets('DeckSpaceMapScreen renders constellation map', (tester) async {
    await tester.pumpWidget(
      _wrap(const DeckSpaceMapScreen(deckId: 'prophet_names')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Constellation de la Louange'), findsOneWidget);
    expect(find.byTooltip('Zoomer'), findsOneWidget);
    expect(find.byTooltip('Dézoomer'), findsOneWidget);
    expect(find.byTooltip('Recentrer la carte'), findsOneWidget);
    expect(
      find.text('Touchez une constellation pour voir ses étoiles.'),
      findsOneWidget,
    );
  });

  testWidgets('DeckSpaceMapScreen rejects a deck without matching layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const DeckSpaceMapScreen(deckId: 'asmaul_husna')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Constellation introuvable'), findsOneWidget);
  });

  testWidgets('ConstellationSpaceMapScreen opens star name experience', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const ConstellationSpaceMapScreen(
          deckId: 'prophet_names',
          constellationId: 'praise',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Muhammad'), findsOneWidget);
    expect(find.bySemanticsLabel('Ahmad'), findsOneWidget);
    expect(find.text('Vue'), findsOneWidget);
    expect(find.text('Ahmad'), findsNothing);

    await tester.tap(find.bySemanticsLabel('Ahmad'));
    await tester.pumpAndSettle();

    expect(find.text('Ahmad'), findsOneWidget);
    expect(find.text('À explorer'), findsOneWidget);

    await tester.tap(find.text('Voir la fiche'));
    await tester.pumpAndSettle();

    expect(find.text('name:2'), findsOneWidget);
  });

  testWidgets('ConstellationSpaceMapScreen rejects mismatched deck layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const ConstellationSpaceMapScreen(
          deckId: 'asmaul_husna',
          constellationId: 'praise',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Constellation introuvable'), findsOneWidget);
  });
}
