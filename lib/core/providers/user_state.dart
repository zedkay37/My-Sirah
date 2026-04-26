import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirah_app/core/theme/text_size.dart';
import 'package:sirah_app/core/theme/theme_key.dart';

part 'user_state.freezed.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState({
    @Default(ThemeKey.light) ThemeKey theme,
    @Default(TextSize.medium) TextSize textSize,
    @Default({}) Set<int> favorites,
    @Default({}) Set<int> learned,
    @Default({}) Set<int> viewed,
    @Default({}) Map<int, DateTime> lastSeen,
    DateTime? onboardingCompletedAt,
    int? dailyNotifHour,
    @Default(0) int quizzesCompleted,
    @Default(0) int totalQuizScore,
    // Genealogy module
    @Default({}) Set<String> favoriteMembers,
    @Default({}) Set<String> viewedMembers,
    @Default('radial') String preferredTreeView,
  }) = _UserState;
}
