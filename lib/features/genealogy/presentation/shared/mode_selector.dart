import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({
    super.key,
    required this.active,
    required this.onSelect,
  });

  final String active;
  final ValueChanged<String> onSelect;

  static const _modes = [
    ('radial', Icons.hub_outlined, Icons.hub),
    ('river', Icons.timeline_outlined, Icons.timeline),
    ('constellation', Icons.auto_awesome_outlined, Icons.auto_awesome),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;
    final space = context.space;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: radii.smAll,
        border: Border.all(color: colors.line, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _modes.map((m) {
          final (key, icon, activeIcon) = m;
          final isActive = key == active;
          return Semantics(
            button: true,
            selected: isActive,
            child: InkWell(
              onTap: () => onSelect(key),
              borderRadius: radii.smAll,
              child: Padding(
                padding: EdgeInsets.all(space.sm),
                child: Icon(
                  isActive ? activeIcon : icon,
                  size: 20,
                  color: isActive ? colors.accent : colors.muted,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
