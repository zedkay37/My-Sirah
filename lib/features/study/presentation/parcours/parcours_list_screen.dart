import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/core/utils/color_utils.dart';
import 'package:sirah_app/features/study/data/parcours_repository.dart';

class ParcoursListScreen extends ConsumerWidget {
  const ParcoursListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parcoursAsync = ref.watch(parcoursProvider);
    final completedParcours = ref.watch(
      settingsProvider.select((s) => s.completedParcours),
    );
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
        title: Text(l10n.studyParcoursTitle, style: typo.headline),
      ),
      body: parcoursAsync.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: colors.accent)),
        error: (_, __) =>
            Center(child: Icon(Icons.error_outline, color: colors.muted)),
        data: (list) => ListView.separated(
          padding: EdgeInsets.fromLTRB(
            space.md,
            space.md,
            space.md,
            space.md + MediaQuery.paddingOf(context).bottom,
          ),
          itemCount: list.length,
          separatorBuilder: (_, __) => SizedBox(height: space.sm),
          itemBuilder: (context, index) {
            final parcours = list[index];
            final isCompleted = completedParcours.contains(parcours.id);
            final color = hexToColor(parcours.colorHex);

            return _ParcoursCard(
              parcours: parcours,
              isCompleted: isCompleted,
              accentColor: color,
              onTap: () => context.push('/study/parcours/${parcours.id}'),
            );
          },
        ),
      ),
    );
  }
}

class _ParcoursCard extends StatelessWidget {
  const _ParcoursCard({
    required this.parcours,
    required this.isCompleted,
    required this.accentColor,
    required this.onTap,
  });

  final Parcours parcours;
  final bool isCompleted;
  final Color accentColor;
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
        decoration: BoxDecoration(
          color: colors.bg2,
          borderRadius: radii.lgAll,
          border: Border.all(
            color: isCompleted
                ? accentColor.withValues(alpha: 0.6)
                : colors.line,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(space.md),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parcours.titleFr,
                      style: typo.bodyLarge.copyWith(color: colors.ink),
                    ),
                    SizedBox(height: space.xs / 2),
                    Text(
                      parcours.descriptionFr,
                      style: typo.caption.copyWith(color: colors.muted),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: space.sm),
              if (isCompleted)
                Icon(Icons.check_circle, color: accentColor, size: 20)
              else
                Text(
                  '${parcours.nameNumbers.length}',
                  style: typo.caption.copyWith(color: colors.muted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
