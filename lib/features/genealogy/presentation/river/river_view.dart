import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/genealogy_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';
import 'package:sirah_app/features/genealogy/data/repositories/genealogy_repository.dart';
import 'package:sirah_app/features/genealogy/presentation/river/river_node.dart';

enum RiverStream { paternal, maternal, descendants }

final riverStreamProvider = StateProvider<RiverStream>((ref) => RiverStream.paternal);

sealed class _StreamEntry {}
class _NodeEntry extends _StreamEntry {
  _NodeEntry(this.member, {this.isProphet = false});
  final FamilyMember member;
  final bool isProphet;
}
class _TributaryEntry extends _StreamEntry {
  _TributaryEntry(this.members);
  final List<FamilyMember> members;
}

class RiverView extends ConsumerStatefulWidget {
  const RiverView({super.key});

  @override
  ConsumerState<RiverView> createState() => _RiverViewState();
}

class _RiverViewState extends ConsumerState<RiverView> {
  List<_StreamEntry> _buildStream(RiverStream stream, GenealogyRepository repo) {
    switch (stream) {
      case RiverStream.paternal:
        return _buildPaternalStream(repo);
      case RiverStream.maternal:
        return _buildMaternalStream(repo);
      case RiverStream.descendants:
        return _buildDescendantsStream(repo);
    }
  }

  List<_StreamEntry> _buildPaternalStream(GenealogyRepository repo) {
    final entries = <_StreamEntry>[];
    final chain = <FamilyMember>[];
    
    var current = repo.getById('muhammad');
    while (current != null) {
      chain.add(current);
      if (current.isBoundary || current.parentId == null) break;
      
      final next = repo.getById(current.parentId!);
      if (next?.isTraditional == true) break;
      current = next;
    }

    final reversed = chain.reversed.toList();
    for (int i = 0; i < reversed.length; i++) {
      final m = reversed[i];
      entries.add(_NodeEntry(m, isProphet: m.role == FamilyRole.prophet));
      
      if (m.id == 'abdulmuttalib') {
        final unclesAunts = repo.getAll().where((x) => 
          (x.role == FamilyRole.uncle || x.role == FamilyRole.aunt) && 
          x.parentId == 'abdulmuttalib'
        ).toList();
        if (unclesAunts.isNotEmpty) {
          entries.add(_TributaryEntry(unclesAunts));
        }
      }
    }

    return entries;
  }

  List<_StreamEntry> _buildMaternalStream(GenealogyRepository repo) {
    final entries = <_StreamEntry>[];
    final chain = <FamilyMember>[];

    var current = repo.getById('amina');
    while (current != null) {
      chain.add(current);
      if (current.parentId == null) break;
      final next = repo.getById(current.parentId!);
      // Stop when we exit the maternal line (e.g. kilab is a paternalAscendant)
      if (next == null ||
          (next.role != FamilyRole.maternalAscendant &&
              next.role != FamilyRole.mother)) {
        break;
      }
      current = next;
    }

    for (final m in chain.reversed) {
      entries.add(_NodeEntry(m));
    }
    entries.add(_NodeEntry(repo.getProphet(), isProphet: true));

    return entries;
  }

  List<_StreamEntry> _buildDescendantsStream(GenealogyRepository repo) {
    final entries = <_StreamEntry>[];
    
    final prophet = repo.getProphet();
    entries.add(_NodeEntry(prophet, isProphet: true));

    final wives = repo.getByRole(FamilyRole.wife).toList()
      ..sort((a, b) => (a.marriageOrder ?? 99).compareTo(b.marriageOrder ?? 99));
    
    for (final w in wives) {
      entries.add(_NodeEntry(w));
    }

    final children = repo.getByRole(FamilyRole.child);
    for (final c in children) {
      entries.add(_NodeEntry(c));
    }

    final grandchildren = repo.getByRole(FamilyRole.grandchild);
    for (final gc in grandchildren) {
      entries.add(_NodeEntry(gc));
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final stream = ref.watch(riverStreamProvider);
    final repoAsync = ref.watch(genealogyRepositoryProvider);

    return repoAsync.when(
      data: (repo) {
        final entries = _buildStream(stream, repo);

        return Column(
          children: [
            _StreamSelector(
              activeStream: stream,
              onSelect: (s) => ref.read(riverStreamProvider.notifier).state = s,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: context.space.xl),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    const Positioned.fill(child: _RiverLine()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.space.xl),
                      child: Column(
                        children: [
                          for (int i = 0; i < entries.length; i++)
                            _buildEntry(entries[i], i)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(context.l10n.treeLoadError)),
    );
  }

  Widget _buildEntry(_StreamEntry entry, int index) {
    if (entry is _NodeEntry) {
      final isLeft = index % 2 == 0;
      return RiverNode(
        member: entry.member,
        isLeft: isLeft,
        isProphet: entry.isProphet,
        index: index,
      );
    } else if (entry is _TributaryEntry) {
      final isLeft = index % 2 == 0;
      return Tributary(
        members: entry.members,
        isLeft: isLeft,
        index: index,
      );
    }
    return const SizedBox.shrink();
  }
}

class _StreamSelector extends StatelessWidget {
  const _StreamSelector({required this.activeStream, required this.onSelect});
  final RiverStream activeStream;
  final ValueChanged<RiverStream> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.space.md,
        vertical: context.space.sm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StreamButton(
              label: context.l10n.treeRiverPaternal,
              isActive: activeStream == RiverStream.paternal,
              onTap: () => onSelect(RiverStream.paternal),
            ),
            SizedBox(width: context.space.sm),
            _StreamButton(
              label: context.l10n.treeRiverMaternal,
              isActive: activeStream == RiverStream.maternal,
              onTap: () => onSelect(RiverStream.maternal),
            ),
            SizedBox(width: context.space.sm),
            _StreamButton(
              label: context.l10n.treeRiverDescendants,
              isActive: activeStream == RiverStream.descendants,
              onTap: () => onSelect(RiverStream.descendants),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamButton extends StatelessWidget {
  const _StreamButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? context.colors.accent : context.colors.muted;
    final bgColor = isActive ? context.colors.accent.withValues(alpha: 0.15) : context.colors.bg2;
    final borderColor = isActive ? context.colors.accent : context.colors.line;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radii.pill),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.space.md,
          vertical: context.space.sm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(context.radii.pill),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: context.typo.button.copyWith(color: color),
        ),
      ),
    );
  }
}

class _RiverLine extends StatelessWidget {
  const _RiverLine();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Glow effect
        Positioned.fill(
          child: Center(
            child: Container(
              width: 14,
              decoration: BoxDecoration(
                color: context.colors.accent.withValues(alpha: 0.12),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.accent.withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Solid center line
        Positioned.fill(
          child: Center(
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.colors.accent.withValues(alpha: 0),
                    context.colors.accent,
                    context.colors.accent,
                    context.colors.accent.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.1, 0.9, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
