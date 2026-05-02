import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.days, this.animate = false});

  final int days;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;

    Widget badge = Container(
      padding: EdgeInsets.symmetric(horizontal: space.sm, vertical: space.xs),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_outlined, color: colors.warning, size: 16),
          SizedBox(width: space.xs),
          Text(
            context.l10n.profileRitualStreak(days),
            style: typo.button.copyWith(color: colors.warning),
          ),
        ],
      ),
    );

    if (animate) {
      badge = badge
          .animate()
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.3, 1.3),
            duration: 200.ms,
            curve: Curves.easeOut,
          )
          .then()
          .scale(
            begin: const Offset(1.3, 1.3),
            end: const Offset(1, 1),
            duration: 150.ms,
          );
    }

    return Semantics(
      label: context.l10n.profileRitualStreak(days),
      child: badge,
    );
  }
}
