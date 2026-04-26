import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/features/quiz/data/quiz_generator.dart';

// Session en cours — null si aucun quiz démarré
final quizSessionProvider = StateProvider<QuizSession?>((ref) => null);
