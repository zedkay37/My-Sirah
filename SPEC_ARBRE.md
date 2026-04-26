# SPEC_ARBRE.md — Module Arbre généalogique V1.1

> Module additionnel pour **Sirah App** — exploration interactive de la lignée
> prophétique (Nasab al-Nabī ﷺ) avec 3 modes de visualisation.

---

## 1. Vision

### Mission du module
Permettre à l'utilisateur d'**explorer visuellement** la famille du Prophète ﷺ —
ascendants, épouses, enfants, petits-enfants, oncles — et de **comprendre les liens**
qui unissent ces personnes, à travers 3 métaphores visuelles complémentaires.

### Positionnement dans l'app
- **Onglet dédié** "Arbre" dans la tab bar (4ᵉ onglet, entre Découvrir et Profil)
- Indépendant du module 201 noms, mais **relié** par des passerelles contextuelles
- Même data layer que le reste : 100% offline, persisté Hive, state Riverpod

### Ton
Même ton que le module noms : spirituel, contemplatif, respectueux.
La généalogie n'est pas un arbre sec — c'est une histoire de famille sacrée.

---

## 2. Données

### Source
Fichier `assets/data/genealogy.json` — dérivé de `genealogy-data.js` fourni.

### Modèle FamilyMember (freezed)

```dart
@freezed
class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required String id,               // "muhammad", "khadija", "hamza"
    required String arabic,            // حَمْزَة
    required String transliteration,   // Ḥamza ibn ʿAbd al-Muṭṭalib
    String? kunya,                     // Abū ʿUmāra
    @Default([]) List<String> laqab,   // ["Asad Allāh", "Sayyid al-Shuhadāʾ"]
    required FamilyRole role,          // enum
    String? birth,
    String? death,
    String? bio,                       // texte biographique
    int? generation,                   // 1 = père, 2 = grand-père, ...
    int? marriageOrder,                // pour les épouses
    String? parentId,                  // id du père (graphe BFS)
    String? motherId,                  // id de la mère (pour les enfants)
    String? spouseOf,                  // id du conjoint (épouses → "muhammad", ʿAlī → "fatima")
    @Default([]) List<String> parentIds, // pour petits-enfants (père + mère)
    @Default(false) bool isBoundary,   // ʿAdnān = limite du consensus
    @Default(false) bool isTraditional, // au-delà de ʿAdnān
    String? variant,                   // note académique si divergence
  }) = _FamilyMember;

  factory FamilyMember.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberFromJson(json);
}

enum FamilyRole {
  prophet,
  father,
  mother,
  paternalAscendant,
  maternalAscendant,
  uncle,
  aunt,
  wife,
  child,
  grandchild,
  cousin,              // ʿAlī (cousin + gendre via spouseOf)
  traditionalAncestor, // Ismāʿīl, Ibrāhīm, Ādam
}
```

### Structure du JSON

```json
{
  "prophet": { ... },
  "paternalAscendants": [ ... ],          // 21 personnes (→ ʿAdnān)
  "paternalAscendantsTraditional": [ ... ], // 3 (Ismāʿīl, Ibrāhīm, Ādam)
  "maternalLine": [ ... ],                // 4 personnes
  "paternalUncles": [ ... ],              // 13 (oncles + tantes)
  "wives": [ ... ],                       // 12 épouses (spouseOf: "muhammad")
  "children": [ ... ],                    // 7 enfants (parentId: "muhammad")
  "grandchildren": [ ... ],               // 5 petits-enfants (parentIds: [...])
  "cousins": [ ... ],                     // 1 (ʿAlī — role: cousin, spouseOf: "fatima")
}

// Champs graphe ajoutés dans tous les noeuds :
// parentId: String?   → id du père (permet BFS sur la lignée)
// spouseOf: String?   → id du conjoint (épouses + ʿAlī)
// Les lignées maternelle et paternelle convergent à Kilāb (generation 6)
```

**Total : ~66 personnes.**

### Repository

