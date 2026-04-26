import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_deck.freezed.dart';

@freezed
abstract class LearningDeck with _$LearningDeck {
  const factory LearningDeck({
    required String id,
    required String titleFr,
    required String titleAr,
    required IconData icon,
    required int itemCount,
  }) = _LearningDeck;
}
