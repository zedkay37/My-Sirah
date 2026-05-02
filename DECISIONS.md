# Journal de decisions - Sirah Hub / Asma an-Nabi

Derniere mise a jour : 2026-05-01
Branche de travail observee : `main` / tag `v2.0.0-beta.3`
Role du document : conserver les decisions produit/techniques importantes, les raisons, l'etat courant et les prochaines etapes pour eviter de perdre le contexte entre les sprints.

## Comment maintenir ce fichier

- Mettre a jour ce document a chaque fin de sprint ou decision structurante.
- Ajouter les decisions dans le journal chronologique, puis mettre a jour le snapshot courant si necessaire.
- Ne pas transformer ce fichier en backlog exhaustif de tickets. Il doit garder les choix, les arbitrages et les risques.
- Les contenus religieux, recits, tafakkur et actions doivent rester dans les fichiers editoriaux dedies et ne deviennent validés que par revue humaine.

## Fichiers de contexte a connaitre

| Fichier | Role |
| --- | --- |
| `AGENTS.md` | Instructions locales pour Codex : architecture, stack, contraintes produit, style de code. |
| `README.md` | Source de verite produit actuelle pour la V2 Journey. |
| `SPEC.md` | Specification fonctionnelle historique de la V1 noms. |
| `DESIGN_SYSTEM.md` | Tokens, intentions visuelles, themes. |
| `docs/JOURNEY_RESTRUCTURE_PLAN.md` | Plan de refonte Journey V2 et decisions initiales. |
| `docs/JOURNEY_GUARDRAILS.md` | Regles a ne pas casser pendant la consolidation V2. |
| `docs/content_backlog_journey.md` | Backlog editorial des recits/actions a valider humainement. |
| `docs/ACTION_REVIEW_V2.md` | Support de revue des 43 actions, groupees par theme/constellation. |
| `docs/RELEASE_AUDIT_V2.md` et `docs/V2_1_AUDIT_BRIEF.md` | Audits precedents et risques identifies. |

## Vision actuelle

La V1 reste focalisee sur les 201 noms du Prophete Muhammad ﷺ, mais l'architecture doit rester ouverte vers un ecosysteme plus large : Sira, Khasa'is, Shama'il, hadiths thematiques, salawat et invocations.

Le produit n'est pas une simple encyclopedie de fiches. La direction retenue est :

```text
Accueil -> Voyage -> Fiche du nom -> Tafakkur -> Action -> Profil
```

Boucle produit a respecter :

```text
Decouvrir -> Comprendre -> Contempler -> Incarner -> Memoriser
```

L'experience signature est le Voyage : une carte stellaire des noms, avec constellations thematiques et progression douce.

## Regles non negociables

- Ne pas modifier `assets/data/names.json` sans validation explicite.
- Ne pas inventer de contenu religieux, doctrinal, recit de Sira, tafakkur ou action spirituelle.
- Ne pas afficher du contenu `needs_review` comme s'il etait valide.
- Ne pas ajouter backend, auth, analytics ou audio en V1/V2 courte.
- Ne pas ajouter de dependance sans validation.
- Ne pas utiliser `learned` comme metrique principale de Journey.
- Ne pas faire de gamification bruyante : pas de score spirituel, badges, classement, competition.
- Garder Asma al-Husna hors du Voyage pour l'instant : Bibliotheque only.
- Editer les ARB pour la l10n, puis lancer `flutter gen-l10n`; ne pas modifier les fichiers l10n Dart a la main.
- `SettingsNotifier` reste le seul writer de l'etat utilisateur persiste.

## Snapshot produit actuel

### Accueil

Decision : garder le nom du jour aleatoire/deterministe comme coeur de l'accueil.
Raison : l'utilisateur aime le cote "pas besoin de reflechir, une chose a decouvrir par jour".

Changements actues :

- CTA du nom du jour : `Decouvrir ce nom`.
- Suppression des raccourcis redondants `Continuer mon voyage`, `Voyage`, `Bibliotheque` qui doublaient la bottom nav.
- Ajout d'une reprise contextuelle seulement si elle a une vraie valeur : dernier nom vu.
- Ajout d'une trace de cheminement sobre : decouverts, contemples, reconnus.
- Les actions du jour ne s'affichent que si une action specifique validee existe.

