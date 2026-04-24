# Données Sirah — Handoff pack

Dossier à poser à la racine d'un nouveau repo Flutter avant de lancer Claude Code.

## Contenu

| Fichier | Rôle |
|---|---|
| `CLAUDE.md` | Règles et conventions, lues à chaque session Claude Code |
| `SPEC.md` | Spécification produit complète (écrans, flows, règles métier) |
| `DESIGN_SYSTEM.md` | Tokens, typos, thèmes, composants |
| `ROADMAP.md` | Phases séquentielles avec prompts prêts à copier |
| `data/names.json` | Les 201 noms typés |
| `data/categories.json` | Les 11 catégories |
| `designs/` | Captures PNG des wireframes A / B / C pour référence visuelle |

## Démarrage rapide

1. `flutter create --org com.sirah --project-name sirah_app .`
2. Copie tous ces fichiers à la racine (`CLAUDE.md`, `SPEC.md`, etc.)
3. Copie `data/names.json` et `data/categories.json` dans `assets/data/` (création du dossier)
4. Ouvre Claude Code dans le repo
5. Lance le premier prompt de `ROADMAP.md` (Phase 0.1)
6. Valide visuellement → phase suivante

## Pré-requis Flutter
- Flutter 3.24+
- Dart 3.5+
- Xcode 15+ (pour iOS)
- Android Studio / Android SDK 34

## Questions fréquentes pour Claude Code

> Peux-tu me générer le logo ?

Non. Je produis uniquement du code. Fournis un fichier `assets/icon/icon.png` 1024×1024.

> Peux-tu ajouter telle lib non listée ?

Non sans validation. Demande d'abord.

> L'arabe ne s'affiche pas bien sur Android

Vérifie que `AmiriQuran-Regular.ttf` est bien dans `assets/fonts/` et déclaré dans `pubspec.yaml`, et que `Directionality` est appliquée correctement.

## Licences & attributions

- Police **Amiri Quran** — SIL OFL (libre)
- Police **Crimson Pro** — SIL OFL (libre)
- Police **Playfair Display** — SIL OFL (libre)
- Police **Inter** — SIL OFL (libre)
- Données des 201 noms : sources classiques citées dans chaque entrée (domaine public)

## Support

En cas de blocage, retourner vers les wireframes HTML originaux pour clarifier l'intention visuelle.
