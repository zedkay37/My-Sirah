import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/core/utils/hijri_utils.dart';
import 'package:sirah_app/features/names/presentation/home/category_carousel.dart';
import 'package:sirah_app/features/names/presentation/home/daily_name_card.dart';
import 'package:sirah_app/features/shared/section_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final space = context.space;

    final dailyName = ref.watch(dailyNameProvider);
    final categories = ref.watch(categoriesProvider);
    final learnedCounts = ref.watch(learnedCountsProvider);

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
                  data: (name) => DailyNameCard(name: name),
                  loading: () => const _NameCardSkeleton(),
                  error: (_, __) => const _NameCardSkeleton(),
                ),
              ),
              SizedBox(height: space.lg),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: space.md),
                child: SectionHeader(title: l10n.homeCategorySection),
              ),
              SizedBox(height: space.sm),
              categories.when(
                data: (cats) => CategoryCarousel(
                  categories: cats,
                  learnedCounts: learnedCounts,
                ),
                loading: () => const SizedBox(height: 130),
                error: (_, __) => const SizedBox(height: 130),
              ),
              SizedBox(height: space.xl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  static const _monthsFr = [
    'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
  ];

  static const _daysFr = [
    'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche',
  ];

  String get _gregorian {
    final now = DateTime.now();
    return '${_daysFr[now.weekday - 1]} ${now.day} ${_monthsFr[now.month - 1]} ${now.year}';
  }

  String get _hijri => HijriUtils.format(HijriCalendar.now());

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

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
          Text(
            _gregorian,
            style: typo.caption.copyWith(color: colors.muted),
          ),
          Text(
            _hijri,
            style: typo.caption.copyWith(color: colors.muted),
          ),
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
        child: CircularProgressIndicator(
          color: colors.accent,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