Risque restant : valider visuellement sur mobile reel ou emulateur.

### Voyage

Decision : Voyage doit devenir l'ecran "waouh calme" de l'app, pas une liste de cercles surchargee.

Changements actues :

- Galaxie `Noms du Prophete ﷺ` recentree.
- La carte de deck utilise une navigation spatiale via `SpaceMapViewport`.
- `SpaceMapViewport` remplace `InteractiveViewer` pour stabiliser le pinch zoom, le dezoom et le recentrage sur mobile.
- Exception documentee : les vues spatiales/contemplatives conservent un fond noir et des accents blancs fixes pour preserver l'identite "nuit etoilee", meme si le reste de l'app suit les tokens de theme.
- L'ancienne vue liste `JourneyScreen`, non routee depuis la V2, est retiree. La route `/journey` reste volontairement la galaxie.
- Les constellations utilisent des titres francais lisibles et, quand disponible, un titre arabe au centre.
- Correction de titres `titleAr` qui contenaient du francais :
  - `miraj` -> `الإسراء والمعراج`
  - `guidance` -> `الهداية والإرشاد`
  - `devotion` -> `العبودية والعبادة`
- Ajout d'une validation : un `titleAr` de constellation doit contenir de l'ecriture arabe.
- La carte de constellation n'affiche plus tous les noms en permanence.
- Une etoile selectionnee ouvre un panneau stable avec arabe, translitteration, statut et CTA.

Risque restant : verifier a l'oeil sur plusieurs tailles mobile que le panneau, l'app bar et les controles ne se chevauchent pas.

### Fiche du nom

Decision : `/name/:number/experience` est la destination principale des noms.
La fiche classique `/name/:number` reste accessible en secondaire.

Etat actuel :

- Marque le nom comme `viewed`.
- Affiche constellation, tafakkur, action validee si elle existe.
- Recit affiche seulement si le statut editorial est `validated`.
- Sinon fallback sur `name.commentary` et references de `names.json`.

### Tafakkur

Decision : Tafakkur peut utiliser les donnees Journey, mais ne doit pas promouvoir de brouillon editorial.

Etat actuel :

- Recit `validated` uniquement.
- Sinon fallback commentaire classique.
- Fin de parcours marque le nom comme `meditated`.
- La page intention utilise une action validee si disponible, sinon fallback l10n.

### Actions

Decision structurante : preparer une grosse banque d'actions, mais ne rien afficher tant que l'action n'est pas validee.

Ancien modele :

```json
{
  "theme": "praise",
  "actions": ["Remercie quelqu'un..."]
}
```

Nouveau modele :

```json
{
  "theme": "praise",
  "actions": [
    {
      "id": "praise_gratitude_001",
      "textFr": "Remercie explicitement quelqu'un pour un bien reçu.",
      "editorialStatus": "needs_review",
      "duration": "short",
      "difficulty": "simple",
      "contexts": ["gratitude", "relationship"],
      "nameNumbers": [],
      "sourceNote": "",
      "sourceRefs": [],
      "reviewedBy": "",
      "validatedAt": "",
      "reviewNotes": ""
    }
  ]
}
```

Regles actuelles :

- L'app ne tire que dans les actions `validated` qui ont aussi une revue complete (`reviewedBy`, `validatedAt`, et `sourceNote` ou `sourceRefs`).
- Les actions non relues restent marquees `needs_review`; tous les themes de constellation sont maintenant `validated` avec metadata de revue. Le theme `general` reste volontairement en `needs_review` comme garde-fou non affiche.
- Selection Action Engine V2 : action validee liee directement au nom > action validee du theme de constellation > `null`.
- Les 11 constellations sont mappees vers des themes d'action ; `prophethood` utilise le theme `mission`.
- Pas de fallback generique affiche comme si l'action etait specifique.
- Chaque theme de constellation a au moins 3 actions brouillonnes pour permettre une rotation future.
- La validation detecte :
  - theme vide,
  - theme duplique,
  - constellation sans mapping vers un theme d'action,
  - mapping de constellation vers un theme d'action absent,
  - action sans id,
  - id duplique,
  - texte vide,
  - `editorialStatus` invalide,
  - `duration` invalide,
  - `difficulty` invalide,
  - `sourceRefs` vides,
  - `validatedAt` invalide,
  - action `validated` sans `reviewedBy`,
  - action `validated` sans `validatedAt`,
  - action `validated` sans `sourceNote` ni `sourceRefs`,
  - references vers un numero de nom inexistant.

