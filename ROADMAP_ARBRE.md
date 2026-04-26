# ROADMAP_ARBRE.md — Plan d'implémentation Module Arbre

> Roadmap séquentielle pour le module Arbre généalogique avec **Claude Code**.
> Pré-requis : V1 des 201 noms terminée et stable.
> **Avant chaque phase**, lancez : *« Lis CLAUDE.md, SPEC_ARBRE.md et DESIGN_SYSTEM.md. »*

---

## Phase A0 — Data layer généalogie (0.5 jour)

### Objectif
Charger les données généalogiques et exposer un repository typé.

### Prompt Claude Code
```
Lis SPEC_ARBRE.md en entier. Implémente la couche data pour l'arbre généalogique :

1. Crée assets/data/genealogy.json à partir des données fournies dans SPEC_ARBRE.md §2
   (prophet + paternalAscendants + maternalLine + paternalUncles + wives + children +
   grandchildren + cousins + paternalAscendantsTraditional = 67 personnes)
2. Crée lib/features/genealogy/data/models/family_member.dart avec freezed :
   - Class FamilyMember avec tous les champs de SPEC_ARBRE.md §2
   - Enum FamilyRole
   - fromJson / toJson générés
3. Crée lib/features/genealogy/data/repositories/genealogy_repository.dart :
   - Charge assets/data/genealogy.json au premier accès, cache en mémoire
   - Méthodes : getAll(), getProphet(), getById(id), getByRole(role),
     getChildren(motherId?), getPath(fromId, toId)
   - getPath : BFS sur le graphe de liens familiaux
4. Expose via un Provider Riverpod
5. Tests unitaires : 66 personnes chargées, getById("khadija") fonctionne,
   getPath("hamza", "muhammad") retourne le bon chemin

Ne crée aucun écran. Juste data + tests.
```

### Critères de sortie
- `flutter test` passe
- 66 personnes chargées, repository accessible

---

## Phase A1 — Navigation & coquille arbre (0.5 jour)

### Objectif
Ajouter le 4ème onglet et la coquille de l'écran arbre.

### Prompt Claude Code
```
Mets à jour la navigation pour inclure l'arbre généalogique :

1. Ajoute un 4ème onglet "Arbre" dans la tab bar (entre Découvrir et Profil)
   Icône : arbre ou réseau (Feather Icons)
2. Routes :
   - /tree → écran principal arbre
   - /tree/person/:id → fiche détail personne (push)
3. Écran principal tree_screen.dart :
   - Header avec titre "Arbre" + sélecteur de mode (3 boutons icônes :
     constellation / rivière / radiale)
   - Corps : placeholder pour chaque mode (Center(Text) pour l'instant)
   - Le mode sélectionné est persisté dans UserState.preferredTreeView (Hive)
4. AnimatedSwitcher entre les modes (fade 200ms)

Critère : je peux naviguer vers l'onglet Arbre, switcher entre les 3 modes
(placeholders), le choix persiste au redémarrage.
```

---

## Phase A2 — Mode D : Carte radiale (2 jours)

### Objectif
Implémenter le premier mode de visualisation — la radiale avec filtres.

### Prompt Claude Code
```
Implémente le mode Carte radiale selon SPEC_ARBRE.md §4.3 :

1. Crée lib/features/genealogy/presentation/radial/radial_view.dart :
   - InteractiveViewer avec CustomPainter
   - Canvas centré, Prophète ﷺ au centre (cercle accent + aura)
   - 4 orbites concentriques en pointillés (opacité dégressive)
   - Chaque personne positionnée sur son orbite selon un angle pré-calculé
   - Labels : nom arabe + translittération sous chaque point

2. Crée radial_painter.dart (CustomPainter) :
   - Dessine les orbites, les points, les labels
   - Les positions doivent être calculées une seule fois et cachées
   - RepaintBoundary pour la performance

3. Crée radial_filters.dart :
   - Bandeau flottant en haut avec chips scrollables horizontalement
   - Filtres : Tous | Épouses & enfants | Ascendants | Oncles & tantes | Ahl al-Bayt
   - State via Riverpod StateProvider<GenealogyFilter>
   - Animation : personnes filtrées = opacity 1, les autres = opacity 0.15 (transition 350ms)

4. Interactions :
   - Tap sur un point → chip flottant avec nom arabe + translit + "Voir la fiche →"
   - Hit testing : calcul distance euclidienne, seuil 20px
   - Double-tap recentre la vue
   - Bouton recentrer coin bas-droit

5. Couleurs par rôle selon DESIGN_SYSTEM.md :
   - Prophète : accent + glow
   - Épouses : accent2
   - Enfants/petits-enfants : accent
   - Oncles : muted
   - Ascendants : ink

Critère : la vue radiale affiche les 66 personnes, les filtres fonctionnent,
tap ouvre un chip, "Voir la fiche" ouvre la fiche détail (vide à ce stade).
```

