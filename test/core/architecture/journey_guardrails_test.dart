import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('primary prophetic name cards do not use legacy learned state', () {
    final checkedFiles = [
      File('lib/features/shared/name_card.dart'),
      File('lib/features/names/presentation/list/list_screen.dart'),
      File('lib/features/profile/presentation/favorites/favorites_screen.dart'),
    ];

    for (final file in checkedFiles) {
      final source = file.readAsStringSync();

      expect(
        source,
        isNot(contains('isLearned')),
        reason: '${file.path} should use JourneyNameStage instead of learned.',
      );
      expect(
        source,
        isNot(contains('s.learned')),
        reason:
            '${file.path} should not read legacy learned state for Journey UI.',
      );
    }
  });

  test('primary list and favorites taps open name experience', () {
    final primarySurfaces = [
      File('lib/features/names/presentation/list/list_screen.dart'),
      File('lib/features/profile/presentation/favorites/favorites_screen.dart'),
    ];

    for (final file in primarySurfaces) {
      final source = file.readAsStringSync();

      expect(
        source,
        contains('/name/\${name.number}/experience'),
        reason: '${file.path} should route primary name taps to Nom vivant.',
      );
      expect(
        source,
        isNot(contains("context.push('/name/\${name.number}')")),
        reason: '${file.path} should not route primary taps to V1 detail.',
      );
    }
  });
}
