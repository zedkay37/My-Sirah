import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sirah_app/core/providers/genealogy_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/features/genealogy/data/genealogy_notifier.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';
import 'package:sirah_app/features/genealogy/data/repositories/genealogy_repository.dart';
import 'package:sirah_app/features/genealogy/presentation/detail/path_chip.dart';
import 'package:sirah_app/features/genealogy/shared/family_role_labels.dart';

class PersonDetailScreen extends ConsumerStatefulWidget {
  const PersonDetailScreen({super.key, required this.memberId});
  final String memberId;

  @override
  ConsumerState<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends ConsumerState<PersonDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(genealogyNotifierProvider).markMemberViewed(widget.memberId);
    });
  }

  @override
  void didUpdateWidget(PersonDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.memberId != widget.memberId) {
      Future.microtask(() {
        ref.read(genealogyNotifierProvider).markMemberViewed(widget.memberId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final repoAsync = ref.watch(genealogyRepositoryProvider);

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: repoAsync.when(
        data: (repo) {
          final member = repo.getById(widget.memberId);
          
          if (member == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: context.colors.error),
                  SizedBox(height: context.space.md),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text(context.l10n.treePersonBack),
                  ),
                ],
              ),
            );
          }

          final userState = ref.watch(settingsProvider);
          final isFavorite = userState.favoriteMembers.contains(widget.memberId);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: context.colors.ink),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? context.colors.accent2 : context.colors.muted,
                    ),
                    onPressed: () {
                      ref.read(genealogyNotifierProvider).toggleFavoriteMember(widget.memberId);
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.space.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context, member),
                      SizedBox(height: context.space.xl),
                      _buildRelationSection(context, member, repo),
                      _buildMarkersSection(context, member),
                      _buildNarrativeSection(context, member),
                      _buildNamesBridgeSection(context, ref, member),
                      _buildSeeAlsoSection(context, member, repo),
                      SizedBox(height: context.space.xl),
                    ],
                  ).animate().fade(duration: 350.ms).slideY(
                        begin: 0.03,
                        curve: Curves.easeOut,
                      ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(context.l10n.treeLoadError)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FamilyMember member) {
    return Column(
      children: [
        Text(
          member.arabic,
          style: context.typo.arabicBody.copyWith(
            fontSize: 32,
            color: context.colors.ink,
          ),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.space.sm),
        Text(
          member.transliteration,
          style: context.typo.headline.copyWith(
            fontStyle: FontStyle.italic,
            color: context.colors.ink,
          ),
          textAlign: TextAlign.center,
        ),
        if (member.kunya != null || member.laqab.isNotEmpty) ...[
          SizedBox(height: context.space.xs),
          Text(
            [
              if (member.kunya != null) member.kunya,
              ...member.laqab,
            ].join(' • '),
            style: context.typo.overline.copyWith(color: context.colors.muted),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildRelationSection(BuildContext context, FamilyMember member, GenealogyRepository repo) {
    final path = repo.getPath(member.id, 'muhammad');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: context.l10n.treePersonRelation),
        SizedBox(height: context.space.sm),
        Text(
          familyRoleLabel(context, member.role),
          style: context.typo.bodyLarge.copyWith(color: context.colors.ink),
        ),
        SizedBox(height: context.space.sm),
        PathChip(path: path),
        SizedBox(height: context.space.lg),
      ],
    );
  }

  Widget _buildMarkersSection(BuildContext context, FamilyMember member) {
    if (member.birth == null && member.death == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: context.l10n.treePersonMarkers),
        SizedBox(height: context.space.sm),
        if (member.birth != null)
          _MarkerRow(label: context.l10n.treePersonBirth, value: member.birth!),
        if (member.death != null) ...[
          if (member.birth != null) SizedBox(height: context.space.xs),
          _MarkerRow(label: context.l10n.treePersonDeath, value: member.death!),
        ],
        SizedBox(height: context.space.lg),
      ],
    );
  }

  Widget _buildNarrativeSection(BuildContext context, FamilyMember member) {
    if (member.bio == null || member.bio!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: context.l10n.treePersonNarrative),
        SizedBox(height: context.space.sm),
        Text(
          member.bio!,
          style: context.typo.bodyLarge.copyWith(color: context.colors.ink),
        ),
        SizedBox(height: context.space.lg),
      ],
    );
  }

  Widget _buildNamesBridgeSection(BuildContext context, WidgetRef ref, FamilyMember member) {
    final namesAsync = ref.watch(namesProvider);
    final names = namesAsync.valueOrNull ?? [];
    
    if (names.isEmpty) return const SizedBox.shrink();

    final firstName = member.transliteration.split(' ').first.toLowerCase();
    final relatedNames = names.where((n) {
      return n.commentary.toLowerCase().contains(firstName);
    }).take(5).toList();

    if (relatedNames.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: context.l10n.treeBridgeRelatedNames),
        SizedBox(height: context.space.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: relatedNames.map((n) => Padding(
              padding: EdgeInsets.only(right: context.space.sm),
              child: InkWell(
                borderRadius: context.radii.smAll,
                onTap: () => context.push('/name/${n.number}'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.space.sm,
                    vertical: context.space.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.bg2,
                    borderRadius: context.radii.smAll,
                    border: Border.all(color: context.colors.line),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        n.arabic,
                        style: context.typo.arabicBody.copyWith(
                          fontSize: 14,
                          color: context.colors.ink,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(width: context.space.xs),
                      Text(
                        n.number.toString().padLeft(3, '0'),
                        style: context.typo.caption.copyWith(color: context.colors.muted),
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
        SizedBox(height: context.space.lg),
      ],
    );
  }

  Widget _buildSeeAlsoSection(BuildContext context, FamilyMember member, GenealogyRepository repo) {
    final related = _getRelated(member, repo);
    if (related.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: context.l10n.treePersonSeeAlso),
        SizedBox(height: context.space.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: related.map((r) => Padding(
              padding: EdgeInsets.only(right: context.space.sm),
              child: InkWell(
                borderRadius: context.radii.smAll,
                onTap: () => context.push('/tree/person/${r.id}'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.space.sm,
                    vertical: context.space.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.bg2,
                    borderRadius: context.radii.smAll,
                    border: Border.all(color: context.colors.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.arabic,
                        style: context.typo.arabicBody.copyWith(
                          fontSize: 16,
                          color: context.colors.ink,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        r.transliteration,
                        style: context.typo.caption.copyWith(color: context.colors.muted),
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  List<FamilyMember> _getRelated(FamilyMember member, GenealogyRepository repo) {
    final ids = [
      member.parentId,
      member.motherId,
      member.spouseOf,
      ...member.parentIds
    ].whereType<String>().toSet();
    
    return ids
        .map((id) => repo.getById(id))
        .whereType<FamilyMember>()
        .take(8)
        .toList();
  }

}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: context.typo.overline.copyWith(color: context.colors.muted),
        ),
        SizedBox(height: context.space.xs),
        Divider(color: context.colors.line, height: 1),
      ],
    );
  }
}

class _MarkerRow extends StatelessWidget {
  const _MarkerRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: context.typo.body.copyWith(color: context.colors.muted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.typo.body.copyWith(color: context.colors.ink),
          ),
        ),
      ],
    );
  }
}
