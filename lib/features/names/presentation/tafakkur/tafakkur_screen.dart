import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/data/names_notifier.dart';
import 'package:sirah_app/features/names/presentation/tafakkur/tafakkur_controller.dart';
import 'package:sirah_app/features/names/presentation/tafakkur/widgets/tafakkur_overlay.dart';
import 'package:sirah_app/features/names/presentation/tafakkur/widgets/tafakkur_progress_bar.dart';
import 'package:sirah_app/features/names/presentation/tafakkur/widgets/tafakkur_settings_sheet.dart';

class TafakkurScreen extends ConsumerWidget {
  const TafakkurScreen({super.key, required this.nameNumber});

  final int nameNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namesAsync = ref.watch(namesProvider);
    final journeyAsync = ref.watch(journeyRepositoryProvider);

    return namesAsync.when(
      loading: () => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: context.colors.accent),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Icon(Icons.error_outline, color: context.colors.muted),
        ),
      ),
      data: (names) {
        final name = names.firstWhere(
          (n) => n.number == nameNumber,
          orElse: () => names.first,
        );

        return journeyAsync.when(
          loading: () => Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: context.colors.accent),
            ),
          ),
          error: (_, __) => _TafakkurContent(
            name: name,
            journey: null,
            nameNumber: nameNumber,
          ),
          data: (journey) => _TafakkurContent(
            name: name,
            journey: journey,
            nameNumber: nameNumber,
          ),
        );
      },
    );
  }
}

class _TafakkurContent extends ConsumerWidget {
  const _TafakkurContent({
    required this.name,
    required this.journey,
    required this.nameNumber,
  });

  final ProphetName name;
  final JourneyRepository? journey;
  final int nameNumber;