Decision a prendre plus tard : choisir quelles actions passer en `validated` apres revue humaine.

## Etat des donnees

| Donnee | Etat |
| --- | --- |
| `assets/data/names.json` | 201 noms, source principale, ne pas toucher sans validation. |
| `assets/data/name_constellations.json` | 11 constellations, 201 noms couverts exactement une fois. |
| `assets/data/journey_map_layout.json` | 201 etoiles, layout stable. |
| `assets/data/name_experiences.json` | 4 experiences seulement, recits en `needs_review` dans les donnees reelles. |
| `assets/data/name_actions.json` | 13 themes, 43 actions, 4 actions liees a des noms, 40 `validated`, 3 `needs_review` (`general` uniquement); chaque theme de constellation a au moins 3 actions validees. |
| `assets/data/journey_decks.json` | `prophet_names` actif, `asmaul_husna` library-only. |

## Decisions chronologiques recentes

| Date | Domaine | Decision | Raison |
| --- | --- | --- | --- |
| 2026-04-29 | Accueil | Garder le nom du jour comme coeur de l'accueil. | Feature appreciee pour la decouverte sans friction. |
| 2026-04-29 | Accueil | Remplacer `Entrer dans ce nom` par `Decouvrir ce nom`. | Formulation plus naturelle et moins abstraite. |
| 2026-04-29 | Accueil | Supprimer les raccourcis redondants vers Voyage/Bibliotheque. | Ils doublonnaient la bottom nav. |
| 2026-04-29 | Accueil | Ajouter une reprise contextualisee et une trace de progression. | Garder une valeur de continuation sans surcharge. |
| 2026-04-29 | Voyage | Recentrer la galaxie principale. | La galaxie etait tronquee a droite. |
| 2026-04-29 | Voyage | Remplacer les labels de toutes les etoiles par un panneau de selection. | Eviter chevauchement et illisibilite. |
| 2026-04-29 | Voyage | Ajouter zoom, dezoom et recentrage. | Rendre la carte spatialement navigable. |
| 2026-04-29 | Voyage | Corriger les `titleAr` francais et valider la presence d'arabe. | Eviter le melange de langues dans les galaxies. |
| 2026-04-29 | Contenu | Ne pas afficher les recits `needs_review`. | Eviter de presenter du contenu non valide comme source. |
| 2026-04-29 | Actions | Migrer les actions vers un modele editorial structure. | Preparer une grande banque precise et validable. |
| 2026-04-29 | Actions | Ne servir que les actions `validated`. | Eviter les actions generiques/non relues. |
| 2026-04-29 | Actions | Implementer Action Engine V2 : nom > constellation > null. | Le nom du jour et la Fiche du nom peuvent recevoir une action pertinente sans fallback generique. |
| 2026-04-29 | Actions | Ajouter les themes manquants et un premier lot de 36 actions en `needs_review`. | Couvrir les 11 constellations sans exposer de brouillon non relu. |
| 2026-04-30 | Actions | Ajouter la barriere de revue : `validated` ne suffit plus sans metadata humaine. | Eviter qu'une action marquee par erreur comme validee soit affichee sans trace editoriale. |
| 2026-04-30 | Actions | Porter chaque theme de constellation a au moins 3 actions en `needs_review`. | Preparer toutes les constellations sans rendre les brouillons visibles. |
| 2026-04-30 | Editorial | Ajouter `docs/ACTION_REVIEW_V2.md` et mettre a jour le backlog contenu. | Permettre une revue humaine action par action sans manipuler directement le JSON. |
| 2026-04-30 | Actions | Promouvoir le lot pilote `praise`, `mission`, `light` en `validated`. | Rendre l'Accueil, la Fiche du nom et Tafakkur vivants sur un perimetre relu et limite. |
| 2026-04-30 | Actions | Promouvoir la deuxieme vague `trust`, `nobility`, `virtues` en `validated`. | Couvrir les actions de caractere, parole, dignite et veracite sans toucher aux themes plus sensibles. |
| 2026-04-30 | Actions | Promouvoir la troisieme vague `intercession`, `eschatology`, `purity`, `miraj`, `guidance`, `devotion` en `validated`. | Couvrir tous les themes de constellation avec des actions relues, en laissant `general` eteint. |
| 2026-04-29 | Stabilite | Garder un `user_state_last_good` et sauvegarder le JSON corrompu. | Eviter la perte silencieuse de progression locale en cas de corruption Hive. |
| 2026-04-29 | Stabilite | Rendre les notifications non bloquantes au demarrage. | Une erreur plugin/permission ne doit pas empecher l'app de s'ouvrir. |
| 2026-04-29 | Notifications | Planifier avant de persister l'heure et refuser les heures invalides. | Eviter que l'UI annonce une notification active qui n'existe pas cote OS. |
| 2026-04-29 | Navigation | Lire defensivement les `extra` de `/quiz/result`. | Les deep links ou appels incomplets ne doivent pas crasher l'ecran resultat. |
| 2026-04-29 | Offline | Desactiver le runtime fetching de `GoogleFonts`. | Respecter l'objectif offline; les assets de polices restent a bundler pour un rendu parfait. |
| 2026-04-29 | QA visuelle | Reserver des zones lisibles dans les cartes spatiales pour titres, controles et panneaux. | Eviter les chevauchements sur mobiles compacts sans changer la metaphore Journey. |
| 2026-04-29 | QA visuelle | Rendre le panneau d'etoile, les actions de la Fiche du nom, les controles Tafakkur et les metriques Profil adaptatifs. | Garder une experience sobre premium sur petits ecrans et avec textes plus longs. |
| 2026-04-29 | Offline | Bundler Amiri, Amiri Quran, Crimson Pro, Inter et Playfair Display en assets locaux. | Stabiliser le rendu typographique et supprimer les appels `GoogleFonts.*` au runtime. |
| 2026-04-29 | QA visuelle | Recentrer automatiquement les cartes spatiales au dezoom minimum. | Eviter l'effet de carte "collee" en haut apres un fort dezoom. |
| 2026-04-29 | Typographie | Augmenter la hauteur reservee aux grands titres arabes. | Eviter que la translitteration chevauche la calligraphie avec les polices locales. |
| 2026-04-29 | Arbre | Reduire la densite de labels visibles dans les vues constellation/radiale. | Garder l'arbre exploratoire lisible sur mobile sans retirer les points interactifs. |
| 2026-04-29 | Arbre | Rendre le header et les overlays plus compacts. | Eviter que la navigation et la legende masquent trop le graphe. |
| 2026-04-29 | RTL / l10n | Forcer les contenus editoriaux FR en LTR sous interface arabe tant qu'ils ne sont pas traduits. | Eviter l'inversion visuelle du francais melange a l'arabe sans modifier `names.json` ni valider de contenu nouveau. |
| 2026-04-29 | Voyage | Retirer le recentrage automatique au zoom minimum des cartes spatiales. | Eviter la sensation d'aimantation en haut et rendre le pan/dezoom plus libre. |
| 2026-04-29 | Voyage | Compactage du header constellation et remplacement du texte brut de categorie par une invitation contextualisee. | Donner plus d'espace a la carte et eviter les libelles techniques non pertinents pour l'utilisateur. |
| 2026-04-29 | Arbre | Les labels des vues constellation/radiale apparaissent seulement au zoom fort ou lors d'une selection. | Eviter l'impression de noms affiches aleatoirement et garder la vue globale comme carte exploratoire. |
| 2026-04-29 | UX wording | Remplacer le libelle public `Nom vivant` par `Fiche du nom` / `Voir la fiche`. | Le concept etait interne et peu explicite pour l'utilisateur. |
| 2026-04-29 | Voyage | Compacter le panneau d'etoile selectionnee avec CTA `Voir la fiche`, statut sur la ligne du nom et arabe contenu. | Rendre le lien vers la fiche lisible sans grosse boite vide ni bouton fleche ambigu. |
| 2026-04-29 | Voyage | Structurer le panneau d'etoile selectionnee en trois colonnes : nom, statut, fiche. | Mieux occuper l'espace horizontal et rendre chaque information immediatement identifiable. |

