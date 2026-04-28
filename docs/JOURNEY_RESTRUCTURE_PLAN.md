# Sirah Hub v2.0 — Journey Restructure Plan

> Statut : design technique initial  
> Date : 2026-04-27  
> Version cible de travail : v2.0  
> Rôle du document : cadrer la restructuration avant implémentation, puis servir de backlog pour Gemini Flash et de grille de revue pour Codex.

---

## 1. Vision Produit

Sirah Hub v2.0 doit évoluer d'un hub modulaire vers une aventure contemplative structurée autour des noms du Prophète ﷺ.

Vision cible :

> Chaque nom devient une étoile vivante : une porte vers un récit, un tafakkur, une action et une mémorisation douce.

Boucle produit centrale :

```text
Découvrir -> Comprendre -> Contempler -> Incarner -> Mémoriser
```

La refonte ne doit pas ajouter de nombreux modules indépendants. Elle doit faire converger l'existant autour des noms du Prophète ﷺ comme axe central.

Décision stratégique :

> Préserver les versions v1.x comme socle stable et créer une v2.0 de rework, sans réécrire brutalement l'historique ni casser l'expérience existante.

Principes non négociables :

- Pas de gamification spirituelle intrusive.
- Pas de score, badge, compétition ou déblocage artificiel de contenu essentiel.
- Pas d'IA générative dans les contenus spirituels/actions.
- Les actions proposées viennent d'une banque éditoriale locale validée.
- Le module Asmāʾ al-Ḥusnā reste en satellite pour l'instant.
- La généalogie devient un support narratif relié aux noms, pas un module isolé.

---

## 2. État Actuel À Préserver

Architecture actuelle :

```text
/home
/discover
/profile
/tree
/study
/quiz
/name/:number
/name/:number/tafakkur
/discover/husna
```

Socle technique validé en v1.5.1 :

- `flutter analyze` : OK
- `flutter test` : OK, 18 tests passent
- `flutter gen-l10n` : OK, avec 76 messages AR encore non traduits
- `SettingsNotifier` est le seul écrivain Hive
- `HiveSource` lit/écrit `UserState` dans une box Hive unique
- `NotificationService` programme le rappel quotidien avec `timezone`, timezone actuelle fixe `Europe/Paris`

Versions à préserver :

- `v1.0` à `v1.5.1` restent des jalons stables.
- `main` doit rester exploitable à tout moment.
- Le rework v2.0 doit vivre sur une branche dédiée jusqu'à stabilisation.

Branche recommandée :

```text
feat/v2-journey-restructure
```

Tag cible final :

```text
v2.0.0
```

Règle de release :

- pas de tag `v2.0.0` tant que la navigation, la persistance, les tests et la documentation ne sont pas stabilisés ;
- pas de suppression de module v1.x dans les premiers sprints ;
- les anciennes routes doivent rester accessibles ou redirigées proprement.

Contraintes de protection :

- Ne pas modifier `assets/data/names.json` sans validation explicite.
- Ne pas éditer directement `lib/l10n/*.dart`; éditer `l10n/*.arb`, puis `flutter gen-l10n`.
- Ne pas casser les routes existantes.
- Ne pas supprimer les modules existants pendant les premiers sprints.
- Ne pas remplacer la navigation principale en premier sprint.

---

## 3. Architecture Cible

La navigation produit cible se structure progressivement autour de quatre pôles :

```text
Aujourd'hui      -> rituel quotidien
Voyage           -> constellations thématiques de noms
Cheminement      -> révision, quiz, mémorisation
Sirah / Famille  -> généalogie et récits liés
```

La transition doit être progressive. Étape 1 : garder la tab bar actuelle.

Routes à ajouter en premier :

```text
/journey
/journey/constellation/:id
/name/:number/experience
```

Routes existantes à conserver :

```text
/home
/discover
/profile
/tree
/name/:number
/name/:number/tafakkur
/study
/quiz/qcm
/quiz/flashcards
/discover/husna
```

Nom du nouveau module :

```text
lib/features/journey/
```

Raison : `constellation` est déjà utilisé dans `genealogy/presentation/constellation` et dans le profil. `journey` porte une vision plus large que les noms seuls.

### Compatibilité v1.x

La v2.0 ne doit pas supprimer immédiatement les surfaces v1.x :

| Surface v1.x | Statut en v2.0 initiale |
|-------------|--------------------------|
| `/home` | devient progressivement "Aujourd'hui" |
| `/discover` | conservé au début, peut rediriger vers Explorer/Voyage plus tard |
| `/profile` | conservé, puis déplacé hors tab bar si validé |
| `/tree` | conservé comme Sirah/Famille |
| `/study` | conservé comme Cheminement |
| `/quiz/*` | conservé |
| `/discover/husna` | conservé en satellite |
| `/name/:number` | conservé comme fiche classique |
| `/name/:number/tafakkur` | conservé puis enrichi |

Objectif : aucun utilisateur ne doit perdre l'accès à une feature existante pendant la migration v2.0.

### V2.1 — Séparation Voyage / Bibliothèque

Décision produit validée après les premiers sprints V2 :