  Future<bool> _onWillPop(
    BuildContext context,
    WidgetRef ref,
    String sessionText,
  ) async {
    final state = ref.read(tafakkurControllerProvider(sessionText));
    if (state.isComplete) return true;

    final controller = ref.read(
      tafakkurControllerProvider(sessionText).notifier,
    );
    controller.pause();

    final l10n = context.l10n;
    final colors = context.colors;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bg,
        title: Text(l10n.tafakkurExitConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.tafakkurExitConfirmNo,
              style: TextStyle(color: colors.ink),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.tafakkurExitConfirmYes,
              style: TextStyle(color: colors.error),
            ),
          ),
        ],
      ),
    );

    if (shouldPop != true) {
      controller.resume();
    }
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = _buildPages(context, name, journey);
    final sessionText = pages.map((p) => p.body).join(tafakkurPageSeparator);

    ref.listen(tafakkurControllerProvider(sessionText), (prev, next) {
      if (prev?.isComplete != true && next.isComplete) {
        ref.read(namesNotifierProvider).markNameMeditated(nameNumber);
      }
    });

    final state = ref.watch(tafakkurControllerProvider(sessionText));
    final controller = ref.read(
      tafakkurControllerProvider(sessionText).notifier,
    );
    final colors = context.colors;
    final currentPage = pages[state.currentIndex.clamp(0, pages.length - 1)];
    final estimatedMinutes = _estimatedMinutes(
      pageCount: pages.length,
      paceSeconds: state.paceSeconds,
    );

    return PopScope(
      canPop: state.isComplete,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(context, ref, sessionText);
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            if (!state.isComplete) {
              controller.togglePause();
            }
          },
          onHorizontalDragEnd: (details) {
            if (state.isComplete) return;
            final velocity = details.primaryVelocity ?? 0;
            if (velocity < -120) {
              controller.next();
            } else if (velocity > 120) {
              controller.previous();
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              TafakkurOverlay(darknessLevel: state.darknessLevel),
              SafeArea(
                child: Column(
                  children: [
                    if (!state.isComplete)
                      TafakkurProgressBar(
                        current: state.currentIndex,
                        total: state.phrases.length,
                      ),
                    Expanded(
                      child: state.isComplete
                          ? _CompleteView(pages: pages)
                          : _TafakkurPageDisplay(
                              title: currentPage.title,
                              body: state.currentPhrase,
                              index: state.currentIndex,
                              total: state.phrases.length,
                            ),
                    ),
                    if (!state.isComplete)
                      _BottomControls(
                        canGoBack: state.currentIndex > 0,
                        canGoForward: !state.isComplete,
                        isPaused: state.isPaused,
                        remaining: state.remaining,
                        estimatedMinutes: estimatedMinutes,
                        paceSeconds: state.paceSeconds,
                        onPrevious: controller.previous,
                        onNext: controller.next,
                        onSettingsTap: () {
                          controller.pause();
                          showModalBottomSheet<void>(
                            context: context,
                            backgroundColor: colors.bg,
                            builder: (ctx) => TafakkurSettingsSheet(
                              currentPace: state.paceSeconds,
                              onPaceChanged: controller.setPace,
                            ),
                          ).then((_) {
                            if (!state.isComplete) controller.resume();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _estimatedMinutes({required int pageCount, required int paceSeconds}) {
    final seconds = pageCount * paceSeconds;
    return (seconds / 60).ceil().clamp(1, 999);
  }

  List<_TafakkurPage> _buildPages(
    BuildContext context,
    ProphetName name,
    JourneyRepository? journey,
  ) {
    final l10n = context.l10n;
    final experience = journey?.getExperienceForName(name.number);
    final story = experience == null ? null : _firstValidatedStory(experience);
    final action = journey?.getDailyActionForName(name.number, DateTime.now());

    return [
      _TafakkurPage(
        title: l10n.tafakkurPageName,
        body: '${name.arabic}\n\n${name.transliteration}\n\n${name.etymology}',
      ),
      _TafakkurPage(
        title: l10n.tafakkurPageStory,
        body: story == null
            ? name.commentary
            : '${story.titleFr}\n\n${story.bodyFr}',
      ),
      _TafakkurPage(
        title: l10n.tafakkurPageMeditation,
        body: experience?.tafakkurPromptFr ?? l10n.nameExperienceFallbackPrompt,
      ),
      _TafakkurPage(
        title: l10n.tafakkurPageIntention,
        body: action?.textFr ?? l10n.nameExperienceFallbackAction,
      ),
    ];
  }

  NameStory? _firstValidatedStory(NameExperience experience) {
    for (final story in experience.stories) {
      if (story.editorialStatus == 'validated') return story;
    }
    return null;
  }
}

class _CompleteView extends StatelessWidget {
  const _CompleteView({required this.pages});

  final List<_TafakkurPage> pages;

  @override
  Widget build(BuildContext context) {
    final typo = context.typo;
    final colors = context.colors;
    final l10n = context.l10n;

    final space = context.space;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: space.xl,
              vertical: space.xxl,
            ),
            itemCount: pages.length,
            separatorBuilder: (_, __) => SizedBox(height: space.lg),
            itemBuilder: (ctx, i) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  pages[i].title,
                  textAlign: TextAlign.center,
                  style: typo.caption.copyWith(color: colors.accent),
                ),
                SizedBox(height: space.sm),
                Text(
                  pages[i].body,
                  textAlign: TextAlign.center,
                  style: typo.bodyLarge.copyWith(
                    color: colors.ink,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(space.xl),
          child: Column(
            children: [
              Text(
                l10n.tafakkurComplete,
                style: typo.body.copyWith(color: colors.muted),
              ),
              SizedBox(height: space.md),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accent,
                  foregroundColor: colors.bg,
                ),
                child: Text(l10n.tafakkurReturn),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TafakkurPage {
  const _TafakkurPage({required this.title, required this.body});

  final String title;
  final String body;
}

class _TafakkurPageDisplay extends StatelessWidget {
  const _TafakkurPageDisplay({
    required this.title,
    required this.body,
    required this.index,
    required this.total,
  });

  final String title;
  final String body;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final typo = context.typo;
    final colors = context.colors;
    final space = context.space;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final progress = total > 1 ? index / (total - 1) : 1.0;
    final targetFontSize = 20.0 + (progress * 5.0);
    final animationDuration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 450);
    final switchDuration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 380);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: space.xl,
          vertical: space.xxl,
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: targetFontSize),
          duration: animationDuration,
          curve: Curves.easeInOut,
          builder: (context, fontSize, _) {
            return AnimatedSwitcher(
              duration: switchDuration,
              child: Column(
                key: ValueKey(index),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: typo.caption.copyWith(color: colors.accent),
                  ),
                  SizedBox(height: space.lg),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: typo.bodyLarge.copyWith(
                      color: colors.ink,
                      fontSize: fontSize,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: space.lg),
                  Text(
                    context.l10n.tafakkurSwipeHint,
                    textAlign: TextAlign.center,
                    style: typo.caption.copyWith(color: colors.muted),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.canGoBack,
    required this.canGoForward,
    required this.isPaused,
    required this.remaining,
    required this.estimatedMinutes,
    required this.paceSeconds,
    required this.onPrevious,
    required this.onNext,
    required this.onSettingsTap,
  });

  final bool canGoBack;
  final bool canGoForward;
  final bool isPaused;
  final int remaining;
  final int estimatedMinutes;
  final int paceSeconds;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final l10n = context.l10n;

    final space = context.space;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: space.md, vertical: space.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: l10n.tafakkurSettingsTooltip,
                icon: Icon(Icons.settings_outlined, color: colors.muted),
                onPressed: onSettingsTap,
              ),
              SizedBox(width: space.sm),
              IconButton.filledTonal(
                tooltip: l10n.tafakkurPrevious,
                onPressed: canGoBack ? onPrevious : null,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              SizedBox(width: space.sm),
              IconButton.filled(
                tooltip: l10n.tafakkurNext,
                onPressed: canGoForward ? onNext : null,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          SizedBox(height: space.sm),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: space.md,
            runSpacing: space.xs,
            children: [
              AnimatedSwitcher(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 300),
                child: isPaused
                    ? Text(
                        l10n.tafakkurPause,
                        key: const ValueKey('paused'),
                        style: typo.caption.copyWith(color: colors.accent),
                      )
                    : const SizedBox.shrink(key: ValueKey('playing')),
              ),
              Text(
                l10n.tafakkurEstimatedDuration(estimatedMinutes),
                style: typo.caption.copyWith(color: colors.muted),
              ),
              Text(
                l10n.tafakkurRemaining(remaining),
                style: typo.caption.copyWith(color: colors.muted),
              ),
            ],
          ),
          SizedBox(height: space.xs),
          Text(
            l10n.tafakkurPaceSummary(paceSeconds),
            style: typo.caption.copyWith(
              color: colors.muted.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}
