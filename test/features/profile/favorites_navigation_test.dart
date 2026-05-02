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
import 'package:sirah_app/features/profile/presentation/favorites/favorites_screen.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _name = ProphetName(
  number: 1,
  arabic: 'محمد',
  transliteration: 'Muhammad',
  categorySlug: 'praise',
  categoryLabel: 'Louange',
  etymology: 'Loué',
  commentary: 'Commentaire',
  references: '',
  primarySource: '',
  secondarySources: '',
);

class _StubSettingsNotifier extends SettingsNotifier {
  @override
  UserState build() => const UserState(favorites: {1});
}

Widget _wrap(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => child),
      GoRoute(
        path: '/name/:number/experience',
        builder: (_, state) =>
            Text('experience:${state.pathParameters['number']}'),
      ),
      GoRoute(
        path: '/library/deck/prophet_names',
        builder: (_, __) => const SizedBox(),
      ),
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
  testWidgets('FavoritesScreen opens name experience from primary tap', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const FavoritesScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Muhammad'));
    await tester.pumpAndSettle();

    expect(find.text('experience:1'), findsOneWidget);
  });
}