- `Découvrir` ne doit plus être un menu de domaines.
- `Voyage` porte l'expérience immersive et émotionnelle.
- `Bibliothèque` porte l'accès rationnel aux listes, fiches, quiz, flashcards et révisions.

Bottom bar cible :

```text
Accueil
Voyage
Bibliothèque
Profil
Arbre
```

Routes de migration :

```text
/discover                  -> /library
/discover/prophets         -> /library/deck/prophet_names
/discover/husna            -> /library/deck/asmaul_husna
/discover/husna/:id        -> /library/deck/asmaul_husna/:id
```

Règle : les anciennes routes restent redirigées pour compatibilité, mais ne sont plus l'interface principale.

---

## 4. Nouveaux Assets

Ne pas modifier `names.json` en première phase. Ajouter des fichiers complémentaires :

```text
assets/data/name_constellations.json
assets/data/name_experiences.json
assets/data/name_actions.json
```

### 4.1 `name_constellations.json`

But : introduire les constellations thématiques, qui remplaceront progressivement les catégories et parcours comme lecture principale.

Structure recommandée :

```json
[
  {
    "id": "truth_trust",
    "titleFr": "Vérité et confiance",
    "titleAr": "الصدق والأمانة",
    "descriptionFr": "Les noms qui révèlent la véracité, la fiabilité et la droiture prophétique.",
    "nameNumbers": [1, 21, 22, 35],
    "colorHex": "#D4A857"
  }
]
```

Contraintes :

- `id` unique
- `nameNumbers` non vide
- chaque numéro doit exister dans `names.json`
- aucun doublon dans une constellation
- une même étoile peut appartenir à plusieurs constellations si éditorialement justifié

### 4.2 `name_experiences.json`

But : relier un nom à un récit, un prompt tafakkur, une thématique de pratique et plus tard des personnes liées.

Structure recommandée :

```json
[
  {
    "nameNumber": 1,
    "stories": [
      {
        "id": "amin_before_revelation",
        "titleFr": "La confiance avant la révélation",
        "bodyFr": "...",
        "tags": ["confiance", "mecque", "caractere"],
        "sourceNote": "Récit de Sirah à sourcer précisément.",
        "relatedPeople": []
      }
    ],
    "tafakkurPromptFr": "Que signifie être digne de confiance aujourd'hui ?",
    "practiceTheme": "trust"
  }
]
```

Contraintes :

- `nameNumber` doit exister dans `names.json`
- `practiceTheme` doit exister dans `name_actions.json`
- `stories[].sourceNote` obligatoire si le récit n'est pas encore sourcé précisément
- `relatedPeople` optionnel au départ, mais prévu pour relier la généalogie

### 4.3 `name_actions.json`

But : proposer une action courte, douce et concrète, liée au nom du jour ou au nom consulté.

Structure recommandée :

```json
[
  {
    "theme": "trust",
    "actions": [
      "Tiens une promesse, même petite.",
      "Évite une exagération dans ta parole aujourd'hui.",
      "Rends quelque chose confié avec soin."
    ]
  }
]
```

Contraintes :

- Actions locales validées éditorialement.
- Pas d'action générée librement par IA.
- Pas de formulation culpabilisante.
- Pas de scoring.
- Prévoir un thème fallback `general`.

---

## 5. Nouveau Module `features/journey`

Arborescence cible Sprint 1 :

```text
lib/features/journey/
  data/
    models/
      name_constellation.dart
      name_experience.dart
      name_action_set.dart
    sources/
      name_constellations_json_source.dart
      name_experiences_json_source.dart
      name_actions_json_source.dart
    repositories/
      journey_repository.dart
  presentation/
    journey_screen.dart
    constellation_detail_screen.dart
    name_experience_screen.dart
```

Providers à ajouter :

```text
lib/core/providers/journey_providers.dart
```

Providers recommandés :

```dart
final journeyRepositoryProvider = FutureProvider<JourneyRepository>(...);
final nameConstellationsProvider = FutureProvider<List<NameConstellation>>(...);
final dailyNameActionProvider = FutureProvider<NameActionSuggestion>(...);
```

Ne pas ajouter de persistance dans `JourneyRepository`. La progression reste dans `UserState`.

---

## 6. Modèles Recommandés

### `NameConstellation`

Champs :

```dart
String id
String titleFr
String? titleAr
String descriptionFr
List<int> nameNumbers
String colorHex
```

### `NameExperience`

Champs :

```dart
int nameNumber
List<NameStory> stories
String tafakkurPromptFr
String practiceTheme
```

### `NameStory`

Champs :

```dart
String id
String titleFr
String bodyFr
List<String> tags
String sourceNote
List<String> relatedPeople
```

### `NameActionSet`

Champs :

```dart
String theme
List<String> actions
```

### `NameActionSuggestion`

Modèle calculé, non persisté :

```dart
int nameNumber
String theme
String action
DateTime date
```

Sélection recommandée :

- déterministe par jour + numéro du nom
- pas aléatoire pur à chaque rebuild
- exemple seed : `yyyyMMdd-nameNumber-theme`
- fallback : thème `general`

---

## 7. Progression Produit

