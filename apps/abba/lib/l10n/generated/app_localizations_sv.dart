// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'När du ber,\nsvarar Gud.';

  @override
  String get welcomeSubtitle => 'Din dagliga bön- och stilla stund-kompanjon';

  @override
  String get getStarted => 'Kom igång';

  @override
  String get loginTitle => 'Välkommen till Abba';

  @override
  String get loginSubtitle => 'Logga in för att börja din böneresa';

  @override
  String get signInWithApple => 'Fortsätt med Apple';

  @override
  String get signInWithGoogle => 'Fortsätt med Google';

  @override
  String get signInWithEmail => 'Fortsätt med e-post';

  @override
  String greetingMorning(Object name) {
    return 'God morgon, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'God eftermiddag, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'God kväll, $name';
  }

  @override
  String get prayButton => 'Be';

  @override
  String get qtButton => 'Stilla stund';

  @override
  String streakDays(Object count) {
    return '$count dagars bönesvit';
  }

  @override
  String get dailyVerse => 'Dagens vers';

  @override
  String get tabHome => 'Hem';

  @override
  String get tabCalendar => 'Kalender';

  @override
  String get tabCommunity => 'Gemenskap';

  @override
  String get tabSettings => 'Inställningar';

  @override
  String get recordingTitle => 'Ber...';

  @override
  String get recordingPause => 'Pausa';

  @override
  String get recordingResume => 'Fortsätt';

  @override
  String get finishPrayer => 'Avsluta bön';

  @override
  String get finishPrayerConfirm => 'Vill du avsluta din bön?';

  @override
  String get switchToText => 'Skriv istället';

  @override
  String get textInputHint => 'Skriv din bön här...';

  @override
  String get aiLoadingText => 'Begrundar din bön...';

  @override
  String get aiLoadingVerse =>
      'Var stilla och besinna att jag är Gud.\n— Psalm 46:10';

  @override
  String get dashboardTitle => 'Bönens Trädgård';

  @override
  String get shareButton => 'Dela';

  @override
  String get backToHome => 'Tillbaka till Hem';

  @override
  String get scriptureTitle => 'Dagens bibelord';

  @override
  String get bibleStoryTitle => 'Bibelberättelse';

  @override
  String get testimonyTitle => 'Vittnesbörd · Min bön';

  @override
  String get testimonyHelperText =>
      'Reflektera över din bön · kan delas med gemenskapen';

  @override
  String get myPrayerAudioLabel => 'Inspelning av min bön';

  @override
  String get testimonyEdit => 'Redigera';

  @override
  String get guidanceTitle => 'AI-vägledning';

  @override
  String get aiPrayerTitle => 'En bön för dig';

  @override
  String get originalLangTitle => 'Originalspråk';

  @override
  String get proUnlock => 'Lås upp med Pro';

  @override
  String get qtPageTitle => 'Morgonens Trädgård';

  @override
  String get qtMeditateButton => 'Börja meditation';

  @override
  String get qtCompleted => 'Klart';

  @override
  String get communityTitle => 'Bönens Trädgård';

  @override
  String get filterAll => 'Alla';

  @override
  String get filterTestimony => 'Vittnesbörd';

  @override
  String get filterPrayerRequest => 'Böneämne';

  @override
  String get likeButton => 'Gilla';

  @override
  String get commentButton => 'Kommentera';

  @override
  String get saveButton => 'Spara';

  @override
  String get replyButton => 'Svara';

  @override
  String get writePostTitle => 'Dela';

  @override
  String get cancelButton => 'Avbryt';

  @override
  String get sharePostButton => 'Publicera';

  @override
  String get anonymousToggle => 'Anonym';

  @override
  String get realNameToggle => 'Riktigt namn';

  @override
  String get categoryTestimony => 'Vittnesbörd';

  @override
  String get categoryPrayerRequest => 'Böneämne';

  @override
  String get writePostHint => 'Dela ditt vittnesbörd eller böneämne...';

  @override
  String get importFromPrayer => 'Importera från bön';

  @override
  String get calendarTitle => 'Bönekalender';

  @override
  String get currentStreak => 'Nuvarande svit';

  @override
  String get bestStreak => 'Bästa svit';

  @override
  String get days => 'dagar';

  @override
  String calendarRecordCount(Object count) {
    return '$count poster';
  }

  @override
  String get todayVerse => 'Dagens vers';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Totalt antal böner';

  @override
  String get consecutiveDays => 'Dagar i rad';

  @override
  String get proSection => 'Medlemskap';

  @override
  String get freePlan => 'Gratis';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '79 kr / mån';

  @override
  String get yearlyPrice => '559 kr / år';

  @override
  String get yearlySave => 'Spara 40%';

  @override
  String get launchPromo => '3 månader för 45kr/mån!';

  @override
  String get startPro => 'Starta Pro';

  @override
  String get comingSoon => 'Kommer snart';

  @override
  String get notificationSetting => 'Aviseringar';

  @override
  String get languageSetting => 'Språk';

  @override
  String get darkModeSetting => 'Mörkt läge';

  @override
  String get helpCenter => 'Hjälpcenter';

  @override
  String get termsOfService => 'Användarvillkor';

  @override
  String get privacyPolicy => 'Integritetspolicy';

  @override
  String get logout => 'Logga ut';

  @override
  String appVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get anonymous => 'Anonym';

  @override
  String timeAgo(Object time) {
    return '$time sedan';
  }

  @override
  String get emailLabel => 'E-post';

  @override
  String get passwordLabel => 'Lösenord';

  @override
  String get signIn => 'Logga in';

  @override
  String get cancel => 'Avbryt';

  @override
  String get noPrayersRecorded => 'Inga böner registrerade';

  @override
  String get deletePost => 'Ta bort';

  @override
  String get reportPost => 'Rapportera';

  @override
  String get reportSubmitted => 'Rapporten har skickats. Tack.';

  @override
  String get reportReasonHint =>
      'Beskriv anledningen till rapporten. Den skickas via e-post.';

  @override
  String get reportReasonPlaceholder => 'Ange anledning till rapporten...';

  @override
  String get reportSubmitButton => 'Rapportera';

  @override
  String get deleteConfirmTitle => 'Ta bort inlägg';

  @override
  String get deleteConfirmMessage =>
      'Är du säker på att du vill ta bort detta inlägg?';

  @override
  String get errorNetwork =>
      'Kontrollera din internetanslutning och försök igen.';

  @override
  String get errorAiFallback =>
      'Vi kunde inte nå AI just nu. Här är en vers till dig.';

  @override
  String get errorSttFailed =>
      'Röstigenkänning är inte tillgänglig. Skriv istället.';

  @override
  String get errorPayment =>
      'Det uppstod ett betalningsproblem. Försök igen i Inställningar.';

  @override
  String get errorGeneric => 'Något gick fel. Försök igen senare.';

  @override
  String get offlineNotice =>
      'Du är offline. Vissa funktioner kan vara begränsade.';

  @override
  String get retryButton => 'Försök igen';

  @override
  String get groupSection => 'Mina grupper';

  @override
  String get createGroup => 'Skapa en bönegrupp';

  @override
  String get inviteFriends => 'Bjud in vänner';

  @override
  String get groupInviteMessage =>
      'Låt oss be tillsammans! Gå med i min bönegrupp på Abba.';

  @override
  String get noGroups => 'Gå med eller skapa en grupp för att be tillsammans.';

  @override
  String get promoTitle => 'Lanseringserbjudande';

  @override
  String get promoBanner => 'Första 3 månaderna för 45kr/mån!';

  @override
  String promoEndsOn(Object date) {
    return 'Erbjudandet slutar $date';
  }

  @override
  String get proLimitTitle => 'Dagens bön är klar';

  @override
  String get proLimitBody => 'Vi ses imorgon!\nBe obegränsat med Pro';

  @override
  String get laterButton => 'Kanske senare';

  @override
  String get proPromptTitle => 'Pro-funktion';

  @override
  String get proPromptBody =>
      'Denna funktion finns med Pro.\nVill du se våra planer?';

  @override
  String get viewProducts => 'Visa planer';

  @override
  String get maybeLater => 'Kanske senare';

  @override
  String get proHeadline => 'Närmare Gud, varje dag';

  @override
  String get proBenefit1 => 'Obegränsad bön & stilla stund';

  @override
  String get proBenefit2 => 'AI-driven bön & vägledning';

  @override
  String get proBenefit3 => 'Trosberättelser från historien';

  @override
  String get proBenefit5 => 'Bibelstudium på originalspråk';

  @override
  String get bestValue => 'BÄST VÄRDE';

  @override
  String get perMonth => 'mån';

  @override
  String get cancelAnytime => 'Avsluta när som helst';

  @override
  String get restorePurchase => 'Återställ köp';

  @override
  String get yearlyPriceMonthly => '47 kr/mån';

  @override
  String get morningPrayerReminder => 'Morgonbön';

  @override
  String get eveningGratitudeReminder => 'Kvällstacksamhet';

  @override
  String get streakReminder => 'Svitpåminnelse';

  @override
  String get afternoonNudgeReminder => 'Eftermiddagsbön påminnelse';

  @override
  String get weeklySummaryReminder => 'Veckosammanfattning';

  @override
  String get unlimited => 'Obegränsat';

  @override
  String get streakRecovery => 'Det är okej, du kan börja om 🌱';

  @override
  String get prayerSaved => 'Bön sparad';

  @override
  String get quietTimeLabel => 'Stilla stund';

  @override
  String get morningPrayerLabel => 'Morgonbön';

  @override
  String get gardenSeed => 'Ett trons frö';

  @override
  String get gardenSprout => 'Växande grodd';

  @override
  String get gardenBud => 'Blomknopp';

  @override
  String get gardenBloom => 'Full blom';

  @override
  String get gardenTree => 'Starkt träd';

  @override
  String get gardenForest => 'Bönens skog';

  @override
  String get milestoneShare => 'Dela';

  @override
  String get milestoneThankGod => 'Tack Gud!';

  @override
  String shareStreakText(Object count) {
    return '$count dagars bönesvit! Min böneresa med Abba #Abba #Bön';
  }

  @override
  String get shareDaysLabel => 'dagars bönesvit';

  @override
  String get shareSubtitle => 'Daglig bön med Gud';

  @override
  String get proActive => 'Medlemskap Aktivt';

  @override
  String get planOncePerDay => '1 gång/dag';

  @override
  String get planUnlimited => 'Obegränsat';

  @override
  String get closeRecording => 'Stäng inspelning';

  @override
  String get qtRevealMessage => 'Låt oss öppna dagens Ord';

  @override
  String get qtSelectPrompt => 'Välj ett ämne och börja dagens stilla stund';

  @override
  String get qtTopicLabel => 'Ämne';

  @override
  String get prayerStartPrompt => 'Börja din bön';

  @override
  String get startPrayerButton => 'Börja be';

  @override
  String get switchToTextMode => 'Skriv istället';

  @override
  String get switchToVoiceMode => 'Tala';

  @override
  String get prayerDashboardTitle => 'Bönens Trädgård';

  @override
  String get qtDashboardTitle => 'Stilla stundens Trädgård';

  @override
  String get prayerSummaryTitle => 'Bönesammanfattning';

  @override
  String get gratitudeLabel => 'Tacksamhet';

  @override
  String get petitionLabel => 'Bönebegäran';

  @override
  String get intercessionLabel => 'Förbön';

  @override
  String get historicalStoryTitle => 'Berättelse från historien';

  @override
  String get todayLesson => 'Dagens lärdom';

  @override
  String get applicationTitle => 'Dagens tillämpning';

  @override
  String get applicationWhat => 'Vad';

  @override
  String get applicationWhen => 'När';

  @override
  String get applicationContext => 'Var';

  @override
  String get applicationMorningLabel => 'Morgon';

  @override
  String get applicationDayLabel => 'Dag';

  @override
  String get applicationEveningLabel => 'Kväll';

  @override
  String get relatedKnowledgeTitle => 'Relaterad kunskap';

  @override
  String get originalWordLabel => 'Originalord';

  @override
  String get historicalContextLabel => 'Historiskt sammanhang';

  @override
  String get crossReferencesLabel => 'Korsreferenser';

  @override
  String get growthStoryTitle => 'Tillväxtberättelse';

  @override
  String get prayerGuideTitle => 'Hur du ber med Abba';

  @override
  String get prayerGuide1 => 'Be högt eller med tydlig röst';

  @override
  String get prayerGuide2 =>
      'Abba lyssnar på din bön och hittar bibelord som talar till ditt hjärta';

  @override
  String get prayerGuide3 => 'Du kan också skriva din bön om du föredrar det';

  @override
  String get qtGuideTitle => 'Hur du har stilla stund med Abba';

  @override
  String get qtGuide1 => 'Läs texten och meditera tyst';

  @override
  String get qtGuide2 =>
      'Dela vad du upptäckte — tala eller skriv din reflektion';

  @override
  String get qtGuide3 => 'Abba hjälper dig att tillämpa Ordet i din vardag';

  @override
  String get scriptureReasonLabel => 'Varför detta bibelord';

  @override
  String get scripturePostureLabel =>
      'Med vilken inställning ska jag läsa det?';

  @override
  String get scriptureOriginalWordsTitle =>
      'Djupare betydelse på originalspråket';

  @override
  String get originalWordMeaningLabel => 'Betydelse';

  @override
  String get originalWordNuanceLabel => 'Nyans vs översättning';

  @override
  String originalWordsCountLabel(int count) {
    return '$count ord';
  }

  @override
  String get seeMore => 'Se mer';

  @override
  String seeAllComments(Object count) {
    return 'Visa alla $count kommentarer';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name och $count andra gillade detta';
  }

  @override
  String get commentsTitle => 'Kommentarer';

  @override
  String get myPageTitle => 'Min Böneträdgård';

  @override
  String get myPrayers => 'Mina böner';

  @override
  String get myTestimonies => 'Mina vittnesbörd';

  @override
  String get savedPosts => 'Sparade';

  @override
  String get totalPrayersCount => 'Böner';

  @override
  String get streakCount => 'Svit';

  @override
  String get testimoniesCount => 'Vittnesbörd';

  @override
  String get linkAccountTitle => 'Koppla konto';

  @override
  String get linkAccountDescription =>
      'Koppla ditt konto för att behålla bönehistorik vid byte av enhet';

  @override
  String get linkWithApple => 'Koppla med Apple';

  @override
  String get linkWithGoogle => 'Koppla med Google';

  @override
  String get linkAccountSuccess => 'Kontot kopplades!';

  @override
  String get anonymousUser => 'Bönekrigar';

  @override
  String showReplies(Object count) {
    return 'Visa $count svar';
  }

  @override
  String get hideReplies => 'Dölj svar';

  @override
  String replyingTo(Object name) {
    return 'Svarar $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Visa alla $count kommentarer';
  }

  @override
  String get membershipTitle => 'Medlemskap';

  @override
  String get membershipSubtitle => 'Fördjupa ditt böneliv';

  @override
  String get monthlyPlan => 'Månadsvis';

  @override
  String get yearlyPlan => 'Årsvis';

  @override
  String get yearlySavings => '32 kr/mån (40% rabatt)';

  @override
  String get startMembership => 'Börja nu';

  @override
  String get membershipActive => 'Medlemskap Aktivt';

  @override
  String get leaveRecordingTitle => 'Lämna inspelningen?';

  @override
  String get leaveRecordingMessage =>
      'Din inspelning kommer att gå förlorad. Är du säker?';

  @override
  String get leaveButton => 'Lämna';

  @override
  String get stayButton => 'Stanna';

  @override
  String likedByCount(Object count) {
    return '$count personer har känt med';
  }

  @override
  String get actionLike => 'Gilla';

  @override
  String get actionComment => 'Kommentera';

  @override
  String get actionSave => 'Spara';

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
  String get billingIssueTitle => 'Betalningsproblem upptäckt';

  @override
  String billingIssueBody(int days) {
    return 'Dina Pro-förmåner upphör om $days dagar om betalningen inte uppdateras.';
  }

  @override
  String get billingIssueAction => 'Uppdatera betalning';

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
      '💛 Kärlek — Tänk på någon du älskar i 10 sekunder';

  @override
  String get qtLoadingHint2 => '🌿 Nåd — Kom ihåg en liten nåd du fick idag';

  @override
  String get qtLoadingHint3 =>
      '🌅 Hopp — Föreställ dig ett litet hopp för imorgon';

  @override
  String get qtLoadingHint4 => '🕊️ Frid — Ta tre djupa, långsamma andetag';

  @override
  String get qtLoadingHint5 => '🌳 Tro — Kom ihåg en oföränderlig sanning';

  @override
  String get qtLoadingHint6 =>
      '🌸 Tacksamhet — Nämn något du är tacksam för just nu';

  @override
  String get qtLoadingHint7 => '🌊 Förlåtelse — Tänk på någon att förlåta';

  @override
  String get qtLoadingHint8 => '📖 Visdom — Bevara en lärdom från idag';

  @override
  String get qtLoadingHint9 => '⏳ Tålamod — Tänk på vad du tyst väntar på';

  @override
  String get qtLoadingHint10 => '✨ Glädje — Kom ihåg ett leende från idag';

  @override
  String get qtLoadingTitle => 'Förbereder dagens Ord...';

  @override
  String get coachingTitle => 'Böncoaching';

  @override
  String get coachingLoadingText => 'Reflekterar över din bön...';

  @override
  String get coachingErrorText => 'Tillfälligt fel — försök igen';

  @override
  String get coachingRetryButton => 'Försök igen';

  @override
  String get coachingScoreSpecificity => 'Specificitet';

  @override
  String get coachingScoreGodCentered => 'Gudscentrerat';

  @override
  String get coachingScoreActs => 'ACTS-balans';

  @override
  String get coachingScoreAuthenticity => 'Äkthet';

  @override
  String get coachingStrengthsTitle => 'Det du gjorde bra ✨';

  @override
  String get coachingImprovementsTitle => 'För att gå djupare 💡';

  @override
  String get coachingProCta => 'Lås upp Böncoaching med Pro';

  @override
  String get coachingLevelBeginner => '🌱 Nybörjare';

  @override
  String get coachingLevelGrowing => '🌿 Växande';

  @override
  String get coachingLevelExpert => '🌳 Expert';

  @override
  String get aiPrayerCitationsTitle => 'Referenser · Citat';

  @override
  String get citationTypeQuote => 'Citat';

  @override
  String get citationTypeScience => 'Forskning';

  @override
  String get citationTypeExample => 'Exempel';

  @override
  String get citationTypeHistory => 'Historia';

  @override
  String get aiPrayerReadingTime => '2 minuters läsning';

  @override
  String get scriptureKeyWordHintTitle => 'Dagens nyckelord';

  @override
  String get bibleLookupReferenceHint =>
      'Hitta detta stycke i din Bibel och meditera över det.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Bibelöversättningar';

  @override
  String get settingsBibleTranslationsIntro =>
      'Bibelverserna i denna app kommer från översättningar i det offentliga området. Kommentarer, böner och berättelser som genereras av AI är Abbas kreativa verk.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'QT-coaching';

  @override
  String get qtCoachingLoadingText => 'Reflekterar över din meditation...';

  @override
  String get qtCoachingErrorText => 'Tillfälligt fel — försök igen';

  @override
  String get qtCoachingRetryButton => 'Försök igen';

  @override
  String get qtCoachingScoreComprehension => 'Förståelse';

  @override
  String get qtCoachingScoreApplication => 'Personlig tillämpning';

  @override
  String get qtCoachingScoreDepth => 'Andligt djup';

  @override
  String get qtCoachingScoreAuthenticity => 'Äkthet';

  @override
  String get qtCoachingStrengthsTitle => 'Det du gjorde bra ✨';

  @override
  String get qtCoachingImprovementsTitle => 'För att gå djupare 💡';

  @override
  String get qtCoachingProCta => 'Lås upp QT-coaching med Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Nybörjare';

  @override
  String get qtCoachingLevelGrowing => '🌿 Växande';

  @override
  String get qtCoachingLevelExpert => '🌳 Expert';

  @override
  String get notifyMorning1Title => '🙏 Dags att be';

  @override
  String notifyMorning1Body(String name) {
    return '$name, prata med Gud idag också';
  }

  @override
  String get notifyMorning2Title => '🌅 En ny morgon har kommit';

  @override
  String notifyMorning2Body(String name) {
    return '$name, börja dagen med tacksamhet';
  }

  @override
  String get notifyMorning3Title => '✨ Dagens nåd';

  @override
  String notifyMorning3Body(String name) {
    return '$name, möt nåden Gud har berett';
  }

  @override
  String get notifyMorning4Title => '🕊️ Fridfull morgon';

  @override
  String notifyMorning4Body(String name) {
    return '$name, fyll hjärtat med frid genom bön';
  }

  @override
  String get notifyMorning5Title => '📖 Med Ordet';

  @override
  String notifyMorning5Body(String name) {
    return '$name, lyssna på Guds röst idag';
  }

  @override
  String get notifyMorning6Title => '🌿 Dags att vila';

  @override
  String notifyMorning6Body(String name) {
    return '$name, stanna upp ett ögonblick och be';
  }

  @override
  String get notifyMorning7Title => '💫 Även idag';

  @override
  String notifyMorning7Body(String name) {
    return '$name, en dag som börjar med bön är annorlunda';
  }

  @override
  String get notifyEvening1Title => '✨ Tacksam för idag';

  @override
  String get notifyEvening1Body => 'Blicka tillbaka på dagen och be en tackbön';

  @override
  String get notifyEvening2Title => '🌙 Avslutar dagen';

  @override
  String get notifyEvening2Body => 'Uttryck dagens tacksamhet genom bön';

  @override
  String get notifyEvening3Title => '🙏 Kvällsbön';

  @override
  String get notifyEvening3Body => 'Tacka Gud vid dagens slut';

  @override
  String get notifyEvening4Title => '🌟 Räknar dagens välsignelser';

  @override
  String get notifyEvening4Body =>
      'Om du har något att tacka för, dela det i bön';

  @override
  String get notifyStreak3Title => '🌱 3 dagar i rad!';

  @override
  String get notifyStreak3Body => 'Din bönevana har börjat';

  @override
  String get notifyStreak7Title => '🌿 En hel vecka!';

  @override
  String get notifyStreak7Body => 'Bön blir en vana';

  @override
  String get notifyStreak14Title => '🌳 2 veckor i rad!';

  @override
  String get notifyStreak14Body => 'Fantastisk tillväxt!';

  @override
  String get notifyStreak21Title => '🌻 3 veckor i rad!';

  @override
  String get notifyStreak21Body => 'Bönens blomma slår ut';

  @override
  String get notifyStreak30Title => '🏆 En hel månad!';

  @override
  String get notifyStreak30Body => 'Din bön lyser';

  @override
  String get notifyStreak50Title => '👑 50 dagar i rad!';

  @override
  String get notifyStreak50Body => 'Din vandring med Gud fördjupas';

  @override
  String get notifyStreak100Title => '🎉 100 dagar i rad!';

  @override
  String get notifyStreak100Body => 'Du har blivit en bönekrigare!';

  @override
  String get notifyStreak365Title => '✝️ Ett helt år!';

  @override
  String get notifyStreak365Body => 'Vilken fantastisk trosresa!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ Har du bett idag?';

  @override
  String get notifyAfternoonNudgeBody => 'En kort bön kan förändra dagen';

  @override
  String get notifyChannelName => 'Bönpåminnelser';

  @override
  String get notifyChannelDescription =>
      'Morgonbön, kvällstacksamhet och andra bönpåminnelser';

  @override
  String get milestoneFirstPrayerTitle => 'Första bönen!';

  @override
  String get milestoneFirstPrayerDesc =>
      'Din böneresa har börjat. Gud lyssnar.';

  @override
  String get milestoneSevenDayStreakTitle => '7 dagars bön!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'En vecka av trogen bön. Din trädgård växer!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 dagar!';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'Din trädgård har blommat till ett blomsterfält!';

  @override
  String get milestoneHundredPrayersTitle => '100:e bönen!';

  @override
  String get milestoneHundredPrayersDesc =>
      'Hundra samtal med Gud. Du är djupt rotad.';

  @override
  String get homeFirstPrayerPrompt => 'Börja din första bön';

  @override
  String get homeFirstQtPrompt => 'Börja din första QT';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Gör $activityName även idag';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'Dag $count kontinuerligt $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'Det är $days dagar sedan din senaste $activityName';
  }

  @override
  String get homeActivityPrayer => 'bön';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Laddar...';

  @override
  String get heatmapNoPrayer => 'Ingen bön';

  @override
  String get qtPassagesLoadError =>
      'Dagens bibelställen kunde inte laddas. Kontrollera anslutningen.';

  @override
  String get qtPassagesRetryButton => 'Försök igen';
}
