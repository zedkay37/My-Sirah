# Changelog — Sirah Hub

Toutes les versions notables de ce projet.
Format basé sur [Keep a Changelog](https://keepachangelog.com/fr/).

---

## [v2.0.0-beta.3] - 2026-05-02 - Beta release finale

### Ameliorations

- **Voyage** : suppression des barres noires de header sur galaxie et constellations au profit d'une navigation flottante immersive.
- **Voyage** : bouton retour de constellation rendu fiable au-dessus de la couche zoom/pan.
- **Voyage** : titre flottant plus visible et premium, avec accent or sur la page galaxie.
- **Constellations** : meilleur espacement entre la calligraphie arabe et le titre francais pour eviter les chevauchements.
- **Profil** : lanterne plus expressive avec halo et lumiere ambiante plus lisibles selon la progression reelle.

### Release Android

- Version applicative : `2.0.0-beta.3+9`.

---

## [v2.0.0-beta.2] - 2026-05-01 - Dernier patch beta avant diffusion elargie

### Ajouts

- **Asma al-Husna** : ajout des QCM et flashcards dans le deck Bibliotheque dedie, sans melanger avec le Voyage des 201 noms.
- **Quiz multi-deck** : le moteur d'entrainement gere maintenant les noms du Prophete et Asma al-Husna avec la meme UX.
- **Voyage** : illumination progressive des etoiles et des lignes selon le cheminement (`viewed`, `meditated`, `practiced`, `recognized`).
- **Voyage immersif** : retrait de la consigne permanente en haut de constellation pour laisser plus de place a la carte.

### Release Android

- Version applicative : `2.0.0-beta.2+8`.

### Validation

- `flutter gen-l10n` execute.
- `flutter analyze --no-pub` : aucune issue.
- `flutter test` : 130 tests passent.
- `flutter build apk --debug` : OK.
- `flutter build apk --release` : OK.

---

## [v2.0.0-beta.1] — 2026-05-01 · Beta Android Journey V2

### Ajouts

- **Journey V2** : Voyage stellaire complet autour des 201 noms du Prophète ﷺ, organisé en 11 constellations.
- **Nom vivant** : route principale `/name/:number/experience` avec sens, commentaire, tafakkur, action validée quand disponible et navigation vers la fiche.
- **Profil V2** : synthèse de cheminement centrée sur la lanterne et les statuts `viewed`, `meditated`, `practiced`, `recognized`.
- **Accueil beta** : nom du jour déterministe, action du jour validée si disponible, reprise du chemin et carte condensée.
- **Bibliothèque clarifiée** : entrée par corpus, outils QCM/flashcards dans le deck concerné, suppression des entrées redondantes de révision libre/parcours non prêts.

### Release Android

- Version applicative : `2.0.0-beta.1+7`.
- Icône launcher Android générée et intégrée.
- Build release signé avec clé locale dédiée, sans fallback debug.
- Bêta publique déclarée FR-only tant que la l10n arabe n'est pas revue.
- Artifacts vérifiés : APK universel, APK split ABI et AAB.

### Validation

- `flutter analyze --no-pub` : aucune issue.
- `flutter test` : 128 tests passent.
- `flutter build apk --debug` : OK.
- `flutter build apk --release` : OK.
- `flutter build apk --release --split-per-abi` : OK.
- `flutter build appbundle --release` : OK.
- Signature APK vérifiée avec `apksigner`.

---

## [v1.5.1] — 2026-04-27 · Robustesse Hive, notifications et l10n

### Correctifs

- **Notifications quotidiennes** : `NotificationService` initialise maintenant `timezone` sur `Europe/Paris` et programme les rappels avec `tz.local` au lieu d'une conversion UTC explicite.
- **HiveSource** : parsing défensif champ par champ pour les listes, maps, dates et entiers. Une valeur corrompue n'efface plus tout l'état utilisateur.
- **L10n** : migration de textes UI restants vers `context.l10n` pour la 404, le hub Découvrir et les écrans Asmāʾ al-Ḥusnā.
- **Docs** : synchronisation README, architecture et référence développeur avec l'état réel du code.

### Validation

- `flutter gen-l10n` exécuté.
- `dart format` exécuté.
- `flutter analyze` : aucune issue.
- `flutter test` : 18 tests passent.

---

## [v1.5] — 2026-04-27 · Audit Patch 2 : Domain Notifiers & Correctifs architecturaux

### Refactoring majeur : Domain Notifiers (Facade Pattern)

Le `SettingsNotifier` était un *God Object* gérant 5 domaines métier distincts.
Problème résolu par le **Facade Pattern** : 4 `Provider<T>` qui délèguent toutes les
mutations à `settingsProvider.notifier`, évitant toute race condition sur Hive.

**Nouveaux fichiers**

| Fichier | Rôle |
|---------|------|
| `lib/features/names/data/names_notifier.dart` | Facade Noms : favorites, learned, viewed, toggleFavorite, markLearned, markViewed |
| `lib/features/study/data/study_notifier.dart` | Facade Étude : leitnerBoxes, completedParcours, levelUp/Down, getItemsForReview |
| `lib/features/genealogy/data/genealogy_notifier.dart` | Facade Généalogie : favoriteMembers, viewedMembers, preferredTreeView |
| `lib/features/asmaul_husna/data/asmaa_notifier.dart` | Facade Asmāʾ : husnaLearned, markHusnaLearned |
| `lib/features/genealogy/shared/family_role_labels.dart` | Labels de rôles familiaux partagés (rivière + fiche détail) |
| `lib/core/utils/color_utils.dart` | `hexToColor()` extrait en utilitaire réutilisable |

**Fichiers supprimés**

- `lib/features/study/data/leitner_repository.dart` → logique absorbée dans `StudyNotifier`
- `lib/core/models/learning_deck.dart` + `learning_item.dart` → code mort depuis V1.3

### Correctifs architecturaux

- **Routing** : `HomeScreen` pointait vers `/study/parcours-list` au lieu de `/study`
- **Lifecycle** : `PersonDetailScreen` converti en `ConsumerStatefulWidget` — `markMemberViewed()` déplacé dans `initState` / `didUpdateWidget` (plus d'effet de bord dans `build`)
- **L10n** : `RadialFilters` utilisait des chaînes en dur → `context.l10n.treeFilter*`
- **L10n** : Ajout des clés `treeFilterAll`, `treeFilterWivesAndChildren`, `treeFilterAncestors`, `treeFilterUnclesAndAunts`, `treeFilterAhlAlBayt` (FR + AR)
- `Parcours` model déplacé dans `features/study/data/models/` avec Freezed propre

### Migration complète des call sites

Tous les `ref.read(settingsProvider.notifier).X` hors-périmètre remplacés par les facades :
Quiz (QCM + Flashcards), Study (Entry + Parcours Detail + Review), Names (List + Detail + Tafakkur), Genealogy (Tree + Person Detail), Asmāʾ (Husna Detail), Profile (Favorites).

---

## [v1.4] — 2026-04-27 · Hub Découvrir + Deck Asmāʾ al-Ḥusnā (99 Noms d'Allah)

### Ajouts

- **Hub Découvrir** : refonte de l'onglet Découvrir en hub extensible par deck
  - `DiscoverScreen` : point d'entrée avec cartes vers chaque deck
  - `ProphetsDiscoverScreen` : liste + quiz noms du Prophète (extrait de HomeScreen)
- **Deck Asmāʾ al-Ḥusnā** (99 Noms d'Allah) — module complet :
  - `HusnaName` : modèle Freezed (id, arabic, transliteration, meaningFr, etymology, reference)
  - `HusnaJsonSource` + `HusnaRepository` : chargement JSON offline
  - `HusnaListScreen` : liste complète searchable, badge "appris"
  - `HusnaDetailScreen` : fiche avec étymologie, référence, auto-appris 8s, navigation prev/next dynamique
  - `UserState.husnaLearned` : `Set<int>` des IDs appris, persisté dans Hive
  - `husnaRepositoryProvider` : FutureProvider exposé dans `husna_providers.dart`
- `assets/data/asmaul_husna.json` : 99 entrées sourcées (liste Tirmidhī)

### Correctifs (Audit Patch 1)

- **Constantes dynamiques** : suppression des `int` en dur dans `NamesJsonSource`
- **Page 404** : `errorBuilder` go_router avec retour `/home` et message localisé
- **Hive robuste** : `int.tryParse()` + `value is int` — jamais de cast brutal dans `_fromMap()`

---

## [v1.3] — 2026-04-26 · Mode Étude : Parcours Thématiques + Leitner SRS

### Ajouts

- **8 Parcours thématiques** (`assets/data/parcours.json`) :
  - Chaque parcours : liste ordonnée de noms + titre + description + couleur hexadécimale
  - `ParcoursListScreen` : liste avec badge "terminé" par parcours
  - `ParcoursDetailScreen` : navigation nom par nom avec barre de progression, `markParcoursComplete()` + `levelUp()` à complétion
- **Mode Revue Leitner** (Spaced Repetition flashcards) :
  - File de revue : noms niveau 0 + niveau 1 en priorité
  - `ReviewController` (`StateNotifier` + Freezed) : flip, know, unsure, avance auto 1200ms
  - `getItemsForReview(allNumbers)` : sélection par niveau Leitner
  - `LeitnerRepository` : facade `Provider` sur `settingsProvider` (remplacé par `StudyNotifier` en V1.5)
- **StudyEntryScreen** : hub d'entrée avec mode Parcours et mode Revue
- **Modèle `Parcours`** : Freezed + JSON serializable
- `UserState` : ajout `leitnerBoxes`, `completedParcours`, `studyMode`

---

## [v1.2] — 2026-04-26 · Mode Tafakkur + Rebrand + Enrichissement généalogie

### Ajouts

- **Mode Tafakkur** (contemplation guidée par un nom) :
  - Découpe du commentaire en phrases affichées une à une
  - Zoom progressif du texte (TweenAnimationBuilder 17 → 31 sp)
  - Overlay d'obscurité progressive (4 niveaux, `CustomPainter`)
  - Barre de progression, pause/reprise, dialog de confirmation de sortie (PopScope)
  - `levelUp()` Leitner automatique à complétion via `ref.listen`
  - Accès depuis `DetailScreen` (bouton dédié)
  - `TafakkurController` : `StateNotifier` Freezed gérant index, rythme, pause, durée
- **Rebrand** : application renommée "Sirah Hub" partout (UI + titres)
- **Thème Violet** : renommage "Constellation" → "Violet" + correctifs de lisibilité en mode sombre
- **Enrichissement généalogie** : 25 fiches personnages avec biographies sourcées
- Fix Android : `coreLibraryDesugaringEnabled = true` pour `flutter_local_notifications`

### Correctifs L10n

- Toutes les clés Tafakkur ajoutées (`intl_fr.arb` + `intl_ar.arb`)

---

## [v1.1] — 2026-04-26 · Module Généalogie (arbre interactif)

### Ajouts

- **Arbre généalogique** — 67 personnages sourcés :
  - `FamilyMember` : modèle Freezed avec id, arabic, transliteration, rôle, parentId, motherId, spouseOf, dates, bio, laqab, kunya
  - `GenealogyRepository` : chargement JSON + BFS `getPath(id, 'muhammad')` + filtres par rôle
- **3 modes de visualisation interactifs** :
  - **Radiale** : vue 360° avec 5 filtres (Tous / Femmes & Enfants / Ancêtres / Oncles & Tantes / Ahl al-Bayt)
  - **Constellation** : exploration nœud par nœud, mode Path Tracing (BFS vers le Prophète ﷺ)
  - **Rivière de Lumière** : timeline verticale en 3 flux (Paternel / Maternel / Descendants)
- **Vue liste** alphabétique des membres avec badges favoris
- **Fiche détail personne** : biographie, dates naissance/mort, relation au Prophète, chemin BFS affiché, passerelles vers noms du Prophète, section "Voir aussi" (parents/conjoints)
- Persistance : `favoriteMembers`, `viewedMembers`, `preferredTreeView` dans `UserState`

### Correctifs

- Fix router : rebuild uniquement sur `onboardingCompletedAt`, pas sur tout `UserState`

---

## [v1.0] — 2026-04-26 · Module Noms du Prophète ﷺ (fondation)

### Fondation complète de l'application

- **201 Noms du Prophète ﷺ** avec translittération, étymologie, commentaire, références, catégorie, sources primaires/secondaires
- **11 catégories sémantiques** : Noblesse, Révélation, Miséricorde, Lumière, Prophétie, Messager, Compagnon, Création, Jugement, Paradis, Noms propres
- **ListScreen** : filtrage par catégorie + recherche full-text (arabe, latin, commentaire, étymologie)
- **DetailScreen** : swipeable `PageView`, timer d'apprentissage 8s (marque automatiquement appris), barre de progression mémorisation, partage image via `ShareNameService`
- **Quiz** : mode QCM (10 questions, distracteurs même catégorie) + mode Flashcards, `QuizGenerator`, `ReviewController`, `ResultScreen`
- **HomeScreen** : `DailyNameCard` (nom du jour via époque statique), `CategoryCarousel` cliquable
- **Profil** : stats dynamiques (total noms/appris/vus), constellation animée, thème, taille texte
- **Favoris** : `FavoritesScreen` avec filtrage dynamique
- **Onboarding** : 5 étapes avec configuration notification quotidienne
- **3 thèmes** : Clair / Sombre / Violet (constellation)
- **Persistance offline** Hive : `UserState` (favorites, learned, viewed, lastSeen, theme, textSize, notifHour, quiz stats)
- **L10n** FR + AR — système `intl` avec `.arb` comme source de vérité
- **Navigation** `go_router` : 4 onglets `StatefulShellRoute` + routes modales + transition `_fadeSlide`
- **Notifications locales** programmées quotidiennement (`flutter_local_notifications`)
- **Onboarding** : redirection automatique si non complété

### Stack initiale

Flutter 3.24 / Dart 3 / Riverpod 2 / Hive CE / Freezed / go_router / google_fonts / intl / flutter_animate / flutter_local_notifications
