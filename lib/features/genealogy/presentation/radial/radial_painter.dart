import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';
import 'package:sirah_app/features/genealogy/presentation/radial/radial_filters.dart';

class RadialPainter extends CustomPainter {
  RadialPainter({
    required this.members,
    required this.filter,
    required this.selectedId,
    required this.center,
    required this.colors,
    required this.onTap,
  }) {
    _updatePositions();
  }

  final List<FamilyMember> members;
  final GenealogyFilter filter;
  final String? selectedId;
  final Offset center;
  final AppColors colors;
  final ValueChanged<String?> onTap;

  static List<FamilyMember>? _cachedMembers;
  static Offset? _cachedCenter;
  static final Map<String, Offset> _positions = {};

  void _updatePositions() {
    if (_cachedMembers == members && _cachedCenter == center) return;

    _cachedMembers = members;
    _cachedCenter = center;
    _positions.clear();

    final orbits = <int, List<FamilyMember>>{0: [], 1: [], 2: [], 3: [], 4: []};

    for (final m in members) {
      final orbit = _getOrbitForRole(m);
      orbits[orbit]?.add(m);
    }

    final radii = {0: 0.0, 1: 90.0, 2: 170.0, 3: 250.0, 4: 340.0};

    for (final entry in orbits.entries) {
      final orbitIdx = entry.key;
      final orbitMembers = entry.value;
      final radius = radii[orbitIdx]!;

      for (var i = 0; i < orbitMembers.length; i++) {
        final m = orbitMembers[i];
        if (radius == 0.0) {
          _positions[m.id] = center;
        } else {
          final angle = (i / orbitMembers.length) * 2 * math.pi - math.pi / 2;
          _positions[m.id] =
              center +
              Offset(math.cos(angle) * radius, math.sin(angle) * radius);
        }
      }
    }
  }

  int _getOrbitForRole(FamilyMember m) {
    switch (m.role) {
      case FamilyRole.prophet:
        return 0;
      case FamilyRole.father:
      case FamilyRole.mother:
        return 1;
      case FamilyRole.wife:
        return (m.marriageOrder == 1) ? 1 : 2;
      case FamilyRole.child:
        return 2;
      case FamilyRole.paternalAscendant:
        return (m.generation == 2) ? 2 : 3;
      case FamilyRole.maternalAscendant:
        return (m.generation == 2) ? 2 : ((m.generation ?? 0) >= 3 ? 4 : 4);
      case FamilyRole.grandchild:
      case FamilyRole.uncle:
      case FamilyRole.aunt:
        return 3;
      case FamilyRole.cousin:
      case FamilyRole.traditionalAncestor:
        return 4;
    }
  }

  bool _isMemberInFilter(FamilyMember m) {
    switch (filter) {
      case GenealogyFilter.all:
        return true;
      case GenealogyFilter.wivesAndChildren:
        return [
          FamilyRole.wife,
          FamilyRole.child,
          FamilyRole.grandchild,
        ].contains(m.role);
      case GenealogyFilter.ancestors:
        return [
          FamilyRole.father,
          FamilyRole.mother,
          FamilyRole.paternalAscendant,
          FamilyRole.maternalAscendant,
        ].contains(m.role);
      case GenealogyFilter.unclesAndAunts:
        return [FamilyRole.uncle, FamilyRole.aunt].contains(m.role);
      case GenealogyFilter.ahlAlBayt:
        return ['ali', 'fatima', 'hasan', 'husayn', 'khadija'].contains(m.id) ||
            m.role == FamilyRole.prophet;
    }
  }

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

  @override
  void paint(Canvas canvas, Size size) {
    final radii = [90.0, 170.0, 250.0, 340.0];
    final orbitPaint = Paint()
      ..color = colors.line.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final r in radii) {
      canvas.drawCircle(center, r, orbitPaint);
    }

    for (final m in members) {
      final pos = _positions[m.id];
      if (pos == null) continue;

      final inFilter = _isMemberInFilter(m);
      final isSelected = m.id == selectedId;
      final opacity = inFilter ? 1.0 : 0.15;

      var radius = m.role == FamilyRole.prophet ? 10.0 : 5.0;
      if (isSelected) radius += 3.0;

      final baseColor = _getColorForRole(m.role);
      final dotPaint = Paint()
        ..color = baseColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      if (m.role == FamilyRole.prophet) {
        final auraPaint = Paint()
          ..color = colors.accent.withValues(alpha: 0.3 * opacity)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(pos, 18.0, auraPaint);
      }

      canvas.drawCircle(pos, radius, dotPaint);

      if (!m.isBoundary) {
        _drawLabels(canvas, m, pos, opacity);
      }
    }
  }

  void _drawLabels(Canvas canvas, FamilyMember m, Offset pos, double opacity) {
    final arabicPainter = TextPainter(
      text: TextSpan(
        text: m.arabic,
        style: TextStyle(
          fontSize: 9,
          color: colors.ink.withValues(alpha: opacity),
          fontFamily: 'Amiri',
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    final transPainter = TextPainter(
      text: TextSpan(
        text: m.transliteration,
        style: TextStyle(
          fontSize: 7,
          color: colors.muted.withValues(alpha: opacity),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    arabicPainter.paint(
      canvas,
      Offset(pos.dx - arabicPainter.width / 2, pos.dy + 8),
    );
    transPainter.paint(
      canvas,
      Offset(
        pos.dx - transPainter.width / 2,
        pos.dy + 8 + arabicPainter.height,
      ),
    );
  }

  String? hitTestMembers(Offset tapPosition) {
    for (final entry in _positions.entries) {
      final id = entry.key;
      final pos = entry.value;
      if ((tapPosition - pos).distance < 22.0) {
        return id;
      }
    }
    return null;
  }

  @override
  bool shouldRepaint(covariant RadialPainter oldDelegate) {
    return oldDelegate.filter != filter ||
        oldDelegate.selectedId != selectedId ||
        oldDelegate.colors != colors ||
        oldDelegate.center != center ||
        oldDelegate.members != members;
  }
}