---

## Phase A3 — Fiche détail personne (1 jour)

### Objectif
Écran partagé de détail pour toute personne de l'arbre.

### Prompt Claude Code
```
Implémente la fiche détail personne selon SPEC_ARBRE.md §5 :

1. Route /tree/person/:id
2. Structure scrollable :
   - Nom arabe très grand, centré
   - Translittération italique
   - Kunya + laqab en overline (si présents)
   - Section "Lien avec le Prophète ﷺ" :
     - Rôle en clair
     - PathChip : visualisation du chemin de parenté via getPath()
       (ex: "Ḥamza → ʿAbd al-Muṭṭalib → ʿAbd Allāh → Muḥammad ﷺ")
   - Section "Repères" : naissance, décès
   - Section "Récit" : bio
   - Section "Voir aussi" : liens vers personnes liées, tap → push même route
3. Actions header :
   - Favori (cœur) → toggle UserState.favoriteMembers
   - Partage → image générée (même mécanisme que 201 noms)
4. Le fait d'ouvrir une fiche marque viewedMembers.add(id)

Style et typo : identique aux fiches des 201 noms (DESIGN_SYSTEM.md).

Critère : depuis la radiale, tap → chip → "Voir la fiche" ouvre une fiche
complète et belle. Les liens "Voir aussi" fonctionnent en chaîne.
```

---

## Phase A4 — Mode B : Constellation (1.5 jour)

### Objectif
Deuxième mode de visualisation.

### Prompt Claude Code
```
Implémente le mode Constellation selon SPEC_ARBRE.md §4.1 :

1. Crée constellation_view.dart + constellation_painter.dart
2. Layout pré-calculé :
   - Le Prophète ﷺ au centre du canvas
   - Ascendants en haut, descendants en bas
   - Oncles à gauche, épouses à droite
   - Positions stables (calculées une fois, cachées)
3. Étoiles :
   - Taille variable : Prophète r=12, parents/Khadīja/Fāṭima r=5, autres r=3, lointains r=2
   - Couleur par rôle (comme radiale)
   - Prophète ﷺ : aura radiale (cercle semi-transparent r=20)
4. Liens (lignes fines) :
   - Parent→enfant, époux→épouse, oncle→neveu
   - Opacité variable : plus forte près du Prophète ﷺ
5. Interactions :
   - InteractiveViewer (pan/zoom)
   - Tap sur étoile → zoom contextuel :
     - Étoile tapée grossit
     - Étoiles connectées s'approchent (animation 350ms easeOutCubic)
     - Non connectées : opacity 0.15
     - Chip flottant avec nom + "Voir la fiche →"
   - Tap ailleurs = reset
   - Tap long sur étoile → mode "tracer le chemin" :
     - 1ère étoile sélectionnée (highlight)
     - Tap sur 2ème étoile → le chemin s'illumine (getPath)
     - Tap ailleurs = annuler
6. Recherche flottante (pill en haut) :
   - Recherche par nom → étoile correspondante pulse + canvas recentré
7. Légende en bas-gauche (petit encart semi-transparent) :
   - ● Prophète ﷺ, ● Ascendants, ● Épouses, etc.
8. Bouton recentrer coin bas-droit

Critère : la constellation est belle, les interactions sont fluides,
tracer un chemin fonctionne.
```

---

## Phase A5 — Mode C : Rivière de lumière (1 jour)

### Objectif
Troisième et dernier mode de visualisation.

