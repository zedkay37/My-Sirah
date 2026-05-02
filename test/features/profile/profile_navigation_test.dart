import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/profile/presentation/profile/profile_screen.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _name = ProphetName(
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

class _StubSettingsNotifier extends SettingsNotifier {
  @override
  UserState build() => const UserState(viewed: {1});
}

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/profile',
    routes: [
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const Text('settings')),
      GoRoute(path: '/favorites', builder: (_, __) => const Text('favorites')),
    ],
  );

  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(_StubSettingsNotifier.new),
      namesProvider.overrideWith((_) async => [_name]),
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
  testWidgets('Profile settings shortcut remains accessible', (tester) async {
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_wrap());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.byKey(const ValueKey('profile-lantern')), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('settings'), findsOneWidget);
  });
}