```dart
class GenealogyRepository {
  Future<List<FamilyMember>> getAll();
  FamilyMember getProphet();
  FamilyMember getById(String id);
  List<FamilyMember> getByRole(FamilyRole role);
  List<FamilyMember> getChildren({String? motherId});
  List<FamilyMember> getPath(String fromId, String toId); // chemin entre deux personnes
}
```

### État persisté (extension de UserState existant)

```dart
// Ajouter à UserState existant :
Set<String> viewedMembers;      // ids consultés
Set<String> favoriteMembers;    // ids favoris
String preferredTreeView;       // "constellation" | "river" | "radial"
```

---

## 3. Navigation

### Tab bar mise à jour (4 onglets)

```
Accueil  ·  Découvrir  ·  Arbre  ·  Profil
```

### Routes

```
/tree                          → écran principal arbre (vue par défaut ou dernière utilisée)
/tree/constellation            → mode constellation
/tree/river                    → mode rivière
/tree/radial                   → mode radiale
/tree/person/:id               → fiche détail personne (push, partagé par les 3 modes)
```

### Écran principal arbre

- Header : titre + sélecteur de mode (3 icônes ou SegmentedControl)
- Corps : le renderer actif (constellation, rivière ou radiale)
- Tab bar en bas
- Le mode choisi est persisté dans `preferredTreeView`

---

## 4. Les 3 modes de visualisation

### 4.1 Mode B — Constellation cosmique

**Métaphore :** la lignée prophétique comme une constellation d'étoiles reliées par des
traits lumineux. Le Prophète ﷺ est l'étoile centrale avec une aura.

**Rendu (CustomPainter) :**
- Canvas plein écran, fond radial subtil
- 66 étoiles positionnées selon un layout pré-calculé stable
- Taille des étoiles selon l'importance : Prophète ﷺ (r=12), parents/Fāṭima/Khadīja (r=5),
  autres (r=3), ascendants lointains (r=2)
- Liens (lignes fines) entre personnes liées, opacité variable selon proximité au Prophète ﷺ
- Code couleur par `FamilyRole` :
  - Prophète ﷺ : `accent` + glow
  - Ascendants : `ink`
  - Épouses : `accent2`
  - Enfants/petits-enfants : `accent`
  - Oncles/tantes : `muted`

**Interactions :**
- **Pan & zoom** (InteractiveViewer) sur le canvas
- **Tap sur une étoile** → zoom contextuel :
  - L'étoile tapée s'agrandit
  - Les étoiles connectées s'approchent visuellement (animation 350ms)
  - Les étoiles non connectées s'estompent (opacity 0.15)
  - Un chip flottant apparaît avec nom arabe + translittération + "Voir la fiche →"
- **"Tracer le chemin"** : tap long sur une étoile → mode sélection →
  tap sur une 2ème étoile → le chemin entre les deux s'illumine
  (utilise `getPath()` du repository)
- **Bouton recentrer** (coin bas-droit) : reset zoom + position

**Pas de filtres** — la constellation montre la toile entière.

**Recherche flottante** en haut : pill semi-transparente, recherche par nom.
Résultat : l'étoile correspondante pulse et le canvas se recentre dessus.

---

### 4.2 Mode C — Rivière de lumière (Nūr)

**Métaphore :** la lumière prophétique (Nūr) qui se transmet de génération en génération,
comme un fleuve lumineux vertical. Lecture contemplative.

**Rendu :**
- Scroll vertical naturel (pas de pan/zoom, juste un `SingleChildScrollView`)
- Ligne lumineuse centrale : trait fin (2px) avec glow diffus (14px, blur),
  gradient vertical transparent → accent → transparent
- Cartes de personnes alternées gauche/droite le long de la rivière
- Le Prophète ﷺ au centre avec une carte plus grande, glow accent
- Aux embranchements (ex: ʿAbd al-Muṭṭalib), de petits affluents latéraux
  montrent les oncles/tantes comme des bras secondaires de la rivière

