import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';

/// Retourne le label localisé d'un rôle familial.
/// Utilisation : `familyRoleLabel(context, member.role)`
String familyRoleLabel(BuildContext context, FamilyRole role) {
  final l10n = context.l10n;
  switch (role) {
    case FamilyRole.prophet:            return l10n.treeRoleProphet;
    case FamilyRole.father:             return l10n.treeRoleFather;
    case FamilyRole.mother:             return l10n.treeRoleMother;
    case FamilyRole.paternalAscendant:  return l10n.treeRolePaternalAncestor;
    case FamilyRole.maternalAscendant:  return l10n.treeRoleMaternalAncestor;
    case FamilyRole.uncle:              return l10n.treeRoleUncle;
    case FamilyRole.aunt:               return l10n.treeRoleAunt;
    case FamilyRole.wife:               return l10n.treeRoleWife;
    case FamilyRole.child:              return l10n.treeRoleChild;
    case FamilyRole.grandchild:         return l10n.treeRoleGrandchild;
    case FamilyRole.cousin:             return l10n.treeRoleCousin;
    case FamilyRole.traditionalAncestor: return l10n.treeRoleTraditionalAncestor;
  }
}
