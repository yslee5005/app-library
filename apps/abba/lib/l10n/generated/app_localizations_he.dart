// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'כשאתה מתפלל,\nאלוהים עונה.';

  @override
  String get welcomeSubtitle => 'בן הלוויה היומי שלך לתפילה ושעת שקט';

  @override
  String get getStarted => 'התחל';

  @override
  String get loginTitle => 'ברוכים הבאים ל-Abba';

  @override
  String get loginSubtitle => 'התחבר כדי להתחיל את מסע התפילה שלך';

  @override
  String get signInWithApple => 'המשך עם Apple';

  @override
  String get signInWithGoogle => 'המשך עם Google';

  @override
  String get signInWithEmail => 'המשך עם אימייל';

  @override
  String greetingMorning(Object name) {
    return 'בוקר טוב, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'צהריים טובים, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'ערב טוב, $name';
  }

  @override
  String get prayButton => 'התפלל';

  @override
  String get qtButton => 'שעת שקט';

  @override
  String streakDays(Object count) {
    return '$count ימי תפילה רצופים';
  }

  @override
  String get dailyVerse => 'פסוק היום';

  @override
  String get tabHome => 'בית';

  @override
  String get tabCalendar => 'לוח שנה';

  @override
  String get tabCommunity => 'קהילה';

  @override
  String get tabSettings => 'הגדרות';

  @override
  String get recordingTitle => 'מתפלל...';

  @override
  String get recordingPause => 'השהה';

  @override
  String get recordingResume => 'המשך';

  @override
  String get finishPrayer => 'סיים תפילה';

  @override
  String get finishPrayerConfirm => 'האם תרצה לסיים את התפילה?';

  @override
  String get switchToText => 'הקלד במקום';

  @override
  String get textInputHint => 'כתוב את תפילתך כאן...';

  @override
  String get aiLoadingText => 'מתבונן בתפילתך...';

  @override
  String get aiLoadingVerse =>
      'הַרְפּוּ וּדְעוּ כִּי אָנֹכִי אֱלֹהִים.\n— תהילים 46:10';

  @override
  String get dashboardTitle => 'גן התפילה';

  @override
  String get shareButton => 'שתף';

  @override
  String get backToHome => 'חזרה לבית';

  @override
  String get scriptureTitle => 'הכתוב של היום';

  @override
  String get bibleStoryTitle => 'סיפור מהתנ\"ך';

  @override
  String get testimonyTitle => 'עדות · תפילתי';

  @override
  String get testimonyHelperText => 'הרהור על תפילתך · ניתן לשתף עם הקהילה';

  @override
  String get myPrayerAudioLabel => 'הקלטת התפילה שלי';

  @override
  String get testimonyEdit => 'ערוך';

  @override
  String get guidanceTitle => 'הדרכת AI';

  @override
  String get aiPrayerTitle => 'תפילה בשבילך';

  @override
  String get originalLangTitle => 'שפת המקור';

  @override
  String get proUnlock => 'פתח עם Pro';

  @override
  String get qtPageTitle => 'גן הבוקר';

  @override
  String get qtMeditateButton => 'התחל התבוננות';

  @override
  String get qtCompleted => 'הושלם';

  @override
  String get communityTitle => 'גן התפילה';

  @override
  String get filterAll => 'הכל';

  @override
  String get filterTestimony => 'עדות';

  @override
  String get filterPrayerRequest => 'בקשת תפילה';

  @override
  String get likeButton => 'אהבתי';

  @override
  String get commentButton => 'תגובה';

  @override
  String get saveButton => 'שמור';

  @override
  String get replyButton => 'השב';

  @override
  String get writePostTitle => 'שתף';

  @override
  String get cancelButton => 'ביטול';

  @override
  String get sharePostButton => 'פרסם';

  @override
  String get anonymousToggle => 'אנונימי';

  @override
  String get realNameToggle => 'שם אמיתי';

  @override
  String get categoryTestimony => 'עדות';

  @override
  String get categoryPrayerRequest => 'בקשת תפילה';

  @override
  String get writePostHint => 'שתף את העדות או בקשת התפילה שלך...';

  @override
  String get importFromPrayer => 'ייבא מתפילה';

  @override
  String get calendarTitle => 'לוח תפילה';

  @override
  String get currentStreak => 'רצף נוכחי';

  @override
  String get bestStreak => 'רצף שיא';

  @override
  String get days => 'ימים';

  @override
  String calendarRecordCount(Object count) {
    return '$count רשומות';
  }

  @override
  String get todayVerse => 'פסוק היום';

  @override
  String get settingsTitle => 'הגדרות';

  @override
  String get profileSection => 'פרופיל';

  @override
  String get totalPrayers => 'סה\"כ תפילות';

  @override
  String get consecutiveDays => 'ימים רצופים';

  @override
  String get proSection => 'מנוי';

  @override
  String get freePlan => 'חינם';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '₪24.90 / חודש';

  @override
  String get yearlyPrice => '₪179.90 / שנה';

  @override
  String get yearlySave => 'חסכון 40%';

  @override
  String get launchPromo => '3 חודשים ב-₪14.90/חודש!';

  @override
  String get startPro => 'התחל Pro';

  @override
  String get comingSoon => 'בקרוב';

  @override
  String get notificationSetting => 'התראות';

  @override
  String get languageSetting => 'שפה';

  @override
  String get darkModeSetting => 'מצב כהה';

  @override
  String get helpCenter => 'מרכז עזרה';

  @override
  String get termsOfService => 'תנאי שימוש';

  @override
  String get privacyPolicy => 'מדיניות פרטיות';

  @override
  String get logout => 'התנתק';

  @override
  String appVersion(Object version) {
    return 'גרסה $version';
  }

  @override
  String get anonymous => 'אנונימי';

  @override
  String timeAgo(Object time) {
    return 'לפני $time';
  }

  @override
  String get emailLabel => 'אימייל';

  @override
  String get passwordLabel => 'סיסמה';

  @override
  String get signIn => 'התחבר';

  @override
  String get cancel => 'ביטול';

  @override
  String get noPrayersRecorded => 'אין תפילות מוקלטות';

  @override
  String get deletePost => 'מחק';

  @override
  String get reportPost => 'דווח';

  @override
  String get reportSubmitted => 'הדיווח נשלח. תודה.';

  @override
  String get reportReasonHint =>
      'אנא תאר את סיבת הדיווח. הדיווח יישלח בדוא\"ל.';

  @override
  String get reportReasonPlaceholder => 'הזן את סיבת הדיווח...';

  @override
  String get reportSubmitButton => 'דווח';

  @override
  String get deleteConfirmTitle => 'מחק פוסט';

  @override
  String get deleteConfirmMessage => 'האם אתה בטוח שברצונך למחוק פוסט זה?';

  @override
  String get errorNetwork => 'אנא בדוק את חיבור האינטרנט ונסה שוב.';

  @override
  String get errorAiFallback => 'לא הצלחנו להתחבר ל-AI כרגע. הנה פסוק בשבילך.';

  @override
  String get errorSttFailed => 'זיהוי קולי אינו זמין. אנא הקלד במקום.';

  @override
  String get errorPayment => 'אירעה בעיה בתשלום. אנא נסה שוב בהגדרות.';

  @override
  String get errorGeneric => 'משהו השתבש. אנא נסה שוב מאוחר יותר.';

  @override
  String get offlineNotice =>
      'אתה במצב לא מקוון. חלק מהתכונות עשויות להיות מוגבלות.';

  @override
  String get retryButton => 'נסה שוב';

  @override
  String get groupSection => 'הקבוצות שלי';

  @override
  String get createGroup => 'צור קבוצת תפילה';

  @override
  String get inviteFriends => 'הזמן חברים';

  @override
  String get groupInviteMessage =>
      'בואו נתפלל יחד! הצטרפו לקבוצת התפילה שלי ב-Abba.';

  @override
  String get noGroups => 'הצטרף או צור קבוצה להתפלל יחד.';

  @override
  String get promoTitle => 'מבצע השקה';

  @override
  String get promoBanner => '3 חודשים ראשונים ב-₪14.90/חודש!';

  @override
  String promoEndsOn(Object date) {
    return 'המבצע נגמר ב-$date';
  }

  @override
  String get proLimitTitle => 'תפילת היום הושלמה';

  @override
  String get proLimitBody => 'נתראה מחר!\nתתפלל ללא הגבלה עם Pro';

  @override
  String get laterButton => 'אולי מאוחר יותר';

  @override
  String get proPromptTitle => 'תכונת Pro';

  @override
  String get proPromptBody =>
      'תכונה זו זמינה עם Pro.\nהאם תרצה לראות את התוכניות?';

  @override
  String get viewProducts => 'צפה בתוכניות';

  @override
  String get maybeLater => 'אולי מאוחר יותר';

  @override
  String get proHeadline => 'קרוב יותר לאלוהים, כל יום';

  @override
  String get proBenefit1 => 'תפילה ושעת שקט ללא הגבלה';

  @override
  String get proBenefit2 => 'תפילה והדרכה מונעת AI';

  @override
  String get proBenefit3 => 'סיפורי אמונה מההיסטוריה';

  @override
  String get proBenefit5 => 'לימוד תנ\"ך בשפת המקור';

  @override
  String get bestValue => 'הערך הטוב ביותר';

  @override
  String get perMonth => 'חודש';

  @override
  String get cancelAnytime => 'ביטול בכל עת';

  @override
  String get restorePurchase => 'שחזר רכישה';

  @override
  String get yearlyPriceMonthly => '₪15/חודש';

  @override
  String get morningPrayerReminder => 'תפילת בוקר';

  @override
  String get eveningGratitudeReminder => 'הודיה ערבית';

  @override
  String get streakReminder => 'תזכורת רצף';

  @override
  String get afternoonNudgeReminder => 'תזכורת תפילת צהריים';

  @override
  String get weeklySummaryReminder => 'סיכום שבועי';

  @override
  String get unlimited => 'ללא הגבלה';

  @override
  String get streakRecovery => 'זה בסדר, אפשר להתחיל מחדש 🌱';

  @override
  String get prayerSaved => 'התפילה נשמרה בהצלחה';

  @override
  String get quietTimeLabel => 'שעת שקט';

  @override
  String get morningPrayerLabel => 'תפילת בוקר';

  @override
  String get gardenSeed => 'זרע אמונה';

  @override
  String get gardenSprout => 'נבט צומח';

  @override
  String get gardenBud => 'ניצן פורח';

  @override
  String get gardenBloom => 'פריחה מלאה';

  @override
  String get gardenTree => 'עץ חזק';

  @override
  String get gardenForest => 'יער התפילה';

  @override
  String get milestoneShare => 'שתף';

  @override
  String get milestoneThankGod => 'תודה לאל!';

  @override
  String shareStreakText(Object count) {
    return '$count ימי תפילה רצופים! מסע התפילה שלי עם Abba #Abba #תפילה';
  }

  @override
  String get shareDaysLabel => 'ימי תפילה רצופים';

  @override
  String get shareSubtitle => 'תפילה יומית עם אלוהים';

  @override
  String get proActive => 'מנוי פעיל';

  @override
  String get planOncePerDay => 'פעם/יום';

  @override
  String get planUnlimited => 'ללא הגבלה';

  @override
  String get closeRecording => 'סגור הקלטה';

  @override
  String get qtRevealMessage => 'בואו נפתח את דבר היום';

  @override
  String get qtSelectPrompt => 'בחר נושא והתחל את שעת השקט של היום';

  @override
  String get qtTopicLabel => 'נושא';

  @override
  String get prayerStartPrompt => 'התחל את תפילתך';

  @override
  String get startPrayerButton => 'התחל תפילה';

  @override
  String get switchToTextMode => 'הקלד במקום';

  @override
  String get switchToVoiceMode => 'דבר במקום';

  @override
  String get prayerDashboardTitle => 'גן התפילה';

  @override
  String get qtDashboardTitle => 'גן שעת השקט';

  @override
  String get prayerSummaryTitle => 'סיכום תפילה';

  @override
  String get gratitudeLabel => 'הודיה';

  @override
  String get petitionLabel => 'בקשה';

  @override
  String get intercessionLabel => 'תפילת שפיכת לב';

  @override
  String get historicalStoryTitle => 'סיפור מההיסטוריה';

  @override
  String get todayLesson => 'לקח היום';

  @override
  String get applicationTitle => 'יישום להיום';

  @override
  String get applicationWhat => 'מה';

  @override
  String get applicationWhen => 'מתי';

  @override
  String get applicationContext => 'איפה';

  @override
  String get applicationMorningLabel => 'בוקר';

  @override
  String get applicationDayLabel => 'יום';

  @override
  String get applicationEveningLabel => 'ערב';

  @override
  String get relatedKnowledgeTitle => 'ידע קשור';

  @override
  String get originalWordLabel => 'מילת המקור';

  @override
  String get historicalContextLabel => 'הקשר היסטורי';

  @override
  String get crossReferencesLabel => 'הפניות צולבות';

  @override
  String get growthStoryTitle => 'סיפור צמיחה';

  @override
  String get prayerGuideTitle => 'איך להתפלל עם Abba';

  @override
  String get prayerGuide1 => 'התפלל בקול רם וברור';

  @override
  String get prayerGuide2 => 'Abba מקשיב לתפילתך ומוצא פסוקים שנוגעים ללבך';

  @override
  String get prayerGuide3 => 'אתה יכול גם להקליד את תפילתך';

  @override
  String get qtGuideTitle => 'איך לעשות שעת שקט עם Abba';

  @override
  String get qtGuide1 => 'קרא את הקטע והתבונן בשקט';

  @override
  String get qtGuide2 => 'שתף את מה שגילית — דבר או הקלד את ההתבוננות שלך';

  @override
  String get qtGuide3 => 'Abba יעזור לך ליישם את הדבר בחיי היומיום';

  @override
  String get scriptureReasonLabel => 'למה פסוק זה';

  @override
  String get scripturePostureLabel => 'באיזו גישה לקרוא את זה?';

  @override
  String get scriptureOriginalWordsTitle => 'משמעות עמוקה יותר בשפת המקור';

  @override
  String get originalWordMeaningLabel => 'משמעות';

  @override
  String get originalWordNuanceLabel => 'ניואנס לעומת תרגום';

  @override
  String originalWordsCountLabel(int count) {
    return '$count מילים';
  }

  @override
  String get seeMore => 'ראה עוד';

  @override
  String seeAllComments(Object count) {
    return 'צפה בכל $count התגובות';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name ועוד $count אהבו את זה';
  }

  @override
  String get commentsTitle => 'תגובות';

  @override
  String get myPageTitle => 'גן התפילה שלי';

  @override
  String get myPrayers => 'התפילות שלי';

  @override
  String get myTestimonies => 'העדויות שלי';

  @override
  String get savedPosts => 'שמורים';

  @override
  String get totalPrayersCount => 'תפילות';

  @override
  String get streakCount => 'רצף';

  @override
  String get testimoniesCount => 'עדויות';

  @override
  String get linkAccountTitle => 'קשר חשבון';

  @override
  String get linkAccountDescription =>
      'קשר את חשבונך כדי לשמור רשומות תפילה בעת החלפת מכשיר';

  @override
  String get linkWithApple => 'קשר עם Apple';

  @override
  String get linkWithGoogle => 'קשר עם Google';

  @override
  String get linkAccountSuccess => 'החשבון קושר בהצלחה!';

  @override
  String get anonymousUser => 'לוחם תפילה';

  @override
  String showReplies(Object count) {
    return 'הצג $count תשובות';
  }

  @override
  String get hideReplies => 'הסתר תשובות';

  @override
  String replyingTo(Object name) {
    return 'משיב ל-$name';
  }

  @override
  String viewAllComments(Object count) {
    return 'צפה בכל $count התגובות';
  }

  @override
  String get membershipTitle => 'מנוי';

  @override
  String get membershipSubtitle => 'העמיקו את חיי התפילה שלכם';

  @override
  String get monthlyPlan => 'חודשי';

  @override
  String get yearlyPlan => 'שנתי';

  @override
  String get yearlySavings => '₪9.90/חודש (הנחה 40%)';

  @override
  String get startMembership => 'התחל';

  @override
  String get membershipActive => 'מנוי פעיל';

  @override
  String get leaveRecordingTitle => 'לעזוב את ההקלטה?';

  @override
  String get leaveRecordingMessage => 'ההקלטה שלך תאבד. בטוח?';

  @override
  String get leaveButton => 'עזוב';

  @override
  String get stayButton => 'הישאר';

  @override
  String likedByCount(Object count) {
    return '$count אנשים הזדהו';
  }

  @override
  String get actionLike => 'אהבתי';

  @override
  String get actionComment => 'תגובה';

  @override
  String get actionSave => 'שמירה';

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
  String get billingIssueTitle => 'זוהתה בעיית תשלום';

  @override
  String billingIssueBody(int days) {
    return 'הטבות Pro שלך יסתיימו בעוד $days ימים אם אמצעי התשלום לא יעודכן.';
  }

  @override
  String get billingIssueAction => 'עדכן תשלום';

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
      '💛 אהבה — חשוב על מישהו שאתה אוהב למשך 10 שניות';

  @override
  String get qtLoadingHint2 => '🌿 חסד — היזכר בחסד קטן שקיבלת היום';

  @override
  String get qtLoadingHint3 => '🌅 תקווה — דמיין תקווה קטנה למחר';

  @override
  String get qtLoadingHint4 => '🕊️ שלום — נשום עמוק שלוש פעמים, לאט';

  @override
  String get qtLoadingHint5 => '🌳 אמונה — זכור אמת אחת שאינה משתנה';

  @override
  String get qtLoadingHint6 => '🌸 הודיה — ציין דבר אחד שאתה מודה עליו עכשיו';

  @override
  String get qtLoadingHint7 => '🌊 סליחה — העלה בזיכרונך מישהו לסלוח לו';

  @override
  String get qtLoadingHint8 => '📖 חכמה — שמור בלבך לקח אחד מהיום';

  @override
  String get qtLoadingHint9 => '⏳ סבלנות — חשוב על מה שאתה מחכה לו בשקט';

  @override
  String get qtLoadingHint10 => '✨ שמחה — זכור רגע של חיוך היום';

  @override
  String get qtLoadingTitle => 'מכין את דבר היום...';

  @override
  String get coachingTitle => 'אימון תפילה';

  @override
  String get coachingLoadingText => 'מהרהרים בתפילתך...';

  @override
  String get coachingErrorText => 'שגיאה זמנית — נא נסה שוב';

  @override
  String get coachingRetryButton => 'נסה שוב';

  @override
  String get coachingScoreSpecificity => 'ספציפיות';

  @override
  String get coachingScoreGodCentered => 'מרכזיות אלוהים';

  @override
  String get coachingScoreActs => 'איזון ACTS';

  @override
  String get coachingScoreAuthenticity => 'אותנטיות';

  @override
  String get coachingStrengthsTitle => 'מה עשית טוב ✨';

  @override
  String get coachingImprovementsTitle => 'כדי להעמיק 💡';

  @override
  String get coachingProCta => 'פתחו אימון תפילה עם Pro';

  @override
  String get coachingLevelBeginner => '🌱 מתחיל';

  @override
  String get coachingLevelGrowing => '🌿 צומח';

  @override
  String get coachingLevelExpert => '🌳 מומחה';

  @override
  String get aiPrayerCitationsTitle => 'הפניות · ציטוטים';

  @override
  String get citationTypeQuote => 'ציטוט';

  @override
  String get citationTypeScience => 'מחקר';

  @override
  String get citationTypeExample => 'דוגמה';

  @override
  String get citationTypeHistory => 'היסטוריה';

  @override
  String get aiPrayerReadingTime => 'קריאה בת 2 דקות';

  @override
  String get scriptureKeyWordHintTitle => 'מילת המפתח של היום';

  @override
  String get bibleLookupReferenceHint => 'חפשו את הקטע הזה בתנ״ך שלכם והגו בו.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'תרגומי המקרא';

  @override
  String get settingsBibleTranslationsIntro =>
      'פסוקי המקרא באפליקציה זו מגיעים מתרגומים בנחלת הכלל. פרשנויות, תפילות וסיפורים שנוצרו על ידי בינה מלאכותית הם יצירה של Abba.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'אימון QT';

  @override
  String get qtCoachingLoadingText => 'מהרהרים בהגותך...';

  @override
  String get qtCoachingErrorText => 'שגיאה זמנית — נא נסה שוב';

  @override
  String get qtCoachingRetryButton => 'נסה שוב';

  @override
  String get qtCoachingScoreComprehension => 'הבנת הכתוב';

  @override
  String get qtCoachingScoreApplication => 'יישום אישי';

  @override
  String get qtCoachingScoreDepth => 'עומק רוחני';

  @override
  String get qtCoachingScoreAuthenticity => 'אותנטיות';

  @override
  String get qtCoachingStrengthsTitle => 'מה עשית טוב ✨';

  @override
  String get qtCoachingImprovementsTitle => 'כדי להעמיק 💡';

  @override
  String get qtCoachingProCta => 'פתחו אימון QT עם Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 מתחיל';

  @override
  String get qtCoachingLevelGrowing => '🌿 צומח';

  @override
  String get qtCoachingLevelExpert => '🌳 מומחה';

  @override
  String get notifyMorning1Title => '🙏 זמן להתפלל';

  @override
  String notifyMorning1Body(String name) {
    return '$name, שוחח עם אלוהים גם היום';
  }

  @override
  String get notifyMorning2Title => '🌅 בוקר חדש הגיע';

  @override
  String notifyMorning2Body(String name) {
    return '$name, התחל את היום בתודה';
  }

  @override
  String get notifyMorning3Title => '✨ החסד של היום';

  @override
  String notifyMorning3Body(String name) {
    return '$name, פגוש את החסד שאלוהים הכין';
  }

  @override
  String get notifyMorning4Title => '🕊️ בוקר שליו';

  @override
  String notifyMorning4Body(String name) {
    return '$name, מלא את הלב בשלום דרך התפילה';
  }

  @override
  String get notifyMorning5Title => '📖 עם הדבר';

  @override
  String notifyMorning5Body(String name) {
    return '$name, הקשב לקולו של אלוהים היום';
  }

  @override
  String get notifyMorning6Title => '🌿 זמן למנוחה';

  @override
  String notifyMorning6Body(String name) {
    return '$name, עצור לרגע והתפלל';
  }

  @override
  String get notifyMorning7Title => '💫 גם היום';

  @override
  String notifyMorning7Body(String name) {
    return '$name, יום שמתחיל בתפילה הוא שונה';
  }

  @override
  String get notifyEvening1Title => '✨ תודה על היום';

  @override
  String get notifyEvening1Body => 'הבט אחורה על היום והתפלל תפילת תודה';

  @override
  String get notifyEvening2Title => '🌙 מסיימים את היום';

  @override
  String get notifyEvening2Body => 'הבע את תודת היום בתפילה';

  @override
  String get notifyEvening3Title => '🙏 תפילת ערב';

  @override
  String get notifyEvening3Body => 'בסוף היום, הודה לאלוהים';

  @override
  String get notifyEvening4Title => '🌟 סופרים את ברכות היום';

  @override
  String get notifyEvening4Body => 'אם יש לך על מה להודות, שתף בתפילה';

  @override
  String get notifyStreak3Title => '🌱 3 ימים ברציפות!';

  @override
  String get notifyStreak3Body => 'הרגל התפילה שלך החל';

  @override
  String get notifyStreak7Title => '🌿 שבוע שלם!';

  @override
  String get notifyStreak7Body => 'התפילה הופכת להרגל';

  @override
  String get notifyStreak14Title => '🌳 שבועיים ברציפות!';

  @override
  String get notifyStreak14Body => 'צמיחה מדהימה!';

  @override
  String get notifyStreak21Title => '🌻 3 שבועות ברציפות!';

  @override
  String get notifyStreak21Body => 'פרח התפילה פורח';

  @override
  String get notifyStreak30Title => '🏆 חודש שלם!';

  @override
  String get notifyStreak30Body => 'התפילה שלך זורחת';

  @override
  String get notifyStreak50Title => '👑 50 ימים ברציפות!';

  @override
  String get notifyStreak50Body => 'ההליכה שלך עם אלוהים מעמיקה';

  @override
  String get notifyStreak100Title => '🎉 100 ימים ברציפות!';

  @override
  String get notifyStreak100Body => 'הפכת ללוחם תפילה!';

  @override
  String get notifyStreak365Title => '✝️ שנה שלמה!';

  @override
  String get notifyStreak365Body => 'איזו מסע אמונה מדהים!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ התפללת היום?';

  @override
  String get notifyAfternoonNudgeBody => 'תפילה קצרה יכולה לשנות את היום';

  @override
  String get notifyChannelName => 'תזכורות תפילה';

  @override
  String get notifyChannelDescription =>
      'תפילת בוקר, הודיית ערב ותזכורות תפילה נוספות';

  @override
  String get milestoneFirstPrayerTitle => 'תפילה ראשונה!';

  @override
  String get milestoneFirstPrayerDesc => 'מסע התפילה שלך החל. אלוהים מקשיב.';

  @override
  String get milestoneSevenDayStreakTitle => '7 ימים של תפילה!';

  @override
  String get milestoneSevenDayStreakDesc => 'שבוע של תפילה נאמנה. הגן שלך גדל!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 ימים!';

  @override
  String get milestoneThirtyDayStreakDesc => 'הגן שלך פרח לשדה פרחים!';

  @override
  String get milestoneHundredPrayersTitle => 'התפילה ה-100!';

  @override
  String get milestoneHundredPrayersDesc =>
      'מאה שיחות עם אלוהים. אתה מושרש עמוק.';

  @override
  String get homeFirstPrayerPrompt => 'התחל את התפילה הראשונה שלך';

  @override
  String get homeFirstQtPrompt => 'התחל את ה-QT הראשון שלך';

  @override
  String homeActivityPrompt(String activityName) {
    return 'גם היום $activityName';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'יום $count רצוף של $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'עברו $days ימים מה$activityName האחרונה';
  }

  @override
  String get homeActivityPrayer => 'תפילה';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'טוען...';

  @override
  String get heatmapNoPrayer => 'אין תפילה';
}
