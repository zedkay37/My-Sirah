# ROADMAP.md — Plan d'implémentation V1

> Roadmap séquentielle pour développer la V1 avec **Claude Code** sur Flutter.
> Chaque phase contient un **prompt prêt à copier**.
> **Avant chaque phase**, lancez d'abord : *« Lis CLAUDE.md, SPEC.md et DESIGN_SYSTEM.md. »*

---

## Phase 0 — Setup du projet (30 min)

### Objectif
Créer le projet Flutter et poser les fondations (dépendances, structure, fichiers de config).

### Prompt Claude Code
```
Crée un projet Flutter nommé "asma_nabi" en suivant strictement CLAUDE.md :

1. flutter create avec les paramètres bundle iOS/Android indiqués
2. Installe les dépendances : flutter_riverpod, go_router, hive_ce, hive_ce_flutter, freezed_annotation, json_annotation, google_fonts, flutter_animate, flutter_local_notifications, screenshot, share_plus, timezone
3. Dépendances dev : build_runner, freezed, json_serializable, hive_generator
4. Crée l'arborescence lib/ selon SPEC.md §9
5. Configure analysis_options.yaml strict (very_good_analysis ou équivalent)
6. Setup le main.dart minimal avec ProviderScope et MaterialApp.router
7. Ajoute assets/ au pubspec (data/names.json + fonts/ si besoin local)
8. Copie le names.json fourni dans assets/data/

Ne code aucun écran à ce stade. Objectif : flutter run doit afficher un écran blanc sans erreur.
```

### Critères de sortie
- `flutter run` fonctionne iOS + Android
- Structure de dossiers conforme
- Aucune erreur d'analyse

---

## Phase 1 — Theme system & tokens (1 jour)

### Objectif
Implémenter les 3 thèmes selon DESIGN_SYSTEM.md, switchables via un provider.

### Prompt Claude Code
```
Implémente le système de thèmes selon DESIGN_SYSTEM.md :

1. Crée lib/core/theme/app_theme.dart avec une classe AppTheme contenant tous les tokens (colors, fonts, spacing, radius)
2. Crée 3 thèmes concrets : LightTheme, DarkTheme, FeminineTheme dans lib/core/theme/themes/
3. Chaque thème expose un ThemeData Flutter complet (light/dark brightness approprié)
4. Intègre les polices via google_fonts :
   - Amiri Quran pour l'arabe (champ fonts.arabic)
   - Crimson Text pour le thème clair (serif)
   - Playfair Display pour le thème féminin
   - Inter pour sans-serif commun
5. Crée un ThemeProvider (Riverpod) qui :
   - Expose le thème actif
   - Persiste le choix dans Hive (box "settings")
   - Lit le thème au démarrage
6. Crée un widget démo lib/demo/theme_preview.dart qui affiche les 3 thèmes côte à côte avec un nom du Prophète en exemple.
7. Branche ce demo en route / temporairement pour vérification visuelle.

Critère : je dois pouvoir switcher entre les 3 thèmes et voir l'exemple changer correctement.
```

### Critères de sortie
- 3 thèmes visibles, distincts, lisibles
- Switch persiste au redémarrage

---

## Phase 2 — Data layer (1/2 journée)

### Objectif
Charger les 201 noms depuis le JSON et exposer un repository typé.

### Prompt Claude Code
```
Implémente la couche data pour les noms du Prophète :

1. Crée lib/features/names/data/models/prophet_name.dart avec freezed :
   - Class ProphetName avec tous les champs de SPEC.md §3
   - Enum Category avec les 11 catégories (SPEC.md §3)
   - fromJson / toJson générés
   - Mapping string -> Category depuis names.json
2. Crée lib/features/names/data/repositories/names_repository.dart :
   - Charge assets/data/names.json au premier accès, cache en mémoire
   - Méthodes : getAll(), getByNumber(int), getByCategory(Category), search(String query)
   - search : sur arabic, transliteration, etymology, explanation (case-insensitive, diacritiques tolérés)
3. Expose le repository via un Provider Riverpod
4. Écris des tests unitaires dans test/names_repository_test.dart :
   - Vérifie que 201 noms sont chargés
   - Vérifie la répartition des catégories (§3 SPEC)
   - Vérifie la recherche sur "Muhammad", "محمد", "louange"

Critère : flutter test passe, 201 noms chargés correctement.
```

