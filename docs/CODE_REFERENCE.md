# Code Documentation — Sirah Hub v1.5.1

> Référence complète pour développeurs. Lire en parallèle de `docs/ARCHITECTURE.md`.

---

## Table des matières

1. [Vue d'ensemble](#1-vue-densemble)
2. [Couche Core](#2-couche-core)
3. [State Management — le modèle en couches](#3-state-management)
4. [Navigation](#4-navigation)
5. [Modules Features](#5-modules-features)
6. [Recettes pratiques](#6-recettes-pratiques)

---

## 1. Vue d'ensemble

```
main.dart
  └─ ProviderScope
       └─ app.dart (MaterialApp.router)
            ├─ ThemeProvider → AppTheme (3 thèmes)
            └─ appRouterProvider → GoRouter (4 onglets + routes modales)
```

L'application est **offline-first, zéro backend**. Toutes les données métier sont dans `assets/data/*.json`. L'état utilisateur est persisté dans une box Hive locale (`'settings'`).

---

## 2. Couche Core

### `core/storage/hive_source.dart`

Unique point de persistance. Pattern : **1 box, 1 clé, blob JSON**.

```dart
// Lire l'état au démarrage
UserState state = HiveSource.read(); // renvoie UserState() par défaut si vide

// Écrire (toujours via SettingsNotifier._save, jamais directement)
await HiveSource.write(nextState);
```

**Ajouter un nouveau champ persisté :**
1. Ajouter dans `user_state.dart` avec `@Default(...)`
2. Ajouter dans `HiveSource._toMap()` et `HiveSource._fromMap()`
3. `dart run build_runner build --delete-conflicting-outputs`

> ⚠️ Dans `_fromMap`, toujours parser défensivement avec les helpers dédiés (`_intValue`, `_intSet`, `_stringSet`, `_lastSeenMap`, `_stringKeyedMap`). Jamais de cast direct sur une valeur persistée.

Le parsing est volontairement tolérant : une valeur invalide est ignorée localement et la valeur par défaut du champ est conservée, sans perdre le reste de `UserState`.

---

### `core/notifications/notification_service.dart`

Initialise `timezone`, fixe la timezone locale sur `Europe/Paris`, puis programme la notification quotidienne via `tz.local`.

```dart
tz_data.initializeTimeZones();
tz.setLocalLocation(tz.getLocation('Europe/Paris'));
```

`SettingsNotifier.setNotifHour(int?)` reste le point d'entrée unique : heure non nulle → `scheduleDailyAt(hour)`, `null` → `cancel()`.

---

### `core/providers/user_state.dart`

Modèle Freezed — source de vérité unique sérialisée.

```dart
// Tous les champs avec leurs valeurs par défaut :
ThemeKey theme            // ThemeKey.light
TextSize textSize         // TextSize.medium
Set<int> favorites        // {} — noms du Prophète favoris (par numéro)
Set<int> learned          // {} — noms marqués appris (timer 8s ou quiz)
Set<int> viewed           // {} — noms consultés
Map<int,DateTime> lastSeen // {} — horodatage dernière consultation
DateTime? onboardingCompletedAt  // null = pas encore onboardé
int? dailyNotifHour       // null = notifications désactivées
int quizzesCompleted      // 0
int totalQuizScore        // 0
Set<String> favoriteMembers  // {} — IDs membres généalogie favoris
Set<String> viewedMembers    // {} — IDs membres généalogie vus
String preferredTreeView  // 'radial' | 'river' | 'constellation' | 'list'
Map<int,int> leitnerBoxes // {} — nameNumber → niveau 0/1/2
Set<String> completedParcours // {} — IDs parcours terminés
String studyMode          // 'random'
Set<int> husnaLearned     // {} — IDs 1-99 Asmāʾ al-Ḥusnā appris
```

---

### `core/providers/settings_provider.dart`

**Seul `Notifier<UserState>` de l'application.** Seul écrivain Hive.

```dart
// Accéder à l'état (lecture réactive)
ref.watch(settingsProvider)
ref.watch(settingsProvider.select((s) => s.favorites))

// Modifier l'état (via les facades de domaine en V1.5, voir §3)
ref.read(settingsProvider.notifier).setTheme(ThemeKey.dark)
```

Méthodes disponibles (groupées par domaine) :

| Méthode | Domaine |
|---------|---------|
| `setTheme(ThemeKey)` | Global |
| `setTextSize(TextSize)` | Global |
| `setOnboardingComplete()` | Global |
| `setNotifHour(int?)` | Global — programme/annule la notification |
| `recordQuizResult(int)` | Global |
| `toggleFavorite(int)` | Names |
| `markViewed(int)` | Names |
| `markLearned(int)` | Names |
| `toggleFavoriteMember(String)` | Genealogy |
| `markMemberViewed(String)` | Genealogy |
| `setPreferredTreeView(String)` | Genealogy |
| `levelUp(int)` / `levelDown(int)` | Study |
| `setStudyMode(String)` | Study |
| `markParcoursComplete(String)` | Study |
| `markHusnaLearned(int)` | Asmāʾ |

---

### `core/utils/build_context_x.dart`

Extension sur `BuildContext` — accès aux tokens de design :

```dart
context.colors.bg / .bg2 / .ink / .muted / .accent / .accent2 / .line / .success / .error
context.typo.displayLarge / .displayMedium / .headline / .bodyLarge / .body / .caption / .overline / .button / .arabicBody
context.space.xs / .sm / .md / .lg / .xl / .xxl
context.radii.sm / .md / .lg / .pill  (+ .smAll / .lgAll / .pillAll pour BorderRadius)
context.l10n  // AppLocalizations
```

> ❌ Ne jamais utiliser de valeurs en dur (`Colors.blue`, `16.0`, `"Accueil"`).

---

## 3. State Management

### Architecture en couches (V1.5)

```
┌─────────────────────────────────────────────────────────┐
│  UI Widgets                                              │
│  ref.watch(namesNotifierProvider).favorites             │
│  ref.read(studyNotifierProvider).levelUp(n)             │
└───────────────┬─────────────────────────────────────────┘
                │  délègue lecture et écriture
┌───────────────▼─────────────────────────────────────────┐
│  Domain Facades  (Provider<T> — lecture + délégation)   │
│  namesNotifierProvider   → NamesNotifier                │
│  studyNotifierProvider   → StudyNotifier                │
│  genealogyNotifierProvider → GenealogyNotifier          │
│  asmaaNotifierProvider   → AsmaaNotifier                │
└───────────────┬─────────────────────────────────────────┘
                │  ref.read(settingsProvider.notifier).X
┌───────────────▼─────────────────────────────────────────┐
│  settingsProvider  (NotifierProvider<SettingsNotifier,  │
│                     UserState>)                          │
│  → SEUL écrivain Hive — toutes mutations passent ici    │
└───────────────┬─────────────────────────────────────────┘
                │  HiveSource.write(nextState)
┌───────────────▼─────────────────────────────────────────┐
│  HiveSource  — box 'settings', clé 'user_state', JSON   │
└─────────────────────────────────────────────────────────┘
```

### Pourquoi les facades ne sont pas des `Notifier<UserState>` ?

Si deux `Notifier<UserState>` coexistent et écrivent en parallèle dans Hive :
1. `NamesNotifier.state = {favorites: {1,2,3}}`
2. `StudyNotifier.state = {leitnerBoxes: {1:1}}`
3. `NamesNotifier` écrit → Hive OK
4. `StudyNotifier` écrit avec son état **périmé** → écrase les favorites

La facade évite ce problème : elle ne possède pas d'état, elle lit `ref.read(settingsProvider)` juste au moment de l'appel.

### Pattern complet d'une facade

```dart
class NamesNotifier {
  const NamesNotifier(this._ref);
  final Ref _ref;

  // Lecture — toujours via ref.read (pas de cache périmé)
  Set<int> get favorites => _ref.read(settingsProvider).favorites;

  // Écriture — délègue au seul notifier autorisé
  Future<void> toggleFavorite(int number) =>
      _ref.read(settingsProvider.notifier).toggleFavorite(number);
}

final namesNotifierProvider = Provider<NamesNotifier>(
  (ref) => NamesNotifier(ref),
);
```

### Règles `ref.watch` vs `ref.read`

```dart
// Dans build() — réactif, rebuilde le widget à chaque changement
final isFav = ref.watch(settingsProvider.select((s) => s.favorites.contains(n)));

// Dans un handler ou initState — lecture unique, pas de rebuild
ref.read(namesNotifierProvider).toggleFavorite(n);
```

---

## 4. Navigation

### Arbre des routes (V1.5)

```
/onboarding          → OnboardingScreen

StatefulShellRoute (4 onglets)
  /home              → HomeScreen
  /discover          → DiscoverScreen
    /discover/prophets → ProphetsDiscoverScreen
    /discover/husna    → HusnaListScreen
      /discover/husna/:id → HusnaDetailScreen
  /profile           → ProfileScreen
  /tree              → TreeScreen
    /tree/person/:id → PersonDetailScreen
    /tree/list       → TreeListScreen

Routes modales (hors onglets)
  /study             → StudyEntryScreen
    /study/parcours-list   → ParcoursListScreen
    /study/parcours/:id    → ParcoursDetailScreen
    /study/review          → ReviewScreen
  /name/:number      → DetailScreen (swipeable PageView)
  /name/:number/tafakkur → TafakkurScreen (implicite via push depuis DetailScreen)
  /quiz/qcm          → QcmScreen
  /quiz/flashcards   → FlashcardsScreen
  /quiz/result       → ResultScreen (extra: {score, total})
  /settings          → SettingsScreen
  /favorites         → FavoritesScreen

Fallback 404 → errorBuilder → page "introuvable" + bouton /home
```

### Redirection onboarding

```dart
redirect: (context, state) {
  final onboarded = onboardingCompletedAt != null;
  if (!onboarded && !state.matchedLocation.startsWith('/onboarding'))
    return '/onboarding';
  if (onboarded && state.matchedLocation.startsWith('/onboarding'))
    return '/home';
  return null;
}
```

Le router ne se rebuilde que si `onboardingCompletedAt` change (via `.select`).

### Passer des données entre routes

```dart
// Via pathParameters
context.push('/name/42');
final number = int.tryParse(state.pathParameters['number'] ?? '') ?? 1;

// Via extra (même session uniquement — ne pas persister)
context.pushReplacement('/quiz/result', extra: {'score': 8, 'total': 10});
final extra = state.extra as Map<String, int>? ?? {};
```

### Transition standard

Tous les `pageBuilder` utilisent `_fadeSlide(state, widget)` — fade + slide Y 4% en 260ms.

---

## 5. Modules Features

### `features/names/` — 201 Noms du Prophète ﷺ

**Data layer**
- `ProphetName` (Freezed) : `number`, `arabic`, `transliteration`, `etymology`, `commentary`, `references`, `categorySlug`, `primarySource`, `secondarySources`
- `NamesJsonSource` → charge `assets/data/names.json`
- `namesProvider` : `FutureProvider<List<ProphetName>>`
- `categoriesProvider` : `FutureProvider<List<NameCategory>>`

**Domain facade**
- `namesNotifierProvider` → `NamesNotifier` : `favorites`, `learned`, `viewed`, `toggleFavorite`, `markLearned`, `markViewed`

**Presentation**
- `HomeScreen` : DailyName (époque statique → index jour) + CategoryCarousel
- `ListScreen` : recherche + filtre catégorie + `NameCard`
- `DetailScreen` : `PageView` swipeable, timer 8s → `markLearned`, bouton Tafakkur, partage
- `TafakkurScreen` / `TafakkurController` : contemplation guidée (phrases, rythme, pause)
- `ShareNameService` : génération image + partage natif

---

### `features/genealogy/` — Arbre généalogique

**Data layer**
- `FamilyMember` (Freezed) : `id`, `arabic`, `transliteration`, `role`, `parentId`, `motherId`, `parentIds`, `spouseOf`, `birth`, `death`, `bio`, `laqab`, `kunya`
- `GenealogyRepository` : `getById`, `getAll`, `getByRole`, `getProphet`, `getPath` (BFS)
- `genealogyRepositoryProvider` : `FutureProvider<GenealogyRepository>`

**Domain facade**
- `genealogyNotifierProvider` → `GenealogyNotifier` : `favoriteMembers`, `viewedMembers`, `preferredTreeView`, `toggleFavoriteMember`, `markMemberViewed`, `setPreferredTreeView`

**Presentation**
- `TreeScreen` : sélecteur de vue (Radiale / Rivière / Constellation)
- `RadialView` + `RadialPainter` : CustomPainter, 5 filtres
- `RiverView` + `RiverNode` : 3 flux (paternel / maternel / descendants)
- `ConstellationView` : exploration nœud par nœud + path tracing
- `PersonDetailScreen` (`ConsumerStatefulWidget`) : fiche complète + `markMemberViewed` dans `initState`
- `TreeListScreen` : liste alphabétique
- `family_role_labels.dart` : `familyRoleLabel(context, role)` — partagé river + detail

---

### `features/study/` — Mode Étude

**Data layer**
- `Parcours` (Freezed) : `id`, `titleFr`, `titleAr`, `descriptionFr`, `nameNumbers`, `colorHex`
- `parcoursProvider` : `FutureProvider<List<Parcours>>`
- `ReviewState` (Freezed) : `queue`, `currentIndex`, `isFlipped`, `isDone`

**Domain facade**
- `studyNotifierProvider` → `StudyNotifier` : `leitnerBoxes`, `completedParcours`, `studyMode`, `getItemsForReview(allNumbers)`, `levelUp`, `levelDown`, `setStudyMode`, `markParcoursComplete`

**`getItemsForReview` — algorithme SRS**
```dart
// Priorité : niveau 0 d'abord, puis niveau 1
// Niveau 2 = maîtrisé, exclu de la file
List<int> getItemsForReview(List<int> allNumbers) {
  final boxes = leitnerBoxes;
  final level0 = allNumbers.where((n) => (boxes[n] ?? 0) == 0).toList();
  final level1 = allNumbers.where((n) => (boxes[n] ?? 0) == 1).toList();
  return [...level0, ...level1];
}
```

**Presentation**
- `StudyEntryScreen` : hub (Parcours + Revue)
- `ParcoursListScreen` : liste avec badge terminé
- `ParcoursDetailScreen` : navigation nom par nom, `markParcoursComplete` + `levelUp` à complétion
- `ReviewScreen` + `ReviewController` : flashcards Leitner, auto-avance 1200ms

---

### `features/asmaul_husna/` — 99 Noms d'Allah

**Data layer**
- `HusnaName` (Freezed) : `id`, `arabic`, `transliteration`, `meaningFr`, `etymology`, `reference`
- `HusnaRepository` : `getById`, `getAll`
- `husnaRepositoryProvider` : `FutureProvider<HusnaRepository>`

**Domain facade**
- `asmaaNotifierProvider` → `AsmaaNotifier` : `husnaLearned`, `markHusnaLearned`

**Presentation**
- `HusnaListScreen` : liste searchable, badge "appris" (check vert)
- `HusnaDetailScreen` (`ConsumerStatefulWidget`) : timer 8s → `markHusnaLearned`, nav prev/next

---

### `features/quiz/` — Quiz

- `QuizGenerator.generate(names, count)` : 10 questions QCM, distracteurs même catégorie
- `QuizSession` (Freezed) : questions + names pour flashcards
- `quizSessionProvider` : `StateProvider<QuizSession?>`
- `QcmScreen` : sélection → `markLearned` + `levelUp` si correct, auto-avance 1200ms
- `FlashcardsScreen` : flip → know (`markLearned` + `levelUp`) / review
- `ResultScreen` : score + CTA "Explorer les noms"

---

### `features/profile/` — Profil

- `ProfileScreen` : constellation animée + stats dynamiques (total depuis repo)
- `SettingsScreen` : thème (ThemeKey), taille texte (TextSize) — via `settingsProvider.notifier` directement (périmètre global légitime)
- `FavoritesScreen` : liste filtrée via `namesNotifierProvider`

---

## 6. Recettes pratiques

### Ajouter un nouveau deck (ex: 25 Prophètes)

1. Créer `assets/data/prophets.json` + modèle Freezed dans `features/prophets/data/`
2. Créer `FutureProvider<ProphetRepository>` dans `core/providers/`
3. Ajouter les champs persistés dans `UserState` + `HiveSource._toMap/_fromMap`
4. Créer la facade `Provider<ProphetsNotifier>` sur le modèle de `NamesNotifier`
5. Ajouter la route dans `app_router.dart`
6. Ajouter la carte dans `DiscoverScreen`

### Ajouter un champ à `UserState`

```dart
// 1. user_state.dart
@Default('') String monNouveauChamp,

// 2. HiveSource._toMap
'monNouveauChamp': s.monNouveauChamp,

// 3. HiveSource._fromMap
monNouveauChamp: m['monNouveauChamp'] as String? ?? '',

// 4. Méthode dans SettingsNotifier
Future<void> setMonNouveauChamp(String v) => _save(state.copyWith(monNouveauChamp: v));

// 5. Exposer dans la facade du bon domaine
// 6. dart run build_runner build --delete-conflicting-outputs
```

### Ajouter une clé L10n

```bash
# 1. Éditer l10n/intl_fr.arb (source de vérité)
# 2. Éditer l10n/intl_ar.arb (traduction arabe)
# 3. Régénérer
flutter gen-l10n
```

Clés UI ajoutées en v1.5.1 :

- 404 : `errorPageNotFound`, `errorBackHome`
- Hub Découvrir : `discoverProphetsTitle`, `discoverProphetsTitleAr`, `discoverProphetsSubtitle`, `discoverHusnaTitleAr`, `discoverHusnaSubtitle`
- Asmāʾ al-Ḥusnā : `husnaTitle`, `husnaSearchHint`, `husnaPrevious`, `husnaNext`, `husnaEtymology`, `husnaReference`

### Inspecter une version passée

```bash
git checkout v1.3     # Détaché — lecture seule, aucun risque
git checkout feat/experimental  # Revenir en dev
```

### Lancer build_runner

```bash
dart run build_runner build --delete-conflicting-outputs
# Ou après modification conflictuelle :
dart run build_runner build -d
```
