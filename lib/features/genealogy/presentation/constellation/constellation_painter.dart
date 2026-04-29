import 'package:flutter/material.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';

class ConstellationPainter extends CustomPainter {
  ConstellationPainter({
    required this.members,
    required this.selectedId,
    required this.pathStartId,
    required this.highlightedPath,
    required this.center,
    required this.colors,
    required this.positions,
    required this.onTap,
    required this.edges,
  });

  final List<FamilyMember> members;
  final String? selectedId;
  final String? pathStartId;
  final List<String> highlightedPath;
  final Offset center;
  final AppColors colors;
  final Map<String, Offset> positions;
  final ValueChanged<String?> onTap;
  final Map<String, List<String>> edges;

  Color _getColorForRole(FamilyRole role) {
    switch (role) {
      case FamilyRole.prophet:
        return colors.accent;
      case FamilyRole.wife:
        return colors.accent2;
      case FamilyRole.child:
      case FamilyRole.grandchild:
        return colors.accent.withValues(alpha: 0.8);
      case FamilyRole.uncle:
      case FamilyRole.aunt:
        return colors.muted;
      case FamilyRole.father:
      case FamilyRole.mother:
        return colors.ink;
      default:
        return colors.muted.withValues(alpha: 0.6);
    }
  }

  bool _isEdgeInHighlightedPath(String a, String b) {
    if (highlightedPath.isEmpty) return false;
    final indexA = highlightedPath.indexOf(a);
    final indexB = highlightedPath.indexOf(b);
    if (indexA == -1 || indexB == -1) return false;
    return (indexA - indexB).abs() == 1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dessiner les liens (edges)
    final drawnEdges = <String>{};

    for (final entry in edges.entries) {
      final from = entry.key;
      final posFrom = positions[from];
      if (posFrom == null) continue;

      for (final to in entry.value) {
        final edgeKey = from.compareTo(to) < 0 ? '$from-$to' : '$to-$from';
        if (drawnEdges.contains(edgeKey)) continue;
        drawnEdges.add(edgeKey);

        final posTo = positions[to];
        if (posTo == null) continue;

        final isHighlighted = _isEdgeInHighlightedPath(from, to);
        final distFromCenterA = (posFrom - center).distance;
        final distFromCenterB = (posTo - center).distance;
        final isNearProphet = distFromCenterA < 150 || distFromCenterB < 150;

        final paint = Paint()..style = PaintingStyle.stroke;

        if (isHighlighted) {
          paint.color = colors.accent;
          paint.strokeWidth = 2.0;
        } else {
          final baseOpacity = isNearProphet ? 0.6 : 0.2;

          // Appliquer atténuation si un noeud est sélectionné
          double opacity = baseOpacity;
          if (selectedId != null && pathStartId == null) {
            final isConnectedToSelected =
                (from == selectedId &&
                    edges[selectedId]?.contains(to) == true) ||
                (to == selectedId && edges[selectedId]?.contains(from) == true);
            if (!isConnectedToSelected) {
              opacity = 0.05; // Fade strongly non-connected edges
            } else {
              opacity = 0.8; // Boost connected edges slightly
            }
          }

          paint.color = colors.line.withValues(alpha: opacity);
          paint.strokeWidth = 0.8;
        }

        canvas.drawLine(posFrom, posTo, paint);
      }
    }

    // 2. Dessiner les étoiles
    final selectedConnections = selectedId != null
        ? (edges[selectedId] ?? [])
        : <String>[];

    for (final m in members) {
      final pos = positions[m.id];
      if (pos == null) continue;

      double r = 3.0;
      if (m.role == FamilyRole.prophet) {
        r = 12.0;
      } else if (m.role == FamilyRole.father ||
          m.role == FamilyRole.mother ||
          (m.role == FamilyRole.wife && m.marriageOrder == 1) ||
          (m.role == FamilyRole.child && m.id == 'fatima')) {
        r = 6.0;
      } else if (m.role == FamilyRole.child ||
          m.role == FamilyRole.grandchild ||
          m.role == FamilyRole.uncle) {
        r = 4.0;
      } else if (m.role == FamilyRole.traditionalAncestor) {
        r = 2.0;
      }

      final isSelected = m.id == selectedId;
      final isPathStart = m.id == pathStartId;
      final isHighlighted = highlightedPath.contains(m.id);
      final isConnectedToSelected =
          selectedId != null &&
          (isSelected || selectedConnections.contains(m.id));

      double opacity = 1.0;
      if (selectedId != null && pathStartId == null) {
        if (isConnectedToSelected) {
          opacity = 1.0;
        } else {
          opacity = 0.15;
        }
      }

      Color nodeColor = _getColorForRole(m.role);

      if (isPathStart) {
        nodeColor = colors.warning;
        r += 4.0;
        opacity = 1.0;
      } else if (isSelected && pathStartId == null) {
        r += 4.0;
        opacity = 1.0;
      } else if (isHighlighted) {
        opacity = 1.0;
        nodeColor = colors.accent;
      }

      if (m.role == FamilyRole.prophet) {
        final auraPaint = Paint()
          ..color = colors.accent.withValues(alpha: 0.25 * opacity)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 22.0, auraPaint);
      }

      final nodePaint = Paint()
        ..color = nodeColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, r, nodePaint);

