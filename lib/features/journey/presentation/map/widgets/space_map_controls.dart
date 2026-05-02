import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class SpaceMapControls extends StatelessWidget {
  const SpaceMapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.bg.withValues(alpha: 0.86),
        borderRadius: context.radii.pillAll,
        border: Border.all(color: colors.line.withValues(alpha: 0.72)),
        boxShadow: [
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.12),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ControlButton(
              icon: Icons.add_rounded,
              tooltip: context.l10n.journeyMapZoomInTooltip,
              onPressed: onZoomIn,
            ),
            _ControlButton(
              icon: Icons.remove_rounded,
              tooltip: context.l10n.journeyMapZoomOutTooltip,
              onPressed: onZoomOut,
            ),
            _ControlButton(
              icon: Icons.my_location_rounded,
              tooltip: context.l10n.journeyMapResetTooltip,
              onPressed: onReset,
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon),
      color: context.colors.accent,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size.square(40),
      ),
      onPressed: onPressed,
    );
  }
}
