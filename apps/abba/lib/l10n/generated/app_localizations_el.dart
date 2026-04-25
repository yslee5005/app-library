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
  String get aiErrorNetworkTitle => 'Η σύνδεση είναι ασταθής';

  @override
  String get aiErrorNetworkBody =>
      'Η προσευχή σας έχει αποθηκευτεί με ασφάλεια. Δοκιμάστε ξανά σε λίγο.';

  @override
  String get aiErrorApiTitle => 'Η υπηρεσία AI είναι ασταθής';

  @override
  String get aiErrorApiBody =>
      'Η προσευχή σας έχει αποθηκευτεί με ασφάλεια. Δοκιμάστε ξανά σε λίγο.';

  @override
  String get aiErrorRetry => 'Δοκιμάστε ξανά';

  @override
  String get aiErrorWaitAndCheck =>
      'Θα προσπαθήσουμε την ανάλυση αργότερα. Επιστρέψτε σύντομα — η προσευχή σας θα σας περιμένει.';

  @override
  String get aiErrorHome => 'Επιστροφή στην αρχική';

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
  String get proPreviewHistoricalHint =>
      'Discover the deeper history behind a word from your prayer';

  @override
  String get proPreviewPrayerHint =>
      'A 300-word prayer is waiting just for you';

  @override
  String get proPreviewCoachingHint =>
      'One coaching tip waits to deepen your next prayer';

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
  String get launchPromo => '';

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
  String get promoBanner => '';

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
  String get applicationTitle => 'Εφαρμογή Ημέρας';

  @override
  String get applicationWhat => 'Τι';

  @override
  String get applicationWhen => 'Πότε';

  @override
  String get applicationContext => 'Πού';

  @override
  String get applicationMorningLabel => 'Πρωί';

  @override
  String get applicationDayLabel => 'Μέρα';

  @override
  String get applicationEveningLabel => 'Βράδυ';

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
  String get seeLess => 'Δείτε λιγότερα';

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
  String get billingIssueTitle => 'Εντοπίστηκε πρόβλημα πληρωμής';

  @override
  String billingIssueBody(int days) {
    return 'Τα προνόμια Pro θα λήξουν σε $days ημέρες αν δεν ενημερωθεί η πληρωμή.';
  }

  @override
  String get billingIssueAction => 'Ενημέρωση πληρωμής';

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

  @override
  String get aiPrayerCitationsTitle => 'Αναφορές · Παραθέσεις';

  @override
  String get citationTypeQuote => 'Παράθεση';

  @override
  String get citationTypeScience => 'Έρευνα';

  @override
  String get citationTypeExample => 'Παράδειγμα';

  @override
  String get citationTypeHistory => 'Ιστορία';

  @override
  String get aiPrayerReadingTime => 'Ανάγνωση 2 λεπτών';

  @override
  String get scriptureKeyWordHintTitle => 'Η λέξη-κλειδί σήμερα';

  @override
  String get bibleLookupReferenceHint =>
      'Βρείτε αυτό το εδάφιο στη δική σας Βίβλο και στοχαστείτε πάνω σε αυτό.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Μεταφράσεις της Βίβλου';

  @override
  String get settingsBibleTranslationsIntro =>
      'Τα βιβλικά εδάφια σε αυτήν την εφαρμογή προέρχονται από μεταφράσεις στο δημόσιο τομέα. Τα σχόλια, οι προσευχές και οι ιστορίες που δημιουργούνται από το AI είναι δημιουργικό έργο του Abba.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'Καθοδήγηση QT';

  @override
  String get qtCoachingLoadingText => 'Αναλογιζόμαστε τον διαλογισμό σας...';

  @override
  String get qtCoachingErrorText => 'Προσωρινό σφάλμα — δοκιμάστε ξανά';

  @override
  String get qtCoachingRetryButton => 'Επανάληψη';

  @override
  String get qtCoachingScoreComprehension => 'Κατανόηση κειμένου';

  @override
  String get qtCoachingScoreApplication => 'Προσωπική εφαρμογή';

  @override
  String get qtCoachingScoreDepth => 'Πνευματικό βάθος';

  @override
  String get qtCoachingScoreAuthenticity => 'Αυθεντικότητα';

  @override
  String get qtCoachingStrengthsTitle => 'Τι κάνατε καλά ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Για να πάτε πιο βαθιά 💡';

  @override
  String get qtCoachingProCta => 'Ξεκλειδώστε την Καθοδήγηση QT με Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Αρχάριος';

  @override
  String get qtCoachingLevelGrowing => '🌿 Σε εξέλιξη';

  @override
  String get qtCoachingLevelExpert => '🌳 Ειδικός';

  @override
  String get notifyMorning1Title => '🙏 Ώρα για προσευχή';

  @override
  String notifyMorning1Body(String name) {
    return '$name, μίλα με τον Θεό και σήμερα';
  }

  @override
  String get notifyMorning2Title => '🌅 Ένα νέο πρωί ήρθε';

  @override
  String notifyMorning2Body(String name) {
    return '$name, ξεκίνα την ημέρα με ευγνωμοσύνη';
  }

  @override
  String get notifyMorning3Title => '✨ Η χάρη της ημέρας';

  @override
  String notifyMorning3Body(String name) {
    return '$name, συνάντησε τη χάρη που ετοίμασε ο Θεός';
  }

  @override
  String get notifyMorning4Title => '🕊️ Ήρεμο πρωινό';

  @override
  String notifyMorning4Body(String name) {
    return '$name, γέμισε την καρδιά με ειρήνη μέσω της προσευχής';
  }

  @override
  String get notifyMorning5Title => '📖 Με τον Λόγο';

  @override
  String notifyMorning5Body(String name) {
    return '$name, άκουσε τη φωνή του Θεού σήμερα';
  }

  @override
  String get notifyMorning6Title => '🌿 Ώρα για ξεκούραση';

  @override
  String notifyMorning6Body(String name) {
    return '$name, σταμάτησε για λίγο και προσευχήσου';
  }

  @override
  String get notifyMorning7Title => '💫 Και σήμερα';

  @override
  String notifyMorning7Body(String name) {
    return '$name, μια ημέρα που αρχίζει με προσευχή είναι διαφορετική';
  }

  @override
  String get notifyEvening1Title => '✨ Ευγνωμοσύνη για σήμερα';

  @override
  String get notifyEvening1Body =>
      'Κοίταξε πίσω στην ημέρα και προσφέρει ευχαριστιακή προσευχή';

  @override
  String get notifyEvening2Title => '🌙 Κλείνοντας την ημέρα';

  @override
  String get notifyEvening2Body =>
      'Εκφράσε την ευγνωμοσύνη της ημέρας μέσω προσευχής';

  @override
  String get notifyEvening3Title => '🙏 Βραδινή προσευχή';

  @override
  String get notifyEvening3Body => 'Στο τέλος της ημέρας, ευχαρίστησε τον Θεό';

  @override
  String get notifyEvening4Title => '🌟 Μετρώντας τις ευλογίες της ημέρας';

  @override
  String get notifyEvening4Body =>
      'Αν έχεις λόγο ευγνωμοσύνης, μοιράσου τον στην προσευχή';

  @override
  String get notifyStreak3Title => '🌱 3 μέρες συνεχόμενες!';

  @override
  String get notifyStreak3Body => 'Η συνήθεια της προσευχής ξεκίνησε';

  @override
  String get notifyStreak7Title => '🌿 Μια ολόκληρη εβδομάδα!';

  @override
  String get notifyStreak7Body => 'Η προσευχή γίνεται συνήθεια';

  @override
  String get notifyStreak14Title => '🌳 2 εβδομάδες συνεχόμενες!';

  @override
  String get notifyStreak14Body => 'Εκπληκτική ανάπτυξη!';

  @override
  String get notifyStreak21Title => '🌻 3 εβδομάδες συνεχόμενες!';

  @override
  String get notifyStreak21Body => 'Το λουλούδι της προσευχής ανθίζει';

  @override
  String get notifyStreak30Title => '🏆 Έναν ολόκληρο μήνα!';

  @override
  String get notifyStreak30Body => 'Η προσευχή σου λάμπει';

  @override
  String get notifyStreak50Title => '👑 50 μέρες συνεχόμενες!';

  @override
  String get notifyStreak50Body => 'Ο περίπατός σου με τον Θεό βαθαίνει';

  @override
  String get notifyStreak100Title => '🎉 100 μέρες συνεχόμενες!';

  @override
  String get notifyStreak100Body => 'Έγινες πολεμιστής της προσευχής!';

  @override
  String get notifyStreak365Title => '✝️ Έναν ολόκληρο χρόνο!';

  @override
  String get notifyStreak365Body => 'Τι εκπληκτικό ταξίδι πίστης!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ Προσευχήθηκες σήμερα;';

  @override
  String get notifyAfternoonNudgeBody =>
      'Μια σύντομη προσευχή μπορεί να αλλάξει την ημέρα';

  @override
  String get notifyChannelName => 'Υπενθυμίσεις προσευχής';

  @override
  String get notifyChannelDescription =>
      'Πρωινή προσευχή, βραδινή ευγνωμοσύνη και άλλες υπενθυμίσεις';

  @override
  String get milestoneFirstPrayerTitle => 'Πρώτη προσευχή!';

  @override
  String get milestoneFirstPrayerDesc =>
      'Το προσευχητικό ταξίδι σας ξεκίνησε. Ο Θεός ακούει.';

  @override
  String get milestoneSevenDayStreakTitle => '7 ημέρες προσευχής!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'Μια εβδομάδα πιστής προσευχής. Ο κήπος σας μεγαλώνει!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 ημέρες!';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'Ο κήπος σας άνθισε σε ένα λιβάδι λουλουδιών!';

  @override
  String get milestoneHundredPrayersTitle => '100ή προσευχή!';

  @override
  String get milestoneHundredPrayersDesc =>
      'Εκατό συζητήσεις με τον Θεό. Έχετε βαθιές ρίζες.';

  @override
  String get homeFirstPrayerPrompt => 'Ξεκινήστε την πρώτη σας προσευχή';

  @override
  String get homeFirstQtPrompt => 'Ξεκινήστε το πρώτο σας QT';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Κάντε $activityName και σήμερα';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'Ημέρα $count συνεχούς $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'Πέρασαν $days ημέρες από τη τελευταία $activityName';
  }

  @override
  String get homeActivityPrayer => 'προσευχή';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Φόρτωση...';

  @override
  String get heatmapNoPrayer => 'Καμία προσευχή';

  @override
  String get heatmapLegendLess => 'Λιγότερο';

  @override
  String get heatmapLegendMore => 'Περισσότερο';

  @override
  String get qtPassagesLoadError =>
      'Δεν ήταν δυνατή η φόρτωση των σημερινών εδαφίων. Ελέγξτε τη σύνδεση.';

  @override
  String get qtPassagesRetryButton => 'Δοκιμάστε ξανά';

  @override
  String get aiStreamingInitial => 'Στοχαζόμαστε την προσευχή σας...';

  @override
  String get aiTierProcessing => 'Περισσότεροι στοχασμοί έρχονται...';

  @override
  String get aiScriptureValidating => 'Αναζητούμε το σωστό εδάφιο...';

  @override
  String get aiScriptureValidatingFailed =>
      'Ετοιμάζουμε αυτό το εδάφιο για εσάς...';

  @override
  String get aiTemplateFallback => 'Ενώ ετοιμάζουμε την πλήρη ανάλυσή σας...';

  @override
  String get aiPendingMore => 'Ετοιμάζουμε περισσότερα...';

  @override
  String get aiTierIncomplete => 'Έρχεται σύντομα, ελέγξτε αργότερα';

  @override
  String get tierCompleted => 'Προστέθηκε νέος στοχασμός';

  @override
  String get tierProcessingNotice => 'Δημιουργούμε περισσότερους στοχασμούς...';

  @override
  String get proSectionLoading => 'Ετοιμάζουμε το premium περιεχόμενό σας...';

  @override
  String get proSectionWillArrive => 'Ο βαθύς στοχασμός σας θα εμφανιστεί εδώ';

  @override
  String get templateCategoryHealth => 'Για θέματα υγείας';

  @override
  String get templateCategoryFamily => 'Για την οικογένεια';

  @override
  String get templateCategoryWork => 'Για εργασία και σπουδές';

  @override
  String get templateCategoryGratitude => 'Μια ευγνώμων καρδιά';

  @override
  String get templateCategoryGrief => 'Σε θλίψη ή απώλεια';

  @override
  String get sectionStatusCompleted => 'Η ανάλυση ολοκληρώθηκε';

  @override
  String get sectionStatusPartial => 'Μερική ανάλυση (έρχονται περισσότερα)';

  @override
  String get sectionStatusPending => 'Η ανάλυση σε εξέλιξη';

  @override
  String get trialStartCta => 'Start 1 month free';

  @override
  String trialAutoRenewDisclosure(Object price) {
    return 'Then $price/year, auto-renews. Cancel anytime in Settings.';
  }

  @override
  String get trialLimitTitle => 'You\'ve prayed 3 times today 🌸';

  @override
  String get trialLimitBody =>
      'Come back tomorrow — or unlock unlimited prayer with Pro.';

  @override
  String get trialLimitCta => 'Continue with Pro';

  @override
  String get prayerTooShort => 'Please write a little more';

  @override
  String get switchToTextModeTitle => 'Switch to text mode?';

  @override
  String get switchToTextModeBody =>
      'Your voice recording so far will be discarded. You\'ll need to write your prayer as text instead.';

  @override
  String get switchToTextModeConfirm => 'Switch to text';

  @override
  String get switchToTextModeCancel => 'Keep recording';

  @override
  String get recordingInterruptedTitle =>
      'Your prayer recording was interrupted';

  @override
  String get recordingInterruptedBody =>
      'While you were away, the recording stopped. What would you like to do?';

  @override
  String get recordingInterruptedRestart => 'Restart recording';

  @override
  String get recordingInterruptedSwitchToText => 'Write as text instead';

  @override
  String get dashboardPartialFailedQt =>
      'Δεν ήταν δυνατή η φόρτωση μέρους του στοχασμού. Ξεκινήστε έναν νέο στοχασμό.';

  @override
  String get dashboardPartialFailedPrayer =>
      'Δεν ήταν δυνατή η φόρτωση μέρους της ανάλυσης προσευχής. Ξεκινήστε μια νέα προσευχή.';

  @override
  String get dashboardPartialFailedHint =>
      'Ό,τι έχει ήδη αποθηκευτεί παραμένει.';

  @override
  String get deleteAccount => 'Διαγραφή λογαριασμού';

  @override
  String get deleteAccountTitle => 'Διαγραφή του λογαριασμού σας;';

  @override
  String get deleteAccountBody =>
      'Όλα τα δεδομένα σας στο Abba (προσευχές, στοχασμοί, ηχογραφήσεις) θα διαγραφούν οριστικά. Αν δεν χρησιμοποιείτε άλλες εφαρμογές ystech, θα διαγραφεί και ο λογαριασμός σύνδεσής σας.';

  @override
  String get deleteAccountConfirmHint =>
      'Πληκτρολογήστε \'DELETE\' για επιβεβαίωση.';

  @override
  String get deleteAccountFailed =>
      'Δεν ήταν δυνατή η διαγραφή του λογαριασμού. Δοκιμάστε αργότερα.';
}
