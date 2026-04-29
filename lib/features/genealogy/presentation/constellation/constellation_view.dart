import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/genealogy_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';
import 'package:sirah_app/features/genealogy/data/repositories/genealogy_repository.dart';
import 'package:sirah_app/features/genealogy/presentation/constellation/constellation_painter.dart';
import 'package:sirah_app/features/genealogy/presentation/shared/person_chip.dart';

class ConstellationView extends ConsumerStatefulWidget {
  const ConstellationView({super.key});

  @override
  ConsumerState<ConstellationView> createState() => _ConstellationViewState();
}

class _ConstellationViewState extends ConsumerState<ConstellationView> {
  final _transformationController = TransformationController();
  final _searchController = TextEditingController();

  final _selectedId = ValueNotifier<String?>(null);
  final _pathStart = ValueNotifier<String?>(null);
  final _highlightedPath = ValueNotifier<List<String>>([]);

  Map<String, Offset>? _positionsCache;
  Map<String, List<String>>? _edgesCache;
  Offset? _lastCenter;

  @override
  void dispose() {
    _transformationController.dispose();
    _searchController.dispose();
    _selectedId.dispose();
    _pathStart.dispose();
    _highlightedPath.dispose();
    super.dispose();
  }

  void _recenter() {
    _transformationController.value = Matrix4.identity();
    _selectedId.value = null;
    _pathStart.value = null;
    _highlightedPath.value = [];
    _searchController.clear();
  }

  void _focusOnMember(String id, Offset pos, Offset center) {
    _selectedId.value = id;

    // Animer le canvas pour recentrer sur l'étoile
    // On calcule la translation pour amener pos au centre de l'écran
    final translation = center - pos;
    _transformationController.value = Matrix4.translationValues(
      translation.dx,
      translation.dy,
      0,
    );
  }

