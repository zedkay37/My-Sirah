import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/husna_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/asmaul_husna/data/models/husna_name.dart';
import 'package:sirah_app/features/asmaul_husna/presentation/list/husna_list_screen.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _rahman = HusnaName(
  id: 1,
  arabic: 'الرحمن',
  transliteration: 'Ar-Rahman',
  meaningFr: 'Le Tout Miséricordieux',
);

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/library/deck/asmaul_husna',
    routes: [
      GoRoute(
        path: '/library/deck/asmaul_husna',
        builder: (_, __) => const HusnaListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) => Text('husna:${state.pathParameters['id']}'),
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(() => _StubSettingsNotifier()),
      husnaProvider.overrideWith((_) async => [_rahman]),
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
  UserState build() => const UserState(onboardingCompletedAt: null);
}

void main() {
  testWidgets('Husna list opens detail through Library route', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('Ar-Rahman'), findsOneWidget);

    await tester.tap(find.text('Ar-Rahman'));
    await tester.pumpAndSettle();

    expect(find.text('husna:1'), findsOneWidget);
  });
}
