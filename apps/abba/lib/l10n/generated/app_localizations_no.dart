// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Når du ber,\nsvarer Gud.';

  @override
  String get welcomeSubtitle => 'Din daglige bønne- og stille stund-følgesvenn';

  @override
  String get getStarted => 'Kom i gang';

  @override
  String get loginTitle => 'Velkommen til Abba';

  @override
  String get loginSubtitle => 'Logg inn for å starte din bønnereise';

  @override
  String get signInWithApple => 'Fortsett med Apple';

  @override
  String get signInWithGoogle => 'Fortsett med Google';

  @override
  String get signInWithEmail => 'Fortsett med e-post';

  @override
  String greetingMorning(Object name) {
    return 'God morgen, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'God ettermiddag, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'God kveld, $name';
  }

  @override
  String get prayButton => 'Be';

  @override
  String get qtButton => 'Stille stund';

  @override
  String streakDays(Object count) {
    return '$count dagers bønnerekke';
  }

  @override
  String get dailyVerse => 'Dagens vers';

  @override
  String get tabHome => 'Hjem';

  @override
  String get tabCalendar => 'Kalender';

  @override
  String get tabCommunity => 'Fellesskap';

  @override
  String get tabSettings => 'Innstillinger';

  @override
  String get recordingTitle => 'Ber...';

  @override
  String get recordingPause => 'Pause';

  @override
  String get recordingResume => 'Fortsett';

  @override
  String get finishPrayer => 'Avslutt bønn';

  @override
  String get finishPrayerConfirm => 'Vil du avslutte bønnen din?';

  @override
  String get switchToText => 'Skriv i stedet';

  @override
  String get textInputHint => 'Skriv bønnen din her...';

  @override
  String get aiLoadingText => 'Reflekterer over bønnen din...';

  @override
  String get aiLoadingVerse =>
      'Vær stille og kjenn at jeg er Gud.\n— Salme 46:10';

  @override
  String get dashboardTitle => 'Bønnens Hage';

  @override
  String get shareButton => 'Del';

  @override
  String get backToHome => 'Tilbake til Hjem';

  @override
  String get scriptureTitle => 'Dagens skriftsted';

  @override
  String get bibleStoryTitle => 'Bibelfortelling';

  @override
  String get testimonyTitle => 'Vitnesbyrd · Min bønn';

  @override
  String get testimonyHelperText =>
      'Reflekter over din bønn · kan deles med fellesskapet';

  @override
  String get myPrayerAudioLabel => 'Opptak av min bønn';

  @override
  String get testimonyEdit => 'Rediger';

  @override
  String get guidanceTitle => 'AI-veiledning';

  @override
  String get aiPrayerTitle => 'En bønn for deg';

  @override
  String get originalLangTitle => 'Originalspråk';

  @override
  String get proUnlock => 'Lås opp med Pro';

  @override
  String get qtPageTitle => 'Morgenens Hage';

  @override
  String get qtMeditateButton => 'Start meditasjon';

  @override
  String get qtCompleted => 'Fullført';

  @override
  String get communityTitle => 'Bønnens Hage';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterTestimony => 'Vitnesbyrd';

  @override
  String get filterPrayerRequest => 'Bønneemne';

  @override
  String get likeButton => 'Lik';

  @override
  String get commentButton => 'Kommenter';

  @override
  String get saveButton => 'Lagre';

  @override
  String get replyButton => 'Svar';

  @override
  String get writePostTitle => 'Del';

  @override
  String get cancelButton => 'Avbryt';

  @override
  String get sharePostButton => 'Publiser';

  @override
  String get anonymousToggle => 'Anonym';

  @override
  String get realNameToggle => 'Ekte navn';

  @override
  String get categoryTestimony => 'Vitnesbyrd';

  @override
  String get categoryPrayerRequest => 'Bønneemne';

  @override
  String get writePostHint => 'Del ditt vitnesbyrd eller bønneemne...';

  @override
  String get importFromPrayer => 'Importer fra bønn';

  @override
  String get calendarTitle => 'Bønnekalender';

  @override
  String get currentStreak => 'Nåværende rekke';

  @override
  String get bestStreak => 'Beste rekke';

  @override
  String get days => 'dager';

  @override
  String calendarRecordCount(Object count) {
    return '$count oppføringer';
  }

  @override
  String get todayVerse => 'Dagens vers';

  @override
  String get settingsTitle => 'Innstillinger';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Totalt antall bønner';

  @override
  String get consecutiveDays => 'Dager på rad';

  @override
  String get proSection => 'Medlemskap';

  @override
  String get freePlan => 'Gratis';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '79 kr / mnd';

  @override
  String get yearlyPrice => '559 kr / år';

  @override
  String get yearlySave => 'Spar 40%';

  @override
  String get launchPromo => '3 måneder for 45kr/mnd!';

  @override
  String get startPro => 'Start Pro';

  @override
  String get comingSoon => 'Kommer snart';

  @override
  String get notificationSetting => 'Varsler';

  @override
  String get languageSetting => 'Språk';

  @override
  String get darkModeSetting => 'Mørk modus';

  @override
  String get helpCenter => 'Hjelpesenter';

  @override
  String get termsOfService => 'Vilkår for bruk';

  @override
  String get privacyPolicy => 'Personvernpolicy';

  @override
  String get logout => 'Logg ut';

  @override
  String appVersion(Object version) {
    return 'Versjon $version';
  }

  @override
  String get anonymous => 'Anonym';

  @override
  String timeAgo(Object time) {
    return '$time siden';
  }

  @override
  String get emailLabel => 'E-post';

  @override
  String get passwordLabel => 'Passord';

  @override
  String get signIn => 'Logg inn';

  @override
  String get cancel => 'Avbryt';

  @override
  String get noPrayersRecorded => 'Ingen bønner registrert';

  @override
  String get deletePost => 'Slett';

  @override
  String get reportPost => 'Rapporter';

  @override
  String get reportSubmitted => 'Rapporten er sendt. Takk.';

  @override
  String get reportReasonHint =>
      'Beskriv grunnen til rapporten. Den sendes via e-post.';

  @override
  String get reportReasonPlaceholder => 'Skriv inn grunnen til rapporten...';

  @override
  String get reportSubmitButton => 'Rapporter';

  @override
  String get deleteConfirmTitle => 'Slett innlegg';

  @override
  String get deleteConfirmMessage =>
      'Er du sikker på at du vil slette dette innlegget?';

  @override
  String get errorNetwork =>
      'Kontroller internettforbindelsen din og prøv igjen.';

  @override
  String get errorAiFallback =>
      'Vi klarte ikke å nå AI akkurat nå. Her er et vers til deg.';

  @override
  String get errorSttFailed =>
      'Talegjenkjenning er ikke tilgjengelig. Vennligst skriv i stedet.';

  @override
  String get errorPayment =>
      'Det oppstod et problem med betalingen. Prøv igjen i Innstillinger.';

  @override
  String get errorGeneric => 'Noe gikk galt. Prøv igjen senere.';

  @override
  String get offlineNotice =>
      'Du er frakoblet. Noen funksjoner kan være begrenset.';

  @override
  String get retryButton => 'Prøv igjen';

  @override
  String get groupSection => 'Mine grupper';

  @override
  String get createGroup => 'Opprett en bønnegruppe';

  @override
  String get inviteFriends => 'Inviter venner';

  @override
  String get groupInviteMessage =>
      'La oss be sammen! Bli med i bønnegruppen min på Abba.';

  @override
  String get noGroups => 'Bli med eller opprett en gruppe for å be sammen.';

  @override
  String get promoTitle => 'Lanseringstilbud';

  @override
  String get promoBanner => 'Første 3 måneder for 45kr/mnd!';

  @override
  String promoEndsOn(Object date) {
    return 'Tilbudet avsluttes $date';
  }

  @override
  String get proLimitTitle => 'Dagens bønn er fullført';

  @override
  String get proLimitBody => 'Vi ses i morgen!\nBe ubegrenset med Pro';

  @override
  String get laterButton => 'Kanskje senere';

  @override
  String get proPromptTitle => 'Pro-funksjon';

  @override
  String get proPromptBody =>
      'Denne funksjonen er tilgjengelig med Pro.\nVil du se planene våre?';

  @override
  String get viewProducts => 'Se planer';

  @override
  String get maybeLater => 'Kanskje senere';

  @override
  String get proHeadline => 'Nærmere Gud, hver dag';

  @override
  String get proBenefit1 => 'Ubegrenset bønn & stille stund';

  @override
  String get proBenefit2 => 'AI-drevet bønn & veiledning';

  @override
  String get proBenefit3 => 'Troshistorier fra fortiden';

  @override
  String get proBenefit5 => 'Bibelstudium på originalspråk';

  @override
  String get bestValue => 'BEST VERDI';

  @override
  String get perMonth => 'mnd';

  @override
  String get cancelAnytime => 'Avbryt når som helst';

  @override
  String get restorePurchase => 'Gjenopprett kjøp';

  @override
  String get yearlyPriceMonthly => '47 kr/mnd';

  @override
  String get morningPrayerReminder => 'Morgenbønn';

  @override
  String get eveningGratitudeReminder => 'Kveldstakknemlighet';

  @override
  String get streakReminder => 'Rekkepåminnelse';

  @override
  String get afternoonNudgeReminder => 'Ettermiddagsbønn påminnelse';

  @override
  String get weeklySummaryReminder => 'Ukentlig sammendrag';

  @override
  String get unlimited => 'Ubegrenset';

  @override
  String get streakRecovery => 'Det er greit, du kan begynne på nytt 🌱';

  @override
  String get prayerSaved => 'Bønnen er lagret';

  @override
  String get quietTimeLabel => 'Stille stund';

  @override
  String get morningPrayerLabel => 'Morgenbønn';

  @override
  String get gardenSeed => 'Et troens frø';

  @override
  String get gardenSprout => 'Voksende spire';

  @override
  String get gardenBud => 'Blomsterknopp';

  @override
  String get gardenBloom => 'Full blomst';

  @override
  String get gardenTree => 'Sterkt tre';

  @override
  String get gardenForest => 'Bønnens skog';

  @override
  String get milestoneShare => 'Del';

  @override
  String get milestoneThankGod => 'Takk Gud!';

  @override
  String shareStreakText(Object count) {
    return '$count dagers bønnerekke! Min bønnereise med Abba #Abba #Bønn';
  }

  @override
  String get shareDaysLabel => 'dagers bønnerekke';

  @override
  String get shareSubtitle => 'Daglig bønn med Gud';

  @override
  String get proActive => 'Medlemskap Aktivt';

  @override
  String get planOncePerDay => '1 gang/dag';

  @override
  String get planUnlimited => 'Ubegrenset';

  @override
  String get closeRecording => 'Lukk opptak';

  @override
  String get qtRevealMessage => 'La oss åpne dagens Ord';

  @override
  String get qtSelectPrompt => 'Velg et emne og start dagens stille stund';

  @override
  String get qtTopicLabel => 'Emne';

  @override
  String get prayerStartPrompt => 'Start bønnen din';

  @override
  String get startPrayerButton => 'Begynn å be';

  @override
  String get switchToTextMode => 'Skriv i stedet';

  @override
  String get switchToVoiceMode => 'Snakk';

  @override
  String get prayerDashboardTitle => 'Bønnens Hage';

  @override
  String get qtDashboardTitle => 'Stille stundens Hage';

  @override
  String get prayerSummaryTitle => 'Bønnesammendrag';

  @override
  String get gratitudeLabel => 'Takknemlighet';

  @override
  String get petitionLabel => 'Bønnebønn';

  @override
  String get intercessionLabel => 'Forbønn';

  @override
  String get historicalStoryTitle => 'Fortelling fra historien';

  @override
  String get todayLesson => 'Dagens lærdom';

  @override
  String get meditationAnalysisTitle => 'Meditasjonsanalyse';

  @override
  String get keyThemeLabel => 'Nøkkeltema';

  @override
  String get applicationTitle => 'Dagens anvendelse';

  @override
  String get applicationWhat => 'Hva';

  @override
  String get applicationWhen => 'Når';

  @override
  String get applicationContext => 'Hvor';

  @override
  String get relatedKnowledgeTitle => 'Relatert kunnskap';

  @override
  String get originalWordLabel => 'Originalord';

  @override
  String get historicalContextLabel => 'Historisk kontekst';

  @override
  String get crossReferencesLabel => 'Kryssreferanser';

  @override
  String get growthStoryTitle => 'Veksthistorie';

  @override
  String get prayerGuideTitle => 'Hvordan be med Abba';

  @override
  String get prayerGuide1 => 'Be høyt eller med tydelig stemme';

  @override
  String get prayerGuide2 =>
      'Abba lytter til bønnen din og finner skriftsteder som taler til hjertet ditt';

  @override
  String get prayerGuide3 =>
      'Du kan også skrive bønnen din hvis du foretrekker det';

  @override
  String get qtGuideTitle => 'Hvordan ha stille stund med Abba';

  @override
  String get qtGuide1 => 'Les teksten og mediter i stillhet';

  @override
  String get qtGuide2 =>
      'Del hva du oppdaget — si det eller skriv refleksjonen din';

  @override
  String get qtGuide3 => 'Abba hjelper deg å anvende Ordet i hverdagen';

  @override
  String get scriptureReasonLabel => 'Hvorfor dette verset';

  @override
  String get scripturePostureLabel =>
      'Med hvilken innstilling skal jeg lese det?';

  @override
  String get scriptureOriginalWordsTitle => 'Dypere mening på originalspråket';

  @override
  String get originalWordMeaningLabel => 'Mening';

  @override
  String get originalWordNuanceLabel => 'Nyanse vs oversettelse';

  @override
  String originalWordsCountLabel(int count) {
    return '$count ord';
  }

  @override
  String get seeMore => 'Se mer';

  @override
  String seeAllComments(Object count) {
    return 'Se alle $count kommentarer';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name og $count andre likte dette';
  }

  @override
  String get commentsTitle => 'Kommentarer';

  @override
  String get myPageTitle => 'Min Bønnehage';

  @override
  String get myPrayers => 'Mine bønner';

  @override
  String get myTestimonies => 'Mine vitnesbyrd';

  @override
  String get savedPosts => 'Lagrede';

  @override
  String get totalPrayersCount => 'Bønner';

  @override
  String get streakCount => 'Rekke';

  @override
  String get testimoniesCount => 'Vitnesbyrd';

  @override
  String get linkAccountTitle => 'Koble konto';

  @override
  String get linkAccountDescription =>
      'Koble kontoen din for å beholde bønnehistorikk ved bytte av enhet';

  @override
  String get linkWithApple => 'Koble med Apple';

  @override
  String get linkWithGoogle => 'Koble med Google';

  @override
  String get linkAccountSuccess => 'Kontoen ble koblet!';

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
  String get membershipTitle => 'Medlemskap';

  @override
  String get membershipSubtitle => 'Fordyp bønnelivet ditt';

  @override
  String get monthlyPlan => 'Månedlig';

  @override
  String get yearlyPlan => 'Årlig';

  @override
  String get yearlySavings => '32 kr/mnd (40% rabatt)';

  @override
  String get startMembership => 'Start nå';

  @override
  String get membershipActive => 'Medlemskap Aktivt';

  @override
  String get leaveRecordingTitle => 'Forlate opptaket?';

  @override
  String get leaveRecordingMessage =>
      'Opptaket ditt vil gå tapt. Er du sikker?';

  @override
  String get leaveButton => 'Forlat';

  @override
  String get stayButton => 'Bli';

  @override
  String likedByCount(Object count) {
    return '$count personer har vist medfølelse';
  }

  @override
  String get actionLike => 'Liker';

  @override
  String get actionComment => 'Kommentar';

  @override
  String get actionSave => 'Lagre';

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
      '💛 Kjærlighet — Tenk på noen du er glad i i 10 sekunder';

  @override
  String get qtLoadingHint2 => '🌿 Nåde — Husk én liten nåde du fikk i dag';

  @override
  String get qtLoadingHint3 => '🌅 Håp — Se for deg et lite håp for i morgen';

  @override
  String get qtLoadingHint4 => '🕊️ Fred — Ta tre dype, rolige pust';

  @override
  String get qtLoadingHint5 => '🌳 Tro — Husk én uforanderlig sannhet';

  @override
  String get qtLoadingHint6 =>
      '🌸 Takknemlighet — Nevn én ting du er takknemlig for nå';

  @override
  String get qtLoadingHint7 => '🌊 Tilgivelse — Tenk på noen du ønsker å tilgi';

  @override
  String get qtLoadingHint8 => '📖 Visdom — Bevar én lærdom fra i dag';

  @override
  String get qtLoadingHint9 =>
      '⏳ Tålmodighet — Tenk på det du stille venter på';

  @override
  String get qtLoadingHint10 => '✨ Glede — Husk et smil fra i dag';

  @override
  String get qtLoadingTitle => 'Forbereder dagens Ord...';

  @override
  String get coachingTitle => 'Bønnecoaching';

  @override
  String get coachingLoadingText => 'Reflekterer over bønnen din...';

  @override
  String get coachingErrorText => 'Midlertidig feil — prøv igjen';

  @override
  String get coachingRetryButton => 'Prøv igjen';

  @override
  String get coachingScoreSpecificity => 'Konkrethet';

  @override
  String get coachingScoreGodCentered => 'Gudssentrert';

  @override
  String get coachingScoreActs => 'ACTS-balanse';

  @override
  String get coachingScoreAuthenticity => 'Ekthet';

  @override
  String get coachingStrengthsTitle => 'Det du gjorde bra ✨';

  @override
  String get coachingImprovementsTitle => 'For å gå dypere 💡';

  @override
  String get coachingProCta => 'Lås opp Bønnecoaching med Pro';

  @override
  String get coachingLevelBeginner => '🌱 Nybegynner';

  @override
  String get coachingLevelGrowing => '🌿 Voksende';

  @override
  String get coachingLevelExpert => '🌳 Ekspert';
}
