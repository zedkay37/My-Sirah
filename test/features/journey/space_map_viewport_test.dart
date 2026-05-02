import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/journey/presentation/map/widgets/space_map_viewport.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _viewportKey = Key('viewport');
const _mapKey = Key('map-child');

Widget _wrapViewport({double initialScale = 1, double minScale = 0.3}) {
  return MaterialApp(
    theme: AppTheme.build(ThemeKey.dark),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('fr'),
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          key: _viewportKey,
          width: 400,
          height: 400,
          child: SpaceMapViewport(
            mapSize: const Size(800, 800),
            initialScale: initialScale,
            minScale: minScale,
            maxScale: 2.4,
            viewportEdgeFade: 0,
            child: const SizedBox.expand(
              key: _mapKey,
              child: ColoredBox(color: Color(0xFF123456)),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _pinchTowardCenter(WidgetTester tester) async {
  final center = tester.getRect(find.byKey(_viewportKey)).center;
  final first = await tester.createGesture(pointer: 1);
  final second = await tester.createGesture(pointer: 2);

  await first.down(center + const Offset(-90, 0));
  await second.down(center + const Offset(90, 0));
  await tester.pump();

  await first.moveTo(center + const Offset(-15, 0));
  await second.moveTo(center + const Offset(15, 0));
  await tester.pump();

  await first.up();
  await second.up();
  await tester.pumpAndSettle();
}

void _expectMapCentered(WidgetTester tester) {
  final viewportCenter = tester.getRect(find.byKey(_viewportKey)).center;
  final mapCenter = tester.getCenter(find.byKey(_mapKey));

  expect(mapCenter.dx, closeTo(viewportCenter.dx, 1));
  expect(mapCenter.dy, closeTo(viewportCenter.dy, 1));
}

void main() {
  testWidgets('pinch zooming out settles around the viewport center', (
    tester,
  ) async {
    await tester.pumpWidget(_wrapViewport());
    await tester.pumpAndSettle();

    await _pinchTowardCenter(tester);

    _expectMapCentered(tester);
  });

  testWidgets('zoom-out control keeps the map centered at minimum scale', (
    tester,
  ) async {
    await tester.pumpWidget(_wrapViewport());
    await tester.pumpAndSettle();

    for (var i = 0; i < 8; i++) {
      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pumpAndSettle();
    }

    _expectMapCentered(tester);
  });
}
