# SPEC.md — Spécification produit V1

> Application mobile Flutter dédiée à l'apprentissage des **201 noms du Prophète ﷺ**
> issus de *Dalāʾil al-Khayrāt* et sources classiques.

---

## 1. Vision & positionnement

### Mission
Offrir un compagnon spirituel mobile qui permet à l'utilisateur d'**apprendre**, **mémoriser** et **développer une connexion émotionnelle** aux 201 noms du Prophète ﷺ.

### Principe directeur V1
**Focus total sur les Asmāʾ an-Nabī.** Pas de dispersion. L'app fait une chose et la fait bien : apprendre ces 201 noms, leurs étymologies, leurs significations, leurs sources.

### Vision long-terme (hors V1, à garder en tête pour l'architecture)
La V1 pose les fondations d'un écosystème plus large autour de la **connaissance et l'amour du Prophète ﷺ** :
- Sīra (biographie) interactive
- Khaṣāʾiṣ (qualités et particularités)
- Shamāʾil (descriptions physiques et caractère)
- Hadiths thématiques
- Salawāt et invocations

→ **Le code doit être structuré par modules** pour faciliter ces ajouts. Les 201 noms sont le **premier module**, pas le produit final.

### Ton & ambiance
- Spirituel, contemplatif, respectueux
- Moderne et épuré (pas de surcharge visuelle, pas de gamification agressive)
- La calligraphie arabe est le héros graphique
- Gamification douce : progression visible en constellation, pas de badges/points bruyants

---

## 2. Périmètre V1

### ✅ Inclus
- Onboarding minimal (3 écrans)
- Accueil avec nom du jour + carrousel catégories
- Liste des 201 noms avec recherche + filtre catégorie
- Fiche détail complète, swipeable
- Favoris
- Partage (image générée)
- Quiz (2 types : QCM description → nom, flashcards)
- Profil avec progression en constellation
- Notifications push quotidiennes (nom du jour)
- 3 thèmes : clair, sombre, féminin
- FR uniquement

### ❌ Exclus V1 (à ne pas coder)
- Audio / prononciation
- Badges, points, classements
- Compte utilisateur / cloud / synchronisation
- Langues EN/AR (interface)
- Commentaires communautaires
- Révision espacée (type Anki)
- Modules Sīra, Shamāʾil, etc.

---

## 3. Modèle de données

### Modèle ProphetName (freezed)

> **IMPORTANT — Mapping JSON ↔ Dart**
> Le fichier `names.json` utilise des noms de champs spécifiques.
> Le modèle Dart utilise `@JsonKey(name: ...)` pour le mapping.

```dart
@freezed
class ProphetName with _$ProphetName {
  const factory ProphetName({
    @JsonKey(name: 'id') required int number,          // 1 à 201
    required String arabic,                             // مُحَمَّد
    required String transliteration,                    // Muḥammad
    @JsonKey(name: 'categorySlug') required String categorySlug, // "praise"
    @JsonKey(name: 'category') required String categoryLabel,    // "Louange" (label FR)
    required String etymology,                          // étymologie complète
    required String commentary,                         // commentaires classiques
    required String references,                         // versets + hadiths
    required String primarySource,                      // source principale
    required String secondarySources,                   // sources complémentaires
  }) = _ProphetName;

  factory ProphetName.fromJson(Map<String, dynamic> json) =>
      _$ProphetNameFromJson(json);
}
```

### Champs JSON réels (names.json)

Chaque entrée du fichier `names.json` contient exactement ces champs :

| Champ JSON | Type | Exemple |
|---|---|---|
| `id` | `int` | `1` |
| `arabic` | `String` | `"مُحَمَّد"` |
| `transliteration` | `String` | `"Muḥammad"` |
| `category` | `String` | `"Louange"` (label FR pour affichage) |
| `categorySlug` | `String` | `"praise"` (clé technique) |
| `etymology` | `String` | texte complet |
| `commentary` | `String` | texte complet (commentaires classiques) |
| `references` | `String` | versets + hadiths |
| `primarySource` | `String` | source principale |
| `secondarySources` | `String` | sources complémentaires |

### Enum Category

```dart
enum Category {
  praise,         // Louange — 8 noms
  prophethood,    // Prophétie et mission — 38 noms
  intercession,   // Rang divin et intercession — 44 noms
  eschatology,    // Eschatologie — 12 noms
  purity,         // Pureté et sainteté — 10 noms
  virtues,        // Qualités morales — 28 noms
  miraj,          // Voyage nocturne (Miʿrāj) — 6 noms
  guidance,       // Attributs de guidance — 6 noms
  light,          // Beauté et lumière — 14 noms
  nobility,       // Origine noble — 14 noms
  devotion,       // Dévotion et adoration — 21 noms
}
```

