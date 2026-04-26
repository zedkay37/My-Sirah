import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/quiz/data/quiz_generator.dart';
import 'package:sirah_app/features/quiz/data/quiz_provider.dart';

class QuizEntryScreen extends ConsumerWidget {
  const QuizEntryScreen({super.key});

  void _startQcm(BuildContext context, WidgetRef ref) {
    ref.read(namesProvider).whenData((names) {
      ref.read(quizSessionProvider.notifier).state =
          QuizSession.qcm(QuizGenerator.generateQcm(names));
      context.push('/quiz/qcm');
    });
  }

  void _startFlashcards(BuildContext context, WidgetRef ref) {
    ref.read(namesProvider).whenData((names) {
      ref.read(quizSessionProvider.notifier).state =
          QuizSession.flashcards(QuizGenerator.pickRandom(names));
      context.push('/quiz/flashcards');
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.all(space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: space.lg),
          Text(l10n.quizTitle, style: typo.displayMedium),
          SizedBox(height: space.xs),
          Text(
            l10n.quizSubtitle,
            style: typo.body.copyWith(color: colors.muted),
          ),
          SizedBox(height: space.xl),
          _QuizTypeCard(
            icon: Icons.quiz_outlined,
            title: l10n.quizTypeMCQ,
            description: l10n.quizTypeMCQDesc,
            onTap: () => _startQcm(context, ref),
          ),
          SizedBox(height: space.md),
          _QuizTypeCard(
            icon: Icons.style_outlined,
            title: l10n.quizTypeFlashcards,
            description: l10n.quizTypeFlashcardsDesc,
            onTap: () => _startFlashcards(context, ref),
          ),
        ],
      ),
    );
  }
}

class _QuizTypeCard extends StatelessWidget {
  const _QuizTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    return Semantics(
      button: true,
      label: title,
      child: InkWell(
        onTap: onTap,
        borderRadius: radii.lgAll,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(space.lg),
          decoration: BoxDecoration(
            color: colors.bg2,
            borderRadius: radii.lgAll,
            border: Border.all(color: colors.line),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(radii.md),
                ),
                child: Icon(icon, color: colors.accent, size: 24),
              ),
              SizedBox(width: space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: typo.headline),
                    SizedBox(height: space.xs),
                    Text(
                      description,
                      style: typo.body.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              SizedBox(width: space.sm),
              Text(
                l10n.quizStartCta,
                style: typo.button.copyWith(color: colors.accent),
              ),
              SizedBox(width: space.xs),
              Icon(Icons.arrow_forward_ios, size: 14, color: colors.accent),
            ],
          ),
        ),
      ),
    );
  }
}
