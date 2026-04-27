import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';

class GenealogyNotifier {
  const GenealogyNotifier(this._ref);
  final Ref _ref;

  Set<String> get favoriteMembers =>
      _ref.read(settingsProvider).favoriteMembers;
      
  Set<String> get viewedMembers =>
      _ref.read(settingsProvider).viewedMembers;

  String get preferredTreeView =>
      _ref.read(settingsProvider).preferredTreeView;

  Future<void> toggleFavoriteMember(String id) =>
      _ref.read(settingsProvider.notifier).toggleFavoriteMember(id);

  Future<void> markMemberViewed(String id) =>
      _ref.read(settingsProvider.notifier).markMemberViewed(id);

  Future<void> setPreferredTreeView(String view) =>
      _ref.read(settingsProvider.notifier).setPreferredTreeView(view);
}

final genealogyNotifierProvider = Provider<GenealogyNotifier>(
  (ref) => GenealogyNotifier(ref),
);
