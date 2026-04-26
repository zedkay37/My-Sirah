import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';

class PersonChip extends StatelessWidget {
  const PersonChip({super.key, required this.member});
  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.bg,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radii.lg),
        side: BorderSide(color: context.colors.line),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.space.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.arabic,
                    style: context.typo.arabicBody.copyWith(
                      color: context.colors.ink,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.transliteration,
                    style: context.typo.body.copyWith(
                      color: context.colors.muted,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => context.push('/tree/person/${member.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accent,
                foregroundColor: context.colors.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.radii.md),
                ),
              ),
              child: Text(context.l10n.treePersonOpenDetail),
            ),
          ],
        ),
      ),
    );
  }
}
