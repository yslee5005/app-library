// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Quando preghi,\nDio risponde.';

  @override
  String get welcomeSubtitle =>
      'Il tuo compagno quotidiano per la preghiera e il tempo con Dio';

  @override
  String get getStarted => 'Inizia';

  @override
  String get loginTitle => 'Benvenuto su Abba';

  @override
  String get loginSubtitle => 'Accedi per iniziare il tuo cammino di preghiera';

  @override
  String get signInWithApple => 'Continua con Apple';

  @override
  String get signInWithGoogle => 'Continua con Google';

  @override
  String get signInWithEmail => 'Continua con Email';

  @override
  String greetingMorning(Object name) {
    return 'Buongiorno, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Buon pomeriggio, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Buonasera, $name';
  }

  @override
  String get prayButton => 'Prega';

  @override
  String get qtButton => 'Tempo con Dio';

  @override
  String streakDays(Object count) {
    return '$count giorni di preghiera consecutivi';
  }

  @override
  String get dailyVerse => 'Versetto del giorno';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCalendar => 'Calendario';

  @override
  String get tabCommunity => 'Comunità';

  @override
  String get tabSettings => 'Impostazioni';

  @override
  String get recordingTitle => 'Pregando...';

  @override
  String get recordingPause => 'Pausa';

  @override
  String get recordingResume => 'Riprendi';

  @override
  String get finishPrayer => 'Termina preghiera';

  @override
  String get finishPrayerConfirm => 'Vuoi terminare la preghiera?';

  @override
  String get switchToText => 'Scrivi invece';

  @override
  String get textInputHint => 'Scrivi la tua preghiera qui...';

  @override
  String get aiLoadingText => 'Riflettendo sulla tua preghiera...';

  @override
  String get aiLoadingVerse =>
      'Fermatevi e riconoscete che io sono Dio.\n— Salmo 46:10';

  @override
  String get dashboardTitle => 'Giardino di preghiera';

  @override
  String get shareButton => 'Condividi';

  @override
  String get backToHome => 'Torna alla Home';

  @override
  String get scriptureTitle => 'Scrittura di oggi';

  @override
  String get bibleStoryTitle => 'Racconto biblico';

  @override
  String get testimonyTitle => 'Testimonianza · La mia preghiera';

  @override
  String get testimonyHelperText =>
      'Rifletti sulla tua preghiera · puoi condividere con la comunità';

  @override
  String get myPrayerAudioLabel => 'Registrazione della mia preghiera';

  @override
  String get testimonyEdit => 'Modifica';

  @override
  String get guidanceTitle => 'Guida IA';

  @override
  String get aiPrayerTitle => 'Una preghiera per te';

  @override
  String get originalLangTitle => 'Lingua originale';

  @override
  String get proUnlock => 'Sblocca con Pro';

  @override
  String get qtPageTitle => 'Giardino mattutino';

  @override
  String get qtMeditateButton => 'Inizia meditazione';

  @override
  String get qtCompleted => 'Completato';

  @override
  String get communityTitle => 'Giardino di preghiera';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterTestimony => 'Testimonianza';

  @override
  String get filterPrayerRequest => 'Richiesta di preghiera';

  @override
  String get likeButton => 'Mi piace';

  @override
  String get commentButton => 'Commenta';

  @override
  String get saveButton => 'Salva';

  @override
  String get replyButton => 'Rispondi';

  @override
  String get writePostTitle => 'Condividi';

  @override
  String get cancelButton => 'Annulla';

  @override
  String get sharePostButton => 'Condividi';

  @override
  String get anonymousToggle => 'Anonimo';

  @override
  String get realNameToggle => 'Nome reale';

  @override
  String get categoryTestimony => 'Testimonianza';

  @override
  String get categoryPrayerRequest => 'Richiesta di preghiera';

  @override
  String get writePostHint =>
      'Condividi la tua testimonianza o richiesta di preghiera...';

  @override
  String get importFromPrayer => 'Importa dalla preghiera';

  @override
  String get calendarTitle => 'Calendario di preghiera';

  @override
  String get currentStreak => 'Serie attuale';

  @override
  String get bestStreak => 'Miglior serie';

  @override
  String get days => 'giorni';

  @override
  String calendarRecordCount(Object count) {
    return '$count registrazioni';
  }

  @override
  String get todayVerse => 'Versetto di oggi';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get profileSection => 'Profilo';

  @override
  String get totalPrayers => 'Preghiere totali';

  @override
  String get consecutiveDays => 'Giorni consecutivi';

  @override
  String get proSection => 'Abbonamento';

  @override
  String get freePlan => 'Gratuito';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '6,99€ / mese';

  @override
  String get yearlyPrice => '49,99€ / anno';

  @override
  String get yearlySave => 'Risparmia 40%';

  @override
  String get launchPromo => '3 mesi a 3,99€/mese!';

  @override
  String get startPro => 'Inizia Pro';

  @override
  String get comingSoon => 'Prossimamente';

  @override
  String get notificationSetting => 'Notifiche';

  @override
  String get languageSetting => 'Lingua';

  @override
  String get darkModeSetting => 'Modalità scura';

  @override
  String get helpCenter => 'Centro assistenza';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get logout => 'Esci';

  @override
  String appVersion(Object version) {
    return 'Versione $version';
  }

  @override
  String get anonymous => 'Anonimo';

  @override
  String timeAgo(Object time) {
    return '$time fa';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signIn => 'Accedi';

  @override
  String get cancel => 'Annulla';

  @override
  String get noPrayersRecorded => 'Nessuna preghiera registrata';

  @override
  String get deletePost => 'Elimina';

  @override
  String get reportPost => 'Segnala';

  @override
  String get reportSubmitted => 'Segnalazione inviata. Grazie.';

  @override
  String get reportReasonHint =>
      'Descrivi il motivo della segnalazione. Verrà inviata via email.';

  @override
  String get reportReasonPlaceholder =>
      'Inserisci il motivo della segnalazione...';

  @override
  String get reportSubmitButton => 'Segnala';

  @override
  String get deleteConfirmTitle => 'Elimina post';

  @override
  String get deleteConfirmMessage =>
      'Sei sicuro di voler eliminare questo post?';

  @override
  String get errorNetwork => 'Controlla la connessione internet e riprova.';

  @override
  String get errorAiFallback =>
      'L\'IA non è raggiungibile al momento. Ecco un versetto per te.';

  @override
  String get errorSttFailed =>
      'Il riconoscimento vocale non è disponibile. Scrivi invece.';

  @override
  String get errorPayment =>
      'Si è verificato un problema con il pagamento. Riprova nelle Impostazioni.';

  @override
  String get errorGeneric => 'Qualcosa è andato storto. Riprova più tardi.';

  @override
  String get offlineNotice =>
      'Sei offline. Alcune funzioni potrebbero essere limitate.';

  @override
  String get retryButton => 'Riprova';

  @override
  String get groupSection => 'I miei gruppi';

  @override
  String get createGroup => 'Crea un gruppo di preghiera';

  @override
  String get inviteFriends => 'Invita amici';

  @override
  String get groupInviteMessage =>
      'Preghiamo insieme! Unisciti al mio gruppo di preghiera su Abba.';

  @override
  String get noGroups => 'Unisciti o crea un gruppo per pregare insieme.';

  @override
  String get promoTitle => 'Offerta di lancio';

  @override
  String get promoBanner => 'I primi 3 mesi a 3,99€/mese!';

  @override
  String promoEndsOn(Object date) {
    return 'L\'offerta scade il $date';
  }

  @override
  String get proLimitTitle => 'La preghiera di oggi è completa';

  @override
  String get proLimitBody => 'A domani!\nPrega senza limiti con Pro';

  @override
  String get laterButton => 'Forse dopo';

  @override
  String get proPromptTitle => 'Funzione Pro';

  @override
  String get proPromptBody =>
      'Questa funzione è disponibile con Pro.\nVuoi vedere i nostri piani?';

  @override
  String get viewProducts => 'Vedi i piani';

  @override
  String get maybeLater => 'Forse dopo';

  @override
  String get proHeadline => 'Più vicino a Dio, ogni giorno';

  @override
  String get proBenefit1 => 'Preghiera e Tempo con Dio illimitati';

  @override
  String get proBenefit2 => 'Preghiera e guida con IA';

  @override
  String get proBenefit3 => 'Storie di fede dalla storia';

  @override
  String get proBenefit5 => 'Studio biblico in lingua originale';

  @override
  String get bestValue => 'MIGLIOR OFFERTA';

  @override
  String get perMonth => 'mese';

  @override
  String get cancelAnytime => 'Cancella quando vuoi';

  @override
  String get restorePurchase => 'Ripristina acquisto';

  @override
  String get yearlyPriceMonthly => '4,17€/mese';

  @override
  String get morningPrayerReminder => 'Preghiera del mattino';

  @override
  String get eveningGratitudeReminder => 'Gratitudine serale';

  @override
  String get streakReminder => 'Promemoria serie';

  @override
  String get afternoonNudgeReminder => 'Promemoria preghiera pomeridiana';

  @override
  String get weeklySummaryReminder => 'Riepilogo settimanale';

  @override
  String get unlimited => 'Illimitato';

  @override
  String get streakRecovery => 'Non preoccuparti, puoi ricominciare 🌱';

  @override
  String get prayerSaved => 'Preghiera salvata con successo';

  @override
  String get quietTimeLabel => 'Tempo con Dio';

  @override
  String get morningPrayerLabel => 'Preghiera del mattino';

  @override
  String get gardenSeed => 'Un seme di fede';

  @override
  String get gardenSprout => 'Germoglio in crescita';

  @override
  String get gardenBud => 'Bocciolo in fiore';

  @override
  String get gardenBloom => 'Piena fioritura';

  @override
  String get gardenTree => 'Albero forte';

  @override
  String get gardenForest => 'Foresta di preghiera';

  @override
  String get milestoneShare => 'Condividi';

  @override
  String get milestoneThankGod => 'Grazie a Dio!';

  @override
  String shareStreakText(Object count) {
    return '$count giorni di preghiera consecutivi! Il mio cammino di preghiera con Abba #Abba #Preghiera';
  }

  @override
  String get shareDaysLabel => 'giorni di preghiera consecutivi';

  @override
  String get shareSubtitle => 'Preghiera quotidiana con Dio';

  @override
  String get proActive => 'Abbonamento Attivo';

  @override
  String get planOncePerDay => '1x/giorno';

  @override
  String get planUnlimited => 'Illimitato';

  @override
  String get closeRecording => 'Chiudi registrazione';

  @override
  String get qtRevealMessage => 'Apriamo la Parola di oggi';

  @override
  String get qtSelectPrompt => 'Scegline uno e inizia il Tempo con Dio di oggi';

  @override
  String get qtTopicLabel => 'Tema';

  @override
  String get prayerStartPrompt => 'Inizia la tua preghiera';

  @override
  String get startPrayerButton => 'Inizia a pregare';

  @override
  String get switchToTextMode => 'Scrivi invece';

  @override
  String get switchToVoiceMode => 'Parla';

  @override
  String get prayerDashboardTitle => 'Giardino di preghiera';

  @override
  String get qtDashboardTitle => 'Giardino del Tempo con Dio';

  @override
  String get prayerSummaryTitle => 'Riepilogo preghiera';

  @override
  String get gratitudeLabel => 'Gratitudine';

  @override
  String get petitionLabel => 'Supplica';

  @override
  String get intercessionLabel => 'Intercessione';

  @override
  String get historicalStoryTitle => 'Racconto dalla storia';

  @override
  String get todayLesson => 'Lezione di oggi';

  @override
  String get applicationTitle => 'Applicazione di oggi';

  @override
  String get applicationWhat => 'Cosa';

  @override
  String get applicationWhen => 'Quando';

  @override
  String get applicationContext => 'Dove';

  @override
  String get applicationMorningLabel => 'Mattina';

  @override
  String get applicationDayLabel => 'Giorno';

  @override
  String get applicationEveningLabel => 'Sera';

  @override
  String get relatedKnowledgeTitle => 'Approfondimenti';

  @override
  String get originalWordLabel => 'Parola originale';

  @override
  String get historicalContextLabel => 'Contesto storico';

  @override
  String get crossReferencesLabel => 'Riferimenti incrociati';

  @override
  String get growthStoryTitle => 'Storia di crescita';

  @override
  String get prayerGuideTitle => 'Come pregare con Abba';

  @override
  String get prayerGuide1 => 'Prega ad alta voce o con voce chiara';

  @override
  String get prayerGuide2 =>
      'Abba ascolta le tue parole e trova le Scritture che parlano al tuo cuore';

  @override
  String get prayerGuide3 => 'Puoi anche scrivere la tua preghiera';

  @override
  String get qtGuideTitle => 'Come fare il Tempo con Dio con Abba';

  @override
  String get qtGuide1 => 'Leggi il brano e medita in silenzio';

  @override
  String get qtGuide2 =>
      'Condividi ciò che hai scoperto — parla o scrivi la tua riflessione';

  @override
  String get qtGuide3 =>
      'Abba ti aiuterà ad applicare la Parola alla tua vita quotidiana';

  @override
  String get scriptureReasonLabel => 'Perché questa Scrittura';

  @override
  String get scripturePostureLabel => 'Con che atteggiamento dovrei leggerlo?';

  @override
  String get scriptureOriginalWordsTitle =>
      'Significato più profondo nella lingua originale';

  @override
  String get originalWordMeaningLabel => 'Significato';

  @override
  String get originalWordNuanceLabel => 'Sfumatura vs traduzione';

  @override
  String originalWordsCountLabel(int count) {
    return '$count parole';
  }

  @override
  String get seeMore => 'Vedi altro';

  @override
  String seeAllComments(Object count) {
    return 'Vedi tutti i $count commenti';
  }

  @override
  String likedBy(Object name, Object count) {
    return 'Piace a $name e ad altri $count';
  }

  @override
  String get commentsTitle => 'Commenti';

  @override
  String get myPageTitle => 'Il mio giardino di preghiera';

  @override
  String get myPrayers => 'Le mie preghiere';

  @override
  String get myTestimonies => 'Le mie testimonianze';

  @override
  String get savedPosts => 'Salvati';

  @override
  String get totalPrayersCount => 'Preghiere';

  @override
  String get streakCount => 'Serie';

  @override
  String get testimoniesCount => 'Testimonianze';

  @override
  String get linkAccountTitle => 'Collega account';

  @override
  String get linkAccountDescription =>
      'Collega il tuo account per mantenere le registrazioni di preghiera quando cambi dispositivo';

  @override
  String get linkWithApple => 'Collega con Apple';

  @override
  String get linkWithGoogle => 'Collega con Google';

  @override
  String get linkAccountSuccess => 'Account collegato con successo!';

  @override
  String get anonymousUser => 'Guerriero di preghiera';

  @override
  String showReplies(Object count) {
    return 'Vedi $count risposte';
  }

  @override
  String get hideReplies => 'Nascondi risposte';

  @override
  String replyingTo(Object name) {
    return 'Rispondendo a $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Vedi tutti i $count commenti';
  }

  @override
  String get membershipTitle => 'Abbonamento';

  @override
  String get membershipSubtitle => 'Approfondisci la tua vita di preghiera';

  @override
  String get monthlyPlan => 'Mensile';

  @override
  String get yearlyPlan => 'Annuale';

  @override
  String get yearlySavings => '4,17€/mese (40% di sconto)';

  @override
  String get startMembership => 'Inizia ora';

  @override
  String get membershipActive => 'Abbonamento Attivo';

  @override
  String get leaveRecordingTitle => 'Uscire dalla registrazione?';

  @override
  String get leaveRecordingMessage =>
      'La registrazione andrà persa. Sei sicuro?';

  @override
  String get leaveButton => 'Esci';

  @override
  String get stayButton => 'Resta';

  @override
  String likedByCount(Object count) {
    return '$count persone hanno empatizzato';
  }

  @override
  String get actionLike => 'Mi piace';

  @override
  String get actionComment => 'Commenta';

  @override
  String get actionSave => 'Salva';

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
  String get billingIssueTitle => 'Problema di pagamento rilevato';

  @override
  String billingIssueBody(int days) {
    return 'I tuoi vantaggi Pro termineranno tra $days giorni se non aggiorni il pagamento.';
  }

  @override
  String get billingIssueAction => 'Aggiorna pagamento';

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
      '💛 Amore — Pensa a qualcuno che ami per 10 secondi';

  @override
  String get qtLoadingHint2 =>
      '🌿 Grazia — Ricorda una piccola grazia ricevuta oggi';

  @override
  String get qtLoadingHint3 =>
      '🌅 Speranza — Immagina una piccola speranza per domani';

  @override
  String get qtLoadingHint4 => '🕊️ Pace — Fai tre respiri lenti e profondi';

  @override
  String get qtLoadingHint5 => '🌳 Fede — Ricorda una verità immutabile';

  @override
  String get qtLoadingHint6 =>
      '🌸 Gratitudine — Nomina qualcosa di cui sei grato ora';

  @override
  String get qtLoadingHint7 => '🌊 Perdono — Pensa a qualcuno da perdonare';

  @override
  String get qtLoadingHint8 => '📖 Saggezza — Custodisci una lezione di oggi';

  @override
  String get qtLoadingHint9 =>
      '⏳ Pazienza — Pensa a ciò che stai aspettando in silenzio';

  @override
  String get qtLoadingHint10 => '✨ Gioia — Ricorda un sorriso di oggi';

  @override
  String get qtLoadingTitle => 'Preparando la Parola di oggi...';

  @override
  String get coachingTitle => 'Coaching di preghiera';

  @override
  String get coachingLoadingText => 'Stiamo riflettendo sulla tua preghiera...';

  @override
  String get coachingErrorText => 'Errore temporaneo — riprova';

  @override
  String get coachingRetryButton => 'Riprova';

  @override
  String get coachingScoreSpecificity => 'Specificità';

  @override
  String get coachingScoreGodCentered => 'Centrato su Dio';

  @override
  String get coachingScoreActs => 'Equilibrio ACTS';

  @override
  String get coachingScoreAuthenticity => 'Autenticità';

  @override
  String get coachingStrengthsTitle => 'Cosa hai fatto bene ✨';

  @override
  String get coachingImprovementsTitle => 'Per approfondire 💡';

  @override
  String get coachingProCta => 'Sblocca il Coaching con Pro';

  @override
  String get coachingLevelBeginner => '🌱 Principiante';

  @override
  String get coachingLevelGrowing => '🌿 In crescita';

  @override
  String get coachingLevelExpert => '🌳 Esperto';

  @override
  String get aiPrayerCitationsTitle => 'Riferimenti · Citazioni';

  @override
  String get citationTypeQuote => 'Citazione';

  @override
  String get citationTypeScience => 'Studio';

  @override
  String get citationTypeExample => 'Esempio';

  @override
  String get citationTypeHistory => 'Storia';

  @override
  String get aiPrayerReadingTime => 'Lettura di 2 minuti';

  @override
  String get scriptureKeyWordHintTitle => 'Parola chiave di oggi';

  @override
  String get bibleLookupReferenceHint =>
      'Trova questo passo nella tua Bibbia e meditalo.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Traduzioni della Bibbia';

  @override
  String get settingsBibleTranslationsIntro =>
      'I versetti biblici in questa app provengono da traduzioni di dominio pubblico. I commenti, le preghiere e le storie generati dall\'IA sono opera creativa di Abba.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'Coaching QT';

  @override
  String get qtCoachingLoadingText =>
      'Stiamo riflettendo sulla tua meditazione...';

  @override
  String get qtCoachingErrorText => 'Errore temporaneo — riprova';

  @override
  String get qtCoachingRetryButton => 'Riprova';

  @override
  String get qtCoachingScoreComprehension => 'Comprensione del testo';

  @override
  String get qtCoachingScoreApplication => 'Applicazione personale';

  @override
  String get qtCoachingScoreDepth => 'Profondità spirituale';

  @override
  String get qtCoachingScoreAuthenticity => 'Autenticità';

  @override
  String get qtCoachingStrengthsTitle => 'Cosa hai fatto bene ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Per approfondire 💡';

  @override
  String get qtCoachingProCta => 'Sblocca il Coaching QT con Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Principiante';

  @override
  String get qtCoachingLevelGrowing => '🌿 In crescita';

  @override
  String get qtCoachingLevelExpert => '🌳 Esperto';

  @override
  String get notifyMorning1Title => '🙏 È ora di pregare';

  @override
  String notifyMorning1Body(String name) {
    return '$name, parla con Dio anche oggi';
  }

  @override
  String get notifyMorning2Title => '🌅 È arrivato un nuovo mattino';

  @override
  String notifyMorning2Body(String name) {
    return '$name, inizia la giornata con gratitudine';
  }

  @override
  String get notifyMorning3Title => '✨ La grazia di oggi';

  @override
  String notifyMorning3Body(String name) {
    return '$name, incontra la grazia che Dio ha preparato';
  }

  @override
  String get notifyMorning4Title => '🕊️ Mattina di pace';

  @override
  String notifyMorning4Body(String name) {
    return '$name, riempi il cuore di pace con la preghiera';
  }

  @override
  String get notifyMorning5Title => '📖 Con la Parola';

  @override
  String notifyMorning5Body(String name) {
    return '$name, ascolta la voce di Dio oggi';
  }

  @override
  String get notifyMorning6Title => '🌿 Tempo di riposo';

  @override
  String notifyMorning6Body(String name) {
    return '$name, fermati un momento e prega';
  }

  @override
  String get notifyMorning7Title => '💫 Anche oggi';

  @override
  String notifyMorning7Body(String name) {
    return '$name, una giornata che inizia con la preghiera è diversa';
  }

  @override
  String get notifyEvening1Title => '✨ Grato per oggi';

  @override
  String get notifyEvening1Body =>
      'Ripercorri la giornata e offri una preghiera di ringraziamento';

  @override
  String get notifyEvening2Title => '🌙 Chiudendo la giornata';

  @override
  String get notifyEvening2Body =>
      'Esprimi la gratitudine di oggi con la preghiera';

  @override
  String get notifyEvening3Title => '🙏 Preghiera della sera';

  @override
  String get notifyEvening3Body => 'Alla fine del giorno, rendi grazie a Dio';

  @override
  String get notifyEvening4Title => '🌟 Contando le benedizioni di oggi';

  @override
  String get notifyEvening4Body =>
      'Se hai qualcosa per cui essere grato, condividilo in preghiera';

  @override
  String get notifyStreak3Title => '🌱 3 giorni di fila!';

  @override
  String get notifyStreak3Body => 'La tua abitudine di pregare è iniziata';

  @override
  String get notifyStreak7Title => '🌿 Un\'intera settimana!';

  @override
  String get notifyStreak7Body => 'La preghiera sta diventando un\'abitudine';

  @override
  String get notifyStreak14Title => '🌳 2 settimane di fila!';

  @override
  String get notifyStreak14Body => 'Una crescita incredibile!';

  @override
  String get notifyStreak21Title => '🌻 3 settimane di fila!';

  @override
  String get notifyStreak21Body => 'Il fiore della preghiera sta sbocciando';

  @override
  String get notifyStreak30Title => '🏆 Un mese intero!';

  @override
  String get notifyStreak30Body => 'La tua preghiera risplende';

  @override
  String get notifyStreak50Title => '👑 50 giorni di fila!';

  @override
  String get notifyStreak50Body =>
      'Il tuo cammino con Dio si sta approfondendo';

  @override
  String get notifyStreak100Title => '🎉 100 giorni di fila!';

  @override
  String get notifyStreak100Body =>
      'Sei diventato un guerriero della preghiera!';

  @override
  String get notifyStreak365Title => '✝️ Un intero anno!';

  @override
  String get notifyStreak365Body => 'Che viaggio di fede incredibile!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ Hai già pregato oggi?';

  @override
  String get notifyAfternoonNudgeBody =>
      'Una breve preghiera può cambiare la giornata';

  @override
  String get notifyChannelName => 'Promemoria di preghiera';

  @override
  String get notifyChannelDescription =>
      'Preghiera del mattino, gratitudine serale e altri promemoria';

  @override
  String get milestoneFirstPrayerTitle => 'Prima preghiera!';

  @override
  String get milestoneFirstPrayerDesc =>
      'Il tuo viaggio di preghiera è iniziato. Dio sta ascoltando.';

  @override
  String get milestoneSevenDayStreakTitle => '7 giorni di preghiera!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'Una settimana di preghiera fedele. Il tuo giardino sta crescendo!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 giorni!';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'Il tuo giardino è fiorito in un campo di fiori!';

  @override
  String get milestoneHundredPrayersTitle => '100ª preghiera!';

  @override
  String get milestoneHundredPrayersDesc =>
      'Cento conversazioni con Dio. Sei profondamente radicato.';

  @override
  String get homeFirstPrayerPrompt => 'Inizia la tua prima preghiera';

  @override
  String get homeFirstQtPrompt => 'Inizia il tuo primo QT';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Anche oggi fai $activityName';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'Giorno $count continuo di $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'Sono passati $days giorni dall\'ultimo $activityName';
  }

  @override
  String get homeActivityPrayer => 'preghiera';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Caricamento...';

  @override
  String get heatmapNoPrayer => 'Nessuna preghiera';

  @override
  String get heatmapLegendLess => 'Meno';

  @override
  String get heatmapLegendMore => 'Più';

  @override
  String get qtPassagesLoadError =>
      'Non è stato possibile caricare i passi di oggi. Controlla la connessione.';

  @override
  String get qtPassagesRetryButton => 'Riprova';
}
