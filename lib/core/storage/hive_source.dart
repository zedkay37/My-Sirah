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
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
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
    'lastSeen': s.lastSeen.map(
      (k, v) => MapEntry(k.toString(), v.toIso8601String()),
    ),
    'onboardingCompletedAt': s.onboardingCompletedAt?.toIso8601String(),
    'dailyNotifHour': s.dailyNotifHour,
    'quizzesCompleted': s.quizzesCompleted,
    'totalQuizScore': s.totalQuizScore,
    'favoriteMembers': s.favoriteMembers.toList(),
    'viewedMembers': s.viewedMembers.toList(),
    'preferredTreeView': s.preferredTreeView,
    'leitnerBoxes': s.leitnerBoxes.map((k, v) => MapEntry(k.toString(), v)),
    'completedParcours': s.completedParcours.toList(),
    'studyMode': s.studyMode,
    'husnaLearned': s.husnaLearned.toList(),
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

    final leitnerRaw = _stringKeyedMap(m['leitnerBoxes']);
    final leitnerBoxes = <int, int>{};
    for (final entry in leitnerRaw.entries) {
      final key = int.tryParse(entry.key);
      final value = _intValue(entry.value);
      if (key != null && value != null) leitnerBoxes[key] = value;
    }
    final preferredTreeView = m['preferredTreeView'] is String
        ? m['preferredTreeView'] as String
        : 'radial';
    final studyMode = m['studyMode'] is String
        ? m['studyMode'] as String
        : 'random';

    return UserState(
      theme: theme,
      textSize: textSize,
      favorites: _intSet(m['favorites']),
      learned: _intSet(m['learned']),
      viewed: _intSet(m['viewed']),
      lastSeen: _lastSeenMap(m['lastSeen']),
      onboardingCompletedAt: _dateTime(m['onboardingCompletedAt']),
      dailyNotifHour: _intValue(m['dailyNotifHour']),
      quizzesCompleted: _intValue(m['quizzesCompleted']) ?? 0,
      totalQuizScore: _intValue(m['totalQuizScore']) ?? 0,
      favoriteMembers: _stringSet(m['favoriteMembers']),
      viewedMembers: _stringSet(m['viewedMembers']),
      preferredTreeView: preferredTreeView,
      leitnerBoxes: leitnerBoxes,
      completedParcours: _stringSet(m['completedParcours']),
      studyMode: studyMode,
      husnaLearned: _intSet(m['husnaLearned']),
    );
  }

  static int? _intValue(Object? value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static DateTime? _dateTime(Object? value) {
    if (value is! String) return null;
    return DateTime.tryParse(value);
  }

  static Set<int> _intSet(Object? value) {
    if (value is! List<dynamic>) return {};
    return value.map(_intValue).whereType<int>().toSet();
  }

  static Set<String> _stringSet(Object? value) {
    if (value is! List<dynamic>) return {};
    return value.whereType<String>().toSet();
  }

  static Map<int, DateTime> _lastSeenMap(Object? value) {
    final raw = _stringKeyedMap(value);
    if (raw.isEmpty) return {};
    final parsed = <int, DateTime>{};
    for (final entry in raw.entries) {
      final key = int.tryParse(entry.key);
      final seenAt = _dateTime(entry.value);
      if (key != null && seenAt != null) {
        parsed[key] = seenAt;
      }
    }
    return parsed;
  }

  static Map<String, dynamic> _stringKeyedMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is! Map<dynamic, dynamic>) return {};
    return {
      for (final entry in value.entries)
        if (entry.key is String) entry.key as String: entry.value,
    };
  }
}