  void _buildCachesIfNeeded(List<FamilyMember> members, Offset center) {
    if (_positionsCache != null && _lastCenter == center) return;

    _lastCenter = center;
    final edges = <String, List<String>>{};

    void addEdge(String a, String b) {
      edges.putIfAbsent(a, () => []).add(b);
      edges.putIfAbsent(b, () => []).add(a);
    }

    for (final m in members) {
      if (m.parentId != null) addEdge(m.id, m.parentId!);
      if (m.motherId != null) addEdge(m.id, m.motherId!);
      if (m.spouseOf != null) addEdge(m.id, m.spouseOf!);
      for (final pid in m.parentIds) {
        addEdge(m.id, pid);
      }
    }
    _edgesCache = edges;

    final positions = <String, Offset>{};

    // Group members
    final paternalGen3 = <FamilyMember>[];
    final maternal = <FamilyMember>[];
    final wives = <FamilyMember>[];
    final children = <FamilyMember>[];
    final grandchildren = <FamilyMember>[];
    final unclesAunts = <FamilyMember>[];
    final cousins = <FamilyMember>[];
    final traditional = <FamilyMember>[];

    for (final m in members) {
      if (m.role == FamilyRole.prophet) {
        positions[m.id] = center;
      } else if (m.role == FamilyRole.father || m.role == FamilyRole.mother) {
        // father/mother : center + Offset(0, -110), let's offset slightly to avoid overlap
        final dx = m.role == FamilyRole.father ? -25.0 : 25.0;
        positions[m.id] = center + Offset(dx, -110);
      } else if (m.role == FamilyRole.wife && m.marriageOrder == 1) {
        positions[m.id] = center + const Offset(180, -40);
      } else if (m.role == FamilyRole.paternalAscendant && m.generation == 2) {
        final dx = positions.length % 2 == 0 ? -60.0 : 60.0;
        positions[m.id] = center + Offset(dx, -180);
      } else if (m.isTraditional) {
        traditional.add(m);
      } else {
        switch (m.role) {
          case FamilyRole.paternalAscendant:
            paternalGen3.add(m);
            break;
          case FamilyRole.maternalAscendant:
            maternal.add(m);
            break;
          case FamilyRole.wife:
            wives.add(m);
            break;
          case FamilyRole.child:
            children.add(m);
            break;
          case FamilyRole.grandchild:
            grandchildren.add(m);
            break;
          case FamilyRole.uncle:
          case FamilyRole.aunt:
            unclesAunts.add(m);
            break;
          case FamilyRole.cousin:
            cousins.add(m);
            break;
          default:
            break;
        }
      }
    }

    void distributeOnArc(
      List<FamilyMember> list,
      double startAngle,
      double endAngle,
      double rMin,
      double rMax,
    ) {
      if (list.isEmpty) return;
      for (int i = 0; i < list.length; i++) {
        final f = list.length == 1 ? 0.5 : i / (list.length - 1);
        final angle = startAngle + (endAngle - startAngle) * f;
        final r = rMin + (rMax - rMin) * (i % 2 == 0 ? 0.0 : 1.0); // zigzag
        positions[list[i].id] =
            center + Offset(math.cos(angle) * r, math.sin(angle) * r);
      }
    }

    void distributeInBox(
      List<FamilyMember> list,
      double xMin,
      double xMax,
      double yMin,
      double yMax,
    ) {
      if (list.isEmpty) return;
      final cols = math.max(1, math.sqrt(list.length).ceil());
      final rows = (list.length / cols).ceil();
      for (int i = 0; i < list.length; i++) {
        final c = i % cols;
        final r = i ~/ cols;
        final dx = cols == 1 ? 0.5 : c / (cols - 1);
        final dy = rows == 1 ? 0.5 : r / (rows - 1);
        positions[list[i].id] =
            center +
            Offset(xMin + (xMax - xMin) * dx, yMin + (yMax - yMin) * dy);
      }
    }

    distributeOnArc(paternalGen3, -3 * math.pi / 4, -math.pi / 4, 260, 340);
    distributeOnArc(maternal, -math.pi, -3 * math.pi / 4, 200, 280);
    distributeInBox(wives, 180, 320, 20, 120);
    distributeInBox(children, -80, 80, 120, 220);
    distributeInBox(grandchildren, -120, 120, 260, 340);
    distributeInBox(unclesAunts, -300, -160, -60, 100);
    distributeOnArc(cousins, math.pi / 2, 3 * math.pi / 4, 280, 340);
    distributeOnArc(traditional, -5 * math.pi / 6, -math.pi / 6, 380, 440);

    _positionsCache = positions;
  }

