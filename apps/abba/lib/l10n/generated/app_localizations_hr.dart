// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Kada se moliš,\nBog odgovara.';

  @override
  String get welcomeSubtitle =>
      'Tvoj svakodnevni pratilac za molitvu i tihi sat';

  @override
  String get getStarted => 'Započni';

  @override
  String get loginTitle => 'Dobrodošli u Abba';

  @override
  String get loginSubtitle => 'Prijavite se da započnete svoj molitveni put';

  @override
  String get signInWithApple => 'Nastavi s Apple';

  @override
  String get signInWithGoogle => 'Nastavi s Google';

  @override
  String get signInWithEmail => 'Nastavi s e-poštom';

  @override
  String greetingMorning(Object name) {
    return 'Dobro jutro, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Dobar dan, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Dobra večer, $name';
  }

  @override
  String get prayButton => 'Moli se';

  @override
  String get qtButton => 'Tihi sat';

  @override
  String streakDays(Object count) {
    return '$count dana neprekidne molitve';
  }

  @override
  String get dailyVerse => 'Stih dana';

  @override
  String get tabHome => 'Početna';

  @override
  String get tabCalendar => 'Kalendar';

  @override
  String get tabCommunity => 'Zajednica';

  @override
  String get tabSettings => 'Postavke';

  @override
  String get recordingTitle => 'Molim se...';

  @override
  String get recordingPause => 'Pauza';

  @override
  String get recordingResume => 'Nastavi';

  @override
  String get finishPrayer => 'Završi molitvu';

  @override
  String get finishPrayerConfirm => 'Želite li završiti molitvu?';

  @override
  String get switchToText => 'Upiši umjesto toga';

  @override
  String get textInputHint => 'Upiši svoju molitvu ovdje...';

  @override
  String get aiLoadingText => 'Razmišljam o tvojoj molitvi...';

  @override
  String get aiLoadingVerse =>
      'Utišajte se i spoznajte da sam ja Bog.\n— Psalam 46:10';

  @override
  String get dashboardTitle => 'Molitveni Vrt';

  @override
  String get shareButton => 'Podijeli';

  @override
  String get backToHome => 'Natrag na početnu';

  @override
  String get scriptureTitle => 'Svetopisamski odlomak dana';

  @override
  String get bibleStoryTitle => 'Biblijska priča';

  @override
  String get testimonyTitle => 'Svjedočanstvo · Moja molitva';

  @override
  String get testimonyHelperText =>
      'Razmisli o svojoj molitvi · može se dijeliti sa zajednicom';

  @override
  String get myPrayerAudioLabel => 'Snimka moje molitve';

  @override
  String get testimonyEdit => 'Uredi';

  @override
  String get guidanceTitle => 'AI vodstvo';

  @override
  String get aiPrayerTitle => 'Molitva za tebe';

  @override
  String get originalLangTitle => 'Izvorni jezik';

  @override
  String get proUnlock => 'Otključaj s Pro';

  @override
  String get qtPageTitle => 'Jutarnji Vrt';

  @override
  String get qtMeditateButton => 'Započni meditaciju';

  @override
  String get qtCompleted => 'Završeno';

  @override
  String get communityTitle => 'Molitveni Vrt';

  @override
  String get filterAll => 'Sve';

  @override
  String get filterTestimony => 'Svjedočanstvo';

  @override
  String get filterPrayerRequest => 'Molitvena namjera';

  @override
  String get likeButton => 'Sviđa mi se';

  @override
  String get commentButton => 'Komentar';

  @override
  String get saveButton => 'Spremi';

  @override
  String get replyButton => 'Odgovori';

  @override
  String get writePostTitle => 'Podijeli';

  @override
  String get cancelButton => 'Odustani';

  @override
  String get sharePostButton => 'Objavi';

  @override
  String get anonymousToggle => 'Anonimno';

  @override
  String get realNameToggle => 'Pravo ime';

  @override
  String get categoryTestimony => 'Svjedočanstvo';

  @override
  String get categoryPrayerRequest => 'Molitvena namjera';

  @override
  String get writePostHint =>
      'Podijeli svoje svjedočanstvo ili molitvenu namjeru...';

  @override
  String get importFromPrayer => 'Uvezi iz molitve';

  @override
  String get calendarTitle => 'Molitveni kalendar';

  @override
  String get currentStreak => 'Trenutni niz';

  @override
  String get bestStreak => 'Najbolji niz';

  @override
  String get days => 'dana';

  @override
  String calendarRecordCount(Object count) {
    return '$count zapisa';
  }

  @override
  String get todayVerse => 'Stih dana';

  @override
  String get settingsTitle => 'Postavke';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Ukupno molitava';

  @override
  String get consecutiveDays => 'Uzastopnih dana';

  @override
  String get proSection => 'Članstvo';

  @override
  String get freePlan => 'Besplatno';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '6,99€ / mjes';

  @override
  String get yearlyPrice => '49,99€ / god';

  @override
  String get yearlySave => 'Uštedi 40%';

  @override
  String get launchPromo => '3 mjeseca po 3,99€/mj!';

  @override
  String get startPro => 'Započni Pro';

  @override
  String get comingSoon => 'Uskoro';

  @override
  String get notificationSetting => 'Obavijesti';

  @override
  String get languageSetting => 'Jezik';

  @override
  String get darkModeSetting => 'Tamni način';

  @override
  String get helpCenter => 'Centar za pomoć';

  @override
  String get termsOfService => 'Uvjeti korištenja';

  @override
  String get privacyPolicy => 'Pravila privatnosti';

  @override
  String get logout => 'Odjava';

  @override
  String appVersion(Object version) {
    return 'Verzija $version';
  }

  @override
  String get anonymous => 'Anonimno';

  @override
  String timeAgo(Object time) {
    return 'prije $time';
  }

  @override
  String get emailLabel => 'E-pošta';

  @override
  String get passwordLabel => 'Lozinka';

  @override
  String get signIn => 'Prijava';

  @override
  String get cancel => 'Odustani';

  @override
  String get noPrayersRecorded => 'Nema zabilježenih molitava';

  @override
  String get deletePost => 'Obriši';

  @override
  String get reportPost => 'Prijavi';

  @override
  String get reportSubmitted => 'Prijava je poslana. Hvala.';

  @override
  String get reportReasonHint =>
      'Opišite razlog prijave. Bit će poslana putem e-pošte.';

  @override
  String get reportReasonPlaceholder => 'Unesite razlog prijave...';

  @override
  String get reportSubmitButton => 'Prijavi';

  @override
  String get deleteConfirmTitle => 'Obriši objavu';

  @override
  String get deleteConfirmMessage =>
      'Jeste li sigurni da želite obrisati ovu objavu?';

  @override
  String get errorNetwork => 'Provjerite internetsku vezu i pokušajte ponovo.';

  @override
  String get errorAiFallback =>
      'Nismo uspjeli povezati se s AI-jem. Evo stiha za vas.';

  @override
  String get errorSttFailed =>
      'Prepoznavanje govora nije dostupno. Molimo unesite tekst.';

  @override
  String get errorPayment =>
      'Došlo je do problema s plaćanjem. Pokušajte ponovo u Postavkama.';

  @override
  String get errorGeneric =>
      'Nešto je pošlo po krivu. Pokušajte ponovo kasnije.';

  @override
  String get offlineNotice =>
      'Izvan mreže ste. Neke značajke mogu biti ograničene.';

  @override
  String get retryButton => 'Pokušaj ponovo';

  @override
  String get groupSection => 'Moje grupe';

  @override
  String get createGroup => 'Stvori molitvenu grupu';

  @override
  String get inviteFriends => 'Pozovi prijatelje';

  @override
  String get groupInviteMessage =>
      'Molimo se zajedno! Pridruži se mojoj molitvenoj grupi na Abba.';

  @override
  String get noGroups => 'Pridruži se ili stvori grupu za zajedničku molitvu.';

  @override
  String get promoTitle => 'Posebna ponuda';

  @override
  String get promoBanner => 'Prva 3 mjeseca po 3,99€/mj!';

  @override
  String promoEndsOn(Object date) {
    return 'Ponuda istječe $date';
  }

  @override
  String get proLimitTitle => 'Današnja molitva je završena';

  @override
  String get proLimitBody => 'Vidimo se sutra!\nMoli se neograničeno s Pro';

  @override
  String get laterButton => 'Možda kasnije';

  @override
  String get proPromptTitle => 'Pro značajka';

  @override
  String get proPromptBody =>
      'Ova značajka je dostupna s Pro.\nŽelite li vidjeti planove?';

  @override
  String get viewProducts => 'Pogledaj planove';

  @override
  String get maybeLater => 'Možda kasnije';

  @override
  String get proHeadline => 'Bliže Bogu, svaki dan';

  @override
  String get proBenefit1 => 'Neograničena molitva & tihi sat';

  @override
  String get proBenefit2 => 'AI molitva & vodstvo';

  @override
  String get proBenefit3 => 'Priče vjere iz povijesti';

  @override
  String get proBenefit5 => 'Proučavanje Biblije na izvornom jeziku';

  @override
  String get bestValue => 'NAJBOLJA VRIJEDNOST';

  @override
  String get perMonth => 'mj';

  @override
  String get cancelAnytime => 'Otkaži bilo kada';

  @override
  String get restorePurchase => 'Vrati kupnju';

  @override
  String get yearlyPriceMonthly => '4,17€/mjes';

  @override
  String get morningPrayerReminder => 'Jutarnja molitva';

  @override
  String get eveningGratitudeReminder => 'Večernja zahvalnost';

  @override
  String get streakReminder => 'Podsjetnik za niz';

  @override
  String get afternoonNudgeReminder => 'Podsjetnik za popodnevnu molitvu';

  @override
  String get weeklySummaryReminder => 'Tjedni sažetak';

  @override
  String get unlimited => 'Neograničeno';

  @override
  String get streakRecovery => 'U redu je, možeš početi ispočetka 🌱';

  @override
  String get prayerSaved => 'Molitva je spremljena';

  @override
  String get quietTimeLabel => 'Tihi sat';

  @override
  String get morningPrayerLabel => 'Jutarnja molitva';

  @override
  String get gardenSeed => 'Sjeme vjere';

  @override
  String get gardenSprout => 'Klica koja raste';

  @override
  String get gardenBud => 'Pupoljak';

  @override
  String get gardenBloom => 'Puni cvat';

  @override
  String get gardenTree => 'Snažno stablo';

  @override
  String get gardenForest => 'Šuma molitve';

  @override
  String get milestoneShare => 'Podijeli';

  @override
  String get milestoneThankGod => 'Hvala Bogu!';

  @override
  String shareStreakText(Object count) {
    return '$count dana neprekidne molitve! Moj molitveni put s Abba #Abba #Molitva';
  }

  @override
  String get shareDaysLabel => 'dana neprekidne molitve';

  @override
  String get shareSubtitle => 'Svakodnevna molitva s Bogom';

  @override
  String get proActive => 'Članstvo Aktivno';

  @override
  String get planOncePerDay => '1x/dan';

  @override
  String get planUnlimited => 'Neograničeno';

  @override
  String get closeRecording => 'Zatvori snimanje';

  @override
  String get qtRevealMessage => 'Otvorimo današnju Riječ';

  @override
  String get qtSelectPrompt => 'Odaberi temu i započni današnji tihi sat';

  @override
  String get qtTopicLabel => 'Tema';

  @override
  String get prayerStartPrompt => 'Započni svoju molitvu';

  @override
  String get startPrayerButton => 'Započni molitvu';

  @override
  String get switchToTextMode => 'Upiši umjesto toga';

  @override
  String get switchToVoiceMode => 'Govorite';

  @override
  String get prayerDashboardTitle => 'Molitveni Vrt';

  @override
  String get qtDashboardTitle => 'Vrt tihog sata';

  @override
  String get prayerSummaryTitle => 'Sažetak molitve';

  @override
  String get gratitudeLabel => 'Zahvalnost';

  @override
  String get petitionLabel => 'Prošnja';

  @override
  String get intercessionLabel => 'Zagovor';

  @override
  String get historicalStoryTitle => 'Priča iz povijesti';

  @override
  String get todayLesson => 'Današnja pouka';

  @override
  String get applicationTitle => 'Današnja primjena';

  @override
  String get applicationWhat => 'Što';

  @override
  String get applicationWhen => 'Kada';

  @override
  String get applicationContext => 'Gdje';

  @override
  String get applicationMorningLabel => 'Jutro';

  @override
  String get applicationDayLabel => 'Dan';

  @override
  String get applicationEveningLabel => 'Večer';

  @override
  String get relatedKnowledgeTitle => 'Povezano znanje';

  @override
  String get originalWordLabel => 'Izvorna riječ';

  @override
  String get historicalContextLabel => 'Povijesni kontekst';

  @override
  String get crossReferencesLabel => 'Unakrsne reference';

  @override
  String get growthStoryTitle => 'Priča o rastu';

  @override
  String get prayerGuideTitle => 'Kako se moliti s Abba';

  @override
  String get prayerGuide1 => 'Moli se glasno ili jasnim glasom';

  @override
  String get prayerGuide2 =>
      'Abba sluša tvoju molitvu i pronalazi stihove koji govore tvom srcu';

  @override
  String get prayerGuide3 => 'Svoju molitvu možeš i napisati';

  @override
  String get qtGuideTitle => 'Kako provesti tihi sat s Abba';

  @override
  String get qtGuide1 => 'Pročitaj odlomak i tiho meditiraj';

  @override
  String get qtGuide2 =>
      'Podijeli što si otkrio/la — izgovori ili napiši svoja razmišljanja';

  @override
  String get qtGuide3 =>
      'Abba će ti pomoći primijeniti Riječ u svakodnevnom životu';

  @override
  String get scriptureReasonLabel => 'Zašto ovaj stih';

  @override
  String get scripturePostureLabel => 'S kojim stavom to čitati?';

  @override
  String get scriptureOriginalWordsTitle =>
      'Dublje značenje na izvornom jeziku';

  @override
  String get originalWordMeaningLabel => 'Značenje';

  @override
  String get originalWordNuanceLabel => 'Nijansa vs prijevod';

  @override
  String originalWordsCountLabel(int count) {
    return '$count riječi';
  }

  @override
  String get seeMore => 'Vidi više';

  @override
  String seeAllComments(Object count) {
    return 'Pogledaj svih $count komentara';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name i još $count osoba lajkali su ovo';
  }

  @override
  String get commentsTitle => 'Komentari';

  @override
  String get myPageTitle => 'Moj Molitveni Vrt';

  @override
  String get myPrayers => 'Moje molitve';

  @override
  String get myTestimonies => 'Moja svjedočanstva';

  @override
  String get savedPosts => 'Spremljeno';

  @override
  String get totalPrayersCount => 'Molitve';

  @override
  String get streakCount => 'Niz';

  @override
  String get testimoniesCount => 'Svjedočanstva';

  @override
  String get linkAccountTitle => 'Poveži račun';

  @override
  String get linkAccountDescription =>
      'Poveži svoj račun kako bi sačuvao/la molitvene zapise pri promjeni uređaja';

  @override
  String get linkWithApple => 'Poveži s Apple';

  @override
  String get linkWithGoogle => 'Poveži s Google';

  @override
  String get linkAccountSuccess => 'Račun je uspješno povezan!';

  @override
  String get anonymousUser => 'Molitveni ratnik';

  @override
  String showReplies(Object count) {
    return 'Prikaži $count odgovora';
  }

  @override
  String get hideReplies => 'Sakrij odgovore';

  @override
  String replyingTo(Object name) {
    return 'Odgovaraš na $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Pogledaj svih $count komentara';
  }

  @override
  String get membershipTitle => 'Članstvo';

  @override
  String get membershipSubtitle => 'Produbite svoj molitveni život';

  @override
  String get monthlyPlan => 'Mjesečno';

  @override
  String get yearlyPlan => 'Godišnje';

  @override
  String get yearlySavings => '4,17€/mjes (40% popust)';

  @override
  String get startMembership => 'Započni';

  @override
  String get membershipActive => 'Članstvo Aktivno';

  @override
  String get leaveRecordingTitle => 'Napustiti snimanje?';

  @override
  String get leaveRecordingMessage =>
      'Vaša snimka će biti izgubljena. Jeste li sigurni?';

  @override
  String get leaveButton => 'Napusti';

  @override
  String get stayButton => 'Ostani';

  @override
  String likedByCount(Object count) {
    return '$count osoba je suosjećalo';
  }

  @override
  String get actionLike => 'Sviđa mi se';

  @override
  String get actionComment => 'Komentar';

  @override
  String get actionSave => 'Spremi';

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
  String get billingIssueTitle => 'Otkriven problem s plaćanjem';

  @override
  String billingIssueBody(int days) {
    return 'Vaše Pro pogodnosti završit će za $days dana ako se plaćanje ne ažurira.';
  }

  @override
  String get billingIssueAction => 'Ažuriraj plaćanje';

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
      '💛 Ljubav — Misli 10 sekundi na nekoga koga voliš';

  @override
  String get qtLoadingHint2 =>
      '🌿 Milost — Sjeti se jedne male milosti primljene danas';

  @override
  String get qtLoadingHint3 => '🌅 Nada — Zamisli malu nadu za sutra';

  @override
  String get qtLoadingHint4 => '🕊️ Mir — Tri puta polako duboko udahni';

  @override
  String get qtLoadingHint5 => '🌳 Vjera — Sjeti se jedne nepromjenjive istine';

  @override
  String get qtLoadingHint6 =>
      '🌸 Zahvalnost — Imenuj jednu stvar za koju si sada zahvalan';

  @override
  String get qtLoadingHint7 =>
      '🌊 Oprost — Dovede u misli nekoga komu želiš oprostiti';

  @override
  String get qtLoadingHint8 =>
      '📖 Mudrost — Sačuvaj jednu lekciju današnjeg dana';

  @override
  String get qtLoadingHint9 => '⏳ Strpljenje — Misli na ono što tiho čekaš';

  @override
  String get qtLoadingHint10 => '✨ Radost — Sjeti se osmijeha današnjeg dana';

  @override
  String get qtLoadingTitle => 'Priprema se današnja Riječ...';

  @override
  String get coachingTitle => 'Coaching molitve';

  @override
  String get coachingLoadingText => 'Razmišljamo o vašoj molitvi...';

  @override
  String get coachingErrorText => 'Privremena pogreška — pokušajte ponovno';

  @override
  String get coachingRetryButton => 'Pokušaj ponovno';

  @override
  String get coachingScoreSpecificity => 'Konkretnost';

  @override
  String get coachingScoreGodCentered => 'Usredotočenost na Boga';

  @override
  String get coachingScoreActs => 'ACTS ravnoteža';

  @override
  String get coachingScoreAuthenticity => 'Autentičnost';

  @override
  String get coachingStrengthsTitle => 'Što ste dobro napravili ✨';

  @override
  String get coachingImprovementsTitle => 'Da idete dublje 💡';

  @override
  String get coachingProCta => 'Otključaj Coaching molitve s Pro';

  @override
  String get coachingLevelBeginner => '🌱 Početnik';

  @override
  String get coachingLevelGrowing => '🌿 U rastu';

  @override
  String get coachingLevelExpert => '🌳 Stručnjak';

  @override
  String get aiPrayerCitationsTitle => 'Reference · Citati';

  @override
  String get citationTypeQuote => 'Citat';

  @override
  String get citationTypeScience => 'Istraživanje';

  @override
  String get citationTypeExample => 'Primjer';

  @override
  String get citationTypeHistory => 'Povijest';

  @override
  String get aiPrayerReadingTime => 'Čitanje 2 minute';

  @override
  String get scriptureKeyWordHintTitle => 'Današnja ključna riječ';

  @override
  String get bibleLookupReferenceHint =>
      'Pronađite ovaj odlomak u svojoj Bibliji i razmišljajte o njemu.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Prijevodi Biblije';

  @override
  String get settingsBibleTranslationsIntro =>
      'Biblijski stihovi u ovoj aplikaciji dolaze iz prijevoda u javnom vlasništvu. AI-generirani komentari, molitve i priče su Abbino kreativno djelo.';

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
  String get qtCoachingLoadingText => 'Razmišljamo o vašem razmatranju...';

  @override
  String get qtCoachingErrorText => 'Privremena pogreška — pokušajte ponovno';

  @override
  String get qtCoachingRetryButton => 'Pokušaj ponovno';

  @override
  String get qtCoachingScoreComprehension => 'Razumijevanje teksta';

  @override
  String get qtCoachingScoreApplication => 'Osobna primjena';

  @override
  String get qtCoachingScoreDepth => 'Duhovna dubina';

  @override
  String get qtCoachingScoreAuthenticity => 'Autentičnost';

  @override
  String get qtCoachingStrengthsTitle => 'Što ste dobro napravili ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Da idete dublje 💡';

  @override
  String get qtCoachingProCta => 'Otključaj QT coaching s Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Početnik';

  @override
  String get qtCoachingLevelGrowing => '🌿 U rastu';

  @override
  String get qtCoachingLevelExpert => '🌳 Stručnjak';
}
