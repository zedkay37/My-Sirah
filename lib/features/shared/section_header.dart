import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;

    return Row(
      children: [
        _ornament(colors.line),
        SizedBox(width: space.sm),
        Text(
          title.toUpperCase(),
          style: typo.overline.copyWith(color: colors.muted),
        ),
        SizedBox(width: space.sm),
        Expanded(child: _ornament(colors.line)),
      ],
    );
  }

  Widget _ornament(Color color) => Container(
    height: 1,
    width: 24,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [color.withValues(alpha: 0), color]),
    ),
  );
}