Le mapping `categorySlug → Category` se fait par correspondance directe du nom de l'enum.
Le label français est dans `categoryLabel` (champ `category` du JSON) OU dans `categories.json`.

### Catégories (categories.json)

```json
[
  { "slug": "praise", "labelFr": "Louange", "count": 8 },
  { "slug": "prophethood", "labelFr": "Prophétie et mission", "count": 38 },
  ...
]
```

### État persisté (local, Hive)

```dart
@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(ThemeKey.light) ThemeKey theme,
    @Default({}) Set<int> favorites,       // numéros des noms favoris
    @Default({}) Set<int> learned,         // noms marqués appris
    @Default({}) Set<int> viewed,          // noms consultés au moins une fois
    @Default({}) Map<int, DateTime> lastSeen,  // par numéro, dernière visite
    DateTime? onboardingCompletedAt,
    int? dailyNotifHour,                   // 0-23, null si pas de notif
    @Default(0) int quizzesCompleted,
    @Default(0) int totalQuizScore,        // somme des bonnes réponses
  }) = _UserState;
}
```

### Dérivations
- **Nom du jour** : `names[(daysSinceEpoch) % 201]` — déterministe, même nom pour tous les users un jour donné.
- **Constellation** : un point par nom (201 points), colorié selon `learned`.
- **Progression** : `learned.length / 201`.

---

## 4. Écrans détaillés

### 4.1 Onboarding (3 écrans)

**Écran 1 — Bienvenue**
- Fond : calligraphie ﷺ en filigrane
- Titre : *« Les 201 noms du Prophète ﷺ »*
- Sous-titre : *« Apprenez, méditez, connectez-vous. »*
- CTA : "Commencer"

**Écran 2 — Choix du thème**
- Titre : *« Choisissez votre ambiance »*
- 3 cartes preview côte-à-côte (clair / sombre / féminin) avec un aperçu du nom du jour dans chaque.
- Tap sur une carte = sélection (indicateur visuel).
- CTA : "Continuer"

**Écran 3 — Notification quotidienne**
- Titre : *« Un nom chaque jour »*
- Sous-titre : *« Recevez le nom du jour à l'heure qui vous convient »*
- Time picker (défaut 08:00)
- CTA principal : "Activer les notifications" → demande permission OS
- CTA secondaire : "Plus tard" (pas de notif)
- À la fin : `onboardingCompletedAt = now` → redirige Accueil

---

### 4.2 Accueil

**Structure verticale (scroll)** :

1. **Header** (haut)
   - Salutation contextuelle : *« As-salāmu ʿalaykum »*
   - Date hégirienne + grégorienne (petite)

