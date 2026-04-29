// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Sirah Hub';

  @override
  String get navHome => 'Accueil';

  @override
  String get navDiscover => 'Découvrir';

  @override
  String get navJourney => 'الرحلة';

  @override
  String get navLibrary => 'المكتبة';

  @override
  String get navProfile => 'Profil';

  @override
  String get navTree => 'الشجرة';

  @override
  String get errorPageNotFound => 'الصفحة غير موجودة';

  @override
  String get errorBackHome => 'العودة إلى الرئيسية';

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
  String get homeTagline => 'معرفة النبيّ ﷺ ومحبّته واتّباعه';

  @override
  String get homeCategorySection => 'Explorer par catégorie';

  @override
  String get homeDiscoverName => 'Découvrir ce nom';

  @override
  String get homeDailyActionTitle => 'عمل اليوم';

  @override
  String get homeExploreTodayName => 'ادخل في هذا الاسم';

  @override
  String get homeClassicNameTooltip => 'البطاقة الكلاسيكية';

  @override
  String get homeContinueJourneyTitle => 'متابعة الرحلة';

  @override
  String get homeContinueJourneyFallback => 'المتابعة من اسم اليوم';

  @override
  String homeContinueJourneySubtitle(String constellation) {
    return 'النجم التالي في $constellation';
  }

  @override
  String get homeJourneyShortcutSubtitle => 'الدخول إلى الخريطة النجمية';

  @override
  String get homeLibraryShortcutSubtitle => 'القوائم والبطاقات والمراجعة';

  @override
  String homeCategoryViewed(int viewed, int total) {
    return '$viewed/$total découverts';
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
  String get discoverProphetsTitle => 'أسماء النبي ﷺ';

  @override
  String get discoverProphetsTitleAr => 'أسماء النبي ﷺ';

  @override
  String get discoverProphetsSubtitle => '٢٠١ اسمًا للاستكشاف';

  @override
  String get discoverHusnaTitleAr => 'الأسماء الحسنى';

  @override
  String get discoverHusnaSubtitle => '٩٩ اسمًا من أسماء الله';

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
  String profileJourneySubtitle(int viewed, int total) {
    return '$viewed/$total نجوم تم اكتشافها';
  }

  @override
  String get profileJourneyViewed => 'مكتشفة';

  @override
  String get profileJourneyMeditated => 'متأملة';

  @override
  String get profileJourneyPracticed => 'معاشة';

  @override
  String get profileJourneyRecognized => 'معروفة';

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
  String get profileLegendViewed => 'vu';

  @override
  String get profileLegendMeditated => 'تم تأملها';

  @override
  String get profileLegendPracticed => 'عيشت';

  @override
  String get profileLegendRecognized => 'عرفت';

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
  String get husnaTitle => 'أسماء الله الحسنى';

  @override
  String get husnaSearchHint => 'ابحث بالعربية أو النقل الصوتي أو المعنى…';

  @override
  String get husnaPrevious => 'السابق';

  @override
  String get husnaNext => 'التالي';

  @override
  String get husnaEtymology => 'الاشتقاق';

  @override
  String get husnaReference => 'المرجع';

  @override
  String get discoverHubSubtitle => 'اختر مجالاً للاستكشاف';

  @override
  String get libraryTitle => 'المكتبة';

  @override
  String get librarySubtitle =>
      'القوائم والبطاقات والمراجعة والاختبارات في مكان واحد.';

  @override
  String get libraryProphetNamesSubtitle =>
      'قائمة وبطاقات وتفكر واختبار ومراجعة.';

  @override
  String get libraryToolsTitle => 'أدوات التعلم';

  @override
  String get libraryLearnTab => 'تعلم';

  @override
  String libraryDeckProgress(int current, int total) {
    return '$current/$total معروفة';
  }

  @override
  String get journeyTitle => 'الرحلة';

  @override
  String get journeyTitleAr => 'رحلة الأسماء';

  @override
  String get journeySubtitle => 'تقدم عبر مجموعات الأسماء، نجمة بعد نجمة.';

  @override
  String get journeyGalaxyHint => 'المس المجرة النشطة للدخول في الرحلة.';

  @override
  String get journeyDeckMapHint => 'المس مجموعة لرؤية نجومها.';

  @override
  String get journeyLoadError => 'تعذر تحميل الرحلة';

  @override
  String get journeyNotFound => 'المجموعة غير موجودة';

  @override
  String journeyProgress(int viewed, int total) {
    return '$viewed/$total نجوم تمت رؤيتها';
  }

  @override
  String journeyProgressDetailed(
    int viewed,
    int meditated,
    int practiced,
    int recognized,
    int total,
  ) {
    return '$viewed شوهدت · $meditated تم تأملها · $practiced عيشت · $recognized عرفت / $total';
  }

  @override
  String get journeyStarViewed => 'شوهدت';

  @override
  String get journeyStarMeditated => 'تم تأملها';

  @override
  String get journeyStarPracticed => 'عيشت';

  @override
  String get journeyStarRecognized => 'عرفت';

  @override
  String get journeyStarUnknown => 'للاكتشاف';

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
  String get treeRoleProphet => 'النبي ﷺ';

  @override
  String get treeRoleFather => 'والد النبي ﷺ';

  @override
  String get treeRoleMother => 'والدة النبي ﷺ';

  @override
  String get treeRolePaternalAncestor => 'جد أبوي';

  @override
  String get treeRoleMaternalAncestor => 'جد أمومي';

  @override
  String get treeRoleUncle => 'عم النبي ﷺ';

  @override
  String get treeRoleAunt => 'عمة النبي ﷺ';

  @override
  String get treeRoleWife => 'زوجة النبي ﷺ';

  @override
  String get treeRoleChild => 'ابن/ابنة النبي ﷺ';

  @override
  String get treeRoleGrandchild => 'حفيد(ة) النبي ﷺ';

  @override
  String get treeRoleCousin => 'ابن عم النبي ﷺ';

  @override
  String get treeRoleTraditionalAncestor => 'جد (رواية)';

  @override
  String get treeRoleUnclesAunts => 'الأعمام والعمات';

  @override
  String treeRoleUnclesAuntsCount(int count) {
    return 'الأعمام والعمات · $count';
  }

  @override
  String get tafakkurTitle => 'تفكر';

  @override
  String get tafakkurPause => 'إيقاف مؤقت';

  @override
  String get tafakkurResume => 'استئناف';

  @override
  String get tafakkurComplete => 'انتهت التلاوة';

  @override
  String get tafakkurReturn => 'العودة إلى الاسم';

  @override
  String get tafakkurPaceLabel => 'وتيرة القراءة';

  @override
  String get tafakkurPaceSlow => 'بطيء — 12 ثانية';

  @override
  String get tafakkurPaceNormal => 'عادي — 9 ثواني';

  @override
  String get tafakkurPaceFast => 'سريع — 6 ثواني';

  @override
  String tafakkurRemaining(int count) {
    return 'متبقٍ $count';
  }

  @override
  String get tafakkurExitConfirm => 'الخروج من التفكر؟';

  @override
  String get tafakkurExitConfirmYes => 'خروج';

  @override
  String get tafakkurExitConfirmNo => 'متابعة';

  @override
  String get tafakkurPrevious => 'الصفحة السابقة';

  @override
  String get tafakkurNext => 'الصفحة التالية';

  @override
  String get tafakkurSettingsTooltip => 'ضبط الوتيرة';

  @override
  String tafakkurEstimatedDuration(int minutes) {
    return 'نحو $minutes د';
  }

  @override
  String tafakkurPaceSummary(int seconds) {
    return '$seconds ث لكل صفحة';
  }

  @override
  String get tafakkurPageName => 'الاسم';

  @override
  String get tafakkurPageStory => 'القصة';

  @override
  String get tafakkurPageMeditation => 'تأمل';

  @override
  String get tafakkurPageIntention => 'نية';

  @override
  String get tafakkurSwipeHint => 'اسحب للتقدم أو الرجوع';

  @override
  String get studyTitle => 'وضع الدراسة';

  @override
  String get studyParcoursTitle => 'المسارات الموضوعية';

  @override
  String get studyParcoursSubtitle => 'اكتشاف موجه حسب المواضيع';

  @override
  String get studyReviewTitle => 'مراجعة حرة';

  @override
  String studyReviewSubtitle(int count) {
    return '$count أسماء للمراجعة';
  }

  @override
  String get studyReviewEmpty => 'لا توجد أسماء للمراجعة حالياً';

  @override
  String get studyReviewKnow => 'أعرف';

  @override
  String get studyReviewUnsure => 'غير متأكد';

  @override
  String get studyParcoursComplete => 'إنهاء';

  @override
  String studyMasteredBadge(int count) {
    return '$count أسماء متقنة';
  }

  @override
  String get treeFilterAll => 'الكل';

  @override
  String get treeFilterWivesAndChildren => 'الزوجات والأبناء';

  @override
  String get treeFilterAncestors => 'الأجداد';

  @override
  String get treeFilterUnclesAndAunts => 'الأعمام والعمات';

  @override
  String get treeFilterAhlAlBayt => 'أهل البيت';

  @override
  String get nameExperienceTitle => 'اسم حي';

  @override
  String get nameExperienceOpen => 'فتح الاسم الحي';

  @override
  String get nameExperienceStory => 'قصة';

  @override
  String get nameExperienceUnderstand => 'فهم هذا الاسم';

  @override
  String get nameExperienceTafakkur => 'تفكر';

  @override
  String get nameExperienceActionOfDay => 'عمل اليوم';

  @override
  String get nameExperienceMarkActionPracticed => 'عشتها';

  @override
  String get nameExperienceActionPracticed => 'تم العمل بها';

  @override
  String get nameExperienceNoStory =>
      'لا توجد بعد قصة مخصصة لهذا الاسم. تبقى البطاقة الكلاسيكية متاحة أثناء الإثراء التحريري.';

  @override
  String get nameExperienceFallbackPrompt =>
      'ماذا يعلمني هذا الاسم اليوم عن معرفة النبي ﷺ ومحبته والاقتداء به؟';

  @override
  String get nameExperienceFallbackAction =>
      'خذ لحظة قصيرة لتعيش هذا الاسم بصدق.';

  @override
  String get nameExperienceEnterTafakkur => 'الدخول في التفكر';

  @override
  String get nameExperienceClassicTooltip => 'البطاقة الكلاسيكية';

  @override
  String get nameExperienceOpenClassic => 'فتح البطاقة الكلاسيكية';

  @override
  String get nameExperienceNotFound => 'الاسم غير موجود';
}
