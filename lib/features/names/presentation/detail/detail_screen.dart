import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/names/presentation/detail/share_name_service.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';
import 'package:sirah_app/features/shared/category_chip.dart';
import 'package:sirah_app/features/shared/section_header.dart';

// ── Écran principal ───────────────────────────────────────────────────────────

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.initialNumber});

  final int initialNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namesAsync = ref.watch(namesProvider);
    final colors = context.colors;

    return namesAsync.when(
      loading: () => Scaffold(
        backgroundColor: colors.bg,
        body: Center(
          child: CircularProgressIndicator(color: colors.accent, strokeWidth: 2),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: colors.bg,
        body: Center(child: Icon(Icons.error_outline, color: colors.muted)),
      ),
      data: (names) {
        final idx = names.indexWhere((n) => n.number == initialNumber);
        return _DetailPageView(
          names: names,
          startIndex: idx < 0 ? 0 : idx,
        );
      },
    );
  }
}

// ── PageView avec état ─────────────────────────────────────────────────────────

class _DetailPageView extends ConsumerStatefulWidget {
  const _DetailPageView({
    required this.names,
    required this.startIndex,
  });

  final List<ProphetName> names;
  final int startIndex;

  @override
  ConsumerState<_DetailPageView> createState() => _DetailPageViewState();
}

class _DetailPageViewState extends ConsumerState<_DetailPageView>
    with SingleTickerProviderStateMixin {
  late final PageController _pageCtrl;
  late int _currentIndex;
  late final AnimationController _learningAnim;
  Timer? _learnedTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    _pageCtrl = PageController(initialPage: widget.startIndex);
    _learningAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _onPageFocused(_currentIndex);
    });
  }

  void _onPageFocused(int index) {
    final number = widget.names[index].number;
    ref.read(settingsProvider.notifier).markViewed(number);
    _restartLearnedTimer(number);
  }

  void _restartLearnedTimer(int number) {
    _learnedTimer?.cancel();
    _learningAnim
      ..stop()
      ..reset();
    final alreadyLearned = ref.read(settingsProvider).learned.contains(number);
    if (alreadyLearned) return;
    _learningAnim.forward();
    _learnedTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) ref.read(settingsProvider.notifier).markLearned(number);
    });
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _onPageFocused(index);
  }

  @override
  void dispose() {
    _learnedTimer?.cancel();
    _learningAnim.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final names = widget.names;
    final colors = context.colors;
    final typo = context.typo;
    final l10n = context.l10n;

    final currentName = names[_currentIndex];
    final isFavorite = ref.watch(
      settingsProvider.select((s) => s.favorites.contains(currentName.number)),
    );
    final isLearned = ref.watch(
      settingsProvider.select((s) => s.learned.contains(currentName.number)),
    );

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          l10n.detailNameLabel(
            currentName.number.toString().padLeft(3, '0'),
          ),
          style: typo.caption.copyWith(color: colors.muted),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: colors.muted),
            tooltip: l10n.detailShare,
            onPressed: () => ShareNameService.share(
              name: currentName,
              colors: colors,
              typo: context.typo,
            ),
          ),
          Semantics(
            label: isFavorite ? l10n.favoriteRemove : l10n.favoriteAdd,
            button: true,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? colors.error : colors.muted,
              ),
              onPressed: () => ref
                  .read(settingsProvider.notifier)
                  .toggleFavorite(currentName.number),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Position dans la liste
              LinearProgressIndicator(
                value: (_currentIndex + 1) / names.length,
                backgroundColor: colors.line,
                valueColor: AlwaysStoppedAnimation<Color>(
                  colors.muted.withValues(alpha: 0.35),
                ),
                minHeight: 2,
              ),
              // Progression de mémorisation (8s)
              AnimatedOpacity(
                opacity: isLearned ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 600),
                child: AnimatedBuilder(
                  animation: _learningAnim,
                  builder: (_, __) => LinearProgressIndicator(
                    value: _learningAnim.value,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
                    minHeight: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageCtrl,
        onPageChanged: _onPageChanged,
        itemCount: names.length,
        itemBuilder: (ctx, i) => _NameDetailPage(
          name: names[i],
          index: i,
          total: names.length,
        ),
      ),
    );
  }
}

// ── Page de détail d'un nom ────────────────────────────────────────────────────

class _NameDetailPage extends StatelessWidget {
  const _NameDetailPage({
    required this.name,
    required this.index,
    required this.total,
  });

  final ProphetName name;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(space.md, space.xl, space.md, space.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Indicateur de position
          Text(
            l10n.detailProgress(index + 1, total),
            style: typo.caption.copyWith(color: colors.muted),
          ),
          SizedBox(height: space.xl),

          // Texte arabe hero — rejoue à chaque changement de nom
          ArabicText(
            key: ValueKey(name.number),
            text: name.arabic,
            size: ArabicSize.hero,
            withShadow: true,
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .scale(
                begin: const Offset(0.88, 0.88),
                curve: Curves.easeOutBack,
              ),
          SizedBox(height: space.md),

          // Translittération
          Text(
            name.transliteration,
            textAlign: TextAlign.center,
            style: typo.displayMedium.copyWith(fontStyle: FontStyle.italic),
          ),
          SizedBox(height: space.md),

          // Chip catégorie
          CategoryChip(
            slug: name.categorySlug,
            label: name.categoryLabel,
            variant: CategoryChipVariant.filled,
          ),
          SizedBox(height: space.xxl),

          // ── Sections ────────────────────────────────────────────────────
          if (name.etymology.isNotEmpty) ...[
            _Section(
              title: l10n.detailSectionEtymology,
              content: name.etymology,
            ),
            SizedBox(height: space.xl),
          ],

          if (name.commentary.isNotEmpty) ...[
            _Section(
              title: l10n.detailSectionCommentary,
              content: name.commentary,
            ),
            SizedBox(height: space.xl),
          ],

          if (name.references.isNotEmpty) ...[
            _Section(
              title: l10n.detailSectionReferences,
              content: name.references,
            ),
            SizedBox(height: space.xl),
          ],

          if (name.primarySource.isNotEmpty || name.secondarySources.isNotEmpty)
            _SourcesSection(
              primary: name.primarySource,
              secondary: name.secondarySources,
            ),
        ],
      ),
    );
  }
}

// ── Section générique ──────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final typo = context.typo;
    final space = context.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        SizedBox(height: space.md),
        Text(content, style: typo.bodyLarge),
      ],
    );
  }
}

// ── Section sources ────────────────────────────────────────────────────────────

class _SourcesSection extends StatelessWidget {
  const _SourcesSection({required this.primary, required this.secondary});

  final String primary;
  final String secondary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.detailSectionSources),
        SizedBox(height: space.md),
        if (primary.isNotEmpty)
          Text(primary, style: typo.bodyLarge),
        if (primary.isNotEmpty && secondary.isNotEmpty)
          SizedBox(height: space.sm),
        if (secondary.isNotEmpty)
          Text(
            secondary,
            style: typo.body.copyWith(color: colors.muted),
          ),
      ],
    );
  }
}
