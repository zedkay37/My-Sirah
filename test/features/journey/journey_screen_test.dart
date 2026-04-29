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
import 'package:sirah_app/features/journey/presentation/constellation_detail_screen.dart';
import 'package:sirah_app/features/journey/presentation/journey_screen.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _name1 = ProphetName(
  number: 1,
  arabic: 'Ù…Ø­Ù…Ø¯',
  transliteration: 'Muhammad',
  categorySlug: 'praise',
  categoryLabel: 'Louange',
  etymology: 'Loue',
  commentary: 'Commentaire',
  references: '',
  primarySource: '',
  secondarySources: '',
);

const _name2 = ProphetName(
  number: 2,
  arabic: 'Ø£Ø­Ù…Ø¯',
  transliteration: 'Ahmad',
  categorySlug: 'praise',
  categoryLabel: 'Louange',
  etymology: 'Celui qui loue',
  commentary: 'Commentaire',
  references: '',
  primarySource: '',
  secondarySources: '',
);

const _constellation = NameConstellation(
  id: 'praise',
  titleFr: 'Constellation de la Louange',
  titleAr: 'Ø§Ù„Ø­Ù…Ø¯',
  descriptionFr: 'Les noms de la louange.',
  nameNumbers: [1, 2],
  colorHex: '#7C6FAB',
);

final _journey = JourneyRepository(
  constellations: const [_constellation],
  experiences: const [],
  actionBanks: const [
    NameActionBank(theme: 'general', actions: ['Agis.']),
  ],
);

Widget _wrap(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => child),
      GoRoute(
        path: '/journey/constellation/:id',
        builder: (_, state) => ConstellationDetailScreen(
          constellationId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/name/:number/experience',
        builder: (_, __) => const SizedBox(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(() => _StubSettingsNotifier()),
      namesProvider.overrideWith((_) async => [_name1, _name2]),
      journeyRepositoryProvider.overrideWith((_) async => _journey),
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
  UserState build() => const UserState(
    viewed: {1, 2},
    meditatedNames: {1},
    practicedNames: {1},
    recognizedNames: {1},
  );
}

void main() {
  testWidgets('JourneyScreen renders constellation stage progress', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const JourneyScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Voyage'), findsOneWidget);
    expect(find.text('Constellation de la Louange'), findsOneWidget);
    expect(
      find.text('2 découvertes · 1 contemplées · 1 vécues · 1 reconnues / 2'),
      findsOneWidget,
    );
  });

  testWidgets('ConstellationDetailScreen renders names with stage labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const ConstellationDetailScreen(constellationId: 'praise')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Constellation de la Louange'), findsOneWidget);
    expect(find.text('Muhammad'), findsOneWidget);
    expect(find.text('Ahmad'), findsOneWidget);
    expect(find.text('Reconnue'), findsOneWidget);
    expect(find.text('Vue'), findsOneWidget);
  });
}
