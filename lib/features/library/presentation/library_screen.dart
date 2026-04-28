import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/husna_providers.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/quiz/data/quiz_generator.dart';
import 'package:sirah_app/features/quiz/data/quiz_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  void _startQcm(BuildContext context, WidgetRef ref) {
    ref.read(namesProvider).whenData((names) {
      ref.read(quizSessionProvider.notifier).state = QuizSession.qcm(
        QuizGenerator.generateQcm(names),
      );
      context.push('/quiz/qcm');
    });
  }

  void _startFlashcards(BuildContext context, WidgetRef ref) {
    ref.read(namesProvider).whenData((names) {
      ref.read(quizSessionProvider.notifier).state = QuizSession.flashcards(
        QuizGenerator.pickRandom(names),
      );
      context.push('/quiz/flashcards');
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;
    final prophetsRecognized = ref
        .watch(journeyProgressResolverProvider)
        .recognized
        .length;
    final husnaLearned = ref.watch(husnaLearnedCountProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(l10n.libraryTitle, style: typo.headline),
      ),
      body: ListView(
        padding: EdgeInsets.all(space.md),
        children: [
          Text(
            l10n.librarySubtitle,
            style: typo.body.copyWith(color: colors.muted),
          ),
          SizedBox(height: space.lg),
          _LibraryDeckCard(
            icon: Icons.menu_book_outlined,
            title: l10n.discoverProphetsTitle,
            subtitle: l10n.libraryProphetNamesSubtitle,
            progressLabel: l10n.libraryDeckProgress(prophetsRecognized, 201),
            accentColor: colors.accent,
            onTap: () => context.push('/library/deck/prophet_names'),
          ),
          SizedBox(height: space.md),
          _LibraryDeckCard(
            icon: Icons.stars_outlined,
            title: l10n.husnaTitle,
            subtitle: l10n.discoverHusnaSubtitle,
            progressLabel: l10n.libraryDeckProgress(husnaLearned, 99),
            accentColor: colors.accent2,
            onTap: () => context.push('/library/deck/asmaul_husna'),
          ),
          SizedBox(height: space.xl),
          Text(
            l10n.libraryToolsTitle,
            style: typo.bodyLarge.copyWith(color: colors.ink),
          ),
          SizedBox(height: space.sm),
          _ToolRow(
            icon: Icons.style_outlined,
            title: l10n.studyReviewTitle,
            onTap: () => context.push('/study'),
          ),
          _ToolRow(
            icon: Icons.quiz_outlined,
            title: l10n.quizTypeMCQ,
            onTap: () => _startQcm(context, ref),
          ),
          _ToolRow(
            icon: Icons.view_carousel_outlined,
            title: l10n.quizTypeFlashcards,
            onTap: () => _startFlashcards(context, ref),
          ),
        ],
      ),
    );
  }
}

class _LibraryDeckCard extends StatelessWidget {
  const _LibraryDeckCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progressLabel,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String progressLabel;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;

    return InkWell(
      onTap: onTap,
      borderRadius: context.radii.lgAll,
      child: Container(
        padding: EdgeInsets.all(space.lg),
        decoration: BoxDecoration(
          color: colors.bg2,
          borderRadius: context.radii.lgAll,
          border: Border.all(color: colors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: context.radii.mdAll,
              ),
              child: Icon(icon, color: accentColor),
            ),
            SizedBox(width: space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: typo.bodyLarge.copyWith(color: colors.ink),
                  ),
                  SizedBox(height: space.xs / 2),
                  Text(
                    subtitle,
                    style: typo.caption.copyWith(color: colors.muted),
                  ),
                  SizedBox(height: space.xs),
                  Text(
                    progressLabel,
                    style: typo.caption.copyWith(color: accentColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.muted),
          ],
        ),
      ),
    );
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: space.sm),
      leading: Icon(icon, color: colors.accent),
      title: Text(title, style: typo.body.copyWith(color: colors.ink)),
      trailing: Icon(Icons.chevron_right, color: colors.muted),
    );
  }
}
