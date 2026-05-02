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
              SizedBox(height: space.sm),
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
                SizedBox(height: space.sm),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: space.md),
                  child: _ResumeJourneyCard(
                    names: namesAsync.requireValue,
                    lastSeen: lastSeen,
                    summary: journeySummary,
                  ),
                ),
              ] else ...[
                SizedBox(height: space.sm),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: space.md),
                  child: _JourneyTrace(summary: journeySummary),
                ),
              ],
              SizedBox(height: space.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumeJourneyCard extends StatelessWidget {
  const _ResumeJourneyCard({
    required this.names,
    required this.lastSeen,
    required this.summary,
  });

  final List<ProphetName> names;
  final Map<int, DateTime> lastSeen;
  final AsyncValue<NameProgressSummary> summary;

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
                    _subtitle(context, name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

  String _subtitle(BuildContext context, ProphetName name) {
    final value = summary.valueOrNull;
    if (value == null) {
      return context.l10n.homeResumeSubtitle(name.transliteration);
    }
    return context.l10n.homeResumeProgressSubtitle(
      name.transliteration,
      value.viewed,
      value.meditated,
      value.recognized,
    );
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

  String _capitalizeFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;
    final media = MediaQuery.of(context);
    final compact = media.size.height < 900 || media.size.width < 460;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final gregorian = _capitalizeFirst(
      DateFormat.yMMMMEEEEd(localeName).format(DateTime.now()),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(space.md, space.md, space.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.appTitle,
            style: typo.displayMedium.copyWith(color: colors.accent),
          ),
          if (!compact) ...[
            SizedBox(height: space.xs / 2),
            Text(
              l10n.homeTagline,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: typo.body.copyWith(color: colors.muted),
            ),
          ],
          SizedBox(height: compact ? space.xs : space.sm),
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
      height: (screenHeight * 0.50).clamp(420.0, 540.0),
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
