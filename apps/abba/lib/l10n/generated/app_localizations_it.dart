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
  String get testimonyTitle => 'La mia testimonianza';

  @override
  String get testimonyEdit => 'Modifica';

  @override
  String get guidanceTitle => 'Guida IA';

  @override
  String get aiPrayerTitle => 'Una preghiera per te';

  @override
  String get originalLangTitle => 'Lingua originale';

  @override
  String get premiumUnlock => 'Sblocca con Premium';

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
  String get premiumSection => 'Abbonamento';

  @override
  String get freePlan => 'Gratuito';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get monthlyPrice => '7,99€ / mese';

  @override
  String get yearlyPrice => '59,99€ / anno';

  @override
  String get yearlySave => 'Risparmia 40%';

  @override
  String get launchPromo => '3 mesi a 3,99€/mese!';

  @override
  String get startPremium => 'Inizia Premium';

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
  String get premiumLimitTitle => 'La preghiera di oggi è completa';

  @override
  String get premiumLimitBody => 'A domani!\nPrega senza limiti con Premium';

  @override
  String get laterButton => 'Forse dopo';

  @override
  String get premiumPromptTitle => 'Funzione Pro';

  @override
  String get premiumPromptBody =>
      'Questa funzione è disponibile con Pro.\nVuoi vedere i nostri piani?';

  @override
  String get viewProducts => 'Vedi i piani';

  @override
  String get maybeLater => 'Forse dopo';

  @override
  String get premiumHeadline => 'Più vicino a Dio, ogni giorno';

  @override
  String get premiumBenefit1 => 'Preghiera e Tempo con Dio illimitati';

  @override
  String get premiumBenefit2 => 'Preghiera e guida con IA';

  @override
  String get premiumBenefit3 => 'Storie di fede dalla storia';

  @override
  String get premiumBenefit5 => 'Studio biblico in lingua originale';

  @override
  String get bestValue => 'MIGLIOR OFFERTA';

  @override
  String get perMonth => 'mese';

  @override
  String get cancelAnytime => 'Cancella quando vuoi';

  @override
  String get restorePurchase => 'Ripristina acquisto';

  @override
  String get yearlyPriceMonthly => '2,08€/mese';

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
  String get premiumActive => 'Abbonamento Attivo';

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
  String get meditationAnalysisTitle => 'Analisi della meditazione';

  @override
  String get keyThemeLabel => 'Tema chiave';

  @override
  String get applicationTitle => 'Applicazione di oggi';

  @override
  String get applicationWhat => 'Cosa';

  @override
  String get applicationWhen => 'Quando';

  @override
  String get applicationContext => 'Dove';

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
  String get yearlySavings => '5,00€/mese (37% di sconto)';

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
}
