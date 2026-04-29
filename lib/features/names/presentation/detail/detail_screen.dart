import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/features/names/data/names_notifier.dart';
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
          child: CircularProgressIndicator(
            color: colors.accent,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: colors.bg,
        body: Center(child: Icon(Icons.error_outline, color: colors.muted)),
      ),
      data: (names) {
        final idx = names.indexWhere((n) => n.number == initialNumber);
        return _DetailPageView(names: names, startIndex: idx < 0 ? 0 : idx);
      },
    );
  }
}

// ── PageView avec état ─────────────────────────────────────────────────────────

class _DetailPageView extends ConsumerStatefulWidget {
  const _DetailPageView({required this.names, required this.startIndex});

  final List<ProphetName> names;
  final int startIndex;

  @override
  ConsumerState<_DetailPageView> createState() => _DetailPageViewState();
}

class _DetailPageViewState extends ConsumerState<_DetailPageView> {
  late final PageController _pageCtrl;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    _pageCtrl = PageController(initialPage: widget.startIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _onPageFocused(_currentIndex);
    });
  }

  void _onPageFocused(int index) {
    final number = widget.names[index].number;
    ref.read(namesNotifierProvider).markViewed(number);
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _onPageFocused(index);
  }

  @override
  void dispose() {
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

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          l10n.detailNameLabel(currentName.number.toString().padLeft(3, '0')),
          style: typo.caption.copyWith(color: colors.muted),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.self_improvement_rounded, color: colors.muted),
            tooltip: l10n.tafakkurTitle,
            onPressed: () =>
                context.push('/name/${currentName.number}/tafakkur'),
          ),
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
                  .read(namesNotifierProvider)
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
            ],
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageCtrl,
        onPageChanged: _onPageChanged,
        itemCount: names.length,
        itemBuilder: (ctx, i) =>
            _NameDetailPage(name: names[i], index: i, total: names.length),
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
          SizedBox(height: space.lg),

          // Translittération
          Text(
            name.transliteration,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: typo.displayMedium.copyWith(fontStyle: FontStyle.italic),
          ),
          SizedBox(height: space.md),

          // Chip catégorie
          CategoryChip(
            slug: name.categorySlug,
            label: name.categoryLabel,
            variant: CategoryChipVariant.filled,
          ),
          SizedBox(height: space.lg),
          OutlinedButton.icon(
            onPressed: () => context.push('/name/${name.number}/experience'),
            icon: const Icon(Icons.auto_awesome_outlined),
            label: Text(context.l10n.nameExperienceOpen),
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

          if (name.categorySlug == 'nobility') ...[
            SizedBox(height: space.xl),
            const _TreeBridgeLink(),
          ],
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
        Text(content, textDirection: TextDirection.ltr, style: typo.bodyLarge),
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
          Text(
            primary,
            textDirection: TextDirection.ltr,
            style: typo.bodyLarge,
          ),
        if (primary.isNotEmpty && secondary.isNotEmpty)
          SizedBox(height: space.sm),
        if (secondary.isNotEmpty)
          Text(
            secondary,
            textDirection: TextDirection.ltr,
            style: typo.body.copyWith(color: colors.muted),
          ),
      ],
    );
  }
}

class _TreeBridgeLink extends StatelessWidget {
  const _TreeBridgeLink();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/tree'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_tree_outlined,
            size: 16,
            color: context.colors.muted,
          ),
          SizedBox(width: context.space.xs),
          Text(
            context.l10n.treeBridgeToTree,
            style: context.typo.body.copyWith(color: context.colors.muted),
          ),
        ],
      ),
    );
  }
}
