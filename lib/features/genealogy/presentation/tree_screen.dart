import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/presentation/constellation/constellation_view.dart';
import 'package:sirah_app/features/genealogy/presentation/radial/radial_view.dart';
import 'package:sirah_app/features/genealogy/presentation/river/river_view.dart';
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
    return switch (mode) {
      'river' => const RiverView(),
      'constellation' => const ConstellationView(),
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
          SizedBox(width: context.space.sm),
          IconButton(
            icon: Icon(Icons.list_outlined, color: context.colors.muted),
            tooltip: context.l10n.treeListView,
            onPressed: () => context.push('/tree/list'),
          ),
        ],
      ),
    );
  }
}

