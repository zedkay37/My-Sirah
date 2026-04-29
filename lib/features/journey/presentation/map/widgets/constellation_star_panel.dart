import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';

class ConstellationStarPanel extends StatelessWidget {
  const ConstellationStarPanel({
    super.key,
    required this.name,
    required this.stage,
    required this.color,
    required this.onOpen,
  });

  final ProphetName name;
  final JourneyNameStage stage;
  final Color color;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bg.withValues(alpha: 0.94),
        borderRadius: context.radii.mdAll,
        border: Border.all(color: color.withValues(alpha: 0.34)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.16),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 330;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PanelHeader(
                  name: name,
                  stageLabel: _stageLabel(context, stage),
                  color: color,
                  isCompact: isCompact,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(context.l10n.homeExploreTodayName),
                  onPressed: onOpen,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _stageLabel(BuildContext context, JourneyNameStage stage) {
    final l10n = context.l10n;
    return switch (stage) {
      JourneyNameStage.recognized => l10n.journeyStarRecognized,
      JourneyNameStage.practiced => l10n.journeyStarPracticed,
      JourneyNameStage.meditated => l10n.journeyStarMeditated,
      JourneyNameStage.viewed => l10n.journeyStarViewed,
      JourneyNameStage.unknown => l10n.journeyStarUnknown,
    };
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.name,
    required this.stageLabel,
    required this.color,
    required this.isCompact,
  });

  final ProphetName name;
  final String stageLabel;
  final Color color;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final nameBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name.arabic,
          textDirection: TextDirection.rtl,
          style: context.typo.arabicLarge.copyWith(
            color: color,
            fontSize: isCompact ? 42 : null,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name.transliteration,
          textDirection: TextDirection.ltr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.typo.bodyLarge.copyWith(
            color: colors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          nameBlock,
          const SizedBox(height: 10),
          _StageChip(label: stageLabel, color: color),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: nameBlock),
        const SizedBox(width: 12),
        _StageChip(label: stageLabel, color: color),
      ],
    );
  }
}

class _StageChip extends StatelessWidget {
  const _StageChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: context.radii.pillAll,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.typo.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