2. **Nom du jour** (bloc principal, ~60% hauteur écran)
   - Numéro (#47, en petit)
   - **Nom arabe en très grand** (80-120pt, Amiri Quran)
   - Translittération (italique, sous l'arabe)
   - Catégorie (pastille colorée, utiliser `categoryLabel` pour le texte)
   - Extrait étymologie (3-4 lignes, fade bas)
   - CTA : "Découvrir ce nom" → ouvre la fiche détail

3. **Carrousel catégories**
   - Titre de section : *« Explorer par catégorie »*
   - Scroll horizontal, 11 cartes (une par catégorie, data de `categories.json`)
   - Chaque carte : `labelFr` + compteur (ex: "12/44 appris") + couleur dédiée via `slug`
   - Tap → liste filtrée sur cette catégorie

---

### 4.3 Liste des 201 noms (onglet Découvrir, vue par défaut)

**Layout : liste aérée**
- En-tête :
  - Titre "Découvrir"
  - Sous-onglets : **Tous les noms** (actif) | **Quiz**
- Barre de recherche (sticky)
  - Placeholder : *« Rechercher (arabe, translittération, français) »*
  - Recherche sur : `arabic`, `transliteration`, `etymology`, `commentary`
- Chips catégories (scroll horizontal, sticky sous la recherche)
  - Chip "Tous" + 11 chips catégories (de `categories.json`), chacune avec sa couleur via `slug`
  - Sélection unique (multi-sélection V2)
- Liste verticale
  - Chaque ligne :
    - Numéro (#001, monochrome, 14pt) — champ `number`
    - Nom arabe (28pt, Amiri Quran, gras) — champ `arabic`
    - Translittération (16pt, italique) — champ `transliteration`
    - Pastille catégorie (8px, couleur via `categorySlug`)
    - Icône cœur si favori
  - Tap → fiche détail

---

### 4.4 Quiz (onglet Découvrir, sous-onglet)

**Écran d'entrée Quiz** :
- Titre : *« Quiz rapide »*
- Sous-titre : *« 5 questions · ~1 minute »*
- Choix du type (2 cartes) :
  - **QCM** — *« Trouvez le nom à partir de sa description »*
  - **Flashcards** — *« Retournez les cartes pour réviser »*
- CTA : "Démarrer"

**Mode QCM** :
- 5 questions successives
- Chaque question :
  - Texte : extrait du champ `commentary` (60-100 mots, masquant le nom)
  - Masquage : regex sur `arabic` et `transliteration` remplacés par "[ce nom]"
  - 4 réponses (nom arabe + translit) : 1 correcte + 3 distracteurs aléatoires (de préférence même `categorySlug`)
  - Tap sur une réponse → feedback immédiat (vert/rouge) pendant 1.2s
  - Passage auto à la question suivante
- Progression : barre fine en haut (1/5, 2/5...)

**Mode Flashcards** :
- 5 cartes présentées une par une
- Face avant : **nom arabe en très grand** (`arabic`) + translittération (`transliteration`)
- Tap → retournement 3D → face arrière : `categoryLabel` + étymologie courte (`etymology` tronqué) + extrait `commentary`
- Boutons bas : "Je connais" / "À revoir"
- Swipe horizontal pour carte suivante

**Écran de fin** :
- Grande calligraphie décorative
- Message motivateur contextuel :
  - Si ≥ 4/5 : *« MāshāʾAllāh. Chaque nom est une porte vers Sa lumière. Continuez à explorer. »*
  - Si 2-3/5 : *« Chaque nom mérite qu'on s'y attarde. Revenez demain, ils deviendront familiers. »*
  - Si ≤ 1/5 : *« La connaissance commence par la patience. Explorez la fiche des noms pour les apprivoiser. »*
- Sous le message : petite ligne "Vous avez répondu correctement à X/5" (discret)
- CTAs :
  - "Rejouer"
  - "Explorer les noms" → retour liste

---

### 4.5 Fiche détail

**Accès** : tap depuis Accueil, Liste, ou Quiz.

**Structure** :
- Header fixe :
  - Bouton retour (gauche)
  - Titre discret : "Nom #047" (champ `number`)
  - Icônes actions (droite) : cœur (favori) + partage
- Flèches précédent/suivant (côtés, semi-transparentes, toujours visibles)
- **Swipe horizontal** entre fiches (geste principal)
- Contenu scrollable vertical :
  1. Numéro + pastille catégorie (`categoryLabel`, couleur via `categorySlug`)
  2. **Nom arabe** (très grand, centré) — `arabic`
  3. Translittération (italique, centré) — `transliteration`
  4. Section "Étymologie" (titre + texte) — `etymology`
  5. Section "Commentaires classiques" (titre + texte complet) — `commentary`
  6. Section "Références" (versets + hadiths, mise en forme citation) — `references`
  7. Section "Sources" (repliable) — `primarySource` + `secondarySources`
- Footer : indicateur "47 / 201" + mini-barre de progression

**Actions** :
- **Cœur** (favori) : toggle instantané, feedback haptique léger
- **Partage** : génère une image (template joli, `arabic` + `transliteration` + `categoryLabel` + URL app) et ouvre le menu share OS natif
- Le fait d'ouvrir une fiche marque automatiquement `viewed.add(number)` et met à jour `lastSeen`

---

### 4.6 Profil

**Structure verticale** :

1. **Header**
   - Salutation + date hégirienne
   - Paramètres en haut-droite (icône roue crantée)

2. **Progression en constellation** (bloc signature)
   - Canvas 1:1 (carré), fond selon thème
   - 201 étoiles disposées en spirale douce (positions stables, seed déterministe basé sur `number`)
   - Étoiles **appris** : lumineuses, couleur accent selon `categorySlug`
   - Étoiles **vues mais pas apprises** : demi-brillantes
   - Étoiles **non découvertes** : punctum discret
   - Tap sur une étoile → ouvre la fiche du nom correspondant (`number`)
   - En bas du canvas : "X / 201 noms appris"

3. **Stat simple**
   - Grand chiffre : noms appris (ex: "47")
   - Sous-titre : "sur 201 noms du Prophète ﷺ"

4. **Raccourcis**
   - "Mes favoris" → liste filtrée
   - "Paramètres"

**Écran Paramètres** (accès depuis Profil) :
- Thème : clair / sombre / féminin (3 cartes preview)
- Notification quotidienne : toggle + time picker
- Taille du texte : petit / moyen / grand
- À propos : version, sources, crédits
- Signaler une erreur (mailto pré-rempli)

---

## 5. Règles métier

### Définition d'un nom "appris"
Un nom passe en `learned` si :
- **OU** l'utilisateur l'a consulté dans la fiche détail ≥ 8 secondes (trigger on scroll/idle)
- **OU** l'utilisateur a répondu correctement à une question QCM portant sur ce nom
- **OU** il a cliqué "Je connais" sur la flashcard de ce nom

Une fois `learned`, le statut est permanent (pas de désapprentissage).

### Génération du nom du jour
```dart
final epoch = DateTime(2025, 1, 1);
final days = DateTime.now().difference(epoch).inDays;
final todayIndex = days % 201;
// → names[todayIndex] (accès par index dans la liste triée par `number`)
```
Stable pour tous les utilisateurs un jour donné.

### Génération quiz QCM
- Tirage de 5 noms aléatoires (pool : tous les 201)
- Pour chaque nom tiré :
  - Extraction d'un paragraphe depuis `commentary` (60-150 mots)
  - Masquage du nom (regex sur `arabic` et `transliteration`) par "[ce nom]"
  - 3 distracteurs tirés aléatoirement, en priorité même `categorySlug`
- Pas de répétition de noms dans la même session

### Partage (image générée)
- Template 1080×1920 (story-friendly)
- Fond : couleur thème actif
- `arabic` énorme, `transliteration`, `categoryLabel`, petite mention "Asmāʾ an-Nabī ﷺ"
- Export PNG via `screenshot` package → `share_plus`

---

## 6. Navigation

### Tab bar basse, 3 onglets
1. 🏠 **Accueil** (Home)
2. 🔍 **Découvrir** (Discover — liste + quiz en sous-onglets internes)
3. 👤 **Profil** (Profile)

### Routes
- `/home`
- `/discover` (sous-onglets internes : liste + quiz)
- `/profile`
- `/name/:number` (fiche détail, push depuis n'importe où)
- `/settings` (depuis profil)

---

## 7. Notifications

- Permission demandée à l'onboarding (écran 3)
- 1 notification par jour à l'heure choisie
- Contenu : *« Nom du jour : [arabic] ([transliteration]) »*
- Tap → ouvre directement la fiche détail du nom du jour
- Réglable dans Paramètres (heure, ou désactivation)
- Package : `flutter_local_notifications`

---

## 8. Performances & contraintes

- **100% offline** : aucun backend V1
- Taille app visée : < 30 Mo (polices arabes incluses)
- Temps de démarrage froid : < 2s sur device milieu de gamme
- 60 fps sur toutes les animations (swipe fiche, retournement flashcard, transitions)

---

## 9. Accessibilité

- Texte arabe toujours sélectionnable et copiable
- Contraste AA minimum sur tous les thèmes
- Respect de la taille de texte système (Dynamic Type iOS / font scale Android)
- Sémantique Flutter : `Semantics` correctement posé sur les actions
- Support RTL pour les passages arabes (attribut `textDirection: TextDirection.rtl`)

---

## 10. Architecture technique

Voir `CLAUDE.md` pour le stack exact et l'arborescence complète.

Résumé de la structure modulaire :
```
lib/
  core/          # theme, router, storage, utils — partagé, PAS de logique names
  features/
    names/       # MODULE V1 : data (models, repo, source) + presentation (home, list, detail)
    quiz/        # data (generator) + presentation (entry, qcm, flashcards, result)
    profile/     # presentation (profile, favorites, settings)
    onboarding/  # presentation
    shared/      # widgets réutilisables (ArabicText, NameCard, etc.)
```

---

## 11. Livrables V1 attendus

Pour considérer la V1 livrée :
- [ ] Tous les écrans de cette spec implémentés
- [ ] Les 3 thèmes fonctionnels et switchables
- [ ] Données 201 noms chargées depuis `names.json` (201 entrées, 11 catégories)
- [ ] Persistance locale (favoris, learned, thème, heure notif)
- [ ] Notifications quotidiennes
- [ ] Partage d'image
- [ ] Tests manuels sur iOS + Android (simulateurs)
- [ ] Build Flutter release signés