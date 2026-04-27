import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

enum GenealogyFilter {
  all,
  wivesAndChildren,
  ancestors,
  unclesAndAunts,
  ahlAlBayt
}

class RadialFilters extends StatelessWidget {
  const RadialFilters({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final GenealogyFilter activeFilter;
  final ValueChanged<GenealogyFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: context.space.md),
      child: Row(
        children: [
          _buildChip(context, GenealogyFilter.all, context.l10n.treeFilterAll),
          SizedBox(width: context.space.sm),
          _buildChip(context, GenealogyFilter.wivesAndChildren, context.l10n.treeFilterWivesAndChildren),
          SizedBox(width: context.space.sm),
          _buildChip(context, GenealogyFilter.ancestors, context.l10n.treeFilterAncestors),
          SizedBox(width: context.space.sm),
          _buildChip(context, GenealogyFilter.unclesAndAunts, context.l10n.treeFilterUnclesAndAunts),
          SizedBox(width: context.space.sm),
          _buildChip(context, GenealogyFilter.ahlAlBayt, context.l10n.treeFilterAhlAlBayt),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, GenealogyFilter filter, String label) {
    final isActive = activeFilter == filter;
    final colors = context.colors;
    
    return FilterChip(
      label: Text(label),
      labelStyle: context.typo.body.copyWith(
        color: isActive ? colors.accent : colors.ink,
      ),
      selected: isActive,
      onSelected: (_) => onFilterChanged(filter),
      backgroundColor: colors.bg2,
      selectedColor: colors.accent.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radii.lg),
        side: BorderSide(
          color: isActive ? colors.accent : colors.line,
        ),
      ),
      showCheckmark: false,
    );
  }
}
