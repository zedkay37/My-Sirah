# \# CLAUDE.md — Instructions pour Claude Code

# 

# \## Projet

# \*\*Asmāʾ an-Nabī\*\* — Application mobile Flutter pour explorer les 201 Noms du Prophète Muḥammad ﷺ avec lecture approfondie, mémorisation et gamification douce.

# 

# \## Vision long-terme (à garder en tête pour l'architecture)

# La V1 est \*\*focalisée exclusivement sur les 201 noms\*\*. Mais l'app évoluera vers un écosystème plus large autour de la \*\*connaissance et l'amour du Prophète ﷺ\*\* :

# \- Sīra (biographie) interactive

# \- Khaṣāʾis (qualités et particularités)

# \- Shamāʾil (descriptions physiques et caractère)

# \- Hadiths thématiques

# \- Salawāt et invocations

# 

# → \*\*Structure modulaire obligatoire.\*\* Chaque feature sous `lib/features/` doit être autonome. Les 201 noms sont le \*\*premier module\*\*, pas le produit final. Ne mets pas de logique spécifique "names" dans `core/`.

# 

# \## Stack imposée

# \- \*\*Flutter 3.24+\*\* / \*\*Dart 3\*\*

# \- \*\*Riverpod\*\* (state management) — jamais Provider ou Bloc

# \- \*\*go\_router\*\* (navigation)

# \- \*\*hive\_ce\*\* (persistance locale)

# \- \*\*freezed + json\_serializable\*\* (modèles immuables)

# \- \*\*google\_fonts\*\* pour Amiri, Amiri Quran, Crimson Pro, Inter

# \- \*\*flutter\_animate\*\* pour animations

# \- \*\*intl\*\* (formatage date FR + hijri via `hijri` package)

# 

# \## Principes de code non-négociables

# 1\. \*\*TOUT est typé.\*\* Aucun `dynamic` en dehors du parsing JSON initial.

# 2\. \*\*TOUT est immutable.\*\* Modèles en `freezed`, state en `freezed`.

# 3\. \*\*Aucune couleur en dur dans un widget.\*\* Toujours via `context.theme.colors.X`.

# 4\. \*\*Aucune string en dur côté UI.\*\* Passer par `l10n` (même si FR only au départ — préparer pour AR/EN).

# 5\. \*\*1 widget = 1 fichier\*\* si > 80 lignes.

# 6\. \*\*Tests widget\*\* sur les 5 écrans principaux minimum.

# 7\. \*\*Accessibilité\*\* : `Semantics`, tailles dynamiques respectées, contraste AA.

# 

# \## Architecture de dossiers (à respecter strictement)

# 

# > \*\*Architecture modulaire par feature.\*\* Chaque module regroupe son data layer ET son

# > presentation layer. Les futures features (Sīra, Shamāʾil) viendront se greffer comme

# > nouveaux dossiers sous `features/`.

# 

# ```

# lib/

# &#x20; main.dart

# &#x20; app.dart                        # MaterialApp.router + ThemeProvider

# &#x20; core/

# &#x20;   theme/

# &#x20;     app\_theme.dart              # ThemeData builder par variante

# &#x20;     app\_colors.dart             # extension ThemeExtension<AppColors>

# &#x20;     app\_typography.dart

# &#x20;     app\_spacing.dart

# &#x20;     app\_radius.dart

# &#x20;     app\_elevation.dart

# &#x20;     themes/

# &#x20;       light\_theme.dart          # thème A (éditorial sobre)

# &#x20;       dark\_theme.dart           # thème B (nuit + or)

# &#x20;       feminine\_theme.dart       # thème C (constellation)

# &#x20;   router/

# &#x20;     app\_router.dart

# &#x20;   storage/                      # hive boxes, config

# &#x20;     hive\_source.dart

# &#x20;   providers/                    # riverpod providers partagés (UserState, etc.)

# &#x20;   utils/

# &#x20; features/

# &#x20;   names/                        # ← MODULE PRINCIPAL V1

# &#x20;     data/

# &#x20;       models/

# &#x20;         prophet\_name.dart       # freezed model (voir SPEC.md §3)

# &#x20;       repositories/

# &#x20;         names\_repository.dart

# &#x20;       sources/

# &#x20;         names\_json\_source.dart  # charge assets/data/names.json

# &#x20;     presentation/

# &#x20;       home/                     # écran Accueil + widgets

# &#x20;       list/                     # liste des 201 noms

# &#x20;       detail/                   # fiche détail swipeable

# &#x20;       search/                   # widgets de recherche

# &#x20;   quiz/

# &#x20;     data/

# &#x20;       quiz\_generator.dart       # génération QCM + flashcards

# &#x20;     presentation/

# &#x20;       entry/                    # écran d'entrée quiz

# &#x20;       qcm/                      # écran QCM

# &#x20;       flashcards/               # écran flashcards

# &#x20;       result/                   # écran de fin

# &#x20;   profile/

# &#x20;     presentation/

# &#x20;       profile/                  # écran profil + constellation

# &#x20;       favorites/                # liste des favoris

# &#x20;       settings/                 # paramètres

# &#x20;   onboarding/

# &#x20;     presentation/

