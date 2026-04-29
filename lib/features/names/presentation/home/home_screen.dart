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
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/presentation/home/daily_name_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final space = context.space;

    final dailyName = ref.watch(dailyNameProvider);
    final namesAsync = ref.watch(namesProvider);
    final journey = ref.watch(journeyRepositoryProvider);
    final lastSeen = ref.watch(settingsProvider.select((s) => s.lastSeen));
    final journeySummary = ref.watch(journeyProgressSummaryProvider);

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
              if (namesAsync.hasValue && lastSeen.isNotEmpty) ...[
                SizedBox(height: space.lg),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: space.md),
                  child: _ResumeJourneyCard(
                    names: namesAsync.requireValue,
                    lastSeen: lastSeen,
                  ),
                ),
              ],
              SizedBox(height: space.lg),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: _JourneyTrace(summary: journeySummary),
              ),
              SizedBox(height: space.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumeJourneyCard extends StatelessWidget {
  const _ResumeJourneyCard({required this.names, required this.lastSeen});

  final List<ProphetName> names;
  final Map<int, DateTime> lastSeen;

  @override
  Widget build(BuildContext context) {
    final latest = _latestSeen();
    if (latest == null) return const SizedBox.shrink();

    final name = _nameByNumber(latest.key);
    if (name == null) return const SizedBox.shrink();

    final colors = context.colors;
    final space = context.space;
    final typo = context.typo;
    final l10n = context.l10n;

    return InkWell(
      onTap: () => context.push('/name/${name.number}/experience'),
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
            Icon(Icons.auto_awesome_motion_outlined, color: colors.accent),
            SizedBox(width: space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeResumeTitle,
                    style: typo.bodyLarge.copyWith(color: colors.ink),
                  ),
                  SizedBox(height: space.xs / 2),
                  Text(
                    l10n.homeResumeSubtitle(name.transliteration),
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

  MapEntry<int, DateTime>? _latestSeen() {
    if (lastSeen.isEmpty) return null;
    return lastSeen.entries.reduce((a, b) => a.value.isAfter(b.value) ? a : b);
  }

  ProphetName? _nameByNumber(int number) {
    for (final name in names) {
      if (name.number == number) return name;
    }
    return null;
  }
}

class _JourneyTrace extends StatelessWidget {
  const _JourneyTrace({required this.summary});

  final AsyncValue<NameProgressSummary> summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;

    final value = summary.valueOrNull;
    if (value == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: space.md, vertical: space.sm),
      decoration: BoxDecoration(
        color: colors.bg2.withValues(alpha: 0.62),
        borderRadius: context.radii.mdAll,
        border: Border.all(color: colors.line),
      ),
      child: Row(
        children: [
          Icon(Icons.timeline_outlined, color: colors.muted, size: 18),
          SizedBox(width: space.sm),
          Expanded(
            child: Text(
              context.l10n.homeJourneyTrace(
                value.viewed,
                value.meditated,
                value.recognized,
              ),
              style: typo.caption.copyWith(color: colors.muted),
            ),
          ),
        ],
      ),
    );
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
