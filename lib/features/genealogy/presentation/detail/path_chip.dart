import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';

class PathChip extends StatelessWidget {
  const PathChip({super.key, required this.path});

  final List<FamilyMember> path;

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty || path.length == 1) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];

    for (var i = 0; i < path.length; i++) {
      final member = path[i];
      final isEndpoint = i == 0 || i == path.length - 1;

      children.add(_buildChip(context, member, isEndpoint));

      if (i < path.length - 1) {
        children.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.space.xs),
            child: Icon(
              Icons.chevron_right,
              size: 14,
              color: context.colors.muted,
            ),
          ),
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  Widget _buildChip(
    BuildContext context,
    FamilyMember member,
    bool isEndpoint,
  ) {
    final isProphet = member.role == FamilyRole.prophet;
    final text = isProphet ? 'ﷺ' : member.transliteration;
    final borderColor = isEndpoint
        ? context.colors.accent.withValues(alpha: 0.6)
        : context.colors.line;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.space.xs,
        vertical: context.space.xs / 2,
      ),
      decoration: BoxDecoration(
        color: context.colors.bg2,
        borderRadius: context.radii.smAll,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: context.typo.caption.copyWith(color: context.colors.ink),
      ),
    );
  }
}