L'état `learned` existe déjà mais ne doit plus être la métrique centrale à long terme.

Nouvelle progression progressive recommandée :

```dart
Set<int> meditatedNames
Set<int> practicedNames
Set<int> recognizedNames
Set<int> masteredNames
Map<int, DateTime> lastMeditatedAt
Map<int, DateTime> lastPracticedAt
```

Ne pas passer immédiatement à `Map<int, NameProgress>` pour limiter le risque de migration Hive.

États produit :

| État | Déclencheur |
|------|-------------|
| Vu | fiche ouverte |
| Médité | tafakkur terminé |
| Incarné | action validée |
| Reconnu | quiz ou flashcard réussi |
| Maîtrisé | répétitions espacées réussies |

Méthodes à ajouter progressivement dans `SettingsNotifier` :

```dart
markNameMeditated(int number)
markNamePracticed(int number)
markNameRecognized(int number)
markNameMastered(int number)
```

Facade `NamesNotifier` ou nouvelle facade `JourneyProgressNotifier` à discuter après Sprint 1.

Règle importante : Tafakkur 2.0 ne doit plus appeler directement `levelUp()`. Il doit appeler `markNameMeditated(number)`.

---

## 8. Home Cible : Rituel Quotidien

Objectif : transformer `HomeScreen` d'un dashboard en rituel quotidien.

Structure cible :

1. Header sobre
   - date grégorienne
   - date hégirienne
   - salutation

2. Hero nom du jour
   - arabe très visible
   - translittération
   - sens court
   - constellation associée

3. Trois CTA
   - Explorer ce nom
   - Entrer en tafakkur
   - Vivre une action

4. Carte Action du jour
   - action courte liée au thème
   - bouton "Je l'ai vécue"
   - jamais culpabilisant

5. Carte Continuer mon voyage
   - constellation en cours
   - prochaine étoile

6. Révision douce
   - visible seulement si utile
   - secondaire

Sprint recommandé : ne pas refondre `HomeScreen` avant que la couche `journey/data` soit stable et testée.

---

## 9. Page "Nom Vivant"

Route initiale :

```text
/name/:number/experience
```

Ne pas fusionner immédiatement avec `DetailScreen`; commencer par une page pivot dédiée.

Contenu cible :

- arabe
- translittération
- sens
- source
- constellation(s)
- récit(s) lié(s)
- prompt tafakkur
- action proposée
- état de progression
- CTA vers Tafakkur
- CTA vers fiche classique `/name/:number`
- liens éventuels vers généalogie si `relatedPeople` existe

Après stabilisation, décider si `DetailScreen` devient cette page ou reste une fiche de référence.

---

## 10. Voyage Stellaire MVP

Écrans Sprint 4 :

```text
JourneyScreen
ConstellationDetailScreen
```

MVP volontairement simple :

- liste de constellations
- progression par constellation
- détail constellation
- liste des noms/étoiles
- clic étoile -> `/name/:number/experience`

Pas encore de carte stellaire complexe, pas de canvas animé, pas de 3D.

Les anciens parcours et catégories peuvent inspirer les premières constellations, mais ne doivent pas être supprimés au début.

---

## 11. Tafakkur 2.0

Le Tafakkur actuel est une bonne base technique. Évolution cible : mini-livre contemplatif.

Structure d'une session :

1. Page du nom
2. Page récit court
3. Page méditation
4. Page intention / action

Fonctionnalités cibles :

- swipe doux
- durée estimée avant session
- bouton de sortie discret
- haptique léger optionnel
- son de page optionnel
- paramètres pour désactiver sons/haptics/animations

Règle métier :

- fin de session -> `markNameMeditated(number)`
- pas de `levelUp()` direct

Les sons/haptics doivent être reportés tant que les settings d'accessibilité ne sont pas disponibles.

---

## 12. Généalogie Et Sirah

Ne pas supprimer les vues existantes.

Préparer des ponts :

- un récit peut référencer `relatedPeople`
- la page Nom vivant peut afficher des liens vers `PersonDetailScreen`
- un nom lié à la noblesse/famille peut proposer un lien vers l'arbre

Évolution future de `name_experiences.json` :

```json
"relatedPeople": ["khadija", "abdul_muttalib"]
```

Validation requise :

- chaque `relatedPeople` doit exister dans `genealogy.json`

---

## 13. Asmāʾ al-Ḥusnā

Directive :

- ne pas supprimer
- ne pas étendre maintenant
- pas de quiz Husna
- pas de parcours Husna
- pas de moteur générique de decks maintenant

Le coeur produit de la restructuration est :

> les noms du Prophète ﷺ comme portes vers la Sirah.

---

## 14. L10n Et Accessibilité

### L10n

État actuel :

- FR : langue principale
- AR : partiel, 76 messages non traduits au dernier `flutter gen-l10n`

Décision produit à prendre avant release majeure :

1. FR-only temporaire, ou
2. AR complété proprement

Éviter une locale AR visible mais manifestement cassée.

Règles :

- toutes les nouvelles strings UI dans `l10n/intl_fr.arb`
- ajouter équivalent dans `l10n/intl_ar.arb`, même temporaire
- lancer `flutter gen-l10n`

