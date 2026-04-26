import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/notifications/notification_service.dart';
import 'package:sirah_app/core/providers/user_state.dart';
import 'package:sirah_app/core/storage/hive_source.dart';
import 'package:sirah_app/core/theme/text_size.dart';
import 'package:sirah_app/core/theme/theme_key.dart';

class SettingsNotifier extends Notifier<UserState> {
  @override
  UserState build() => HiveSource.read();

  Future<void> _save(UserState next) async {
    state = next;
    await HiveSource.write(next);
  }

  Future<void> setTheme(ThemeKey theme) => _save(state.copyWith(theme: theme));

  Future<void> setTextSize(TextSize size) =>
      _save(state.copyWith(textSize: size));

  Future<void> setOnboardingComplete() => _save(
        state.copyWith(onboardingCompletedAt: DateTime.now()),
      );

  Future<void> toggleFavorite(int number) {
    final favs = Set<int>.from(state.favorites);
    if (favs.contains(number)) {
      favs.remove(number);
    } else {
      favs.add(number);
    }
    return _save(state.copyWith(favorites: favs));
  }

  Future<void> markViewed(int number) {
    if (state.viewed.contains(number)) return Future.value();
    final viewed = Set<int>.from(state.viewed)..add(number);
    final lastSeen = Map<int, DateTime>.from(state.lastSeen)
      ..[number] = DateTime.now();
    return _save(state.copyWith(viewed: viewed, lastSeen: lastSeen));
  }

  Future<void> markLearned(int number) {
    if (state.learned.contains(number)) return Future.value();
    final learned = Set<int>.from(state.learned)..add(number);
    return _save(state.copyWith(learned: learned));
  }

  Future<void> setNotifHour(int? hour) async {
    await _save(state.copyWith(dailyNotifHour: hour));
    if (hour != null) {
      await NotificationService.scheduleDailyAt(hour);
    } else {
      await NotificationService.cancel();
    }
  }

  Future<void> recordQuizResult(int correctAnswers) => _save(
        state.copyWith(
          quizzesCompleted: state.quizzesCompleted + 1,
          totalQuizScore: state.totalQuizScore + correctAnswers,
        ),
      );

  // ── Genealogy ─────────────────────────────────────────────────────────────

  Future<void> toggleFavoriteMember(String id) {
    final favs = Set<String>.from(state.favoriteMembers);
    if (favs.contains(id)) {
      favs.remove(id);
    } else {
      favs.add(id);
    }
    return _save(state.copyWith(favoriteMembers: favs));
  }

  Future<void> markMemberViewed(String id) {
    if (state.viewedMembers.contains(id)) return Future.value();
    final viewed = Set<String>.from(state.viewedMembers)..add(id);
    return _save(state.copyWith(viewedMembers: viewed));
  }

  Future<void> setPreferredTreeView(String view) =>
      _save(state.copyWith(preferredTreeView: view));

  // ── Study / Leitner ──────────────────────────────────────────────────────────

  Future<void> levelUp(int nameNumber) {
    final boxes = Map<int, int>.from(state.leitnerBoxes);
    final current = boxes[nameNumber] ?? 0;
    boxes[nameNumber] = (current + 1).clamp(0, 2);
    return _save(state.copyWith(leitnerBoxes: boxes));
  }

  Future<void> levelDown(int nameNumber) {
    final boxes = Map<int, int>.from(state.leitnerBoxes);
    final current = boxes[nameNumber] ?? 0;
    boxes[nameNumber] = (current - 1).clamp(0, 2);
    return _save(state.copyWith(leitnerBoxes: boxes));
  }

  Future<void> setStudyMode(String mode) =>
      _save(state.copyWith(studyMode: mode));

  Future<void> markParcoursComplete(String id) {
    final completed = Set<String>.from(state.completedParcours)..add(id);
    return _save(state.copyWith(completedParcours: completed));
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, UserState>(
  SettingsNotifier.new,
);
