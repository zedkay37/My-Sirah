# DESIGN_SYSTEM.md — Système de design

## Principes
- **Calligraphie arabe centrale** : toujours le point focal visuel
- **Typo serif pour le corps**, sans pour l'UI, arabe pour l'arabe
- **Pas plus de 2 couleurs d'accent par thème** (sauf palette catégorie)
- **Spacing basé sur une grille de 4**
- **Radius doux mais pas bubble-gum** (12-16 par défaut)

## Tokens communs

### Spacing (grille 4)
```dart
class AppSpacing {
  final double xs = 4;
  final double sm = 8;
  final double md = 16;
  final double lg = 24;
  final double xl = 32;
  final double xxl = 48;
}
```

### Radius
```dart
class AppRadius {
  final double sm = 6;
  final double md = 12;
  final double lg = 18;
  final double pill = 999;
}
```

### Elevation
```dart
// thèmes clair/féminin : shadows douces
// thème sombre : glow or discret sur cartes importantes
```

## Typographies

### Familles
- `amiriQuran` — calligraphie arabe, Coran
- `amiri` — arabe corps de texte
- `crimsonPro` — serif éditorial (corps)
- `playfair` — serif display (thème féminin)
- `inter` — sans-serif UI

### Échelle
```dart
class AppTypography {
  final TextStyle arabicHero;       // 88sp, amiriQuran
  final TextStyle arabicLarge;      // 56sp
  final TextStyle arabicMedium;     // 32sp
  final TextStyle arabicBody;       // 22sp
  final TextStyle displayLarge;     // 36 serif
  final TextStyle displayMedium;    // 28 serif
  final TextStyle headline;         // 20 serif
  final TextStyle bodyLarge;        // 16 serif
  final TextStyle body;             // 14 serif
  final TextStyle caption;          // 12 sans
  final TextStyle overline;         // 10 sans uppercase spaced
  final TextStyle button;           // 14 sans medium
}
```

## Thème CLAIR (A — éditorial sobre)

**Usage** : lecture jour, neutre, grand public, défaut.
**Serif** : Crimson Pro.

```dart
// Couleurs
bg:       #F5F1E8   // papier crème
bg2:      #EFE9DB   // surface carte légèrement plus foncée
ink:      #1F1D18   // texte principal
muted:    #7A7A6F   // texte secondaire
accent:   #1F5942   // vert profond (CTA, liens, chips)
accent2:  #8B5A2A   // brun secondaire (annotations)
line:     #D8CCB4   // séparateurs
success:  #2E7D5B
warning:  #B88A2A
error:    #B83D3D
```

## Thème SOMBRE (B — nuit + or)

**Usage** : lecture tardive, mode nuit, ambiance cinématographique.
**Serif** : Crimson Pro.

```dart
bg:       #141312   // nuit profonde
bg2:      #1C1A16   // surface carte
ink:      #F2ECE0   // crème lumineux
muted:    #8C8578
accent:   #D4A857   // or brûlé
accent2:  #9E7A3C
line:     #26231F
success:  #7FB997
warning:  #E0B45C
error:    #D67070
// Effet signature : glow or discret autour de la calligraphie hero
// textShadow: '0 2px 40px D4A85755'
```

## Thème FÉMININ (C — constellation colorée)

**Usage** : palette douce, gamifiée, adressée spécifiquement à un public féminin.
**Serif display** : Playfair Display.
**Signature** : constellation violet/lavande, hero gradient, badges animés.

```dart
bg:       #F7F4FF   // lavande très pâle
bg2:      #FFFFFF   // carte blanche
ink:      #161129   // texte très sombre nuancé violet
muted:    #7A7590
accent:   #6B4EF2   // violet indigo (CTA)
accent2:  #FF8A4C   // orange complémentaire (streak, badges)
line:     #ECE7FA
success:  #18A87A
warning:  #F4A622
error:    #E63E6D

// Gradient signature (header hero, badges)
gradient: ['#6B4EF2', '#FF8A4C']

// Effet : box-shadow colorée sous les cartes principales
// shadow: '0 4px 0 6B4EF222'
```

