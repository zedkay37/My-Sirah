import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/storage/hive_source.dart';
import 'package:sirah_app/core/theme/text_size.dart';
import 'package:sirah_app/core/theme/theme_key.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sirah_hive_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<String>('settings');
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('HiveSource', () {
    test('read returns default UserState when no state exists', () {
      final state = HiveSource.read();

      expect(state, const UserState());
    });

    test('write then read preserves persisted user state fields', () async {
      final saved = UserState(
        theme: ThemeKey.dark,
        textSize: TextSize.large,
        favorites: {1, 2},
        learned: {3},
        viewed: {1, 3},
        meditatedNames: {1},
        practicedNames: {2},
        recognizedNames: {3},
        lastSeen: {1: DateTime.utc(2026, 4, 27, 12)},
        onboardingCompletedAt: DateTime.utc(2026, 4, 27),
        dailyNotifHour: 8,
        quizzesCompleted: 4,
        totalQuizScore: 17,
        favoriteMembers: {'khadija'},
        viewedMembers: {'muhammad'},
        preferredTreeView: 'river',
        leitnerBoxes: {1: 2, 2: 1},
        completedParcours: {'prophetie'},
        studyMode: 'parcours',
        husnaLearned: {1, 99},
      );

      await HiveSource.write(saved);

      expect(HiveSource.read(), saved);
    });

    test(
      'read returns default UserState when stored JSON is corrupted',
      () async {
        await Hive.box<String>('settings').put('user_state', '{not-json');

        final state = HiveSource.read();

        expect(state, const UserState());
      },
    );

    test('read ignores unknown fields and keeps known fields', () async {
      await Hive.box<String>('settings').put('user_state', '''
        {
          "theme": "dark",
          "textSize": "small",
          "favorites": [1, 2],
          "unknownFutureField": {"nested": true}
        }
        ''');

      final state = HiveSource.read();

      expect(state.theme, ThemeKey.dark);
      expect(state.textSize, TextSize.small);
      expect(state.favorites, {1, 2});
      expect(state.learned, isEmpty);
    });

    test('read applies defaults when optional fields are missing', () async {
      await Hive.box<String>('settings').put('user_state', '''
        {
          "theme": "light",
          "favorites": [7]
        }
        ''');

      final state = HiveSource.read();

      expect(state.theme, ThemeKey.light);
      expect(state.textSize, TextSize.medium);
      expect(state.favorites, {7});
      expect(state.meditatedNames, isEmpty);
      expect(state.practicedNames, isEmpty);
      expect(state.recognizedNames, isEmpty);
      expect(state.leitnerBoxes, isEmpty);
      expect(state.husnaLearned, isEmpty);
    });

    test(
      'read keeps valid fields when neighboring fields are malformed',
      () async {
        await Hive.box<String>('settings').put('user_state', '''
        {
          "favorites": [1, "2", "bad", 3],
          "learned": "not-a-list",
          "viewed": [4],
          "meditatedNames": [1, "4", "bad"],
          "practicedNames": [2, "5", "bad"],
          "recognizedNames": [3, "6", "bad"],
          "lastSeen": {
            "4": "2026-04-27T10:00:00.000Z",
            "bad-key": "2026-04-27T10:00:00.000Z",
            "5": "not-a-date"
          },
          "dailyNotifHour": "9",
          "quizzesCompleted": "12",
          "totalQuizScore": {},
          "favoriteMembers": ["khadija", 42],
          "leitnerBoxes": {
            "1": "2",
            "2": "bad",
            "bad-key": 1
          },
          "completedParcours": [7, "mission"],
          "husnaLearned": [1, "99", "bad"]
        }
        ''');

        final state = HiveSource.read();

        expect(state.favorites, {1, 2, 3});
        expect(state.learned, isEmpty);
        expect(state.viewed, {4});
        expect(state.meditatedNames, {1, 4});
        expect(state.practicedNames, {2, 5});
        expect(state.recognizedNames, {3, 6});
        expect(state.lastSeen, {4: DateTime.parse('2026-04-27T10:00:00.000Z')});
        expect(state.dailyNotifHour, 9);
        expect(state.quizzesCompleted, 12);
        expect(state.totalQuizScore, 0);
        expect(state.favoriteMembers, {'khadija'});
        expect(state.leitnerBoxes, {1: 2});
        expect(state.completedParcours, {'mission'});
        expect(state.husnaLearned, {1, 99});
      },
    );
  });
}
