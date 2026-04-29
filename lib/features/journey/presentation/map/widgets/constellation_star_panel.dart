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
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 340;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _PanelHeader(
                    name: name,
                    stageLabel: _stageLabel(context, stage),
                    color: color,
                    isCompact: isCompact,
                  ),
                ),
                const SizedBox(width: 12),
                _OpenNameButton(
                  color: color,
                  isCompact: isCompact,
                  onOpen: onOpen,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: isCompact ? 58 : 66,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 2),
                child: Text(
                  name.arabic,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  style: context.typo.arabicLarge.copyWith(
                    color: color,
                    fontSize: isCompact ? 40 : 46,
                    height: 1.12,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Flexible(
              child: Text(
                name.transliteration,
                textDirection: TextDirection.ltr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typo.bodyLarge.copyWith(
                  color: colors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _StageChip(label: stageLabel, color: color),
          ],
        ),
      ],
    );
  }
}

class _OpenNameButton extends StatelessWidget {
  const _OpenNameButton({
    required this.color,
    required this.isCompact,
    required this.onOpen,
  });

  final Color color;
  final bool isCompact;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isCompact ? 132 : 154),
      child: FilledButton.icon(
        onPressed: onOpen,
        icon: const Icon(Icons.article_outlined),
        label: Text(
          context.l10n.journeyOpenNameCta,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        style: FilledButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.18),
          foregroundColor: colors.ink,
          side: BorderSide(color: color.withValues(alpha: 0.42)),
          minimumSize: Size(0, isCompact ? 42 : 46),
          padding: EdgeInsets.symmetric(horizontal: isCompact ? 10 : 14),
          visualDensity: VisualDensity.compact,
        ),
      ),
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
