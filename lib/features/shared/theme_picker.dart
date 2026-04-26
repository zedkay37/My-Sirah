import 'package:flutter/material.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final ThemeKey current;
  final void Function(ThemeKey) onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    final options = [
      (ThemeKey.light, l10n.settingsThemeLight, Icons.light_mode_outlined),
      (ThemeKey.dark, l10n.settingsThemeDark, Icons.dark_mode_outlined),
      (ThemeKey.feminine, l10n.settingsThemeFeminine, Icons.auto_awesome_outlined),
    ];

    return Row(
      children: options.map((opt) {
        final (key, label, icon) = opt;
        final isSelected = current == key;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: space.xs / 2),
            child: GestureDetector(
              onTap: () => onChanged(key),
              child: Semantics(
                label: label,
                selected: isSelected,
                button: true,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: space.sm + 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.accent.withValues(alpha: 0.12)
                        : colors.bg2,
                    borderRadius: BorderRadius.circular(radii.md),
                    border: Border.all(
                      color: isSelected ? colors.accent : colors.line,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? colors.accent : colors.muted,
                        size: 22,
                      ),
                      SizedBox(height: space.xs),
                      Text(
                        label,
                        style: typo.caption.copyWith(
                          color: isSelected ? colors.accent : colors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
