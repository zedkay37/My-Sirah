# Architecture Sirah Hub — Document de référence

> Mis à jour : 2026-04-27
> Branche stable : `main` (tag v1.4 + audit patch)
> Branche dev : `feat/experimental`

---

## Identité de l'app

**Sirah Hub** — Application mobile Flutter pour explorer la connaissance du Prophète ﷺ et de l'Islam.
Package : `sirah_app` · Offline-first · Zéro backend

---

## Stack technique

| Outil | Usage |
|-------|-------|
| Flutter 3.24+ / Dart 3 | Framework principal |
| Riverpod 2.x | State management — UNIQUEMENT, jamais Provider/Bloc |
| go_router | Navigation |
| hive_ce | Persistance locale (offline-first, zéro backend) |
| freezed + json_serializable | Modèles immuables |
| google_fonts | Amiri, Amiri Quran, Crimson Pro, Inter |
| flutter_animate | Animations déclaratives |
| intl | L10n FR + AR (placeholder) |
| flutter_local_notifications | Notification quotidienne |

---

## Tokens de thème — valeurs autorisées uniquement

### AppColors
```dart
context.colors.bg        // fond principal
context.colors.bg2       // fond secondaire (cartes)
context.colors.ink       // texte principal
context.colors.muted     // texte secondaire / icônes inactives
context.colors.accent    // couleur accent (or / violet selon thème)
context.colors.accent2   // accent secondaire
context.colors.line      // séparateurs / bordures
context.colors.success   // vert succès
context.colors.error     // rouge erreur
```
❌ Tokens inexistants : `surface`, `text`, `onPrimary`, `primary`

### AppTypography
```dart
context.typo.displayLarge
context.typo.displayMedium
context.typo.headline
context.typo.bodyLarge
context.typo.body
context.typo.caption
context.typo.overline
context.typo.button
context.typo.arabicBody    // police Amiri pour texte arabe
```
❌ Tokens inexistants : `labelLarge`, `labelMedium`, `titleMedium`

### 3 thèmes
- `ThemeKey.light` — éditorial sobre (affiché "Clair")
- `ThemeKey.dark` — nuit + or (affiché "Sombre")
- `ThemeKey.feminine` — constellation violet (affiché "Violet")

---

## Règles de code non-négociables

1. **Freezed** : toujours `abstract class Foo with _$Foo` — jamais `class Foo with _$Foo`
2. **L10n** : source de vérité = `.arb` files. Ne jamais éditer `lib/l10n/*.dart` directement
3. **Couleurs** : jamais de couleur en dur, toujours `context.colors.X`
4. **Strings UI** : jamais en dur, toujours `context.l10n.X`
5. **Après modif freezed** : `dart run build_runner build --delete-conflicting-outputs`
6. **Après ajout clés l10n** : `flutter gen-l10n`
7. **Navigation** : `context.push()` / `context.pop()` via go_router — jamais `Navigator` directement
8. **State** : `ref.watch()` dans `build()`, `ref.read()` dans les handlers

---

## Structure des dossiers (V1.4)

