import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';
import 'package:sirah_app/features/shared/section_header.dart';

class NameExperienceScreen extends ConsumerStatefulWidget {
  const NameExperienceScreen({super.key, required this.nameNumber});

  final int nameNumber;

  @override
  ConsumerState<NameExperienceScreen> createState() =>
      _NameExperienceScreenState();
}

class _NameExperienceScreenState extends ConsumerState<NameExperienceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(settingsProvider.notifier).markViewed(widget.nameNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final namesAsync = ref.watch(namesProvider);
    final journeyAsync = ref.watch(journeyRepositoryProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        title: Text(
          context.l10n.nameExperienceTitle,
          style: context.typo.caption.copyWith(color: colors.muted),
        ),
      ),
      body: namesAsync.when(
        loading: () => _Loading(color: colors.accent),
        error: (_, __) => const _ErrorMessage(),
        data: (names) {
          final name = _findName(names, widget.nameNumber);
          if (name == null) return const _ErrorMessage();

          return journeyAsync.when(
            loading: () => _Loading(color: colors.accent),
            error: (_, __) => _ExperienceContent(
              name: name,
              constellations: const [],
              experience: null,
              action: null,
            ),
            data: (journey) => _ExperienceContent(
              name: name,
              constellations: journey.getConstellationsForName(name.number),
              experience: journey.getExperienceForName(name.number),
              action: _specificActionFor(journey, name.number),
            ),
          );
        },
      ),
    );
  }

  NameActionItem? _specificActionFor(JourneyRepository journey, int number) {
    final experience = journey.getExperienceForName(number);
    if (experience == null || experience.practiceTheme == 'general') {
      return null;
    }
    return journey.getDailyActionForName(number, DateTime.now());
  }

  ProphetName? _findName(List<ProphetName> names, int number) {
    try {
      return names.firstWhere((n) => n.number == number);
    } on StateError {
      return null;
    }
  }
}

class _ExperienceContent extends StatelessWidget {
  const _ExperienceContent({
    required this.name,
    required this.constellations,
    required this.experience,
    required this.action,
  });

  final ProphetName name;
  final List<NameConstellation> constellations;
  final NameExperience? experience;
  final NameActionItem? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;
    final typo = context.typo;
    final stories = experience?.stories ?? const <NameStory>[];
    final primaryStory = stories.isEmpty ? null : stories.first;
    final canShowPrimaryStory = primaryStory?.editorialStatus == 'validated';

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(space.md, space.lg, space.md, space.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '#${name.number.toString().padLeft(3, '0')}',
            textAlign: TextAlign.center,
            style: typo.caption.copyWith(color: colors.muted),
          ),
          SizedBox(height: space.md),
          ArabicText(
            text: name.arabic,
            size: ArabicSize.hero,
            withShadow: true,
          ),
          SizedBox(height: space.sm),
          Text(
            name.transliteration,
            textAlign: TextAlign.center,
            style: typo.displayMedium.copyWith(
              color: colors.ink,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: space.lg),
          Text(
            name.etymology,
            textAlign: TextAlign.center,
            style: typo.bodyLarge.copyWith(color: colors.muted, height: 1.45),
          ),
          SizedBox(height: space.xl),
          if (constellations.isNotEmpty) ...[
            Wrap(
              alignment: WrapAlignment.center,
              spacing: space.sm,
              runSpacing: space.sm,
              children: [
                for (final constellation in constellations)
                  _ConstellationPill(constellation: constellation),
              ],
            ),
            SizedBox(height: space.xl),
          ],
          _PrimaryActions(nameNumber: name.number),
          SizedBox(height: space.xl),
          SectionHeader(
            title: !canShowPrimaryStory
                ? context.l10n.nameExperienceUnderstand
                : context.l10n.nameExperienceStory,
          ),
          SizedBox(height: space.md),
          if (!canShowPrimaryStory)
            _MutedPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.commentary.isNotEmpty
                        ? name.commentary
                        : context.l10n.nameExperienceFallbackPrompt,
                    style: typo.bodyLarge.copyWith(
                      color: colors.ink,
                      height: 1.5,
                    ),
                  ),
                  if (name.references.isNotEmpty) ...[
                    SizedBox(height: space.md),
                    Text(
                      context.l10n.detailSectionReferences,
                      style: typo.caption.copyWith(color: colors.muted),
                    ),
                    SizedBox(height: space.xs),
                    Text(
                      name.references,
                      style: typo.caption.copyWith(
                        color: colors.muted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            )
          else
            _StoryPanel(story: primaryStory!),
          SizedBox(height: space.xl),
          SectionHeader(title: context.l10n.nameExperienceTafakkur),
          SizedBox(height: space.md),
          _MutedPanel(
            child: Text(
              experience?.tafakkurPromptFr ??
                  context.l10n.nameExperienceFallbackPrompt,
              style: typo.bodyLarge.copyWith(color: colors.ink, height: 1.5),
            ),
          ),
          if (action != null) ...[
            SizedBox(height: space.xl),
            SectionHeader(title: context.l10n.nameExperienceActionOfDay),
            SizedBox(height: space.md),
            _ActionPanel(action: action!, nameNumber: name.number),
          ],
          SizedBox(height: space.xl),
          OutlinedButton.icon(
            onPressed: () => context.push('/name/${name.number}'),
            icon: const Icon(Icons.menu_book_outlined),
            label: Text(context.l10n.nameExperienceOpenClassic),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions({required this.nameNumber});

  final int nameNumber;

  @override
  Widget build(BuildContext context) {
    final space = context.space;

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => context.push('/name/$nameNumber/tafakkur'),
            icon: const Icon(Icons.self_improvement_rounded),
            label: Text(context.l10n.nameExperienceEnterTafakkur),
          ),
        ),
        SizedBox(width: space.sm),
        IconButton.filledTonal(
          tooltip: context.l10n.nameExperienceClassicTooltip,
          onPressed: () => context.push('/name/$nameNumber'),
          icon: const Icon(Icons.article_outlined),
        ),
      ],
    );
  }
}

