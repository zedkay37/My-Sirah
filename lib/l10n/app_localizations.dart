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
  /// **'Asmāʾ an-Nabī'**
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

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

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

  /// No description provided for @homeCategoryLearned.
  ///
  /// In fr, this message translates to:
  /// **'{learned}/{total} appris'**
  String homeCategoryLearned(int learned, int total);

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

  /// No description provided for @profileLearnedSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'sur 201 noms du Prophète ﷺ'**
  String get profileLearnedSubtitle;

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
  /// **'Féminin'**
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

  /// No description provided for @profileLegendLearned.
  ///
  /// In fr, this message translates to:
  /// **'appris'**
  String get profileLegendLearned;

  /// No description provided for @profileLegendViewed.
  ///
  /// In fr, this message translates to:
  /// **'vu'**
  String get profileLegendViewed;

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