### Critères de sortie
- Tests verts
- Repository accessible via provider

---

## Phase 3 — Onboarding (1 jour)

### Objectif
3 écrans d'onboarding selon SPEC.md §4.1.

### Prompt Claude Code
```
Implémente l'onboarding selon SPEC.md §4.1 :

1. Feature lib/features/onboarding/ :
   - Écran 1 (welcome) : bienvenue + calligraphie filigrane
   - Écran 2 (theme_pick) : 3 cartes preview des thèmes, sélection persistée via ThemeProvider
   - Écran 3 (notif_setup) : time picker + permission flutter_local_notifications + toggle "Plus tard"
2. Use PageView pour la navigation horizontale entre les 3 écrans
3. Indicateur de progression (3 points) en bas
4. À la fin : écriture de UserState.onboardingCompletedAt, UserState.dailyNotifHour
5. Router logic : si onboardingCompletedAt == null → /onboarding, sinon → /home
6. Setup flutter_local_notifications :
   - Initialisation dans main.dart
   - Programmation d'une notif quotidienne répétée à l'heure choisie
   - Canal "daily_name" sur Android
   - Timezone (utiliser package timezone)

Critère : un cold start fait apparaître l'onboarding. Relancer après l'avoir terminé va directement à l'accueil (vide à ce stade).
```

### Critères de sortie
- 3 écrans fluides, skippables
- Permission notif fonctionne iOS + Android
- Thème sélectionné persiste

---

## Phase 4 — Navigation & coquille (1/2 journée)

### Objectif
Tab bar 3 onglets, routing complet.

### Prompt Claude Code
```
Mets en place la coquille de navigation :

1. go_router avec ShellRoute pour la tab bar
2. 3 onglets : Home, Discover, Profile (icônes selon DESIGN_SYSTEM.md)
3. Routes nommées :
   - /home
   - /discover (qui contient 2 sous-onglets internes : liste + quiz)
   - /profile
   - /name/:number (fiche détail, peut être push depuis n'importe où)
   - /settings (depuis profile)
4. Écrans placeholder pour chaque route (juste un Center(Text))
5. Gestion de l'état de navigation (onglet actif) via StatefulShellRoute de go_router

Critère : je peux naviguer entre les 3 onglets, et /name/47 ouvre un écran vide mais routé correctement.
```

---

## Phase 5 — Accueil (1 jour)

### Objectif
Écran Accueil selon SPEC.md §4.2.

### Prompt Claude Code
```
Implémente l'écran Accueil selon SPEC.md §4.2 :

1. Header : salutation + date hégirienne + grégorienne
   - Utiliser le package hijri pour la date hégirienne
2. Nom du jour :
   - Calcul déterministe selon SPEC.md §5 (daysSinceEpoch % 201)
   - Grand bloc central avec nom arabe en Amiri Quran 96pt
   - Translittération italique
   - Pastille catégorie (couleur selon theme.colors.categoryHues)
   - 3 lignes d'étymologie avec fade bas
   - CTA "Découvrir ce nom" → push /name/:number
3. Carrousel catégories :
   - Scroll horizontal, 11 cartes
   - Chaque carte : nom catégorie, "X/Y appris", couleur dédiée
   - Tap → push /discover avec filtre catégorie pré-sélectionné (via query param)
4. Animations d'entrée légères avec flutter_animate (fade + slide up)

Critère : l'écran est complet, le nom du jour s'affiche, les catégories sont scrollables, le tap CTA ouvre la fiche détail vide.
```

---

## Phase 6 — Fiche détail + swipe (1.5 jour)

### Objectif
Fiche détail swipeable selon SPEC.md §4.5.

