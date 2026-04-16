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
  String get testimonyTitle => 'Mitt vittnesbörd';

  @override
  String get testimonyEdit => 'Redigera';

  @override
  String get guidanceTitle => 'AI-vägledning';

  @override
  String get aiPrayerTitle => 'En bön för dig';

  @override
  String get originalLangTitle => 'Originalspråk';

  @override
  String get premiumUnlock => 'Lås upp med Premium';

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
  String get premiumSection => 'Medlemskap';

  @override
  String get freePlan => 'Gratis';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get monthlyPrice => '89 kr / mån';

  @override
  String get yearlyPrice => '669 kr / år';

  @override
  String get yearlySave => 'Spara 40%';

  @override
  String get launchPromo => '3 månader för 45kr/mån!';

  @override
  String get startPremium => 'Starta Premium';

  @override
  String get comingSoon => 'Kommer snart';

  @override
  String get notificationSetting => 'Aviseringar';

  @override
  String get aiVoiceSetting => 'AI-röst';

  @override
  String get voiceWarm => 'Varm';

  @override
  String get voiceCalm => 'Lugn';

  @override
  String get voiceStrong => 'Stark';

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
  String get premiumLimitTitle => 'Dagens bön är klar';

  @override
  String get premiumLimitBody => 'Vi ses imorgon!\nBe obegränsat med Premium';

  @override
  String get laterButton => 'Kanske senare';

  @override
  String get premiumPromptTitle => 'Pro-funktion';

  @override
  String get premiumPromptBody =>
      'Denna funktion finns med Pro.\nVill du se våra planer?';

  @override
  String get viewProducts => 'Visa planer';

  @override
  String get maybeLater => 'Kanske senare';

  @override
  String get premiumHeadline => 'Närmare Gud, varje dag';

  @override
  String get premiumBenefit1 => 'Obegränsad bön & stilla stund';

  @override
  String get premiumBenefit2 => 'AI-driven bön & vägledning';

  @override
  String get premiumBenefit3 => 'Trosberättelser från historien';

  @override
  String get premiumBenefit4 => 'Bön uppläst (TTS)';

  @override
  String get premiumBenefit5 => 'Bibelstudium på originalspråk';

  @override
  String get bestValue => 'BÄST VÄRDE';

  @override
  String get perMonth => 'mån';

  @override
  String get cancelAnytime => 'Avsluta när som helst';

  @override
  String get restorePurchase => 'Återställ köp';

  @override
  String get yearlyPriceMonthly => '22kr/mån';

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
  String get premiumActive => 'Medlemskap Aktivt';

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
  String get meditationAnalysisTitle => 'Meditationsanalys';

  @override
  String get keyThemeLabel => 'Nyckeltema';

  @override
  String get applicationTitle => 'Dagens tillämpning';

  @override
  String get applicationWhat => 'Vad';

  @override
  String get applicationWhen => 'När';

  @override
  String get applicationContext => 'Var';

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
  String get yearlySavings => '56 kr/mån (37% rabatt)';

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
}
