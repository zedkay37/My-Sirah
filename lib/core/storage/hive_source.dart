import 'dart:convert';
import 'dart:io' show File, Platform;

import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/theme/text_size.dart';
import 'package:sirah_app/core/theme/theme_key.dart';

class HiveSource {
  HiveSource._();

  static const String _boxName = 'settings';
  static const String _stateKey = 'user_state';

  static Future<void> init() async {
    // On desktop, use a dedicated app-support directory and clear stale lock
    // files that can accumulate during hot-restart development cycles.
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      final dir = await getApplicationSupportDirectory();
      final lockFile = File('${dir.path}/$_boxName.lock');
      if (await lockFile.exists()) {
        try {
          await lockFile.delete();
        } catch (_) {}
      }
      Hive.init(dir.path);
    } else {
      await Hive.initFlutter();
    }
    await Hive.openBox<String>(_boxName);
  }

  static Box<String> get _box => Hive.box<String>(_boxName);

  static UserState read() {
    final raw = _box.get(_stateKey);
    if (raw == null) return const UserState();
    try {
      final map = json.decode(raw) as Map<String, dynamic>;
      return _fromMap(map);
    } catch (_) {
      return const UserState();
    }
  }

  static Future<void> write(UserState state) async {
    await _box.put(_stateKey, json.encode(_toMap(state)));
  }

  static Map<String, dynamic> _toMap(UserState s) => {
        'theme': s.theme.name,
        'textSize': s.textSize.name,
        'favorites': s.favorites.toList(),
        'learned': s.learned.toList(),
        'viewed': s.viewed.toList(),
        'lastSeen': s.lastSeen
            .map((k, v) => MapEntry(k.toString(), v.toIso8601String())),
        'onboardingCompletedAt': s.onboardingCompletedAt?.toIso8601String(),
        'dailyNotifHour': s.dailyNotifHour,
        'quizzesCompleted': s.quizzesCompleted,
        'totalQuizScore': s.totalQuizScore,
      };

  static UserState _fromMap(Map<String, dynamic> m) {
    final themeStr = m['theme'] as String? ?? 'light';
    final theme = ThemeKey.values.firstWhere(
      (t) => t.name == themeStr,
      orElse: () => ThemeKey.light,
    );

    final textSizeStr = m['textSize'] as String? ?? 'medium';
    final textSize = TextSize.values.firstWhere(
      (t) => t.name == textSizeStr,
      orElse: () => TextSize.medium,
    );

    final favList = (m['favorites'] as List<dynamic>? ?? []);
    final learnedList = (m['learned'] as List<dynamic>? ?? []);
    final viewedList = (m['viewed'] as List<dynamic>? ?? []);

    final lastSeenRaw = m['lastSeen'] as Map<String, dynamic>? ?? {};
    final lastSeen = lastSeenRaw.map(
      (k, v) => MapEntry(int.parse(k), DateTime.parse(v as String)),
    );

    final onboardingStr = m['onboardingCompletedAt'] as String?;

    return UserState(
      theme: theme,
      textSize: textSize,
      favorites: Set<int>.from(favList.map((e) => e as int)),
      learned: Set<int>.from(learnedList.map((e) => e as int)),
      viewed: Set<int>.from(viewedList.map((e) => e as int)),
      lastSeen: lastSeen,
      onboardingCompletedAt:
          onboardingStr != null ? DateTime.parse(onboardingStr) : null,
      dailyNotifHour: m['dailyNotifHour'] as int?,
      quizzesCompleted: m['quizzesCompleted'] as int? ?? 0,
      totalQuizScore: m['totalQuizScore'] as int? ?? 0,
    );
  }
}
