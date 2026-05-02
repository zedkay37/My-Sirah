import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';

class AsmaaNotifier {
  const AsmaaNotifier(this._ref);
  final Ref _ref;

  Set<int> get husnaLearned => _ref.read(settingsProvider).husnaLearned;

  Future<void> markHusnaLearned(int id) =>
      _ref.read(settingsProvider.notifier).markHusnaLearned(id);
}

final asmaaNotifierProvider = Provider<AsmaaNotifier>(
  (ref) => AsmaaNotifier(ref),
);