### Accessibilité

À intégrer progressivement :

- labels `Semantics` localisés sur CTA principaux
- tap targets suffisants
- contraste vérifié
- mode réduire animations
- sons/haptics désactivables
- texte adaptatif via `TextSize`

---

## 15. Notifications

État actuel :

- notification quotidienne active
- timezone fixe `Europe/Paris`
- deep-link vers le nom du jour

Évolution cible :

```dart
NotificationService.scheduleDailyNameReminder(hour)
```

Améliorations :

- détecter timezone appareil
- fallback `Europe/Paris`
- localiser title/body
- vérifier deep-link `/name/:number` ou futur `/name/:number/experience`

Texte produit cible :

> Aujourd'hui, entre dans un nom du Prophète ﷺ.

---

## 16. Tests Prioritaires

Avant grosse refonte UI, ajouter les tests P0.

### HiveSource

- lecture état vide
- lecture état corrompu
- champs inconnus
- champs nouveaux absents
- valeurs de type inattendu

### NamesRepository

- charge 201 noms
- `getByNumber`
- `search`
- `getDailyName` stable avec date contrôlée si possible

### StudyNotifier

- `levelUp`
- `levelDown`
- queue review

### QuizGenerator

- 5 questions
- 4 choix
- bonne réponse incluse
- pas de doublons dans les choix

### JourneyRepository

- constellations chargées
- `nameNumbers` valides
- aucun doublon local
- actions liées à des thèmes connus

### NameExperienceRepository

- chaque `nameNumber` existe
- chaque `practiceTheme` existe
- `relatedPeople` valides si présents

---

## 17. Ordre D'Exécution

### Pré-sprint — Préservation v1.x

Objectif : isoler le chantier v2.0 sans mettre en risque la version stable.

Tâches :

- vérifier que `main` est propre et taggé `v1.5.1`
- créer la branche `feat/v2-journey-restructure`
- ne pas retagger une version v1.x pour le rework
- documenter dans `CHANGELOG.md` une section future `v2.0.0` seulement quand le rework est prêt
- garder un chemin de rollback simple vers `v1.5.1`

### Sprint 0 — Sécurisation

Objectif : sécuriser sans feature visible majeure.

Tâches :

- confirmer repo propre
- `flutter gen-l10n`
- `dart format .`
- `flutter analyze`
- `flutter test`
- documenter l'état l10n AR
- ajouter tests P0 `HiveSource`, `NamesRepository`, `QuizGenerator`
- ne pas toucher à la navigation

État au 2026-04-28 :

- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 57 tests passent
- tests ajoutés : `HiveSource`, `NamesRepository`, `QuizGenerator`, `StudyNotifier`
- aucune modification UI ou navigation
- point restant hors Sprint 0 : décider la stratégie release pour la locale arabe partielle

### Sprint 1 — Couche Journey Data

Objectif : ajouter la donnée et les repositories sans refonte UI massive.

Tâches :

- créer `assets/data/name_constellations.json`
- créer `assets/data/name_experiences.json`
- créer `assets/data/name_actions.json`
- créer modèles Freezed/JSON
- créer sources JSON
- créer `JourneyRepository`
- créer providers
- ajouter tests repository

État au 2026-04-28 :

- assets créés : `name_constellations.json`, `name_experiences.json`, `name_actions.json`
- module créé : `lib/features/journey/data/`
- repository créé : `JourneyRepository`
- provider créé : `journeyRepositoryProvider`
- tests ajoutés : `JourneyRepository` avec fixtures et chargement réel des assets
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 67 tests passent
- aucune modification UI, navigation ou `assets/data/names.json`

### Sprint 2 — Nom Vivant

Objectif : créer une page pivot sans remplacer `DetailScreen`.

Tâches :

- route `/name/:number/experience`
- `NameExperienceScreen`
- afficher récit, constellation, action, CTA tafakkur
- gérer fallback si expérience absente
- ajouter tests widget basiques si possible

État au 2026-04-28 :

- route ajoutée : `/name/:number/experience`
- écran créé : `NameExperienceScreen`
- contenu MVP : nom, constellation(s), récit, prompt tafakkur, action du jour, CTA tafakkur, CTA fiche classique
- fallback créé si aucun récit dédié ou si Journey échoue à charger
- lien discret ajouté depuis `DetailScreen`
- tests ajoutés : rendu avec expérience et rendu fallback sans expérience
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 69 tests passent

### Sprint 3 — Home Rituel

Objectif : refondre `HomeScreen` autour du rituel quotidien.

Tâches :

- hero nom du jour
- CTA explorer / tafakkur / action
- carte action du jour
- carte continuer voyage
- révision douce secondaire

État Sprint 3A au 2026-04-28 :

- `HomeScreen` reste compatible avec la structure v1.x
- `DailyNameCard` devient une carte de rituel quotidien
- CTA ajoutés : explorer le nom vivant, entrer en tafakkur, ouvrir la fiche classique
- action du jour affichée depuis `JourneyRepository`
- constellation liée au nom du jour affichée quand disponible
- carte "Continuer mon voyage" ajoutée avec prochaine étoile de la constellation
- catégories et étude restent accessibles
- nouvelles clés l10n FR/AR ajoutées
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 69 tests passent