      // 3. Dessiner les labels
      bool showLabel = true;
      if (m.isTraditional && !isSelected) {
        showLabel = false;
      }

      showLabel =
          showLabel &&
          _shouldShowLabel(
            m,
            isSelected: isSelected,
            isPathStart: isPathStart,
            isHighlighted: isHighlighted,
            isConnectedToSelected: isConnectedToSelected,
          );

      if (showLabel && opacity > 0.1) {
        // Ne pas dessiner le texte si trop transparent
        _drawLabels(canvas, m, pos, r, opacity);
      }
    }
  }

  bool _shouldShowLabel(
    FamilyMember member, {
    required bool isSelected,
    required bool isPathStart,
    required bool isHighlighted,
    required bool isConnectedToSelected,
  }) {
    if (isSelected || isPathStart || isHighlighted) return true;
    if (selectedId != null) return isConnectedToSelected;

    return switch (member.role) {
      FamilyRole.prophet || FamilyRole.father || FamilyRole.mother => true,
      FamilyRole.wife => member.marriageOrder == 1,
      FamilyRole.child => member.id == 'fatima',
      _ => false,
    };
  }

  void _drawLabels(
    Canvas canvas,
    FamilyMember m,
    Offset pos,
    double r,
    double opacity,
  ) {
    final arabicPainter = TextPainter(
      text: TextSpan(
        text: m.arabic,
        style: TextStyle(
          fontSize: 8,
          color: colors.ink.withValues(alpha: opacity),
          fontFamily: 'Amiri',
        ),
      ),
      textDirection: TextDirection.rtl,
      maxLines: 1,
      ellipsis: '...',
    )..layout(maxWidth: 88);

    final transPainter = TextPainter(
      text: TextSpan(
        text: m.transliteration,
        style: TextStyle(
          fontSize: 6,
          color: colors.muted.withValues(alpha: opacity),
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    )..layout(maxWidth: 104);

    final textY = pos.dy + r + 4;

    arabicPainter.paint(
      canvas,
      Offset(pos.dx - arabicPainter.width / 2, textY),
    );
    transPainter.paint(
      canvas,
      Offset(pos.dx - transPainter.width / 2, textY + arabicPainter.height),
    );
  }

  String? hitTestMembers(Offset tapPosition) {
    for (final entry in positions.entries) {
      final id = entry.key;
      final pos = entry.value;
      // Rayon d'interaction approx : max(radius + 8, 18)
      if ((tapPosition - pos).distance < 18.0) {
        return id;
      }
    }
    return null;
  }

  @override
  bool shouldRepaint(covariant ConstellationPainter oldDelegate) {
    return oldDelegate.selectedId != selectedId ||
        oldDelegate.pathStartId != pathStartId ||
        oldDelegate.highlightedPath != highlightedPath ||
        oldDelegate.colors != colors ||
        oldDelegate.center != center ||
        oldDelegate.members != members;
  }
}
