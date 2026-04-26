import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/core/utils/hijri_utils.dart';
import 'package:sirah_app/features/shared/progress_ring.dart';
import 'package:sirah_app/features/shared/section_header.dart';
import 'package:sirah_app/features/shared/streak_badge.dart';
import 'package:sirah_app/features/shared/theme_picker.dart';

// Fibonacci spiral position shared by view + painter
Offset _starPosition(int index, int total, Size size) {
  final goldenAngle = math.pi * (3 - math.sqrt(5));
  final r = math.sqrt((index + 0.5) / total) * 0.45;
  final theta = index * goldenAngle;
  return Offset(
    size.width / 2 + r * size.width * math.cos(theta),
    size.height / 2 + r * size.height * math.sin(theta),
  );
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    final settings = ref.watch(settingsProvider);
    final namesAsync = ref.watch(namesProvider);

    final learnedCount = settings.learned.length;
    final progress = learnedCount / 201;
    final streak = _computeStreak(settings.lastSeen);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.homeGreeting, style: typo.headline),
            Text(
              _hijriDate(),
              style: typo.caption.copyWith(color: colors.muted),
            ),
          ],
        ),
        actions: [
          Semantics(
            label: l10n.profileSettings,
            button: true,
            child: IconButton(
              icon: Icon(Icons.settings_outlined, color: colors.muted),
              onPressed: () => context.push('/settings'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: space.md),

              // ── Progression principale ────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ProgressRing(
                          progress: progress,
                          size: 80,
                          strokeWidth: 6,
                          color: colors.accent,
                        ),
                        Text('$learnedCount', style: typo.headline),
                      ],
                    ),
                    SizedBox(width: space.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.profileLearnedSubtitle,
                            style: typo.body.copyWith(color: colors.muted),
                          ),
                          SizedBox(height: space.xs),
                          if (streak > 0) StreakBadge(days: streak),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: space.xl),

              // ── Constellation ─────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: SectionHeader(title: l10n.profileConstellationTitle),
              ),
              SizedBox(height: space.sm),
              namesAsync.when(
                data: (names) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: space.md),
                  child: _ConstellationView(
                    totalNames: names.length,
                    learnedNumbers: settings.learned,
                    viewedNumbers: settings.viewed,
                    onStarTap: (number) => context.push('/name/$number'),
                  ),
                ),
                loading: () => const SizedBox(height: 300),
                error: (_, __) => const SizedBox(height: 300),
              ),
              SizedBox(height: space.sm),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: _ConstellationLegend(),
              ),
              SizedBox(height: space.xl),

              // ── Thème ─────────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: SectionHeader(title: context.l10n.settingsSectionTheme),
              ),
              SizedBox(height: space.sm),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: ThemePicker(
                  current: settings.theme,
                  onChanged: ref.read(settingsProvider.notifier).setTheme,
                ),
              ),
              SizedBox(height: space.xl),

              // ── Raccourcis ────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: Column(
                  children: [
                    _ProfileTile(
                      icon: Icons.favorite_outline,
                      label: l10n.profileFavorites,
                      count: settings.favorites.length,
                      onTap: () => context.push('/favorites'),
                    ),
                    SizedBox(height: space.xs),
                    _ProfileTile(
                      icon: Icons.settings_outlined,
                      label: l10n.profileSettings,
                      onTap: () => context.push('/settings'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: space.xl),
            ],
          ),
        ),
      ),
    );
  }

  String _hijriDate() => HijriUtils.format(HijriCalendar.now());

  int _computeStreak(Map<int, DateTime> lastSeen) {
    if (lastSeen.isEmpty) return 0;
    final today = DateTime.now();
    final dates = lastSeen.values.toSet();
    int streak = 0;
    for (int i = 0; i < 365; i++) {
      final day = DateTime(today.year, today.month, today.day - i);
      if (dates.any(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day,
      )) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}

// ── Constellation — 201 étoiles ───────────────────────────────────────────────

class _ConstellationView extends StatelessWidget {
  const _ConstellationView({
    required this.totalNames,
    required this.learnedNumbers,
    required this.viewedNumbers,
    required this.onStarTap,
  });

  final int totalNames;
  final Set<int> learnedNumbers;
  final Set<int> viewedNumbers;
  final void Function(int number) onStarTap;

  int? _hitTest(Offset localPos, Size size) {
    const hitRadius = 14.0;
    for (int i = 0; i < totalNames; i++) {
      final pos = _starPosition(i, totalNames, size);
      if ((localPos - pos).distance <= hitRadius) return i + 1;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AspectRatio(
      aspectRatio: 1.0,
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onTapDown: (details) {
              final number = _hitTest(details.localPosition, size);
              if (number != null) onStarTap(number);
            },
            child: CustomPaint(
              painter: _ConstellationPainter(
                totalNames: totalNames,
                learnedNumbers: learnedNumbers,
                viewedNumbers: viewedNumbers,
                accentColor: colors.accent,
                viewedColor: colors.muted.withValues(alpha: 0.45),
                unknownColor: colors.muted.withValues(alpha: 0.18),
              ),
              child: const SizedBox.expand(),
            ),
          );
        },
      ),
    );
  }
}