```
lib/
  main.dart
  app.dart                          # MaterialApp.router + ThemeProvider
  core/
    theme/
      app_theme.dart
      app_colors.dart               # ThemeExtension<AppColors>
      app_typography.dart
      app_spacing.dart
      app_radius.dart
      text_size.dart                # enum TextSize (small/medium/large)
      theme_key.dart                # enum ThemeKey (light/dark/feminine)
      themes/
        light_theme.dart · dark_theme.dart · feminine_theme.dart
    router/
      app_router.dart               # go_router + StatefulShellRoute (4 onglets) + errorBuilder 404
    storage/
      hive_source.dart              # 1 box 'settings', JSON manuel sécurisé, pas de TypeAdapter
    providers/
      user_state.dart               # freezed — état global utilisateur
      settings_provider.dart        # NotifierProvider<SettingsNotifier, UserState>
      names_providers.dart          # FutureProvider<List<ProphetName>>
      genealogy_providers.dart      # FutureProvider<GenealogyRepository>
      husna_providers.dart          # FutureProvider<List<HusnaName>> (V1.4)
    models/                         # modèles génériques multi-deck (V1.3)
      learning_deck.dart
      learning_item.dart
    notifications/
      notification_service.dart
    utils/
      build_context_x.dart          # extension BuildContextX — colors, typo, space, radii, l10n
  features/
    names/                          # 201 Noms du Prophète ﷺ
    quiz/                           # QCM + Flashcards (noms du Prophète)
    profile/                        # Profil, favoris, settings
    onboarding/
    genealogy/                      # Arbre généalogique 67 personnes
    study/                          # Parcours thématiques + Leitner (V1.3)
    asmaul_husna/                   # 99 Noms d'Allah (V1.4)
    shared/                         # Widgets réutilisables
assets/
  data/
    names.json                      # 201 noms — NE PAS MODIFIER sans accord
    categories.json                 # 11 catégories
    genealogy.json                  # 67 personnes sourcées
    parcours.json                   # 8 parcours thématiques (V1.3)
    asmaul_husna.json               # 99 noms d'Allah (V1.4)
l10n/
  intl_fr.arb                       # SOURCE DE VÉRITÉ L10N — toujours éditer ici
  intl_ar.arb
```

---

## Persistance — HiveSource

**Pattern** : une seule box `'settings'`, blob JSON encodé manuellement. Pas de TypeAdapter. Tout dans `UserState`.

Parsing sécurisé : `int.tryParse()` + `value is int` — jamais de cast brutal.

Pour ajouter un champ :
1. Ajouter dans `user_state.dart` (freezed, avec `@Default`)
2. Ajouter dans `HiveSource._toMap()` ET `HiveSource._fromMap()`
3. `dart run build_runner build --delete-conflicting-outputs`

### Champs UserState (V1.4)
```dart
// Core
ThemeKey theme
TextSize textSize
Set<int> favorites          // numéros de noms du Prophète favoris
Set<int> learned            // noms du Prophète marqués "appris" (timer 8s)
Set<int> viewed
Map<int, DateTime> lastSeen
DateTime? onboardingCompletedAt
int? dailyNotifHour
int quizzesCompleted
int totalQuizScore
// Généalogie (V1.1)
Set<String> favoriteMembers
Set<String> viewedMembers
String preferredTreeView    // 'radial' | 'river' | 'constellation' | 'list'
// Study / Leitner (V1.3)
Map<int, int> leitnerBoxes  // nameNumber → niveau 0/1/2
Set<String> completedParcours
String studyMode
// Asmāʾ al-Ḥusnā (V1.4)
Set<int> husnaLearned       // IDs 1-99 des noms d'Allah appris
```

---

## Navigation — app_router.dart (V1.4)

4 onglets `StatefulShellRoute.indexedStack` :
1. `/home` — HomeScreen
2. `/discover` — DiscoverScreen (hub de decks)
3. `/profile` — ProfileScreen
4. `/tree` — TreeScreen

Routes sous `/discover` :
- `/discover/prophets` — ProphetsDiscoverScreen (liste 201 noms + quiz)
- `/discover/husna` — HusnaListScreen
- `/discover/husna/:id` — HusnaDetailScreen

Routes hors-onglets :
- `/onboarding`
- `/name/:number` — DetailScreen (swipeable)
- `/name/:number/tafakkur` — TafakkurScreen
- `/quiz/qcm` · `/quiz/flashcards` · `/quiz/result`
- `/study` → StudyEntryScreen (bypassed — home → `/study/parcours-list` directement)
- `/study/parcours-list` · `/study/parcours/:id` · `/study/review`
- `/settings` · `/favorites`
- `/tree/person/:id` · `/tree/list`
- Fallback 404 : `errorBuilder` → page "introuvable" + retour `/home`

Transition standard : `_fadeSlide()` — à utiliser sur tous les `pageBuilder`.

---

## Modules — état V1.4