État Sprint 3B au 2026-04-28 :

- date grégorienne du header localisée avec `intl.DateFormat`
- carte du nom du jour resserrée avec hauteur responsive bornée
- récupération de constellation harmonisée avec `firstOrNull`
- test Home renforcé : CTA "Explorer ce nom", action du jour et "Continuer mon voyage"
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 69 tests passent

### Sprint 4 — Voyage Stellaire MVP

Objectif : créer une entrée Journey simple.

Tâches :

- route `/journey`
- route `/journey/constellation/:id`
- liste constellations
- détail constellation
- noms/étoiles cliquables

État au 2026-04-28 :

- route ajoutée : `/journey`
- route ajoutée : `/journey/constellation/:id`
- écran créé : `JourneyScreen`
- écran créé : `ConstellationDetailScreen`
- Discover affiche une carte "Voyage" vers `/journey`
- progression MVP basée sur `UserState.viewed`
- clic étoile/nom -> `/name/:number/experience`
- nouvelles clés l10n FR/AR ajoutées
- tests widget ajoutés pour liste Journey et détail constellation
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 71 tests passent

### Sprint 5 — Tafakkur 2.0

Objectif : transformer Tafakkur en mini-livre.

Tâches :

- pages nom / récit / méditation / intention
- durée estimée
- completion `markNameMeditated`
- pas de `levelUp()` direct

État Sprint 5A au 2026-04-28 :

- champ `UserState.meditatedNames` ajouté
- persistence Hive ajoutée pour `meditatedNames`
- `SettingsNotifier.markNameMeditated(int number)` ajouté
- `NamesNotifier.markNameMeditated(int number)` ajouté
- Tafakkur ne déclenche plus `StudyNotifier.levelUp()` directement à la complétion
- Tafakkur marque désormais le nom comme médité
- tests Hive mis à jour pour round-trip, champ manquant et champ malformé
- `build_runner` exécuté pour `UserState.freezed.dart`
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 71 tests passent

État Sprint 5B au 2026-04-28 :

- Tafakkur construit désormais une session en 4 pages : nom, récit, méditation, intention
- les pages s'appuient sur `JourneyRepository` quand l'expérience du nom existe
- fallback conservé vers le commentaire classique si aucun récit Journey n'est disponible
- action/intention alimentée par la banque locale `name_actions.json`
- swipe horizontal ajouté pour avancer ou revenir entre les pages
- contrôleur Tafakkur enrichi avec `next()` et `previous()` sans changer le contrat de persistance
- completion toujours reliée à `markNameMeditated(number)`, sans `levelUp()` direct
- nouvelles clés l10n FR/AR ajoutées et générées
- tests widget ajoutés pour session mini-livre et fallback commentaire classique
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 73 tests passent

État Sprint 5C au 2026-04-28 :

- contrôles explicites ajoutés dans Tafakkur : page précédente, page suivante, réglage du rythme
- durée estimée affichée pour la session et résumé du rythme en secondes par page
- navigation tactile conservée, mais elle n'est plus le seul moyen d'avancer
- animations de changement de page et d'état pause désactivées quand `MediaQuery.disableAnimations` est actif
- tooltips/localisation ajoutés pour les commandes principales
- tests widget étendus pour vérifier la navigation par boutons et la durée estimée
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 74 tests passent

### Sprint 6 — Progression Propre

Objectif : ajouter les nouveaux états dans `UserState`.

Tâches :

- `meditatedNames`
- `practicedNames`
- `recognizedNames`
- `masteredNames`
- dates associées
- migration Hive robuste
- adapter profil/progression/constellations

État Sprint 6A au 2026-04-28 :

- champ `UserState.practicedNames` ajouté
- persistence Hive ajoutée pour `practicedNames`, avec fallback robuste si le champ est absent ou malformé
- `SettingsNotifier.markNamePracticed(int number)` ajouté
- facade `NamesNotifier.markNamePracticed(int number)` ajoutée
- bouton "Je l’ai vécue" ajouté sur l'action du jour du Home
- bouton "Je l’ai vécue" ajouté sur l'action du Nom vivant
- l'état devient "Action vécue" une fois marqué, sans réécriture si le nom est déjà pratiqué
- tests Hive mis à jour pour round-trip, champ manquant et champ malformé
- tests widget Nom vivant/Home mis à jour pour vérifier l'action incarnée
- `build_runner` exécuté pour `UserState.freezed.dart`
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 74 tests passent

État Sprint 6B au 2026-04-28 :

- progression Journey enrichie avec `viewed`, `meditatedNames` et `practicedNames`
- anneau de progression des constellations pondéré par étape : vu, médité, vécu
- texte de progression constellation remplacé par un résumé multi-états
- détail constellation affiche un statut par étoile : à découvrir, vue, méditée, vécue
- icônes adaptées par état : étoile vide, étoile, tafakkur, validation
- nouvelles clés l10n FR/AR ajoutées pour les statuts Journey
- tests Journey réécrits avec fixtures lisibles et assertions sur les nouveaux états
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 74 tests passent

