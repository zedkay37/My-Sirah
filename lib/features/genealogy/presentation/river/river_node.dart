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

    final displayMembers = members.take(4).toList();
    final extraCount = members.length - displayMembers.length;

    final cards = <Widget>[];
    for (final m in displayMembers) {
      cards.add(
        GestureDetector(
          onTap: () => context.push('/tree/person/${m.id}'),
          child: Container(
            width: 80,
            margin: EdgeInsets.only(
              right: isLeft ? 0 : context.space.xs,
              left: isLeft ? context.space.xs : 0,
            ),
            padding: EdgeInsets.all(context.space.xs),
            decoration: BoxDecoration(
              color: context.colors.bg2,
              borderRadius: BorderRadius.circular(context.radii.sm),
              border: Border.all(
                color: context.colors.line.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  m.arabic,
                  style: context.typo.arabicBody.copyWith(
                    fontSize: 12,
                    color: context.colors.ink,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  m.transliteration,
                  style: context.typo.caption.copyWith(color: context.colors.muted),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (extraCount > 0) {
      cards.add(
        Container(
          width: 40,
          margin: EdgeInsets.only(
            right: isLeft ? 0 : context.space.xs,
            left: isLeft ? context.space.xs : 0,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.colors.bg2,
            borderRadius: BorderRadius.circular(context.radii.sm),
            border: Border.all(
              color: context.colors.line.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            '+$extraCount',
            style: context.typo.caption.copyWith(color: context.colors.muted),
          ),
        ),
      );
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: isLeft ? cards.reversed.toList() : cards,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: context.space.md),
      child: Row(
        children: isLeft ? [const Spacer(), content] : [content, const Spacer()],
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
}
