import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';

class RiverNode extends StatelessWidget {
  const RiverNode({
    super.key,
    required this.member,
    required this.isLeft,
    required this.isProphet,
    required this.index,
  });

  final FamilyMember member;
  final bool isLeft;
  final bool isProphet;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Widget card = GestureDetector(
      onTap: () => context.push('/tree/person/${member.id}'),
      child: Container(
        width: isProphet ? 180 : 140,
        padding: EdgeInsets.all(context.space.sm),
        decoration: BoxDecoration(
          color: isProphet ? context.colors.bg : context.colors.bg2,
          borderRadius: BorderRadius.circular(context.radii.sm),
          border: Border.all(
            color: isProphet ? context.colors.accent : context.colors.line,
          ),
          boxShadow: isProphet
              ? [
                  BoxShadow(
                    color: context.colors.accent.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _roleLabel(member.role).toUpperCase(),
              style: context.typo.overline.copyWith(color: context.colors.muted),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.space.xs),
            Text(
              member.arabic,
              style: context.typo.arabicBody.copyWith(
                fontSize: 18,
                color: context.colors.ink,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
            Text(
              member.transliteration,
              style: context.typo.caption.copyWith(color: context.colors.muted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    Widget aligned;
    if (isProphet) {
      aligned = Center(child: card);
    } else {
      aligned = Row(
        children: isLeft
            ? [card, const Spacer()]
            : [const Spacer(), card],
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: context.space.md),
      child: aligned,
    ).animate().fade(
          duration: 300.ms,
          delay: (index * 40).ms,
        ).slideY(
          begin: 0.05,
          duration: 300.ms,
          delay: (index * 40).ms,
        );
  }

  String _roleLabel(FamilyRole role) {
    switch (role) {
      case FamilyRole.prophet: return 'Le Prophète ﷺ';
      case FamilyRole.father: return 'Père du Prophète ﷺ';
      case FamilyRole.mother: return 'Mère du Prophète ﷺ';
      case FamilyRole.paternalAscendant: return 'Ancêtre paternel';
      case FamilyRole.maternalAscendant: return 'Ancêtre maternel';
      case FamilyRole.uncle: return 'Oncle du Prophète ﷺ';
      case FamilyRole.aunt: return 'Tante du Prophète ﷺ';
      case FamilyRole.wife: return 'Épouse du Prophète ﷺ';
      case FamilyRole.child: return 'Enfant du Prophète ﷺ';
      case FamilyRole.grandchild: return 'Petit-enfant du Prophète ﷺ';
      case FamilyRole.cousin: return 'Cousin(e) du Prophète ﷺ';
      case FamilyRole.traditionalAncestor: return 'Ancêtre (tradition)';
    }
  }
}

class Tributary extends StatelessWidget {
  const Tributary({
    super.key,
    required this.members,
    required this.isLeft,
    required this.index,
  });

  final List<FamilyMember> members;
  final bool isLeft;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();

    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final count = members.length;

    return Padding(
      padding: EdgeInsets.only(bottom: space.md),
      child: Center(
        child: GestureDetector(
          onTap: () => _showSheet(context),
          child: Container(
            width: 200,
            padding: EdgeInsets.symmetric(
              horizontal: space.md,
              vertical: space.sm,
            ),
            decoration: BoxDecoration(
              color: colors.bg2,
              borderRadius: BorderRadius.circular(radii.sm),
              border: Border.all(
                color: colors.muted.withValues(alpha: 0.4),
                width: 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  size: 14,
                  color: colors.muted,
                ),
                SizedBox(width: space.xs),
                Flexible(
                  child: Text(
                    'Oncles & Tantes · $count',
                    style: typo.caption.copyWith(color: colors.muted),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: space.xs),
                Icon(Icons.chevron_right, size: 14, color: colors.muted),
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(
          duration: 300.ms,
          delay: (index * 40).ms,
        ).slideY(
          begin: 0.05,
          duration: 300.ms,
          delay: (index * 40).ms,
        );
  }

  void _showSheet(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radii.lg),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: space.sm),
                decoration: BoxDecoration(
                  color: colors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(space.md, 0, space.md, space.sm),
              child: Text(
                'Oncles & Tantes du Prophète ﷺ',
                style: typo.headline.copyWith(color: colors.ink),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: space.sm),
                shrinkWrap: true,
                itemCount: members.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (ctx, i) {
                  final m = members[i];
                  return ListTile(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      GoRouter.of(context).push('/tree/person/${m.id}');
                    },
                    title: Text(
                      m.arabic,
                      style: typo.arabicBody.copyWith(
                        fontSize: 18,
                        color: colors.ink,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    subtitle: Text(
                      m.transliteration,
                      style: typo.caption.copyWith(color: colors.muted),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colors.muted,
                      size: 18,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