## Validation technique recente

Derniere validation apres correctifs fondations :

```text
flutter analyze
flutter test
dart format --output=none --set-exit-if-changed <fichiers modifies>
```

Resultat :

- `flutter analyze` : OK
- `flutter test` : OK, 116 tests passes
- `dart format --output=none --set-exit-if-changed <fichiers modifies>` : OK

Note importante : un `dart format .` precedent a normalise plusieurs fichiers deja existants. Le diff de la branche peut donc contenir du formatage hors logique metier.

Derniere validation apres QA visuelle Journey :

```text
dart format <fichiers modifies>
flutter analyze
flutter test test/features/journey/space_map_screen_test.dart test/features/journey/galaxy_map_screen_test.dart test/features/journey/name_experience_screen_test.dart test/features/journey/tafakkur_screen_test.dart test/features/profile/profile_navigation_test.dart
flutter test
```

Resultat :

- `flutter analyze` : OK
- Tests cibles Journey/Fiche du nom/Tafakkur/Profil : OK, 13 tests passes
- Suite complete : OK, 116 tests passes

Derniere validation apres sprint typo offline :

```text
flutter pub get
dart format <fichiers theme modifies>
flutter analyze
flutter test
flutter build apk --debug
```

Resultat :

- Fonts locales declarees dans `pubspec.yaml` : OK
- Appels `GoogleFonts.*` dans `lib/` : 0
- `flutter analyze` : OK
- `flutter test` : OK, 116 tests passes
- `flutter build apk --debug` : OK

