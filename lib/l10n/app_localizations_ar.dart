// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Asmāʾ an-Nabī';

  @override
  String get navHome => 'Accueil';

  @override
  String get navDiscover => 'Découvrir';

  @override
  String get navProfile => 'Profil';

  @override
  String get onboardingWelcomeTitle => 'Les 201 noms du Prophète ﷺ';

  @override
  String get onboardingWelcomeSubtitle => 'Apprenez, méditez, connectez-vous.';

  @override
  String get onboardingWelcomeCta => 'Commencer';

  @override
  String get onboardingThemeTitle => 'Choisissez votre ambiance';

  @override
  String get onboardingThemeCta => 'Continuer';

  @override
  String get onboardingNotifTitle => 'Un nom chaque jour';

  @override
  String get onboardingNotifSubtitle =>
      'Recevez le nom du jour à l\'heure qui vous convient';

  @override
  String get onboardingNotifActivate => 'Activer les notifications';

  @override
  String get onboardingNotifLater => 'Plus tard';

  @override
  String get homeGreeting => 'As-salāmu ʿalaykum';

  @override
  String get homeCategorySection => 'Explorer par catégorie';

  @override
  String get homeDiscoverName => 'Découvrir ce nom';

  @override
  String homeCategoryLearned(int learned, int total) {
    return '$learned/$total appris';
  }

  @override
  String homeNameNumber(String number) {
    return '#$number';
  }

  @override
  String get discoverAllNames => 'Tous les noms';

  @override
  String get discoverQuiz => 'Quiz';

  @override
  String get discoverFilterAll => 'Tous';

  @override
  String get discoverSearchHint =>
      'Rechercher (arabe, translittération, français)';

  @override
  String get detailSectionEtymology => 'Étymologie';

  @override
  String get detailSectionCommentary => 'Commentaires classiques';

  @override
  String get detailSectionReferences => 'Références';

  @override
  String get detailSectionSources => 'Sources';

  @override
  String detailNameLabel(String number) {
    return 'Nom #$number';
  }

  @override
  String detailProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get detailMaskedName => '[ce nom]';

  @override
  String get quizTitle => 'Quiz rapide';

  @override
  String get quizSubtitle => '5 questions · ~1 minute';

  @override
  String get quizTypeMCQ => 'QCM';

  @override
  String get quizTypeMCQDesc => 'Trouvez le nom à partir de sa description';

  @override
  String get quizTypeFlashcards => 'Flashcards';

  @override
  String get quizTypeFlashcardsDesc => 'Retournez les cartes pour réviser';

  @override
  String get quizStartCta => 'Démarrer';

  @override
  String get quizCardKnow => 'Je connais';

  @override
  String get quizCardReview => 'À revoir';

  @override
  String quizProgress(int current, int total) {
    return '$current/$total';
  }

  @override
  String get quizResultExcellent =>
      'MāshāʾAllāh. Chaque nom est une porte vers Sa lumière. Continuez à explorer.';

  @override
  String get quizResultGood =>
      'Chaque nom mérite qu\'on s\'y attarde. Revenez demain, ils deviendront familiers.';

  @override
  String get quizResultKeepGoing =>
      'La connaissance commence par la patience. Explorez la fiche des noms pour les apprivoiser.';

  @override
  String quizResultScore(int score, int total) {
    return 'Vous avez répondu correctement à $score/$total';
  }

  @override
  String get quizReplayCta => 'Rejouer';

  @override
  String get quizExploreNamesCta => 'Explorer les noms';

  @override
  String get profileLearnedSubtitle => 'sur 201 noms du Prophète ﷺ';

  @override
  String get profileFavorites => 'Mes favoris';

  @override
  String get profileSettings => 'Paramètres';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionTheme => 'Thème';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeFeminine => 'Féminin';

  @override
  String get settingsSectionNotif => 'Notification quotidienne';

  @override
  String get settingsSectionTextSize => 'Taille du texte';

  @override
  String get settingsTextSmall => 'Petit';

  @override
  String get settingsTextMedium => 'Moyen';

  @override
  String get settingsTextLarge => 'Grand';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsReportError => 'Signaler une erreur';

  @override
  String get favoritesTitle => 'Mes favoris';

  @override
  String get favoritesEmpty => 'Aucun favori pour l\'instant';

  @override
  String get favoritesEmptyCta => 'Explorer les noms';

  @override
  String get flashcardFlipHint => 'Appuyez sur la carte pour la retourner';

  @override
  String get qcmNext => 'Suivant';

  @override
  String get detailShare => 'Partager';

  @override
  String get settingsNotifEnable => 'Activer';

  @override
  String get settingsNotifDisable => 'Désactiver';

  @override
  String get profileConstellationTitle => 'Constellation';

  @override
  String get profileLegendLearned => 'appris';

  @override
  String get profileLegendViewed => 'vu';

  @override
  String get profileLegendUnknown => 'non découvert';

  @override
  String get detailLearningProgress => 'Mémorisation en cours…';

  @override
  String get favoriteAdd => 'Ajouter aux favoris';

  @override
  String get favoriteRemove => 'Retirer des favoris';

  @override
  String get discoverNoResults => 'Aucun résultat';

  @override
  String get navTree => 'الشجرة';

  @override
  String get treeTitle => 'النسب النبوي الشريف';

  @override
  String get treeModeRadial => 'المدارات';

  @override
  String get treeModeRiver => 'نهر النور';

  @override
  String get treeModeConstellation => 'النجوم';

  @override
  String get treePersonBack => 'العودة';

  @override
  String get treePersonRelation => 'الصلة بالنبي ﷺ';

  @override
  String get treePersonPath => 'سلسلة النسب';

  @override
  String get treePersonMarkers => 'تواريخ';

  @override
  String get treePersonBirth => 'الولادة';

  @override
  String get treePersonDeath => 'الوفاة';

  @override
  String get treePersonNarrative => 'السيرة';

  @override
  String get treePersonSeeAlso => 'انظر أيضاً';

  @override
  String get treePersonFavoriteAdd => 'إضافة إلى المفضلة';

  @override
  String get treePersonFavoriteRemove => 'إزالة من المفضلة';

  @override
  String get treePersonShare => 'مشاركة';

  @override
  String get treeSearchHint => 'ابحث في النسب…';

  @override
  String get treeResetView => 'إعادة التمركز';

  @override
  String get treeListView => 'عرض القائمة';

  @override
  String get treePersonOpenDetail => 'Voir la fiche →';

  @override
  String get treeLoadError => 'Erreur de chargement';
}
