# Journal de decisions - Sirah Hub / Asma an-Nabi

Derniere mise a jour : 2026-04-29
Branche de travail observee : `feat/v2-journey-restructure`
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
| `docs/RELEASE_AUDIT_V2.md` et `docs/V2_1_AUDIT_BRIEF.md` | Audits precedents et risques identifies. |

## Vision actuelle

La V1 reste focalisee sur les 201 noms du Prophete Muhammad ﷺ, mais l'architecture doit rester ouverte vers un ecosysteme plus large : Sira, Khasa'is, Shama'il, hadiths thematiques, salawat et invocations.

Le produit n'est pas une simple encyclopedie de fiches. La direction retenue est :

```text
Accueil -> Voyage -> Nom vivant -> Tafakkur -> Action -> Profil
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
- La carte de deck utilise une navigation spatiale via `InteractiveViewer`.
- Ajout de `SpaceMapViewport` reutilisable avec zoom, dezoom et recentrage.
- Les constellations utilisent des titres francais lisibles et, quand disponible, un titre arabe au centre.
- Correction de titres `titleAr` qui contenaient du francais :
  - `miraj` -> `الإسراء والمعراج`
  - `guidance` -> `الهداية والإرشاد`
  - `devotion` -> `العبودية والعبادة`
- Ajout d'une validation : un `titleAr` de constellation doit contenir de l'ecriture arabe.
- La carte de constellation n'affiche plus tous les noms en permanence.
- Une etoile selectionnee ouvre un panneau stable avec arabe, translitteration, statut et CTA.

Risque restant : verifier a l'oeil sur plusieurs tailles mobile que le panneau, l'app bar et les controles ne se chevauchent pas.

### Nom vivant

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
      "sourceNote": ""
    }
  ]
}
```

Regles actuelles :

- L'app ne tire que dans les actions `validated`.
- Les actions existantes ont ete conservees mais marquees `needs_review`.
- Pas de fallback generique en Nom vivant si le nom n'a pas d'experience specifique.
- La validation detecte :
  - theme vide,
  - theme duplique,
  - action sans id,
  - id duplique,
  - texte vide,
  - `editorialStatus` invalide,
  - `duration` invalide,
  - `difficulty` invalide,
  - references vers un numero de nom inexistant.

Decision a prendre plus tard : definir la matrice editoriale complete avant de remplir massivement.

## Etat des donnees

| Donnee | Etat |
| --- | --- |
| `assets/data/names.json` | 201 noms, source principale, ne pas toucher sans validation. |
| `assets/data/name_constellations.json` | 11 constellations, 201 noms couverts exactement une fois. |
| `assets/data/journey_map_layout.json` | 201 etoiles, layout stable. |
| `assets/data/name_experiences.json` | 4 experiences seulement, recits en `needs_review` dans les donnees reelles. |
| `assets/data/name_actions.json` | Structure editoriale migree, actions existantes en `needs_review`. |
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
| 2026-04-29 | Stabilite | Garder un `user_state_last_good` et sauvegarder le JSON corrompu. | Eviter la perte silencieuse de progression locale en cas de corruption Hive. |
| 2026-04-29 | Stabilite | Rendre les notifications non bloquantes au demarrage. | Une erreur plugin/permission ne doit pas empecher l'app de s'ouvrir. |
| 2026-04-29 | Notifications | Planifier avant de persister l'heure et refuser les heures invalides. | Eviter que l'UI annonce une notification active qui n'existe pas cote OS. |
| 2026-04-29 | Navigation | Lire defensivement les `extra` de `/quiz/result`. | Les deep links ou appels incomplets ne doivent pas crasher l'ecran resultat. |
| 2026-04-29 | Offline | Desactiver le runtime fetching de `GoogleFonts`. | Respecter l'objectif offline; les assets de polices restent a bundler pour un rendu parfait. |

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

## Dette et risques ouverts

### Priorite haute

- Valider visuellement Accueil + Voyage sur emulateur ou telephone reel.
- Definir une matrice editoriale d'actions avant de remplir massivement.
- Completer `docs/content_backlog_journey.md` avec le nouveau modele `NameActionItem`.
- Valider les 4 experiences existantes ou les garder masquees.

### Priorite moyenne

- Ajouter les fichiers de polices offline pour stabiliser le rendu typographique sans runtime fetching.
- Nettoyer les imports/providers ou `core` connait trop certaines features.
- Continuer l10n arabe : beaucoup de chaines restent FR ou partiellement encodees.
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
- Verifier rendu Accueil, Nom vivant, Tafakkur.

### Sprint D - Tafakkur / recits

Objectif : donner de la profondeur au Nom vivant sans perdre la rigueur.

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