class _ConstellationPainter extends CustomPainter {
  const _ConstellationPainter({
    required this.totalNames,
    required this.learnedNumbers,
    required this.viewedNumbers,
    required this.accentColor,
    required this.viewedColor,
    required this.unknownColor,
  });

  final int totalNames;
  final Set<int> learnedNumbers;
  final Set<int> viewedNumbers;
  final Color accentColor;
  final Color viewedColor;
  final Color unknownColor;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < totalNames; i++) {
      final number = i + 1;
      final pos = _starPosition(i, totalNames, size);
      final isLearned = learnedNumbers.contains(number);
      final isViewed = viewedNumbers.contains(number);

      if (isLearned) {
        // Halo
        canvas.drawCircle(
          pos,
          6.5,
          Paint()
            ..color = accentColor.withValues(alpha: 0.15)
            ..style = PaintingStyle.fill,
        );
        // Point lumineux
        canvas.drawCircle(pos, 3.5, Paint()..color = accentColor);
      } else if (isViewed) {
        // Point semi-brillant
        canvas.drawCircle(
          pos,
          2.5,
          Paint()
            ..color = viewedColor
            ..style = PaintingStyle.fill,
        );
        canvas.drawCircle(
          pos,
          2.5,
          Paint()
            ..color = viewedColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      } else {
        // Punctum discret
        canvas.drawCircle(pos, 1.2, Paint()..color = unknownColor);
      }
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainter old) =>
      old.learnedNumbers != learnedNumbers ||
      old.viewedNumbers != viewedNumbers ||
      old.accentColor != accentColor;
}

// ── Légende constellation ──────────────────────────────────────────────────────

class _ConstellationLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;

    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          color: colors.accent,
          radius: 4,
          label: l10n.profileLegendLearned,
        ),
        SizedBox(width: space.md),
        _LegendItem(
          color: colors.muted.withValues(alpha: 0.5),
          radius: 3,
          label: l10n.profileLegendViewed,
        ),
        SizedBox(width: space.md),
        _LegendItem(
          color: colors.muted.withValues(alpha: 0.25),
          radius: 2,
          label: l10n.profileLegendUnknown,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.radius,
    required this.label,
  });

  final Color color;
  final double radius;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.typo.caption.copyWith(color: context.colors.muted),
        ),
      ],
    );
  }
}

// ── Tuile de navigation ────────────────────────────────────────────────────────

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.count,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: radii.lgAll,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: space.md,
            vertical: space.sm + 4,
          ),
          decoration: BoxDecoration(
            color: colors.bg2,
            borderRadius: radii.lgAll,
            border: Border.all(color: colors.line),
          ),
          child: Row(
            children: [
              Icon(icon, color: colors.accent, size: 22),
              SizedBox(width: space.md),
              Expanded(child: Text(label, style: typo.body)),
              if (count != null)
                Text(
                  '$count',
                  style: typo.caption.copyWith(color: colors.muted),
                ),
              SizedBox(width: space.xs),
              Icon(
                Icons.chevron_right,
                color: colors.muted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
