// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Amikor imádkozol,\nIsten válaszol.';

  @override
  String get welcomeSubtitle =>
      'Mindennapi társad az imádságban és csendes időben';

  @override
  String get getStarted => 'Kezdjük';

  @override
  String get loginTitle => 'Üdvözöllek az Abba-ban';

  @override
  String get loginSubtitle => 'Jelentkezz be az imaútad megkezdéséhez';

  @override
  String get signInWithApple => 'Folytatás Apple-lel';

  @override
  String get signInWithGoogle => 'Folytatás Google-lel';

  @override
  String get signInWithEmail => 'Folytatás e-maillel';

  @override
  String greetingMorning(Object name) {
    return 'Jó reggelt, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Jó napot, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Jó estét, $name';
  }

  @override
  String get prayButton => 'Imádkozz';

  @override
  String get qtButton => 'Csendes idő';

  @override
  String streakDays(Object count) {
    return '$count napos imasorozat';
  }

  @override
  String get dailyVerse => 'Napi ige';

  @override
  String get tabHome => 'Főoldal';

  @override
  String get tabCalendar => 'Naptár';

  @override
  String get tabCommunity => 'Közösség';

  @override
  String get tabSettings => 'Beállítások';

  @override
  String get recordingTitle => 'Imádkozás...';

  @override
  String get recordingPause => 'Szünet';

  @override
  String get recordingResume => 'Folytatás';

  @override
  String get finishPrayer => 'Ima befejezése';

  @override
  String get finishPrayerConfirm => 'Szeretnéd befejezni az imádat?';

  @override
  String get switchToText => 'Inkább gépelés';

  @override
  String get textInputHint => 'Írd ide az imádat...';

  @override
  String get aiLoadingText => 'Elmélkedem az imádon...';

  @override
  String get aiLoadingVerse =>
      'Csendesedjetek el, és ismerjétek el, hogy én vagyok az Isten!\n— Zsoltárok 46:11';

  @override
  String get dashboardTitle => 'Imakert';

  @override
  String get shareButton => 'Megosztás';

  @override
  String get backToHome => 'Vissza a főoldalra';

  @override
  String get scriptureTitle => 'Mai Szentírás';

  @override
  String get bibleStoryTitle => 'Bibliai történet';

  @override
  String get testimonyTitle => 'Bizonyságtételem';

  @override
  String get testimonyEdit => 'Szerkesztés';

  @override
  String get guidanceTitle => 'AI útmutatás';

  @override
  String get aiPrayerTitle => 'Ima neked';

  @override
  String get originalLangTitle => 'Eredeti nyelv';

  @override
  String get premiumUnlock => 'Feloldás Premiummal';

  @override
  String get qtPageTitle => 'Reggeli kert';

  @override
  String get qtMeditateButton => 'Meditáció indítása';

  @override
  String get qtCompleted => 'Befejezve';

  @override
  String get communityTitle => 'Imakert';

  @override
  String get filterAll => 'Összes';

  @override
  String get filterTestimony => 'Bizonyságtétel';

  @override
  String get filterPrayerRequest => 'Imakérés';

  @override
  String get likeButton => 'Tetszik';

  @override
  String get commentButton => 'Hozzászólás';

  @override
  String get saveButton => 'Mentés';

  @override
  String get replyButton => 'Válasz';

  @override
  String get writePostTitle => 'Megosztás';

  @override
  String get cancelButton => 'Mégsem';

  @override
  String get sharePostButton => 'Megosztás';

  @override
  String get anonymousToggle => 'Névtelen';

  @override
  String get realNameToggle => 'Valódi név';

  @override
  String get categoryTestimony => 'Bizonyságtétel';

  @override
  String get categoryPrayerRequest => 'Imakérés';

  @override
  String get writePostHint =>
      'Oszd meg bizonyságtételedet vagy imakérésedet...';

  @override
  String get importFromPrayer => 'Importálás imából';

  @override
  String get calendarTitle => 'Imanaptár';

  @override
  String get currentStreak => 'Jelenlegi sorozat';

  @override
  String get bestStreak => 'Legjobb sorozat';

  @override
  String get days => 'nap';

  @override
  String calendarRecordCount(Object count) {
    return '$count bejegyzés';
  }

  @override
  String get todayVerse => 'Mai ige';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Összes ima';

  @override
  String get consecutiveDays => 'Egymást követő napok';

  @override
  String get premiumSection => 'Tagság';

  @override
  String get freePlan => 'Ingyenes';

  @override
  String get premiumPlan => 'Prémium';

  @override
  String get monthlyPrice => '2 990 Ft / hó';

  @override
  String get yearlyPrice => '22 990 Ft / év';

  @override
  String get yearlySave => '40% megtakarítás';

  @override
  String get launchPromo => '3 hónap 1590Ft/hó áron!';

  @override
  String get startPremium => 'Prémium indítása';

  @override
  String get comingSoon => 'Hamarosan';

  @override
  String get notificationSetting => 'Értesítések';

  @override
  String get aiVoiceSetting => 'AI hang';

  @override
  String get voiceWarm => 'Meleg';

  @override
  String get voiceCalm => 'Nyugodt';

  @override
  String get voiceStrong => 'Erős';

  @override
  String get languageSetting => 'Nyelv';

  @override
  String get darkModeSetting => 'Sötét mód';

  @override
  String get helpCenter => 'Súgó';

  @override
  String get termsOfService => 'Szolgáltatási feltételek';

  @override
  String get privacyPolicy => 'Adatvédelmi irányelvek';

  @override
  String get logout => 'Kijelentkezés';

  @override
  String appVersion(Object version) {
    return 'Verzió $version';
  }

  @override
  String get anonymous => 'Névtelen';

  @override
  String timeAgo(Object time) {
    return '$time ezelőtt';
  }

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Jelszó';

  @override
  String get signIn => 'Bejelentkezés';

  @override
  String get cancel => 'Mégsem';

  @override
  String get noPrayersRecorded => 'Nincsenek rögzített imák';

  @override
  String get deletePost => 'Törlés';

  @override
  String get reportPost => 'Jelentés';

  @override
  String get reportSubmitted => 'Jelentés elküldve. Köszönjük.';

  @override
  String get reportReasonHint =>
      'Írd le a jelentés okát. E-mailben kerül elküldésre.';

  @override
  String get reportReasonPlaceholder => 'Add meg a jelentés okát...';

  @override
  String get reportSubmitButton => 'Jelentés';

  @override
  String get deleteConfirmTitle => 'Bejegyzés törlése';

  @override
  String get deleteConfirmMessage =>
      'Biztosan törölni szeretnéd ezt a bejegyzést?';

  @override
  String get errorNetwork =>
      'Ellenőrizd az internetkapcsolatot, és próbáld újra.';

  @override
  String get errorAiFallback =>
      'Az AI jelenleg nem elérhető. Íme egy ige neked.';

  @override
  String get errorSttFailed => 'A hangfelismerés nem elérhető. Kérjük, gépelj.';

  @override
  String get errorPayment =>
      'Probléma történt a fizetéssel. Próbáld újra a Beállításokban.';

  @override
  String get errorGeneric => 'Valami hiba történt. Próbáld újra később.';

  @override
  String get offlineNotice =>
      'Offline vagy. Egyes funkciók korlátozottak lehetnek.';

  @override
  String get retryButton => 'Újrapróbálás';

  @override
  String get groupSection => 'Csoportjaim';

  @override
  String get createGroup => 'Imacsoport létrehozása';

  @override
  String get inviteFriends => 'Barátok meghívása';

  @override
  String get groupInviteMessage =>
      'Imádkozzunk együtt! Csatlakozz az imacsoportomhoz az Abba-ban.';

  @override
  String get noGroups =>
      'Csatlakozz vagy hozz létre egy csoportot a közös imádkozáshoz.';

  @override
  String get promoTitle => 'Bevezető akció';

  @override
  String get promoBanner => 'Az első 3 hónap 1590Ft/hó!';

  @override
  String promoEndsOn(Object date) {
    return 'Az ajánlat lejár: $date';
  }

  @override
  String get premiumLimitTitle => 'A mai ima befejeződött';

  @override
  String get premiumLimitBody =>
      'Holnap találkozunk!\nImádkozz korlátlanul Prémiummal';

  @override
  String get laterButton => 'Talán később';

  @override
  String get premiumPromptTitle => 'Pro funkció';

  @override
  String get premiumPromptBody =>
      'Ez a funkció Pro-val érhető el.\nSzeretnéd megtekinteni a csomagjainkat?';

  @override
  String get viewProducts => 'Csomagok megtekintése';

  @override
  String get maybeLater => 'Talán később';

  @override
  String get premiumHeadline => 'Közelebb Istenhez, minden nap';

  @override
  String get premiumBenefit1 => 'Korlátlan ima és csendes idő';

  @override
  String get premiumBenefit2 => 'AI-alapú ima és útmutatás';

  @override
  String get premiumBenefit3 => 'Hittörténetek a múltból';

  @override
  String get premiumBenefit4 => 'Ima felolvasás (TTS)';

  @override
  String get premiumBenefit5 => 'Bibliatanulmány eredeti nyelven';

  @override
  String get bestValue => 'LEGJOBB AJÁNLAT';

  @override
  String get perMonth => 'hó';

  @override
  String get cancelAnytime => 'Bármikor lemondható';

  @override
  String get restorePurchase => 'Vásárlás visszaállítása';

  @override
  String get yearlyPriceMonthly => '833Ft/hó';

  @override
  String get morningPrayerReminder => 'Reggeli ima';

  @override
  String get eveningGratitudeReminder => 'Esti hála';

  @override
  String get streakReminder => 'Sorozat emlékeztető';

  @override
  String get afternoonNudgeReminder => 'Délutáni ima emlékeztető';

  @override
  String get weeklySummaryReminder => 'Heti összefoglaló';

  @override
  String get unlimited => 'Korlátlan';

  @override
  String get streakRecovery => 'Semmi baj, újrakezdheted 🌱';

  @override
  String get prayerSaved => 'Ima sikeresen mentve';

  @override
  String get quietTimeLabel => 'Csendes idő';

  @override
  String get morningPrayerLabel => 'Reggeli ima';

  @override
  String get gardenSeed => 'A hit magja';

  @override
  String get gardenSprout => 'Növekvő hajtás';

  @override
  String get gardenBud => 'Bimbózó virág';

  @override
  String get gardenBloom => 'Teljes virágzás';

  @override
  String get gardenTree => 'Erős fa';

  @override
  String get gardenForest => 'Imaerdő';

  @override
  String get milestoneShare => 'Megosztás';

  @override
  String get milestoneThankGod => 'Hála Istennek!';

  @override
  String shareStreakText(Object count) {
    return '$count napos imasorozat! Az imaútam az Abba-val #Abba #Ima';
  }

  @override
  String get shareDaysLabel => 'napos imasorozat';

  @override
  String get shareSubtitle => 'Mindennapi ima Istennel';

  @override
  String get premiumActive => 'Tagság Aktív';

  @override
  String get planOncePerDay => '1x/nap';

  @override
  String get planUnlimited => 'Korlátlan';

  @override
  String get closeRecording => 'Felvétel bezárása';

  @override
  String get qtRevealMessage => 'Nyissuk meg a mai Igét';

  @override
  String get qtSelectPrompt => 'Válassz egyet és kezdd el a mai csendes időt';

  @override
  String get qtTopicLabel => 'Téma';

  @override
  String get prayerStartPrompt => 'Kezdd el az imádat';

  @override
  String get startPrayerButton => 'Ima indítása';

  @override
  String get switchToTextMode => 'Inkább gépelés';

  @override
  String get prayerDashboardTitle => 'Imakert';

  @override
  String get qtDashboardTitle => 'Csendes idő kert';

  @override
  String get prayerSummaryTitle => 'Ima összefoglaló';

  @override
  String get gratitudeLabel => 'Hála';

  @override
  String get petitionLabel => 'Kérés';

  @override
  String get intercessionLabel => 'Közbenjárás';

  @override
  String get historicalStoryTitle => 'Történet a múltból';

  @override
  String get todayLesson => 'Mai lecke';

  @override
  String get meditationAnalysisTitle => 'Meditáció elemzés';

  @override
  String get keyThemeLabel => 'Kulcs téma';

  @override
  String get applicationTitle => 'Mai alkalmazás';

  @override
  String get applicationWhat => 'Mit';

  @override
  String get applicationWhen => 'Mikor';

  @override
  String get applicationContext => 'Hol';

  @override
  String get relatedKnowledgeTitle => 'Kapcsolódó tudás';

  @override
  String get originalWordLabel => 'Eredeti szó';

  @override
  String get historicalContextLabel => 'Történelmi háttér';

  @override
  String get crossReferencesLabel => 'Kereszthivatkozások';

  @override
  String get growthStoryTitle => 'Növekedési történet';

  @override
  String get prayerGuideTitle => 'Hogyan imádkozz az Abba-val';

  @override
  String get prayerGuide1 => 'Imádkozz hangosan vagy tiszta hangon';

  @override
  String get prayerGuide2 =>
      'Az Abba hallja a szavaidat és Szentírást talál, ami a szívedhez szól';

  @override
  String get prayerGuide3 => 'Az imádat be is gépelheted';

  @override
  String get qtGuideTitle => 'Hogyan tölts csendes időt az Abba-val';

  @override
  String get qtGuide1 => 'Olvasd el az igeszakaszt és elmélkedj csendben';

  @override
  String get qtGuide2 =>
      'Oszd meg, amit felfedeztél — mondd el vagy gépeld be a gondolataidat';

  @override
  String get qtGuide3 =>
      'Az Abba segít alkalmazni az Igét a mindennapi életedben';

  @override
  String get scriptureReasonLabel => 'Miért ez a Szentírás';

  @override
  String get seeMore => 'Több megtekintése';

  @override
  String seeAllComments(Object count) {
    return 'Mind a $count hozzászólás megtekintése';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name és még $count másnak tetszik';
  }

  @override
  String get commentsTitle => 'Hozzászólások';

  @override
  String get myPageTitle => 'Az én imakertem';

  @override
  String get myPrayers => 'Imáim';

  @override
  String get myTestimonies => 'Bizonyságtételeim';

  @override
  String get savedPosts => 'Mentett';

  @override
  String get totalPrayersCount => 'Imák';

  @override
  String get streakCount => 'Sorozat';

  @override
  String get testimoniesCount => 'Bizonyságtételek';

  @override
  String get linkAccountTitle => 'Fiók összekapcsolása';

  @override
  String get linkAccountDescription =>
      'Kapcsold össze a fiókodat, hogy megőrizd az imafeljegyzéseidet eszközváltáskor';

  @override
  String get linkWithApple => 'Összekapcsolás Apple-lel';

  @override
  String get linkWithGoogle => 'Összekapcsolás Google-lel';

  @override
  String get linkAccountSuccess => 'Fiók sikeresen összekapcsolva!';

  @override
  String get anonymousUser => 'Imaharcos';

  @override
  String showReplies(Object count) {
    return '$count válasz megtekintése';
  }

  @override
  String get hideReplies => 'Válaszok elrejtése';

  @override
  String replyingTo(Object name) {
    return 'Válasz neki: $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Mind a $count hozzászólás megtekintése';
  }

  @override
  String get membershipTitle => 'Tagság';

  @override
  String get membershipSubtitle => 'Mélyítsd el imaéletedet';

  @override
  String get monthlyPlan => 'Havi';

  @override
  String get yearlyPlan => 'Éves';

  @override
  String get yearlySavings => '1 916 Ft/hó (37% kedvezmény)';

  @override
  String get startMembership => 'Indítás';

  @override
  String get membershipActive => 'Tagság Aktív';

  @override
  String get leaveRecordingTitle => 'Kilép a felvételből?';

  @override
  String get leaveRecordingMessage => 'A felvétel elvész. Biztosan kilép?';

  @override
  String get leaveButton => 'Kilépés';

  @override
  String get stayButton => 'Maradok';
}
