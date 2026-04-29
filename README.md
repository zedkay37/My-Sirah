# Sirah Hub

Application Flutter offline-first pour découvrir, connaître et aimer le Prophète ﷺ.

La source de vérité produit actuelle est la V2 Journey :

> Voyage stellaire autour des noms du Prophète ﷺ.

Le journal vivant des décisions et du contexte de développement est dans
[`DECISIONS.md`](DECISIONS.md).

Chaque nom est une étoile. Chaque constellation structure un thème. Chaque étoile mène vers un Nom vivant qui articule sens, compréhension, contemplation, intention et mémorisation douce.

## Vision Produit

Sirah Hub n'est plus une encyclopédie de fiches, un hub de modules ou une app de quiz religieux.

Le parcours principal est :

```text
Accueil -> Voyage -> Nom vivant -> Tafakkur -> Action -> Profil
```

La boucle utilisateur à respecter partout :

```text
Découvrir -> Comprendre -> Contempler -> Incarner -> Mémoriser
```

## Surfaces Actuelles

| Surface | Rôle |
| --- | --- |
| Accueil | Rituel quotidien et entrée vers le Nom vivant |
| Voyage | Carte stellaire immersive des noms du Prophète ﷺ |
| Nom vivant | Destination principale autour d'un nom |
| Bibliothèque | Recherche, listes, fiches, révision, QCM et flashcards |
| Profil | Miroir doux du chemin parcouru |
| Arbre | Généalogie prophétique, utile mais secondaire au Journey |

`Discover` est legacy. Les routes `/discover*` existent seulement pour compatibilité et redirigent vers la Bibliothèque.

## État V2

- Les 201 noms du Prophète ﷺ sont représentés dans le Journey.
- Chaque nom est présent exactement une fois dans les constellations.
- Le layout Journey contient 201 étoiles.
- Asmāʾ al-Ḥusnā reste Bibliothèque-only et ne doit pas apparaître dans le Voyage.
- Le Nom vivant fonctionne même sans récit validé, via `name.commentary` et les références existantes.
- Les récits non validés ne sont pas affichés comme récits.
- L'accueil ne valide pas directement `practiced`.
- QCM, flashcards et révision libre mettent à jour `recognized`.
- `learned` reste un état legacy Study/V1, pas une métrique produit Journey.

## Contraintes Produit

À ne pas faire maintenant :

- ajouter de nouveaux modules produit ;
- ajouter un backend ;
- générer automatiquement du contenu religieux ;
- inventer récits, tafakkur, actions ou interprétations ;
- gamifier le dhikr, les salawat ou la progression spirituelle ;
- ajouter score spirituel, leaderboard ou compétition religieuse ;
- étendre Journey à Asmāʾ al-Ḥusnā ;
- créer un moteur 3D ou une carte stellaire trop complexe.

Le produit doit rester sobre, offline-first, respectueux et honnête sur le contenu validé.

## Stack

- Flutter
- Riverpod
- go_router
- Hive
- Freezed
- JSON assets
- l10n ARB source files

## Données

| Asset | Rôle |
| --- | --- |
| `assets/data/names.json` | Source des 201 noms. Ne pas modifier sans validation explicite. |
| `assets/data/name_constellations.json` | Couverture Journey des noms par constellation. |
| `assets/data/journey_map_layout.json` | Positions déterministes des constellations et étoiles. |
| `assets/data/name_experiences.json` | Expériences associées aux noms. |
| `assets/data/name_actions.json` | Actions/intérêts d'incarnation existants. |
| `assets/data/journey_decks.json` | Decks Journey/Bibliothèque et statuts `active` / `library_only`. |

## Progression Journey

La progression principale est :

```text
viewed -> meditatedNames -> practicedNames -> recognizedNames
```

Source logique :

- `NameProgressResolver`
- `journeyProgressResolverProvider`
- `journeyProgressSummaryProvider`

Persistance :

- `SettingsNotifier` est le writer Hive.
- Ne pas écrire directement dans Hive hors `HiveSource` / `SettingsNotifier`.

Compatibilité :

- `learned` peut encore être mis à jour par certains flux Study/V1 pour compatibilité.
- `learned` ne doit pas être présenté comme métrique principale dans Accueil, Journey, Profil, listes ou favoris.

## Navigation

Routes produit principales :

| Route | Surface |
| --- | --- |
| `/` | Accueil |
| `/journey` | Voyage |
| `/journey/deck/prophet_names` | Carte des noms du Prophète ﷺ |
| `/name/:number/experience` | Nom vivant |
| `/name/:number/tafakkur` | Tafakkur |
| `/library` | Bibliothèque |
| `/library/deck/prophet_names` | Bibliothèque des noms |
| `/library/deck/asmaul_husna` | Bibliothèque Asmāʾ al-Ḥusnā |
| `/profile` | Profil |
| `/tree` | Arbre |

Les taps primaires vers un nom prophétique doivent ouvrir `/name/:number/experience`.

## l10n

Règles :

- modifier les fichiers source `l10n/intl_*.arb` ;
- ne pas éditer `lib/l10n/app_localizations*.dart` à la main ;
- lancer `flutter gen-l10n` après changement ARB ;
- garder FR et AR cohérents, avec wording neutre si une traduction n'est pas validée.

## Contenu Religieux

Codex ne doit pas rédiger de nouveau contenu religieux doctrinal.

Autorisé :

- réorganiser du contenu existant ;
- afficher `name.commentary` existant ;
- afficher sources/références existantes ;
- ajouter des champs de statut éditorial ;
- préparer un backlog éditorial interne.

Interdit :

- inventer des récits de Sirah ;
- inventer des tafakkur spécifiques ;
- inventer des actions religieuses spécifiques ;
- présenter un brouillon comme validé.

## Tests Et Validation

Avant commit sur un sprint fonctionnel :

```powershell
flutter gen-l10n
flutter analyze
flutter test
```

Si les modèles Freezed/JSON changent :

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Tests importants :

- couverture Journey 201/201 ;
- aucune étoile orpheline ou doublon ;
- routes primaires vers Nom vivant ;
- QCM/Flashcards sans session ;
- no direct Hive writes hors writers attendus ;
- l10n source/générée cohérente.

## Documentation Legacy

Les documents historiques dans `docs/` peuvent contenir des détails V1/V1.5 utiles, mais ils ne sont pas la source de vérité produit actuelle.

Ordre de confiance :

1. `README.md`
2. `docs/JOURNEY_GUARDRAILS.md`
3. `docs/V2_1_AUDIT_BRIEF.md`
4. `docs/JOURNEY_RESTRUCTURE_PLAN.md`
5. docs V1/V1.5 uniquement pour contexte historique

Si une doc mentionne timer 8 secondes, Discover comme centre, `learned` comme métrique principale ou nouveaux modules religieux, elle est legacy.
