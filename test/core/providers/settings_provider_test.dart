import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/storage/hive_source.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sirah_settings_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<String>('settings');
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
    'markViewed refreshes lastSeen even when the name was already viewed',
    () async {
      final previous = DateTime.utc(2026, 4, 27, 8);
      await HiveSource.write(
        UserState(viewed: const {7}, lastSeen: {7: previous}),
      );
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(settingsProvider.notifier).markViewed(7);

      final state = container.read(settingsProvider);
      expect(state.viewed, {7});
      expect(state.lastSeen[7], isNotNull);
      expect(state.lastSeen[7]!.isAfter(previous), isTrue);
    },
  );

  test('setNotifHour ignores invalid hours without persisting them', () async {
    final previousOnError = FlutterError.onError;
    final reportedErrors = <FlutterErrorDetails>[];
    FlutterError.onError = reportedErrors.add;
    addTearDown(() => FlutterError.onError = previousOnError);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(settingsProvider.notifier).setNotifHour(42);

    expect(container.read(settingsProvider).dailyNotifHour, isNull);
    expect(HiveSource.read().dailyNotifHour, isNull);
    expect(reportedErrors, isNotEmpty);
  });
}