### Prompt Claude Code
```
Implémente la fiche détail selon SPEC.md §4.5 :

1. Route /name/:number avec PageView horizontal (initialPage = number-1)
2. Chaque page :
   - Header sticky : retour, titre "#047", actions (favori, partage)
   - Flèches précédent/suivant semi-transparentes sur les côtés
   - Contenu scrollable vertical avec sections (numéro+pastille, nom arabe XL, translit, étymologie, explication, références, sources)
   - Typo et couleurs selon DESIGN_SYSTEM.md
3. Actions :
   - Cœur → toggle UserState.favorites (provider Riverpod + Hive)
   - Partage → génère une image via screenshot package + share_plus
     - Template 1080x1920, fond thème, nom arabe énorme, mention app
4. Règle métier "learned" (SPEC.md §5) :
   - Déclenche learned.add(number) après 8s de consultation
   - Utilise un Timer + visibility detector
5. URL sync : quand on swipe, GoRouter.of(context).go('/name/$newNumber') (remplacement, pas push)

Critère : swipe fluide entre les 201 noms, favori persiste, partage génère une image correcte.
```

---

## Phase 7 — Liste + recherche + filtres (1 jour)

### Objectif
Vue "Découvrir" onglet liste, SPEC.md §4.3.

### Prompt Claude Code
```
Implémente la liste des 201 noms selon SPEC.md §4.3 :

1. Sous-onglet "Tous les noms" de /discover
2. Barre de recherche sticky :
   - Provider Riverpod StateProvider<String> pour la query
   - Debounce 200ms
   - Icône clear quand non vide
3. Chips catégories sticky :
   - Scroll horizontal
   - Chip "Tous" + 11 catégories
   - Sélection unique via StateProvider<Category?>
4. ListView :
   - Chaque ligne : numéro, arabic, translit, pastille catégorie, icône cœur si favori
   - Tap → push /name/:number
   - Optimiser avec ListView.builder
5. Combinaison query + catégorie via un Provider combiné
6. État vide : illustration + message si aucun résultat

Critère : recherche "Muhammad" remonte le nom, filtre par catégorie fonctionne, combinaison fonctionne.
```

---

## Phase 8 — Quiz (2 jours)

### Objectif
Module Quiz complet selon SPEC.md §4.4.

### Prompt Claude Code
```
Implémente le module Quiz selon SPEC.md §4.4 :

1. Sous-onglet "Quiz" de /discover avec écran d'entrée (choix QCM ou Flashcards)
2. Générateur de session (lib/features/quiz/data/quiz_generator.dart) :
   - generateQCM() : 5 noms aléatoires + 3 distracteurs par question (même catégorie prioritaire)
   - generateFlashcards() : 5 noms aléatoires
   - Masquage du nom dans l'extrait d'explanation (regex sur arabic + translit)
3. État de session (StateNotifier) : questionIndex, answers, isComplete
4. Écran QCM :
   - 1 question à la fois
   - 4 boutons réponse
   - Tap → feedback vert/rouge 1.2s → next
   - Barre progression en haut
5. Écran Flashcards :
   - Carte centrale avec retournement 3D (TweenAnimationBuilder ou flip_card package)
   - Boutons bas "Je connais" / "À revoir"
   - Swipe horizontal pour suivant
6. Écran de fin :
   - Calligraphie décorative
   - Message motivateur contextuel selon score (SPEC.md §4.4)
   - Score discret en dessous
   - CTAs "Rejouer" / "Explorer les noms"
7. Règle learned : bonnes réponses QCM + "Je connais" flashcards → add to learned

Critère : je peux faire une session complète de chaque type, la progression "learned" augmente, le message de fin est contextuel.
```

---

## Phase 9 — Profil + constellation (2 jours)

### Objectif
Écran Profil avec visualisation constellation, SPEC.md §4.6.

