// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Când te rogi,\nDumnezeu răspunde.';

  @override
  String get welcomeSubtitle =>
      'Însoțitorul tău zilnic pentru rugăciune și timp liniștit cu Dumnezeu';

  @override
  String get getStarted => 'Începe';

  @override
  String get loginTitle => 'Bine ai venit în Abba';

  @override
  String get loginSubtitle =>
      'Conectează-te pentru a-ți începe călătoria de rugăciune';

  @override
  String get signInWithApple => 'Continuă cu Apple';

  @override
  String get signInWithGoogle => 'Continuă cu Google';

  @override
  String get signInWithEmail => 'Continuă cu Email';

  @override
  String greetingMorning(Object name) {
    return 'Bună dimineața, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Bună ziua, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Bună seara, $name';
  }

  @override
  String get prayButton => 'Roagă-te';

  @override
  String get qtButton => 'Timp liniștit';

  @override
  String streakDays(Object count) {
    return '$count zile de rugăciune continuă';
  }

  @override
  String get dailyVerse => 'Versetul zilei';

  @override
  String get tabHome => 'Acasă';

  @override
  String get tabCalendar => 'Calendar';

  @override
  String get tabCommunity => 'Comunitate';

  @override
  String get tabSettings => 'Setări';

  @override
  String get recordingTitle => 'Rugăciune...';

  @override
  String get recordingPause => 'Pauză';

  @override
  String get recordingResume => 'Reia';

  @override
  String get finishPrayer => 'Încheie rugăciunea';

  @override
  String get finishPrayerConfirm => 'Dorești să închei rugăciunea?';

  @override
  String get switchToText => 'Scrie în schimb';

  @override
  String get textInputHint => 'Scrie rugăciunea ta aici...';

  @override
  String get aiLoadingText => 'Meditez la rugăciunea ta...';

  @override
  String get aiLoadingVerse =>
      'Opriți-vă și cunoașteți că Eu sunt Dumnezeu.\n— Psalmul 46:10';

  @override
  String get aiErrorNetworkTitle => 'Connection unstable';

  @override
  String get aiErrorNetworkBody =>
      'Your prayer is safely saved. Please try again in a moment.';

  @override
  String get aiErrorApiTitle => 'AI service is unstable';

  @override
  String get aiErrorApiBody =>
      'Your prayer is safely saved. Please try again in a moment.';

  @override
  String get aiErrorRetry => 'Try again';

  @override
  String get aiErrorWaitAndCheck =>
      'We\'ll try the analysis again later. Please come back soon — your prayer will be waiting.';

  @override
  String get aiErrorHome => 'Back to home';

  @override
  String get dashboardTitle => 'Grădina rugăciunii';

  @override
  String get shareButton => 'Distribuie';

  @override
  String get backToHome => 'Înapoi acasă';

  @override
  String get scriptureTitle => 'Scriptura de azi';

  @override
  String get bibleStoryTitle => 'Poveste biblică';

  @override
  String get testimonyTitle => 'Mărturie · Rugăciunea mea';

  @override
  String get testimonyHelperText =>
      'Reflectă asupra rugăciunii · se poate distribui în comunitate';

  @override
  String get myPrayerAudioLabel => 'Înregistrarea rugăciunii mele';

  @override
  String get testimonyEdit => 'Editează';

  @override
  String get guidanceTitle => 'Îndrumare IA';

  @override
  String get aiPrayerTitle => 'O rugăciune pentru tine';

  @override
  String get originalLangTitle => 'Limba originală';

  @override
  String get proUnlock => 'Deblochează cu Pro';

  @override
  String get qtPageTitle => 'Grădina dimineții';

  @override
  String get qtMeditateButton => 'Începe meditația';

  @override
  String get qtCompleted => 'Finalizat';

  @override
  String get communityTitle => 'Grădina rugăciunii';

  @override
  String get filterAll => 'Toate';

  @override
  String get filterTestimony => 'Mărturie';

  @override
  String get filterPrayerRequest => 'Cerere de rugăciune';

  @override
  String get likeButton => 'Apreciez';

  @override
  String get commentButton => 'Comentariu';

  @override
  String get saveButton => 'Salvează';

  @override
  String get replyButton => 'Răspunde';

  @override
  String get writePostTitle => 'Distribuie';

  @override
  String get cancelButton => 'Anulează';

  @override
  String get sharePostButton => 'Distribuie';

  @override
  String get anonymousToggle => 'Anonim';

  @override
  String get realNameToggle => 'Nume real';

  @override
  String get categoryTestimony => 'Mărturie';

  @override
  String get categoryPrayerRequest => 'Cerere de rugăciune';

  @override
  String get writePostHint =>
      'Împărtășește mărturia sau cererea ta de rugăciune...';

  @override
  String get importFromPrayer => 'Importă din rugăciune';

  @override
  String get calendarTitle => 'Calendar de rugăciune';

  @override
  String get currentStreak => 'Serie curentă';

  @override
  String get bestStreak => 'Cea mai bună serie';

  @override
  String get days => 'zile';

  @override
  String calendarRecordCount(Object count) {
    return '$count înregistrări';
  }

  @override
  String get todayVerse => 'Versetul de azi';

  @override
  String get settingsTitle => 'Setări';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Total rugăciuni';

  @override
  String get consecutiveDays => 'Zile consecutive';

  @override
  String get proSection => 'Abonament';

  @override
  String get freePlan => 'Gratuit';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '34,99 lei / lună';

  @override
  String get yearlyPrice => '249,99 lei / an';

  @override
  String get yearlySave => 'Economisești 40%';

  @override
  String get launchPromo => '3 luni la 17,99lei/lună!';

  @override
  String get startPro => 'Începe Pro';

  @override
  String get comingSoon => 'În curând';

  @override
  String get notificationSetting => 'Notificări';

  @override
  String get languageSetting => 'Limbă';

  @override
  String get darkModeSetting => 'Mod întunecat';

  @override
  String get helpCenter => 'Centru de ajutor';

  @override
  String get termsOfService => 'Termeni și condiții';

  @override
  String get privacyPolicy => 'Politica de confidențialitate';

  @override
  String get logout => 'Deconectează-te';

  @override
  String appVersion(Object version) {
    return 'Versiunea $version';
  }

  @override
  String get anonymous => 'Anonim';

  @override
  String timeAgo(Object time) {
    return 'acum $time';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Parolă';

  @override
  String get signIn => 'Conectează-te';

  @override
  String get cancel => 'Anulează';

  @override
  String get noPrayersRecorded => 'Nicio rugăciune înregistrată';

  @override
  String get deletePost => 'Șterge';

  @override
  String get reportPost => 'Raportează';

  @override
  String get reportSubmitted => 'Raportul a fost trimis. Mulțumim.';

  @override
  String get reportReasonHint =>
      'Descrie motivul raportării. Va fi trimis prin email.';

  @override
  String get reportReasonPlaceholder => 'Introdu motivul raportării...';

  @override
  String get reportSubmitButton => 'Raportează';

  @override
  String get deleteConfirmTitle => 'Șterge postarea';

  @override
  String get deleteConfirmMessage =>
      'Ești sigur că vrei să ștergi această postare?';

  @override
  String get errorNetwork =>
      'Verifică conexiunea la internet și încearcă din nou.';

  @override
  String get errorAiFallback =>
      'IA nu este disponibilă acum. Iată un verset pentru tine.';

  @override
  String get errorSttFailed =>
      'Recunoașterea vocală nu este disponibilă. Te rugăm să scrii.';

  @override
  String get errorPayment =>
      'A apărut o problemă cu plata. Încearcă din nou în Setări.';

  @override
  String get errorGeneric =>
      'Ceva nu a mers bine. Încearcă din nou mai târziu.';

  @override
  String get offlineNotice => 'Ești offline. Unele funcții pot fi limitate.';

  @override
  String get retryButton => 'Încearcă din nou';

  @override
  String get groupSection => 'Grupurile mele';

  @override
  String get createGroup => 'Creează un grup de rugăciune';

  @override
  String get inviteFriends => 'Invită prieteni';

  @override
  String get groupInviteMessage =>
      'Hai să ne rugăm împreună! Alătură-te grupului meu de rugăciune pe Abba.';

  @override
  String get noGroups =>
      'Alătură-te sau creează un grup pentru rugăciune în comun.';

  @override
  String get promoTitle => 'Ofertă de lansare';

  @override
  String get promoBanner => 'Primele 3 luni la 17,99lei/lună!';

  @override
  String promoEndsOn(Object date) {
    return 'Oferta expiră pe $date';
  }

  @override
  String get proLimitTitle => 'Rugăciunea de azi s-a încheiat';

  @override
  String get proLimitBody => 'Ne vedem mâine!\nRoagă-te nelimitat cu Pro';

  @override
  String get laterButton => 'Poate mai târziu';

  @override
  String get proPromptTitle => 'Funcție Pro';

  @override
  String get proPromptBody =>
      'Această funcție este disponibilă cu Pro.\nDorești să vezi planurile noastre?';

  @override
  String get viewProducts => 'Vezi planurile';

  @override
  String get maybeLater => 'Poate mai târziu';

  @override
  String get proHeadline => 'Mai aproape de Dumnezeu, în fiecare zi';

  @override
  String get proBenefit1 => 'Rugăciune și timp liniștit nelimitat';

  @override
  String get proBenefit2 => 'Rugăciune și îndrumare cu IA';

  @override
  String get proBenefit3 => 'Povești de credință din istorie';

  @override
  String get proBenefit5 => 'Studiu biblic în limba originală';

  @override
  String get bestValue => 'CEA MAI BUNĂ OFERTĂ';

  @override
  String get perMonth => 'lună';

  @override
  String get cancelAnytime => 'Anulează oricând';

  @override
  String get restorePurchase => 'Restaurează achiziția';

  @override
  String get yearlyPriceMonthly => '20,83 lei/lună';

  @override
  String get morningPrayerReminder => 'Rugăciunea de dimineață';

  @override
  String get eveningGratitudeReminder => 'Recunoștință de seară';

  @override
  String get streakReminder => 'Reamintire serie';

  @override
  String get afternoonNudgeReminder => 'Reamintire rugăciune de după-amiază';

  @override
  String get weeklySummaryReminder => 'Rezumat săptămânal';

  @override
  String get unlimited => 'Nelimitat';

  @override
  String get streakRecovery => 'Nu-i nimic, poți începe din nou 🌱';

  @override
  String get prayerSaved => 'Rugăciunea a fost salvată cu succes';

  @override
  String get quietTimeLabel => 'Timp liniștit';

  @override
  String get morningPrayerLabel => 'Rugăciunea de dimineață';

  @override
  String get gardenSeed => 'O sămânță de credință';

  @override
  String get gardenSprout => 'Lăstar în creștere';

  @override
  String get gardenBud => 'Boboc în floare';

  @override
  String get gardenBloom => 'Înflorire deplină';

  @override
  String get gardenTree => 'Copac puternic';

  @override
  String get gardenForest => 'Pădure de rugăciune';

  @override
  String get milestoneShare => 'Distribuie';

  @override
  String get milestoneThankGod => 'Slavă Domnului!';

  @override
  String shareStreakText(Object count) {
    return '$count zile de rugăciune continuă! Călătoria mea de rugăciune cu Abba #Abba #Rugăciune';
  }

  @override
  String get shareDaysLabel => 'zile de rugăciune continuă';

  @override
  String get shareSubtitle => 'Rugăciune zilnică cu Dumnezeu';

  @override
  String get proActive => 'Abonament Activ';

  @override
  String get planOncePerDay => '1x/zi';

  @override
  String get planUnlimited => 'Nelimitat';

  @override
  String get closeRecording => 'Închide înregistrarea';

  @override
  String get qtRevealMessage => 'Să deschidem Cuvântul de azi';

  @override
  String get qtSelectPrompt => 'Alege unul și începe timpul liniștit de azi';

  @override
  String get qtTopicLabel => 'Subiect';

  @override
  String get prayerStartPrompt => 'Începe rugăciunea';

  @override
  String get startPrayerButton => 'Începe să te rogi';

  @override
  String get switchToTextMode => 'Scrie în schimb';

  @override
  String get switchToVoiceMode => 'Vorbeste';

  @override
  String get prayerDashboardTitle => 'Grădina rugăciunii';

  @override
  String get qtDashboardTitle => 'Grădina timpului liniștit';

  @override
  String get prayerSummaryTitle => 'Rezumatul rugăciunii';

  @override
  String get gratitudeLabel => 'Recunoștință';

  @override
  String get petitionLabel => 'Cerere';

  @override
  String get intercessionLabel => 'Mijlocire';

  @override
  String get historicalStoryTitle => 'Poveste din istorie';

  @override
  String get todayLesson => 'Lecția de azi';

  @override
  String get applicationTitle => 'Aplicarea de azi';

  @override
  String get applicationWhat => 'Ce';

  @override
  String get applicationWhen => 'Când';

  @override
  String get applicationContext => 'Unde';

  @override
  String get applicationMorningLabel => 'Dimineață';

  @override
  String get applicationDayLabel => 'Zi';

  @override
  String get applicationEveningLabel => 'Seară';

  @override
  String get relatedKnowledgeTitle => 'Cunoștințe conexe';

  @override
  String get originalWordLabel => 'Cuvânt original';

  @override
  String get historicalContextLabel => 'Context istoric';

  @override
  String get crossReferencesLabel => 'Referințe încrucișate';

  @override
  String get growthStoryTitle => 'Poveste de creștere';

  @override
  String get prayerGuideTitle => 'Cum te rogi cu Abba';

  @override
  String get prayerGuide1 => 'Roagă-te cu voce tare sau clară';

  @override
  String get prayerGuide2 =>
      'Abba ascultă cuvintele tale și găsește Scriptura care vorbește inimii tale';

  @override
  String get prayerGuide3 => 'Poți și să scrii rugăciunea ta';

  @override
  String get qtGuideTitle => 'Cum faci timpul liniștit cu Abba';

  @override
  String get qtGuide1 => 'Citește pasajul și meditează în liniște';

  @override
  String get qtGuide2 =>
      'Împărtășește ce ai descoperit — spune sau scrie reflecția ta';

  @override
  String get qtGuide3 =>
      'Abba te va ajuta să aplici Cuvântul în viața de zi cu zi';

  @override
  String get scriptureReasonLabel => 'De ce această Scriptură';

  @override
  String get scripturePostureLabel => 'Cu ce atitudine să o citesc?';

  @override
  String get scriptureOriginalWordsTitle =>
      'Sens mai profund în limba originală';

  @override
  String get originalWordMeaningLabel => 'Sens';

  @override
  String get originalWordNuanceLabel => 'Nuanță vs traducere';

  @override
  String originalWordsCountLabel(int count) {
    return '$count cuvinte';
  }

  @override
  String get seeMore => 'Vezi mai mult';

  @override
  String seeAllComments(Object count) {
    return 'Vezi toate cele $count comentarii';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name și alți $count au apreciat';
  }

  @override
  String get commentsTitle => 'Comentarii';

  @override
  String get myPageTitle => 'Grădina mea de rugăciune';

  @override
  String get myPrayers => 'Rugăciunile mele';

  @override
  String get myTestimonies => 'Mărturiile mele';

  @override
  String get savedPosts => 'Salvate';

  @override
  String get totalPrayersCount => 'Rugăciuni';

  @override
  String get streakCount => 'Serie';

  @override
  String get testimoniesCount => 'Mărturii';

  @override
  String get linkAccountTitle => 'Leagă contul';

  @override
  String get linkAccountDescription =>
      'Leagă contul pentru a păstra înregistrările de rugăciune la schimbarea dispozitivului';

  @override
  String get linkWithApple => 'Leagă cu Apple';

  @override
  String get linkWithGoogle => 'Leagă cu Google';

  @override
  String get linkAccountSuccess => 'Cont legat cu succes!';

  @override
  String get anonymousUser => 'Luptător de rugăciune';

  @override
  String showReplies(Object count) {
    return 'Vezi $count răspunsuri';
  }

  @override
  String get hideReplies => 'Ascunde răspunsurile';

  @override
  String replyingTo(Object name) {
    return 'Răspunzi lui $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Vezi toate cele $count comentarii';
  }

  @override
  String get membershipTitle => 'Abonament';

  @override
  String get membershipSubtitle => 'Aprofundează viața ta de rugăciune';

  @override
  String get monthlyPlan => 'Lunar';

  @override
  String get yearlyPlan => 'Anual';

  @override
  String get yearlySavings => '14,16 lei/lună (40% reducere)';

  @override
  String get startMembership => 'Începe';

  @override
  String get membershipActive => 'Abonament Activ';

  @override
  String get leaveRecordingTitle => 'Părăsești înregistrarea?';

  @override
  String get leaveRecordingMessage =>
      'Înregistrarea ta va fi pierdută. Ești sigur?';

  @override
  String get leaveButton => 'Părăsește';

  @override
  String get stayButton => 'Rămâi';

  @override
  String likedByCount(Object count) {
    return '$count persoane au empatizat';
  }

  @override
  String get actionLike => 'Apreciez';

  @override
  String get actionComment => 'Comentariu';

  @override
  String get actionSave => 'Salvează';

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
  String get billingIssueTitle => 'Problemă de plată detectată';

  @override
  String billingIssueBody(int days) {
    return 'Beneficiile Pro se vor încheia în $days zile dacă plata nu este actualizată.';
  }

  @override
  String get billingIssueAction => 'Actualizează plata';

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
      '💛 Iubire — Gândește-te 10 secunde la cineva drag';

  @override
  String get qtLoadingHint2 => '🌿 Har — Amintește-ți un mic har primit azi';

  @override
  String get qtLoadingHint3 =>
      '🌅 Speranță — Imaginează-ți o mică speranță pentru mâine';

  @override
  String get qtLoadingHint4 => '🕊️ Pace — Respiră adânc de trei ori, încet';

  @override
  String get qtLoadingHint5 =>
      '🌳 Credință — Amintește-ți un adevăr neschimbat';

  @override
  String get qtLoadingHint6 =>
      '🌸 Recunoștință — Numește un lucru pentru care ești recunoscător acum';

  @override
  String get qtLoadingHint7 =>
      '🌊 Iertare — Adu-ți aminte de cineva pe care vrei să-l ierți';

  @override
  String get qtLoadingHint8 =>
      '📖 Înțelepciune — Păstrează o lecție de azi în inimă';

  @override
  String get qtLoadingHint9 =>
      '⏳ Răbdare — Gândește-te la ceea ce aștepți în liniște';

  @override
  String get qtLoadingHint10 => '✨ Bucurie — Amintește-ți un zâmbet de azi';

  @override
  String get qtLoadingTitle => 'Se pregătește Cuvântul de azi...';

  @override
  String get coachingTitle => 'Coaching de rugăciune';

  @override
  String get coachingLoadingText => 'Reflectăm la rugăciunea ta...';

  @override
  String get coachingErrorText => 'Eroare temporară — vă rugăm reîncercați';

  @override
  String get coachingRetryButton => 'Reîncearcă';

  @override
  String get coachingScoreSpecificity => 'Specificitate';

  @override
  String get coachingScoreGodCentered => 'Centrat pe Dumnezeu';

  @override
  String get coachingScoreActs => 'Echilibru ACTS';

  @override
  String get coachingScoreAuthenticity => 'Autenticitate';

  @override
  String get coachingStrengthsTitle => 'Ce ai făcut bine ✨';

  @override
  String get coachingImprovementsTitle => 'Pentru a merge mai adânc 💡';

  @override
  String get coachingProCta => 'Deblochează Coaching cu Pro';

  @override
  String get coachingLevelBeginner => '🌱 Începător';

  @override
  String get coachingLevelGrowing => '🌿 În creștere';

  @override
  String get coachingLevelExpert => '🌳 Expert';

  @override
  String get aiPrayerCitationsTitle => 'Referințe · Citate';

  @override
  String get citationTypeQuote => 'Citat';

  @override
  String get citationTypeScience => 'Cercetare';

  @override
  String get citationTypeExample => 'Exemplu';

  @override
  String get citationTypeHistory => 'Istorie';

  @override
  String get aiPrayerReadingTime => 'Lectură de 2 minute';

  @override
  String get scriptureKeyWordHintTitle => 'Cuvântul cheie de astăzi';

  @override
  String get bibleLookupReferenceHint =>
      'Găsește acest pasaj în Biblia ta și meditează asupra lui.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Traduceri ale Bibliei';

  @override
  String get settingsBibleTranslationsIntro =>
      'Versetele biblice din această aplicație provin din traduceri aflate în domeniul public. Comentariile, rugăciunile și poveștile generate de AI sunt opera creativă a Abba.';

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
  String get qtCoachingLoadingText => 'Reflectăm la meditația ta...';

  @override
  String get qtCoachingErrorText => 'Eroare temporară — vă rugăm reîncercați';

  @override
  String get qtCoachingRetryButton => 'Reîncearcă';

  @override
  String get qtCoachingScoreComprehension => 'Înțelegerea textului';

  @override
  String get qtCoachingScoreApplication => 'Aplicație personală';

  @override
  String get qtCoachingScoreDepth => 'Profunzime spirituală';

  @override
  String get qtCoachingScoreAuthenticity => 'Autenticitate';

  @override
  String get qtCoachingStrengthsTitle => 'Ce ai făcut bine ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Pentru a merge mai adânc 💡';

  @override
  String get qtCoachingProCta => 'Deblochează Coaching QT cu Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Începător';

  @override
  String get qtCoachingLevelGrowing => '🌿 În creștere';

  @override
  String get qtCoachingLevelExpert => '🌳 Expert';

  @override
  String get notifyMorning1Title => '🙏 E timpul să te rogi';

  @override
  String notifyMorning1Body(String name) {
    return '$name, vorbește cu Dumnezeu și astăzi';
  }

  @override
  String get notifyMorning2Title => '🌅 A venit o nouă dimineață';

  @override
  String notifyMorning2Body(String name) {
    return '$name, începe ziua cu recunoștință';
  }

  @override
  String get notifyMorning3Title => '✨ Harul de azi';

  @override
  String notifyMorning3Body(String name) {
    return '$name, întâlnește harul pe care Dumnezeu l-a pregătit';
  }

  @override
  String get notifyMorning4Title => '🕊️ Dimineață liniștită';

  @override
  String notifyMorning4Body(String name) {
    return '$name, umple-ți inima cu pace prin rugăciune';
  }

  @override
  String get notifyMorning5Title => '📖 Cu Cuvântul';

  @override
  String notifyMorning5Body(String name) {
    return '$name, ascultă glasul lui Dumnezeu astăzi';
  }

  @override
  String get notifyMorning6Title => '🌿 Timp de odihnă';

  @override
  String notifyMorning6Body(String name) {
    return '$name, oprește-te o clipă și roagă-te';
  }

  @override
  String get notifyMorning7Title => '💫 Și azi';

  @override
  String notifyMorning7Body(String name) {
    return '$name, o zi care începe cu rugăciune este diferită';
  }

  @override
  String get notifyEvening1Title => '✨ Recunoștință pentru azi';

  @override
  String get notifyEvening1Body =>
      'Privește ziua și înalță o rugăciune de mulțumire';

  @override
  String get notifyEvening2Title => '🌙 Încheind ziua';

  @override
  String get notifyEvening2Body => 'Exprimă recunoștința zilei prin rugăciune';

  @override
  String get notifyEvening3Title => '🙏 Rugăciune de seară';

  @override
  String get notifyEvening3Body =>
      'La sfârșitul zilei, mulțumește-I lui Dumnezeu';

  @override
  String get notifyEvening4Title => '🌟 Numărând binecuvântările de azi';

  @override
  String get notifyEvening4Body =>
      'Dacă ai pentru ce să mulțumești, împărtășește în rugăciune';

  @override
  String get notifyStreak3Title => '🌱 3 zile la rând!';

  @override
  String get notifyStreak3Body => 'Obiceiul tău de rugăciune a început';

  @override
  String get notifyStreak7Title => '🌿 O săptămână întreagă!';

  @override
  String get notifyStreak7Body => 'Rugăciunea devine un obicei';

  @override
  String get notifyStreak14Title => '🌳 2 săptămâni la rând!';

  @override
  String get notifyStreak14Body => 'Creștere uimitoare!';

  @override
  String get notifyStreak21Title => '🌻 3 săptămâni la rând!';

  @override
  String get notifyStreak21Body => 'Floarea rugăciunii înflorește';

  @override
  String get notifyStreak30Title => '🏆 O lună întreagă!';

  @override
  String get notifyStreak30Body => 'Rugăciunea ta strălucește';

  @override
  String get notifyStreak50Title => '👑 50 de zile la rând!';

  @override
  String get notifyStreak50Body => 'Umblarea ta cu Dumnezeu se adâncește';

  @override
  String get notifyStreak100Title => '🎉 100 de zile la rând!';

  @override
  String get notifyStreak100Body => 'Ai devenit un luptător al rugăciunii!';

  @override
  String get notifyStreak365Title => '✝️ Un an întreg!';

  @override
  String get notifyStreak365Body => 'Ce călătorie uimitoare a credinței!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ Te-ai rugat astăzi?';

  @override
  String get notifyAfternoonNudgeBody =>
      'O rugăciune scurtă poate schimba ziua';

  @override
  String get notifyChannelName => 'Memento-uri de rugăciune';

  @override
  String get notifyChannelDescription =>
      'Rugăciune de dimineață, mulțumire de seară și alte memento-uri';

  @override
  String get milestoneFirstPrayerTitle => 'Prima rugăciune!';

  @override
  String get milestoneFirstPrayerDesc =>
      'Călătoria ta de rugăciune a început. Dumnezeu ascultă.';

  @override
  String get milestoneSevenDayStreakTitle => '7 zile de rugăciune!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'O săptămână de rugăciune fidelă. Grădina ta crește!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 de zile!';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'Grădina ta a înflorit într-un câmp de flori!';

  @override
  String get milestoneHundredPrayersTitle => 'A 100-a rugăciune!';

  @override
  String get milestoneHundredPrayersDesc =>
      'O sută de conversații cu Dumnezeu. Ești adânc înrădăcinat.';

  @override
  String get homeFirstPrayerPrompt => 'Începe prima ta rugăciune';

  @override
  String get homeFirstQtPrompt => 'Începe primul tău QT';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Fă $activityName și astăzi';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'Ziua $count continuă de $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'Au trecut $days zile de la ultimul $activityName';
  }

  @override
  String get homeActivityPrayer => 'rugăciune';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Se încarcă...';

  @override
  String get heatmapNoPrayer => 'Nicio rugăciune';

  @override
  String get heatmapLegendLess => 'Mai puțin';

  @override
  String get heatmapLegendMore => 'Mai mult';

  @override
  String get qtPassagesLoadError =>
      'Nu am putut încărca pasajele de astăzi. Verificați conexiunea.';

  @override
  String get qtPassagesRetryButton => 'Încearcă din nou';

  @override
  String get aiStreamingInitial => 'Meditating on your prayer...';

  @override
  String get aiTierProcessing => 'More reflections coming...';

  @override
  String get aiScriptureValidating => 'Finding the right scripture...';

  @override
  String get aiScriptureValidatingFailed =>
      'Preparing this scripture for you...';

  @override
  String get aiTemplateFallback => 'While we prepare your full analysis...';

  @override
  String get aiPendingMore => 'Preparing more...';

  @override
  String get aiTierIncomplete => 'Coming soon, check back later';

  @override
  String get tierCompleted => 'New reflection added';

  @override
  String get tierProcessingNotice => 'Generating more reflections...';

  @override
  String get proSectionLoading => 'Preparing your premium content...';

  @override
  String get proSectionWillArrive => 'Your deep reflection will appear here';

  @override
  String get templateCategoryHealth => 'For Health Concerns';

  @override
  String get templateCategoryFamily => 'For Family';

  @override
  String get templateCategoryWork => 'For Work & Studies';

  @override
  String get templateCategoryGratitude => 'A Thankful Heart';

  @override
  String get templateCategoryGrief => 'In Grief or Loss';

  @override
  String get sectionStatusCompleted => 'Analysis complete';

  @override
  String get sectionStatusPartial => 'Partial analysis (more coming)';

  @override
  String get sectionStatusPending => 'Analysis in progress';
}
