import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirah_app/features/study/data/leitner_repository.dart';

part 'review_controller.freezed.dart';

@freezed
abstract class ReviewState with _$ReviewState {
  const factory ReviewState({
    required List<int> queue,
    @Default(0) int currentIndex,
    @Default(false) bool isFlipped,
    @Default(false) bool isDone,
  }) = _ReviewState;

  const ReviewState._();

  int? get currentNameNumber =>
      currentIndex < queue.length ? queue[currentIndex] : null;
}

class ReviewController extends StateNotifier<ReviewState> {
  ReviewController(this._leitner, List<int> queue)
      : super(ReviewState(queue: queue, isDone: queue.isEmpty));

  final LeitnerRepository _leitner;

  void flip() => state = state.copyWith(isFlipped: !state.isFlipped);

  Future<void> know() async {
    final n = state.currentNameNumber;
    if (n != null) await _leitner.levelUp(n);
    _advance();
  }

  Future<void> unsure() async {
    final n = state.currentNameNumber;
    if (n != null) await _leitner.levelDown(n);
    _advance();
  }

  void _advance() {
    final next = state.currentIndex + 1;
    if (next >= state.queue.length) {
      state = state.copyWith(isDone: true);
    } else {
      state = state.copyWith(
        currentIndex: next,
        isFlipped: false,
      );
    }
  }
}

final reviewControllerProvider = StateNotifierProvider.autoDispose
    .family<ReviewController, ReviewState, List<int>>(
  (ref, queue) => ReviewController(
    ref.read(leitnerRepositoryProvider),
    queue,
  ),
);