### Prompt Claude Code
```
Implémente le Profil selon SPEC.md §4.6 :

1. Écran Profil :
   - Header (salutation + date + roue crantée)
   - Widget ConstellationView (CustomPainter)
   - Stat "X / 201 noms appris" en grand
   - Raccourcis "Mes favoris" et "Paramètres"

2. ConstellationView (CustomPainter) :
   - Canvas 1:1
   - 201 étoiles positionnées selon une spirale de Fibonacci ou coordonnées pré-calculées
   - Positions stables (seed déterministe basé sur le numéro)
   - Étoile learned : glow color=categoryHue, radius 3-5
   - Étoile viewed non learned : contour simple, radius 2
   - Étoile non découverte : point 1px opacity 0.3
   - Animation subtile de pulsation sur les learned (flutter_animate)
   - GestureDetector : hit-test sur chaque étoile → push /name/:number
   - Légende petite en bas : "● appris ○ vu · non découvert"

3. Écran Favoris (accès via raccourci) :
   - Liste filtrée UserState.favorites
   - Même design que liste principale
   - Retrait par swipe

4. Écran Paramètres :
   - Thème (3 cartes)
   - Heure notif (time picker + reprogrammation)
   - Taille texte (small/medium/large → facteur dans theme)
   - À propos (version, sources, crédits)
   - "Signaler une erreur" (launchUrl mailto)

Critère : constellation belle et interactive, tap sur étoile ouvre le bon nom, paramètres fonctionnent.
```

---

## Phase 10 — Polish & QA (1.5 jour)

### Objectif
Finitions, bugs, perfs.

### Prompt Claude Code
```
Polish et QA de la V1 :

1. Relis SPEC.md et DESIGN_SYSTEM.md, vérifie que TOUT est implémenté. Fais une checklist.
2. Teste manuellement sur simulateur iOS + émulateur Android :
   - Onboarding complet
   - Chaque écran dans les 3 thèmes
   - Notifications (planifie à now+2min, attends)
   - Partage image
   - Recherche (cas bords : diacritiques, vide, aucun résultat)
   - Persistance (kill l'app, relance, tout doit être là)
3. Performance :
   - Profile la liste des 201 (doit être 60fps au scroll)
   - Profile la constellation (60fps)
   - Taille du bundle release (< 30 Mo visé)
4. Accessibilité :
   - Text scale 2.0 : rien ne doit casser
   - Sémantique sur les boutons
5. Erreurs typographiques arabes :
   - Vérifie visuellement que les noms s'affichent correctement (shaping, diacritiques)
6. Documente les bugs connus dans un BUGS.md
7. Prépare un CHANGELOG.md V1.0.0
```

---

## Phase 11 — Build & release (1 jour)

### Prompt Claude Code
```
Prépare les builds release :

1. iOS :
   - Configure Info.plist (NSUserNotificationsUsageDescription, etc.)
   - flutter build ipa --release
   - Vérifier que l'icône et le splash screen sont en place
2. Android :
   - Signature keystore
   - flutter build appbundle --release
3. Crée les assets stores :
   - Icône 1024x1024
   - Screenshots 6.5" + 5.5" iOS, plusieurs tailles Android
   - Texte de description en FR (courte + longue)
   - Politique de confidentialité minimale (pas de tracking, 100% local)
4. Documente le processus de release dans RELEASE.md
```

---

## Récapitulatif temps estimé

| Phase | Durée |
|---|---|
| 0. Setup | 0.5j |
| 1. Thèmes | 1j |
| 2. Data | 0.5j |
| 3. Onboarding | 1j |
| 4. Navigation | 0.5j |
| 5. Accueil | 1j |
| 6. Fiche détail | 1.5j |
| 7. Liste + recherche | 1j |
| 8. Quiz | 2j |
| 9. Profil + constellation | 2j |
| 10. Polish & QA | 1.5j |
| 11. Release | 1j |
| **Total** | **~13.5 jours** |

En vibe-coding avec Claude Code, comptez **3 à 4 semaines calendaires** en temps partiel.

---

## Règles d'or en vibe-coding

1. **Une phase à la fois.** Ne lancez pas la phase N+1 avant d'avoir validé la N.
2. **Commit à chaque phase validée.** Git commit avec message explicite.
3. **Testez manuellement** après chaque prompt gros. Ne faites pas confiance aveuglément.
4. **Si Claude Code s'égare** : stop, rappelez-lui SPEC.md, reformulez en 1-2 phrases claires.
5. **Gardez SPEC.md à jour.** Si une décision évolue, modifiez le SPEC avant de coder.
