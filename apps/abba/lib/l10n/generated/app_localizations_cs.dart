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
  String get testimonyTitle => 'Mé svědectví';

  @override
  String get testimonyEdit => 'Upravit';

  @override
  String get guidanceTitle => 'AI průvodce';

  @override
  String get aiPrayerTitle => 'Modlitba pro tebe';

  @override
  String get originalLangTitle => 'Původní jazyk';

  @override
  String get premiumUnlock => 'Odemknout s Premium';

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
  String get premiumSection => 'Premium';

  @override
  String get freePlan => 'Zdarma';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get monthlyPrice => '89Kč/měs.';

  @override
  String get yearlyPrice => '599Kč/rok';

  @override
  String get yearlySave => 'Ušetři 40%';

  @override
  String get launchPromo => '3 měsíce za 99Kč/měs.!';

  @override
  String get startPremium => 'Začít Premium';

  @override
  String get comingSoon => 'Již brzy';

  @override
  String get notificationSetting => 'Oznámení';

  @override
  String get aiVoiceSetting => 'AI hlas';

  @override
  String get voiceWarm => 'Teplý';

  @override
  String get voiceCalm => 'Klidný';

  @override
  String get voiceStrong => 'Silný';

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
  String get promoBanner => 'První 3 měsíce za 99Kč/měs.!';

  @override
  String promoEndsOn(Object date) {
    return 'Nabídka končí $date';
  }

  @override
  String get premiumLimitTitle => 'Dnešní modlitba je dokončena';

  @override
  String get premiumLimitBody =>
      'Na shledanou zítra!\nModli se bez omezení s Premium';

  @override
  String get laterButton => 'Možná později';

  @override
  String get premiumPromptTitle => 'Pro funkce';

  @override
  String get premiumPromptBody =>
      'Tato funkce je dostupná s Pro.\nChceš se podívat na naše plány?';

  @override
  String get viewProducts => 'Zobrazit plány';

  @override
  String get maybeLater => 'Možná později';

  @override
  String get premiumHeadline => 'Blíž k Bohu každý den';

  @override
  String get premiumBenefit1 => 'Neomezená modlitba a tichý čas';

  @override
  String get premiumBenefit2 => 'Modlitba a průvodce s AI';

  @override
  String get premiumBenefit3 => 'Příběhy víry z historie';

  @override
  String get premiumBenefit4 => 'Předčítání modlitby (TTS)';

  @override
  String get premiumBenefit5 => 'Studium Bible v původních jazycích';

  @override
  String get bestValue => 'NEJLEPŠÍ NABÍDKA';

  @override
  String get perMonth => 'měs.';

  @override
  String get cancelAnytime => 'Zrušení kdykoli';

  @override
  String get restorePurchase => 'Obnovit nákup';

  @override
  String get yearlyPriceMonthly => '50Kč/měs.';

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
  String get premiumActive => 'Premium aktivní';

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
  String get meditationAnalysisTitle => 'Analýza meditace';

  @override
  String get keyThemeLabel => 'Klíčové téma';

  @override
  String get applicationTitle => 'Dnešní uplatnění';

  @override
  String get applicationWhat => 'Co';

  @override
  String get applicationWhen => 'Kdy';

  @override
  String get applicationContext => 'Kde';

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
  String get seeMore => 'Zobrazit více';

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
}
