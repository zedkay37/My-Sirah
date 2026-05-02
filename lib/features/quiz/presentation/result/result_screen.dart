import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/quiz/data/quiz_generator.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    this.deckType = PracticeDeckType.prophetNames,
  });

  final int score;
  final int total;
  final PracticeDeckType deckType;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;
    final deckRoute = switch (deckType) {
      PracticeDeckType.prophetNames => '/library/deck/prophet_names',
      PracticeDeckType.asmaulHusna => '/library/deck/asmaul_husna',
    };

    final message = score >= 4
        ? l10n.quizResultExcellent
        : score >= 2
        ? l10n.quizResultGood
        : l10n.quizResultKeepGoing;

    final emoji = score >= 4
        ? 'بَارَكَ اللهُ'
        : score >= 2
        ? 'الْحَمْدُ للهِ'
        : 'إِن شَاءَ اللهُ';

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(space.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Score arabic ornament
              ArabicText(text: emoji, size: ArabicSize.large, withShadow: true)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(
                    begin: const Offset(0.75, 0.75),
                    curve: Curves.easeOutBack,
                  ),
              SizedBox(height: space.xl),
              // Score
              Text(
                    l10n.quizResultScore(score, total),
                    textAlign: TextAlign.center,
                    style: typo.displayMedium,
                  )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOut),
              SizedBox(height: space.lg),
              // Message
              Container(
                    padding: EdgeInsets.all(space.lg),
                    decoration: BoxDecoration(
                      color: colors.bg2,
                      borderRadius: context.radii.lgAll,
                      border: Border.all(color: colors.line),
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: typo.bodyLarge.copyWith(
                        fontStyle: FontStyle.italic,
                        color: colors.muted,
                      ),
                    ),
                  )
                  .animate(delay: 550.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, curve: Curves.easeOut),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go(deckRoute),
                  child: Text(l10n.quizExploreNamesCta),
                ),
              ),
              SizedBox(height: space.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go(deckRoute),
                  child: Text(l10n.quizReplayCta),
                ),
              ),
              SizedBox(height: space.lg),
            ],
          ),
        ),
      ),
    );
  }
}