class _ConstellationPill extends StatelessWidget {
  const _ConstellationPill({required this.constellation});

  final NameConstellation constellation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final color = _hexToColor(constellation.colorHex);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.55)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          constellation.titleFr,
          style: typo.caption.copyWith(color: colors.ink),
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    final normalized = hex.replaceFirst('#', '');
    return Color(int.parse('FF$normalized', radix: 16));
  }
}

class _StoryPanel extends StatelessWidget {
  const _StoryPanel({required this.story});

  final NameStory story;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;
    final typo = context.typo;

    return _MutedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(story.titleFr, style: typo.headline.copyWith(color: colors.ink)),
          SizedBox(height: space.md),
          Text(
            story.bodyFr,
            style: typo.bodyLarge.copyWith(color: colors.ink, height: 1.5),
          ),
          if (story.sourceNote.isNotEmpty) ...[
            SizedBox(height: space.md),
            Text(
              story.sourceNote,
              style: typo.caption.copyWith(color: colors.muted, height: 1.35),
            ),
          ],
          if (story.sourceRefs.isNotEmpty) ...[
            SizedBox(height: space.md),
            Text(
              context.l10n.detailSectionReferences,
              style: typo.caption.copyWith(color: colors.muted),
            ),
            SizedBox(height: space.xs),
            for (final sourceRef in story.sourceRefs)
              Padding(
                padding: EdgeInsets.only(bottom: space.xs / 2),
                child: Text(
                  sourceRef,
                  style: typo.caption.copyWith(
                    color: colors.muted,
                    height: 1.35,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _ActionPanel extends ConsumerWidget {
  const _ActionPanel({required this.action, required this.nameNumber});

  final NameActionItem action;
  final int nameNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final stage = ref
        .watch(journeyProgressResolverProvider)
        .stageFor(nameNumber);
    final isPracticed = stage.weight >= JourneyNameStage.practiced.weight;

    return _MutedPanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.volunteer_activism_outlined, color: colors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.textFr,
                  style: typo.bodyLarge.copyWith(
                    color: colors.ink,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: space.md),
                OutlinedButton.icon(
                  onPressed: isPracticed
                      ? null
                      : () => ref
                            .read(settingsProvider.notifier)
                            .markNamePracticed(nameNumber),
                  icon: Icon(
                    isPracticed
                        ? Icons.check_circle_rounded
                        : Icons.check_rounded,
                  ),
                  label: Text(
                    isPracticed
                        ? context.l10n.nameExperienceActionPracticed
                        : context.l10n.nameExperienceMarkActionPracticed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MutedPanel extends StatelessWidget {
  const _MutedPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bg2,
        border: Border.all(color: colors.line),
        borderRadius: context.radii.mdAll,
      ),
      child: Padding(padding: EdgeInsets.all(space.md), child: child),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color, strokeWidth: 2),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.nameExperienceNotFound,
        style: context.typo.bodyLarge.copyWith(color: context.colors.muted),
      ),
    );
  }
}
