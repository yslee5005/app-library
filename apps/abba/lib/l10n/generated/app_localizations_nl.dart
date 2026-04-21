// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Als je bidt,\nantwoordt God.';

  @override
  String get welcomeSubtitle => 'Je dagelijkse gezel voor gebed & stille tijd';

  @override
  String get getStarted => 'Aan de slag';

  @override
  String get loginTitle => 'Welkom bij Abba';

  @override
  String get loginSubtitle => 'Log in om je gebedsleven te starten';

  @override
  String get signInWithApple => 'Ga verder met Apple';

  @override
  String get signInWithGoogle => 'Ga verder met Google';

  @override
  String get signInWithEmail => 'Ga verder met E-mail';

  @override
  String greetingMorning(Object name) {
    return 'Goedemorgen, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Goedemiddag, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Goedenavond, $name';
  }

  @override
  String get prayButton => 'Bid';

  @override
  String get qtButton => 'Stille Tijd';

  @override
  String streakDays(Object count) {
    return '$count dagen gebedsserie';
  }

  @override
  String get dailyVerse => 'Vers van de dag';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCalendar => 'Kalender';

  @override
  String get tabCommunity => 'Gemeenschap';

  @override
  String get tabSettings => 'Instellingen';

  @override
  String get recordingTitle => 'Bidden...';

  @override
  String get recordingPause => 'Pauzeer';

  @override
  String get recordingResume => 'Hervat';

  @override
  String get finishPrayer => 'Beëindig gebed';

  @override
  String get finishPrayerConfirm => 'Wil je je gebed beëindigen?';

  @override
  String get switchToText => 'Liever typen';

  @override
  String get textInputHint => 'Schrijf je gebed hier...';

  @override
  String get aiLoadingText => 'Overdenken van je gebed...';

  @override
  String get aiLoadingVerse =>
      'Wees stil en weet dat Ik God ben.\n— Psalm 46:11';

  @override
  String get dashboardTitle => 'Gebetstuin';

  @override
  String get shareButton => 'Delen';

  @override
  String get backToHome => 'Terug naar Home';

  @override
  String get scriptureTitle => 'Schrift van vandaag';

  @override
  String get bibleStoryTitle => 'Bijbelverhaal';

  @override
  String get testimonyTitle => 'Mijn getuigenis';

  @override
  String get testimonyEdit => 'Bewerken';

  @override
  String get guidanceTitle => 'AI-begeleiding';

  @override
  String get aiPrayerTitle => 'Een gebed voor jou';

  @override
  String get originalLangTitle => 'Oorspronkelijke taal';

  @override
  String get proUnlock => 'Ontgrendelen met Pro';

  @override
  String get qtPageTitle => 'Ochtenttuin';

  @override
  String get qtMeditateButton => 'Begin meditatie';

  @override
  String get qtCompleted => 'Voltooid';

  @override
  String get communityTitle => 'Gebetstuin';

  @override
  String get filterAll => 'Alles';

  @override
  String get filterTestimony => 'Getuigenis';

  @override
  String get filterPrayerRequest => 'Gebedsverzoek';

  @override
  String get likeButton => 'Vind ik leuk';

  @override
  String get commentButton => 'Reageer';

  @override
  String get saveButton => 'Opslaan';

  @override
  String get replyButton => 'Antwoord';

  @override
  String get writePostTitle => 'Delen';

  @override
  String get cancelButton => 'Annuleer';

  @override
  String get sharePostButton => 'Delen';

  @override
  String get anonymousToggle => 'Anoniem';

  @override
  String get realNameToggle => 'Echte naam';

  @override
  String get categoryTestimony => 'Getuigenis';

  @override
  String get categoryPrayerRequest => 'Gebedsverzoek';

  @override
  String get writePostHint => 'Deel je getuigenis of gebedsverzoek...';

  @override
  String get importFromPrayer => 'Importeer uit gebed';

  @override
  String get calendarTitle => 'Gebedkalender';

  @override
  String get currentStreak => 'Huidige serie';

  @override
  String get bestStreak => 'Beste serie';

  @override
  String get days => 'dagen';

  @override
  String calendarRecordCount(Object count) {
    return '$count registraties';
  }

  @override
  String get todayVerse => 'Vers van vandaag';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get profileSection => 'Profiel';

  @override
  String get totalPrayers => 'Totaal gebeden';

  @override
  String get consecutiveDays => 'Opeenvolgende dagen';

  @override
  String get proSection => 'Lidmaatschap';

  @override
  String get freePlan => 'Gratis';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '€6,99 / maand';

  @override
  String get yearlyPrice => '€49,99 / jaar';

  @override
  String get yearlySave => 'Bespaar 40%';

  @override
  String get launchPromo => '3 maanden voor €3,99/maand!';

  @override
  String get startPro => 'Start Pro';

  @override
  String get comingSoon => 'Binnenkort';

  @override
  String get notificationSetting => 'Meldingen';

  @override
  String get languageSetting => 'Taal';

  @override
  String get darkModeSetting => 'Donkere modus';

  @override
  String get helpCenter => 'Helpcentrum';

  @override
  String get termsOfService => 'Servicevoorwaarden';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get logout => 'Uitloggen';

  @override
  String appVersion(Object version) {
    return 'Versie $version';
  }

  @override
  String get anonymous => 'Anoniem';

  @override
  String timeAgo(Object time) {
    return '$time geleden';
  }

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Wachtwoord';

  @override
  String get signIn => 'Inloggen';

  @override
  String get cancel => 'Annuleer';

  @override
  String get noPrayersRecorded => 'Geen gebeden geregistreerd';

  @override
  String get deletePost => 'Verwijderen';

  @override
  String get reportPost => 'Rapporteren';

  @override
  String get reportSubmitted => 'Rapport verstuurd. Bedankt.';

  @override
  String get reportReasonHint =>
      'Beschrijf de reden voor het rapporteren. Het wordt per e-mail verstuurd.';

  @override
  String get reportReasonPlaceholder => 'Voer de reden voor rapportering in...';

  @override
  String get reportSubmitButton => 'Rapporteren';

  @override
  String get deleteConfirmTitle => 'Bericht verwijderen';

  @override
  String get deleteConfirmMessage =>
      'Weet je zeker dat je dit bericht wilt verwijderen?';

  @override
  String get errorNetwork =>
      'Controleer je internetverbinding en probeer het opnieuw.';

  @override
  String get errorAiFallback =>
      'AI is momenteel niet bereikbaar. Hier is een vers voor je.';

  @override
  String get errorSttFailed =>
      'Spraakherkenning is niet beschikbaar. Typ alsjeblieft.';

  @override
  String get errorPayment =>
      'Er was een probleem met de betaling. Probeer het opnieuw in Instellingen.';

  @override
  String get errorGeneric => 'Er is iets misgegaan. Probeer het later opnieuw.';

  @override
  String get offlineNotice =>
      'Je bent offline. Sommige functies zijn mogelijk beperkt.';

  @override
  String get retryButton => 'Probeer opnieuw';

  @override
  String get groupSection => 'Mijn groepen';

  @override
  String get createGroup => 'Maak een gebedsgroep';

  @override
  String get inviteFriends => 'Nodig vrienden uit';

  @override
  String get groupInviteMessage =>
      'Laten we samen bidden! Doe mee met mijn gebedsgroep op Abba.';

  @override
  String get noGroups => 'Doe mee of maak een groep om samen te bidden.';

  @override
  String get promoTitle => 'Introductieaanbieding';

  @override
  String get promoBanner => 'De eerste 3 maanden voor €3,99/maand!';

  @override
  String promoEndsOn(Object date) {
    return 'Aanbieding eindigt op $date';
  }

  @override
  String get proLimitTitle => 'Het gebed van vandaag is voltooid';

  @override
  String get proLimitBody => 'Tot morgen!\nBid onbeperkt met Pro';

  @override
  String get laterButton => 'Misschien later';

  @override
  String get proPromptTitle => 'Pro-functie';

  @override
  String get proPromptBody =>
      'Deze functie is beschikbaar met Pro.\nWil je onze abonnementen bekijken?';

  @override
  String get viewProducts => 'Bekijk abonnementen';

  @override
  String get maybeLater => 'Misschien later';

  @override
  String get proHeadline => 'Elke dag dichter bij God';

  @override
  String get proBenefit1 => 'Onbeperkt gebed & stille tijd';

  @override
  String get proBenefit2 => 'AI-gestuurde gebed & begeleiding';

  @override
  String get proBenefit3 => 'Geloofsverhalen uit de geschiedenis';

  @override
  String get proBenefit5 => 'Bijbelstudie in de oorspronkelijke taal';

  @override
  String get bestValue => 'BESTE WAARDE';

  @override
  String get perMonth => 'maand';

  @override
  String get cancelAnytime => 'Op elk moment opzegbaar';

  @override
  String get restorePurchase => 'Herstel aankoop';

  @override
  String get yearlyPriceMonthly => '€4,17/maand';

  @override
  String get morningPrayerReminder => 'Ochtendgebed';

  @override
  String get eveningGratitudeReminder => 'Avonddankbaarheid';

  @override
  String get streakReminder => 'Serieherinnering';

  @override
  String get afternoonNudgeReminder => 'Middaggebedherinnering';

  @override
  String get weeklySummaryReminder => 'Wekelijks overzicht';

  @override
  String get unlimited => 'Onbeperkt';

  @override
  String get streakRecovery => 'Geen zorgen, je kunt opnieuw beginnen 🌱';

  @override
  String get prayerSaved => 'Gebed succesvol opgeslagen';

  @override
  String get quietTimeLabel => 'Stille Tijd';

  @override
  String get morningPrayerLabel => 'Ochtendgebed';

  @override
  String get gardenSeed => 'Een zaadje van geloof';

  @override
  String get gardenSprout => 'Groeiende spruit';

  @override
  String get gardenBud => 'Ontluikende knop';

  @override
  String get gardenBloom => 'Volle bloei';

  @override
  String get gardenTree => 'Sterke boom';

  @override
  String get gardenForest => 'Gebedswoud';

  @override
  String get milestoneShare => 'Delen';

  @override
  String get milestoneThankGod => 'God zij dank!';

  @override
  String shareStreakText(Object count) {
    return '$count dagen gebedsserie! Mijn gebedsreis met Abba #Abba #Gebed';
  }

  @override
  String get shareDaysLabel => 'dagen gebedsserie';

  @override
  String get shareSubtitle => 'Dagelijks gebed met God';

  @override
  String get proActive => 'Lidmaatschap Actief';

  @override
  String get planOncePerDay => '1x/dag';

  @override
  String get planUnlimited => 'Onbeperkt';

  @override
  String get closeRecording => 'Opname sluiten';

  @override
  String get qtRevealMessage => 'Laten we het Woord van vandaag openen';

  @override
  String get qtSelectPrompt =>
      'Kies er een en begin de stille tijd van vandaag';

  @override
  String get qtTopicLabel => 'Onderwerp';

  @override
  String get prayerStartPrompt => 'Begin je gebed';

  @override
  String get startPrayerButton => 'Begin met bidden';

  @override
  String get switchToTextMode => 'Liever typen';

  @override
  String get switchToVoiceMode => 'Spreken';

  @override
  String get prayerDashboardTitle => 'Gebetstuin';

  @override
  String get qtDashboardTitle => 'Stille Tijd-tuin';

  @override
  String get prayerSummaryTitle => 'Gebedsoverzicht';

  @override
  String get gratitudeLabel => 'Dankbaarheid';

  @override
  String get petitionLabel => 'Smeekbede';

  @override
  String get intercessionLabel => 'Voorbede';

  @override
  String get historicalStoryTitle => 'Verhaal uit de geschiedenis';

  @override
  String get todayLesson => 'Les van vandaag';

  @override
  String get meditationAnalysisTitle => 'Meditatie-analyse';

  @override
  String get keyThemeLabel => 'Kernthema';

  @override
  String get applicationTitle => 'Toepassing van vandaag';

  @override
  String get applicationWhat => 'Wat';

  @override
  String get applicationWhen => 'Wanneer';

  @override
  String get applicationContext => 'Waar';

  @override
  String get relatedKnowledgeTitle => 'Gerelateerde kennis';

  @override
  String get originalWordLabel => 'Origineel woord';

  @override
  String get historicalContextLabel => 'Historische context';

  @override
  String get crossReferencesLabel => 'Kruisverwijzingen';

  @override
  String get growthStoryTitle => 'Groeiverhaal';

  @override
  String get prayerGuideTitle => 'Hoe bid je met Abba';

  @override
  String get prayerGuide1 => 'Bid hardop of met een duidelijke stem';

  @override
  String get prayerGuide2 =>
      'Abba luistert naar je woorden en vindt Schrift die tot je hart spreekt';

  @override
  String get prayerGuide3 => 'Je kunt je gebed ook typen';

  @override
  String get qtGuideTitle => 'Hoe doe je stille tijd met Abba';

  @override
  String get qtGuide1 => 'Lees de passage en mediteer in stilte';

  @override
  String get qtGuide2 =>
      'Deel wat je hebt ontdekt — spreek of typ je reflectie';

  @override
  String get qtGuide3 =>
      'Abba helpt je het Woord toe te passen in je dagelijks leven';

  @override
  String get scriptureReasonLabel => 'Waarom deze Schrift';

  @override
  String get seeMore => 'Meer bekijken';

  @override
  String seeAllComments(Object count) {
    return 'Bekijk alle $count reacties';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name en $count anderen vinden dit leuk';
  }

  @override
  String get commentsTitle => 'Reacties';

  @override
  String get myPageTitle => 'Mijn gebetstuin';

  @override
  String get myPrayers => 'Mijn gebeden';

  @override
  String get myTestimonies => 'Mijn getuigenissen';

  @override
  String get savedPosts => 'Opgeslagen';

  @override
  String get totalPrayersCount => 'Gebeden';

  @override
  String get streakCount => 'Serie';

  @override
  String get testimoniesCount => 'Getuigenissen';

  @override
  String get linkAccountTitle => 'Account koppelen';

  @override
  String get linkAccountDescription =>
      'Koppel je account om gebedregistraties te bewaren bij het wisselen van apparaat';

  @override
  String get linkWithApple => 'Koppelen met Apple';

  @override
  String get linkWithGoogle => 'Koppelen met Google';

  @override
  String get linkAccountSuccess => 'Account succesvol gekoppeld!';

  @override
  String get anonymousUser => 'Gebedsstrijder';

  @override
  String showReplies(Object count) {
    return 'Bekijk $count antwoorden';
  }

  @override
  String get hideReplies => 'Verberg antwoorden';

  @override
  String replyingTo(Object name) {
    return 'Antwoord aan $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Bekijk alle $count reacties';
  }

  @override
  String get membershipTitle => 'Lidmaatschap';

  @override
  String get membershipSubtitle => 'Verdiep je gebedsleven';

  @override
  String get monthlyPlan => 'Maandelijks';

  @override
  String get yearlyPlan => 'Jaarlijks';

  @override
  String get yearlySavings => '€4,17/maand (40% korting)';

  @override
  String get startMembership => 'Begin nu';

  @override
  String get membershipActive => 'Lidmaatschap Actief';

  @override
  String get leaveRecordingTitle => 'Opname verlaten?';

  @override
  String get leaveRecordingMessage =>
      'Je opname gaat verloren. Weet je het zeker?';

  @override
  String get leaveButton => 'Verlaten';

  @override
  String get stayButton => 'Blijven';

  @override
  String likedByCount(Object count) {
    return '$count mensen leefden mee';
  }

  @override
  String get actionLike => 'Leuk';

  @override
  String get actionComment => 'Reageer';

  @override
  String get actionSave => 'Opslaan';

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
}
