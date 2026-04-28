import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/router/app_router.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

class _StubSettingsNotifier extends SettingsNotifier {
  @override
  UserState build() => UserState(onboardingCompletedAt: DateTime(2026));
}

void main() {
  testWidgets('/discover redirects to /library', (tester) async {
    late GoRouter router;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsProvider.overrideWith(_StubSettingsNotifier.new)],
        child: Consumer(
          builder: (context, ref, _) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              theme: AppTheme.build(ThemeKey.light),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
              routerConfig: router,
            );
          },
        ),
      ),
    );
    await tester.pump();

    router.go('/discover');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Bibliothèque'), findsWidgets);
    expect(router.routerDelegate.currentConfiguration.uri.path, '/library');
  });
}