**Sélecteur de courant (haut de l'écran) :**
- 3 options : "Lignée paternelle" / "Lignée maternelle" / "Descendants"
- Change le trajet de la rivière :
  - **Paternelle** : ʿAdnān → … → ʿAbd al-Muṭṭalib → ʿAbd Allāh → Prophète ﷺ
    (avec affluents pour les oncles à chaque embranchement)
  - **Maternelle** : Zuhra → Wahb → Āmina → Prophète ﷺ
  - **Descendants** : Prophète ﷺ → épouses → enfants → petits-enfants
    (la rivière se ramifie par mère)

**Interactions :**
- **Scroll naturel** — c'est un parcours guidé, pas un graphe libre
- **Tap sur une carte** → push vers `/tree/person/:id`
- **Les affluents** sont des branches courtes (40px) avec des mini-cartes
  (juste nom arabe + translittération). Tap → même fiche détail.
- Animation d'entrée : les cartes apparaissent en fade+slide au scroll
  (flutter_animate, déclenché par `VisibilityDetector`)

**Pas de filtres, pas de zoom** — la force est la linéarité.

---

### 4.3 Mode D — Carte radiale (orbites)

**Métaphore :** le Prophète ﷺ au centre comme un soleil, les autres rayonnent en
cercles concentriques selon leur proximité familiale.

**Rendu (CustomPainter) :**
- Canvas centré, fond neutre
- 4 orbites concentriques (cercles en pointillés, opacité dégressive) :
  - **Orbite 1 — Famille proche** (r≈70) : Khadīja, ʿĀʾisha, Fāṭima, ʿAlī, enfants
  - **Orbite 2 — Banū Hāshim** (r≈130) : oncles, tantes, ʿAbd Allāh, Āmina, ʿAbd al-Muṭṭalib
  - **Orbite 3 — Quraysh** (r≈190) : Hāshim, Quṣayy, Fihr, Kināna
  - **Orbite 4 — Ascendants lointains** (r≈240) : Maʿadd, ʿAdnān, (Ismāʿīl, Ibrāhīm, Ādam)
- Le Prophète ﷺ au centre : cercle plein accent, aura douce
- Chaque personne : point + label arabe + translittération

**Filtres interactifs (bandeau flottant en haut) :**
- Chips scrollables horizontalement :
  - **Tous** (par défaut)
  - **Épouses & enfants** : n'affiche que orbites 1 (épouses + enfants + petits-enfants)
  - **Ascendants** : n'affiche que la chaîne paternelle + maternelle
  - **Oncles & tantes** : n'affiche que les enfants de ʿAbd al-Muṭṭalib
  - **Ahl al-Bayt** : Fāṭima, ʿAlī, Ḥasan, Ḥusayn, enfants
- Animation : les personnes filtrées restent lumineuses, les autres s'estompent
  (opacity transition 350ms), les orbites non concernées s'estompent aussi

**Interactions :**
- **Tap sur un point** → chip flottant avec infos + "Voir la fiche →"
- **Pan & zoom** (InteractiveViewer)
- **Double-tap sur une orbite** → zoom sur ce cercle (les points s'espacent, labels plus lisibles)
- **Bouton recentrer** (coin bas-droit)

---

## 5. Fiche détail personne (partagée)

**Route :** `/tree/person/:id`

**Accès :** tap depuis n'importe quel mode de visualisation.

**Structure :**
- Header fixe : retour + titre rôle (ex: "Oncle") + actions (favori, partage)
- Contenu scrollable vertical :
  1. **Nom arabe** (très grand, centré) — `arabic`
  2. Translittération (italique) — `transliteration`
  3. Kunya + laqab (petits, overline) — si présents
  4. Section **"Lien avec le Prophète ﷺ"** :
     - Rôle en clair
     - Chip "chemin" : visualisation du chemin de parenté
       (ex: "Ḥamza → ʿAbd al-Muṭṭalib → ʿAbd Allāh → Muḥammad ﷺ")
  5. Section **"Repères"** : naissance, décès, dates clés
  6. Section **"Récit"** : biographie (`bio`)
  7. Section **"Voir aussi"** : liens vers les personnes liées (père, mère, enfants…)
     Tap → push vers la fiche de cette personne

**Actions :**
- **Favori** (cœur) : toggle `favoriteMembers`
- **Partage** : image générée (même mécanisme que les 201 noms)
  Template : fond thème + nom arabe + translittération + rôle + mention app

**Pas de swipe horizontal** entre fiches (contrairement aux 201 noms) —
la navigation se fait par les liens "Voir aussi" ou en retournant à la vue arbre.

---

## 6. Passerelles avec le module 201 noms

### Depuis une fiche nom → arbre
- Si le nom appartient à la catégorie "Origine noble" (nobility, 14 noms),
  afficher un lien discret en bas de la fiche :
  *"Explorer la lignée dans l'arbre →"* → `/tree` (recentré sur le Prophète ﷺ)

### Depuis une fiche personne → noms
- En bas de la fiche personne, section optionnelle :
  *"Noms du Prophète ﷺ liés"* → liste de noms dont l'étymologie ou le commentaire
  mentionne cette personne (recherche textuelle dans `commentary`).
  Ex : fiche de Khadīja → noms liés à la pureté et la fidélité.

### Accueil — Personnage du jour (V1.2)
- Bloc optionnel sous le "Nom du jour" :
  *"Personnage du jour"* avec une personne différente chaque jour
  Calcul : `(daysSinceEpoch + 100) % 66` (décalé pour ne pas toujours
  montrer la même paire nom+personne)
- Pas en V1.1, à ajouter quand le module arbre est stabilisé

---

## 7. Performances

- **Constellation & Radiale** : CustomPainter avec `RepaintBoundary`.
  66 points + ~80 liens = léger. Pas de problème de performance attendu.
- **Rivière** : widgets Flutter classiques dans un `SingleChildScrollView`.
  ~20-30 cartes max par courant. Aucun souci.
- **Hit testing** (constellation & radiale) : utiliser `GestureDetector` sur
  le canvas + calcul de distance euclidienne au tap. Seuil : 20px autour
  de chaque point. Cache des positions dans un `List<Offset>`.
- **Transitions entre modes** : `AnimatedSwitcher` avec fade 200ms.

---

## 8. Accessibilité

- Chaque étoile/point a un `Semantics` label : "Ḥamza, oncle du Prophète ﷺ"
- La rivière est naturellement accessible (widgets Flutter standard)
- Constellation & Radiale : fournir un mode liste alternatif accessible
  (bouton "Vue liste" dans le header) → simple ListView groupée par rôle
- Contraste AA respecté sur les 3 thèmes pour les labels

---

## 9. Architecture technique

```
lib/features/
  genealogy/                          # ← NOUVEAU MODULE
    data/
      models/
        family_member.dart            # freezed model
      repositories/
        genealogy_repository.dart
      sources/
        genealogy_json_source.dart    # charge assets/data/genealogy.json
    presentation/
      tree_screen.dart                # écran principal avec sélecteur de mode
      constellation/
        constellation_view.dart       # CustomPainter + InteractiveViewer
        constellation_painter.dart
      river/
        river_view.dart               # ScrollView + cartes alternées
        river_node.dart               # widget carte individuelle
      radial/
        radial_view.dart              # CustomPainter + InteractiveViewer
        radial_painter.dart
        radial_filters.dart           # chips de filtre
      detail/
        person_detail_screen.dart     # fiche détail partagée
        path_chip.dart                # visualisation du chemin de parenté
      shared/
        person_card.dart              # carte personne réutilisable
        tree_search_bar.dart          # recherche flottante
        mode_selector.dart            # sélecteur constellation/rivière/radiale
```

Le module est **entièrement autonome** — aucune dépendance vers `features/names/`.
Les passerelles (§6) sont des liens de navigation go_router, pas des imports croisés.
