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
import 'package:sirah_app/features/names/presentation/tafakkur/tafakkur_screen.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _name = ProphetName(
  number: 1,
  arabic: 'محمد',
  transliteration: 'Muhammad',
  categorySlug: 'praise',
  categoryLabel: 'Louange',
  etymology: 'Celui qui est loué maintes fois',
  commentary: 'Commentaire classique.',
  references: 'Coran 3:144',
  primarySource: 'Al-Bukhari',
  secondarySources: '',
);

const _experience = NameExperience(
  nameNumber: 1,
  stories: [
    NameStory(
      id: 'story',
      titleFr: 'La confiance avant la révélation',
      bodyFr: 'Un récit contemplatif court.',
      sourceNote: 'Source éditoriale.',
      editorialStatus: 'validated',
    ),
  ],
  tafakkurPromptFr: 'Que puis-je méditer aujourd’hui ?',
  practiceTheme: 'trust',
);

const _actions = NameActionBank(
  theme: 'trust',
  actions: [
    NameActionItem(
      id: 'trust_tafakkur_action',
      textFr: 'Tiens une promesse simple.',
      editorialStatus: 'validated',
      sourceNote: 'Fixture reviewed.',
      reviewedBy: 'test-reviewer',
      validatedAt: '2026-04-30',
    ),
  ],
);

Widget _wrap({
  required JourneyRepository journey,
  _StubSettingsNotifier? settings,
}) {
  return ProviderScope(
    overrides: [
      if (settings != null) settingsProvider.overrideWith(() => settings),
      namesProvider.overrideWith((_) async => [_name]),
      journeyRepositoryProvider.overrideWith((_) async => journey),
    ],
    child: MaterialApp(
      theme: AppTheme.build(ThemeKey.light),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: const TafakkurScreen(nameNumber: 1),
    ),
  );
}

class _StubSettingsNotifier extends SettingsNotifier {
  @override
  UserState build() => const UserState();

  @override
  Future<void> markNameMeditated(int number) async {
    final meditated = Set<int>.from(state.meditatedNames)..add(number);
    state = state.copyWith(meditatedNames: meditated);
  }
}

void main() {
  testWidgets('TafakkurScreen renders mini-book pages from journey data', (
    tester,
  ) async {
    final journey = JourneyRepository(
      constellations: const [],
      experiences: const [_experience],
      actionBanks: const [_actions],
    );

    await tester.pumpWidget(_wrap(journey: journey));
    await tester.pump();

    expect(find.text('Le nom'), findsOneWidget);
    expect(find.textContaining('Muhammad'), findsOneWidget);
    expect(find.text('Glissez pour avancer ou revenir'), findsOneWidget);
    expect(find.text('~1 min'), findsOneWidget);
    expect(find.byTooltip('Page suivante'), findsOneWidget);

    await tester.fling(
      find.byType(GestureDetector).last,
      const Offset(-500, 0),
      1000,
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Le récit'), findsOneWidget);
    expect(
      find.textContaining('La confiance avant la révélation'),
      findsOneWidget,
    );
  });

  testWidgets('TafakkurScreen falls back to classic commentary', (
    tester,
  ) async {
    final journey = JourneyRepository(
      constellations: const [],
      experiences: const [],
      actionBanks: const [
        NameActionBank(
          theme: 'general',
          actions: [
            NameActionItem(
              id: 'general_tafakkur_action',
              textFr: 'Agis avec sincérité.',
              editorialStatus: 'needs_review',
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(_wrap(journey: journey));
    await tester.pump();
    await tester.fling(
      find.byType(GestureDetector).last,
      const Offset(-500, 0),
      1000,
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Le récit'), findsOneWidget);
    expect(find.textContaining('Commentaire classique.'), findsOneWidget);
  });

  testWidgets('TafakkurScreen supports explicit page controls', (tester) async {
    final journey = JourneyRepository(
      constellations: const [],
      experiences: const [_experience],
      actionBanks: const [_actions],
    );

    await tester.pumpWidget(_wrap(journey: journey));
    await tester.pump();

    final previousButton = find.widgetWithIcon(
      IconButton,
      Icons.chevron_left_rounded,
    );

    expect(find.text('Le nom'), findsOneWidget);
    expect(tester.widget<IconButton>(previousButton).onPressed, isNull);

    await tester.tap(find.byTooltip('Page suivante'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Le récit'), findsOneWidget);
    expect(tester.widget<IconButton>(previousButton).onPressed, isNotNull);

    await tester.tap(find.byTooltip('Page précédente'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Le nom'), findsOneWidget);
  });

  testWidgets('TafakkurScreen marks the name meditated on completion', (
    tester,
  ) async {
    final journey = JourneyRepository(
      constellations: const [],
      experiences: const [_experience],
      actionBanks: const [_actions],
    );
    final settings = _StubSettingsNotifier();

    await tester.pumpWidget(_wrap(journey: journey, settings: settings));
    await tester.pump();

    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byTooltip('Page suivante'));
      await tester.pump(const Duration(milliseconds: 500));
    }

    expect(find.text('Contemplation terminée'), findsOneWidget);
    expect(settings.state.meditatedNames, contains(1));
    expect(settings.state.recognizedNames, isNot(contains(1)));
  });
}