Derniere validation apres retours screenshots :

```text
dart format <fichiers modifies>
flutter test test/features/journey/space_map_screen_test.dart test/features/journey/name_experience_screen_test.dart test/widget_test.dart test/features/names/list_navigation_test.dart
flutter analyze
flutter test
flutter build apk --debug
```

Resultat :

- Tests cibles cartes/Fiche du nom/home/detail : OK, 17 tests passes
- `flutter analyze` : OK
- `flutter test` : OK, 116 tests passes
- `flutter build apk --debug` : OK

Derniere validation apres polish Arbre :

```text
dart format <fichiers arbre modifies>
flutter analyze --no-pub
flutter test test/features/genealogy/genealogy_repository_test.dart test/features/profile/profile_navigation_test.dart
flutter test
flutter build apk --debug
```

Resultat :

- `flutter analyze --no-pub` : OK
- Tests cibles genealogie/profil : OK, 13 tests passes
- `flutter test` : OK, 116 tests passes
- `flutter build apk --debug` : OK

Derniere validation apres correctif RTL/LTR :

```text
dart format <fichiers modifies>
flutter analyze --no-pub
flutter test test/features/journey/name_experience_screen_test.dart test/features/journey/tafakkur_screen_test.dart test/features/journey/space_map_screen_test.dart test/features/journey/galaxy_map_screen_test.dart test/features/names/list_navigation_test.dart test/widget_test.dart
flutter test
flutter build apk --debug
```

Resultat :

- `flutter analyze --no-pub` : OK
- Tests cibles Journey/Fiche du nom/Tafakkur/Home/Detail : OK, 22 tests passes
- `flutter test` : OK, 116 tests passes
- `flutter build apk --debug` : OK

Derniere validation apres polish navigation spatiale / labels :

```text
dart format <fichiers modifies>
flutter gen-l10n
flutter analyze --no-pub
flutter test test/features/journey/space_map_screen_test.dart test/features/journey/galaxy_map_screen_test.dart test/features/genealogy/genealogy_repository_test.dart test/features/profile/profile_navigation_test.dart
flutter test
flutter build apk --debug
```

Resultat :

- `flutter analyze --no-pub` : OK
- Tests cibles Journey/Genealogie/Profil : OK, 18 tests passes
- `flutter test` : OK, 116 tests passes
- `flutter build apk --debug` : OK

Derniere validation apres clarification Fiche du nom / panneau constellation :