État Sprint 6C au 2026-04-28 :

- champ `UserState.recognizedNames` ajouté
- persistence Hive ajoutée pour `recognizedNames`, avec fallback robuste si champ absent ou malformé
- `SettingsNotifier.markNameRecognized(int number)` ajouté
- facade `NamesNotifier.markNameRecognized(int number)` ajoutée
- QCM : une bonne réponse marque désormais le nom comme reconnu en plus du comportement existant
- Flashcards : "Je connais" marque désormais le nom comme reconnu en plus du comportement existant
- Journey affiche l'état "Reconnue" et l'intègre au résumé de progression
- anneau Journey pondéré par étape : vu, médité, vécu, reconnu
- tests Hive, NamesNotifier et Journey mis à jour
- `build_runner` exécuté pour `UserState.freezed.dart`
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 75 tests passent

### V2.1 Sprint A — Navigation Et Bibliothèque

Objectif : clarifier l'architecture produit avant la carte spatiale.

État au 2026-04-28 :

- bottom bar passée à 5 entrées : Accueil, Voyage, Bibliothèque, Profil, Arbre
- la tab Découvrir est remplacée par Voyage
- nouvelle route `/library`
- nouveau module `lib/features/library/`
- nouvel écran `LibraryScreen`
- nouvel écran `LibraryDeckScreen`
- deck `prophet_names` : liste des noms, apprentissage/révision, quiz/flashcards via les écrans existants
- deck `asmaul_husna` : accès bibliothèque uniquement, via les écrans existants
- anciennes routes `/discover*` redirigées vers `/library*`
- Profil et Arbre conservés
- aucune modification de `assets/data/names.json`
- test widget ajouté pour la Bibliothèque
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 76 tests passent

### V2.1 Sprint B — Galaxy Map MVP

Objectif : faire de `/journey` une vraie entrée spatiale, pas une liste de cartes.

État au 2026-04-28 :

- nouvel asset `assets/data/journey_decks.json`
- modèle `JourneyDeck` ajouté
- source JSON `JourneyDecksJsonSource` ajoutée
- provider `journeyDecksProvider` ajouté
- nouvel écran `GalaxyMapScreen`
- nouveaux widgets spatiaux :
  - `StarfieldBackground`
  - `GalaxyNode`
- `/journey` affiche désormais une carte galaxie avec `CustomPainter` + `InteractiveViewer`
- galaxie active : `prophet_names`
- tap galaxie -> `/journey/deck/prophet_names`
- decks non actifs affichés comme galaxies secondaires discrètes / bibliothèque seulement
- `/journey/deck/prophet_names` réutilise temporairement l'écran Journey existant de constellations, en attendant Sprint C
- anciennes routes `/journey/constellation/:id` conservées pour compatibilité
- tests ajoutés pour `journey_decks.json` et `GalaxyMapScreen`
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 78 tests passent

### V2.1 Sprint C — Constellation Map MVP

Objectif : transformer le deck `prophet_names` en vraie navigation spatiale jusqu'aux étoiles.

État au 2026-04-28 :

- nouvel asset `assets/data/journey_map_layout.json`
- modèle `JourneyMapLayout` ajouté
- source JSON `JourneyMapLayoutJsonSource` ajoutée
- provider `journeyMapLayoutProvider` ajouté
- nouvel écran `DeckSpaceMapScreen`
- nouvel écran `ConstellationSpaceMapScreen`
- `/journey/deck/prophet_names` affiche désormais une carte spatiale des constellations
- `/journey/deck/prophet_names/constellation/:id` affiche une carte spatiale d'étoiles
- chaque étoile ouvre `/name/:number/experience`
- liens visuels doux entre constellations et entre étoiles
- statuts visuels des étoiles alignés sur `viewed`, `meditatedNames`, `practicedNames`, `recognizedNames`
- ancienne route `/journey/constellation/:id` conservée pour compatibilité
- tests ajoutés pour la validité de `journey_map_layout.json`
- tests widget ajoutés pour deck map et constellation map
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 81 tests passent

### V2.1 Sprint D — Home Cleanup

Objectif : rendre l'accueil moins dashboard et le recentrer sur le rituel quotidien.

État au 2026-04-28 :

- `HomeScreen` ne présente plus le carrousel "Explorer par catégorie"
- l'accès frontal au "Mode Étude" est retiré de l'accueil
- le rituel du jour reste prioritaire : nom du jour, action du jour, tafakkur, nom vivant, continuer le voyage
- deux accès secondaires sobres sont ajoutés :
  - `Voyage` -> `/journey`
  - `Bibliothèque` -> `/library`
- la Bibliothèque affiche une indication de révision si des noms sont présents dans les boîtes Leitner
- les catégories restent disponibles en interne dans les listes/bibliothèque, mais ne structurent plus l'accueil
- nouvelles clés l10n FR/AR ajoutées pour les raccourcis Home
- test widget Home mis à jour pour vérifier Voyage/Bibliothèque et l'absence de "Explorer par catégorie"
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 81 tests passent

### V2.1 Sprint E — Progression Visuelle Journey

Objectif : rendre les statuts des étoiles cohérents et lisibles dans tout Journey.

