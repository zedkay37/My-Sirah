# Sirah Hub V2.1 Audit Brief

Date : 2026-04-28  
Branche : `feat/v2-journey-restructure`

## Perimetre

V2.1 restructure l'app autour de deux surfaces principales :

- `Voyage` : exploration spatiale des noms du Prophete ﷺ.
- `Bibliotheque` : listes, fiches, revision, quiz, flashcards et Husna.

`Discover` n'est plus une surface produit active. Les routes `/discover*` restent uniquement en redirection de compatibilite.

## Points A Relire En Priorite

1. Navigation
   - bottom bar : Accueil, Voyage, Bibliotheque, Profil, Arbre
   - `/discover*` redirige vers `/library*`
   - `/journey` ouvre la galaxy map
   - `asmaul_husna` reste Bibliotheque only

2. Journey data
   - `assets/data/name_constellations.json`
   - `assets/data/name_experiences.json`
   - `assets/data/name_actions.json`
   - `assets/data/journey_decks.json`
   - `assets/data/journey_map_layout.json`

3. Progression
   - `SettingsNotifier` reste le seul writer de `UserState`
   - nouveaux champs : `meditatedNames`, `practicedNames`, `recognizedNames`
   - `NameProgressResolver` centralise les statuts Journey
   - `learned` reste un etat legacy Study/V1, pas une metrique produit Journey

4. UI produit
   - Home recentre sur le rituel quotidien
   - Bibliotheque absorbe les acces rationnels
   - Journey utilise `CustomPainter` + `InteractiveViewer`
   - Tafakkur devient une mini-session en 4 pages

5. Compatibilite
   - `assets/data/names.json` non modifie
   - Profile et Tree conserves
   - routes v1 critiques conservees ou redirigees

## Validations Locales

- `flutter gen-l10n` : OK
- `ar` : 75 messages non traduits, etat connu avant release
- `flutter analyze` : OK
- `flutter test` : OK, derniere baseline attendue 102 tests

## Garde-Fous Ajoutes Avant Audit

- Voir `docs/JOURNEY_GUARDRAILS.md`.
- Les taps primaires depuis liste des noms et favoris ouvrent le Nom vivant.
- Les cartes de noms prophetiques utilisent `JourneyNameStage`, plus `learned`.
- `learned` est documente comme compatibilite legacy Study/V1.

## Sprint H Integre Apres Audit

- `markViewed` rafraichit maintenant `lastSeen` meme pour un nom deja vu.
- QCM et Flashcards affichent un fallback Bibliotheque si aucune session n'existe.
- Le resultat quiz ne depend plus de `pop()` pour "Rejouer".
- Les notifications ouvrent le Nom vivant.
- L'onglet Apprendre de Bibliotheque n'imbrique plus un second `Scaffold`.
- La galaxie Journey ne montre plus Asma al-Husna.
- Le Nom vivant remplace le placeholder editorial par une section "Comprendre ce nom".

## Risques Connus

- Locale AR encore partielle : decision release necessaire avant publication.
- Diff volumineux : audit recommande par modules, pas en lecture lineaire.
- Plusieurs fichiers generes l10n/freezed inclus : verifier qu'ils correspondent aux sources ARB/modeles.
- Les cartes spatiales sont testees en widget, mais un passage manuel visuel sur mobile/desktop reste utile.

## Interdits Respectes

- Pas de modification de `assets/data/names.json`.
- Pas de backend.
- Pas d'IA.
- Pas de 3D.
- Pas de nouveau module religieux.
- Pas de quiz Husna.
- Pas de verrouillage de contenu essentiel.
- Pas de persistance Journey hors `SettingsNotifier`.