```text
flutter gen-l10n
dart format <fichiers modifies>
flutter analyze --no-pub
flutter test test/features/journey/space_map_screen_test.dart test/features/journey/name_experience_screen_test.dart test/widget_test.dart
flutter test
flutter build apk --debug
git diff --check
```

Resultat :

- `flutter analyze --no-pub` : OK
- Tests cibles Journey/Fiche du nom/Home : OK, 16 tests passes
- `flutter test` : OK, 116 tests passes
- `flutter build apk --debug` : OK
- `git diff --check` : OK

Derniere validation apres sprint Action Engine V2 :

```text
dart format lib/features/journey/data/repositories/journey_repository.dart lib/features/journey/presentation/name_experience_screen.dart test/features/journey/journey_repository_test.dart
flutter test test/features/journey/journey_repository_test.dart
flutter test test/features/journey/name_experience_screen_test.dart test/features/journey/tafakkur_screen_test.dart test/widget_test.dart
flutter analyze --no-pub
flutter test
flutter build apk --debug
git diff --check
```

Resultat :

- `assets/data/name_actions.json` : 13 themes, 43 actions, 4 actions liees a des noms, 0 `validated`
- Tests cibles repository/Fiche du nom/Tafakkur/Home : OK
- `flutter analyze --no-pub` : OK
- `flutter test` : OK, 119 tests passes
- `flutter build apk --debug` : OK
- `git diff --check` : OK

Derniere validation apres barriere de revue Action Engine :

```text
dart run build_runner build --delete-conflicting-outputs
dart format lib/features/journey/data/models/name_action_bank.dart lib/features/journey/data/repositories/journey_repository.dart test/features/journey/journey_repository_test.dart test/features/journey/name_experience_screen_test.dart test/features/journey/tafakkur_screen_test.dart test/widget_test.dart
flutter test test/features/journey/journey_repository_test.dart
flutter test test/features/journey/name_experience_screen_test.dart test/features/journey/tafakkur_screen_test.dart test/widget_test.dart
flutter analyze --no-pub
flutter test
flutter build apk --debug
git diff --check
```

Resultat :

- `assets/data/name_actions.json` : 13 themes, 43 actions, 4 actions liees a des noms, 0 `validated`, minimum 3 actions par theme de constellation
- `flutter analyze --no-pub` : OK
- `flutter test` : OK, 121 tests passes
- `flutter build apk --debug` : OK
- `git diff --check` : OK
- `git diff --check` : OK

Derniere validation apres promotion du lot pilote Actions :

```text
dart format test/features/journey/journey_repository_test.dart
flutter test test/features/journey/journey_repository_test.dart
flutter test test/features/journey/name_experience_screen_test.dart test/features/journey/tafakkur_screen_test.dart test/widget_test.dart
flutter analyze --no-pub
flutter test
flutter build apk --debug
git diff --check
```

Resultat :

- `assets/data/name_actions.json` : 13 themes, 43 actions, 11 `validated`, 32 `needs_review`
- Themes pilotes visibles : `praise`, `mission`, `light`
- `flutter analyze --no-pub` : OK
- `flutter test` : OK, 121 tests passes
- `flutter build apk --debug` : OK
- `git diff --check` : OK

Derniere validation apres deuxieme vague Actions :

```text
dart format test/features/journey/journey_repository_test.dart
flutter test test/features/journey/journey_repository_test.dart
flutter analyze --no-pub
flutter test
flutter build apk --debug
git diff --check
```

Resultat :

- `assets/data/name_actions.json` : 13 themes, 43 actions, 22 `validated`, 21 `needs_review`
- Themes visibles / prets : `praise`, `mission`, `trust`, `nobility`, `virtues`, `light`
- `flutter analyze --no-pub` : OK
- `flutter test` : OK, 121 tests passes
- `flutter build apk --debug` : OK

Derniere validation apres couverture complete des themes d'actions :

```text
dart format test/features/journey/journey_repository_test.dart
flutter test test/features/journey/journey_repository_test.dart
flutter analyze --no-pub
flutter test
flutter build apk --debug
git diff --check
```

Resultat :

- `assets/data/name_actions.json` : 13 themes, 43 actions, 40 `validated`, 3 `needs_review` (`general` uniquement)
- Tous les themes de constellation ont au moins 3 actions validees
- `flutter analyze --no-pub` : OK
- `flutter test` : OK, 121 tests passes
- `flutter build apk --debug` : OK

