import 'dart:ui';

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
    final stageLabel = _stageLabel(context, stage);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: colors.bg.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withValues(alpha: 0.42),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.16),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 42, 20, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 76,
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        child: Text(
                          name.arabic,
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: context.typo.arabicLarge.copyWith(
                            color: color,
                            fontSize: 64,
                            height: 1.1,
                            shadows: [
                              Shadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      name.transliteration,
                      textDirection: TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: context.typo.bodyLarge.copyWith(
                        color: colors.ink.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white12, height: 1),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: onOpen,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                        label: Text(
                          context.l10n.journeyOpenNameCta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: color.withValues(alpha: 0.22),
                          foregroundColor: colors.ink,
                          side: BorderSide(
                            color: color.withValues(alpha: 0.48),
                            width: 1.2,
                          ),
                          minimumSize: const Size(0, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 14,
                child: _StageChip(label: stageLabel, color: color),
              ),
            ],
          ),
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

class _StageChip extends StatelessWidget {
  const _StageChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.32), width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
