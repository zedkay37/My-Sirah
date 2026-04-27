import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/features/names/data/names_notifier.dart';
import 'package:sirah_app/features/study/data/study_notifier.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/quiz/data/quiz_generator.dart';
import 'package:sirah_app/features/quiz/data/quiz_provider.dart';
import 'package:sirah_app/features/shared/quiz_card.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> {
  int _index = 0;
  bool _isFlipped = false;
  int _knownCount = 0;

  QuizSession get _session => ref.read(quizSessionProvider)!;

  void _flip() => setState(() => _isFlipped = !_isFlipped);

  void _know() {
    ref
        .read(namesNotifierProvider)
        .markLearned(_session.names[_index].number);
    ref
        .read(studyNotifierProvider)
        .levelUp(_session.names[_index].number);
    _knownCount++;
    _advance();
  }

  void _review() => _advance();

  void _advance() {
    final total = _session.names.length;
    if (_index < total - 1) {
      setState(() {
        _index++;
        _isFlipped = false;
      });
    } else {
      context.pushReplacement(
        '/quiz/result',
        extra: {'score': _knownCount, 'total': total},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;
    final total = _session.names.length;
    final name = _session.names[_index];

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(
          l10n.quizProgress(_index + 1, total),
          style: typo.caption.copyWith(color: colors.muted),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: LinearProgressIndicator(
            value: (_index + 1) / total,
            backgroundColor: colors.line,
            valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            minHeight: 2,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(space.md),
        child: Column(
          children: [
            SizedBox(height: space.md),
            // Carte retournable
            Expanded(
              child: QuizCard(
                name: name,
                isFlipped: _isFlipped,
                onFlip: _flip,
              ),
            ),
            SizedBox(height: space.lg),
            // Boutons (visibles uniquement après retournement)
            AnimatedOpacity(
              opacity: _isFlipped ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !_isFlipped,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _review,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.muted,
                          side: BorderSide(color: colors.line),
                        ),
                        child: Text(l10n.quizCardReview),
                      ),
                    ),
                    SizedBox(width: space.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: _know,
                        child: Text(l10n.quizCardKnow),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Indication tactile (avant retournement)
            AnimatedOpacity(
              opacity: _isFlipped ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: _isFlipped,
                child: Text(
                  l10n.flashcardFlipHint,
                  style: typo.caption.copyWith(color: colors.muted),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: space.xl),
          ],
        ),
      ),
    );
  }
}
