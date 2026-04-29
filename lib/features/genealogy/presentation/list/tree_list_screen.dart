import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/genealogy_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';
import 'package:sirah_app/features/genealogy/data/repositories/genealogy_repository.dart';

class TreeListScreen extends ConsumerWidget {
  const TreeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoAsync = ref.watch(genealogyRepositoryProvider);

    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(
        backgroundColor: context.colors.bg,
        surfaceTintColor: Colors.transparent,
        title: Text(
          context.l10n.treeListViewTitle,
          style: context.typo.headline.copyWith(color: context.colors.ink),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.ink),
          onPressed: () => context.pop(),
        ),
      ),
      body: repoAsync.when(
        data: (repo) => _buildList(context, repo),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.l10n.treeLoadError)),
      ),
    );
  }

  Widget _buildList(BuildContext context, GenealogyRepository repo) {
    final allMembers = repo.getAll();

    // Grouping
    final ancestors =
        allMembers
            .where(
              (m) =>
                  m.role == FamilyRole.father ||
                  m.role == FamilyRole.mother ||
                  m.role == FamilyRole.paternalAscendant ||
                  m.role == FamilyRole.maternalAscendant,
            )
            .toList()
          ..sort(
            (a, b) => (a.generation ?? 999).compareTo(b.generation ?? 999),
          );

    final wives = allMembers.where((m) => m.role == FamilyRole.wife).toList()
      ..sort(
        (a, b) => (a.marriageOrder ?? 999).compareTo(b.marriageOrder ?? 999),
      );

    final children = allMembers
        .where(
          (m) => m.role == FamilyRole.child || m.role == FamilyRole.grandchild,
        )
        .toList();

    final uncles = allMembers
        .where((m) => m.role == FamilyRole.uncle || m.role == FamilyRole.aunt)
        .toList();

    final other = allMembers
        .where(
          (m) =>
              !m.isBoundary &&
              (m.role == FamilyRole.cousin ||
                  m.role == FamilyRole.traditionalAncestor),
        )
        .toList();

    return CustomScrollView(
      slivers: [
        if (ancestors.isNotEmpty)
          ..._buildSection(
            context,
            context.l10n.treeListSectionAncestors,
            ancestors,
          ),
        if (wives.isNotEmpty)
          ..._buildSection(context, context.l10n.treeListSectionWives, wives),
        if (children.isNotEmpty)
          ..._buildSection(
            context,
            context.l10n.treeListSectionChildren,
            children,
          ),
        if (uncles.isNotEmpty)
          ..._buildSection(context, context.l10n.treeListSectionUncles, uncles),
        if (other.isNotEmpty)
          ..._buildSection(context, context.l10n.treeListSectionOther, other),
        SliverToBoxAdapter(child: SizedBox(height: context.space.xxl)),
      ],
    );
  }

  List<Widget> _buildSection(
    BuildContext context,
    String title,
    List<FamilyMember> members,
  ) {
    return [
      SliverToBoxAdapter(
        child: Container(
          color: context.colors.bg2,
          padding: EdgeInsets.symmetric(
            horizontal: context.space.md,
            vertical: context.space.sm,
          ),
          child: Text(
            title.toUpperCase(),
            style: context.typo.overline.copyWith(color: context.colors.muted),
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final m = members[index];
          final roleLabel = _roleLabel(m.role);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: '${m.transliteration}, $roleLabel',
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.space.md,
                    vertical: context.space.xs,
                  ),
                  title: Text(
                    m.arabic,
                    style: context.typo.arabicBody.copyWith(
                      fontSize: 18,
                      color: context.colors.ink,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  subtitle: Text(
                    m.transliteration,
                    style: context.typo.caption.copyWith(
                      color: context.colors.muted,
                    ),
                  ),
                  trailing: Text(
                    roleLabel,
                    style: context.typo.caption.copyWith(
                      color: context.colors.muted,
                    ),
                  ),
                  onTap: () => context.push('/tree/person/${m.id}'),
                ),
              ),
              if (index < members.length - 1)
                Divider(
                  color: context.colors.line,
                  height: 1,
                  indent: context.space.md,
                ),
            ],
          );
        }, childCount: members.length),
      ),
    ];
  }

  String _roleLabel(FamilyRole role) {
    switch (role) {
      case FamilyRole.prophet:
        return 'Le Prophète ﷺ';
      case FamilyRole.father:
        return 'Père du Prophète ﷺ';
      case FamilyRole.mother:
        return 'Mère du Prophète ﷺ';
      case FamilyRole.paternalAscendant:
        return 'Ancêtre paternel';
      case FamilyRole.maternalAscendant:
        return 'Ancêtre maternel';
      case FamilyRole.uncle:
        return 'Oncle du Prophète ﷺ';
      case FamilyRole.aunt:
        return 'Tante du Prophète ﷺ';
      case FamilyRole.wife:
        return 'Épouse du Prophète ﷺ';
      case FamilyRole.child:
        return 'Enfant du Prophète ﷺ';
      case FamilyRole.grandchild:
        return 'Petit-enfant du Prophète ﷺ';
      case FamilyRole.cousin:
        return 'Cousin(e) du Prophète ﷺ';
      case FamilyRole.traditionalAncestor:
        return 'Ancêtre (tradition)';
    }
  }
}