### Prompt Claude Code
```
Implémente le mode Rivière de lumière selon SPEC_ARBRE.md §4.2 :

1. Crée river_view.dart + river_node.dart
2. Pas de CustomPainter — widgets Flutter dans un SingleChildScrollView
3. Ligne lumineuse centrale :
   - Container positionné en absolute, largeur 2px, background gradient
     (transparent → accent → transparent)
   - Glow diffus : même chose en largeur 14px, opacity 0.15, blur
4. Sélecteur de courant (haut) :
   - SegmentedControl : "Lignée paternelle" / "Lignée maternelle" / "Descendants"
   - State via Riverpod StateProvider<RiverStream>
   - Change la liste de personnes affichées
5. Cartes alternées gauche/droite :
   - Justification flex-start / flex-end alternée
   - Carte : background card, border, border-radius 14
   - Rôle en overline, nom arabe, translittération
   - Le Prophète ﷺ : carte plus grande, centrée, glow accent
6. Affluents aux embranchements :
   - À ʿAbd al-Muṭṭalib : petites branches latérales montrant les oncles
   - Mini-cartes (juste nom arabe + translit, taille réduite)
7. Animation d'entrée :
   - flutter_animate : fade + slide up au scroll
   - VisibilityDetector pour déclencher
8. Tap sur une carte → push /tree/person/:id

Critère : la rivière est fluide au scroll, les 3 courants fonctionnent,
les affluents sont visibles, les animations sont subtiles et performantes.
```

---

## Phase A6 — Passerelles & polish (1 jour)

### Objectif
Relier l'arbre au module 201 noms + finitions.

### Prompt Claude Code
```
Finitions du module arbre :

1. Passerelle noms → arbre :
   - Dans la fiche détail d'un nom de catégorie "nobility" (origineNoble),
     ajouter un lien discret en bas : "Explorer la lignée dans l'arbre →"
   - Tap → /tree (recentré sur le Prophète ﷺ)

2. Passerelle arbre → noms :
   - Dans la fiche personne, section optionnelle "Noms du Prophète ﷺ liés"
   - Recherche textuelle dans les champs commentary des 201 noms
     pour trouver les mentions du nom de cette personne
   - Afficher les noms trouvés comme chips, tap → /name/:number

3. Vue liste accessible :
   - Bouton "Vue liste" dans le header de l'écran arbre
   - ListView groupée par rôle (sections : Ascendants, Oncles, Épouses, etc.)
   - Même style que la liste des 201 noms
   - Pour l'accessibilité (Semantics, VoiceOver, TalkBack)

4. Polish visuel :
   - Tester les 3 modes × 3 thèmes = 9 combinaisons
   - Vérifier les labels arabes (shaping, diacritiques)
   - Performance : 60fps sur constellation et radiale (RepaintBoundary)
   - Text scale 2.0 : rien ne casse
   - Tester la recherche (constellation) avec des noms arabes

5. Partage depuis fiche personne :
   - Template image 1080×1920
   - Nom arabe + translittération + rôle + bio courte + mention app

Critère : les passerelles fonctionnent dans les deux sens, la vue liste
est accessible, les 9 combinaisons thème×mode sont visuellement correctes.
```

---

## Récapitulatif

| Phase | Durée | Contenu |
|---|---|---|
| A0. Data layer | 0.5j | Modèle, JSON, repository, tests |
| A1. Navigation | 0.5j | 4ème onglet, coquille, sélecteur de mode |
| A2. Radiale (D) | 2j | CustomPainter, filtres, interactions |
| A3. Fiche détail | 1j | Écran partagé, chemin, voir aussi |
| A4. Constellation (B) | 1.5j | CustomPainter, zoom contextuel, tracer chemin |
| A5. Rivière (C) | 1j | Scroll, courants, affluents, animations |
| A6. Passerelles & polish | 1j | Liens croisés, accessibilité, tests visuels |
| **Total** | **~7.5 jours** |

### Ordre recommandé
**D (radiale) en premier** — c'est la plus utile rapidement et elle force à construire
toute l'infra (data, fiche détail, navigation). B et C s'appuient dessus.

---

## Règles d'or

1. **Ne touche pas au module names/** — les passerelles sont des liens go_router, pas des imports.
2. **Un mode à la fois.** Valide visuellement avant de passer au suivant.
3. **Teste dans les 3 thèmes** après chaque phase.
4. **Le JSON genealogy.json est la source de vérité** — ne pas hardcoder de données dans les painters.
5. **Commit après chaque phase validée.**