### `features/names/` — 201 Noms du Prophète ﷺ
- `data/` : `ProphetName` freezed, `NamesJsonSource`, `NamesRepository` (getDailyName avec époque statique)
- `presentation/home/` : HomeScreen, DailyNameCard, CategoryCarousel
- `presentation/list/` : `DiscoverScreen` (hub), `ProphetsDiscoverScreen` (liste+quiz), `ListScreen`
- `presentation/detail/` : DetailScreen swipeable, ShareNameService
- `presentation/tafakkur/` : TafakkurScreen, TafakkurController, widgets zoom/overlay/progress

### `features/quiz/` — Quiz (noms du Prophète uniquement pour l'instant)
- `QuizGenerator` — 10 questions, distracteurs même catégorie
- QcmScreen, FlashcardsScreen, ResultScreen, QuizEntryScreen

### `features/asmaul_husna/` — 99 Noms d'Allah (V1.4)
- `data/` : `HusnaName` freezed, `HusnaJsonSource`, `HusnaRepository`
- `presentation/list/` : `HusnaListScreen` — searchable, badge appris
- `presentation/detail/` : `HusnaDetailScreen` — auto-learned 8s, nav prev/next dynamique

### `features/study/` — Mode Étude (V1.3)
- `data/` : `LeitnerRepository`, `ParcoursRepository`
- `presentation/parcours/` : `ParcoursListScreen`, `ParcoursDetailScreen`
- `presentation/review/` : `ReviewScreen`, `ReviewController`

### `features/genealogy/` — Arbre généalogique (V1.1)
- 67 personnes, BFS path-finding, getProphet() avec StateError explicite
- 5 vues : Radiale, Rivière (3 streams : paternel/maternel/descendants), Constellation, Liste, Fiche détail

### `features/profile/`
- ProfileScreen : constellation + stats dynamiques (total depuis repo)
- SettingsScreen, FavoritesScreen

---

## L10n — clés notables

Toutes les clés sont dans `l10n/intl_fr.arb` (source de vérité).
Clés avec placeholders : `homeCategoryLearned`, `detailProgress`, `quizProgress`, `quizResultScore`, `tafakkurRemaining`, `studyReviewSubtitle`, `studyMasteredBadge`.

---

## Roadmap

| Version | Contenu | Statut |
|---------|---------|--------|
| V1.0 | 201 noms, quiz, profil, favoris, onboarding, notifs, 3 thèmes | ✅ tag v1.0 |
| V1.1 | Généalogie (5 vues, 67 personnes) | ✅ tag v1.1 |
| V1.2 | Tafakkur, rebrand, correctifs thème | ✅ tag v1.2 |
| V1.3 | SRS Leitner + Parcours Thématiques + architecture multi-deck | ✅ tag v1.3 |
| V1.4 | Hub Découvrir + Deck Asmāʾ al-Ḥusnā (99 noms) | ✅ tag v1.4 |
| audit | Robustesse : constants dynamiques, 404, Hive sécurisé | ✅ post-v1.4 |
| **V1.5** | Quiz Husna + Deck Arkān (pilliers Islam + Foi) | 📋 planifié |
| V1.6 | 25 Prophètes coraniques | 📋 planifié |

### Hors scope permanent
Fiqh, dates historiques disputées, théologie des attributs, tawassul, tariqas soufies, classement Compagnons, backend/auth/audio.

### Corpus validés (tous courants confondus)
1. ✅ 201 Noms du Prophète ﷺ
2. ✅ 99 Noms d'Allah (liste Tirmidhī, sens linguistiques)
3. ✅ Arkān al-Islām + al-Īmān (unanimité — hadith Jibrīl)
4. ✅ 25 Prophètes coraniques (texte coranique uniquement)

---

## Conventions de nommage

- Fichiers : `snake_case.dart`
- Classes/widgets : `PascalCase`
- Providers : suffixe `Provider` (`namesProvider`, `settingsProvider`)
- Notifiers : suffixe `Notifier` (`SettingsNotifier`)
- Extensions : `BuildContextX on BuildContext`
- Enums : `PascalCase` valeurs `camelCase`

## Commits

Format conventional commits : `feat(study): ...`, `fix(quiz): ...`, `chore: ...`
Un commit par feature complète, pas de micro-commits.
