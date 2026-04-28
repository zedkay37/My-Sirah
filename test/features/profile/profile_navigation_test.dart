import 'dart:math' as math;

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
      GoRoute(
        path: '/name/:number/experience',
        builder: (_, state) =>
            Text('experience:${state.pathParameters['number']}'),
      ),
      GoRoute(path: '/settings', builder: (_, __) => const SizedBox()),
      GoRoute(path: '/favorites', builder: (_, __) => const SizedBox()),
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
  testWidgets('Profile constellation star opens name experience', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    final constellationPaint = find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString().contains(
            '_ConstellationPainter',
          ),
    );
    expect(constellationPaint, findsOneWidget);

    final topLeft = tester.getTopLeft(constellationPaint);
    final size = tester.getSize(constellationPaint);
    final star = Offset(
      size.width / 2 + math.sqrt(0.5) * 0.45 * size.width,
      size.height / 2,
    );

    await tester.tapAt(topLeft + star);
    await tester.pumpAndSettle();

    expect(find.text('experience:1'), findsOneWidget);
  });
}
