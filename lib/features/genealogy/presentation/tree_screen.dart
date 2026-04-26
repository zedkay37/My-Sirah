import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/presentation/radial/radial_view.dart';
import 'package:sirah_app/features/genealogy/presentation/shared/mode_selector.dart';

class TreeScreen extends ConsumerWidget {
  const TreeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(settingsProvider.select((s) => s.preferredTreeView));

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              mode: mode,
              onModeChange: (m) =>
                  ref.read(settingsProvider.notifier).setPreferredTreeView(m),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: KeyedSubtree(
                  key: ValueKey(mode),
                  child: _viewForMode(mode, context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _viewForMode(String mode, BuildContext context) {
    final l10n = context.l10n;
    return switch (mode) {
      'river' => _ModePlaceholder(
          icon: Icons.timeline_outlined,
          label: l10n.treeModeRiver,
        ),
      'constellation' => _ModePlaceholder(
          icon: Icons.auto_awesome_outlined,
          label: l10n.treeModeConstellation,
        ),
      _ => const RadialView(),
    };
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.mode, required this.onModeChange});
  final String mode;
  final ValueChanged<String> onModeChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.space.md,
        context.space.md,
        context.space.md,
        context.space.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.treeTitle,
              style: context.typo.displayMedium
                  .copyWith(color: context.colors.ink),
            ),
          ),
          ModeSelector(active: mode, onSelect: onModeChange),
        ],
      ),
    );
  }
}

class _ModePlaceholder extends StatelessWidget {
  const _ModePlaceholder({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: context.colors.muted),
          SizedBox(height: context.space.md),
          Text(
            label,
            style:
                context.typo.headline.copyWith(color: context.colors.muted),
          ),
        ],
      ),
    );
  }
}
