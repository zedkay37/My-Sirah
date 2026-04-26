# Asmāʾ an-Nabī — Les 201 noms du Prophète ﷺ

Application mobile Flutter permettant d'explorer, d'apprendre et de mémoriser les 201 noms du Prophète Muḥammad ﷺ, avec une expérience de lecture approfondie, un arbre généalogique interactif et une gamification douce.

---

## Table des matières

1. [Vision et périmètre](#1-vision-et-périmètre)
2. [Stack technique](#2-stack-technique)
3. [Lancer le projet](#3-lancer-le-projet)
4. [Architecture des dossiers](#4-architecture-des-dossiers)
5. [Système de thèmes](#5-système-de-thèmes)
6. [Données — names.json, categories.json, genealogy.json](#6-données--namesjson-categoriesjson-genealogyjson)
7. [État utilisateur et persistance](#7-état-utilisateur-et-persistance)
8. [Navigation (go_router)](#8-navigation-go_router)
9. [Internationalisation (l10n)](#9-internationalisation-l10n)
10. [Module Noms — écrans implémentés](#10-module-noms--écrans-implémentés)
11. [Module Arbre généalogique](#11-module-arbre-généalogique)
12. [Widgets partagés](#12-widgets-partagés)
13. [Système de quiz](#13-système-de-quiz)
14. [Partage d'image](#14-partage-dimage)
15. [Tests](#15-tests)
16. [Problèmes connus et blocages](#16-problèmes-connus-et-blocages)
17. [Roadmap](#17-roadmap)

---

## 1. Vision et périmètre

L'application est conçue comme un **écosystème de connaissance et d'amour du Prophète ﷺ**, construit module par module. Architecture modulaire obligatoire : chaque feature vit sous `lib/features/` et est autonome. Aucune logique métier spécifique à un module ne se trouve dans `core/`.

### Modules livrés

| Version | Module | Contenu |
|---------|--------|---------|
| **V1** | **Noms** | Explorer, apprendre et mémoriser les 201 noms du Prophète ﷺ |
| **V1.1** | **Arbre généalogique** | Visualisation interactive de la lignée prophétique en 3 modes |

### Modules prévus

- Sīra (biographie) interactive
- Khaṣāʾiṣ (qualités et particularités)
- Shamāʾil (descriptions physiques et de caractère)
- Hadiths thématiques
- Ṣalawāt et invocations

### Règles produit V1

| Règle | Détail |
|-------|--------|
| **Nom du jour** | Déterministe par date — `daysSinceEpoch(depuis 2025-01-01) % 201`. Identique pour tous les utilisateurs. |
| **Marquage "appris"** | Un nom est marqué appris après **8 secondes** de consultation, **ou** bonne réponse QCM, **ou** "Je connais" en flashcard. |
| **Quiz V1** | 2 formats uniquement : QCM (description → nom) et Flashcards retournables. Pas de badges, pas de points. |
| **Navigation** | Tab bar 3 onglets : Accueil, Découvrir (liste + quiz en sous-onglets), Profil. |
| **Constellation** | Visualisation signature du profil. 201 étoiles à positions stables (spirale Golden Ratio). |
| **Hors-ligne** | 100% fonctionnel. Aucun backend V1, aucune dépendance réseau au runtime. |
| **Langue V1** | FR uniquement. L10n préparée pour AR/EN. |

---

## 2. Stack technique

| Domaine | Package | Version |
|---------|---------|---------|
| Framework | Flutter | 3.35.7 |
| Language | Dart | 3.9.2 |
| State management | flutter_riverpod | ^2.5.1 |
| Navigation | go_router | ^14.6.2 |
| Persistance locale | hive_ce + hive_ce_flutter | ^2.6.0 / ^2.2.0 |
| Modèles immuables | freezed_annotation + json_annotation | ^2.4.4 / ^4.9.0 |
| Fonts | google_fonts | ^6.2.1 |
| Animations | flutter_animate | ^4.5.2 |
| Partage | share_plus | ^9.0.0 |
| i18n + dates | intl + hijri | ^0.20.2 / ^3.0.0 |
| **Dev** | build_runner, freezed, json_serializable, hive_ce_generator | — |

> **Note :** `flutter_local_notifications` est exclu en V1 (voir §15).

---

## 3. Lancer le projet

```bash
# Dépendances
flutter pub get

# Génération du code (freezed, json_serializable, hive adapters)
dart run build_runner build --delete-conflicting-outputs

# Génération des fichiers l10n
flutter gen-l10n

# Lancer sur un appareil connecté
flutter run

# Lancer sur un appareil spécifique (si plusieurs connectés)
flutter run -d <device_id>

# Tests
flutter test

# Analyse statique
flutter analyze
```

---

## 4. Architecture des dossiers

```
lib/
├── main.dart                          # Entrée : init Hive, runApp avec ProviderScope
├── app.dart                           # MaterialApp.router, watch settingsProvider + appRouterProvider
│
├── core/
│   ├── theme/
│   │   ├── app_theme.dart             # AppTheme.build(ThemeKey) → ThemeData
│   │   ├── theme_key.dart             # enum ThemeKey { light, dark, feminine }
│   │   ├── app_colors.dart            # ThemeExtension<AppColors> + palettes catégorie par thème
│   │   ├── app_typography.dart        # ThemeExtension<AppTypography> + buildArabic()
│   │   ├── app_spacing.dart           # ThemeExtension<AppSpacing> (xs/sm/md/lg/xl/xxl)
│   │   ├── app_radius.dart            # ThemeExtension<AppRadius> (sm/md/lg/pill + helpers BorderRadius)
│   │   ├── app_elevation.dart         # ThemeExtension<AppElevation> (card/modal/fab/glow)
│   │   └── themes/
│   │       ├── light_theme.dart       # Crème / vert profond / Crimson Pro
│   │       ├── dark_theme.dart        # Nuit / or / Crimson Pro + glow
│   │       └── feminine_theme.dart    # Lavande / violet / Playfair Display
│   ├── router/
│   │   └── app_router.dart            # GoRouter avec StatefulShellRoute (3 tabs) + toutes les routes
│   ├── storage/
│   │   └── hive_source.dart           # Init Hive, lecture/écriture UserState sérialisé en JSON
│   ├── providers/
│   │   ├── user_state.dart            # @freezed UserState (thème, favoris, appris, vus, streak…)
│   │   ├── settings_provider.dart     # NotifierProvider<SettingsNotifier, UserState>
│   │   ├── names_providers.dart       # namesRepositoryProvider, namesProvider, dailyNameProvider,
│   │   │                              # categoriesProvider, learnedCountsProvider
│   │   └── genealogy_providers.dart   # genealogyRepositoryProvider, genealogyMembersProvider
│   └── utils/
│       └── build_context_x.dart       # Extension BuildContextX (.colors .typo .space .radii .elevation .l10n)
│
├── features/
│   ├── names/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── prophet_name.dart  # @freezed ProphetName (voir §6)
│   │   │   │   └── category.dart      # enum Category { praise, prophethood, … } + fromSlug()
│   │   │   ├── sources/
│   │   │   │   ├── names_json_source.dart      # Charge assets/data/names.json via rootBundle
│   │   │   │   └── categories_json_source.dart # Charge assets/data/categories.json
│   │   │   └── repositories/
│   │   │       └── names_repository.dart       # getAll(), getByCategory(), search(), getByNumber(), getDailyName()
│   │   └── presentation/
│   │       ├── home/
│   │       │   ├── home_screen.dart        # Écran Accueil
│   │       │   ├── daily_name_card.dart    # Carte nom du jour (~58% hauteur écran)
│   │       │   └── category_carousel.dart  # Carrousel horizontal 11 catégories
│   │       ├── list/
│   │       │   ├── discover_screen.dart    # DefaultTabController : "Tous les noms" | "Quiz"
│   │       │   └── list_screen.dart        # Recherche + filtres catégorie + ListView 201 noms
│   │       └── detail/
│   │           ├── detail_screen.dart      # PageView swipeable, timer 8s, favori, toutes sections
│   │           └── share_name_service.dart # Rendu canvas 1080×1080 + share_plus
│   ├── onboarding/
│   │   └── presentation/
│   │       └── onboarding_screen.dart      # 3 pages : Bienvenue, Thème, Notifications
│   ├── quiz/
│   │   ├── data/
│   │   │   ├── quiz_generator.dart    # QuizGenerator + QcmQuestion + QuizSession
│   │   │   └── quiz_provider.dart     # StateProvider<QuizSession?>
│   │   └── presentation/
│   │       ├── entry/quiz_entry_screen.dart      # Choix QCM ou Flashcards
│   │       ├── qcm/qcm_screen.dart               # QCM 5 questions avec feedback animé
│   │       ├── flashcards/flashcards_screen.dart  # Flashcards avec flip Matrix4
│   │       └── result/result_screen.dart          # Résultat avec message contextuel
│   ├── profile/
│   │   └── presentation/
│   │       ├── profile/profile_screen.dart     # Constellation + stats + raccourcis
│   │       ├── settings/settings_screen.dart   # Thème, notification, à propos
│   │       └── favorites/favorites_screen.dart # Liste filtrée des favoris
│   ├── genealogy/                          # MODULE V1.1 — Arbre généalogique
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── family_member.dart      # @freezed FamilyMember + FamilyRole enum (12 valeurs)
│   │   │   └── repositories/
│   │   │       └── genealogy_repository.dart  # .load(), getAll(), getById(), getByRole(),
│   │   │                                       # getChildren(), search(), getPath() — BFS
│   │   └── presentation/
│   │       ├── tree_screen.dart            # Conteneur principal : TabBar 3 modes + TabBarView
│   │       ├── radial/
│   │       │   ├── radial_view.dart        # ConsumerStatefulWidget, TransformationController
│   │       │   ├── radial_painter.dart     # CustomPainter : 4 orbites, labels, hitTest
│   │       │   └── radial_filters.dart     # GenealogyFilter enum + RadialFilters chip bar
│   │       ├── constellation/
│   │       │   ├── constellation_view.dart # Graph zoomable, search, path tracing, PersonChip
│   │       │   └── constellation_painter.dart  # CustomPainter : arêtes, étoiles, labels
│   │       ├── river/
│   │       │   ├── river_view.dart         # RiverStream {paternal, maternal, descendants}
│   │       │   └── river_node.dart         # RiverNode (alterné G/D) + Tributary (mini-cartes)
│   │       ├── detail/
│   │       │   ├── person_detail_screen.dart  # Fiche complète : sections, passerelle noms, links
│   │       │   └── path_chip.dart          # PathChip : chemin BFS en chips horizontales
│   │       ├── list/
│   │       │   └── tree_list_screen.dart   # Liste par groupes avec Semantics
│   │       └── shared/
│   │           └── person_chip.dart        # PersonChip partagé (radial + constellation)
│   └── shared/
│       ├── arabic_text.dart      # ArabicText(text, size: ArabicSize, withShadow, textAlign…)
│       ├── name_card.dart        # NameCard(name, isFavorite, onTap, onFavoriteTap)
│       ├── category_chip.dart    # CategoryChip(slug, label, variant: filled/outlined/small)
│       ├── progress_ring.dart    # ProgressRing(progress 0–1, size, strokeWidth) — CustomPainter
│       ├── quiz_card.dart        # QuizCard(name, isFlipped, onFlip) — flip animation Matrix4
│       ├── section_header.dart   # SectionHeader(title) — titre avec ornements dégradés
│       └── streak_badge.dart     # StreakBadge(days, animate) — avec flutter_animate scale
│
├── l10n/
│   ├── app_localizations.dart      # Généré par flutter gen-l10n
│   ├── app_localizations_fr.dart   # FR (source)
│   └── app_localizations_ar.dart   # AR (placeholder vide)
│
assets/
├── data/
│   ├── names.json        # 201 entrées — NE PAS MODIFIER sans prévenir
│   ├── categories.json   # 11 catégories (slug, labelFr, count)
│   └── genealogy.json    # Arbre généalogique (~80 membres) — NE PAS MODIFIER sans prévenir
└── fonts/                # Fonts Amiri Quran en local (perf offline)
```

---

## 5. Système de thèmes

### 3 variantes

| ThemeKey | Ambiance | Fond | Accent | Font éditoriale |
|----------|----------|------|--------|-----------------|
| `light` | Éditorial sobre | `#F5F1E8` crème | `#1F5942` vert profond | Crimson Pro |
| `dark` | Nuit + or | `#141312` nuit | `#D4A857` or + glow | Crimson Pro |
| `feminine` | Constellation | `#F7F4FF` lavande | `#6B4EF2` violet | Playfair Display |

### Règle absolue — pas de couleur en dur dans les widgets

```dart
// CORRECT
Text('...', style: context.typo.displayMedium.copyWith(color: context.colors.accent));

// INTERDIT
Text('...', style: TextStyle(color: Color(0xFF1F5942)));
```

Exception documentée : les cartes de prévisualisation dans l'onboarding et les paramètres doivent afficher les couleurs des thèmes non actifs — elles appellent `AppTheme.build(key).extension<AppColors>()` pour obtenir les tokens d'un thème spécifique.

### Accès aux tokens

```dart
final colors = context.colors;    // AppColors
final typo   = context.typo;      // AppTypography
final space  = context.space;     // AppSpacing
final radii  = context.radii;     // AppRadius
final elev   = context.elevation; // AppElevation
final l10n   = context.l10n;      // AppLocalizations
```

### Tokens disponibles

**AppColors :** `bg`, `bg2`, `ink`, `muted`, `accent`, `accent2`, `line`, `success`, `warning`, `error`
+ `categoryColor(slug)` et `categoryBg(slug)` (10% opacity) — couleurs spécifiques aux 11 catégories, différentes par thème.

**AppTypography :** `arabicHero` (88sp), `arabicLarge` (56sp), `arabicMedium` (32sp), `arabicBody` (22sp),
`displayLarge` (36sp), `displayMedium` (28sp), `headline` (20sp), `bodyLarge` (16sp), `body` (14sp),
`caption` (12sp), `overline` (10sp uppercase lettre-espacé), `button` (14sp medium)

**AppSpacing :** `xs=4`, `sm=8`, `md=16`, `lg=24`, `xl=32`, `xxl=48`

**AppRadius :** `sm=6`, `md=12`, `lg=18`, `pill=999` + helpers `smAll / mdAll / lgAll / pillAll` → `BorderRadius`

### Changement de thème

```dart
ref.read(settingsProvider.notifier).setTheme(ThemeKey.dark);
// Persisté dans Hive → rebuild automatique de toute l'app via app.dart
```

---

## 6. Données — names.json, categories.json, genealogy.json

### Mapping JSON → Dart (`ProphetName`)

Le fichier JSON n'utilise pas les mêmes noms de champs que le modèle Dart. Le mapping est géré par `@JsonKey` dans le modèle freezed :

| Champ JSON | Champ Dart | Type | Notes |
|------------|------------|------|-------|
| `id` | `number` | `int` | 1–201 |
| `arabic` | `arabic` | `String` | Texte arabe avec voyelles |
| `transliteration` | `transliteration` | `String` | Translittération académique |
| `category` | `categoryLabel` | `String` | Label FR affiché ("Louange") |
| `categorySlug` | `categorySlug` | `String` | Clé technique ("praise") |
| `etymology` | `etymology` | `String` | |
| `commentary` | `commentary` | `String` | |
| `references` | `references` | `String` | |
| `primarySource` | `primarySource` | `String` | |
| `secondarySources` | `secondarySources` | `String` | |

### Les 11 catégories

| slug | Label FR |
|------|----------|
| `praise` | Louange |
| `prophethood` | Prophétie |
| `intercession` | Intercession |
| `eschatology` | Eschatologie |
| `purity` | Pureté |
| `virtues` | Vertus |
| `miraj` | Miʿrāj |
| `guidance` | Guidance |
| `light` | Lumière |
| `nobility` | Noblesse |
| `devotion` | Dévotion |

### Chargement et cache Riverpod

Les données sont chargées **une seule fois** au démarrage via `namesRepositoryProvider` (`FutureProvider`). Toutes les autres providers dérivent de ce cache — pas de double lecture du fichier JSON.

```dart
final names   = ref.watch(namesProvider);           // AsyncValue<List<ProphetName>>
final daily   = ref.watch(dailyNameProvider);        // AsyncValue<ProphetName>
final cats    = ref.watch(categoriesProvider);       // AsyncValue<List<NameCategory>>
final counts  = ref.watch(learnedCountsProvider);    // Map<slug, int> — recalculé si learned change
```

### genealogy.json — Structure

Le fichier `assets/data/genealogy.json` contient ~80 membres de la famille du Prophète ﷺ. Chaque entrée est un objet `FamilyMember` :

| Champ JSON | Type | Notes |
|------------|------|-------|
| `id` | `String` | Clé unique (ex: `"muhammad"`, `"khadija"`) |
| `arabic` | `String` | Nom en arabe avec voyelles |
| `transliteration` | `String` | Translittération académique |
| `role` | `String` | Voir `FamilyRole` ci-dessous |
| `generation` | `int?` | Profondeur depuis le Prophète ﷺ (ancestres) |
| `marriageOrder` | `int?` | Ordre de mariage pour les épouses (1 = Khadīja) |
| `parentId` | `String?` | ID du père |
| `motherId` | `String?` | ID de la mère |
| `spouseOf` | `String?` | ID du conjoint (pour les épouses) |
| `parentIds` | `List<String>` | Plusieurs parents (cas BFS multi-chemin) |
| `bio` | `String?` | Biographie courte |
| `birthYear` | `String?` | Année de naissance (format libre) |
| `deathYear` | `String?` | Année de décès |
| `kunya` | `String?` | Surnom honorifique (ex: "Abū al-Qāsim") |
| `laqab` | `String?` | Titre (ex: "al-Amīn") |
| `isBoundary` | `bool` | Vrai = ancêtre-limite (pas de label affiché) |
| `isTraditional` | `bool` | Vrai = ancêtre traditionnel pré-islamique |

Le chargement se fait via `GenealogyRepository.load()` (méthode statique, `FutureProvider`). Les deux providers disponibles :

```dart
final repo     = ref.watch(genealogyRepositoryProvider); // AsyncValue<GenealogyRepository>
final members  = ref.watch(genealogyMembersProvider);    // AsyncValue<List<FamilyMember>>
```

---

## 7. État utilisateur et persistance

### Structure de `UserState` (freezed)

```dart
class UserState {
  ThemeKey theme;                  // Thème actif — default: ThemeKey.light
  Set<int> favorites;              // Numéros des noms favoris
  Set<int> learned;                // Numéros des noms marqués "appris"
  Set<int> viewed;                 // Numéros des noms consultés au moins une fois
  Map<int, DateTime> lastSeen;     // Dernière consultation par numéro de nom
  DateTime? onboardingCompletedAt; // null = onboarding non complété → redirection auto
  int? dailyNotifHour;             // Heure de notification (null = désactivé)
  int quizzesCompleted;            // Nombre total de quiz terminés (tous types)
  int totalQuizScore;              // Score cumulé tous quiz
}
```

### Persistance — Hive CE

`HiveSource` sérialise `UserState` **en JSON** dans une `Box<String>` nommée `'settings'`. Pas d'adapter Hive généré — le JSON est encodé/décodé manuellement. Cela rend la migration de schéma triviale (ajouter un champ avec valeur par défaut).

### Actions de mutation

Toutes les mutations passent par `ref.read(settingsProvider.notifier)` :

| Méthode | Effet |
|---------|-------|
| `setTheme(ThemeKey)` | Change le thème actif |
| `setOnboardingComplete()` | Horodate l'onboarding → débloque l'app |
| `toggleFavorite(int number)` | Ajoute ou retire des favoris |
| `markViewed(int number)` | Marque comme vu + horodatage dans `lastSeen` |
| `markLearned(int number)` | Marque comme appris (idempotent) |
| `setNotifHour(int?)` | Définit ou supprime l'heure de notification |
| `recordQuizResult(int correct)` | Incrémente `quizzesCompleted` et `totalQuizScore` |

---

## 8. Navigation (go_router)

### Tableau des routes

| Path | Écran | Type |
|------|-------|------|
| `/onboarding` | `OnboardingScreen` | Full-screen — redirigé auto si non onboardé |
| `/home` | `HomeScreen` | Tab 1 (StatefulShellBranch) |
| `/discover` | `DiscoverScreen` | Tab 2 (StatefulShellBranch) |
| `/profile` | `ProfileScreen` | Tab 3 (StatefulShellBranch) |
| `/tree` | `TreeScreen` | Tab 4 (StatefulShellBranch) |
| `/name/:number` | `DetailScreen(initialNumber)` | Push — number = 1–201 |
| `/quiz/qcm` | `QcmScreen` | Push depuis discover |
| `/quiz/flashcards` | `FlashcardsScreen` | Push depuis discover |
| `/quiz/result` | `ResultScreen(score, total)` | pushReplacement — extra: `Map<String, int>` |
| `/settings` | `SettingsScreen` | Push depuis profil |
| `/favorites` | `FavoritesScreen` | Push depuis profil |
| `/tree/person/:id` | `PersonDetailScreen(memberId)` | Push depuis n'importe quelle vue arbre |
| `/tree/list` | `TreeListScreen` | Push depuis TreeScreen |

### Redirection automatique (onboarding)

```dart
redirect: (context, state) {
  final onboarded = settings.onboardingCompletedAt != null;
  if (!onboarded && !onOnboarding) return '/onboarding';
  if (onboarded  && onOnboarding)  return '/home';
  return null;
},
```

### Tab bar — `StatefulShellRoute.indexedStack`

4 branches : **Accueil / Découvrir / Profil / Arbre**. Chaque branche conserve son état de navigation indépendamment. Naviguer vers un autre onglet et revenir restore exactement l'état précédent.

### Passage de données aux routes

- Paramètre de chemin : `/name/:number` → `state.pathParameters['number']`
- Extra go_router : `/quiz/result` reçoit `state.extra as Map<String, int>` avec `{score, total}`

---

## 9. Internationalisation (l10n)

**Source :** `l10n/intl_fr.arb`
**Config :** `l10n.yaml` — `arb-dir: l10n`, `output-dir: lib/l10n`, `nullable-getter: false`
**Génération :** `flutter gen-l10n` → produit `lib/l10n/app_localizations*.dart`

L'AR (`intl_ar.arb`) est un placeholder. Les clés sont présentes, les traductions sont à compléter.

### Clés disponibles

| Préfixe | Clés | Notes |
|---------|------|-------|
| `nav` | `navHome`, `navDiscover`, `navProfile` | Tab bar |
| `onboarding` | 9 clés (welcome, theme, notif) | Onboarding 3 pages |
| `home` | `homeGreeting`, `homeCategorySection`, `homeDiscoverName`, `homeCategoryLearned(learned, total)`, `homeNameNumber(number)` | |
| `discover` | `discoverAllNames`, `discoverQuiz`, `discoverFilterAll`, `discoverSearchHint` | |
| `detail` | `detailSectionEtymology/Commentary/References/Sources`, `detailNameLabel(number)`, `detailProgress(current, total)`, `detailMaskedName` | |
| `quiz` | 11 clés dont `quizResultScore(score, total)`, `quizProgress(current, total)` | |
| `profile` | `profileLearnedSubtitle`, `profileFavorites`, `profileSettings` | |
| `settings` | 10 clés (thème, notif, taille texte, à propos) | |
| `favorites` | `favoritesTitle`, `favoritesEmpty`, `favoritesEmptyCta` | |
| `tree` | `treeLoadError`, `treePersonOpenDetail`, `treePersonBack`, `treeRiverPaternal`, `treeRiverMaternal`, `treeRiverDescendants`, `treeBridgeToTree`, `treeBridgeRelatedNames`, `treeListViewTitle`, `treeListSectionAncestors`, `treeListSectionWives`, `treeListSectionChildren`, `treeListSectionUncles`, `treeListSectionOther` | Module V1.1 |

```dart
// Accès dans n'importe quel widget
final l10n = context.l10n;
Text(l10n.homeGreeting);
Text(l10n.homeCategoryLearned(3, 20)); // "3/20 appris"
```

---

## 10. Module Noms — écrans implémentés

### Onboarding (`lib/features/onboarding/presentation/`)

3 pages via `PageView` (scroll désactivé — navigation par boutons uniquement) :

1. **Bienvenue** — Texte arabe calligraphique + titre + sous-titre + "Commencer"
2. **Thème** — 3 cartes de prévisualisation côte à côte. Chaque carte rend les couleurs de son thème via `AppTheme.build(key).extension<AppColors>()`. Sélection live (le thème change immédiatement dans l'app).
3. **Notification** — Sélecteur d'heure `showTimePicker` + boutons "Activer" et "Plus tard". L'heure est sauvegardée dans `UserState.dailyNotifHour` mais la notification n'est pas encore schedulée (voir §15).

Fin : `settingsProvider.setOnboardingComplete()` → `context.go('/home')`

---

### Accueil (`lib/features/names/presentation/home/`)

**`HomeScreen`** (`ConsumerWidget`) — scroll vertical assemblant :

- **`_HomeHeader`** — Salutation (`l10n.homeGreeting`), date grégorienne (tableaux FR manuels pour éviter `initializeDateFormatting`), date hijri (`HijriCalendar.now()` avec noms de mois FR manuels).
- **`DailyNameCard`** — Hauteur = `MediaQuery.of(context).size.height * 0.58`. Contient : numéro + `CategoryChip`, `ArabicText` hero avec ombre, translittération italique, fondu du commentaire (`Stack` + `LinearGradient` bg→transparent), CTA "Découvrir ce nom".
- **`CategoryCarousel`** — `ListView` horizontal (hauteur 130px), 11 cartes de 120px. Chaque carte affiche le nom de la catégorie, un `ProgressRing` (learned/total), et le compte `l10n.homeCategoryLearned`. Taper navigue vers `/discover`.

---

### Découvrir (`lib/features/names/presentation/list/`)

**`DiscoverScreen`** — `DefaultTabController` à 2 onglets (AppBar + TabBar intégrés) :

- **Tab 1 — `ListScreen`** (`ConsumerStatefulWidget`) :
  - Barre de recherche `TextField` (fond `colors.bg2`, bordure pill) — filtre sur arabic, translittération, label catégorie.
  - Chips de filtre horizontal : "Tous" + 11 catégories. Tapper le chip actif le déselectionne.
  - `ListView.builder` avec `NameCard` — dismiss clavier au scroll.
- **Tab 2 — `QuizEntryScreen`** — voir §12.

---

### Fiche détail (`lib/features/names/presentation/detail/`)

**`DetailScreen`** reçoit `initialNumber` depuis `/name/:number`.

**`_DetailPageView`** (`ConsumerStatefulWidget`) :
- `PageController` initialisé à l'index du nom demandé.
- **Timer 8 secondes** : annulé et relancé à chaque changement de page. Appelle `markLearned` si le nom n'est pas encore appris. Annulé proprement dans `dispose`.
- `markViewed` appelé via `addPostFrameCallback` à l'initState.
- AppBar : titre "Nom #001" (`detailNameLabel`), bouton partage (`ShareNameService`), bouton favori, barre de progression linéaire `(index+1)/total`.

**`_NameDetailPage`** (StatelessWidget) — `SingleChildScrollView` contenant :
- Indicateur `detailProgress(current, total)`
- `ArabicText` hero avec ombre
- Translittération en italique (`displayMedium`)
- `CategoryChip` filled
- Sections conditionnelles (etymology, commentary, references, sources) avec `SectionHeader`

---

### Profil (`lib/features/profile/presentation/profile/`)

**`ProfileScreen`** (`ConsumerWidget`) :
- Anneau `ProgressRing` (80px, épaisseur 6) avec compteur `learned / 201` au centre.
- `StreakBadge` si streak > 0. Le streak est calculé localement : on remonte les jours consécutifs dans `lastSeen.values`.
- **Constellation** (`CustomPaint`, 300px) — `_ConstellationPainter` :
  - Positions déterministes : spirale de Golden Ratio (`goldenAngle = π(3 - √5)`), rayon proportionnel à `sqrt(i/total)`.
  - Nom appris : point 3.5px + halo semi-transparent `accentColor.withValues(alpha: 0.15)`.
  - Nom non appris : point 2px + couleur `muted` à 30% d'opacité.
- Tuiles de navigation : Favoris (avec badge de compteur) et Paramètres.

---

### Paramètres (`lib/features/profile/presentation/settings/`)

**`SettingsScreen`** (`ConsumerWidget`) :
- Sélecteur thème : 3 boutons côte à côte (`AnimatedContainer` 200ms), icône + label. Sélectionné = fond accent 12% + bordure accent 2px.
- Tile notification : affiche l'heure si activée + bouton "Désactiver" ; sinon bouton "Activer" → `showTimePicker`.
- Section "À propos" : nom app, version, lien "Signaler une erreur" (à brancher).

---

### Favoris (`lib/features/profile/presentation/favorites/`)

**`FavoritesScreen`** (`ConsumerWidget`) :
- Filtre : `names.where((n) => favorites.contains(n.number))`.
- État vide : icône + `l10n.favoritesEmpty` + CTA → `/discover`.
- État peuplé : `ListView.builder` de `NameCard` avec toggle favori inline (retire de la liste immédiatement).

---

## 11. Module Arbre généalogique

**Branche de développement :** `feat/genealogy-tree`  
**Dossier :** `lib/features/genealogy/`

---

### Modèle — `FamilyMember` (freezed)

```dart
@freezed
class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required String id,
    required String arabic,
    required String transliteration,
    required FamilyRole role,
    int? generation,
    int? marriageOrder,
    String? parentId,
    String? motherId,
    String? spouseOf,
    @Default([]) List<String> parentIds,
    String? bio,
    String? birthYear,
    String? deathYear,
    String? kunya,
    String? laqab,
    @Default(false) bool isBoundary,
    @Default(false) bool isTraditional,
  }) = _FamilyMember;
}
```

### Enum `FamilyRole` (12 valeurs)

| Valeur | Description |
|--------|-------------|
| `prophet` | Le Prophète ﷺ — centre de toutes les vues |
| `father` | Père ('Abdullāh) |
| `mother` | Mère (Āmina) |
| `wife` | Épouse — ordonnée par `marriageOrder` |
| `child` | Enfant direct |
| `grandchild` | Petit-enfant |
| `paternalAscendant` | Ancêtre paternel (`generation` depuis le Prophète) |
| `maternalAscendant` | Ancêtre maternel |
| `uncle` | Oncle paternel |
| `aunt` | Tante paternelle |
| `cousin` | Cousin |
| `traditionalAncestor` | Ancêtre pré-islamique (`isTraditional: true`) |

---

### Repository — `GenealogyRepository`

```dart
// Chargement depuis assets/data/genealogy.json
static Future<GenealogyRepository> load()

// Lecture
List<FamilyMember> getAll()
FamilyMember? getById(String id)
FamilyMember getProphet()                         // toujours non-null
Iterable<FamilyMember> getByRole(FamilyRole role)
List<FamilyMember> getChildren({String? motherId})
List<FamilyMember> search(String query)           // cherche arabic + transliteration

// Navigation
List<FamilyMember> getPath(String fromId, String toId)
// BFS sur graphe non orienté : arêtes = parentId + motherId + spouseOf + parentIds
// Retourne [] si aucun chemin trouvé
```

---

### Vue Radiale (`radial_view.dart`)

**Principe :** 5 orbites concentriques avec le Prophète ﷺ au centre.

| Orbite | Rayon (px) | Membres |
|--------|-----------|---------|
| 0 | 0 (centre) | Prophète ﷺ |
| 1 | 90 | Père, Mère, Khadīja (épouse 1) |
| 2 | 170 | Autres épouses, enfants, ancestres gen 2 |
| 3 | 250 | Petits-enfants, oncles, tantes, ancestres gen 3 |
| 4 | 340 | Cousins, ancestres traditionnels, ancestres gen ≥ 4 |

- **Filtre** : `GenealogyFilter` {`all`, `wivesAndChildren`, `ancestors`, `unclesAndAunts`, `ahlAlBayt`} — les membres hors filtre restent visibles à 15% d'opacité.
- **Sélection** : tap → `ValueNotifier<String?> selectedId` → `PersonChip` en bas.
- **Zoom** : `InteractiveViewer` (scale 0.5×–3.0×).
- **Cache de positions** : statique dans `RadialPainter`, recalculé si `members` ou `center` change.

---

### Vue Constellation (`constellation_view.dart`)

**Principe :** graphe zoomable où chaque membre est une étoile, reliée à ses parents/conjoints par des arêtes.

**Disposition par zones :**

| Groupe | Zone (Offset depuis centre) |
|--------|-----------------------------|
| Prophète ﷺ | (0, 0) — centre absolu |
| Père / Mère | (±25, −110) |
| Épouse 1 (Khadīja) | (180, −40) |
| Autres épouses | boîte (180..320, 20..120) |
| Enfants | boîte (−80..80, 120..220) |
| Petits-enfants | boîte (−120..120, 260..340) |
| Oncles / tantes | boîte (−300..−160, −60..100) |
| Ancêtres paternels gen 2 | arc (−180°..−90°, r=260..340) |
| Ancêtres maternels | arc (−180°..−135°, r=200..280) |
| Cousins | arc (90°..135°, r=280..340) |
| Ancêtres traditionnels | arc (−150°..−30°, r=380..440) |

**Fonctionnalités :**
- **Barre de recherche** (pill, filtre sur arabic/transliteration) → recentre sur l'étoile trouvée.
- **Tap** : sélectionne un membre → `PersonChip` en bas avec lien "Voir la fiche".
- **Long press** : définit le point de départ d'un chemin ; le tap suivant trace le chemin BFS (arêtes en accent coloré, autres membres à 15% d'opacité).
- **FAB "recentrer"** : réinitialise `TransformationController` + sélection + chemin.
- **Légende** en bas à gauche : 5 couleurs × rôle.

**Rendu `ConstellationPainter` :**
- Arêtes dessinées en premier. Opacité diminue avec la distance depuis le centre. Arêtes dédupliquées via `Set<String> drawnEdges` avec clé `'${min(a,b)}-${max(a,b)}'`.
- Étoiles : taille 6px (prophète : 10px + halo doré). Le point de départ de chemin = `colors.warning`. Sélectionné = +3px.
- Labels : arabic (9sp, Amiri RTL) + translittération (7sp) sous chaque étoile. Cachés pour les ancêtres traditionnels sauf si sélectionné.
- Hit-test : distance < 18px.

---

### Vue Rivière (`river_view.dart`)

**Principe :** chaîne verticale alternée gauche/droite avec une ligne fluviale centrale.

**3 modes** (`RiverStream`, `riverStreamProvider`) :

| Mode | Contenu |
|------|---------|
| `paternal` | Chaîne paternelle depuis Ādam → Prophète ﷺ, avec insertion d'un `_TributaryEntry` (oncles/tantes) au niveau d''Abd al-Muṭṭalib |
| `maternal` | Chaîne maternelle depuis l'ancêtre de Āmina → Prophète ﷺ |
| `descendants` | Prophète ﷺ → épouses (ordre mariage) → enfants → petits-enfants |

**Widgets :**
- `RiverNode` : carte 140px (larges: 180px pour le Prophète ﷺ), alternée gauche/droite selon l'index pair/impair. Animation flutter_animate `fade + slideY` avec délai basé sur l'index.
- `Tributary` : bande de mini-cartes (max 4 + overflow "+N") pour les groupes latéraux.
- `_RiverLine` : colonne centrale — glow 14px + ligne dégradée 2px (`accent.withValues(alpha: 0)` aux extrémités pour éviter les bandes sur les thèmes sombres).

---

### Fiche détail — `PersonDetailScreen`

Route : `/tree/person/:id`

`CustomScrollView` avec `SliverAppBar` transparent :

| Section | Contenu | Conditionnel |
|---------|---------|-------------|
| **Header** | Arabe 32sp, translittération italique, kunya/laqab | — |
| **Relation** | Label rôle + `PathChip` (chemin BFS depuis le Prophète ﷺ) | — |
| **Dates** | Naissance / décès | Si non null |
| **Biographie** | `bio` avec police éditoriale | Si non null |
| **Passerelle noms** | Premier mot de la translittération cherché dans les commentaires des 201 noms → chips cliquables → `/name/:number` | Si résultats trouvés |
| **Voir aussi** | Liens vers père / mère / conjoint | Si ID disponibles |

- **`markMemberViewed`** appelé via `addPostFrameCallback` (évite les setState pendant le build).
- **Favori** : bouton `bookmark` dans l'AppBar.
- **Animation** : chaque section apparaît avec `fade + slideY` via flutter_animate.

### `PathChip`

```dart
PathChip(path: repo.getPath('adam', 'muhammad'))
// → [Ādam] › [Sham] › … › [ﷺ]
```

Chips horizontales scrollables. Les extrémités ont une bordure `accent`. Le Prophète ﷺ est toujours affiché "ﷺ". Si `path.length ≤ 1` → `SizedBox.shrink()`.

---

### Liste — `TreeListScreen`

Route : `/tree/list`

`CustomScrollView` avec sections `SliverToBoxAdapter` (header) + `SliverList` (membres) :

| Section | Tri |
|---------|-----|
| Ancêtres | Par `generation` croissant |
| Épouses | Par `marriageOrder` croissant |
| Enfants & petits-enfants | Ordre du JSON |
| Oncles & tantes | Ordre du JSON |
| Autres | Tout ce qui n'est pas `isBoundary` et hors catégories ci-dessus |

Chaque `ListTile` : arabic + translittération + role label. Encapsulé dans `Semantics(label: ...)` pour l'accessibilité. Tapper → push `/tree/person/:id`.

---

### Passerelle noms ↔ arbre

**Arbre → Noms** : `PersonDetailScreen` cherche le premier mot de `transliteration` dans les `commentary` de tous les 201 noms. Utilise `namesAsync.valueOrNull ?? []` pour ne pas bloquer si les noms ne sont pas encore chargés. Affiche des `CategoryChip`-like navigables.

**Noms → Arbre** : dans `DetailScreen` (module noms), si `categorySlug == 'nobility'`, un bouton `_TreeBridgeLink` apparaît en bas de la fiche → `context.go('/tree')`.

---

### Widget partagé — `PersonChip`

```dart
PersonChip(member: member)
// → arabic (typo.arabicBody) + translittération + bouton "Voir la fiche →" → /tree/person/:id
```

Utilisé par `RadialView` et `ConstellationView`. Extrait dans `lib/features/genealogy/presentation/shared/person_chip.dart` pour éviter les imports croisés.

---

## 12. Widgets partagés

Tous dans `lib/features/shared/`.

### `ArabicText`

```dart
ArabicText(
  text: name.arabic,
  size: ArabicSize.hero,       // hero (88sp) | large (56sp) | medium (32sp) | body (22sp)
  withShadow: true,            // active le glow du thème dark (AppElevation.glow)
  color: colors.accent,        // surcharge la couleur de l'ink
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

Toujours `textDirection: TextDirection.rtl`. Encapsulé dans `Semantics` avec le texte arabe comme label.

### `NameCard`

```dart
NameCard(
  name: name,
  isFavorite: favorites.contains(name.number),
  onTap: () => context.push('/name/${name.number}'),
  onFavoriteTap: () => notifier.toggleFavorite(name.number),  // null = icône cachée
)
```

Numéro padLeft(3), arabe medium, translittération italique muted, `CategoryChip` small, icône favori conditionnelle.

### `CategoryChip`

```dart
CategoryChip(
  slug: 'praise',
  label: 'Louange',
  variant: CategoryChipVariant.filled,    // filled | outlined | small
  isSelected: true,
  onTap: () {},
)
```

Couleurs tirées de `colors.categoryColor(slug)` et `colors.categoryBg(slug)` — automatiquement adaptées au thème actif.

### `ProgressRing`

`CustomPainter` avec arc depuis 12h (-π/2), `strokeCap: round`, fond circulaire `backgroundColor`.

```dart
ProgressRing(progress: 0.42, size: 48, strokeWidth: 4, color: colors.accent)
```

### `QuizCard`

Flashcard avec flip. Gère son propre `AnimationController` (400ms, `Curves.easeInOut`). Le retournement est contrôlé par le parent via `isFlipped`. Utilise `Matrix4.identity()..setEntry(3,2,0.001)..rotateY(value * π)` pour la perspective et la rotation.

- **Recto** : `ArabicText` large + icône "toucher pour retourner"
- **Verso** : translittération + `CategoryChip` small + étymologie (max 4 lignes)

### `SectionHeader`

Ligne avec titre `overline` uppercase centré, flanqué à gauche d'un ornement dégradé fixe 24px et à droite d'un ornement `Expanded`.

### `StreakBadge`

Badge avec `Icons.local_fire_department` et le nombre de jours. Si `animate: true` : pulse scale via `flutter_animate` (×1.3 en 200ms, retour en 150ms).

---

## 13. Système de quiz

### `QuizGenerator`

| Méthode | Description |
|---------|-------------|
| `pickRandom(all)` | Sélectionne 5 noms aléatoires parmi 201 |
| `generateQcm(all)` | Produit 5 `QcmQuestion` avec distracteurs |
| `_distractors(all, target, n)` | Préfère la même catégorie, complète avec aléatoire |
| `_mask(text, transliteration)` | Remplace la translittération par `[…]` (regex insensible à la casse) |

### `QuizSession`

Stockée dans `quizSessionProvider` (`StateProvider<QuizSession?>`). Contient soit `List<QcmQuestion>` (QCM) soit `List<ProphetName>` (flashcards).

### Flux de navigation

```
QuizEntryScreen
  ├─ QCM       → push /quiz/qcm        → pushReplacement /quiz/result (extra: {score, total})
  └─ Flashcard → push /quiz/flashcards  → pushReplacement /quiz/result (extra: {score, total})
                                                    ↓
                                          "Explorer les noms" → go('/discover')
                                          "Rejouer"           → pop() (retour à QuizEntryScreen)
```

### QCM (`QcmScreen`)

- Affiche le commentaire masqué comme question.
- 4 boutons `_ChoiceButton` avec états : `idle` / `correct` (vert) / `wrong` (rouge) / `disabled` (grisé). Animés via `AnimatedContainer`.
- Bonne réponse → `markLearned(name.number)` + `_score++`.
- Bouton "Suivant" visible uniquement après sélection.

### Flashcards (`FlashcardsScreen`)

- Carte retournable (`QuizCard`).
- Boutons "À revoir" et "Je connais" visibles uniquement après retournement (`AnimatedOpacity`).
- "Je connais" → `markLearned` + `_knownCount++`.
- Les deux avancent à la carte suivante.

### Résultat (`ResultScreen`)

Message contextuel en fonction du score :
- ≥ 4/5 → `quizResultExcellent` + ornement arabe "بَارَكَ اللهُ"
- 2–3/5 → `quizResultGood` + "الْحَمْدُ للهِ"
- ≤ 1/5 → `quizResultKeepGoing` + "إِن شَاءَ اللهُ"

---

## 14. Partage d'image

**`ShareNameService.share(name, colors, typo)`** (`lib/features/names/presentation/detail/share_name_service.dart`) :

1. Crée un `ui.PictureRecorder` — canvas logique 1080×1080
2. Dessine : fond `colors.bg`, ornement horizontal `colors.accent`, texte arabe 120sp (`TextPainter` RTL), translittération italique 36sp, pied de page "Asmāʾ an-Nabī ﷺ"
3. Encode en PNG via `img.toByteData(format: ui.ImageByteFormat.png)`
4. Partage via `Share.shareXFiles([XFile.fromData(..., mimeType: 'image/png')])`

Le rendu est entièrement dans le code (pas de widget Flutter capturé) — ce qui garantit un résultat identique quelle que soit la résolution d'écran.

Le bouton partage est intégré dans l'AppBar de `DetailScreen`.

---

## 15. Tests widget

Fichier : `test/widget_test.dart`

Les tests overrident les providers Riverpod pour éviter tout accès à Hive ou aux assets :

```dart
ProviderScope(
  overrides: [
    settingsProvider.overrideWith(() => _StubSettingsNotifier()),
    namesProvider.overrideWith((_) async => [_testName]),
    categoriesProvider.overrideWith((_) async => [_testCategory]),
    dailyNameProvider.overrideWith((_) async => _testName),
    learnedCountsProvider.overrideWithValue({}),
  ],
  child: MaterialApp(theme: AppTheme.build(ThemeKey.light), ...),
)
```

### Tests module Noms (V1)

| Test | Écran | Vérification |
|------|-------|-------------|
| 1 | `OnboardingScreen` | Bouton "Commencer" présent |
| 2 | `HomeScreen` | Construction sans erreur |
| 3 | `ListScreen` | Barre de recherche présente |
| 4 | `ListScreen` (filtre) | Recherche "Muḥammad" retourne des résultats |
| 5 | `DetailScreen` | Texte arabe du nom affiché |
| 6 | `FavoritesScreen` | Message vide affiché quand aucun favori |

### Tests module Arbre (V1.1)

Les tests overrident `genealogyRepositoryProvider` avec un stub de 5 membres (prophète, père, mère, épouse, enfant) :

```dart
genealogyRepositoryProvider.overrideWith((_) async => _stubRepo)
```

| Test | Écran | Vérification |
|------|-------|-------------|
| 7 | `TreeScreen` | TabBar "Radiale / Constellation / Rivière" présent |
| 8 | `TreeListScreen` | Au moins un `ListTile` affiché |
| 9 | `PersonDetailScreen` | Texte arabe du membre affiché |
| 10 | `RadialView` | Widget se construit sans erreur (stub repo) |
| 11 | `RiverView` | Au moins un `RiverNode` rendu |

```bash
flutter test
```

---

## 16. Problèmes connus et blocages

### Notifications quotidiennes (tâche #18) — BLOQUÉ

`flutter_local_notifications` ne peut pas être intégré dans cette configuration :

| Contrainte | Valeur |
|------------|--------|
| Dart SDK actuel | 3.9.2 |
| Dart requis pour `flutter_local_notifications ≥ 21.x` | ≥ 3.10.0 |
| Dernière version compatible avec Dart 3.9.2 (`17.x`) | Incompatible avec Android Gradle Plugin 8.9.1 (erreur AAR metadata) |

**Solution :** réintégrer `flutter_local_notifications: ^21.0.0` dès que Flutter embarque Dart ≥ 3.10.0.

**Ce qui est déjà en place :** l'UI de sélection d'heure (onboarding page 3 + paramètres) est fonctionnelle, l'heure est persistée dans `UserState.dailyNotifHour`. Il suffira de brancher l'appel à `flutter_local_notifications` dans `SettingsNotifier.setNotifHour()`.

---

## 17. Roadmap

### État actuel

| Version | Statut | Contenu |
|---------|--------|---------|
| **V1** | ✅ Livré | 201 noms, quiz QCM + flashcards, profil constellation, partage image, 3 thèmes, onboarding, favoris |
| **V1.1** | ✅ Livré (branche `feat/genealogy-tree`) | Arbre généalogique 3 modes (radial, constellation, rivière), fiches détail, liste, passerelles |

### Priorités immédiates

| Tâche | Notes |
|-------|-------|
| **Icône app + splash screen** | Derniers blocages avant soumission store |
| **Tests widget module Arbre (×5)** | Voir §15 — stubs déjà décrits |
| **Notifications quotidiennes** | Réintégrer `flutter_local_notifications ^21` dès Dart ≥ 3.10 (voir §16) |

### Prochains modules

L'architecture modulaire permet d'ajouter les features suivantes sans modifier le code existant :

| Feature | Dossier à créer | Notes |
|---------|-----------------|-------|
| Biographie (Sīra) | `lib/features/sira/` | Timeline interactive, lieux, personnages liés à l'arbre |
| Qualités (Khaṣāʾiṣ) | `lib/features/khasais/` | Particularités prophétiques classées |
| Descriptions (Shamāʾil) | `lib/features/shammail/` | Description physique et morale |
| Hadiths thématiques | `lib/features/hadiths/` | Par catégorie, lien avec les noms |
| Ṣalawāt et invocations | `lib/features/salawat/` | Audio + texte arabe + translittération |

### Améliorations transverses

| Feature | Dossier | Notes |
|---------|---------|-------|
| Langue arabe | `l10n/intl_ar.arb` | Structure l10n déjà en place, clés à traduire |
| Langue anglaise | `l10n/intl_en.arb` | |
| Taille de texte dynamique | `core/providers/` | Ajouter `textScaleProvider`, appliquer dans `AppTypography` |
| Sync cloud | — | `UserState` est déjà sérialisable en JSON |
| Mode "étude" arbre | `lib/features/genealogy/` | Quiz sur les relations familiales |

---

## Licences & attributions

- Police **Amiri / Amiri Quran** — SIL OFL (libre)
- Police **Crimson Pro** — SIL OFL (libre)
- Police **Playfair Display** — SIL OFL (libre)
- Police **Inter** — SIL OFL (libre)
- Données des 201 noms : sources classiques citées dans chaque entrée (domaine public)

---

*Documentation v1.1.0 — 26 avril 2026*
