import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sirah_app/core/providers/husna_providers.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/core/utils/hijri_utils.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/shared/streak_badge.dart';

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
    final husnaAsync = ref.watch(husnaProvider);
    final progressResolver = ref.watch(journeyProgressResolverProvider);
    final journeySummary =
        ref.watch(journeyProgressSummaryProvider).valueOrNull ??
        progressResolver.summarize(
          List<int>.generate(201, (index) => index + 1),
        );
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
            Text(
              l10n.homeGreeting,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: typo.headline,
            ),
            Text(
              _hijriDate(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
              namesAsync.when(
                data: (names) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: space.md),
                  child: _PersonalLanternSection(
                    names: names,
                    husnaLit: settings.husnaLearned.length,
                    husnaTotal: husnaAsync.valueOrNull?.length ?? 99,
                    progress: progressResolver,
                    summary: journeySummary,
                    streak: streak,
                  ),
                ),
                loading: () => SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colors.accent,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                error: (_, __) => const SizedBox(height: 300),
              ),
              SizedBox(height: space.lg),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: _JourneySummaryGrid(summary: journeySummary),
              ),
              SizedBox(height: space.xl),
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

class _PersonalLanternSection extends StatelessWidget {
  const _PersonalLanternSection({
    required this.names,
    required this.husnaLit,
    required this.husnaTotal,
    required this.progress,
    required this.summary,
    required this.streak,
  });

