import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';
import 'package:sirah_app/features/study/data/study_notifier.dart';
import 'package:sirah_app/features/study/presentation/review/review_controller.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namesAsync = ref.watch(namesProvider);

    return namesAsync.when(
      loading: () => Scaffold(
        backgroundColor: context.colors.bg,
        body: Center(
          child: CircularProgressIndicator(color: context.colors.accent),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: context.colors.bg,
        body: Center(
          child: Icon(Icons.error_outline, color: context.colors.muted),
        ),
      ),
      data: (names) {
        final allNumbers = names.map((n) => n.number).toList();
        final queue = ref
            .read(studyNotifierProvider)
            .getItemsForReview(allNumbers);

        return _ReviewContent(names: names, queue: queue);
      },
    );
  }
}

class _ReviewContent extends ConsumerWidget {
  const _ReviewContent({required this.names, required this.queue});

  final List<ProphetName> names;
  final List<int> queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewControllerProvider(queue));
    final controller = ref.read(reviewControllerProvider(queue).notifier);
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    if (state.isDone) {
      return Scaffold(
        backgroundColor: colors.bg,
        appBar: AppBar(
          backgroundColor: colors.bg,
          surfaceTintColor: colors.bg,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(space.xl),
            child: Text(
              l10n.studyReviewEmpty,
              style: typo.headline.copyWith(color: colors.muted),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final nameNumber = state.currentNameNumber!;
    final name = names.firstWhere((n) => n.number == nameNumber);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(
          l10n.studyReviewTitle,
          style: typo.caption.copyWith(color: colors.muted),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: LinearProgressIndicator(
            value: state.currentIndex / state.queue.length,
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
            Expanded(
              child: GestureDetector(
                onTap: controller.flip,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: state.isFlipped
                      ? _CardBack(key: const ValueKey('back'), name: name)
                      : _CardFront(key: const ValueKey('front'), name: name),
                ),
              ),
            ),
            SizedBox(height: space.lg),
            if (!state.isFlipped)
              Text(
                l10n.flashcardFlipHint,
                style: typo.caption.copyWith(color: colors.muted),
                textAlign: TextAlign.center,
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.unsure,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.muted,
                        side: BorderSide(color: colors.line),
                      ),
                      child: Text(l10n.studyReviewUnsure),
                    ),
                  ),
                  SizedBox(width: space.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: controller.know,
                      child: Text(l10n.studyReviewKnow),
                    ),
                  ),
                ],
              ),
            SizedBox(height: space.xl),
          ],
        ),
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({super.key, required this.name});
  final ProphetName name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;
    final radii = context.radii;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: radii.lgAll,
        border: Border.all(color: colors.line),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(space.xl),
          child: ArabicText(
            text: name.arabic,
            size: ArabicSize.hero,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({super.key, required this.name});
  final ProphetName name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: radii.lgAll,
        border: Border.all(color: colors.accent.withValues(alpha: 0.4)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(space.lg),
        child: Column(
          children: [
            ArabicText(
              text: name.arabic,
              size: ArabicSize.large,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: space.sm),
            Text(
              name.transliteration,
              style: typo.headline.copyWith(
                fontStyle: FontStyle.italic,
                color: colors.accent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: space.md),
            Text(
              name.commentary,
              style: typo.body.copyWith(color: colors.ink, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
