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
    return Scaffold(
      backgroundColor: context.colors.bg,
      body: PageView(
        controller: _ctrl,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _WelcomePage(onNext: _next),
          _ThemePage(onNext: _next),
          _NotifPage(onFinish: _finish),
        ],
      ),
    );
  }
}

// ── Page 1 : Bienvenue ─────────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: space.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: space.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  colors.accent.withValues(alpha: 0),
                  colors.accent,
                  colors.accent.withValues(alpha: 0),
                ]),
              ),
            ),
            SizedBox(height: space.lg),
            const ArabicText(
              text: 'مُحَمَّدٌ رَّسُولُ اللهِ ﷺ',
              size: ArabicSize.large,
            ),
            SizedBox(height: space.xl),
            Text(
              l10n.onboardingWelcomeTitle,
              textAlign: TextAlign.center,
              style: typo.displayMedium,
            ),
            SizedBox(height: space.md),
            Text(
              l10n.onboardingWelcomeSubtitle,
              textAlign: TextAlign.center,
              style: typo.bodyLarge.copyWith(color: colors.muted),
            ),
            const Spacer(flex: 3),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onNext,
                child: Text(l10n.onboardingWelcomeCta),
              ),
            ),
            SizedBox(height: space.xl),
          ],
        ),
      ),
    );
  }
}

// ── Page 2 : Thème ─────────────────────────────────────────────────────────────

class _ThemePage extends ConsumerWidget {
  const _ThemePage({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;
    final current = ref.watch(settingsProvider.select((s) => s.theme));
    final notifier = ref.read(settingsProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: space.lg),
        child: Column(
          children: [
            const Spacer(),
            Text(
              l10n.onboardingThemeTitle,
              textAlign: TextAlign.center,
              style: typo.displayMedium,
            ),
            SizedBox(height: space.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ThemePreviewCard(
                  themeKey: ThemeKey.light,
                  label: l10n.settingsThemeLight,
                  isSelected: current == ThemeKey.light,
                  onTap: () => notifier.setTheme(ThemeKey.light),
                ),
                _ThemePreviewCard(
                  themeKey: ThemeKey.dark,
                  label: l10n.settingsThemeDark,
                  isSelected: current == ThemeKey.dark,
                  onTap: () => notifier.setTheme(ThemeKey.dark),
                ),
                _ThemePreviewCard(
                  themeKey: ThemeKey.feminine,
                  label: l10n.settingsThemeFeminine,
                  isSelected: current == ThemeKey.feminine,
                  onTap: () => notifier.setTheme(ThemeKey.feminine),
                ),
              ],
            ),
            const Spacer(flex: 2),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onNext,
                child: Text(l10n.onboardingThemeCta),
              ),
            ),
            SizedBox(height: space.xl),
          ],
        ),
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  const _ThemePreviewCard({
    required this.themeKey,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final ThemeKey themeKey;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Preview colors come from the target theme, not the active one — justified exception
    final preview = AppTheme.build(themeKey).extension<AppColors>()!;
    final colors = context.colors;
    final typo = context.typo;
    final radii = context.radii;

    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        label: label,
        selected: isSelected,
        button: true,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radii.lg),
            border: Border.all(
              color: isSelected ? colors.accent : colors.line,
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: 0.25),
                      blurRadius: 12,
                    )
                  ]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 80,
                color: preview.bg,
                child: Center(
                  child: Text(
                    'ﷴ',
                    style: TextStyle(fontSize: 40, color: preview.accent),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: preview.bg2,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: typo.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? colors.accent : colors.ink,
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

// ── Page 3 : Notifications ─────────────────────────────────────────────────────

class _NotifPage extends ConsumerStatefulWidget {
  const _NotifPage({required this.onFinish});
  final Future<void> Function() onFinish;

  @override
  ConsumerState<_NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends ConsumerState<_NotifPage> {
  int _hour = 8;

  Future<void> _activateAndFinish() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: 0),
    );
    if (picked != null) {
      setState(() => _hour = picked.hour);
      await ref.read(settingsProvider.notifier).setNotifHour(picked.hour);
    }
    if (mounted) await widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: space.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Icon(Icons.notifications_outlined, size: 64, color: colors.accent),
            SizedBox(height: space.lg),
            Text(
              l10n.onboardingNotifTitle,
              textAlign: TextAlign.center,
              style: typo.displayMedium,
            ),
            SizedBox(height: space.sm),
            Text(
              l10n.onboardingNotifSubtitle,
              textAlign: TextAlign.center,
              style: typo.bodyLarge.copyWith(color: colors.muted),
            ),
            SizedBox(height: space.xl),
            GestureDetector(
              onTap: _activateAndFinish,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: space.xxl,
                  vertical: space.md,
                ),
                decoration: BoxDecoration(
                  color: colors.bg2,
                  borderRadius: BorderRadius.circular(radii.lg),
                  border: Border.all(color: colors.line),
                ),
                child: Text(
                  '${_hour.toString().padLeft(2, '0')}:00',
                  style: typo.displayLarge.copyWith(color: colors.accent),
                ),
              ),
            ),
            const Spacer(flex: 3),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _activateAndFinish,
                child: Text(l10n.onboardingNotifActivate),
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
            SizedBox(height: space.xl),
          ],
        ),
      ),
    );
  }
}
