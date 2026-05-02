import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class TafakkurSettingsSheet extends StatelessWidget {
  const TafakkurSettingsSheet({
    super.key,
    required this.currentPace,
    required this.onPaceChanged,
  });

  final int currentPace;
  final ValueChanged<int> onPaceChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final typo = context.typo;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.tafakkurPaceLabel, style: typo.headline),
            const SizedBox(height: 16),
            _PaceOption(
              label: l10n.tafakkurPaceSlow,
              value: 12,
              groupValue: currentPace,
              onChanged: (val) {
                onPaceChanged(val);
                context.pop();
              },
            ),
            _PaceOption(
              label: l10n.tafakkurPaceNormal,
              value: 9,
              groupValue: currentPace,
              onChanged: (val) {
                onPaceChanged(val);
                context.pop();
              },
            ),
            _PaceOption(
              label: l10n.tafakkurPaceFast,
              value: 6,
              groupValue: currentPace,
              onChanged: (val) {
                onPaceChanged(val);
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PaceOption extends StatelessWidget {
  const _PaceOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int groupValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? colors.accent : colors.muted,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: typo.bodyLarge.copyWith(
                color: isSelected ? colors.ink : colors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
