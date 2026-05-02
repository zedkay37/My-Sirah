import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tafakkur_controller.freezed.dart';

const tafakkurPageSeparator = '\n---tafakkur-page---\n';

@freezed
abstract class TafakkurState with _$TafakkurState {
  const factory TafakkurState({
    required List<String> phrases,
    @Default(0) int currentIndex,
    @Default(false) bool isPaused,
    @Default(false) bool isComplete,
    @Default(9) int paceSeconds, // 6 | 9 | 12
    @Default(0) int elapsedSeconds,
  }) = _TafakkurState;

  const TafakkurState._();

  double get darknessLevel {
    if (phrases.isEmpty) return 0.0;
    return (currentIndex / phrases.length).clamp(0.0, 0.7);
  }

  bool get isLastPhrase =>
      phrases.isNotEmpty && currentIndex == phrases.length - 1;
  String get currentPhrase => phrases.isNotEmpty ? phrases[currentIndex] : '';
  int get remaining =>
      phrases.isNotEmpty ? phrases.length - currentIndex - 1 : 0;
}

class TafakkurController extends StateNotifier<TafakkurState> {
  TafakkurController(String commentary)
    : super(const TafakkurState(phrases: [])) {
    final phrases = _splitPhrases(commentary);
    state = state.copyWith(phrases: phrases);
    if (phrases.isNotEmpty) {
      _startTimer();
    } else {
      state = state.copyWith(isComplete: true);
    }
  }

  Timer? _timer;

  List<String> _splitPhrases(String commentary) {
    if (commentary.isEmpty) return [];
    if (commentary.contains(tafakkurPageSeparator)) {
      return commentary
          .split(tafakkurPageSeparator)
          .map((p) => p.trim())
          .where((p) => p.isNotEmpty)
          .toList();
    }

    final pattern = RegExp(r'(?<=[.!?])\s+');
    final rawPhrases = commentary.split(pattern);
    final result = <String>[];
    String current = '';

    for (final p in rawPhrases) {
      final phrase = p.trim();
      if (phrase.isEmpty) continue;

      if (current.isEmpty) {
        current = phrase;
      } else {
        current += ' $phrase';
      }

      if (current.length >= 10) {
        result.add(current);
        current = '';
      }
    }

    if (current.isNotEmpty) {
      if (result.isNotEmpty && current.length < 10) {
        result[result.length - 1] += ' $current';
      } else {
        result.add(current);
      }
    }

    return result;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isPaused || state.isComplete) return;

      final nextElapsed = state.elapsedSeconds + 1;

      if (nextElapsed >= state.paceSeconds) {
        if (state.isLastPhrase) {
          state = state.copyWith(isComplete: true, elapsedSeconds: 0);
          timer.cancel();
        } else {
          state = state.copyWith(
            currentIndex: state.currentIndex + 1,
            elapsedSeconds: 0,
          );
        }
      } else {
        state = state.copyWith(elapsedSeconds: nextElapsed);
      }
    });
  }

  void pause() {
    state = state.copyWith(isPaused: true);
  }

  void resume() {
    state = state.copyWith(isPaused: false);
  }

  void togglePause() {
    state = state.copyWith(isPaused: !state.isPaused);
  }

  void setPace(int seconds) {
    state = state.copyWith(paceSeconds: seconds, elapsedSeconds: 0);
  }

  void next() {
    if (state.isComplete) return;
    if (state.isLastPhrase) {
      state = state.copyWith(isComplete: true, elapsedSeconds: 0);
      _timer?.cancel();
      return;
    }
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      elapsedSeconds: 0,
    );
  }

  void previous() {
    if (state.isComplete || state.currentIndex == 0) return;
    state = state.copyWith(
      currentIndex: state.currentIndex - 1,
      elapsedSeconds: 0,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final tafakkurControllerProvider = StateNotifierProvider.autoDispose
    .family<TafakkurController, TafakkurState, String>(
      (ref, commentary) => TafakkurController(commentary),
    );