État au 2026-04-28 :

- création de `NameProgressResolver`
- création de l'énumération partagée `JourneyNameStage`
- centralisation de la priorité des états :
  - reconnu
  - vécu
  - médité
  - vu
  - à découvrir
- centralisation du calcul de progression pondérée :
  - vu = 0.25
  - médité = 0.50
  - vécu = 0.75
  - reconnu = 1.00
- `JourneyScreen` utilise désormais le resolver au lieu d'une logique locale
- `ConstellationDetailScreen` utilise désormais le resolver au lieu d'une logique locale
- `DeckSpaceMapScreen` utilise désormais le resolver pour la progression des constellations
- `ConstellationSpaceMapScreen` utilise désormais le resolver pour les statuts d'étoiles
- légende visuelle ajoutée dans la carte des étoiles : à découvrir, vue, méditée, vécue, reconnue
- tests unitaires ajoutés pour `NameProgressResolver`
- tests widget de la carte spatiale étendus pour vérifier la légende
- `flutter analyze` : OK, aucune issue
- tests Journey ciblés : OK, 6 tests passent
- `flutter test` : OK, 83 tests passent

### V2.1 Sprint F — Stabilisation Routing Journey

Objectif : éviter les ambiguïtés entre Voyage spatial et Bibliothèque.

État au 2026-04-28 :

- les galaxies `library_only` de `/journey` ouvrent maintenant leur deck dans `/library/deck/:deckId`
- `/journey/deck/:deckId` vérifie que le layout chargé correspond bien au deck demandé
- `/journey/deck/:deckId/constellation/:id` vérifie aussi que le layout correspond au deck demandé
- les constellations spatiales construisent leurs routes avec le `deckId` courant, plus de valeur codée en dur
- test ajouté pour l'ouverture d'un deck Bibliothèque-only depuis la galaxie
- tests ajoutés pour refuser les mismatches deck/layout
- `flutter analyze` : OK, aucune issue
- tests Journey ciblés : OK, 6 tests passent
- `flutter test` : OK, 86 tests passent

### V2.1 Sprint G — Nettoyage Des Routes Discover Résiduelles

Objectif : faire disparaître `Discover` du code applicatif actif, tout en gardant les redirects de compatibilité.

État au 2026-04-28 :

- les liens internes Husna pointent désormais vers `/library/deck/asmaul_husna/:id`
- les boutons précédent/suivant de Husna utilisent désormais les routes Bibliothèque
- les anciens CTA vers les noms pointent désormais vers `/library/deck/prophet_names`
- `CategoryCarousel`, `DiscoverScreen`, `ResultScreen` et `FavoritesScreen` ne naviguent plus vers `/discover`
- la seule occurrence restante de `/discover` est le redirect de compatibilité dans `app_router.dart`
- test ajouté : la liste Husna ouvre le détail via la route Bibliothèque
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 87 tests passent

### V2.1 Sprint H — Stabilisation P0 Post-Audit

Objectif : corriger les bugs et incohérences qui faussent la progression ou peuvent casser l'app avant de poursuivre la consolidation Journey.

État au 2026-04-28 :

- `SettingsNotifier.markViewed()` met désormais toujours à jour `lastSeen[number]`, même si le nom était déjà dans `viewed`
- test ajouté pour vérifier que revisiter un nom rafraîchit `lastSeen` tout en gardant `viewed` idempotent
- `QcmScreen` ne crash plus si `/quiz/qcm` est ouvert sans session active
- `FlashcardsScreen` ne crash plus si `/quiz/flashcards` est ouvert sans session active
- les écrans quiz sans session affichent un retour vers la Bibliothèque
- le bouton "Rejouer" du résultat quiz ne fait plus un `pop()` fragile ; il retourne vers la Bibliothèque des noms
- les notifications ouvrent désormais `/name/:number/experience`, pas la fiche classique
- les textes notification utilisent `Sirah Hub` et le rituel du jour
- `StudyEntryContent` extrait le contenu Study sans `Scaffold`
- l'onglet Bibliothèque / Apprendre utilise `StudyEntryContent`, supprimant le nested `Scaffold`
- les raccourcis QCM et Flashcards dans Bibliothèque démarrent une vraie session avant d'ouvrir l'écran correspondant
- la galaxie Journey n'affiche plus les decks `library_only`; Asmāʾ al-Ḥusnā reste Bibliothèque uniquement
- le Nom vivant n'affiche plus le placeholder "Aucun récit dédié"; il affiche une section "Comprendre ce nom" basée sur le commentaire classique
- nouvelles clés l10n FR/AR ajoutées pour "Comprendre ce nom"
- `flutter gen-l10n` : OK, `ar` conserve 76 messages non traduits
- `flutter analyze` : OK, aucune issue
- `flutter test` : OK, 89 tests passent

---

## 18. Interdits Pour Les Premiers Sprints

- pas de backend
- pas de social
- pas d'IA
- pas d'AR/3D
- pas de quiz Husna
- pas de 25 prophètes
- pas d'Arkān al-Islām / al-Īmān
- pas de gamification du dhikr ou de la ṣalawāt
- pas de contenu essentiel verrouillé
- pas de modification massive de `names.json`
- pas de refonte totale de navigation en Sprint 0 ou Sprint 1

