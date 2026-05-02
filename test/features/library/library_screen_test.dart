import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/library/presentation/library_screen.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/library',
    routes: [
      GoRoute(path: '/library', builder: (_, __) => const LibraryScreen()),
      GoRoute(
        path: '/library/deck/:deckId',
        builder: (_, __) => const SizedBox(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [settingsProvider.overrideWith(() => _StubSettingsNotifier())],
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
  UserState build() =>
      const UserState(recognizedNames: {1, 2}, husnaLearned: {1});
}

void main() {
  testWidgets('LibraryScreen renders corpus decks without duplicate tools', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('Bibliothèque'), findsOneWidget);
    expect(find.text('Noms du Prophète ﷺ'), findsOneWidget);
    expect(find.text('Asmāʾ al-Ḥusnā'), findsOneWidget);
    expect(find.text('2/201 reconnus'), findsOneWidget);
    expect(find.text('Outils d’apprentissage'), findsNothing);
    expect(find.text('QCM'), findsNothing);
    expect(find.text('Flashcards'), findsNothing);
  });
}