  final List<ProphetName> names;
  final int husnaLit;
  final int husnaTotal;
  final NameProgressResolver progress;
  final NameProgressSummary summary;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    final prophetTotal = summary.total == 0 ? names.length : summary.total;
    final prophetLit = names
        .where(
          (name) => progress.stageFor(name.number) != JourneyNameStage.unknown,
        )
        .length;
    final safeHusnaTotal = math.max(0, husnaTotal);
    final safeHusnaLit = husnaLit.clamp(0, safeHusnaTotal).toInt();
    final total = prophetTotal + safeHusnaTotal;
    final litCount = prophetLit + safeHusnaLit;
    final progressValue = total == 0
        ? 0.0
        : (litCount / total).clamp(0.0, 1.0).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final media = MediaQuery.of(context);
        final compact =
            constraints.maxWidth < 360 ||
            media.size.height < 760 ||
            media.textScaler.scale(1) > 1.15;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: colors.bg2.withValues(alpha: 0.74),
            borderRadius: context.radii.lgAll,
            border: Border.all(color: colors.line),
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? space.md : space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.profileLanternTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typo.headline.copyWith(
                    color: colors.accent,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: space.xs),
                Text(
                  l10n.profileLanternSubtitle,
                  style: typo.body.copyWith(color: colors.muted, height: 1.35),
                ),
                SizedBox(height: space.sm),
                Wrap(
                  spacing: space.sm,
                  runSpacing: space.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      l10n.profileLanternProgress(litCount, total),
                      style: typo.caption.copyWith(color: colors.muted),
                    ),
                    if (streak > 0)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: StreakBadge(days: streak),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: space.xs),
                Text(
                  l10n.profileLanternSources,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typo.caption.copyWith(
                    color: colors.muted.withValues(alpha: 0.78),
                  ),
                ),
                SizedBox(height: compact ? space.xs : space.sm),
                _LanternProgressView(
                  progress: progressValue,
                  litCount: litCount,
                  total: total,
                  compact: compact,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LanternProgressView extends StatefulWidget {
  const _LanternProgressView({
    required this.progress,
    required this.litCount,
    required this.total,
    required this.compact,
  });

  final double progress;
  final int litCount;
  final int total;
  final bool compact;

  @override
  State<_LanternProgressView> createState() => _LanternProgressViewState();
}

class _LanternProgressViewState extends State<_LanternProgressView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final height = widget.compact ? 210.0 : 248.0;

    return Semantics(
      label: context.l10n.profileLanternSemantics(
        widget.litCount,
        widget.total,
      ),
      child: SizedBox(
        height: height,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                key: const ValueKey('profile-lantern'),
                painter: _LanternPainter(
                  animationValue: disableAnimations ? 0 : _controller.value,
                  progress: widget.progress,
                  bg: colors.bg,
                  bg2: colors.bg2,
                  ink: colors.ink,
                  muted: colors.muted,
                  line: colors.line,
                  accent: colors.accent,
                  accent2: colors.accent2,
                  warning: colors.warning,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LanternPainter extends CustomPainter {
  const _LanternPainter({
    required this.animationValue,
    required this.progress,
    required this.bg,
    required this.bg2,
    required this.ink,
    required this.muted,
    required this.line,
    required this.accent,
    required this.accent2,
    required this.warning,
  });

  final double animationValue;
  final double progress;
  final Color bg;
  final Color bg2;
  final Color ink;
  final Color muted;
  final Color line;
  final Color accent;
  final Color accent2;
  final Color warning;

  @override
  void paint(Canvas canvas, Size size) {
    final p = progress.clamp(0.0, 1.0).toDouble();
    final center = Offset(size.width / 2, size.height * 0.54);
    final cycle = animationValue * math.pi * 2;

    // Slow movement keeps the lantern alive without becoming playful.
    final sway = math.sin(cycle) * (0.01 + p * 0.012);
    final bob = math.sin(cycle) * (2.2 + p * 1.8);

    // Make the glow stay discreet early, then open up after mid-progress.
    final double glowFactor = p < 0.5
        ? (p * 0.3) // < 50% -> very soft, discreet
        : (0.15 + (p - 0.5) * 1.7).clamp(0.0, 1.0);

    final glowRadius = size.shortestSide * (0.28 + glowFactor * 0.42);
    final glowAlpha = (0.05 + glowFactor * 0.55).clamp(0.0, 0.65);
    final lanternCenter = center.translate(0, bob - size.height * 0.03);

    _drawBackground(
      canvas,
      size,
      lanternCenter,
      glowRadius,
      glowAlpha,
      glowFactor,
    );

    canvas.save();
    canvas.translate(lanternCenter.dx, lanternCenter.dy);
    canvas.rotate(sway);
    canvas.translate(-lanternCenter.dx, -lanternCenter.dy);
    _drawLantern(canvas, size, lanternCenter, p, cycle, glowFactor);
    canvas.restore();
  }

  void _drawBackground(
    Canvas canvas,
    Size size,
    Offset center,
    double glowRadius,
    double glowAlpha,
    double glowFactor,
  ) {
    // 1. Core Light source glow (inner tightly focused beam)
    final innerRadius = glowRadius * 0.55;
    canvas.drawCircle(
      center,
      innerRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            accent2.withValues(alpha: (glowAlpha * 1.35).clamp(0.0, 1.0)),
            accent.withValues(alpha: (glowAlpha * 0.5).clamp(0.0, 1.0)),
            bg.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.35, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: innerRadius)),
    );

    // 2. Wide ambient glow (more expansive when high progress)
    canvas.drawCircle(
      center,
      glowRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            accent2.withValues(alpha: glowAlpha * 0.65),
            accent.withValues(alpha: glowAlpha * 0.22),
            bg.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.48, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: glowRadius)),
    );

    // 3. Lower ambient oval reflection to create floor or surface aura
    final lowerGlowCenter = Offset(size.width / 2, size.height * 0.82);
    final lowerGlowRadius = size.width * (0.32 + glowFactor * 0.25);
    canvas.drawOval(
      Rect.fromCenter(
        center: lowerGlowCenter,
        width: lowerGlowRadius * 1.62,
        height: lowerGlowRadius * 0.76,
      ),
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                accent2.withValues(alpha: glowAlpha * 0.28),
                accent.withValues(alpha: glowAlpha * 0.08),
                bg.withValues(alpha: 0),
              ],
              stops: const [0.0, 0.42, 1.0],
            ).createShader(
              Rect.fromCircle(center: lowerGlowCenter, radius: lowerGlowRadius),
            ),
    );
  }

  void _drawLantern(
    Canvas canvas,
    Size size,
    Offset center,
    double p,
    double cycle,
    double glowFactor,
  ) {
    final scale = ((size.shortestSide / 238) * (1.0 + p * 0.12))
        .clamp(0.92, 1.28)
        .toDouble();
    final bodyWidth = 76.0 * scale;
    final bodyHeight = 108.0 * scale;
    final body = Rect.fromCenter(
      center: center,
      width: bodyWidth,
      height: bodyHeight,
    );
    final top = body.top;
    final bottom = body.bottom;
    final middleX = body.center.dx;

    // Chain drawing
    final chainPaint = Paint()
      ..color = line.withValues(alpha: 0.85)
      ..strokeWidth = 1.6 * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final anchor = Offset(middleX, top - 46 * scale);
    final hook = Offset(middleX, top - 6 * scale);
    canvas.drawLine(anchor, hook, chainPaint);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(middleX, top - 3 * scale),
        width: 26 * scale,
        height: 24 * scale,
      ),
      math.pi,
      math.pi,
      false,
      chainPaint,
    );

    // Main Body Frame
    final bodyRRect = RRect.fromRectAndRadius(
      body,
      Radius.circular(24 * scale),
    );
    canvas.drawRRect(bodyRRect, Paint()..color = bg2.withValues(alpha: 0.82));
    canvas.drawRRect(
      bodyRRect,
      Paint()
        ..color = line.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3 * scale,
    );

    // Cap & Base
    final capPaint = Paint()..color = accent2.withValues(alpha: 0.88);
    // Elaborate premium lantern dome cap
    final capPath = Path();
    capPath.moveTo(middleX - bodyWidth * 0.42, top + 15 * scale);
    capPath.quadraticBezierTo(
      middleX,
      top - 4 * scale,
      middleX + bodyWidth * 0.42,
      top + 15 * scale,
    );
    capPath.lineTo(middleX + bodyWidth * 0.32, top + 24 * scale);
    capPath.lineTo(middleX - bodyWidth * 0.32, top + 24 * scale);
    capPath.close();
    canvas.drawPath(capPath, capPaint);

    // Decorative base cap
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(middleX, bottom - 11 * scale),
          width: bodyWidth * 0.84,
          height: 16 * scale,
        ),
        Radius.circular(9 * scale),
      ),
      capPaint,
    );

    // Glowing Inner Glass
    final glass = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center.translate(0, 3 * scale),
        width: bodyWidth * 0.58,
        height: bodyHeight * 0.54,
      ),
      Radius.circular(16 * scale),
    );
    canvas.drawRRect(
      glass,
      Paint()
        ..shader = RadialGradient(
          colors: [
            accent2.withValues(alpha: 0.32 + glowFactor * 0.32),
            accent.withValues(alpha: 0.12 + glowFactor * 0.12),
            bg.withValues(alpha: 0.02),
          ],
        ).createShader(glass.outerRect),
    );
    canvas.drawRRect(
      glass,
      Paint()
        ..color = line.withValues(alpha: 0.52)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9 * scale,
    );

    // Two flame layers give a warmer core while keeping the shape readable.
    final breathe = math.sin(cycle) * 0.04;
    final flameHeight = (26 + p * 18 + breathe * 12) * scale;
    final flameWidth = (14 + p * 10 + breathe * 6) * scale;
    final flameBase = center.translate(0, 20 * scale);

    // Layer 1: Outer soft flame aura (amber/accent)
    final outerFlame = Path()
      ..moveTo(flameBase.dx, flameBase.dy - flameHeight)
      ..cubicTo(
        flameBase.dx - flameWidth,
        flameBase.dy - flameHeight * 0.58,
        flameBase.dx - flameWidth * 0.72,
        flameBase.dy - flameHeight * 0.08,
        flameBase.dx,
        flameBase.dy,
      )
      ..cubicTo(
        flameBase.dx + flameWidth * 0.82,
        flameBase.dy - flameHeight * 0.18,
        flameBase.dx + flameWidth * 0.66,
        flameBase.dy - flameHeight * 0.74,
        flameBase.dx,
        flameBase.dy - flameHeight,
      );
    canvas.drawPath(
      outerFlame,
      Paint()
        ..shader = RadialGradient(
          colors: [
            accent2.withValues(alpha: 0.95),
            accent.withValues(alpha: 0.68),
          ],
        ).createShader(outerFlame.getBounds()),
    );

    // Layer 2: bright inner flame.
    final innerFlameHeight = flameHeight * 0.65;
    final innerFlameWidth = flameWidth * 0.58;
    final innerFlame = Path()
      ..moveTo(flameBase.dx, flameBase.dy - innerFlameHeight)
      ..cubicTo(
        flameBase.dx - innerFlameWidth,
        flameBase.dy - innerFlameHeight * 0.55,
        flameBase.dx - innerFlameWidth * 0.65,
        flameBase.dy - innerFlameHeight * 0.05,
        flameBase.dx,
        flameBase.dy,
      )
      ..cubicTo(
        flameBase.dx + innerFlameWidth * 0.75,
        flameBase.dy - innerFlameHeight * 0.16,
        flameBase.dx + innerFlameWidth * 0.62,
        flameBase.dy - innerFlameHeight * 0.72,
        flameBase.dx,
        flameBase.dy - innerFlameHeight,
      );
    canvas.drawPath(
      innerFlame,
      Paint()
        ..shader = RadialGradient(
          colors: [
            warning.withValues(alpha: 0.96),
            accent2.withValues(alpha: 0.88),
          ],
        ).createShader(innerFlame.getBounds()),
    );

    // Delicate metallic decorative side structures
    final sidePaint = Paint()
      ..color = muted.withValues(alpha: 0.44)
      ..strokeWidth = 1.1 * scale
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(body.left + 15 * scale, top + 22 * scale),
      Offset(body.left + 11 * scale, bottom - 22 * scale),
      sidePaint,
    );
    canvas.drawLine(
      Offset(body.right - 15 * scale, top + 22 * scale),
      Offset(body.right - 11 * scale, bottom - 22 * scale),
      sidePaint,
    );
  }

  @override
  bool shouldRepaint(_LanternPainter old) =>
      old.animationValue != animationValue ||
      old.progress != progress ||
      old.bg != bg ||
      old.bg2 != bg2 ||
      old.ink != ink ||
      old.muted != muted ||
      old.line != line ||
      old.accent != accent ||
      old.accent2 != accent2;
}

