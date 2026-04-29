import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/genealogy_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';
import 'package:sirah_app/features/genealogy/presentation/radial/radial_filters.dart';
import 'package:sirah_app/features/genealogy/presentation/radial/radial_painter.dart';
import 'package:sirah_app/features/genealogy/presentation/shared/person_chip.dart';

final genealogyFilterProvider = StateProvider<GenealogyFilter>(
  (ref) => GenealogyFilter.all,
);

class RadialView extends ConsumerStatefulWidget {
  const RadialView({super.key});

  @override
  ConsumerState<RadialView> createState() => _RadialViewState();
}

class _RadialViewState extends ConsumerState<RadialView> {
  final _transformationController = TransformationController();
  final ValueNotifier<String?> _selectedId = ValueNotifier<String?>(null);
  final _scale = ValueNotifier<double>(1.0);

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_syncScale);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_syncScale);
    _transformationController.dispose();
    _selectedId.dispose();
    _scale.dispose();
    super.dispose();
  }

  void _syncScale() {
    final nextScale = _transformationController.value.getMaxScaleOnAxis();
    if ((nextScale - _scale.value).abs() > 0.03) {
      _scale.value = nextScale;
    }
  }

  void _recenter() {
    _transformationController.value = Matrix4.identity();
    _selectedId.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(genealogyMembersProvider);
    final activeFilter = ref.watch(genealogyFilterProvider);

    return membersAsync.when(
      data: (members) => _buildBody(context, members, activeFilter),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(context.l10n.treeLoadError)),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<FamilyMember> members,
    GenealogyFilter activeFilter,
  ) {
    return Stack(
      children: [
        // Arbre interactif
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final center = Offset(
                constraints.maxWidth / 2,
                constraints.maxHeight / 2,
              );
              return InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.2,
                maxScale: 4.0,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(1000),
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: GestureDetector(
                    onTapDown: (details) {
                      // Note: InteractiveViewer handles pan/zoom.
                      // onTapDown here is for our hit test.
                    },
                    child: RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_selectedId, _scale]),
                        builder: (context, child) {
                          final selectedId = _selectedId.value;
                          return GestureDetector(
                            onTapUp: (details) {
                              final tapPosition = details.localPosition;
                              final painter = RadialPainter(
                                members: members,
                                filter: activeFilter,
                                selectedId: selectedId,
                                center: center,
                                colors: context.colors,
                                onTap: (_) {},
                                scale: _scale.value,
                              );
                              final hitId = painter.hitTestMembers(tapPosition);
                              _selectedId.value = hitId;
                            },
                            child: CustomPaint(
                              size: Size(
                                constraints.maxWidth,
                                constraints.maxHeight,
                              ),
                              painter: RadialPainter(
                                members: members,
                                filter: activeFilter,
                                selectedId: selectedId,
                                center: center,
                                colors: context.colors,
                                onTap: (_) {},
                                scale: _scale.value,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Filtres en haut
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: context.colors.bg.withValues(alpha: 0.8),
            padding: EdgeInsets.symmetric(vertical: context.space.sm),
            child: RadialFilters(
              activeFilter: activeFilter,
              onFilterChanged: (filter) {
                ref.read(genealogyFilterProvider.notifier).state = filter;
              },
            ),
          ),
        ),

        // Chip du profil sélectionné
        Positioned(
          bottom: context.space.xl,
          left: context.space.md,
          right: context.space.md,
          child: ValueListenableBuilder<String?>(
            valueListenable: _selectedId,
            builder: (context, selectedId, child) {
              if (selectedId == null) return const SizedBox.shrink();

              final member = members.firstWhere((m) => m.id == selectedId);
              return PersonChip(member: member);
            },
          ),
        ),

        // Bouton recentrer
        Positioned(
          bottom: context.space.lg,
          right: context.space.md,
          child: FloatingActionButton.small(
            onPressed: _recenter,
            backgroundColor: context.colors.bg2,
            child: Icon(Icons.my_location, color: context.colors.ink),
          ),
        ),
      ],
    );
  }
}
