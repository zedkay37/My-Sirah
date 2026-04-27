// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Sirah Hub';

  @override
  String get navHome => 'Accueil';

  @override
  String get navDiscover => 'Découvrir';

  @override
  String get navProfile => 'Profil';

  @override
  String get navTree => 'Arbre';

  @override
  String get errorPageNotFound => 'Page introuvable';

  @override
  String get errorBackHome => 'Retour à l\'accueil';

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
  String get homeTagline => 'Connaître, aimer et suivre le Prophète ﷺ';

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
  String get discoverProphetsTitle => 'Noms du Prophète ﷺ';

  @override
  String get discoverProphetsTitleAr => 'أسماء النبي ﷺ';

  @override
  String get discoverProphetsSubtitle => '201 noms à découvrir';

  @override
  String get discoverHusnaTitleAr => 'الأسماء الحسنى';

  @override
  String get discoverHusnaSubtitle => '99 Noms d\'Allah';

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
  String get settingsThemeFeminine => 'Violet';

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
  String get husnaTitle => 'Asmāʾ al-Ḥusnā';

  @override
  String get husnaSearchHint => 'Rechercher (arabe, translittération, sens…)';

  @override
  String get husnaPrevious => 'Précédent';

  @override
  String get husnaNext => 'Suivant';

  @override
  String get husnaEtymology => 'Étymologie';

  @override
  String get husnaReference => 'Référence';

  @override
  String get discoverHubSubtitle => 'Choisissez un domaine à explorer';

  @override
  String get treeTitle => 'Lignée prophétique';

  @override
  String get treeModeRadial => 'Orbites';

  @override
  String get treeModeRiver => 'Rivière';

  @override
  String get treeModeConstellation => 'Constellation';

  @override
  String get treePersonBack => 'Retour à l\'arbre';

  @override
  String get treePersonRelation => 'Lien avec le Prophète ﷺ';

  @override
  String get treePersonPath => 'Chemin de parenté';

  @override
  String get treePersonMarkers => 'Repères';

  @override
  String get treePersonBirth => 'Naissance';

  @override
  String get treePersonDeath => 'Décès';

  @override
  String get treePersonNarrative => 'Récit';

  @override
  String get treePersonSeeAlso => 'Voir aussi';

  @override
  String get treePersonFavoriteAdd => 'Ajouter aux favoris';

  @override
  String get treePersonFavoriteRemove => 'Retirer des favoris';

  @override
  String get treePersonShare => 'Partager';

  @override
  String get treeSearchHint => 'Rechercher dans la lignée…';

  @override
  String get treeResetView => 'Recentrer';

  @override
  String get treeListView => 'Vue liste';

  @override
  String get treeRiverPaternal => 'Lignée paternelle';

  @override
  String get treeRiverMaternal => 'Lignée maternelle';

  @override
  String get treeRiverDescendants => 'Descendants';

  @override
  String get treePersonOpenDetail => 'Voir la fiche →';

  @override
  String get treeLoadError => 'Erreur de chargement';

  @override
  String get treeBridgeToTree => 'Explorer la lignée →';

  @override
  String get treeBridgeRelatedNames => 'Noms du Prophète ﷺ liés';

  @override
  String get treeListViewTitle => 'Tous les membres';

  @override
  String get treeListSectionAncestors => 'Ascendants';

  @override
  String get treeListSectionWives => 'Épouses';

  @override
  String get treeListSectionChildren => 'Enfants & petits-enfants';

  @override
  String get treeListSectionUncles => 'Oncles & tantes';

  @override
  String get treeListSectionOther => 'Autres';

  @override
  String get treeRoleProphet => 'Le Prophète ﷺ';

  @override
  String get treeRoleFather => 'Père du Prophète ﷺ';

  @override
  String get treeRoleMother => 'Mère du Prophète ﷺ';

  @override
  String get treeRolePaternalAncestor => 'Ancêtre paternel';

  @override
  String get treeRoleMaternalAncestor => 'Ancêtre maternel';

  @override
  String get treeRoleUncle => 'Oncle du Prophète ﷺ';

  @override
  String get treeRoleAunt => 'Tante du Prophète ﷺ';

  @override
  String get treeRoleWife => 'Épouse du Prophète ﷺ';

  @override
  String get treeRoleChild => 'Enfant du Prophète ﷺ';

  @override
  String get treeRoleGrandchild => 'Petit-enfant du Prophète ﷺ';

  @override
  String get treeRoleCousin => 'Cousin(e) du Prophète ﷺ';

  @override
  String get treeRoleTraditionalAncestor => 'Ancêtre (tradition)';

  @override
  String get treeRoleUnclesAunts => 'Oncles & Tantes du Prophète ﷺ';

  @override
  String treeRoleUnclesAuntsCount(int count) {
    return 'Oncles & Tantes · $count';
  }

  @override
  String get tafakkurTitle => 'Tafakkur';

  @override
  String get tafakkurPause => 'En pause';

  @override
  String get tafakkurResume => 'Reprendre';

  @override
  String get tafakkurComplete => 'Contemplation terminée';

  @override
  String get tafakkurReturn => 'Retourner au nom';

  @override
  String get tafakkurPaceLabel => 'Rythme de lecture';

  @override
  String get tafakkurPaceSlow => 'Lent — 12 secondes';

  @override
  String get tafakkurPaceNormal => 'Normal — 9 secondes';

  @override
  String get tafakkurPaceFast => 'Rapide — 6 secondes';

  @override
  String tafakkurRemaining(int count) {
    return '$count phrase(s) restante(s)';
  }

  @override
  String get tafakkurExitConfirm => 'Quitter la contemplation ?';

  @override
  String get tafakkurExitConfirmYes => 'Quitter';

  @override
  String get tafakkurExitConfirmNo => 'Continuer';

  @override
  String get studyTitle => 'Mode Étude';

  @override
  String get studyParcoursTitle => 'Parcours Thématiques';

  @override
  String get studyParcoursSubtitle => 'Découverte guidée par thèmes';

  @override
  String get studyReviewTitle => 'Révision libre';

  @override
  String studyReviewSubtitle(int count) {
    return '$count noms à réviser';
  }

  @override
  String get studyReviewEmpty => 'Aucun nom à réviser pour le moment';

  @override
  String get studyReviewKnow => 'Je connais';

  @override
  String get studyReviewUnsure => 'Encore flou';

  @override
  String get studyParcoursComplete => 'Terminer';

  @override
  String studyMasteredBadge(int count) {
    return '$count noms maîtrisés';
  }

  @override
  String get treeFilterAll => 'Tous';

  @override
  String get treeFilterWivesAndChildren => 'Épouses & enfants';

  @override
  String get treeFilterAncestors => 'Ascendants';

  @override
  String get treeFilterUnclesAndAunts => 'Oncles & tantes';

  @override
  String get treeFilterAhlAlBayt => 'Ahl al-Bayt';
}
