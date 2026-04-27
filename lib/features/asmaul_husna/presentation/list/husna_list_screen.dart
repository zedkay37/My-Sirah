import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/husna_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/asmaul_husna/data/models/husna_name.dart';

class HusnaListScreen extends ConsumerStatefulWidget {
  const HusnaListScreen({super.key});

  @override
  ConsumerState<HusnaListScreen> createState() => _HusnaListScreenState();
}

class _HusnaListScreenState extends ConsumerState<HusnaListScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<HusnaName> _filter(List<HusnaName> all) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all
        .where(
          (n) =>
              n.arabic.contains(_query.trim()) ||
              n.transliteration.toLowerCase().contains(q) ||
              n.meaningFr.toLowerCase().contains(q) ||
              n.etymology.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    final husnaAsync = ref.watch(husnaProvider);
    final husnaLearned = ref.watch(
      settingsProvider.select((s) => s.husnaLearned),
    );

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(l10n.husnaTitle, style: typo.headline),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.ink),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(space.md, 0, space.md, space.sm),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              style: typo.body,
              decoration: InputDecoration(
                hintText: l10n.husnaSearchHint,
                hintStyle: typo.body.copyWith(color: colors.muted),
                prefixIcon: Icon(Icons.search_outlined, color: colors.muted),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: colors.muted, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: colors.bg2,
                border: OutlineInputBorder(
                  borderRadius: radii.pillAll,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: radii.pillAll,
                  borderSide: BorderSide(color: colors.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: radii.pillAll,
                  borderSide: BorderSide(color: colors.accent),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: space.md,
                  vertical: space.sm,
                ),
              ),
            ),
          ),
          Expanded(
            child: husnaAsync.when(
              data: (names) {
                final filtered = _filter(names);
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.discoverNoResults,
                      style: typo.body.copyWith(color: colors.muted),
                    ),
                  );
                }
                return ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final name = filtered[i];
                    final isLearned = husnaLearned.contains(name.id);
                    return _HusnaCard(
                      name: name,
                      isLearned: isLearned,
                      onTap: () => context.push('/discover/husna/${name.id}'),
                    );
                  },
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: colors.accent,
                  strokeWidth: 2,
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HusnaCard extends StatelessWidget {
  const _HusnaCard({
    required this.name,
    required this.isLearned,
    required this.onTap,
  });

  final HusnaName name;
  final bool isLearned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: space.md, vertical: space.xs),
        child: Container(
          padding: EdgeInsets.all(space.md),
          decoration: BoxDecoration(
            color: colors.bg2,
            borderRadius: BorderRadius.circular(radii.md),
            border: Border.all(color: colors.line),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(radii.sm),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${name.id}',
                  style: typo.caption.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.arabic,
                      style: typo.arabicBody.copyWith(
                        fontSize: 20,
                        color: colors.ink,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name.transliteration,
                      style: typo.caption.copyWith(color: colors.muted),
                    ),
                    Text(
                      name.meaningFr,
                      style: typo.caption.copyWith(color: colors.ink),
                    ),
                  ],
                ),
              ),
              if (isLearned)
                Icon(Icons.check_circle, color: colors.success, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