  void _handleTap(String? id, GenealogyRepository repo) {
    if (id == null) {
      _pathStart.value = null;
      _highlightedPath.value = [];
      return;
    }

    if (_pathStart.value != null && _pathStart.value != id) {
      // Tracer le chemin
      final path = repo.getPath(_pathStart.value!, id);
      _highlightedPath.value = path.map((m) => m.id).toList();
    } else {
      _selectedId.value = id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final repoAsync = ref.watch(genealogyRepositoryProvider);

    return repoAsync.when(
      data: (repo) {
        final members = repo.getAll();

        return Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final center = Offset(
                    constraints.maxWidth / 2,
                    constraints.maxHeight / 2,
                  );
                  _buildCachesIfNeeded(members, center);

                  return InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.15,
                    maxScale: 5.0,
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(2000),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: GestureDetector(
                        onTapUp: (details) {
                          final painter = ConstellationPainter(
                            members: members,
                            selectedId: null,
                            pathStartId: null,
                            highlightedPath: [],
                            center: center,
                            colors: context.colors,
                            positions: _positionsCache!,
                            edges: _edgesCache!,
                            onTap: (_) {},
                          );
                          final id = painter.hitTestMembers(
                            details.localPosition,
                          );
                          if (id == null) {
                            _selectedId.value = null;
                            _pathStart.value = null;
                            _highlightedPath.value = [];
                          } else {
                            _handleTap(id, repo);
                          }
                        },
                        onLongPressStart: (details) {
                          final painter = ConstellationPainter(
                            members: members,
                            selectedId: null,
                            pathStartId: null,
                            highlightedPath: [],
                            center: center,
                            colors: context.colors,
                            positions: _positionsCache!,
                            edges: _edgesCache!,
                            onTap: (_) {},
                          );
                          final id = painter.hitTestMembers(
                            details.localPosition,
                          );
                          if (id != null) {
                            _pathStart.value = id;
                            _highlightedPath.value = [];
                          }
                        },
                        child: RepaintBoundary(
                          child: AnimatedBuilder(
                            animation: Listenable.merge([
                              _selectedId,
                              _pathStart,
                              _highlightedPath,
                            ]),
                            builder: (context, _) {
                              return CustomPaint(
                                size: Size(
                                  constraints.maxWidth,
                                  constraints.maxHeight,
                                ),
                                painter: ConstellationPainter(
                                  members: members,
                                  selectedId: _selectedId.value,
                                  pathStartId: _pathStart.value,
                                  highlightedPath: _highlightedPath.value,
                                  center: center,
                                  colors: context.colors,
                                  positions: _positionsCache!,
                                  edges: _edgesCache!,
                                  onTap: (_) {},
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

            // Search Bar
            Positioned(
              top: context.space.md,
              left: context.space.md,
              right: context.space.md,
              child: _SearchBar(
                controller: _searchController,
                onSearch: (query) {
                  if (query.isEmpty) return;
                  final results = repo.search(query);
                  if (results.isNotEmpty) {
                    final target = results.first;
                    final pos = _positionsCache?[target.id];
                    if (pos != null) {
                      // Center approximation since LayoutBuilder size is not directly available here,
                      // we can use MediaQuery
                      final screenSize = MediaQuery.of(context).size;
                      final center = Offset(
                        screenSize.width / 2,
                        screenSize.height / 2,
                      );
                      _focusOnMember(target.id, pos, center);
                    }
                  }
                },
              ),
            ),

            // Légende
            Positioned(
              bottom: context.space.md,
              left: context.space.md,
              child: _Legend(),
            ),

            // Bouton recentrer
            Positioned(
              bottom: context.space.md,
              right: context.space.md,
              child: FloatingActionButton.small(
                onPressed: _recenter,
                backgroundColor: context.colors.bg2,
                child: Icon(Icons.my_location, color: context.colors.ink),
              ),
            ),

            // Person Chip
            Positioned(
              bottom: context.space.xl,
              left: context.space.md,
              right: context.space.md,
              child: ValueListenableBuilder<String?>(
                valueListenable: _selectedId,
                builder: (context, selectedId, child) {
                  if (selectedId == null) return const SizedBox.shrink();
                  final member = repo.getById(selectedId);
                  if (member == null) return const SizedBox.shrink();
                  return PersonChip(member: member);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(context.l10n.treeLoadError)),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onSearch});
  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.bg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(context.radii.pill),
        boxShadow: [
          BoxShadow(
            color: context.colors.ink.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: onSearch,
        decoration: InputDecoration(
          hintText: context.l10n.treeSearchHint,
          hintStyle: context.typo.body.copyWith(color: context.colors.muted),
          prefixIcon: Icon(Icons.search, color: context.colors.muted),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.space.md,
            vertical: context.space.sm,
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.space.sm),
      decoration: BoxDecoration(
        color: context.colors.bg.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(context.radii.sm),
        border: Border.all(color: context.colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _LegendItem(color: context.colors.accent, label: 'Prophète ﷺ'),
          _LegendItem(color: context.colors.ink, label: 'Ascendants'),
          _LegendItem(color: context.colors.accent2, label: 'Épouses'),
          _LegendItem(
            color: context.colors.accent.withValues(alpha: 0.8),
            label: 'Enfants',
          ),
          _LegendItem(color: context.colors.muted, label: 'Oncles & tantes'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: context.typo.caption.copyWith(color: context.colors.muted),
          ),
        ],
      ),
    );
  }
}
