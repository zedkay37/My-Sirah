import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/core/utils/hijri_utils.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/presentation/home/daily_name_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final space = context.space;

    final dailyName = ref.watch(dailyNameProvider);
    final journey = ref.watch(journeyRepositoryProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HomeHeader(),
              SizedBox(height: space.md),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: dailyName.when(
                  data: (name) {
                    final journeyRepo = journey.valueOrNull;
                    final constellation = journeyRepo
                        ?.getConstellationsForName(name.number)
                        .firstOrNull;
                    return DailyNameCard(
                      name: name,
                      constellation: constellation,
                      action: journeyRepo?.getDailyActionForName(
                        name.number,
                        DateTime.now(),
                      ),
                    );
                  },
                  loading: () => const _NameCardSkeleton(),
                  error: (_, __) => const _NameCardSkeleton(),
                ),
              ),
              if (dailyName.hasValue) ...[
                SizedBox(height: space.lg),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: space.md),
                  child: _ContinueJourneyCard(
                    name: dailyName.requireValue,
                    journey: journey.valueOrNull,
                  ),
                ),
              ],
              SizedBox(height: space.lg),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: const _HomeAccessRow(),
              ),
              SizedBox(height: space.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAccessRow extends ConsumerWidget {
  const _HomeAccessRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final space = context.space;
    final reviewCount = ref.watch(
      settingsProvider.select(
        (s) => s.leitnerBoxes.values.where((v) => v < 2).length,
      ),
    );

    return Row(
      children: [
        Expanded(
          child: _HomeAccessCard(
            icon: Icons.travel_explore_outlined,
            title: l10n.navJourney,
            subtitle: l10n.homeJourneyShortcutSubtitle,
            onTap: () => context.push('/journey'),
          ),
        ),
        SizedBox(width: space.sm),
        Expanded(
          child: _HomeAccessCard(
            icon: reviewCount > 0
                ? Icons.rate_review_outlined
                : Icons.local_library_outlined,
            title: l10n.navLibrary,
            subtitle: reviewCount > 0
                ? l10n.studyReviewSubtitle(reviewCount)
                : l10n.homeLibraryShortcutSubtitle,
            onTap: () => context.push('/library'),
          ),
        ),
      ],
    );
  }
}

class _HomeAccessCard extends StatelessWidget {
  const _HomeAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;
    final typo = context.typo;

    return InkWell(
      onTap: onTap,
      borderRadius: context.radii.mdAll,
      child: Container(
        constraints: const BoxConstraints(minHeight: 112),
        padding: EdgeInsets.all(space.md),
        decoration: BoxDecoration(
          color: colors.bg2,
          borderRadius: context.radii.mdAll,
          border: Border.all(color: colors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.accent),
            SizedBox(height: space.sm),
            Text(title, style: typo.bodyLarge.copyWith(color: colors.ink)),
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
    );
  }
}

class _ContinueJourneyCard extends StatelessWidget {
  const _ContinueJourneyCard({required this.name, required this.journey});

  final ProphetName name;
  final JourneyRepository? journey;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;
    final typo = context.typo;
    final l10n = context.l10n;
    final constellation = journey
        ?.getConstellationsForName(name.number)
        .firstOrNull;
    final nextNumber = _nextNumber(constellation, name.number);

    return InkWell(
      onTap: () => context.push('/name/$nextNumber/experience'),
      borderRadius: context.radii.lgAll,
      child: Container(
        padding: EdgeInsets.all(space.md),
        decoration: BoxDecoration(
          color: colors.bg2,
          borderRadius: context.radii.lgAll,
          border: Border.all(color: colors.line),
        ),
        child: Row(
          children: [
            Icon(Icons.travel_explore_outlined, color: colors.accent),
            SizedBox(width: space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeContinueJourneyTitle,
                    style: typo.bodyLarge.copyWith(color: colors.ink),
                  ),
                  SizedBox(height: space.xs / 2),
                  Text(
                    constellation == null
                        ? l10n.homeContinueJourneyFallback
                        : l10n.homeContinueJourneySubtitle(
                            constellation.titleFr,
                          ),
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

  int _nextNumber(NameConstellation? constellation, int currentNumber) {
    final numbers = constellation?.nameNumbers ?? const <int>[];
    if (numbers.isEmpty) return currentNumber;
    final index = numbers.indexOf(currentNumber);
    if (index < 0 || index == numbers.length - 1) return numbers.first;
    return numbers[index + 1];
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  String get _hijri => HijriUtils.format(HijriCalendar.now());

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final gregorian = DateFormat.yMMMMEEEEd(localeName).format(DateTime.now());

    return Padding(
      padding: EdgeInsets.fromLTRB(space.md, space.md, space.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.appTitle,
            style: typo.displayMedium.copyWith(color: colors.accent),
          ),
          SizedBox(height: space.xs / 2),
          Text(
            l10n.homeTagline,
            style: typo.body.copyWith(color: colors.muted),
          ),
          SizedBox(height: space.sm),
          Text(gregorian, style: typo.caption.copyWith(color: colors.muted)),
          Text(_hijri, style: typo.caption.copyWith(color: colors.muted)),
        ],
      ),
    );
  }
}

// ── Skeleton ───────────────────────────────────────────────────────────────────

class _NameCardSkeleton extends StatelessWidget {
  const _NameCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.58,
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: context.radii.lgAll,
        border: Border.all(color: colors.line),
      ),
      child: Center(
        child: CircularProgressIndicator(color: colors.accent, strokeWidth: 2),
      ),
    );
  }
}
