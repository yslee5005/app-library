// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Když se modlíš,\nBůh odpovídá.';

  @override
  String get welcomeSubtitle =>
      'Tvůj každodenní společník pro modlitbu a tichý čas s Bohem';

  @override
  String get getStarted => 'Začít';

  @override
  String get loginTitle => 'Vítej v Abba';

  @override
  String get loginSubtitle => 'Přihlas se a začni svou cestu modlitby';

  @override
  String get signInWithApple => 'Pokračovat s Apple';

  @override
  String get signInWithGoogle => 'Pokračovat s Google';

  @override
  String get signInWithEmail => 'Pokračovat s e-mailem';

  @override
  String greetingMorning(Object name) {
    return 'Dobré ráno, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Dobré odpoledne, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Dobrý večer, $name';
  }

  @override
  String get prayButton => 'Modlit se';

  @override
  String get qtButton => 'Tichý čas';

  @override
  String streakDays(Object count) {
    return '$count dní nepřetržité modlitby';
  }

  @override
  String get dailyVerse => 'Verš dne';

  @override
  String get tabHome => 'Domů';

  @override
  String get tabCalendar => 'Kalendář';

  @override
  String get tabCommunity => 'Společenství';

  @override
  String get tabSettings => 'Nastavení';

  @override
  String get recordingTitle => 'Modlitba...';

  @override
  String get recordingPause => 'Pauza';

  @override
  String get recordingResume => 'Pokračovat';

  @override
  String get finishPrayer => 'Ukončit modlitbu';

  @override
  String get finishPrayerConfirm => 'Chceš ukončit modlitbu?';

  @override
  String get switchToText => 'Raději napsat';

  @override
  String get textInputHint => 'Napiš svou modlitbu zde...';

  @override
  String get aiLoadingText => 'Přemýšlím o tvé modlitbě...';

  @override
  String get aiLoadingVerse =>
      'Utište se a vězte, že já jsem Bůh.\n— Žalm 46:11';

  @override
  String get aiErrorNetworkTitle => 'Nestabilní spojení';

  @override
  String get aiErrorNetworkBody =>
      'Vaše modlitba je bezpečně uložena. Zkuste to prosím za chvíli znovu.';

  @override
  String get aiErrorApiTitle => 'Služba AI je nestabilní';

  @override
  String get aiErrorApiBody =>
      'Vaše modlitba je bezpečně uložena. Zkuste to prosím za chvíli znovu.';

  @override
  String get aiErrorRetry => 'Zkusit znovu';

  @override
  String get aiErrorWaitAndCheck =>
      'Analýzu zkusíme později. Vraťte se brzy — vaše modlitba bude čekat.';

  @override
  String get aiErrorHome => 'Zpět domů';

  @override
  String get dashboardTitle => 'Zahrada modlitby';

  @override
  String get shareButton => 'Sdílet';

  @override
  String get backToHome => 'Zpět na hlavní stránku';

  @override
  String get scriptureTitle => 'Dnešní Písmo';

  @override
  String get bibleStoryTitle => 'Biblický příběh';

  @override
  String get testimonyTitle => 'Svědectví · Má modlitba';

  @override
  String get testimonyHelperText =>
      'Zamyslete se nad svou modlitbou · lze sdílet s komunitou';

  @override
  String get myPrayerAudioLabel => 'Nahrávka mé modlitby';

  @override
  String get testimonyEdit => 'Upravit';

  @override
  String get guidanceTitle => 'AI průvodce';

  @override
  String get aiPrayerTitle => 'Modlitba pro tebe';

  @override
  String get originalLangTitle => 'Původní jazyk';

  @override
  String get proUnlock => 'Odemknout s Pro';

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
  String get qtPageTitle => 'Ranní zahrada';

  @override
  String get qtMeditateButton => 'Začít meditaci';

  @override
  String get qtCompleted => 'Dokončeno';

  @override
  String get communityTitle => 'Zahrada modlitby';

  @override
  String get filterAll => 'Vše';

  @override
  String get filterTestimony => 'Svědectví';

  @override
  String get filterPrayerRequest => 'Prosba o modlitbu';

  @override
  String get likeButton => 'Líbí se';

  @override
  String get commentButton => 'Komentář';

  @override
  String get saveButton => 'Uložit';

  @override
  String get replyButton => 'Odpovědět';

  @override
  String get writePostTitle => 'Sdílet';

  @override
  String get cancelButton => 'Zrušit';

  @override
  String get sharePostButton => 'Sdílet';

  @override
  String get anonymousToggle => 'Anonymně';

  @override
  String get realNameToggle => 'Pravé jméno';

  @override
  String get categoryTestimony => 'Svědectví';

  @override
  String get categoryPrayerRequest => 'Prosba o modlitbu';

  @override
  String get writePostHint => 'Podíl se o svědectví nebo prosbu o modlitbu...';

  @override
  String get importFromPrayer => 'Importovat z modlitby';

  @override
  String get calendarTitle => 'Kalendář modlitby';

  @override
  String get currentStreak => 'Aktuální série';

  @override
  String get bestStreak => 'Nejlepší série';

  @override
  String get days => 'dní';

  @override
  String calendarRecordCount(Object count) {
    return '$count záznamů';
  }

  @override
  String get todayVerse => 'Dnešní verš';

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Celkem modliteb';

  @override
  String get consecutiveDays => 'Dní v řadě';

  @override
  String get proSection => 'Členství';

  @override
  String get freePlan => 'Zdarma';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '169 Kč / měs';

  @override
  String get yearlyPrice => '1 190 Kč / rok';

  @override
  String get yearlySave => 'Ušetři 40%';

  @override
  String get launchPromo => '';

  @override
  String get startPro => 'Začít Pro';

  @override
  String get comingSoon => 'Již brzy';

  @override
  String get notificationSetting => 'Oznámení';

  @override
  String get languageSetting => 'Jazyk';

  @override
  String get darkModeSetting => 'Tmavý režim';

  @override
  String get helpCenter => 'Centrum nápovědy';

  @override
  String get termsOfService => 'Podmínky služby';

  @override
  String get privacyPolicy => 'Zásady ochrany soukromí';

  @override
  String get logout => 'Odhlásit se';

  @override
  String appVersion(Object version) {
    return 'Verze $version';
  }

  @override
  String get anonymous => 'Anonymně';

  @override
  String timeAgo(Object time) {
    return 'před $time';
  }

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Heslo';

  @override
  String get signIn => 'Přihlásit se';

  @override
  String get cancel => 'Zrušit';

  @override
  String get noPrayersRecorded => 'Žádné zaznamenané modlitby';

  @override
  String get deletePost => 'Smazat';

  @override
  String get reportPost => 'Nahlásit';

  @override
  String get reportSubmitted => 'Hlášení odesláno. Děkujeme.';

  @override
  String get reportReasonHint =>
      'Popiš důvod nahlášení. Bude zasláno e-mailem.';

  @override
  String get reportReasonPlaceholder => 'Uveď důvod nahlášení...';

  @override
  String get reportSubmitButton => 'Nahlásit';

  @override
  String get deleteConfirmTitle => 'Smazat příspěvek';

  @override
  String get deleteConfirmMessage => 'Opravdu chceš smazat tento příspěvek?';

  @override
  String get errorNetwork =>
      'Zkontroluj připojení k internetu a zkus to znovu.';

  @override
  String get errorAiFallback =>
      'AI je momentálně nedostupné. Zde je verš pro tebe.';

  @override
  String get errorSttFailed =>
      'Rozpoznávání hlasu není k dispozici. Prosím napiš.';

  @override
  String get errorPayment =>
      'Nastal problém s platbou. Zkus to znovu v Nastavení.';

  @override
  String get errorGeneric => 'Něco se pokazilo. Zkus to prosím později.';

  @override
  String get offlineNotice => 'Jsi offline. Některé funkce mohou být omezeny.';

  @override
  String get retryButton => 'Zkusit znovu';

  @override
  String get groupSection => 'Moje skupiny';

  @override
  String get createGroup => 'Vytvořit modlitební skupinu';

  @override
  String get inviteFriends => 'Pozvat přátele';

  @override
  String get groupInviteMessage =>
      'Modleme se společně! Přidej se k mé modlitební skupině v Abba.';

  @override
  String get noGroups =>
      'Přidej se nebo vytvoř skupinu pro společnou modlitbu.';

  @override
  String get promoTitle => 'Úvodní akce';

  @override
  String get promoBanner => '';

  @override
  String promoEndsOn(Object date) {
    return 'Nabídka končí $date';
  }

  @override
  String get proLimitTitle => 'Dnešní modlitba je dokončena';

  @override
  String get proLimitBody => 'Na shledanou zítra!\nModli se bez omezení s Pro';

  @override
  String get laterButton => 'Možná později';

  @override
  String get proPromptTitle => 'Pro funkce';

  @override
  String get proPromptBody =>
      'Tato funkce je dostupná s Pro.\nChceš se podívat na naše plány?';

  @override
  String get viewProducts => 'Zobrazit plány';

  @override
  String get maybeLater => 'Možná později';

  @override
  String get proHeadline => 'Blíž k Bohu každý den';

  @override
  String get proBenefit1 => 'Neomezená modlitba a tichý čas';

  @override
  String get proBenefit2 => 'Modlitba a průvodce s AI';

  @override
  String get proBenefit3 => 'Příběhy víry z historie';

  @override
  String get proBenefit5 => 'Studium Bible v původních jazycích';

  @override
  String get bestValue => 'NEJLEPŠÍ NABÍDKA';

  @override
  String get perMonth => 'měs.';

  @override
  String get cancelAnytime => 'Zrušení kdykoli';

  @override
  String get restorePurchase => 'Obnovit nákup';

  @override
  String get yearlyPriceMonthly => '99 Kč/měs';

  @override
  String get morningPrayerReminder => 'Ranní modlitba';

  @override
  String get eveningGratitudeReminder => 'Večerní vděčnost';

  @override
  String get streakReminder => 'Připomenutí série';

  @override
  String get afternoonNudgeReminder => 'Připomenutí odpolední modlitby';

  @override
  String get weeklySummaryReminder => 'Týdenní shrnutí';

  @override
  String get unlimited => 'Neomezeně';

  @override
  String get streakRecovery => 'Nevadí, můžeš začít znovu 🌱';

  @override
  String get prayerSaved => 'Modlitba úspěšně uložena';

  @override
  String get quietTimeLabel => 'Tichý čas';

  @override
  String get morningPrayerLabel => 'Ranní modlitba';

  @override
  String get gardenSeed => 'Semínko víry';

  @override
  String get gardenSprout => 'Rostoucí klíček';

  @override
  String get gardenBud => 'Poupě v květu';

  @override
  String get gardenBloom => 'Plný květ';

  @override
  String get gardenTree => 'Silný strom';

  @override
  String get gardenForest => 'Les modlitby';

  @override
  String get milestoneShare => 'Sdílet';

  @override
  String get milestoneThankGod => 'Díky Bohu!';

  @override
  String shareStreakText(Object count) {
    return '$count dní nepřetržité modlitby! Moje cesta modlitby s Abba #Abba #Modlitba';
  }

  @override
  String get shareDaysLabel => 'dní nepřetržité modlitby';

  @override
  String get shareSubtitle => 'Každodenní modlitba s Bohem';

  @override
  String get proActive => 'Členství Aktivní';

  @override
  String get planOncePerDay => '1x/den';

  @override
  String get planUnlimited => 'Neomezeně';

  @override
  String get closeRecording => 'Zavřít nahrávání';

  @override
  String get qtRevealMessage => 'Otevřme dnešní Slovo';

  @override
  String get qtSelectPrompt => 'Vyber si jedno a začni dnešní tichý čas';

  @override
  String get qtTopicLabel => 'Téma';

  @override
  String get prayerStartPrompt => 'Začni svou modlitbu';

  @override
  String get startPrayerButton => 'Začít se modlit';

  @override
  String get switchToTextMode => 'Raději napsat';

  @override
  String get switchToVoiceMode => 'Mluvit';

  @override
  String get prayerDashboardTitle => 'Zahrada modlitby';

  @override
  String get qtDashboardTitle => 'Zahrada tichého času';

  @override
  String get prayerSummaryTitle => 'Shrnutí modlitby';

  @override
  String get gratitudeLabel => 'Vděčnost';

  @override
  String get petitionLabel => 'Prosba';

  @override
  String get intercessionLabel => 'Přímluvná modlitba';

  @override
  String get historicalStoryTitle => 'Příběh z historie';

  @override
  String get todayLesson => 'Dnešní lekce';

  @override
  String get applicationTitle => 'Dnešní uplatnění';

  @override
  String get applicationWhat => 'Co';

  @override
  String get applicationWhen => 'Kdy';

  @override
  String get applicationContext => 'Kde';

  @override
  String get applicationMorningLabel => 'Ráno';

  @override
  String get applicationDayLabel => 'Den';

  @override
  String get applicationEveningLabel => 'Večer';

  @override
  String get relatedKnowledgeTitle => 'Související znalosti';

  @override
  String get originalWordLabel => 'Původní slovo';

  @override
  String get historicalContextLabel => 'Historický kontext';

  @override
  String get crossReferencesLabel => 'Křížové odkazy';

  @override
  String get growthStoryTitle => 'Příběh růstu';

  @override
  String get prayerGuideTitle => 'Jak se modlit s Abba';

  @override
  String get prayerGuide1 => 'Modli se nahlas nebo jasným hlasem';

  @override
  String get prayerGuide2 =>
      'Abba naslouchá tvým slovům a nachází Písmo, které promlouvá k tvému srdci';

  @override
  String get prayerGuide3 => 'Svou modlitbu můžeš také napsat';

  @override
  String get qtGuideTitle => 'Jak trávit tichý čas s Abba';

  @override
  String get qtGuide1 => 'Přečti si pasáž a rozjímej v tichu';

  @override
  String get qtGuide2 =>
      'Podíl se o to, co jsi objevil — řekni nebo napiš svou úvahu';

  @override
  String get qtGuide3 =>
      'Abba ti pomůže uplatnit Slovo ve tvém každodenním životě';

  @override
  String get scriptureReasonLabel => 'Proč toto Písmo';

  @override
  String get scripturePostureLabel => 'S jakým postojem to mám číst?';

  @override
  String get scriptureOriginalWordsTitle => 'Hlubší význam v původním jazyce';

  @override
  String get originalWordMeaningLabel => 'Význam';

  @override
  String get originalWordNuanceLabel => 'Nuance vs překlad';

  @override
  String originalWordsCountLabel(int count) {
    return '$count slov';
  }

  @override
  String get seeMore => 'Zobrazit více';

  @override
  String get seeLess => 'Zobrazit méně';

  @override
  String seeAllComments(Object count) {
    return 'Zobrazit všech $count komentářů';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name a dalším $count se to líbí';
  }

  @override
  String get commentsTitle => 'Komentáře';

  @override
  String get myPageTitle => 'Moje zahrada modlitby';

  @override
  String get myPrayers => 'Moje modlitby';

  @override
  String get myTestimonies => 'Moje svědectví';

  @override
  String get savedPosts => 'Uložené';

  @override
  String get totalPrayersCount => 'Modlitby';

  @override
  String get streakCount => 'Série';

  @override
  String get testimoniesCount => 'Svědectví';

  @override
  String get linkAccountTitle => 'Propojit účet';

  @override
  String get linkAccountDescription =>
      'Propoj svůj účet, abys uchoval záznamy modliteb při změně zařízení';

  @override
  String get linkWithApple => 'Propojit s Apple';

  @override
  String get linkWithGoogle => 'Propojit s Google';

  @override
  String get linkAccountSuccess => 'Účet úspěšně propojen!';

  @override
  String get anonymousUser => 'Modlitební bojovník';

  @override
  String showReplies(Object count) {
    return 'Zobrazit $count odpovědí';
  }

  @override
  String get hideReplies => 'Skrýt odpovědi';

  @override
  String replyingTo(Object name) {
    return 'Odpověď pro $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Zobrazit všech $count komentářů';
  }

  @override
  String get membershipTitle => 'Členství';

  @override
  String get membershipSubtitle => 'Prohloubte svůj modlitební život';

  @override
  String get monthlyPlan => 'Měsíčně';

  @override
  String get yearlyPlan => 'Ročně';

  @override
  String get yearlySavings => '70 Kč/měs (sleva 40%)';

  @override
  String get startMembership => 'Začít';

  @override
  String get membershipActive => 'Členství Aktivní';

  @override
  String get leaveRecordingTitle => 'Opustit nahrávání?';

  @override
  String get leaveRecordingMessage =>
      'Vaše nahrávka bude ztracena. Jste si jisti?';

  @override
  String get leaveButton => 'Opustit';

  @override
  String get stayButton => 'Zůstat';

  @override
  String likedByCount(Object count) {
    return '$count lidí projevilo soucit';
  }

  @override
  String get actionLike => 'To se mi líbí';

  @override
  String get actionComment => 'Komentář';

  @override
  String get actionSave => 'Uložit';

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
  String get billingIssueTitle => 'Zjištěn problém s platbou';

  @override
  String billingIssueBody(int days) {
    return 'Výhody Pro skončí za $days dní, pokud platba nebude aktualizována.';
  }

  @override
  String get billingIssueAction => 'Aktualizovat platbu';

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
      '💛 Láska — Myslete 10 sekund na někoho, koho milujete';

  @override
  String get qtLoadingHint2 =>
      '🌿 Milost — Vzpomeňte si na jednu malou milost z dneška';

  @override
  String get qtLoadingHint3 =>
      '🌅 Naděje — Představte si malou naději pro zítřek';

  @override
  String get qtLoadingHint4 =>
      '🕊️ Pokoj — Třikrát pomalu a zhluboka se nadechněte';

  @override
  String get qtLoadingHint5 =>
      '🌳 Víra — Vzpomeňte si na jednu neměnnou pravdu';

  @override
  String get qtLoadingHint6 =>
      '🌸 Vděčnost — Pojmenujte jednu věc, za kterou jste teď vděční';

  @override
  String get qtLoadingHint7 =>
      '🌊 Odpuštění — Vzpomeňte si na někoho, komu chcete odpustit';

  @override
  String get qtLoadingHint8 =>
      '📖 Moudrost — Uchovejte si jedno ponaučení z dneška';

  @override
  String get qtLoadingHint9 =>
      '⏳ Trpělivost — Myslete na to, na co tiše čekáte';

  @override
  String get qtLoadingHint10 => '✨ Radost — Vzpomeňte si na úsměv z dneška';

  @override
  String get qtLoadingTitle => 'Připravuji dnešní Slovo...';

  @override
  String get coachingTitle => 'Koučink modlitby';

  @override
  String get coachingLoadingText => 'Přemýšlíme o vaší modlitbě...';

  @override
  String get coachingErrorText => 'Dočasná chyba — zkuste to znovu';

  @override
  String get coachingRetryButton => 'Zkusit znovu';

  @override
  String get coachingScoreSpecificity => 'Konkrétnost';

  @override
  String get coachingScoreGodCentered => 'Bohocentričnost';

  @override
  String get coachingScoreActs => 'Rovnováha ACTS';

  @override
  String get coachingScoreAuthenticity => 'Autentičnost';

  @override
  String get coachingStrengthsTitle => 'Co jste udělali dobře ✨';

  @override
  String get coachingImprovementsTitle => 'Jak jít hlouběji 💡';

  @override
  String get coachingProCta => 'Odemkněte Koučink modlitby s Pro';

  @override
  String get coachingLevelBeginner => '🌱 Začátečník';

  @override
  String get coachingLevelGrowing => '🌿 Rostoucí';

  @override
  String get coachingLevelExpert => '🌳 Odborník';

  @override
  String get aiPrayerCitationsTitle => 'Odkazy · Citace';

  @override
  String get citationTypeQuote => 'Citát';

  @override
  String get citationTypeScience => 'Výzkum';

  @override
  String get citationTypeExample => 'Příklad';

  @override
  String get citationTypeHistory => 'Historie';

  @override
  String get aiPrayerReadingTime => 'Čtení 2 minuty';

  @override
  String get scriptureKeyWordHintTitle => 'Dnešní klíčové slovo';

  @override
  String get bibleLookupReferenceHint =>
      'Najděte tuto pasáž ve své Bibli a rozjímejte nad ní.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Překlady Bible';

  @override
  String get settingsBibleTranslationsIntro =>
      'Biblické verše v této aplikaci pocházejí z překladů ve veřejné doméně. Komentáře, modlitby a příběhy generované AI jsou tvůrčí prací Abba.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'QT koučink';

  @override
  String get qtCoachingLoadingText => 'Přemýšlíme o vašem rozjímání...';

  @override
  String get qtCoachingErrorText => 'Dočasná chyba — zkuste to znovu';

  @override
  String get qtCoachingRetryButton => 'Zkusit znovu';

  @override
  String get qtCoachingScoreComprehension => 'Porozumění textu';

  @override
  String get qtCoachingScoreApplication => 'Osobní aplikace';

  @override
  String get qtCoachingScoreDepth => 'Duchovní hloubka';

  @override
  String get qtCoachingScoreAuthenticity => 'Autentičnost';

  @override
  String get qtCoachingStrengthsTitle => 'Co jste udělali dobře ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Jak jít hlouběji 💡';

  @override
  String get qtCoachingProCta => 'Odemkněte QT koučink s Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Začátečník';

  @override
  String get qtCoachingLevelGrowing => '🌿 Rostoucí';

  @override
  String get qtCoachingLevelExpert => '🌳 Odborník';

  @override
  String get notifyMorning1Title => '🙏 Čas modlit se';

  @override
  String notifyMorning1Body(String name) {
    return '$name, promluv si s Bohem i dnes';
  }

  @override
  String get notifyMorning2Title => '🌅 Přišlo nové ráno';

  @override
  String notifyMorning2Body(String name) {
    return '$name, začni den s vděčností';
  }

  @override
  String get notifyMorning3Title => '✨ Dnešní milost';

  @override
  String notifyMorning3Body(String name) {
    return '$name, setkej se s milostí, kterou Bůh připravil';
  }

  @override
  String get notifyMorning4Title => '🕊️ Pokojné ráno';

  @override
  String notifyMorning4Body(String name) {
    return '$name, naplň srdce pokojem skrze modlitbu';
  }

  @override
  String get notifyMorning5Title => '📖 Se Slovem';

  @override
  String notifyMorning5Body(String name) {
    return '$name, naslouchej dnes Božímu hlasu';
  }

  @override
  String get notifyMorning6Title => '🌿 Čas na odpočinek';

  @override
  String notifyMorning6Body(String name) {
    return '$name, zastav se na chvíli a modli se';
  }

  @override
  String get notifyMorning7Title => '💫 I dnes';

  @override
  String notifyMorning7Body(String name) {
    return '$name, den začínající modlitbou je jiný';
  }

  @override
  String get notifyEvening1Title => '✨ Vděčnost za dnešek';

  @override
  String get notifyEvening1Body => 'Ohlédni se za dnem a vznes modlitbu díků';

  @override
  String get notifyEvening2Title => '🌙 Završování dne';

  @override
  String get notifyEvening2Body => 'Vyjádři dnešní vděčnost v modlitbě';

  @override
  String get notifyEvening3Title => '🙏 Večerní modlitba';

  @override
  String get notifyEvening3Body => 'Na konci dne poděkuj Bohu';

  @override
  String get notifyEvening4Title => '🌟 Počítáme dnešní požehnání';

  @override
  String get notifyEvening4Body => 'Máš-li za co děkovat, sdílej to v modlitbě';

  @override
  String get notifyStreak3Title => '🌱 3 dny v řadě!';

  @override
  String get notifyStreak3Body => 'Tvůj zvyk modlit se začal';

  @override
  String get notifyStreak7Title => '🌿 Celý týden!';

  @override
  String get notifyStreak7Body => 'Modlitba se stává zvykem';

  @override
  String get notifyStreak14Title => '🌳 2 týdny v řadě!';

  @override
  String get notifyStreak14Body => 'Úžasný růst!';

  @override
  String get notifyStreak21Title => '🌻 3 týdny v řadě!';

  @override
  String get notifyStreak21Body => 'Květ modlitby rozkvétá';

  @override
  String get notifyStreak30Title => '🏆 Celý měsíc!';

  @override
  String get notifyStreak30Body => 'Tvá modlitba září';

  @override
  String get notifyStreak50Title => '👑 50 dní v řadě!';

  @override
  String get notifyStreak50Body => 'Tvá chůze s Bohem se prohlubuje';

  @override
  String get notifyStreak100Title => '🎉 100 dní v řadě!';

  @override
  String get notifyStreak100Body => 'Stal ses modlitebním bojovníkem!';

  @override
  String get notifyStreak365Title => '✝️ Celý rok!';

  @override
  String get notifyStreak365Body => 'Úžasná cesta víry!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ Modlil ses dnes?';

  @override
  String get notifyAfternoonNudgeBody => 'Krátká modlitba může změnit den';

  @override
  String get notifyChannelName => 'Připomínky modlitby';

  @override
  String get notifyChannelDescription =>
      'Ranní modlitba, večerní vděčnost a další připomínky modlitby';

  @override
  String get milestoneFirstPrayerTitle => 'První modlitba!';

  @override
  String get milestoneFirstPrayerDesc =>
      'Vaše modlitební cesta začala. Bůh naslouchá.';

  @override
  String get milestoneSevenDayStreakTitle => '7 dní modlitby!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'Týden věrné modlitby. Vaše zahrada roste!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 dní!';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'Vaše zahrada rozkvetla v pole květin!';

  @override
  String get milestoneHundredPrayersTitle => '100. modlitba!';

  @override
  String get milestoneHundredPrayersDesc =>
      'Sto rozhovorů s Bohem. Máte hluboké kořeny.';

  @override
  String get homeFirstPrayerPrompt => 'Začněte svou první modlitbu';

  @override
  String get homeFirstQtPrompt => 'Začněte svůj první QT';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Dnes také $activityName';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'Den $count nepřetržitě $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'Od posledního $activityName uplynulo $days dní';
  }

  @override
  String get homeActivityPrayer => 'modlitba';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Načítání...';

  @override
  String get heatmapNoPrayer => 'Žádná modlitba';

  @override
  String get heatmapLegendLess => 'Méně';

  @override
  String get heatmapLegendMore => 'Více';

  @override
  String get qtPassagesLoadError =>
      'Dnešní verše se nepodařilo načíst. Zkontrolujte připojení.';

  @override
  String get qtPassagesRetryButton => 'Zkusit znovu';

  @override
  String get aiStreamingInitial => 'Meditujeme nad vaší modlitbou...';

  @override
  String get aiTierProcessing => 'Další úvahy přicházejí...';

  @override
  String get aiScriptureValidating => 'Hledáme správný verš...';

  @override
  String get aiScriptureValidatingFailed =>
      'Připravujeme pro vás tento verš...';

  @override
  String get aiTemplateFallback => 'Zatímco připravujeme úplnou analýzu...';

  @override
  String get aiPendingMore => 'Připravujeme další...';

  @override
  String get aiTierIncomplete => 'Již brzy, zkontrolujte to později';

  @override
  String get tierCompleted => 'Přidána nová úvaha';

  @override
  String get tierProcessingNotice => 'Vytváříme další úvahy...';

  @override
  String get proSectionLoading => 'Připravujeme váš prémiový obsah...';

  @override
  String get proSectionWillArrive => 'Vaše hluboká úvaha se zobrazí zde';

  @override
  String get templateCategoryHealth => 'Pro zdravotní starosti';

  @override
  String get templateCategoryFamily => 'Pro rodinu';

  @override
  String get templateCategoryWork => 'Pro práci a studium';

  @override
  String get templateCategoryGratitude => 'Vděčné srdce';

  @override
  String get templateCategoryGrief => 'Ve smutku nebo ztrátě';

  @override
  String get sectionStatusCompleted => 'Analýza dokončena';

  @override
  String get sectionStatusPartial => 'Částečná analýza (další přichází)';

  @override
  String get sectionStatusPending => 'Analýza probíhá';

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
      'Část obsahu meditace se nepodařilo načíst. Začněte prosím novou meditaci.';

  @override
  String get dashboardPartialFailedPrayer =>
      'Část analýzy modlitby se nepodařilo načíst. Začněte prosím novou modlitbu.';

  @override
  String get dashboardPartialFailedHint =>
      'Co je již uloženo, zůstává zachováno.';

  @override
  String get deleteAccount => 'Smazat účet';

  @override
  String get deleteAccountTitle => 'Smazat svůj účet?';

  @override
  String get deleteAccountBody =>
      'Všechna vaše data v Abba (modlitby, ztišení, hlasové nahrávky) budou trvale smazána. Pokud nepoužíváte jiné aplikace ystech, bude smazán i váš přihlašovací účet.';

  @override
  String get deleteAccountConfirmHint => 'Pro potvrzení napište \'DELETE\'.';

  @override
  String get deleteAccountFailed =>
      'Účet se nepodařilo smazat. Zkuste to prosím později.';
}
