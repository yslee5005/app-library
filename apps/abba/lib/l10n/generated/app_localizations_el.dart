// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Όταν προσεύχεσαι,\nο Θεός απαντά.';

  @override
  String get welcomeSubtitle =>
      'Ο καθημερινός σύντροφός σου στην προσευχή και τη μελέτη';

  @override
  String get getStarted => 'Ξεκίνα';

  @override
  String get loginTitle => 'Καλώς ήρθατε στο Abba';

  @override
  String get loginSubtitle =>
      'Συνδεθείτε για να ξεκινήσετε το ταξίδι προσευχής σας';

  @override
  String get signInWithApple => 'Συνέχεια με Apple';

  @override
  String get signInWithGoogle => 'Συνέχεια με Google';

  @override
  String get signInWithEmail => 'Συνέχεια με Email';

  @override
  String greetingMorning(Object name) {
    return 'Καλημέρα, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Καλό απόγευμα, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Καλησπέρα, $name';
  }

  @override
  String get prayButton => 'Προσευχή';

  @override
  String get qtButton => 'Ώρα Μελέτης';

  @override
  String streakDays(Object count) {
    return '$count ημέρες συνεχούς προσευχής';
  }

  @override
  String get dailyVerse => 'Εδάφιο Ημέρας';

  @override
  String get tabHome => 'Αρχική';

  @override
  String get tabCalendar => 'Ημερολόγιο';

  @override
  String get tabCommunity => 'Κοινότητα';

  @override
  String get tabSettings => 'Ρυθμίσεις';

  @override
  String get recordingTitle => 'Προσεύχομαι...';

  @override
  String get recordingPause => 'Παύση';

  @override
  String get recordingResume => 'Συνέχεια';

  @override
  String get finishPrayer => 'Τέλος Προσευχής';

  @override
  String get finishPrayerConfirm => 'Θέλετε να τελειώσετε την προσευχή σας;';

  @override
  String get switchToText => 'Γράψε αντί αυτού';

  @override
  String get textInputHint => 'Γράψε την προσευχή σου εδώ...';

  @override
  String get aiLoadingText => 'Αναλογίζομαι την προσευχή σου...';

  @override
  String get aiLoadingVerse =>
      'Σταματήστε και γνωρίστε ότι εγώ είμαι ο Θεός.\n— Ψαλμός 46:10';

  @override
  String get dashboardTitle => 'Κήπος Προσευχής';

  @override
  String get shareButton => 'Κοινοποίηση';

  @override
  String get backToHome => 'Επιστροφή στην Αρχική';

  @override
  String get scriptureTitle => 'Γραφή Ημέρας';

  @override
  String get bibleStoryTitle => 'Βιβλική Ιστορία';

  @override
  String get testimonyTitle => 'Μαρτυρία · Η προσευχή μου';

  @override
  String get testimonyHelperText =>
      'Στοχαστείτε την προσευχή σας · μπορεί να μοιραστεί με την κοινότητα';

  @override
  String get myPrayerAudioLabel => 'Ηχογράφηση της προσευχής μου';

  @override
  String get testimonyEdit => 'Επεξεργασία';

  @override
  String get guidanceTitle => 'Καθοδήγηση AI';

  @override
  String get aiPrayerTitle => 'Μια Προσευχή για Σένα';

  @override
  String get originalLangTitle => 'Αρχική Γλώσσα';

  @override
  String get proUnlock => 'Ξεκλείδωμα με Pro';

  @override
  String get qtPageTitle => 'Πρωινός Κήπος';

  @override
  String get qtMeditateButton => 'Έναρξη Μελέτης';

  @override
  String get qtCompleted => 'Ολοκληρώθηκε';

  @override
  String get communityTitle => 'Κήπος Προσευχής';

  @override
  String get filterAll => 'Όλα';

  @override
  String get filterTestimony => 'Μαρτυρία';

  @override
  String get filterPrayerRequest => 'Αίτημα Προσευχής';

  @override
  String get likeButton => 'Μου αρέσει';

  @override
  String get commentButton => 'Σχόλιο';

  @override
  String get saveButton => 'Αποθήκευση';

  @override
  String get replyButton => 'Απάντηση';

  @override
  String get writePostTitle => 'Κοινοποίηση';

  @override
  String get cancelButton => 'Ακύρωση';

  @override
  String get sharePostButton => 'Δημοσίευση';

  @override
  String get anonymousToggle => 'Ανώνυμος';

  @override
  String get realNameToggle => 'Πραγματικό Όνομα';

  @override
  String get categoryTestimony => 'Μαρτυρία';

  @override
  String get categoryPrayerRequest => 'Αίτημα Προσευχής';

  @override
  String get writePostHint =>
      'Μοιράσου τη μαρτυρία ή το αίτημα προσευχής σου...';

  @override
  String get importFromPrayer => 'Εισαγωγή από προσευχή';

  @override
  String get calendarTitle => 'Ημερολόγιο Προσευχής';

  @override
  String get currentStreak => 'Τρέχον Σερί';

  @override
  String get bestStreak => 'Καλύτερο Σερί';

  @override
  String get days => 'ημέρες';

  @override
  String calendarRecordCount(Object count) {
    return '$count εγγραφές';
  }

  @override
  String get todayVerse => 'Εδάφιο Ημέρας';

  @override
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get profileSection => 'Προφίλ';

  @override
  String get totalPrayers => 'Συνολικές Προσευχές';

  @override
  String get consecutiveDays => 'Συνεχόμενες Ημέρες';

  @override
  String get proSection => 'Συνδρομή';

  @override
  String get freePlan => 'Δωρεάν';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '6,99€ / μήνα';

  @override
  String get yearlyPrice => '49,99€ / έτος';

  @override
  String get yearlySave => 'Εξοικονόμηση 40%';

  @override
  String get launchPromo => '3 μήνες στα 3,99€/μήνα!';

  @override
  String get startPro => 'Ξεκίνα Pro';

  @override
  String get comingSoon => 'Έρχεται σύντομα';

  @override
  String get notificationSetting => 'Ειδοποιήσεις';

  @override
  String get languageSetting => 'Γλώσσα';

  @override
  String get darkModeSetting => 'Σκοτεινή Λειτουργία';

  @override
  String get helpCenter => 'Κέντρο Βοήθειας';

  @override
  String get termsOfService => 'Όροι Χρήσης';

  @override
  String get privacyPolicy => 'Πολιτική Απορρήτου';

  @override
  String get logout => 'Αποσύνδεση';

  @override
  String appVersion(Object version) {
    return 'Έκδοση $version';
  }

  @override
  String get anonymous => 'Ανώνυμος';

  @override
  String timeAgo(Object time) {
    return 'πριν $time';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Κωδικός';

  @override
  String get signIn => 'Σύνδεση';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get noPrayersRecorded => 'Δεν υπάρχουν καταγεγραμμένες προσευχές';

  @override
  String get deletePost => 'Διαγραφή';

  @override
  String get reportPost => 'Αναφορά';

  @override
  String get reportSubmitted => 'Η αναφορά υποβλήθηκε. Ευχαριστούμε.';

  @override
  String get reportReasonHint =>
      'Περιγράψτε τον λόγο αναφοράς. Θα σταλεί μέσω email.';

  @override
  String get reportReasonPlaceholder => 'Εισάγετε τον λόγο αναφοράς...';

  @override
  String get reportSubmitButton => 'Αναφορά';

  @override
  String get deleteConfirmTitle => 'Διαγραφή Ανάρτησης';

  @override
  String get deleteConfirmMessage =>
      'Είστε σίγουροι ότι θέλετε να διαγράψετε αυτή την ανάρτηση;';

  @override
  String get errorNetwork =>
      'Ελέγξτε τη σύνδεση στο διαδίκτυο και δοκιμάστε ξανά.';

  @override
  String get errorAiFallback =>
      'Δεν μπορέσαμε να συνδεθούμε με AI. Ιδού ένα εδάφιο για εσάς.';

  @override
  String get errorSttFailed =>
      'Η αναγνώριση φωνής δεν είναι διαθέσιμη. Γράψτε αντί αυτού.';

  @override
  String get errorPayment =>
      'Υπήρξε πρόβλημα με την πληρωμή. Δοκιμάστε ξανά στις Ρυθμίσεις.';

  @override
  String get errorGeneric => 'Κάτι πήγε στραβά. Δοκιμάστε ξανά αργότερα.';

  @override
  String get offlineNotice =>
      'Είστε εκτός σύνδεσης. Ορισμένες λειτουργίες ενδέχεται να είναι περιορισμένες.';

  @override
  String get retryButton => 'Δοκίμασε Ξανά';

  @override
  String get groupSection => 'Οι Ομάδες Μου';

  @override
  String get createGroup => 'Δημιουργία Ομάδας Προσευχής';

  @override
  String get inviteFriends => 'Πρόσκληση Φίλων';

  @override
  String get groupInviteMessage =>
      'Ας προσευχηθούμε μαζί! Εγγραφείτε στην ομάδα προσευχής μου στο Abba.';

  @override
  String get noGroups =>
      'Εγγραφείτε ή δημιουργήστε ομάδα για να προσεύχεστε μαζί.';

  @override
  String get promoTitle => 'Ειδική Προσφορά';

  @override
  String get promoBanner => '3 πρώτοι μήνες στα 3,99€/μήνα!';

  @override
  String promoEndsOn(Object date) {
    return 'Η προσφορά λήγει $date';
  }

  @override
  String get proLimitTitle => 'Η σημερινή προσευχή ολοκληρώθηκε';

  @override
  String get proLimitBody => 'Τα λέμε αύριο!\nΑπεριόριστη προσευχή με Pro';

  @override
  String get laterButton => 'Ίσως αργότερα';

  @override
  String get proPromptTitle => 'Λειτουργία Pro';

  @override
  String get proPromptBody =>
      'Αυτή η λειτουργία είναι διαθέσιμη με Pro.\nΘέλετε να δείτε τα πλάνα;';

  @override
  String get viewProducts => 'Δείτε Πλάνα';

  @override
  String get maybeLater => 'Ίσως αργότερα';

  @override
  String get proHeadline => 'Πιο κοντά στον Θεό, κάθε μέρα';

  @override
  String get proBenefit1 => 'Απεριόριστη Προσευχή & Μελέτη';

  @override
  String get proBenefit2 => 'Προσευχή & καθοδήγηση με AI';

  @override
  String get proBenefit3 => 'Ιστορίες πίστης από την ιστορία';

  @override
  String get proBenefit5 => 'Μελέτη Βίβλου στην αρχική γλώσσα';

  @override
  String get bestValue => 'ΚΑΛΥΤΕΡΗ ΑΞΙΑ';

  @override
  String get perMonth => 'μήνα';

  @override
  String get cancelAnytime => 'Ακύρωση ανά πάσα στιγμή';

  @override
  String get restorePurchase => 'Επαναφορά αγοράς';

  @override
  String get yearlyPriceMonthly => '4,17€/μήνα';

  @override
  String get morningPrayerReminder => 'Πρωινή Προσευχή';

  @override
  String get eveningGratitudeReminder => 'Βραδινή Ευχαριστία';

  @override
  String get streakReminder => 'Υπενθύμιση Σερί';

  @override
  String get afternoonNudgeReminder => 'Υπενθύμιση Απογευματινής Προσευχής';

  @override
  String get weeklySummaryReminder => 'Εβδομαδιαία Σύνοψη';

  @override
  String get unlimited => 'Απεριόριστο';

  @override
  String get streakRecovery => 'Δεν πειράζει, μπορείς να ξαναρχίσεις 🌱';

  @override
  String get prayerSaved => 'Η προσευχή αποθηκεύτηκε επιτυχώς';

  @override
  String get quietTimeLabel => 'Ώρα Μελέτης';

  @override
  String get morningPrayerLabel => 'Πρωινή Προσευχή';

  @override
  String get gardenSeed => 'Σπόρος πίστης';

  @override
  String get gardenSprout => 'Φύτρο που μεγαλώνει';

  @override
  String get gardenBud => 'Μπουμπούκι';

  @override
  String get gardenBloom => 'Πλήρης ανθοφορία';

  @override
  String get gardenTree => 'Δυνατό δέντρο';

  @override
  String get gardenForest => 'Δάσος προσευχής';

  @override
  String get milestoneShare => 'Κοινοποίηση';

  @override
  String get milestoneThankGod => 'Δόξα τω Θεώ!';

  @override
  String shareStreakText(Object count) {
    return '$count ημέρες συνεχούς προσευχής! Το ταξίδι προσευχής μου με Abba #Abba #Προσευχή';
  }

  @override
  String get shareDaysLabel => 'ημέρες συνεχούς προσευχής';

  @override
  String get shareSubtitle => 'Καθημερινή προσευχή με τον Θεό';

  @override
  String get proActive => 'Συνδρομή Ενεργή';

  @override
  String get planOncePerDay => '1 φορά/ημέρα';

  @override
  String get planUnlimited => 'Απεριόριστο';

  @override
  String get closeRecording => 'Κλείσιμο εγγραφής';

  @override
  String get qtRevealMessage => 'Ας ανοίξουμε τον Λόγο της ημέρας';

  @override
  String get qtSelectPrompt => 'Διάλεξε ένα θέμα και ξεκίνα τη μελέτη σήμερα';

  @override
  String get qtTopicLabel => 'Θέμα';

  @override
  String get prayerStartPrompt => 'Ξεκίνα την προσευχή σου';

  @override
  String get startPrayerButton => 'Έναρξη Προσευχής';

  @override
  String get switchToTextMode => 'Γράψε αντί αυτού';

  @override
  String get switchToVoiceMode => 'Μιλήστε';

  @override
  String get prayerDashboardTitle => 'Κήπος Προσευχής';

  @override
  String get qtDashboardTitle => 'Κήπος Μελέτης';

  @override
  String get prayerSummaryTitle => 'Σύνοψη Προσευχής';

  @override
  String get gratitudeLabel => 'Ευχαριστία';

  @override
  String get petitionLabel => 'Αίτηση';

  @override
  String get intercessionLabel => 'Μεσιτεία';

  @override
  String get historicalStoryTitle => 'Ιστορία από το Παρελθόν';

  @override
  String get todayLesson => 'Μάθημα Ημέρας';

  @override
  String get meditationAnalysisTitle => 'Ανάλυση Μελέτης';

  @override
  String get keyThemeLabel => 'Κεντρικό Θέμα';

  @override
  String get applicationTitle => 'Εφαρμογή Ημέρας';

  @override
  String get applicationWhat => 'Τι';

  @override
  String get applicationWhen => 'Πότε';

  @override
  String get applicationContext => 'Πού';

  @override
  String get relatedKnowledgeTitle => 'Σχετική Γνώση';

  @override
  String get originalWordLabel => 'Αρχική Λέξη';

  @override
  String get historicalContextLabel => 'Ιστορικό Πλαίσιο';

  @override
  String get crossReferencesLabel => 'Διασταυρούμενες Αναφορές';

  @override
  String get growthStoryTitle => 'Ιστορία Ανάπτυξης';

  @override
  String get prayerGuideTitle => 'Πώς να προσεύχεσαι με Abba';

  @override
  String get prayerGuide1 => 'Προσευχήσου δυνατά ή με καθαρή φωνή';

  @override
  String get prayerGuide2 =>
      'Ο Abba ακούει την προσευχή σου και βρίσκει εδάφια που αγγίζουν την καρδιά σου';

  @override
  String get prayerGuide3 => 'Μπορείς επίσης να γράψεις την προσευχή σου';

  @override
  String get qtGuideTitle => 'Πώς να κάνεις μελέτη με Abba';

  @override
  String get qtGuide1 => 'Διάβασε το χωρίο και σκέψου ήσυχα';

  @override
  String get qtGuide2 =>
      'Μοιράσου τι ανακάλυψες — μίλα ή γράψε τον στοχασμό σου';

  @override
  String get qtGuide3 =>
      'Ο Abba θα σε βοηθήσει να εφαρμόσεις τον Λόγο στην καθημερινή ζωή';

  @override
  String get scriptureReasonLabel => 'Γιατί αυτό το εδάφιο';

  @override
  String get scripturePostureLabel => 'Με ποια στάση να το διαβάσω;';

  @override
  String get scriptureOriginalWordsTitle => 'Βαθύτερο νόημα στην αρχική γλώσσα';

  @override
  String get originalWordMeaningLabel => 'Νόημα';

  @override
  String get originalWordNuanceLabel => 'Απόχρωση vs μετάφραση';

  @override
  String originalWordsCountLabel(int count) {
    return '$count λέξεις';
  }

  @override
  String get seeMore => 'Δείτε περισσότερα';

  @override
  String seeAllComments(Object count) {
    return 'Δείτε όλα τα $count σχόλια';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name και $count ακόμα αρέσει';
  }

  @override
  String get commentsTitle => 'Σχόλια';

  @override
  String get myPageTitle => 'Ο Κήπος Προσευχής Μου';

  @override
  String get myPrayers => 'Οι Προσευχές Μου';

  @override
  String get myTestimonies => 'Οι Μαρτυρίες Μου';

  @override
  String get savedPosts => 'Αποθηκευμένα';

  @override
  String get totalPrayersCount => 'Προσευχές';

  @override
  String get streakCount => 'Σερί';

  @override
  String get testimoniesCount => 'Μαρτυρίες';

  @override
  String get linkAccountTitle => 'Σύνδεση Λογαριασμού';

  @override
  String get linkAccountDescription =>
      'Συνδέστε τον λογαριασμό σας για να διατηρήσετε τα αρχεία προσευχής κατά την αλλαγή συσκευής';

  @override
  String get linkWithApple => 'Σύνδεση με Apple';

  @override
  String get linkWithGoogle => 'Σύνδεση με Google';

  @override
  String get linkAccountSuccess => 'Ο λογαριασμός συνδέθηκε επιτυχώς!';

  @override
  String get anonymousUser => 'Πολεμιστής Προσευχής';

  @override
  String showReplies(Object count) {
    return 'Δείτε $count απαντήσεις';
  }

  @override
  String get hideReplies => 'Απόκρυψη απαντήσεων';

  @override
  String replyingTo(Object name) {
    return 'Απάντηση στον $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Δείτε όλα τα $count σχόλια';
  }

  @override
  String get membershipTitle => 'Συνδρομή';

  @override
  String get membershipSubtitle => 'Εμβαθύνετε στη ζωή προσευχής σας';

  @override
  String get monthlyPlan => 'Μηνιαία';

  @override
  String get yearlyPlan => 'Ετήσια';

  @override
  String get yearlySavings => '4,17€/μήνα (40% έκπτωση)';

  @override
  String get startMembership => 'Ξεκινήστε';

  @override
  String get membershipActive => 'Συνδρομή Ενεργή';

  @override
  String get leaveRecordingTitle => 'Έξοδος από την εγγραφή;';

  @override
  String get leaveRecordingMessage => 'Η εγγραφή σας θα χαθεί. Είστε σίγουροι;';

  @override
  String get leaveButton => 'Έξοδος';

  @override
  String get stayButton => 'Παραμονή';

  @override
  String likedByCount(Object count) {
    return '$count άτομα συμπόνεσαν';
  }

  @override
  String get actionLike => 'Μου αρέσει';

  @override
  String get actionComment => 'Σχόλιο';

  @override
  String get actionSave => 'Αποθήκευση';

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
      '💛 Αγάπη — Σκέψου κάποιον που αγαπάς για 10 δευτερόλεπτα';

  @override
  String get qtLoadingHint2 =>
      '🌿 Χάρη — Θυμήσου μια μικρή χάρη που έλαβες σήμερα';

  @override
  String get qtLoadingHint3 =>
      '🌅 Ελπίδα — Φαντάσου μια μικρή ελπίδα για αύριο';

  @override
  String get qtLoadingHint4 => '🕊️ Ειρήνη — Πάρε τρεις αργές, βαθιές αναπνοές';

  @override
  String get qtLoadingHint5 => '🌳 Πίστη — Θυμήσου μια αμετάβλητη αλήθεια';

  @override
  String get qtLoadingHint6 =>
      '🌸 Ευγνωμοσύνη — Πες ένα πράγμα για το οποίο είσαι τώρα ευγνώμων';

  @override
  String get qtLoadingHint7 =>
      '🌊 Συγχώρεση — Φέρε στο μυαλό κάποιον να συγχωρήσεις';

  @override
  String get qtLoadingHint8 =>
      '📖 Σοφία — Κράτα ένα μάθημα από σήμερα στην καρδιά';

  @override
  String get qtLoadingHint9 => '⏳ Υπομονή — Σκέψου τι περιμένεις σιωπηλά';

  @override
  String get qtLoadingHint10 => '✨ Χαρά — Θυμήσου ένα χαμόγελο από σήμερα';

  @override
  String get qtLoadingTitle => 'Προετοιμάζεται ο σημερινός Λόγος...';

  @override
  String get coachingTitle => 'Καθοδήγηση προσευχής';

  @override
  String get coachingLoadingText => 'Αναλογιζόμαστε την προσευχή σας...';

  @override
  String get coachingErrorText => 'Προσωρινό σφάλμα — δοκιμάστε ξανά';

  @override
  String get coachingRetryButton => 'Επανάληψη';

  @override
  String get coachingScoreSpecificity => 'Συγκεκριμένο';

  @override
  String get coachingScoreGodCentered => 'Θεοκεντρικότητα';

  @override
  String get coachingScoreActs => 'Ισορροπία ACTS';

  @override
  String get coachingScoreAuthenticity => 'Αυθεντικότητα';

  @override
  String get coachingStrengthsTitle => 'Τι κάνατε καλά ✨';

  @override
  String get coachingImprovementsTitle => 'Για να πάτε πιο βαθιά 💡';

  @override
  String get coachingProCta => 'Ξεκλειδώστε την Καθοδήγηση με Pro';

  @override
  String get coachingLevelBeginner => '🌱 Αρχάριος';

  @override
  String get coachingLevelGrowing => '🌿 Σε εξέλιξη';

  @override
  String get coachingLevelExpert => '🌳 Ειδικός';
}
