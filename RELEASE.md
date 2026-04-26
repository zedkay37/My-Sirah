# RELEASE.md — Guide de publication V1.0.0

## Prérequis

- Flutter 3.24+ installé (`flutter --version`)
- Xcode 15+ (pour iOS)
- Android Studio + JDK 17+ (pour Android)
- Compte Apple Developer (99 $/an)
- Compte Google Play Console (25 $ unique)

---

## Avant de builder

### 1. Vérifier la version dans pubspec.yaml

```yaml
version: 1.0.0+1
#         ↑ versionName   ↑ versionCode (incrémenter à chaque upload)
```

### 2. Remplacer l'icône placeholder

L'icône actuelle est le logo Flutter par défaut. Elle **doit** être remplacée avant de soumettre.

- Préparer une image **1024×1024 px** sans fond transparent (PNG)
- Utiliser le package `flutter_launcher_icons` ou générer manuellement :
  - iOS : placer dans `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
  - Android : remplacer les dossiers `mipmap-*` dans `android/app/src/main/res/`

### 3. Remplacer le splash screen

- iOS : modifier `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- Android : modifier `android/app/src/main/res/drawable/launch_background.xml`

---

## Build iOS

### Générer le certificat et le provisioning profile (une seule fois)

1. Dans Xcode → **Signing & Capabilities** → activer "Automatically manage signing"
2. Sélectionner votre Team ID
3. Bundle Identifier : `com.sirah.sirah_app` (ou le vôtre)

### Build

```bash
flutter build ipa --release
```

L'archive `.ipa` est générée dans `build/ios/ipa/`.

### Upload vers App Store Connect

```bash
xcrun altool --upload-app -f build/ios/ipa/sirah_app.ipa \
  -t ios --apiKey <API_KEY> --apiIssuer <ISSUER_ID>
```

Ou via **Xcode → Organizer → Distribute App**.

---

## Build Android

### Générer le keystore (une seule fois — NE PAS PERDRE)

```bash
keytool -genkey -v \
  -keystore android/asma-nabi-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias asma-nabi-key
```

Répondre aux questions (nom, organisation, pays).

### Configurer key.properties

Créer le fichier `android/key.properties` (ignoré par git) :

```properties
storePassword=<votre_mot_de_passe_store>
keyPassword=<votre_mot_de_passe_cle>
keyAlias=asma-nabi-key
storeFile=../asma-nabi-release.jks
```

⚠️ Ne jamais committer ce fichier ni le `.jks`.

### Build AAB (recommandé pour Play Store)

```bash
flutter build appbundle --release
```

Le fichier est dans `build/app/outputs/bundle/release/app-release.aab`.

### Build APK (test / sideload)

```bash
flutter build apk --release --split-per-abi
```

---

## Checklist avant soumission

### App Store (iOS)

- [ ] Icône 1024×1024 sans fond transparent
- [ ] Captures d'écran 6.7" (iPhone 15 Pro Max) — minimum 3
- [ ] Captures d'écran 5.5" (iPhone 8 Plus) — minimum 3
- [ ] Titre : `Asmāʾ an-Nabī — Noms du Prophète ﷺ`
- [ ] Sous-titre : `Les 201 noms de Muḥammad ﷺ`
- [ ] Description courte (30 cars max) : `201 noms du Prophète ﷺ`
- [ ] Description longue : voir section ci-dessous
- [ ] Mots-clés : `islam,prophète,muhammad,noms,coran,apprentissage,arabe`
- [ ] Catégorie : **Education** (principale), Religion & Spirituality (secondaire)
- [ ] Classification : 4+ (aucun contenu sensible)
- [ ] URL politique de confidentialité : voir section ci-dessous
- [ ] Support URL / Marketing URL

### Google Play

- [ ] Icône 512×512
- [ ] Feature graphic 1024×500
- [ ] Captures d'écran téléphone (au moins 2)
- [ ] Titre (30 chars) : `Asmāʾ an-Nabī`
- [ ] Description courte (80 chars) : `Apprenez les 201 noms du Prophète Muḥammad ﷺ`
- [ ] Description longue : voir section ci-dessous
- [ ] Catégorie : **Éducation**
- [ ] Classement de contenu : Tout public
- [ ] Déclaration de confidentialité

---

## Description store (FR)

### Titre
`Asmāʾ an-Nabī — Les 201 noms du Prophète ﷺ`

### Description courte
`Apprenez, méditez et mémorisez les 201 noms du Prophète Muḥammad ﷺ.`

### Description longue

```
Asmāʾ an-Nabī est un compagnon spirituel pour découvrir et mémoriser les 201 noms du Prophète Muḥammad ﷺ, tirés du Dalāʾil al-Khayrāt et des sources classiques.

✦ UN NOM CHAQUE JOUR
Chaque matin, un nouveau nom vous attend — avec son étymologie, ses commentaires classiques et ses références coraniques et hadithiques.

✦ EXPLORATION COMPLÈTE
Parcourez les 201 noms, filtrés par catégorie, ou recherchez en arabe, translittération ou sens. Chaque fiche détaille l'étymologie, les commentaires des savants classiques et les sources.

✦ QUIZ ET MÉMORISATION
Deux modes pour ancrer les noms dans la mémoire :
• QCM : retrouvez le nom à partir de sa description
• Flashcards : retournez les cartes, confirmez ce que vous savez

✦ CONSTELLATION DE PROGRESSION
Visualisez votre avancée : 201 étoiles s'illuminent au fil de votre apprentissage. Chaque nom appris est une lumière de plus dans votre constellation.

✦ 3 THÈMES VISUELS
• Clair (éditorial sobre)
• Sombre (nuit et or)
• Féminin (constellation colorée)

✦ 100% HORS LIGNE
Aucun compte, aucune connexion requise. Vos données restent sur votre appareil.

✦ NOTIFICATION QUOTIDIENNE
Recevez le nom du jour à l'heure de votre choix — une invitation douce à la contemplation.

Une application épurée, respectueuse, sans publicité ni gamification agressive. Pour ceux qui aiment le Prophète ﷺ et souhaitent le connaître davantage.
```

---

## Politique de confidentialité

L'app ne collecte aucune donnée personnelle, n'utilise aucun réseau et ne transmet rien à des serveurs tiers. La politique de confidentialité minimale ci-dessous peut être hébergée sur une page GitHub Pages ou Notion :

```
Politique de confidentialité — Asmāʾ an-Nabī

Cette application ne collecte, ne stocke ni ne transmet aucune donnée personnelle.
Toutes les données (favoris, progression, préférences) sont stockées localement
sur votre appareil et ne quittent jamais celui-ci.
Aucun compte utilisateur n'est requis. Aucune analytics. Aucune publicité.

Contact : mohamedw.bechrouri@gmail.com
```

---

## Versionnement

| Version | versionCode | Description |
|---|---|---|
| 1.0.0 | 1 | Lancement initial — 201 noms, 3 thèmes, quiz, constellation |

À chaque update Play Store / App Store, incrémenter `versionCode` dans `pubspec.yaml`.