---

## 19. Stratégie De PR

Branche de travail unique recommandée :

```text
feat/v2-journey-restructure
```

PR cible :

```text
feat/v2-journey-restructure -> main
```

Le merge vers `main` ne doit arriver qu'une fois le périmètre v2.0 validé.

PR 1 — Sécurisation tests

- tests `HiveSource`
- tests `NamesRepository`
- tests `QuizGenerator`
- aucun changement UI

PR 2 — Journey data foundation

- assets journey
- modèles
- sources
- repository
- providers
- tests

PR 3 — Name Experience MVP

- route `/name/:number/experience`
- écran MVP
- lien depuis `DetailScreen` ou Home en CTA secondaire

PR 4 — Home Daily Ritual

- refonte Home
- action du jour
- continuer voyage

PR 5 — Journey MVP UI

- `/journey`
- détail constellation
- navigation vers noms vivants

PR 6 — Tafakkur 2.0 + progression

- nouveau flow
- `markNameMeditated`
- nouveaux champs `UserState`

---

## 20. Prompt Pour Gemini Flash — Sprint 0

```text
Tu es développeur Flutter junior sur Sirah Hub. Codex est lead dev/architecte.

Contexte :
- les versions v1.x doivent être préservées ;
- main est la base stable ;
- le chantier cible est Sirah Hub v2.0 ;
- tu travailles sur la branche feat/v2-journey-restructure.

Sprint 0 : sécurisation avant refonte v2.0.

Objectif :
- ne pas changer l'UI
- ne pas changer la navigation
- ajouter des tests de sécurité sur le socle existant

Contraintes :
- ne modifie pas assets/data/names.json
- ne modifie pas lib/l10n/*.dart à la main
- garde SettingsNotifier comme seul écrivain Hive
- n'introduis pas de nouveau package sans validation

Tâches :
1. Inspecte les tests existants.
2. Ajoute des tests unitaires pour NamesRepository :
   - getAll retourne 201 noms via données testées si possible
   - getByNumber retourne le bon nom
   - search trouve par translittération et commentaire
3. Ajoute des tests pour QuizGenerator :
   - generateQcm retourne 5 questions
   - chaque question a 4 choix
   - la bonne réponse est incluse
   - pas de doublons dans les choix
4. Propose une stratégie de test HiveSource. Si HiveSource est difficile à tester tel quel, explique pourquoi et propose une petite extraction testable sans l'implémenter massivement.

Validation obligatoire :
- dart format .
- flutter analyze
- flutter test

Livrable :
- diff minimal
- résumé des tests ajoutés
- aucune refonte UI
```

---

## 21. Prompt Pour Gemini Flash — Sprint 1

```text
Tu es développeur Flutter junior sur Sirah Hub. Codex est lead dev/architecte.

Contexte :
- les versions v1.x doivent rester intactes ;
- tu travailles pour la future v2.0 ;
- ne supprime aucune feature existante ;
- branche de travail : feat/v2-journey-restructure.

Sprint 1 : couche Journey data pour v2.0.

Objectif :
Créer la fondation data de features/journey sans refonte UI massive.

Créer :
- assets/data/name_constellations.json
- assets/data/name_experiences.json
- assets/data/name_actions.json
- lib/features/journey/data/models/
- lib/features/journey/data/sources/
- lib/features/journey/data/repositories/journey_repository.dart
- lib/core/providers/journey_providers.dart

Contraintes :
- ne modifie pas assets/data/names.json
- utilise Freezed/json_serializable si cohérent avec les modèles existants
- après Freezed, lance build_runner
- ne touche pas à HomeScreen
- ne change pas la tab bar
- ne crée pas de carte stellaire animée

Repository attendu :
- charge constellations, expériences, actions
- permet getConstellations()
- permet getConstellationById(id)
- permet getExperienceForName(number)
- permet getActionsForTheme(theme)
- permet getDailyActionForName(number, date) de façon déterministe
- valide ou expose les incohérences minimales sans crash brutal

Tests attendus :
- constellations chargées
- nameNumbers valides par rapport à un set de noms fourni en test
- practiceTheme existe dans actions
- fallback action general

Validation obligatoire :
- dart run build_runner build --delete-conflicting-outputs si Freezed ajouté
- flutter gen-l10n si clés ajoutées
- dart format .
- flutter analyze
- flutter test
```

---

## 22. Grille De Revue Codex

À chaque livraison Gemini, vérifier :

- Le diff est-il limité au sprint ?
- Les fichiers générés sont-ils cohérents ?
- `flutter analyze` passe-t-il ?
- `flutter test` passe-t-il ?
- Le routing existant est-il intact ?
- `SettingsNotifier` reste-t-il seul écrivain Hive ?
- Aucune string UI en dur ?
- Aucun contenu religieux généré librement ?
- Aucun ajout de gamification ?
- Aucun changement massif de `names.json` ?
- Les tests couvrent-ils les nouveaux invariants ?
- Les fallbacks sont-ils sobres et non silencieusement cassés ?