## Palette par catégorie (commune aux 3 thèmes)

Les couleurs catégorielles sont **invariantes** (même HUE sur les 3 thèmes) mais saturation/luminance ajustées par thème.

| Slug | Libellé | Hue | Light | Dark | Feminine |
|---|---|---|---|---|---|
| praise | Louange | 28 | #B86B2A | #D48757 | #FF9A4C |
| prophethood | Prophétie | 210 | #2A5BA8 | #5A8BCC | #4A7FDF |
| intercession | Intercession | 260 | #5B3FBE | #8A6FD9 | #7B5EE8 |
| eschatology | Eschatologie | 320 | #A83A7A | #D06FA0 | #E063A8 |
| purity | Pureté | 170 | #1F7A6B | #4FA593 | #18A88C |
| virtues | Qualités | 90 | #5E8A2A | #8BB355 | #8BC340 |
| miraj | Miʿrāj | 240 | #3A3FBE | #6E72D9 | #5E60E8 |
| guidance | Guidance | 45 | #B88A0D | #D9B040 | #F4A622 |
| light | Lumière | 55 | #A8932A | #D4BF57 | #F4D422 |
| nobility | Origine | 10 | #B83D2A | #D46B57 | #FF6A4C |
| devotion | Dévotion | 140 | #2A8A5E | #57B388 | #18A87A |

Helper dans `app_colors.dart` :
```dart
Color categoryColor(String slug);
Color categoryBg(String slug);   // tint 10% alpha
```

## Composants partagés

### `ArabicText`
```dart
ArabicText(
  text: name.arabic,
  size: ArabicSize.hero,         // hero/large/medium/body
  withShadow: theme.isDark,      // auto sur thème sombre
);
// Applique : fontFamily amiriQuran, direction RTL, textAlign center par défaut
```

### `NameCard`
Card de liste (index des noms). Contient : n°, calligraphie medium, translit, chip catégorie, icône favori.

### `QuizCard`
Flashcard retournable (AnimatedSwitcher + rotation Y). Props : front, back, onFlip.

### `CategoryChip`
Pill avec dot colorée + libellé. Variants : filled, outlined, small.

### `ProgressRing`
Anneau de progression (CustomPaint). Utilisé pour : progression globale, progression par catégorie.

### `Constellation` (thème C uniquement)
Widget SVG-like affichant les 201 noms comme des étoiles, reliées par catégorie, animé au scroll.

### `StreakBadge`
Flamme + nombre de jours, coloré selon thème.

### `SectionHeader`
Ornement horizontal + titre en overline (Style éditorial A).

## Motion

### Durées
- `instant: 100ms`
- `fast: 200ms`
- `medium: 350ms`
- `slow: 600ms`

### Courbes
- `Curves.easeOutCubic` par défaut
- `Curves.easeOutQuart` pour entrées
- `Curves.easeInOutCubic` pour transitions

### Animations signature
- **Flashcard** : rotation Y 600ms easeOutQuart
- **Streak +1** : flamme scale 1→1.3→1 + particle
- **Badge débloqué** : scale + rotate + confetti (flutter_animate)
- **Transition écran** : fade + slide subtle (pas de zoom iOS default)

## Iconographie
- Feather Icons (via `flutter_feather_icons` ou SVG custom)
- Taille de base : 20px / 24px / 32px
- Stroke 1.5
- Jamais d'emoji dans l'UI (sauf thème C décoratif : ✨🌙 autorisés parcimonieusement)

## Densité
- Écran accueil : aéré, 1 info focale (calligraphie hero)
- Fiche détail : dense mais rythmée par sections espacées `lg` (24)
- Liste : row height ~72px
- Tab bar : height 64px iOS, 56px Android

## Règles d'or
1. La calligraphie arabe est **toujours** l'élément le plus grand de l'écran où elle apparaît
2. Le vert/or/violet ne se mélangent **jamais** entre thèmes
3. Une catégorie = une couleur unique, **jamais** variée dans l'app
4. Pas plus de **2 emphases** simultanées dans un écran