Derniere validation apres sprint Alpha hardening :

```text
dart format lib test
flutter test test/features/journey/constellation_detail_screen_test.dart test/features/journey/space_map_viewport_test.dart test/core/providers/journey_providers_test.dart
flutter analyze --no-pub
flutter test
flutter build apk --debug
git diff --check
dart format --output=none --set-exit-if-changed lib test
```

Resultat :

- `pubspec.yaml` synchronise sur `2.0.0-alpha.3+3`
- `_hexToColor` supprime des widgets Journey au profit de `hexToColor`
- `journeyProgressSummaryProvider` converti en `FutureProvider<NameProgressSummary>`
- Tests directs ajoutes pour `SpaceMapViewport` : dezoom par pincement et bouton de dezoom restent centres
- Ancien `JourneyScreen` non route supprime
- `flutter analyze --no-pub` : OK
- `flutter test` : OK, 122 tests passes
- `flutter build apk --debug` : OK
- `git diff --check` : OK

## Decision 2026-04-30 - Bibliotheque de lancement

- Pour le lancement, `Revision libre` est retiree des entrees visibles : elle duplique trop les flashcards et n'apporte pas assez de valeur distincte.
- Les `Parcours thematiques` restent une intention produit, mais ne sont pas exposes tant qu'ils ne portent pas de vrais modules mixtes relus humainement.
- Les modules mixtes futurs pourront combiner des corpus distincts seulement avec une ligne editoriale claire et des contenus valides.
- Les routes/code Study peuvent rester en place pour eviter un refactor large, mais elles ne doivent plus etre presentees comme experience principale de lancement.
- La Bibliotheque doit rester une entree par corpus. Les outils QCM/flashcards restent accessibles dans le deck concerne pour eviter une redondance avec l'entree globale.
- Dans le Profil, la constellation personnelle reste la version de reference actuelle ; le panneau de selection doit presenter le nom sur toute la largeur et ouvrir la fiche au tap.

## Decision 2026-05-01 - Durcissement beta Android

- La beta publique initiale est declaree en FR uniquement : l'ARB arabe reste conserve pour la suite, mais l'app ne l'annonce pas comme locale supportee tant que les chaines ne sont pas relues.
- La version applicative passe sur `2.0.0-beta.1+7` pour aligner le build distribue avec l'etat release candidate et garantir une mise a jour Android au-dessus des alphas locales.
- Les icones launcher Android sont generees depuis une direction visuelle nuit/or proche du logo fourni : croissant, constellation et calligraphie centrale.
- Le build `release` ne doit plus retomber sur la cle debug. Un build release sans `android/key.properties` echoue explicitement.
- Les secrets de signature (`android/key.properties`, keystores et formats associes) restent non suivis et doivent etre sauvegardes hors Git par le porteur du projet.
- Les tags de version conserves apres `v1.5.1` doivent rester des jalons lisibles : les tags alpha/brouillons peuvent etre retires une fois `v2.0.0-beta.1` publie.

## Decision 2026-05-01 - Patch beta 2 : entrainement Husna et Voyage plus immersif

- La version applicative passe sur `2.0.0-beta.2+8` pour preparer un dernier build beta incrementiel.
- Les QCM et flashcards deviennent multi-deck : le meme moteur peut servir les 201 noms du Prophete et Asma al-Husna, sans melanger les corpus.
- Asma al-Husna reste dans la Bibliotheque uniquement. Le Voyage principal reste dedie aux 201 noms du Prophete.
- Le Profil et le Voyage ne doivent pas employer de score spirituel. La progression reste exprimee visuellement et par les statuts sobres `viewed`, `meditated`, `practiced`, `recognized`.
- Dans la carte de constellation, la consigne permanente est retiree pour renforcer l'immersion. La progression apparait par l'intensite des etoiles et des lignes, pas par des badges ou points.

## Decision 2026-05-02 - Beta release finale

