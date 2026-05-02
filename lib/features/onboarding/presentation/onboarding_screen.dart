import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  void _next() => _ctrl.nextPage(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeInOut,
  );

  Future<void> _finish() async {
    await ref.read(settingsProvider.notifier).setOnboardingComplete();
    if (mounted) context.go('/home');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final space = context.space;

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: Stack(
        children: [
          PageView(
            controller: _ctrl,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) => setState(() => _page = page),
            children: [
              _WelcomePage(onNext: _next),
              _ThemePage(onNext: _next),
              _NotifPage(onFinish: _finish),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(space.xl, space.md, space.xl, 0),
              child: _OnboardingDots(current: _page, total: 3),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final selected = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: EdgeInsets.symmetric(horizontal: space.xs / 2),
          width: selected ? 24 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: selected ? colors.accent : colors.line,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;
    final compact = MediaQuery.of(context).size.height < 760;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  space.xl,
                  space.xxl,
                  space.xl,
                  space.xl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: compact ? space.sm : space.lg),
                    _OnboardingSkyPreview(
                      child: ArabicText(
                        text: l10n.onboardingSealPhrase,
                        size: compact ? ArabicSize.medium : ArabicSize.large,
                        withShadow: true,
                      ),
                    ),
                    SizedBox(height: compact ? space.md : space.xl),
                    Text(
                      l10n.onboardingWelcomeTitle,
                      textAlign: TextAlign.center,
                      style: typo.displayMedium.copyWith(color: colors.ink),
                    ),
                    SizedBox(height: space.sm),
                    Text(
                      l10n.onboardingWelcomeSubtitle,
                      textAlign: TextAlign.center,
                      style: typo.bodyLarge.copyWith(color: colors.muted),
                    ),
                    SizedBox(height: compact ? space.md : space.xl),
                    _OnboardingFeatureTile(
                      icon: Icons.travel_explore_outlined,
                      title: l10n.onboardingJourneyTitle,
                      subtitle: l10n.onboardingJourneySubtitle,
                    ),
                    SizedBox(height: space.sm),
                    _OnboardingFeatureTile(
                      icon: Icons.menu_book_outlined,
                      title: l10n.onboardingTafakkurTitle,
                      subtitle: l10n.onboardingTafakkurSubtitle,
                    ),
                    SizedBox(height: space.sm),
                    _OnboardingFeatureTile(
                      icon: Icons.volunteer_activism_outlined,
                      title: l10n.onboardingActionTitle,
                      subtitle: l10n.onboardingActionSubtitle,
                    ),
                    SizedBox(height: compact ? space.md : space.xl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onNext,
                        child: Text(l10n.onboardingWelcomeCta),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardingSkyPreview extends StatelessWidget {
  const _OnboardingSkyPreview({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;

    return AspectRatio(
      aspectRatio: 1.45,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.bg2,
          borderRadius: context.radii.lgAll,
          border: Border.all(color: colors.line),
          boxShadow: [
            BoxShadow(
              color: colors.accent.withValues(alpha: 0.08),
              blurRadius: 28,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _OnboardingSkyPainter(
            accent: colors.accent,
            accent2: colors.accent2,
            muted: colors.muted,
          ),
          child: Padding(
            padding: EdgeInsets.all(space.lg),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _OnboardingSkyPainter extends CustomPainter {
  const _OnboardingSkyPainter({
    required this.accent,
    required this.accent2,
    required this.muted,
  });

  final Color accent;
  final Color accent2;
  final Color muted;

  static const _stars = <Offset>[
    Offset(0.14, 0.22),
    Offset(0.22, 0.58),
    Offset(0.30, 0.36),
    Offset(0.42, 0.72),
    Offset(0.54, 0.24),
    Offset(0.66, 0.62),
    Offset(0.78, 0.34),
    Offset(0.86, 0.68),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final halo = Paint()
      ..shader =
          RadialGradient(
            colors: [
              accent2.withValues(alpha: 0.16),
              accent2.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: size.center(Offset.zero),
              radius: size.width,
            ),
          );
    canvas.drawCircle(size.center(Offset.zero), size.width * 0.52, halo);

    final line = Paint()
      ..color = accent.withValues(alpha: 0.16)
      ..strokeWidth = 1;
    for (var index = 0; index < _stars.length - 1; index++) {
      canvas.drawLine(
        Offset(_stars[index].dx * size.width, _stars[index].dy * size.height),
        Offset(
          _stars[index + 1].dx * size.width,
          _stars[index + 1].dy * size.height,
        ),
        line,
      );
    }

    final star = Paint()..color = muted.withValues(alpha: 0.36);
    final lit = Paint()..color = accent.withValues(alpha: 0.92);
    for (final point in _stars) {
      final center = Offset(point.dx * size.width, point.dy * size.height);
      canvas.drawCircle(center, 2.4, star);
    }
    canvas.drawCircle(
      Offset(_stars[4].dx * size.width, _stars[4].dy * size.height),
      4.2,
      lit,
    );
  }

  @override
  bool shouldRepaint(covariant _OnboardingSkyPainter oldDelegate) {
    return oldDelegate.accent != accent ||
        oldDelegate.accent2 != accent2 ||
        oldDelegate.muted != muted;
  }
}

class _OnboardingFeatureTile extends StatelessWidget {
  const _OnboardingFeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bg2.withValues(alpha: 0.76),
        borderRadius: context.radii.mdAll,
        border: Border.all(color: colors.line),
      ),
      child: Padding(
        padding: EdgeInsets.all(space.sm),
        child: Row(
          children: [
            Icon(icon, color: colors.accent, size: 22),
            SizedBox(width: space.sm),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: typo.caption.copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemePage extends ConsumerWidget {
  const _ThemePage({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;
    final current = ref.watch(settingsProvider.select((s) => s.theme));
    final notifier = ref.read(settingsProvider.notifier);

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  space.lg,
                  space.xxl,
                  space.lg,
                  space.xl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.onboardingThemeTitle,
                      textAlign: TextAlign.center,
                      style: typo.displayMedium.copyWith(color: colors.ink),
                    ),
                    SizedBox(height: space.sm),
                    Text(
                      l10n.onboardingThemeSubtitle,
                      textAlign: TextAlign.center,
                      style: typo.bodyLarge.copyWith(color: colors.muted),
                    ),
                    SizedBox(height: space.xl),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cardWidth = constraints.maxWidth < 380
                            ? (constraints.maxWidth - space.sm) / 2
                            : (constraints.maxWidth - space.sm * 2) / 3;
                        return Wrap(
                          alignment: WrapAlignment.center,
                          spacing: space.sm,
                          runSpacing: space.sm,
                          children: [
                            _ThemePreviewCard(
                              width: cardWidth,
                              themeKey: ThemeKey.light,
                              label: l10n.settingsThemeLight,
                              isSelected: current == ThemeKey.light,
                              onTap: () => notifier.setTheme(ThemeKey.light),
                            ),
                            _ThemePreviewCard(
                              width: cardWidth,
                              themeKey: ThemeKey.dark,
                              label: l10n.settingsThemeDark,
                              isSelected: current == ThemeKey.dark,
                              onTap: () => notifier.setTheme(ThemeKey.dark),
                            ),
                            _ThemePreviewCard(
                              width: cardWidth,
                              themeKey: ThemeKey.feminine,
                              label: l10n.settingsThemeFeminine,
                              isSelected: current == ThemeKey.feminine,
                              onTap: () => notifier.setTheme(ThemeKey.feminine),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: space.xl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onNext,
                        child: Text(l10n.onboardingThemeCta),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  const _ThemePreviewCard({
    required this.width,
    required this.themeKey,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final double width;
  final ThemeKey themeKey;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final preview = AppTheme.build(themeKey).extension<AppColors>()!;
    final colors = context.colors;
    final typo = context.typo;
    final radii = context.radii;
    final space = context.space;
    final labelColor = isSelected ? preview.accent : preview.ink;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radii.lg),
      child: Semantics(
        label: label,
        selected: isSelected,
        button: true,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width.clamp(104.0, 132.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radii.lg),
            border: Border.all(
              color: isSelected ? colors.accent : colors.line,
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: 0.22),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 88,
                color: preview.bg,
                child: Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: preview.accent.withValues(alpha: 0.13),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_outlined,
                      color: preview.accent,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: space.xs,
                  vertical: space.sm,
                ),
                color: preview.bg2,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: typo.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotifPage extends ConsumerStatefulWidget {
  const _NotifPage({required this.onFinish});
  final Future<void> Function() onFinish;

  @override
  ConsumerState<_NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends ConsumerState<_NotifPage> {
  int _hour = 8;

  Future<void> _pickHour() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: 0),
    );
    if (picked == null) return;
    setState(() => _hour = picked.hour);
    await ref.read(settingsProvider.notifier).setNotifHour(picked.hour);
  }

  Future<void> _activateAndFinish() async {
    await ref.read(settingsProvider.notifier).setNotifHour(_hour);
    if (mounted) await widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  space.xl,
                  space.xxl,
                  space.xl,
                  space.xl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _NotificationIcon(),
                    SizedBox(height: space.lg),
                    Text(
                      l10n.onboardingNotifTitle,
                      textAlign: TextAlign.center,
                      style: typo.displayMedium.copyWith(color: colors.ink),
                    ),
                    SizedBox(height: space.sm),
                    Text(
                      l10n.onboardingNotifSubtitle,
                      textAlign: TextAlign.center,
                      style: typo.bodyLarge.copyWith(color: colors.muted),
                    ),
                    SizedBox(height: space.xl),
                    InkWell(
                      onTap: _pickHour,
                      borderRadius: context.radii.lgAll,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(space.md),
                        decoration: BoxDecoration(
                          color: colors.bg2,
                          borderRadius: context.radii.lgAll,
                          border: Border.all(color: colors.line),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.schedule_outlined, color: colors.accent),
                            SizedBox(width: space.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.onboardingNotifTimeLabel,
                                    style: typo.caption.copyWith(
                                      color: colors.muted,
                                    ),
                                  ),
                                  SizedBox(height: space.xs / 2),
                                  Text(
                                    '${_hour.toString().padLeft(2, '0')}:00',
                                    style: typo.displayMedium.copyWith(
                                      color: colors.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Text(
                                l10n.onboardingNotifChooseTime,
                                textAlign: TextAlign.end,
                                style: typo.button.copyWith(
                                  color: colors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: space.xl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _activateAndFinish,
                        icon: const Icon(Icons.notifications_active_outlined),
                        label: Text(l10n.onboardingNotifActivate),
                      ),
                    ),
                    SizedBox(height: space.sm),
                    TextButton(
                      onPressed: widget.onFinish,
                      child: Text(
                        l10n.onboardingNotifLater,
                        style: typo.button.copyWith(color: colors.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: colors.line),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.space.lg),
        child: Icon(
          Icons.notifications_outlined,
          size: 42,
          color: colors.accent,
        ),
      ),
    );
  }
}
