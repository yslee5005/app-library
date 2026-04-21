// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Når du beder,\nsvarer Gud.';

  @override
  String get welcomeSubtitle => 'Din daglige bønne- og stille stund-følgesvend';

  @override
  String get getStarted => 'Kom i gang';

  @override
  String get loginTitle => 'Velkommen til Abba';

  @override
  String get loginSubtitle => 'Log ind for at begynde din bønnerejse';

  @override
  String get signInWithApple => 'Fortsæt med Apple';

  @override
  String get signInWithGoogle => 'Fortsæt med Google';

  @override
  String get signInWithEmail => 'Fortsæt med e-mail';

  @override
  String greetingMorning(Object name) {
    return 'Godmorgen, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'God eftermiddag, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Godaften, $name';
  }

  @override
  String get prayButton => 'Bed';

  @override
  String get qtButton => 'Stille stund';

  @override
  String streakDays(Object count) {
    return '$count dages bønnerække';
  }

  @override
  String get dailyVerse => 'Dagens vers';

  @override
  String get tabHome => 'Hjem';

  @override
  String get tabCalendar => 'Kalender';

  @override
  String get tabCommunity => 'Fællesskab';

  @override
  String get tabSettings => 'Indstillinger';

  @override
  String get recordingTitle => 'Beder...';

  @override
  String get recordingPause => 'Pause';

  @override
  String get recordingResume => 'Fortsæt';

  @override
  String get finishPrayer => 'Afslut bøn';

  @override
  String get finishPrayerConfirm => 'Vil du afslutte din bøn?';

  @override
  String get switchToText => 'Skriv i stedet';

  @override
  String get textInputHint => 'Skriv din bøn her...';

  @override
  String get aiLoadingText => 'Overvejer din bøn...';

  @override
  String get aiLoadingVerse =>
      'Vær stille og vid, at jeg er Gud.\n— Salme 46:10';

  @override
  String get dashboardTitle => 'Bønnens Have';

  @override
  String get shareButton => 'Del';

  @override
  String get backToHome => 'Tilbage til Hjem';

  @override
  String get scriptureTitle => 'Dagens skriftsted';

  @override
  String get bibleStoryTitle => 'Bibelhistorie';

  @override
  String get testimonyTitle => 'Vidnesbyrd · Min bøn';

  @override
  String get testimonyHelperText =>
      'Reflekter over din bøn · kan deles med fællesskabet';

  @override
  String get myPrayerAudioLabel => 'Optagelse af min bøn';

  @override
  String get testimonyEdit => 'Rediger';

  @override
  String get guidanceTitle => 'AI-vejledning';

  @override
  String get aiPrayerTitle => 'En bøn for dig';

  @override
  String get originalLangTitle => 'Originalsprog';

  @override
  String get proUnlock => 'Lås op med Pro';

  @override
  String get qtPageTitle => 'Morgenens Have';

  @override
  String get qtMeditateButton => 'Begynd meditation';

  @override
  String get qtCompleted => 'Fuldført';

  @override
  String get communityTitle => 'Bønnens Have';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterTestimony => 'Vidnesbyrd';

  @override
  String get filterPrayerRequest => 'Bønneemne';

  @override
  String get likeButton => 'Synes godt om';

  @override
  String get commentButton => 'Kommentar';

  @override
  String get saveButton => 'Gem';

  @override
  String get replyButton => 'Svar';

  @override
  String get writePostTitle => 'Del';

  @override
  String get cancelButton => 'Annuller';

  @override
  String get sharePostButton => 'Offentliggør';

  @override
  String get anonymousToggle => 'Anonym';

  @override
  String get realNameToggle => 'Rigtig navn';

  @override
  String get categoryTestimony => 'Vidnesbyrd';

  @override
  String get categoryPrayerRequest => 'Bønneemne';

  @override
  String get writePostHint => 'Del dit vidnesbyrd eller bønneemne...';

  @override
  String get importFromPrayer => 'Importer fra bøn';

  @override
  String get calendarTitle => 'Bønnekalender';

  @override
  String get currentStreak => 'Nuværende række';

  @override
  String get bestStreak => 'Bedste række';

  @override
  String get days => 'dage';

  @override
  String calendarRecordCount(Object count) {
    return '$count poster';
  }

  @override
  String get todayVerse => 'Dagens vers';

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Samlede bønner';

  @override
  String get consecutiveDays => 'Dage i træk';

  @override
  String get proSection => 'Medlemskab';

  @override
  String get freePlan => 'Gratis';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '49 kr / mdr';

  @override
  String get yearlyPrice => '369 kr / år';

  @override
  String get yearlySave => 'Spar 40%';

  @override
  String get launchPromo => '3 måneder for 29kr/md!';

  @override
  String get startPro => 'Start Pro';

  @override
  String get comingSoon => 'Kommer snart';

  @override
  String get notificationSetting => 'Notifikationer';

  @override
  String get languageSetting => 'Sprog';

  @override
  String get darkModeSetting => 'Mørk tilstand';

  @override
  String get helpCenter => 'Hjælpecenter';

  @override
  String get termsOfService => 'Servicevilkår';

  @override
  String get privacyPolicy => 'Privatlivspolitik';

  @override
  String get logout => 'Log ud';

  @override
  String appVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get anonymous => 'Anonym';

  @override
  String timeAgo(Object time) {
    return '$time siden';
  }

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Adgangskode';

  @override
  String get signIn => 'Log ind';

  @override
  String get cancel => 'Annuller';

  @override
  String get noPrayersRecorded => 'Ingen bønner registreret';

  @override
  String get deletePost => 'Slet';

  @override
  String get reportPost => 'Rapporter';

  @override
  String get reportSubmitted => 'Rapporten er sendt. Tak.';

  @override
  String get reportReasonHint =>
      'Beskriv venligst årsagen til rapporten. Den sendes via e-mail.';

  @override
  String get reportReasonPlaceholder => 'Angiv årsagen til rapporten...';

  @override
  String get reportSubmitButton => 'Rapporter';

  @override
  String get deleteConfirmTitle => 'Slet opslag';

  @override
  String get deleteConfirmMessage =>
      'Er du sikker på, at du vil slette dette opslag?';

  @override
  String get errorNetwork => 'Kontroller din internetforbindelse og prøv igen.';

  @override
  String get errorAiFallback =>
      'Vi kunne ikke nå AI lige nu. Her er et vers til dig.';

  @override
  String get errorSttFailed =>
      'Talegenkendelse er ikke tilgængelig. Skriv venligst i stedet.';

  @override
  String get errorPayment =>
      'Der var et problem med betalingen. Prøv igen i Indstillinger.';

  @override
  String get errorGeneric => 'Noget gik galt. Prøv igen senere.';

  @override
  String get offlineNotice =>
      'Du er offline. Nogle funktioner kan være begrænsede.';

  @override
  String get retryButton => 'Prøv igen';

  @override
  String get groupSection => 'Mine grupper';

  @override
  String get createGroup => 'Opret en bønnegruppe';

  @override
  String get inviteFriends => 'Inviter venner';

  @override
  String get groupInviteMessage =>
      'Lad os bede sammen! Bliv medlem af min bønnegruppe på Abba.';

  @override
  String get noGroups =>
      'Tilmeld dig eller opret en gruppe for at bede sammen.';

  @override
  String get promoTitle => 'Lanceringstilbud';

  @override
  String get promoBanner => 'Første 3 måneder for 29kr/md!';

  @override
  String promoEndsOn(Object date) {
    return 'Tilbuddet udløber $date';
  }

  @override
  String get proLimitTitle => 'Dagens bøn er fuldført';

  @override
  String get proLimitBody => 'Vi ses i morgen!\nBed ubegrænset med Pro';

  @override
  String get laterButton => 'Måske senere';

  @override
  String get proPromptTitle => 'Pro-funktion';

  @override
  String get proPromptBody =>
      'Denne funktion er tilgængelig med Pro.\nVil du se vores planer?';

  @override
  String get viewProducts => 'Se planer';

  @override
  String get maybeLater => 'Måske senere';

  @override
  String get proHeadline => 'Tættere på Gud, hver dag';

  @override
  String get proBenefit1 => 'Ubegrænset bøn & stille stund';

  @override
  String get proBenefit2 => 'AI-drevet bøn & vejledning';

  @override
  String get proBenefit3 => 'Troshistorier fra fortiden';

  @override
  String get proBenefit5 => 'Bibelstudium på originalsprog';

  @override
  String get bestValue => 'BEDSTE VÆRDI';

  @override
  String get perMonth => 'md';

  @override
  String get cancelAnytime => 'Annuller når som helst';

  @override
  String get restorePurchase => 'Gendan køb';

  @override
  String get yearlyPriceMonthly => '31 kr/mdr';

  @override
  String get morningPrayerReminder => 'Morgenbøn';

  @override
  String get eveningGratitudeReminder => 'Aftentaknemmelighed';

  @override
  String get streakReminder => 'Rækkepåmindelse';

  @override
  String get afternoonNudgeReminder => 'Eftermiddagsbøn påmindelse';

  @override
  String get weeklySummaryReminder => 'Ugentlig opsummering';

  @override
  String get unlimited => 'Ubegrænset';

  @override
  String get streakRecovery => 'Det er okay, du kan starte forfra 🌱';

  @override
  String get prayerSaved => 'Bønnen er gemt';

  @override
  String get quietTimeLabel => 'Stille stund';

  @override
  String get morningPrayerLabel => 'Morgenbøn';

  @override
  String get gardenSeed => 'Et troens frø';

  @override
  String get gardenSprout => 'Voksende spire';

  @override
  String get gardenBud => 'Blomsterknop';

  @override
  String get gardenBloom => 'Fuld blomst';

  @override
  String get gardenTree => 'Stærkt træ';

  @override
  String get gardenForest => 'Bønnens skov';

  @override
  String get milestoneShare => 'Del';

  @override
  String get milestoneThankGod => 'Tak Gud!';

  @override
  String shareStreakText(Object count) {
    return '$count dages bønnerække! Min bønnerejse med Abba #Abba #Bøn';
  }

  @override
  String get shareDaysLabel => 'dages bønnerække';

  @override
  String get shareSubtitle => 'Daglig bøn med Gud';

  @override
  String get proActive => 'Medlemskab Aktivt';

  @override
  String get planOncePerDay => '1 gang/dag';

  @override
  String get planUnlimited => 'Ubegrænset';

  @override
  String get closeRecording => 'Luk optagelse';

  @override
  String get qtRevealMessage => 'Lad os åbne dagens Ord';

  @override
  String get qtSelectPrompt => 'Vælg et emne og begynd dagens stille stund';

  @override
  String get qtTopicLabel => 'Emne';

  @override
  String get prayerStartPrompt => 'Begynd din bøn';

  @override
  String get startPrayerButton => 'Begynd at bede';

  @override
  String get switchToTextMode => 'Skriv i stedet';

  @override
  String get switchToVoiceMode => 'Tal i stedet';

  @override
  String get prayerDashboardTitle => 'Bønnens Have';

  @override
  String get qtDashboardTitle => 'Stille stundens Have';

  @override
  String get prayerSummaryTitle => 'Bønneoversigt';

  @override
  String get gratitudeLabel => 'Taknemmelighed';

  @override
  String get petitionLabel => 'Bønfaldelse';

  @override
  String get intercessionLabel => 'Forbøn';

  @override
  String get historicalStoryTitle => 'Fortælling fra historien';

  @override
  String get todayLesson => 'Dagens lærdom';

  @override
  String get meditationAnalysisTitle => 'Meditationsanalyse';

  @override
  String get keyThemeLabel => 'Nøgletema';

  @override
  String get applicationTitle => 'Dagens anvendelse';

  @override
  String get applicationWhat => 'Hvad';

  @override
  String get applicationWhen => 'Hvornår';

  @override
  String get applicationContext => 'Hvor';

  @override
  String get relatedKnowledgeTitle => 'Relateret viden';

  @override
  String get originalWordLabel => 'Originalord';

  @override
  String get historicalContextLabel => 'Historisk kontekst';

  @override
  String get crossReferencesLabel => 'Krydsreferencer';

  @override
  String get growthStoryTitle => 'Væksthistorie';

  @override
  String get prayerGuideTitle => 'Sådan beder du med Abba';

  @override
  String get prayerGuide1 => 'Bed højt eller med tydelig stemme';

  @override
  String get prayerGuide2 =>
      'Abba lytter til din bøn og finder skriftsteder der taler til dit hjerte';

  @override
  String get prayerGuide3 =>
      'Du kan også skrive din bøn, hvis du foretrækker det';

  @override
  String get qtGuideTitle => 'Sådan har du stille stund med Abba';

  @override
  String get qtGuide1 => 'Læs teksten og mediter i stilhed';

  @override
  String get qtGuide2 =>
      'Del hvad du opdagede — sig det eller skriv din refleksion';

  @override
  String get qtGuide3 => 'Abba hjælper dig med at anvende Ordet i din hverdag';

  @override
  String get scriptureReasonLabel => 'Hvorfor dette skriftsted';

  @override
  String get scripturePostureLabel =>
      'Med hvilken indstilling skal jeg læse det?';

  @override
  String get scriptureOriginalWordsTitle =>
      'Dybere betydning på originalsproget';

  @override
  String get originalWordMeaningLabel => 'Betydning';

  @override
  String get originalWordNuanceLabel => 'Nuance vs oversættelse';

  @override
  String originalWordsCountLabel(int count) {
    return '$count ord';
  }

  @override
  String get seeMore => 'Se mere';

  @override
  String seeAllComments(Object count) {
    return 'Se alle $count kommentarer';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name og $count andre kan lide dette';
  }

  @override
  String get commentsTitle => 'Kommentarer';

  @override
  String get myPageTitle => 'Min Bønnehave';

  @override
  String get myPrayers => 'Mine bønner';

  @override
  String get myTestimonies => 'Mine vidnesbyrd';

  @override
  String get savedPosts => 'Gemte';

  @override
  String get totalPrayersCount => 'Bønner';

  @override
  String get streakCount => 'Række';

  @override
  String get testimoniesCount => 'Vidnesbyrd';

  @override
  String get linkAccountTitle => 'Forbind konto';

  @override
  String get linkAccountDescription =>
      'Forbind din konto for at beholde bønnehistorik ved skift af enhed';

  @override
  String get linkWithApple => 'Forbind med Apple';

  @override
  String get linkWithGoogle => 'Forbind med Google';

  @override
  String get linkAccountSuccess => 'Kontoen er forbundet!';

  @override
  String get anonymousUser => 'Bønnekriger';

  @override
  String showReplies(Object count) {
    return 'Vis $count svar';
  }

  @override
  String get hideReplies => 'Skjul svar';

  @override
  String replyingTo(Object name) {
    return 'Svarer $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Se alle $count kommentarer';
  }

  @override
  String get membershipTitle => 'Medlemskab';

  @override
  String get membershipSubtitle => 'Fordyb dit bedeliv';

  @override
  String get monthlyPlan => 'Månedlig';

  @override
  String get yearlyPlan => 'Årlig';

  @override
  String get yearlySavings => '18 kr/mdr (40% rabat)';

  @override
  String get startMembership => 'Begynd nu';

  @override
  String get membershipActive => 'Medlemskab Aktivt';

  @override
  String get leaveRecordingTitle => 'Forlad optagelsen?';

  @override
  String get leaveRecordingMessage =>
      'Din optagelse vil gå tabt. Er du sikker?';

  @override
  String get leaveButton => 'Forlad';

  @override
  String get stayButton => 'Bliv';

  @override
  String likedByCount(Object count) {
    return '$count personer har vist medfølelse';
  }

  @override
  String get actionLike => 'Synes godt om';

  @override
  String get actionComment => 'Kommentar';

  @override
  String get actionSave => 'Gem';

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
  String accessUntil(String date) {
    return 'Access until: $date';
  }

  @override
  String subscriptionCancelledNotice(String date) {
    return 'Your subscription has been cancelled. You\'ll have access until $date.';
  }

  @override
  String get qtLoadingHint1 =>
      '💛 Kærlighed — Tænk på en, du elsker, i 10 sekunder';

  @override
  String get qtLoadingHint2 => '🌿 Nåde — Husk en lille nåde, du fik i dag';

  @override
  String get qtLoadingHint3 =>
      '🌅 Håb — Forestil dig et lille håb for i morgen';

  @override
  String get qtLoadingHint4 => '🕊️ Fred — Tag tre langsomme, dybe indåndinger';

  @override
  String get qtLoadingHint5 => '🌳 Tro — Husk én uforanderlig sandhed';

  @override
  String get qtLoadingHint6 =>
      '🌸 Taknemmelighed — Nævn én ting, du er taknemmelig for nu';

  @override
  String get qtLoadingHint7 => '🌊 Tilgivelse — Tænk på nogen, du vil tilgive';

  @override
  String get qtLoadingHint8 => '📖 Visdom — Bevar en læring fra i dag';

  @override
  String get qtLoadingHint9 =>
      '⏳ Tålmodighed — Tænk på det, du stille venter på';

  @override
  String get qtLoadingHint10 => '✨ Glæde — Husk et smil fra i dag';

  @override
  String get qtLoadingTitle => 'Forbereder dagens Ord...';

  @override
  String get coachingTitle => 'Bønnecoaching';

  @override
  String get coachingLoadingText => 'Reflekterer over din bøn...';

  @override
  String get coachingErrorText => 'Midlertidig fejl — prøv igen';

  @override
  String get coachingRetryButton => 'Prøv igen';

  @override
  String get coachingScoreSpecificity => 'Konkrethed';

  @override
  String get coachingScoreGodCentered => 'Gudscentreret';

  @override
  String get coachingScoreActs => 'ACTS-balance';

  @override
  String get coachingScoreAuthenticity => 'Ægthed';

  @override
  String get coachingStrengthsTitle => 'Det du gjorde godt ✨';

  @override
  String get coachingImprovementsTitle => 'For at gå dybere 💡';

  @override
  String get coachingProCta => 'Lås op for Bønnecoaching med Pro';

  @override
  String get coachingLevelBeginner => '🌱 Begynder';

  @override
  String get coachingLevelGrowing => '🌿 Voksende';

  @override
  String get coachingLevelExpert => '🌳 Ekspert';

  @override
  String get aiPrayerCitationsTitle => 'Referencer · Citater';

  @override
  String get citationTypeQuote => 'Citat';

  @override
  String get citationTypeScience => 'Forskning';

  @override
  String get citationTypeExample => 'Eksempel';

  @override
  String get aiPrayerReadingTime => '2 minutters læsning';
}
