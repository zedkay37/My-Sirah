import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/study/data/study_notifier.dart';

class StudyEntryScreen extends ConsumerWidget {
  const StudyEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(l10n.studyTitle, style: typo.headline),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: space.sm),
            _ModeCard(
              title: l10n.studyParcoursTitle,
              subtitle: l10n.studyParcoursSubtitle,
              icon: Icons.map_outlined,
              onTap: () => context.push('/study/parcours-list'),
            ),
            SizedBox(height: space.md),
            Consumer(
              builder: (context, ref, _) {
                final namesAsync = ref.watch(namesProvider);
                return namesAsync.when(
                  data: (names) {
                    final allNumbers = names.map((n) => n.number).toList();
                    final queue = ref
                        .read(studyNotifierProvider)
                        .getItemsForReview(allNumbers);
                    
                    return _ModeCard(
                      title: l10n.studyReviewTitle,
                      subtitle: l10n.studyReviewSubtitle(queue.length),
                      icon: Icons.style_outlined,
                      onTap: () {
                        if (queue.isNotEmpty) {
                          context.push('/study/review', extra: queue);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.studyReviewEmpty),
                              backgroundColor: colors.accent,
                            ),
                          );
                        }
                      },
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            ),
            SizedBox(height: space.xl),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(space.lg),
        decoration: BoxDecoration(
          color: colors.bg2,
          borderRadius: radii.lgAll,
          border: Border.all(color: colors.line),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(space.sm),
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.accent, size: 28),
            ),
            SizedBox(width: space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: typo.bodyLarge.copyWith(color: colors.ink)),
                  SizedBox(height: space.xs / 2),
                  Text(
                    subtitle,
                    style: typo.caption.copyWith(color: colors.muted),
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
