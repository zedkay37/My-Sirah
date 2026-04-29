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
import 'package:sirah_app/features/journey/presentation/name_experience_screen.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _name = ProphetName(
  number: 1,
  arabic: 'مُحَمَّد',
  transliteration: 'Muḥammad',
  categorySlug: 'praise',
  categoryLabel: 'Louange',
  etymology: 'Celui qui est loué maintes fois',
  commentary: 'Le plus célèbre des noms.',
  references: 'Coran 3:144',
  primarySource: 'Al-Bukhārī',
  secondarySources: '',
);

const _constellation = NameConstellation(
  id: 'praise',
  titleFr: 'Constellation de la Louange',
  titleAr: 'الحمد',
  descriptionFr: 'Louange',
  nameNumbers: [1],
  colorHex: '#7C6FAB',
);

const _experience = NameExperience(
  nameNumber: 1,
  stories: [
    NameStory(
      id: 'story',
      titleFr: 'Un nom porté par la louange',
      bodyFr: 'Un récit court.',
      sourceNote: 'Source éditoriale.',
      sourceRefs: ['Coran 3:144'],
      editorialStatus: 'validated',
      reviewedBy: 'editor',
    ),
  ],
  tafakkurPromptFr: 'Quelle louange sincère puis-je vivre ?',
  practiceTheme: 'praise',
);

const _actions = NameActionBank(
  theme: 'praise',
  actions: [
    NameActionItem(
      id: 'praise_experience_action',
      textFr: 'Remercie quelqu’un aujourd’hui.',
      editorialStatus: 'validated',
    ),
  ],
);

Widget _wrap(
  Widget child, {
  required JourneyRepository journey,
  required _StubSettingsNotifier settings,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => child),
      GoRoute(path: '/name/:number', builder: (_, __) => const SizedBox()),
      GoRoute(
        path: '/name/:number/tafakkur',
        builder: (_, __) => const SizedBox(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(() => settings),
      namesProvider.overrideWith((_) async => [_name]),
      journeyRepositoryProvider.overrideWith((_) async => journey),
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
  UserState build() => const UserState();

  @override
  Future<void> markViewed(int number) async {
    final viewed = Set<int>.from(state.viewed)..add(number);
    state = state.copyWith(viewed: viewed);
  }

  @override
  Future<void> markNamePracticed(int number) async {
    final practiced = Set<int>.from(state.practicedNames)..add(number);
    state = state.copyWith(practicedNames: practiced);
  }
}

void main() {
  testWidgets('NameExperienceScreen renders journey content', (tester) async {
    final journey = JourneyRepository(
      constellations: const [_constellation],
      experiences: const [_experience],
      actionBanks: const [_actions],
    );
    final settings = _StubSettingsNotifier();

    await tester.pumpWidget(
      _wrap(
        const NameExperienceScreen(nameNumber: 1),
        journey: journey,
        settings: settings,
      ),
    );
    await tester.pumpAndSettle();

    expect(settings.state.viewed, contains(1));
    expect(settings.state.recognizedNames, isNot(contains(1)));

    expect(find.text('Nom vivant'), findsOneWidget);
    expect(find.text('Muḥammad'), findsOneWidget);
    expect(find.text('Constellation de la Louange'), findsOneWidget);
    expect(find.text('RÉCIT'), findsOneWidget);
    expect(find.text('Un nom porté par la louange'), findsOneWidget);
    expect(find.text('Coran 3:144'), findsWidgets);
    expect(find.text('Quelle louange sincère puis-je vivre ?'), findsOneWidget);
    expect(find.text('Remercie quelqu’un aujourd’hui.'), findsOneWidget);
    expect(find.text('Je l’ai vécue'), findsOneWidget);
    expect(find.text('Entrer en tafakkur'), findsOneWidget);

    await tester.ensureVisible(find.text('Je l’ai vécue'));
    await tester.tap(find.text('Je l’ai vécue'));
    await tester.pump();

    expect(find.text('Action vécue'), findsOneWidget);
    expect(settings.state.practicedNames, contains(1));
    expect(settings.state.recognizedNames, isNot(contains(1)));
  });

  testWidgets('NameExperienceScreen renders fallback without experience', (
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
              id: 'general_experience_action',
              textFr: 'Agis.',
              editorialStatus: 'needs_review',
            ),
          ],
        ),
      ],
    );
    final settings = _StubSettingsNotifier();

    await tester.pumpWidget(
      _wrap(
        const NameExperienceScreen(nameNumber: 1),
        journey: journey,
        settings: settings,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Muḥammad'), findsOneWidget);
    expect(find.text('COMPRENDRE CE NOM'), findsOneWidget);
    expect(find.text('Le plus célèbre des noms.'), findsOneWidget);
    expect(find.text('Coran 3:144'), findsOneWidget);
    expect(find.text('Agis.'), findsNothing);
    expect(find.text('Action du jour'), findsNothing);
    expect(find.text('Aucun récit dédié'), findsNothing);
    expect(find.textContaining('placeholder'), findsNothing);
    expect(find.text('Entrer en tafakkur'), findsOneWidget);
  });

  testWidgets(
    'NameExperienceScreen does not present unvalidated story as story',
    (tester) async {
      const unvalidatedExperience = NameExperience(
        nameNumber: 1,
        stories: [
          NameStory(
            id: 'draft-story',
            titleFr: 'Titre brouillon',
            bodyFr: 'Texte brouillon.',
            sourceNote: 'Synthèse éditoriale à revoir.',
          ),
        ],
        tafakkurPromptFr: 'Quelle louange sincère puis-je vivre ?',
        practiceTheme: 'praise',
      );
      final journey = JourneyRepository(
        constellations: const [_constellation],
        experiences: const [unvalidatedExperience],
        actionBanks: const [_actions],
      );
      final settings = _StubSettingsNotifier();

      await tester.pumpWidget(
        _wrap(
          const NameExperienceScreen(nameNumber: 1),
          journey: journey,
          settings: settings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('COMPRENDRE CE NOM'), findsOneWidget);
      expect(find.text('Titre brouillon'), findsNothing);
      expect(find.text('Texte brouillon.'), findsNothing);
      expect(find.text('Le plus célèbre des noms.'), findsOneWidget);
    },
  );
}
