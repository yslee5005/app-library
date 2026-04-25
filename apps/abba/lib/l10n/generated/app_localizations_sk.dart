// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Keď sa modlíš,\nBoh odpovedá.';

  @override
  String get welcomeSubtitle => 'Tvoj denný spoločník pre modlitbu a tichý čas';

  @override
  String get getStarted => 'Začať';

  @override
  String get loginTitle => 'Vitajte v Abba';

  @override
  String get loginSubtitle => 'Prihláste sa a začnite svoju modlitebnú cestu';

  @override
  String get signInWithApple => 'Pokračovať cez Apple';

  @override
  String get signInWithGoogle => 'Pokračovať cez Google';

  @override
  String get signInWithEmail => 'Pokračovať cez e-mail';

  @override
  String greetingMorning(Object name) {
    return 'Dobré ráno, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Dobré popoludnie, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Dobrý večer, $name';
  }

  @override
  String get prayButton => 'Modli sa';

  @override
  String get qtButton => 'Tichý čas';

  @override
  String streakDays(Object count) {
    return '$count dní nepretržitej modlitby';
  }

  @override
  String get dailyVerse => 'Verš dňa';

  @override
  String get tabHome => 'Domov';

  @override
  String get tabCalendar => 'Kalendár';

  @override
  String get tabCommunity => 'Komunita';

  @override
  String get tabSettings => 'Nastavenia';

  @override
  String get recordingTitle => 'Modlím sa...';

  @override
  String get recordingPause => 'Pauza';

  @override
  String get recordingResume => 'Pokračovať';

  @override
  String get finishPrayer => 'Ukončiť modlitbu';

  @override
  String get finishPrayerConfirm => 'Chcete ukončiť modlitbu?';

  @override
  String get switchToText => 'Napísať namiesto toho';

  @override
  String get textInputHint => 'Napíšte svoju modlitbu sem...';

  @override
  String get aiLoadingText => 'Premýšľam nad vašou modlitbou...';

  @override
  String get aiLoadingVerse =>
      'Utíšte sa a vedzte, že ja som Boh.\n— Žalm 46:10';

  @override
  String get aiErrorNetworkTitle => 'Spojenie je nestabilné';

  @override
  String get aiErrorNetworkBody =>
      'Tvoja modlitba je bezpečne uložená. Skús to znova o chvíľu, prosím.';

  @override
  String get aiErrorApiTitle => 'AI služba je nestabilná';

  @override
  String get aiErrorApiBody =>
      'Tvoja modlitba je bezpečne uložená. Skús to znova o chvíľu, prosím.';

  @override
  String get aiErrorRetry => 'Skúsiť znova';

  @override
  String get aiErrorWaitAndCheck =>
      'Analýzu skúsime neskôr. Vráť sa čoskoro — tvoja modlitba bude čakať.';

  @override
  String get aiErrorHome => 'Späť domov';

  @override
  String get dashboardTitle => 'Modlitebná Záhrada';

  @override
  String get shareButton => 'Zdieľať';

  @override
  String get backToHome => 'Späť na domov';

  @override
  String get scriptureTitle => 'Dnešné Písmo';

  @override
  String get bibleStoryTitle => 'Biblický príbeh';

  @override
  String get testimonyTitle => 'Svedectvo · Moja modlitba';

  @override
  String get testimonyHelperText =>
      'Zamysli sa nad svojou modlitbou · možno zdieľať s komunitou';

  @override
  String get myPrayerAudioLabel => 'Nahrávka mojej modlitby';

  @override
  String get testimonyEdit => 'Upraviť';

  @override
  String get guidanceTitle => 'AI vedenie';

  @override
  String get aiPrayerTitle => 'Modlitba pre vás';

  @override
  String get originalLangTitle => 'Pôvodný jazyk';

  @override
  String get proUnlock => 'Odomknúť s Pro';

  @override
  String get proPreviewHistoricalHint =>
      'Discover the deeper history behind a word from your prayer';

  @override
  String get proPreviewPrayerHint =>
      'A 300-word prayer is waiting just for you';

  @override
  String get proPreviewCoachingHint =>
      'One coaching tip waits to deepen your next prayer';

  @override
  String get qtPageTitle => 'Ranná Záhrada';

  @override
  String get qtMeditateButton => 'Začať meditáciu';

  @override
  String get qtCompleted => 'Dokončené';

  @override
  String get communityTitle => 'Modlitebná Záhrada';

  @override
  String get filterAll => 'Všetko';

  @override
  String get filterTestimony => 'Svedectvo';

  @override
  String get filterPrayerRequest => 'Modlitebná prosba';

  @override
  String get likeButton => 'Páči sa mi';

  @override
  String get commentButton => 'Komentár';

  @override
  String get saveButton => 'Uložiť';

  @override
  String get replyButton => 'Odpovedať';

  @override
  String get writePostTitle => 'Zdieľať';

  @override
  String get cancelButton => 'Zrušiť';

  @override
  String get sharePostButton => 'Zverejniť';

  @override
  String get anonymousToggle => 'Anonymne';

  @override
  String get realNameToggle => 'Skutočné meno';

  @override
  String get categoryTestimony => 'Svedectvo';

  @override
  String get categoryPrayerRequest => 'Modlitebná prosba';

  @override
  String get writePostHint =>
      'Zdieľajte svoje svedectvo alebo modlitebnú prosbu...';

  @override
  String get importFromPrayer => 'Importovať z modlitby';

  @override
  String get calendarTitle => 'Modlitebný kalendár';

  @override
  String get currentStreak => 'Aktuálna séria';

  @override
  String get bestStreak => 'Najlepšia séria';

  @override
  String get days => 'dní';

  @override
  String calendarRecordCount(Object count) {
    return '$count záznamov';
  }

  @override
  String get todayVerse => 'Verš dňa';

  @override
  String get settingsTitle => 'Nastavenia';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Celkový počet modlitieb';

  @override
  String get consecutiveDays => 'Po sebe nasledujúce dni';

  @override
  String get proSection => 'Členstvo';

  @override
  String get freePlan => 'Zadarmo';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '6,99€ / mes';

  @override
  String get yearlyPrice => '49,99€ / rok';

  @override
  String get yearlySave => 'Ušetrite 40%';

  @override
  String get launchPromo => '';

  @override
  String get startPro => 'Začať Pro';

  @override
  String get comingSoon => 'Čoskoro';

  @override
  String get notificationSetting => 'Upozornenia';

  @override
  String get languageSetting => 'Jazyk';

  @override
  String get darkModeSetting => 'Tmavý režim';

  @override
  String get helpCenter => 'Centrum pomoci';

  @override
  String get termsOfService => 'Podmienky používania';

  @override
  String get privacyPolicy => 'Zásady ochrany súkromia';

  @override
  String get logout => 'Odhlásiť sa';

  @override
  String appVersion(Object version) {
    return 'Verzia $version';
  }

  @override
  String get anonymous => 'Anonymne';

  @override
  String timeAgo(Object time) {
    return 'pred $time';
  }

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Heslo';

  @override
  String get signIn => 'Prihlásiť sa';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get noPrayersRecorded => 'Žiadne zaznamenané modlitby';

  @override
  String get deletePost => 'Odstrániť';

  @override
  String get reportPost => 'Nahlásiť';

  @override
  String get reportSubmitted => 'Hlásenie bolo odoslané. Ďakujeme.';

  @override
  String get reportReasonHint =>
      'Prosím opíšte dôvod nahlásenia. Bude odoslané e-mailom.';

  @override
  String get reportReasonPlaceholder => 'Zadajte dôvod nahlásenia...';

  @override
  String get reportSubmitButton => 'Nahlásiť';

  @override
  String get deleteConfirmTitle => 'Odstrániť príspevok';

  @override
  String get deleteConfirmMessage =>
      'Ste si istí, že chcete odstrániť tento príspevok?';

  @override
  String get errorNetwork =>
      'Skontrolujte pripojenie na internet a skúste znova.';

  @override
  String get errorAiFallback =>
      'Nepodarilo sa spojiť s AI. Tu je verš pre vás.';

  @override
  String get errorSttFailed =>
      'Rozpoznávanie hlasu nie je k dispozícii. Prosím napíšte namiesto toho.';

  @override
  String get errorPayment =>
      'Nastal problém s platbou. Skúste znova v Nastaveniach.';

  @override
  String get errorGeneric => 'Niečo sa pokazilo. Skúste neskôr znova.';

  @override
  String get offlineNotice =>
      'Ste offline. Niektoré funkcie môžu byť obmedzené.';

  @override
  String get retryButton => 'Skúsiť znova';

  @override
  String get groupSection => 'Moje skupiny';

  @override
  String get createGroup => 'Vytvoriť modlitebnú skupinu';

  @override
  String get inviteFriends => 'Pozvať priateľov';

  @override
  String get groupInviteMessage =>
      'Modlime sa spolu! Pridaj sa k mojej modlitebnej skupine na Abba.';

  @override
  String get noGroups =>
      'Pridajte sa k skupine alebo vytvorte novú pre spoločnú modlitbu.';

  @override
  String get promoTitle => 'Úvodná ponuka';

  @override
  String get promoBanner => '';

  @override
  String promoEndsOn(Object date) {
    return 'Ponuka končí $date';
  }

  @override
  String get proLimitTitle => 'Dnešná modlitba je dokončená';

  @override
  String get proLimitBody => 'Vidíme sa zajtra!\nModlite sa neobmedzene s Pro';

  @override
  String get laterButton => 'Možno neskôr';

  @override
  String get proPromptTitle => 'Pro funkcia';

  @override
  String get proPromptBody =>
      'Táto funkcia je dostupná s Pro.\nChcete si pozrieť plány?';

  @override
  String get viewProducts => 'Zobraziť plány';

  @override
  String get maybeLater => 'Možno neskôr';

  @override
  String get proHeadline => 'Bližšie k Bohu každý deň';

  @override
  String get proBenefit1 => 'Neobmedzená modlitba a tichý čas';

  @override
  String get proBenefit2 => 'AI modlitba a vedenie';

  @override
  String get proBenefit3 => 'Príbehy viery z dejín';

  @override
  String get proBenefit5 => 'Štúdium Biblie v pôvodnom jazyku';

  @override
  String get bestValue => 'NAJLEPŠIA HODNOTA';

  @override
  String get perMonth => 'mes.';

  @override
  String get cancelAnytime => 'Zrušiť kedykoľvek';

  @override
  String get restorePurchase => 'Obnoviť nákup';

  @override
  String get yearlyPriceMonthly => '4,17€/mes';

  @override
  String get morningPrayerReminder => 'Ranná modlitba';

  @override
  String get eveningGratitudeReminder => 'Večerná vďačnosť';

  @override
  String get streakReminder => 'Pripomienka série';

  @override
  String get afternoonNudgeReminder => 'Pripomienka poobedňajšej modlitby';

  @override
  String get weeklySummaryReminder => 'Týždenný prehľad';

  @override
  String get unlimited => 'Neobmedzené';

  @override
  String get streakRecovery => 'Nevadí, môžeš začať odznova 🌱';

  @override
  String get prayerSaved => 'Modlitba bola uložená';

  @override
  String get quietTimeLabel => 'Tichý čas';

  @override
  String get morningPrayerLabel => 'Ranná modlitba';

  @override
  String get gardenSeed => 'Semienok viery';

  @override
  String get gardenSprout => 'Rastúci klíček';

  @override
  String get gardenBud => 'Púčik';

  @override
  String get gardenBloom => 'Plný kvet';

  @override
  String get gardenTree => 'Silný strom';

  @override
  String get gardenForest => 'Les modlitby';

  @override
  String get milestoneShare => 'Zdieľať';

  @override
  String get milestoneThankGod => 'Vďaka Bohu!';

  @override
  String shareStreakText(Object count) {
    return '$count dní nepretržitej modlitby! Moja modlitebná cesta s Abba #Abba #Modlitba';
  }

  @override
  String get shareDaysLabel => 'dní nepretržitej modlitby';

  @override
  String get shareSubtitle => 'Denná modlitba s Bohom';

  @override
  String get proActive => 'Členstvo Aktívne';

  @override
  String get planOncePerDay => '1x/deň';

  @override
  String get planUnlimited => 'Neobmedzené';

  @override
  String get closeRecording => 'Zavrieť nahrávanie';

  @override
  String get qtRevealMessage => 'Otvorme dnešné Slovo';

  @override
  String get qtSelectPrompt => 'Vyberte tému a začnite dnešný tichý čas';

  @override
  String get qtTopicLabel => 'Téma';

  @override
  String get prayerStartPrompt => 'Začnite svoju modlitbu';

  @override
  String get startPrayerButton => 'Začať modlitbu';

  @override
  String get switchToTextMode => 'Napísať namiesto toho';

  @override
  String get switchToVoiceMode => 'Hovorit';

  @override
  String get prayerDashboardTitle => 'Modlitebná Záhrada';

  @override
  String get qtDashboardTitle => 'Záhrada tichého času';

  @override
  String get prayerSummaryTitle => 'Zhrnutie modlitby';

  @override
  String get gratitudeLabel => 'Vďačnosť';

  @override
  String get petitionLabel => 'Prosba';

  @override
  String get intercessionLabel => 'Príhovor';

  @override
  String get historicalStoryTitle => 'Príbeh z dejín';

  @override
  String get todayLesson => 'Dnešná lekcia';

  @override
  String get applicationTitle => 'Dnešná aplikácia';

  @override
  String get applicationWhat => 'Čo';

  @override
  String get applicationWhen => 'Kedy';

  @override
  String get applicationContext => 'Kde';

  @override
  String get applicationMorningLabel => 'Ráno';

  @override
  String get applicationDayLabel => 'Deň';

  @override
  String get applicationEveningLabel => 'Večer';

  @override
  String get relatedKnowledgeTitle => 'Súvisiace poznatky';

  @override
  String get originalWordLabel => 'Pôvodné slovo';

  @override
  String get historicalContextLabel => 'Historický kontext';

  @override
  String get crossReferencesLabel => 'Krížové odkazy';

  @override
  String get growthStoryTitle => 'Príbeh rastu';

  @override
  String get prayerGuideTitle => 'Ako sa modliť s Abba';

  @override
  String get prayerGuide1 => 'Modlite sa nahlas alebo jasným hlasom';

  @override
  String get prayerGuide2 =>
      'Abba počúva vašu modlitbu a nájde verše, ktoré hovoria k vášmu srdcu';

  @override
  String get prayerGuide3 => 'Modlitbu môžete aj napísať';

  @override
  String get qtGuideTitle => 'Ako mať tichý čas s Abba';

  @override
  String get qtGuide1 => 'Prečítajte si pasáž a ticho meditujte';

  @override
  String get qtGuide2 =>
      'Podeľte sa o to, čo ste objavili — povedzte to alebo napíšte svoju reflexiu';

  @override
  String get qtGuide3 =>
      'Abba vám pomôže aplikovať Slovo do každodenného života';

  @override
  String get scriptureReasonLabel => 'Prečo tento verš';

  @override
  String get scripturePostureLabel => 'S akým postojom to mám čítať?';

  @override
  String get scriptureOriginalWordsTitle => 'Hlbší význam v pôvodnom jazyku';

  @override
  String get originalWordMeaningLabel => 'Význam';

  @override
  String get originalWordNuanceLabel => 'Nuansa vs preklad';

  @override
  String originalWordsCountLabel(int count) {
    return '$count slov';
  }

  @override
  String get seeMore => 'Zobraziť viac';

  @override
  String get seeLess => 'Zobraziť menej';

  @override
  String seeAllComments(Object count) {
    return 'Zobraziť všetkých $count komentárov';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name a ďalším $count sa to páči';
  }

  @override
  String get commentsTitle => 'Komentáre';

  @override
  String get myPageTitle => 'Moja Modlitebná Záhrada';

  @override
  String get myPrayers => 'Moje modlitby';

  @override
  String get myTestimonies => 'Moje svedectvá';

  @override
  String get savedPosts => 'Uložené';

  @override
  String get totalPrayersCount => 'Modlitby';

  @override
  String get streakCount => 'Séria';

  @override
  String get testimoniesCount => 'Svedectvá';

  @override
  String get linkAccountTitle => 'Prepojiť účet';

  @override
  String get linkAccountDescription =>
      'Prepojte svoj účet, aby ste si uchovali záznamy o modlitbách pri zmene zariadenia';

  @override
  String get linkWithApple => 'Prepojiť s Apple';

  @override
  String get linkWithGoogle => 'Prepojiť s Google';

  @override
  String get linkAccountSuccess => 'Účet bol úspešne prepojený!';

  @override
  String get anonymousUser => 'Modlitebný bojovník';

  @override
  String showReplies(Object count) {
    return 'Zobraziť $count odpovedí';
  }

  @override
  String get hideReplies => 'Skryť odpovede';

  @override
  String replyingTo(Object name) {
    return 'Odpovedáte na $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Zobraziť všetkých $count komentárov';
  }

  @override
  String get membershipTitle => 'Členstvo';

  @override
  String get membershipSubtitle => 'Prehĺbte svoj modlitebný život';

  @override
  String get monthlyPlan => 'Mesačne';

  @override
  String get yearlyPlan => 'Ročne';

  @override
  String get yearlySavings => '4,17€/mes (zľava 40%)';

  @override
  String get startMembership => 'Začať';

  @override
  String get membershipActive => 'Členstvo Aktívne';

  @override
  String get leaveRecordingTitle => 'Opustiť nahrávanie?';

  @override
  String get leaveRecordingMessage =>
      'Vaša nahrávka bude stratená. Ste si istí?';

  @override
  String get leaveButton => 'Opustiť';

  @override
  String get stayButton => 'Zostať';

  @override
  String likedByCount(Object count) {
    return '$count ľudí prejavilo súcit';
  }

  @override
  String get actionLike => 'Páči sa mi';

  @override
  String get actionComment => 'Komentár';

  @override
  String get actionSave => 'Uložiť';

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
  String get billingIssueTitle => 'Zistil sa problém s platbou';

  @override
  String billingIssueBody(int days) {
    return 'Vaše výhody Pro sa skončia o $days dní, ak sa platba neaktualizuje.';
  }

  @override
  String get billingIssueAction => 'Aktualizovať platbu';

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
      '💛 Láska — Myslite 10 sekúnd na niekoho, koho milujete';

  @override
  String get qtLoadingHint2 =>
      '🌿 Milosť — Spomeňte si na jednu malú milosť z dneška';

  @override
  String get qtLoadingHint3 =>
      '🌅 Nádej — Predstavte si malú nádej pre zajtrajšok';

  @override
  String get qtLoadingHint4 =>
      '🕊️ Pokoj — Trikrát sa pomaly a zhlboka nadýchnite';

  @override
  String get qtLoadingHint5 => '🌳 Viera — Spomeňte si na jednu nemennú pravdu';

  @override
  String get qtLoadingHint6 =>
      '🌸 Vďačnosť — Pomenujte jednu vec, za ktorú ste teraz vďační';

  @override
  String get qtLoadingHint7 =>
      '🌊 Odpustenie — Spomeňte si na niekoho, komu chcete odpustiť';

  @override
  String get qtLoadingHint8 =>
      '📖 Múdrosť — Uchovajte si jedno ponaučenie z dneška';

  @override
  String get qtLoadingHint9 =>
      '⏳ Trpezlivosť — Myslite na to, na čo potichu čakáte';

  @override
  String get qtLoadingHint10 => '✨ Radosť — Spomeňte si na úsmev z dneška';

  @override
  String get qtLoadingTitle => 'Pripravuje sa dnešné Slovo...';

  @override
  String get coachingTitle => 'Koučing modlitby';

  @override
  String get coachingLoadingText => 'Rozjímame nad vašou modlitbou...';

  @override
  String get coachingErrorText => 'Dočasná chyba — skúste to znova';

  @override
  String get coachingRetryButton => 'Skúsiť znova';

  @override
  String get coachingScoreSpecificity => 'Konkrétnosť';

  @override
  String get coachingScoreGodCentered => 'Bohocentrickosť';

  @override
  String get coachingScoreActs => 'Rovnováha ACTS';

  @override
  String get coachingScoreAuthenticity => 'Autentickosť';

  @override
  String get coachingStrengthsTitle => 'Čo ste urobili dobre ✨';

  @override
  String get coachingImprovementsTitle => 'Ako ísť hlbšie 💡';

  @override
  String get coachingProCta => 'Odomknite Koučing modlitby s Pro';

  @override
  String get coachingLevelBeginner => '🌱 Začiatočník';

  @override
  String get coachingLevelGrowing => '🌿 Rastúci';

  @override
  String get coachingLevelExpert => '🌳 Odborník';

  @override
  String get aiPrayerCitationsTitle => 'Odkazy · Citácie';

  @override
  String get citationTypeQuote => 'Citát';

  @override
  String get citationTypeScience => 'Výskum';

  @override
  String get citationTypeExample => 'Príklad';

  @override
  String get citationTypeHistory => 'História';

  @override
  String get aiPrayerReadingTime => 'Čítanie 2 minúty';

  @override
  String get scriptureKeyWordHintTitle => 'Dnešné kľúčové slovo';

  @override
  String get bibleLookupReferenceHint =>
      'Nájdite túto pasáž vo svojej Biblii a rozjímajte nad ňou.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Preklady Biblie';

  @override
  String get settingsBibleTranslationsIntro =>
      'Biblické verše v tejto aplikácii pochádzajú z prekladov vo verejnej doméne. Komentáre, modlitby a príbehy generované AI sú tvorivým dielom Abba.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'QT koučing';

  @override
  String get qtCoachingLoadingText => 'Rozjímame nad vaším rozjímaním...';

  @override
  String get qtCoachingErrorText => 'Dočasná chyba — skúste to znova';

  @override
  String get qtCoachingRetryButton => 'Skúsiť znova';

  @override
  String get qtCoachingScoreComprehension => 'Porozumenie textu';

  @override
  String get qtCoachingScoreApplication => 'Osobná aplikácia';

  @override
  String get qtCoachingScoreDepth => 'Duchovná hĺbka';

  @override
  String get qtCoachingScoreAuthenticity => 'Autentickosť';

  @override
  String get qtCoachingStrengthsTitle => 'Čo ste urobili dobre ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Ako ísť hlbšie 💡';

  @override
  String get qtCoachingProCta => 'Odomknite QT koučing s Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Začiatočník';

  @override
  String get qtCoachingLevelGrowing => '🌿 Rastúci';

  @override
  String get qtCoachingLevelExpert => '🌳 Odborník';

  @override
  String get notifyMorning1Title => '🙏 Čas modliť sa';

  @override
  String notifyMorning1Body(String name) {
    return '$name, porozprávaj sa s Bohom aj dnes';
  }

  @override
  String get notifyMorning2Title => '🌅 Prišlo nové ráno';

  @override
  String notifyMorning2Body(String name) {
    return '$name, začni deň s vďačnosťou';
  }

  @override
  String get notifyMorning3Title => '✨ Dnešná milosť';

  @override
  String notifyMorning3Body(String name) {
    return '$name, stretni sa s milosťou, ktorú Boh pripravil';
  }

  @override
  String get notifyMorning4Title => '🕊️ Pokojné ráno';

  @override
  String notifyMorning4Body(String name) {
    return '$name, naplň srdce pokojom cez modlitbu';
  }

  @override
  String get notifyMorning5Title => '📖 So Slovom';

  @override
  String notifyMorning5Body(String name) {
    return '$name, načúvaj dnes Božiemu hlasu';
  }

  @override
  String get notifyMorning6Title => '🌿 Čas na odpočinok';

  @override
  String notifyMorning6Body(String name) {
    return '$name, zastav sa na chvíľu a modli sa';
  }

  @override
  String get notifyMorning7Title => '💫 Aj dnes';

  @override
  String notifyMorning7Body(String name) {
    return '$name, deň začínajúci modlitbou je iný';
  }

  @override
  String get notifyEvening1Title => '✨ Vďaka za dnešok';

  @override
  String get notifyEvening1Body =>
      'Obzri sa za dňom a pomodli sa modlitbu vďaky';

  @override
  String get notifyEvening2Title => '🌙 Ukončenie dňa';

  @override
  String get notifyEvening2Body => 'Vyjadri dnešnú vďačnosť v modlitbe';

  @override
  String get notifyEvening3Title => '🙏 Večerná modlitba';

  @override
  String get notifyEvening3Body => 'Na konci dňa poďakuj Bohu';

  @override
  String get notifyEvening4Title => '🌟 Počítame dnešné požehnania';

  @override
  String get notifyEvening4Body =>
      'Ak máš za čo ďakovať, zdieľaj to v modlitbe';

  @override
  String get notifyStreak3Title => '🌱 3 dni po sebe!';

  @override
  String get notifyStreak3Body => 'Tvoj návyk modliť sa začal';

  @override
  String get notifyStreak7Title => '🌿 Celý týždeň!';

  @override
  String get notifyStreak7Body => 'Modlitba sa stáva zvykom';

  @override
  String get notifyStreak14Title => '🌳 2 týždne za sebou!';

  @override
  String get notifyStreak14Body => 'Úžasný rast!';

  @override
  String get notifyStreak21Title => '🌻 3 týždne za sebou!';

  @override
  String get notifyStreak21Body => 'Kvet modlitby rozkvitá';

  @override
  String get notifyStreak30Title => '🏆 Celý mesiac!';

  @override
  String get notifyStreak30Body => 'Tvoja modlitba žiari';

  @override
  String get notifyStreak50Title => '👑 50 dní po sebe!';

  @override
  String get notifyStreak50Body => 'Tvoja chôdza s Bohom sa prehlbuje';

  @override
  String get notifyStreak100Title => '🎉 100 dní po sebe!';

  @override
  String get notifyStreak100Body => 'Stal si sa modlitebným bojovníkom!';

  @override
  String get notifyStreak365Title => '✝️ Celý rok!';

  @override
  String get notifyStreak365Body => 'Úžasná cesta viery!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ Modlil si sa dnes?';

  @override
  String get notifyAfternoonNudgeBody => 'Krátka modlitba môže zmeniť deň';

  @override
  String get notifyChannelName => 'Pripomienky modlitby';

  @override
  String get notifyChannelDescription =>
      'Ranná modlitba, večerná vďačnosť a ďalšie pripomienky modlitby';

  @override
  String get milestoneFirstPrayerTitle => 'Prvá modlitba!';

  @override
  String get milestoneFirstPrayerDesc =>
      'Vaša modlitebná cesta začala. Boh počúva.';

  @override
  String get milestoneSevenDayStreakTitle => '7 dní modlitby!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'Týždeň vernej modlitby. Vaša záhrada rastie!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 dní!';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'Vaša záhrada rozkvitla v poli kvetov!';

  @override
  String get milestoneHundredPrayersTitle => '100. modlitba!';

  @override
  String get milestoneHundredPrayersDesc =>
      'Sto rozhovorov s Bohom. Máte hlboké korene.';

  @override
  String get homeFirstPrayerPrompt => 'Začnite svoju prvú modlitbu';

  @override
  String get homeFirstQtPrompt => 'Začnite svoj prvý QT';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Dnes tiež $activityName';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'Deň $count nepretržite $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'Od posledného $activityName uplynulo $days dní';
  }

  @override
  String get homeActivityPrayer => 'modlitba';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Načítava sa...';

  @override
  String get heatmapNoPrayer => 'Žiadna modlitba';

  @override
  String get heatmapLegendLess => 'Menej';

  @override
  String get heatmapLegendMore => 'Viac';

  @override
  String get qtPassagesLoadError =>
      'Dnešné verše sa nepodarilo načítať. Skontrolujte pripojenie.';

  @override
  String get qtPassagesRetryButton => 'Skúsiť znova';

  @override
  String get aiStreamingInitial => 'Rozjímame nad tvojou modlitbou...';

  @override
  String get aiTierProcessing => 'Ďalšie úvahy prichádzajú...';

  @override
  String get aiScriptureValidating => 'Hľadáme správny biblický text...';

  @override
  String get aiScriptureValidatingFailed =>
      'Pripravujeme pre teba tento text...';

  @override
  String get aiTemplateFallback => 'Kým pripravujeme úplnú analýzu...';

  @override
  String get aiPendingMore => 'Pripravujeme viac...';

  @override
  String get aiTierIncomplete => 'Už čoskoro, pozri sa neskôr';

  @override
  String get tierCompleted => 'Pridaná nová úvaha';

  @override
  String get tierProcessingNotice => 'Vytvárame ďalšie úvahy...';

  @override
  String get proSectionLoading => 'Pripravujeme tvoj prémiový obsah...';

  @override
  String get proSectionWillArrive => 'Tvoja hlboká úvaha sa zobrazí tu';

  @override
  String get templateCategoryHealth => 'Pre zdravotné starosti';

  @override
  String get templateCategoryFamily => 'Pre rodinu';

  @override
  String get templateCategoryWork => 'Pre prácu a štúdium';

  @override
  String get templateCategoryGratitude => 'Vďačné srdce';

  @override
  String get templateCategoryGrief => 'V smútku alebo strate';

  @override
  String get sectionStatusCompleted => 'Analýza dokončená';

  @override
  String get sectionStatusPartial => 'Čiastočná analýza (ďalšia sa pripravuje)';

  @override
  String get sectionStatusPending => 'Analýza prebieha';

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

  @override
  String get prayerTooShort => 'Please write a little more';

  @override
  String get switchToTextModeTitle => 'Switch to text mode?';

  @override
  String get switchToTextModeBody =>
      'Your voice recording so far will be discarded. You\'ll need to write your prayer as text instead.';

  @override
  String get switchToTextModeConfirm => 'Switch to text';

  @override
  String get switchToTextModeCancel => 'Keep recording';

  @override
  String get recordingInterruptedTitle =>
      'Your prayer recording was interrupted';

  @override
  String get recordingInterruptedBody =>
      'While you were away, the recording stopped. What would you like to do?';

  @override
  String get recordingInterruptedRestart => 'Restart recording';

  @override
  String get recordingInterruptedSwitchToText => 'Write as text instead';

  @override
  String get dashboardPartialFailedQt =>
      'Časť obsahu meditácie sa nepodarilo načítať. Začnite, prosím, novú meditáciu.';

  @override
  String get dashboardPartialFailedPrayer =>
      'Časť analýzy modlitby sa nepodarilo načítať. Začnite, prosím, novú modlitbu.';

  @override
  String get dashboardPartialFailedHint =>
      'Čo je už uložené, zostáva zachované.';
}
