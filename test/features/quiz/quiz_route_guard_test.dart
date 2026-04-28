import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/quiz/presentation/flashcards/flashcards_screen.dart';
import 'package:sirah_app/features/quiz/presentation/qcm/qcm_screen.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

Widget _wrap(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => child),
      GoRoute(
        path: '/library/deck/prophet_names',
        builder: (_, __) => const Text('library-deck'),
      ),
    ],
  );

  return ProviderScope(
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
  testWidgets('QcmScreen does not crash when opened without a session', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const QcmScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Quiz rapide'), findsOneWidget);
    expect(find.text('Bibliothèque'), findsOneWidget);

    await tester.tap(find.text('Bibliothèque'));
    await tester.pumpAndSettle();

    expect(find.text('library-deck'), findsOneWidget);
  });

  testWidgets('FlashcardsScreen does not crash when opened without a session', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const FlashcardsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Flashcards'), findsOneWidget);
    expect(find.text('Bibliothèque'), findsOneWidget);

    await tester.tap(find.text('Bibliothèque'));
    await tester.pumpAndSettle();

    expect(find.text('library-deck'), findsOneWidget);
  });
}
