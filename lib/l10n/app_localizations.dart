import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sirah Hub'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir'**
  String get navDiscover;

  /// No description provided for @navJourney.
  ///
  /// In fr, this message translates to:
  /// **'Voyage'**
  String get navJourney;

  /// No description provided for @navLibrary.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque'**
  String get navLibrary;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @navTree.
  ///
  /// In fr, this message translates to:
  /// **'Arbre'**
  String get navTree;

  /// No description provided for @errorPageNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Page introuvable'**
  String get errorPageNotFound;

  /// No description provided for @errorBackHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get errorBackHome;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Les 201 noms du Prophète ﷺ'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Apprenez, méditez, connectez-vous.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingWelcomeCta.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingWelcomeCta;

  /// No description provided for @onboardingThemeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre ambiance'**
  String get onboardingThemeTitle;

  /// No description provided for @onboardingThemeCta.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get onboardingThemeCta;

  /// No description provided for @onboardingNotifTitle.
  ///
  /// In fr, this message translates to:
  /// **'Un nom chaque jour'**
  String get onboardingNotifTitle;

  /// No description provided for @onboardingNotifSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevez le nom du jour à l\'heure qui vous convient'**
  String get onboardingNotifSubtitle;

  /// No description provided for @onboardingNotifActivate.
  ///
  /// In fr, this message translates to:
  /// **'Activer les notifications'**
  String get onboardingNotifActivate;

  /// No description provided for @onboardingNotifLater.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get onboardingNotifLater;

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'As-salāmu ʿalaykum'**
  String get homeGreeting;

  /// No description provided for @homeTagline.
  ///
  /// In fr, this message translates to:
  /// **'Connaître, aimer et suivre le Prophète ﷺ'**
  String get homeTagline;

  /// No description provided for @homeCategorySection.
  ///
  /// In fr, this message translates to:
  /// **'Explorer par catégorie'**
  String get homeCategorySection;

  /// No description provided for @homeDiscoverName.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir ce nom'**
  String get homeDiscoverName;

  /// No description provided for @homeDailyActionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Action du jour'**
  String get homeDailyActionTitle;

  /// No description provided for @homeExploreTodayName.
  ///
  /// In fr, this message translates to:
  /// **'Entrer dans ce nom'**
  String get homeExploreTodayName;

  /// No description provided for @homeClassicNameTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Fiche classique'**
  String get homeClassicNameTooltip;

  /// No description provided for @homeContinueJourneyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Continuer mon voyage'**
  String get homeContinueJourneyTitle;

  /// No description provided for @homeContinueJourneyFallback.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre depuis le nom du jour'**
  String get homeContinueJourneyFallback;

  /// No description provided for @homeContinueJourneySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine étoile dans {constellation}'**
  String homeContinueJourneySubtitle(String constellation);

  /// No description provided for @homeJourneyShortcutSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrer dans la carte stellaire'**
  String get homeJourneyShortcutSubtitle;

  /// No description provided for @homeLibraryShortcutSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Listes, fiches et révisions'**
  String get homeLibraryShortcutSubtitle;

  /// No description provided for @homeCategoryViewed.
  ///
  /// In fr, this message translates to:
  /// **'{viewed}/{total} découverts'**
  String homeCategoryViewed(int viewed, int total);

  /// No description provided for @homeNameNumber.
  ///
  /// In fr, this message translates to:
  /// **'#{number}'**
  String homeNameNumber(String number);

  /// No description provided for @discoverAllNames.
  ///
  /// In fr, this message translates to:
  /// **'Tous les noms'**
  String get discoverAllNames;

  /// No description provided for @discoverQuiz.
  ///
  /// In fr, this message translates to:
  /// **'Quiz'**
  String get discoverQuiz;

  /// No description provided for @discoverFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get discoverFilterAll;

  /// No description provided for @discoverSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher (arabe, translittération, français)'**
  String get discoverSearchHint;

  /// No description provided for @discoverProphetsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Noms du Prophète ﷺ'**
  String get discoverProphetsTitle;

  /// No description provided for @discoverProphetsTitleAr.
  ///
  /// In fr, this message translates to:
  /// **'أسماء النبي ﷺ'**
  String get discoverProphetsTitleAr;

  /// No description provided for @discoverProphetsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'201 noms à découvrir'**
  String get discoverProphetsSubtitle;

  /// No description provided for @discoverHusnaTitleAr.
  ///
  /// In fr, this message translates to:
  /// **'الأسماء الحسنى'**
  String get discoverHusnaTitleAr;

  /// No description provided for @discoverHusnaSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'99 Noms d\'Allah'**
  String get discoverHusnaSubtitle;

  /// No description provided for @detailSectionEtymology.
  ///
  /// In fr, this message translates to:
  /// **'Étymologie'**
  String get detailSectionEtymology;

  /// No description provided for @detailSectionCommentary.
  ///
  /// In fr, this message translates to:
  /// **'Commentaires classiques'**
  String get detailSectionCommentary;

  /// No description provided for @detailSectionReferences.
  ///
  /// In fr, this message translates to:
  /// **'Références'**
  String get detailSectionReferences;

  /// No description provided for @detailSectionSources.
  ///
  /// In fr, this message translates to:
  /// **'Sources'**
  String get detailSectionSources;

  /// No description provided for @detailNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom #{number}'**
  String detailNameLabel(String number);

  /// No description provided for @detailProgress.
  ///
  /// In fr, this message translates to:
  /// **'{current} / {total}'**
  String detailProgress(int current, int total);

  /// No description provided for @detailMaskedName.
  ///
  /// In fr, this message translates to:
  /// **'[ce nom]'**
  String get detailMaskedName;

  /// No description provided for @quizTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quiz rapide'**
  String get quizTitle;

  /// No description provided for @quizSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'5 questions · ~1 minute'**
  String get quizSubtitle;

  /// No description provided for @quizTypeMCQ.
  ///
  /// In fr, this message translates to:
  /// **'QCM'**
  String get quizTypeMCQ;

  /// No description provided for @quizTypeMCQDesc.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez le nom à partir de sa description'**
  String get quizTypeMCQDesc;

  /// No description provided for @quizTypeFlashcards.
  ///
  /// In fr, this message translates to:
  /// **'Flashcards'**
  String get quizTypeFlashcards;

  /// No description provided for @quizTypeFlashcardsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Retournez les cartes pour réviser'**
  String get quizTypeFlashcardsDesc;

  /// No description provided for @quizStartCta.
  ///
  /// In fr, this message translates to:
  /// **'Démarrer'**
  String get quizStartCta;

  /// No description provided for @quizCardKnow.
  ///
  /// In fr, this message translates to:
  /// **'Je connais'**
  String get quizCardKnow;

  /// No description provided for @quizCardReview.
  ///
  /// In fr, this message translates to:
  /// **'À revoir'**
  String get quizCardReview;

  /// No description provided for @quizProgress.
  ///
  /// In fr, this message translates to:
  /// **'{current}/{total}'**
  String quizProgress(int current, int total);

  /// No description provided for @quizResultExcellent.
  ///
  /// In fr, this message translates to:
  /// **'MāshāʾAllāh. Chaque nom est une porte vers Sa lumière. Continuez à explorer.'**
  String get quizResultExcellent;

  /// No description provided for @quizResultGood.
  ///
  /// In fr, this message translates to:
  /// **'Chaque nom mérite qu\'on s\'y attarde. Revenez demain, ils deviendront familiers.'**
  String get quizResultGood;

  /// No description provided for @quizResultKeepGoing.
  ///
  /// In fr, this message translates to:
  /// **'La connaissance commence par la patience. Explorez la fiche des noms pour les apprivoiser.'**
  String get quizResultKeepGoing;

  /// No description provided for @quizResultScore.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez répondu correctement à {score}/{total}'**
  String quizResultScore(int score, int total);

  /// No description provided for @quizReplayCta.
  ///
  /// In fr, this message translates to:
  /// **'Rejouer'**
  String get quizReplayCta;

  /// No description provided for @quizExploreNamesCta.
  ///
  /// In fr, this message translates to:
  /// **'Explorer les noms'**
  String get quizExploreNamesCta;

  /// No description provided for @profileJourneySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{viewed}/{total} étoiles découvertes'**
  String profileJourneySubtitle(int viewed, int total);

  /// No description provided for @profileJourneyViewed.
  ///
  /// In fr, this message translates to:
  /// **'découvertes'**
  String get profileJourneyViewed;

  /// No description provided for @profileJourneyMeditated.
  ///
  /// In fr, this message translates to:
  /// **'contemplées'**
  String get profileJourneyMeditated;

  /// No description provided for @profileJourneyPracticed.
  ///
  /// In fr, this message translates to:
  /// **'vécues'**
  String get profileJourneyPracticed;

  /// No description provided for @profileJourneyRecognized.
  ///
  /// In fr, this message translates to:
  /// **'reconnues'**
  String get profileJourneyRecognized;

  /// No description provided for @profileFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get profileFavorites;

  /// No description provided for @profileSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get profileSettings;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @settingsSectionTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsSectionTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeFeminine.
  ///
  /// In fr, this message translates to:
  /// **'Violet'**
  String get settingsThemeFeminine;

  /// No description provided for @settingsSectionNotif.
  ///
  /// In fr, this message translates to:
  /// **'Notification quotidienne'**
  String get settingsSectionNotif;

  /// No description provided for @settingsSectionTextSize.
  ///
  /// In fr, this message translates to:
  /// **'Taille du texte'**
  String get settingsSectionTextSize;

  /// No description provided for @settingsTextSmall.
  ///
  /// In fr, this message translates to:
  /// **'Petit'**
  String get settingsTextSmall;

  /// No description provided for @settingsTextMedium.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get settingsTextMedium;

  /// No description provided for @settingsTextLarge.
  ///
  /// In fr, this message translates to:
  /// **'Grand'**
  String get settingsTextLarge;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsSectionAbout;

  /// No description provided for @settingsReportError.
  ///
  /// In fr, this message translates to:
  /// **'Signaler une erreur'**
  String get settingsReportError;

  /// No description provided for @favoritesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori pour l\'instant'**
  String get favoritesEmpty;

  /// No description provided for @favoritesEmptyCta.
  ///
  /// In fr, this message translates to:
  /// **'Explorer les noms'**
  String get favoritesEmptyCta;

  /// No description provided for @flashcardFlipHint.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur la carte pour la retourner'**
  String get flashcardFlipHint;

  /// No description provided for @qcmNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get qcmNext;

  /// No description provided for @detailShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get detailShare;

  /// No description provided for @settingsNotifEnable.
  ///
  /// In fr, this message translates to:
  /// **'Activer'**
  String get settingsNotifEnable;

  /// No description provided for @settingsNotifDisable.
  ///
  /// In fr, this message translates to:
  /// **'Désactiver'**
  String get settingsNotifDisable;

  /// No description provided for @profileConstellationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Constellation'**
  String get profileConstellationTitle;

  /// No description provided for @profileLegendViewed.
  ///
  /// In fr, this message translates to:
  /// **'vu'**
  String get profileLegendViewed;

  /// No description provided for @profileLegendMeditated.
  ///
  /// In fr, this message translates to:
  /// **'contemplé'**
  String get profileLegendMeditated;

  /// No description provided for @profileLegendPracticed.
  ///
  /// In fr, this message translates to:
  /// **'vécu'**
  String get profileLegendPracticed;

  /// No description provided for @profileLegendRecognized.
  ///
  /// In fr, this message translates to:
  /// **'reconnu'**
  String get profileLegendRecognized;

  /// No description provided for @profileLegendUnknown.
  ///
  /// In fr, this message translates to:
  /// **'non découvert'**
  String get profileLegendUnknown;

  /// No description provided for @detailLearningProgress.
  ///
  /// In fr, this message translates to:
  /// **'Mémorisation en cours…'**
  String get detailLearningProgress;

  /// No description provided for @favoriteAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get favoriteAdd;

  /// No description provided for @favoriteRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get favoriteRemove;

  /// No description provided for @discoverNoResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get discoverNoResults;

  /// No description provided for @husnaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Asmāʾ al-Ḥusnā'**
  String get husnaTitle;

  /// No description provided for @husnaSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher (arabe, translittération, sens…)'**
  String get husnaSearchHint;

  /// No description provided for @husnaPrevious.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get husnaPrevious;

  /// No description provided for @husnaNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get husnaNext;

  /// No description provided for @husnaEtymology.
  ///
  /// In fr, this message translates to:
  /// **'Étymologie'**
  String get husnaEtymology;

  /// No description provided for @husnaReference.
  ///
  /// In fr, this message translates to:
  /// **'Référence'**
  String get husnaReference;

  /// No description provided for @discoverHubSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un domaine à explorer'**
  String get discoverHubSubtitle;

  /// No description provided for @libraryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque'**
  String get libraryTitle;

  /// No description provided for @librarySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Retrouvez les listes, fiches, révisions et quiz.'**
  String get librarySubtitle;

  /// No description provided for @libraryProphetNamesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Liste, fiches, tafakkur, QCM et révision.'**
  String get libraryProphetNamesSubtitle;

  /// No description provided for @libraryToolsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Outils d’apprentissage'**
  String get libraryToolsTitle;

  /// No description provided for @libraryLearnTab.
  ///
  /// In fr, this message translates to:
  /// **'Apprendre'**
  String get libraryLearnTab;

  /// No description provided for @libraryDeckProgress.
  ///
  /// In fr, this message translates to:
  /// **'{current}/{total} reconnus'**
  String libraryDeckProgress(int current, int total);

  /// No description provided for @journeyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Voyage'**
  String get journeyTitle;

  /// No description provided for @journeyTitleAr.
  ///
  /// In fr, this message translates to:
  /// **'رحلة الأسماء'**
  String get journeyTitleAr;

  /// No description provided for @journeySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Avancez par constellations de noms, une étoile après l’autre.'**
  String get journeySubtitle;

  /// No description provided for @journeyGalaxyHint.
  ///
  /// In fr, this message translates to:
  /// **'Touchez la galaxie active pour entrer dans le voyage.'**
  String get journeyGalaxyHint;

  /// No description provided for @journeyDeckMapHint.
  ///
  /// In fr, this message translates to:
  /// **'Touchez une constellation pour voir ses étoiles.'**
  String get journeyDeckMapHint;

  /// No description provided for @journeyLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le voyage'**
  String get journeyLoadError;

  /// No description provided for @journeyNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Constellation introuvable'**
  String get journeyNotFound;

  /// No description provided for @journeyProgress.
  ///
  /// In fr, this message translates to:
  /// **'{viewed}/{total} étoiles vues'**
  String journeyProgress(int viewed, int total);

  /// No description provided for @journeyProgressDetailed.
  ///
  /// In fr, this message translates to:
  /// **'{viewed} vues · {meditated} méditées · {practiced} vécues · {recognized} reconnues / {total}'**
  String journeyProgressDetailed(
    int viewed,
    int meditated,
    int practiced,
    int recognized,
    int total,
  );

  /// No description provided for @journeyStarViewed.
  ///
  /// In fr, this message translates to:
  /// **'Vue'**
  String get journeyStarViewed;

  /// No description provided for @journeyStarMeditated.
  ///
  /// In fr, this message translates to:
  /// **'Méditée'**
  String get journeyStarMeditated;

  /// No description provided for @journeyStarPracticed.
  ///
  /// In fr, this message translates to:
  /// **'Vécue'**
  String get journeyStarPracticed;

  /// No description provided for @journeyStarRecognized.
  ///
  /// In fr, this message translates to:
  /// **'Reconnue'**
  String get journeyStarRecognized;

  /// No description provided for @journeyStarUnknown.
  ///
  /// In fr, this message translates to:
  /// **'À découvrir'**
  String get journeyStarUnknown;

  /// No description provided for @treeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lignée prophétique'**
  String get treeTitle;

  /// No description provided for @treeModeRadial.
  ///
  /// In fr, this message translates to:
  /// **'Orbites'**
  String get treeModeRadial;

  /// No description provided for @treeModeRiver.
  ///
  /// In fr, this message translates to:
  /// **'Rivière'**
  String get treeModeRiver;

  /// No description provided for @treeModeConstellation.
  ///
  /// In fr, this message translates to:
  /// **'Constellation'**
  String get treeModeConstellation;

  /// No description provided for @treePersonBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'arbre'**
  String get treePersonBack;

  /// No description provided for @treePersonRelation.
  ///
  /// In fr, this message translates to:
  /// **'Lien avec le Prophète ﷺ'**
  String get treePersonRelation;

  /// No description provided for @treePersonPath.
  ///
  /// In fr, this message translates to:
  /// **'Chemin de parenté'**
  String get treePersonPath;

  /// No description provided for @treePersonMarkers.
  ///
  /// In fr, this message translates to:
  /// **'Repères'**
  String get treePersonMarkers;

  /// No description provided for @treePersonBirth.
  ///
  /// In fr, this message translates to:
  /// **'Naissance'**
  String get treePersonBirth;

  /// No description provided for @treePersonDeath.
  ///
  /// In fr, this message translates to:
  /// **'Décès'**
  String get treePersonDeath;

  /// No description provided for @treePersonNarrative.
  ///
  /// In fr, this message translates to:
  /// **'Récit'**
  String get treePersonNarrative;

  /// No description provided for @treePersonSeeAlso.
  ///
  /// In fr, this message translates to:
  /// **'Voir aussi'**
  String get treePersonSeeAlso;

  /// No description provided for @treePersonFavoriteAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get treePersonFavoriteAdd;

  /// No description provided for @treePersonFavoriteRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get treePersonFavoriteRemove;

  /// No description provided for @treePersonShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get treePersonShare;

  /// No description provided for @treeSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher dans la lignée…'**
  String get treeSearchHint;

  /// No description provided for @treeResetView.
  ///
  /// In fr, this message translates to:
  /// **'Recentrer'**
  String get treeResetView;

  /// No description provided for @treeListView.
  ///
  /// In fr, this message translates to:
  /// **'Vue liste'**
  String get treeListView;

  /// No description provided for @treeRiverPaternal.
  ///
  /// In fr, this message translates to:
  /// **'Lignée paternelle'**
  String get treeRiverPaternal;

  /// No description provided for @treeRiverMaternal.
  ///
  /// In fr, this message translates to:
  /// **'Lignée maternelle'**
  String get treeRiverMaternal;

  /// No description provided for @treeRiverDescendants.
  ///
  /// In fr, this message translates to:
  /// **'Descendants'**
  String get treeRiverDescendants;

  /// No description provided for @treePersonOpenDetail.
  ///
  /// In fr, this message translates to:
  /// **'Voir la fiche →'**
  String get treePersonOpenDetail;

  /// No description provided for @treeLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement'**
  String get treeLoadError;

  /// No description provided for @treeBridgeToTree.
  ///
  /// In fr, this message translates to:
  /// **'Explorer la lignée →'**
  String get treeBridgeToTree;

  /// No description provided for @treeBridgeRelatedNames.
  ///
  /// In fr, this message translates to:
  /// **'Noms du Prophète ﷺ liés'**
  String get treeBridgeRelatedNames;

  /// No description provided for @treeListViewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tous les membres'**
  String get treeListViewTitle;

  /// No description provided for @treeListSectionAncestors.
  ///
  /// In fr, this message translates to:
  /// **'Ascendants'**
  String get treeListSectionAncestors;

  /// No description provided for @treeListSectionWives.
  ///
  /// In fr, this message translates to:
  /// **'Épouses'**
  String get treeListSectionWives;

  /// No description provided for @treeListSectionChildren.
  ///
  /// In fr, this message translates to:
  /// **'Enfants & petits-enfants'**
  String get treeListSectionChildren;

  /// No description provided for @treeListSectionUncles.
  ///
  /// In fr, this message translates to:
  /// **'Oncles & tantes'**
  String get treeListSectionUncles;

  /// No description provided for @treeListSectionOther.
  ///
  /// In fr, this message translates to:
  /// **'Autres'**
  String get treeListSectionOther;

  /// No description provided for @treeRoleProphet.
  ///
  /// In fr, this message translates to:
  /// **'Le Prophète ﷺ'**
  String get treeRoleProphet;

  /// No description provided for @treeRoleFather.
  ///
  /// In fr, this message translates to:
  /// **'Père du Prophète ﷺ'**
  String get treeRoleFather;

  /// No description provided for @treeRoleMother.
  ///
  /// In fr, this message translates to:
  /// **'Mère du Prophète ﷺ'**
  String get treeRoleMother;

  /// No description provided for @treeRolePaternalAncestor.
  ///
  /// In fr, this message translates to:
  /// **'Ancêtre paternel'**
  String get treeRolePaternalAncestor;

  /// No description provided for @treeRoleMaternalAncestor.
  ///
  /// In fr, this message translates to:
  /// **'Ancêtre maternel'**
  String get treeRoleMaternalAncestor;

  /// No description provided for @treeRoleUncle.
  ///
  /// In fr, this message translates to:
  /// **'Oncle du Prophète ﷺ'**
  String get treeRoleUncle;

  /// No description provided for @treeRoleAunt.
  ///
  /// In fr, this message translates to:
  /// **'Tante du Prophète ﷺ'**
  String get treeRoleAunt;

  /// No description provided for @treeRoleWife.
  ///
  /// In fr, this message translates to:
  /// **'Épouse du Prophète ﷺ'**
  String get treeRoleWife;

  /// No description provided for @treeRoleChild.
  ///
  /// In fr, this message translates to:
  /// **'Enfant du Prophète ﷺ'**
  String get treeRoleChild;

  /// No description provided for @treeRoleGrandchild.
  ///
  /// In fr, this message translates to:
  /// **'Petit-enfant du Prophète ﷺ'**
  String get treeRoleGrandchild;

  /// No description provided for @treeRoleCousin.
  ///
  /// In fr, this message translates to:
  /// **'Cousin(e) du Prophète ﷺ'**
  String get treeRoleCousin;

  /// No description provided for @treeRoleTraditionalAncestor.
  ///
  /// In fr, this message translates to:
  /// **'Ancêtre (tradition)'**
  String get treeRoleTraditionalAncestor;

  /// No description provided for @treeRoleUnclesAunts.
  ///
  /// In fr, this message translates to:
  /// **'Oncles & Tantes du Prophète ﷺ'**
  String get treeRoleUnclesAunts;

  /// No description provided for @treeRoleUnclesAuntsCount.
  ///
  /// In fr, this message translates to:
  /// **'Oncles & Tantes · {count}'**
  String treeRoleUnclesAuntsCount(int count);

  /// No description provided for @tafakkurTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tafakkur'**
  String get tafakkurTitle;

  /// No description provided for @tafakkurPause.
  ///
  /// In fr, this message translates to:
  /// **'En pause'**
  String get tafakkurPause;

  /// No description provided for @tafakkurResume.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get tafakkurResume;

  /// No description provided for @tafakkurComplete.
  ///
  /// In fr, this message translates to:
  /// **'Contemplation terminée'**
  String get tafakkurComplete;

  /// No description provided for @tafakkurReturn.
  ///
  /// In fr, this message translates to:
  /// **'Retourner au nom'**
  String get tafakkurReturn;

  /// No description provided for @tafakkurPaceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Rythme de lecture'**
  String get tafakkurPaceLabel;

  /// No description provided for @tafakkurPaceSlow.
  ///
  /// In fr, this message translates to:
  /// **'Lent — 12 secondes'**
  String get tafakkurPaceSlow;

  /// No description provided for @tafakkurPaceNormal.
  ///
  /// In fr, this message translates to:
  /// **'Normal — 9 secondes'**
  String get tafakkurPaceNormal;

  /// No description provided for @tafakkurPaceFast.
  ///
  /// In fr, this message translates to:
  /// **'Rapide — 6 secondes'**
  String get tafakkurPaceFast;

  /// No description provided for @tafakkurRemaining.
  ///
  /// In fr, this message translates to:
  /// **'{count} phrase(s) restante(s)'**
  String tafakkurRemaining(int count);

  /// No description provided for @tafakkurExitConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la contemplation ?'**
  String get tafakkurExitConfirm;

  /// No description provided for @tafakkurExitConfirmYes.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get tafakkurExitConfirmYes;

  /// No description provided for @tafakkurExitConfirmNo.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get tafakkurExitConfirmNo;

  /// No description provided for @tafakkurPrevious.
  ///
  /// In fr, this message translates to:
  /// **'Page précédente'**
  String get tafakkurPrevious;

  /// No description provided for @tafakkurNext.
  ///
  /// In fr, this message translates to:
  /// **'Page suivante'**
  String get tafakkurNext;

  /// No description provided for @tafakkurSettingsTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Régler le rythme'**
  String get tafakkurSettingsTooltip;

  /// No description provided for @tafakkurEstimatedDuration.
  ///
  /// In fr, this message translates to:
  /// **'~{minutes} min'**
  String tafakkurEstimatedDuration(int minutes);

  /// No description provided for @tafakkurPaceSummary.
  ///
  /// In fr, this message translates to:
  /// **'{seconds} s par page'**
  String tafakkurPaceSummary(int seconds);

  /// No description provided for @tafakkurPageName.
  ///
  /// In fr, this message translates to:
  /// **'Le nom'**
  String get tafakkurPageName;

  /// No description provided for @tafakkurPageStory.
  ///
  /// In fr, this message translates to:
  /// **'Le récit'**
  String get tafakkurPageStory;

  /// No description provided for @tafakkurPageMeditation.
  ///
  /// In fr, this message translates to:
  /// **'Méditer'**
  String get tafakkurPageMeditation;

  /// No description provided for @tafakkurPageIntention.
  ///
  /// In fr, this message translates to:
  /// **'Intention'**
  String get tafakkurPageIntention;

  /// No description provided for @tafakkurSwipeHint.
  ///
  /// In fr, this message translates to:
  /// **'Glissez pour avancer ou revenir'**
  String get tafakkurSwipeHint;

  /// No description provided for @studyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mode Étude'**
  String get studyTitle;

  /// No description provided for @studyParcoursTitle.
  ///
  /// In fr, this message translates to:
  /// **'Parcours Thématiques'**
  String get studyParcoursTitle;

  /// No description provided for @studyParcoursSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Découverte guidée par thèmes'**
  String get studyParcoursSubtitle;

  /// No description provided for @studyReviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Révision libre'**
  String get studyReviewTitle;

  /// No description provided for @studyReviewSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{count} noms à réviser'**
  String studyReviewSubtitle(int count);

  /// No description provided for @studyReviewEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun nom à réviser pour le moment'**
  String get studyReviewEmpty;

  /// No description provided for @studyReviewKnow.
  ///
  /// In fr, this message translates to:
  /// **'Je connais'**
  String get studyReviewKnow;

  /// No description provided for @studyReviewUnsure.
  ///
  /// In fr, this message translates to:
  /// **'Encore flou'**
  String get studyReviewUnsure;

  /// No description provided for @studyParcoursComplete.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get studyParcoursComplete;

  /// No description provided for @studyMasteredBadge.
  ///
  /// In fr, this message translates to:
  /// **'{count} noms maîtrisés'**
  String studyMasteredBadge(int count);

  /// No description provided for @treeFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get treeFilterAll;

  /// No description provided for @treeFilterWivesAndChildren.
  ///
  /// In fr, this message translates to:
  /// **'Épouses & enfants'**
  String get treeFilterWivesAndChildren;

  /// No description provided for @treeFilterAncestors.
  ///
  /// In fr, this message translates to:
  /// **'Ascendants'**
  String get treeFilterAncestors;

  /// No description provided for @treeFilterUnclesAndAunts.
  ///
  /// In fr, this message translates to:
  /// **'Oncles & tantes'**
  String get treeFilterUnclesAndAunts;

  /// No description provided for @treeFilterAhlAlBayt.
  ///
  /// In fr, this message translates to:
  /// **'Ahl al-Bayt'**
  String get treeFilterAhlAlBayt;

  /// No description provided for @nameExperienceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nom vivant'**
  String get nameExperienceTitle;

  /// No description provided for @nameExperienceOpen.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le nom vivant'**
  String get nameExperienceOpen;

  /// No description provided for @nameExperienceStory.
  ///
  /// In fr, this message translates to:
  /// **'Récit'**
  String get nameExperienceStory;

  /// No description provided for @nameExperienceUnderstand.
  ///
  /// In fr, this message translates to:
  /// **'Comprendre ce nom'**
  String get nameExperienceUnderstand;

  /// No description provided for @nameExperienceTafakkur.
  ///
  /// In fr, this message translates to:
  /// **'Tafakkur'**
  String get nameExperienceTafakkur;

  /// No description provided for @nameExperienceActionOfDay.
  ///
  /// In fr, this message translates to:
  /// **'Action du jour'**
  String get nameExperienceActionOfDay;

  /// No description provided for @nameExperienceMarkActionPracticed.
  ///
  /// In fr, this message translates to:
  /// **'Je l’ai vécue'**
  String get nameExperienceMarkActionPracticed;

  /// No description provided for @nameExperienceActionPracticed.
  ///
  /// In fr, this message translates to:
  /// **'Action vécue'**
  String get nameExperienceActionPracticed;

  /// No description provided for @nameExperienceNoStory.
  ///
  /// In fr, this message translates to:
  /// **'Aucun récit dédié n’est encore relié à ce nom. La fiche classique reste disponible pendant l’enrichissement éditorial.'**
  String get nameExperienceNoStory;

  /// No description provided for @nameExperienceFallbackPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Que ce nom m’apprend-il aujourd’hui sur la connaissance, l’amour et l’imitation du Prophète ﷺ ?'**
  String get nameExperienceFallbackPrompt;

  /// No description provided for @nameExperienceFallbackAction.
  ///
  /// In fr, this message translates to:
  /// **'Prends un moment court pour vivre ce nom avec sincérité.'**
  String get nameExperienceFallbackAction;

  /// No description provided for @nameExperienceEnterTafakkur.
  ///
  /// In fr, this message translates to:
  /// **'Entrer en tafakkur'**
  String get nameExperienceEnterTafakkur;

  /// No description provided for @nameExperienceClassicTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Fiche classique'**
  String get nameExperienceClassicTooltip;

  /// No description provided for @nameExperienceOpenClassic.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir la fiche classique'**
  String get nameExperienceOpenClassic;

  /// No description provided for @nameExperienceNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Nom introuvable'**
  String get nameExperienceNotFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