- La version applicative passe sur `2.0.0-beta.4+10`.
- Les headers noirs du Voyage sont retires sur les cartes galaxie et constellations : la navigation devient flottante sur le ciel pour preserver l'immersion.
- Le bouton retour des cartes Voyage doit rester au-dessus de la couche interactive zoom/pan.
- La page Profil conserve la lanterne comme representation personnelle, mais elle utilise uniquement les vraies donnees locales. Aucun mode preview ou progression fictive ne doit partir en beta.
- La lanterne du Profil represente la progression globale des contenus explorables, pas seulement le Voyage des 201 noms : elle agrege les Noms du Prophete et Asma al-Husna aujourd'hui, puis chaque futur corpus devra s'y brancher explicitement. Les compteurs detailles Journey restent reserves aux 201 noms pour ne pas melanger les univers.
- Tout futur contenu explorable ajoute a l'application doit declarer sa progression et alimenter automatiquement la lanterne du Profil. Pour un agent IA, un nouveau module n'est pas considere complet tant qu'il n'est pas connecte a cette illumination globale, sauf decision produit explicite contraire.
- Le rendu de la lanterne peut utiliser une animation douce et un halo progressif, pilotes par cette progression globale. L'effet doit rester contemplatif, sans score spirituel, badge ni recompense bruyante.

## Dette et risques ouverts

### Priorite haute

- Valider sur emulateur ou telephone reel les retouches QA Journey deja passees en tests widget.
- Garder `general` non affiche tant qu'aucune decision produit explicite ne transforme ce theme en vrai contenu utilisateur.
- Faire une revue partenaire des 40 actions de constellation validees avant une release publique.
- Valider les 4 experiences existantes ou les garder masquees.
- Sauvegarder la cle Android release locale et `android/key.properties` avant de diffuser largement la beta.

### Priorite moyenne

- Valider visuellement le rendu des polices locales sur emulateur ou telephone reel.
- Nettoyer les imports/providers ou `core` connait trop certaines features.
- Continuer l10n arabe avant d'ajouter `ar` aux locales publiques : beaucoup de chaines restent FR ou partiellement encodees. Les contenus sources FR sont forces en LTR en attendant une vraie traduction/revue.
- Decouper certains gros widgets si > 80 lignes quand le scope s'y prete.

### Priorite basse

- Revoir les docs anciennes pour eviter la divergence avec la V2.
- Construire une vraie strategie de screenshots/QA visuelle.
- Preparer les conventions pour Sira, Shama'il et Khasa'is.

## Proposition de prochains sprints

### Sprint A - QA visuelle Journey

Objectif : rendre Voyage vraiment fiable sur mobile.

- Tester Galaxy, Deck map, Constellation map sur mobile petit et grand.
- Ajuster app bar, panneau de selection, controles de zoom.
- Verifier contraste, zones de tap, accessibilite.
- Ajouter tests widget si un bug de layout est reproduit.

### Sprint B - Matrice editoriale des actions

Objectif : definir la structure avant de produire du volume.

- Lister les themes d'actions alignes sur les constellations.
- Definir `duration`, `difficulty`, `contexts`, `nameNumbers`, `sourceNote`.
- Creer un template de revue humaine.
- Mettre a jour `docs/content_backlog_journey.md`.
- Ne valider aucune action sans revue.

### Sprint C - Remplissage pilote

Objectif : produire un petit lot de contenu valide, pas encore "enorme".

- Choisir 1 ou 2 constellations pilotes.
- Rediger les actions hors IA ou avec revue humaine explicite.
- Passer certaines actions en `validated`.
- Verifier rendu Accueil, Fiche du nom, Tafakkur.

### Sprint D - Tafakkur / recits

Objectif : donner de la profondeur a la Fiche du nom sans perdre la rigueur.

- Valider sourceRefs, reviewedBy, validatedAt.
- Promouvoir seulement quelques recits en `validated`.
- Garder fallback commentaire pour tout le reste.

## Notes de workflow

- Pour les fichiers generes Freezed/l10n, modifier la source puis regenerer.
- Pour les JSON editoriaux, preferer petits lots relus plutot qu'un gros dump.
- Apres chaque sprint, relancer au minimum :

```text
flutter analyze
flutter test
dart format --output=none --set-exit-if-changed .
git diff --check
```

- Mettre a jour ce fichier avant de passer au sprint suivant.