class _JourneySummaryGrid extends StatelessWidget {
  const _JourneySummaryGrid({required this.summary});

  final NameProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final space = context.space;

    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 320;
        final tileWidth = twoColumns
            ? (constraints.maxWidth - space.sm) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: space.sm,
          runSpacing: space.sm,
          children: [
            _JourneyMetric(
              width: tileWidth,
              icon: Icons.star_rounded,
              label: l10n.profileJourneyViewed,
              value: summary.viewed,
            ),
            _JourneyMetric(
              width: tileWidth,
              icon: Icons.self_improvement_rounded,
              label: l10n.profileJourneyMeditated,
              value: summary.meditated,
            ),
            _JourneyMetric(
              width: tileWidth,
              icon: Icons.check_circle_rounded,
              label: l10n.profileJourneyPracticed,
              value: summary.practiced,
            ),
            _JourneyMetric(
              width: tileWidth,
              icon: Icons.workspace_premium_rounded,
              label: l10n.profileJourneyRecognized,
              value: summary.recognized,
            ),
          ],
        );
      },
    );
  }
}

class _JourneyMetric extends StatelessWidget {
  const _JourneyMetric({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
  });

  final double width;
  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.bg2,
          borderRadius: radii.mdAll,
          border: Border.all(color: colors.line),
        ),
        child: Padding(
          padding: EdgeInsets.all(space.sm),
          child: Row(
            children: [
              Icon(icon, color: colors.accent, size: 18),
              SizedBox(width: space.xs),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typo.caption.copyWith(color: colors.muted),
                ),
              ),
              SizedBox(width: space.xs),
              Text('$value', style: typo.body),
            ],
          ),
        ),
      ),
    );
  }
}

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
              Icon(Icons.chevron_right, color: colors.muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