# &#x20;       onboarding\_screen.dart

# &#x20;   shared/                       # widgets réutilisables

# &#x20;     arabic\_text.dart

# &#x20;     name\_card.dart

# &#x20;     progress\_ring.dart

# &#x20;     quiz\_card.dart

# &#x20;     category\_chip.dart

# &#x20;     constellation\_view.dart

# &#x20;     streak\_badge.dart

# &#x20;     section\_header.dart

# l10n/

# &#x20; intl\_fr.arb

# &#x20; intl\_ar.arb                     # placeholder

# assets/

# &#x20; data/

# &#x20;   names.json                    # les 201 noms, fourni

# &#x20;   categories.json               # les 11 catégories

# &#x20; fonts/                          # fonts Amiri Quran en local pour perf

# ```

# 

# \## Conventions de nommage

# \- Fichiers : `snake\_case.dart`

# \- Classes/widgets : `PascalCase`

# \- Providers Riverpod : suffixe `Provider` (`dailyNameProvider`, `themeModeProvider`)

# \- Extensions : `XOn<Type>` (ex: `BuildContextX on BuildContext`)

# \- Enums : `PascalCase` avec valeurs `camelCase`

# 

# \## Accès aux tokens de thème

# ```dart

# // Extension obligatoire sur BuildContext

# extension BuildContextX on BuildContext {

# &#x20; AppColors get colors => Theme.of(this).extension<AppColors>()!;

# &#x20; AppTypography get typo => Theme.of(this).extension<AppTypography>()!;

# &#x20; AppSpacing get space => Theme.of(this).extension<AppSpacing>()!;

# &#x20; AppRadius get radii => Theme.of(this).extension<AppRadius>()!;

# }

# 

# // Usage dans un widget

# Text('...', style: context.typo.serifTitle.copyWith(color: context.colors.accent));

# ```

# 

# \## Thèmes (voir DESIGN\_SYSTEM.md pour valeurs)

# 3 variantes : `light`, `dark`, `feminine`. Le thème est un enum dans `settingsStore`, persisté dans Hive. Changer de thème = simple rebuild, aucun code métier ne doit connaître le nom du thème courant.

# 

# \## Données

# 

# \### names.json — Mapping JSON → Dart

# 

# Le fichier `assets/data/names.json` contient 201 entrées. \*\*Les champs JSON ne correspondent pas 1:1 aux noms Dart\*\* — le mapping est documenté ci-dessous et dans SPEC.md §3.

# 

# | Champ JSON | Champ Dart (ProphetName) | Type |

# |---|---|---|

# | `id` | `number` | `int` (1-201) |

# | `arabic` | `arabic` | `String` |

# | `transliteration` | `transliteration` | `String` |

# | `category` | \*(ignoré, utiliser `categorySlug`)\* | — |

# | `categorySlug` | `categorySlug` | `String` → mapped vers `Category` enum |

# | `etymology` | `etymology` | `String` |

# | `commentary` | `commentary` | `String` |

# | `references` | `references` | `String` |

# | `primarySource` | `primarySource` | `String` |

# | `secondarySources` | `secondarySources` | `String` |

# 

# Le champ `category` (ex: "Louange") est le label FR pour l'affichage. Le champ `categorySlug` (ex: "praise") est la clé technique pour l'enum et les couleurs.

# 

# \- Chargé une fois au démarrage, mis en cache via Riverpod `FutureProvider`.

# \- Catégories dans `assets/data/categories.json` (slug, labelFr, count).

# 

# \## Règles produit (voir SPEC.md pour détail)

# \- \*\*Nom du jour\*\* : déterministe par date (`daysSinceEpoch % 201`), identique pour tous les utilisateurs.

# \- \*\*Progression "learned"\*\* : un nom est marqué appris après 8s de consultation OU bonne réponse QCM OU "Je connais" en flashcard.

# \- \*\*Quiz V1\*\* : 2 formats uniquement — QCM (description → nom) et Flashcards retournables. Pas de badges, pas de points.

# \- \*\*Navigation\*\* : tab bar 3 onglets — Accueil, Découvrir (liste+quiz en sous-onglets), Profil.

# \- \*\*Constellation\*\* : visualisation signature du profil. 201 étoiles à positions stables.

# \- \*\*Hors-ligne\*\* : 100% fonctionnel. Aucun backend V1, aucune dépendance réseau au runtime.

# \- \*\*Langue V1\*\* : FR uniquement (prévoir l10n pour AR/EN).

# 

# \## Commits

# Format conventional commits : `feat(home): ...`, `fix(quiz): ...`, `chore: ...`. Un commit par feature complète, pas micro-commits.

# 

# \## Ce que Claude Code NE doit PAS faire

# \- Générer d'assets visuels (logos, icônes complexes) — utiliser des placeholders ou demander.

# \- Ajouter des dépendances non listées sans me demander.

# \- Implémenter du backend / auth / analytics / audio en V1.

# \- Ajouter des badges, points, classements (gamification bruyante proscrite).

# \- Mélanger logique métier et UI.

# \- Toucher à `names.json` sans me prévenir.

# \- Coder hors scope du SPEC.md sans validation.

