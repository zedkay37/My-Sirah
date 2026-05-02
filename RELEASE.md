# RELEASE.md — Guide beta Android V2

Etat courant : `v2.0.0-beta.3`

La beta Android est une beta fermee FR-only. Elle sert a valider le parcours :

```text
Accueil -> Voyage -> Nom vivant -> Tafakkur -> Action -> Profil
```

## Pre-requis

- Flutter/Dart installes.
- Android Studio installe.
- JDK Android Studio disponible.
- `android/key.properties` present localement.
- `android/sirah-hub-release.jks` sauvegarde hors Git.

Les deux fichiers de signature sont secrets et ignores par Git. Sans eux, les futures mises a jour ne pourront pas etre signees avec la meme cle.

## Version

La version se regle dans `pubspec.yaml` :

```yaml
version: 2.0.0-beta.3+9
```

- `2.0.0-beta.3` = nom visible de version.
- `+9` = `versionCode` Android. Il doit augmenter a chaque build diffuse.

## Validation standard

Avant de diffuser une beta :

```powershell
flutter analyze --no-pub
flutter test
git diff --check
flutter build apk --debug
flutter build apk --release
flutter build apk --release --split-per-abi
flutter build appbundle --release
```

Verifier ensuite la signature APK :

```powershell
$env:JAVA_HOME='C:\Program Files\Android\Android Studio\jbr'
$env:PATH="$env:JAVA_HOME\bin;$env:PATH"
& "$env:ANDROID_SDK_ROOT\build-tools\36.1.0-rc1\apksigner.bat" verify --verbose --print-certs build\app\outputs\flutter-apk\app-release.apk
```

Le certificat attendu pour la beta locale :

```text
CN=Sirah Hub, OU=Release, O=Sirah Hub, L=Paris, ST=Ile-de-France, C=FR
```

## Artifacts Android

Pour testeurs Android recents :

```text
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

Pour installation simple sans choisir l'architecture :

```text
build/app/outputs/flutter-apk/app-release.apk
```

Pour Play Console :

```text
build/app/outputs/bundle/release/app-release.aab
```

## Checklist beta fermee

- [ ] `git status` propre hors `AGENTS.md` local.
- [ ] `pubspec.yaml` versionCode incremente.
- [ ] APK release signe par la cle release locale.
- [ ] `android/key.properties` et `.jks` non suivis par Git.
- [ ] APK installe sur au moins un telephone reel.
- [ ] Accueil, Voyage, Nom vivant, Tafakkur, Bibliotheque, Profil et Arbre testes rapidement.
- [ ] Notifications testees au moins une fois sur Android 13+.
- [ ] Aucune promesse AR publique tant que `intl_ar.arb` n'est pas relu.

## Store listing provisoire

Titre :

```text
Asmāʾ an-Nabī
```

Description courte :

```text
Explorer les 201 noms du Prophète ﷺ dans une expérience sobre et contemplative.
```

Description longue :

```text
Sirah Hub est une application mobile hors ligne pour découvrir, contempler et mémoriser les 201 noms du Prophète Muḥammad ﷺ.

Chaque nom devient une étoile dans un voyage stellaire : accueil quotidien, constellations, fiche du nom, tafakkur, action sobre et progression personnelle.

L'application fonctionne sans compte, sans analytics et sans publicité. Les contenus sensibles restent protégés par un statut éditorial : seuls les éléments validés sont affichés comme tels.
```

## Confidentialite

L'application ne collecte aucune donnee personnelle et n'utilise aucun backend. Les favoris, progressions, preferences et notifications restent stockes localement sur l'appareil.
