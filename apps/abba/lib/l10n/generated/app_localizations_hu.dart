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
  String get aiErrorNetworkTitle => 'Instabil kapcsolat';

  @override
  String get aiErrorNetworkBody =>
      'Az imádságod biztonságban van elmentve. Kérjük, próbáld újra egy pillanat múlva.';

  @override
  String get aiErrorApiTitle => 'Az AI szolgáltatás instabil';

  @override
  String get aiErrorApiBody =>
      'Az imádságod biztonságban van elmentve. Kérjük, próbáld újra egy pillanat múlva.';

  @override
  String get aiErrorRetry => 'Próbáld újra';

  @override
  String get aiErrorWaitAndCheck =>
      'Később újra megpróbáljuk az elemzést. Gyere vissza hamarosan — az imádságod várni fog.';

  @override
  String get aiErrorHome => 'Vissza a főoldalra';

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
  String get testimonyTitle => 'Bizonyság · Imádságom';

  @override
  String get testimonyHelperText =>
      'Gondolkodj el az imádon · megosztható a közösséggel';

  @override
  String get myPrayerAudioLabel => 'Imádságom felvétele';

  @override
  String get testimonyEdit => 'Szerkesztés';

  @override
  String get guidanceTitle => 'AI útmutatás';

  @override
  String get aiPrayerTitle => 'Ima neked';

  @override
  String get originalLangTitle => 'Eredeti nyelv';

  @override
  String get proUnlock => 'Feloldás Pro';

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
  String get proSection => 'Tagság';

  @override
  String get freePlan => 'Ingyenes';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '2 490 Ft / hó';

  @override
  String get yearlyPrice => '18 990 Ft / év';

  @override
  String get yearlySave => '40% megtakarítás';

  @override
  String get launchPromo => '';

  @override
  String get startPro => 'Pro indítása';

  @override
  String get comingSoon => 'Hamarosan';

  @override
  String get notificationSetting => 'Értesítések';

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
  String get promoBanner => '';

  @override
  String promoEndsOn(Object date) {
    return 'Az ajánlat lejár: $date';
  }

  @override
  String get proLimitTitle => 'A mai ima befejeződött';

  @override
  String get proLimitBody => 'Holnap találkozunk!\nImádkozz korlátlanul Promal';

  @override
  String get laterButton => 'Talán később';

  @override
  String get proPromptTitle => 'Pro funkció';

  @override
  String get proPromptBody =>
      'Ez a funkció Pro-val érhető el.\nSzeretnéd megtekinteni a csomagjainkat?';

  @override
  String get viewProducts => 'Csomagok megtekintése';

  @override
  String get maybeLater => 'Talán később';

  @override
  String get proHeadline => 'Közelebb Istenhez, minden nap';

  @override
  String get proBenefit1 => 'Korlátlan ima és csendes idő';

  @override
  String get proBenefit2 => 'AI-alapú ima és útmutatás';

  @override
  String get proBenefit3 => 'Hittörténetek a múltból';

  @override
  String get proBenefit5 => 'Bibliatanulmány eredeti nyelven';

  @override
  String get bestValue => 'LEGJOBB AJÁNLAT';

  @override
  String get perMonth => 'hó';

  @override
  String get cancelAnytime => 'Bármikor lemondható';

  @override
  String get restorePurchase => 'Vásárlás visszaállítása';

  @override
  String get yearlyPriceMonthly => '1 583 Ft/hó';

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
  String get proActive => 'Tagság Aktív';

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
  String get switchToVoiceMode => 'Beszéljen';

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
  String get applicationTitle => 'Mai alkalmazás';

  @override
  String get applicationWhat => 'Mit';

  @override
  String get applicationWhen => 'Mikor';

  @override
  String get applicationContext => 'Hol';

  @override
  String get applicationMorningLabel => 'Reggel';

  @override
  String get applicationDayLabel => 'Nappal';

  @override
  String get applicationEveningLabel => 'Este';

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
  String get scripturePostureLabel => 'Milyen lelkülettel olvassam?';

  @override
  String get scriptureOriginalWordsTitle =>
      'Mélyebb jelentés az eredeti nyelven';

  @override
  String get originalWordMeaningLabel => 'Jelentés';

  @override
  String get originalWordNuanceLabel => 'Árnyalat vs fordítás';

  @override
  String originalWordsCountLabel(int count) {
    return '$count szó';
  }

  @override
  String get seeMore => 'Több megtekintése';

  @override
  String get seeLess => 'Kevesebb megtekintése';

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
  String get yearlySavings => '907 Ft/hó (40% kedvezmény)';

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

  @override
  String likedByCount(Object count) {
    return '$count ember együttérzett';
  }

  @override
  String get actionLike => 'Tetszik';

  @override
  String get actionComment => 'Hozzászólás';

  @override
  String get actionSave => 'Mentés';

  @override
  String get manageSubscription => 'Manage Subscription';

  @override
  String currentPlan(String plan) {
    return 'Current Plan: $plan';
  }

  @override
  String nextBillingDate(String date) {
    return 'Next billing: $date';
  }

  @override
  String get upgradeToYearly => 'Upgrade to Yearly — Save 40%';

  @override
  String get upgradeSuccess => 'Upgraded to Yearly 🌸';

  @override
  String get purchaseSuccess => 'Your subscription is now active 🌸';

  @override
  String get purchaseFailedNetwork => 'Please check your network connection';

  @override
  String get purchaseFailedGeneric => 'Something went wrong. Please try again.';

  @override
  String get restoreInProgress => 'Restoring your subscription...';

  @override
  String get restoreSuccess => 'Subscription restored ✅';

  @override
  String get restoreNothing => 'No purchases to restore';

  @override
  String get restoreTimeout => 'Timed out. Please try again.';

  @override
  String get restoreFailed => 'Restore failed. Please try again later.';

  @override
  String get subscriptionExpiredTitle => 'Subscription Expired';

  @override
  String subscriptionExpiredBody(String date) {
    return 'Your subscription expired on $date. Resubscribe to continue enjoying Abba Pro.';
  }

  @override
  String get billingIssueTitle => 'Fizetési probléma észlelve';

  @override
  String billingIssueBody(int days) {
    return 'Pro előnyei $days nap múlva megszűnnek, ha a fizetés nem frissül.';
  }

  @override
  String get billingIssueAction => 'Fizetés frissítése';

  @override
  String accessUntil(String date) {
    return 'Access until: $date';
  }

  @override
  String subscriptionCancelledNotice(String date) {
    return 'Your subscription has been cancelled. You\'ll have access until $date.';
  }

  @override
  String get qtLoadingHint1 =>
      '💛 Szeretet — Gondolj 10 másodpercig valakire, akit szeretsz';

  @override
  String get qtLoadingHint2 =>
      '🌿 Kegyelem — Emlékezz egy kis kegyelemre, amit ma kaptál';

  @override
  String get qtLoadingHint3 =>
      '🌅 Remény — Képzelj el egy kis reményt a holnapra';

  @override
  String get qtLoadingHint4 =>
      '🕊️ Békesség — Lélegezz háromszor lassan, mélyen';

  @override
  String get qtLoadingHint5 => '🌳 Hit — Emlékezz egy változhatatlan igazságra';

  @override
  String get qtLoadingHint6 =>
      '🌸 Hála — Nevezz meg egy dolgot, amiért most hálás vagy';

  @override
  String get qtLoadingHint7 =>
      '🌊 Megbocsátás — Idézd fel valakit, akinek meg akarsz bocsátani';

  @override
  String get qtLoadingHint8 =>
      '📖 Bölcsesség — Őrizd meg a mai nap egy tanulságát';

  @override
  String get qtLoadingHint9 => '⏳ Türelem — Gondolj arra, amire csendben vársz';

  @override
  String get qtLoadingHint10 => '✨ Öröm — Emlékezz egy mosolyra a mai napból';

  @override
  String get qtLoadingTitle => 'A mai Ige előkészítése folyamatban...';

  @override
  String get coachingTitle => 'Imakoucholás';

  @override
  String get coachingLoadingText => 'Elmélkedünk az imádságodon...';

  @override
  String get coachingErrorText => 'Átmeneti hiba — kérjük, próbálja újra';

  @override
  String get coachingRetryButton => 'Újra';

  @override
  String get coachingScoreSpecificity => 'Konkrétság';

  @override
  String get coachingScoreGodCentered => 'Istenközpontúság';

  @override
  String get coachingScoreActs => 'ACTS egyensúly';

  @override
  String get coachingScoreAuthenticity => 'Hitelesség';

  @override
  String get coachingStrengthsTitle => 'Amit jól csináltál ✨';

  @override
  String get coachingImprovementsTitle => 'Hogy elmélyülj 💡';

  @override
  String get coachingProCta => 'Oldja fel az Imakoucholást Pro-val';

  @override
  String get coachingLevelBeginner => '🌱 Kezdő';

  @override
  String get coachingLevelGrowing => '🌿 Fejlődő';

  @override
  String get coachingLevelExpert => '🌳 Szakértő';

  @override
  String get aiPrayerCitationsTitle => 'Hivatkozások · Idézetek';

  @override
  String get citationTypeQuote => 'Idézet';

  @override
  String get citationTypeScience => 'Kutatás';

  @override
  String get citationTypeExample => 'Példa';

  @override
  String get citationTypeHistory => 'Történelem';

  @override
  String get aiPrayerReadingTime => '2 perces olvasás';

  @override
  String get scriptureKeyWordHintTitle => 'A mai kulcsszó';

  @override
  String get bibleLookupReferenceHint =>
      'Keresd meg ezt a szakaszt a saját Bibliádban, és elmélkedj rajta.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Biblia fordítások';

  @override
  String get settingsBibleTranslationsIntro =>
      'A Biblia-versek ebben az alkalmazásban közkincsű fordításokból származnak. A mesterséges intelligencia által generált kommentárok, imák és történetek az Abba kreatív munkája.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'QT coaching';

  @override
  String get qtCoachingLoadingText => 'Elmélkedünk az elmélkedéseden...';

  @override
  String get qtCoachingErrorText => 'Átmeneti hiba — kérjük, próbálja újra';

  @override
  String get qtCoachingRetryButton => 'Újra';

  @override
  String get qtCoachingScoreComprehension => 'Szövegértés';

  @override
  String get qtCoachingScoreApplication => 'Személyes alkalmazás';

  @override
  String get qtCoachingScoreDepth => 'Lelki mélység';

  @override
  String get qtCoachingScoreAuthenticity => 'Hitelesség';

  @override
  String get qtCoachingStrengthsTitle => 'Amit jól csináltál ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Hogy elmélyülj 💡';

  @override
  String get qtCoachingProCta => 'Oldja fel a QT coachingot Pro-val';

  @override
  String get qtCoachingLevelBeginner => '🌱 Kezdő';

  @override
  String get qtCoachingLevelGrowing => '🌿 Fejlődő';

  @override
  String get qtCoachingLevelExpert => '🌳 Szakértő';

  @override
  String get notifyMorning1Title => '🙏 Ima ideje';

  @override
  String notifyMorning1Body(String name) {
    return '$name, beszélgess Istennel ma is';
  }

  @override
  String get notifyMorning2Title => '🌅 Új reggel virradt';

  @override
  String notifyMorning2Body(String name) {
    return '$name, kezdd a napot hálával';
  }

  @override
  String get notifyMorning3Title => '✨ A mai kegyelem';

  @override
  String notifyMorning3Body(String name) {
    return '$name, találkozz a kegyelemmel, amit Isten készített';
  }

  @override
  String get notifyMorning4Title => '🕊️ Békés reggel';

  @override
  String notifyMorning4Body(String name) {
    return '$name, töltsd meg szíved békével ima által';
  }

  @override
  String get notifyMorning5Title => '📖 Az Igével';

  @override
  String notifyMorning5Body(String name) {
    return '$name, figyelj ma Isten hangjára';
  }

  @override
  String get notifyMorning6Title => '🌿 Pihenés ideje';

  @override
  String notifyMorning6Body(String name) {
    return '$name, állj meg egy pillanatra és imádkozz';
  }

  @override
  String get notifyMorning7Title => '💫 Ma is';

  @override
  String notifyMorning7Body(String name) {
    return '$name, az imával kezdődő nap más';
  }

  @override
  String get notifyEvening1Title => '✨ Hála a mai napért';

  @override
  String get notifyEvening1Body => 'Tekints vissza a napra és mondj hálaimát';

  @override
  String get notifyEvening2Title => '🌙 A nap lezárása';

  @override
  String get notifyEvening2Body => 'Fejezd ki a mai hálát imában';

  @override
  String get notifyEvening3Title => '🙏 Esti ima';

  @override
  String get notifyEvening3Body => 'A nap végén adj hálát Istennek';

  @override
  String get notifyEvening4Title => '🌟 A mai áldásokat számolva';

  @override
  String get notifyEvening4Body => 'Ha van miért hálát adnod, oszd meg imában';

  @override
  String get notifyStreak3Title => '🌱 3 nap egymás után!';

  @override
  String get notifyStreak3Body => 'Az imaszokásod elkezdődött';

  @override
  String get notifyStreak7Title => '🌿 Egy egész hét!';

  @override
  String get notifyStreak7Body => 'Az ima szokássá válik';

  @override
  String get notifyStreak14Title => '🌳 2 hét egymás után!';

  @override
  String get notifyStreak14Body => 'Lenyűgöző fejlődés!';

  @override
  String get notifyStreak21Title => '🌻 3 hét egymás után!';

  @override
  String get notifyStreak21Body => 'Az ima virága kinyílik';

  @override
  String get notifyStreak30Title => '🏆 Egy egész hónap!';

  @override
  String get notifyStreak30Body => 'Az imád ragyog';

  @override
  String get notifyStreak50Title => '👑 50 nap egymás után!';

  @override
  String get notifyStreak50Body => 'Az Istennel való járásod mélyül';

  @override
  String get notifyStreak100Title => '🎉 100 nap egymás után!';

  @override
  String get notifyStreak100Body => 'Imaharcossá váltál!';

  @override
  String get notifyStreak365Title => '✝️ Egy egész év!';

  @override
  String get notifyStreak365Body => 'Csodálatos hitbeli utazás!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ Imádkoztál már ma?';

  @override
  String get notifyAfternoonNudgeBody =>
      'Egy rövid ima megváltoztathatja a napot';

  @override
  String get notifyChannelName => 'Ima emlékeztetők';

  @override
  String get notifyChannelDescription =>
      'Reggeli ima, esti hála és egyéb emlékeztetők';

  @override
  String get milestoneFirstPrayerTitle => 'Első ima!';

  @override
  String get milestoneFirstPrayerDesc =>
      'Imautazásod elkezdődött. Isten hallgat.';

  @override
  String get milestoneSevenDayStreakTitle => '7 napos ima!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'Egy hét hűséges ima. A kerted növekszik!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 nap!';

  @override
  String get milestoneThirtyDayStreakDesc => 'A kerted virágmezővé vált!';

  @override
  String get milestoneHundredPrayersTitle => '100. ima!';

  @override
  String get milestoneHundredPrayersDesc =>
      'Száz beszélgetés Istennel. Mélyen gyökeret eresztettél.';

  @override
  String get homeFirstPrayerPrompt => 'Kezdd el az első imádat';

  @override
  String get homeFirstQtPrompt => 'Kezdd el az első QT-dat';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Ma is $activityName';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return '$count. folyamatos $activityName napja';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return '$days napja volt az utolsó $activityName';
  }

  @override
  String get homeActivityPrayer => 'ima';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Betöltés...';

  @override
  String get heatmapNoPrayer => 'Nincs ima';

  @override
  String get heatmapLegendLess => 'Kevesebb';

  @override
  String get heatmapLegendMore => 'Több';

  @override
  String get qtPassagesLoadError =>
      'A mai igék betöltése nem sikerült. Ellenőrizze a kapcsolatot.';

  @override
  String get qtPassagesRetryButton => 'Újrapróbálkozás';

  @override
  String get aiStreamingInitial => 'Elmélkedünk az imádságodon...';

  @override
  String get aiTierProcessing => 'További gondolatok érkeznek...';

  @override
  String get aiScriptureValidating => 'Keressük a megfelelő igehelyet...';

  @override
  String get aiScriptureValidatingFailed =>
      'Készítjük számodra ezt az igehelyet...';

  @override
  String get aiTemplateFallback => 'Miközben elkészítjük a teljes elemzést...';

  @override
  String get aiPendingMore => 'Még többet készítünk...';

  @override
  String get aiTierIncomplete => 'Hamarosan, nézz vissza később';

  @override
  String get tierCompleted => 'Új elmélkedés hozzáadva';

  @override
  String get tierProcessingNotice => 'További elmélkedéseket készítünk...';

  @override
  String get proSectionLoading => 'Készítjük a prémium tartalmat...';

  @override
  String get proSectionWillArrive => 'A mélyebb elmélkedés itt jelenik meg';

  @override
  String get templateCategoryHealth => 'Egészségügyi aggodalmakért';

  @override
  String get templateCategoryFamily => 'A családért';

  @override
  String get templateCategoryWork => 'Munkáért és tanulásért';

  @override
  String get templateCategoryGratitude => 'Hálás szív';

  @override
  String get templateCategoryGrief => 'Gyászban vagy veszteségben';

  @override
  String get sectionStatusCompleted => 'Elemzés kész';

  @override
  String get sectionStatusPartial => 'Részleges elemzés (további jön)';

  @override
  String get sectionStatusPending => 'Elemzés folyamatban';

  @override
  String get trialStartCta => 'Start 1 month free';

  @override
  String trialAutoRenewDisclosure(Object price) {
    return 'Then $price/year, auto-renews. Cancel anytime in Settings.';
  }

  @override
  String get trialLimitTitle => 'You\'ve prayed 3 times today 🌸';

  @override
  String get trialLimitBody =>
      'Come back tomorrow — or unlock unlimited prayer with Pro.';

  @override
  String get trialLimitCta => 'Continue with Pro';
}
