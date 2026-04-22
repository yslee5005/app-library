// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'When you pray,\nGod responds.';

  @override
  String get welcomeSubtitle => 'Your daily prayer & quiet time companion';

  @override
  String get getStarted => 'Get Started';

  @override
  String get loginTitle => 'Welcome to Abba';

  @override
  String get loginSubtitle => 'Sign in to begin your prayer journey';

  @override
  String get signInWithApple => 'Continue with Apple';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get signInWithEmail => 'Continue with Email';

  @override
  String greetingMorning(Object name) {
    return 'Good Morning, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Good Afternoon, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Good Evening, $name';
  }

  @override
  String get prayButton => 'Pray';

  @override
  String get qtButton => 'Quiet Time';

  @override
  String streakDays(Object count) {
    return '$count day prayer streak';
  }

  @override
  String get dailyVerse => 'Daily Verse';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCalendar => 'Calendar';

  @override
  String get tabCommunity => 'Community';

  @override
  String get tabSettings => 'Settings';

  @override
  String get recordingTitle => 'Praying...';

  @override
  String get recordingPause => 'Pause';

  @override
  String get recordingResume => 'Resume';

  @override
  String get finishPrayer => 'Finish Prayer';

  @override
  String get finishPrayerConfirm => 'Would you like to finish your prayer?';

  @override
  String get switchToText => 'Type instead';

  @override
  String get textInputHint => 'Type your prayer here...';

  @override
  String get aiLoadingText => 'Reflecting on your prayer...';

  @override
  String get aiLoadingVerse =>
      'Be still, and know that I am God.\n— Psalm 46:10';

  @override
  String get dashboardTitle => 'Prayer Garden';

  @override
  String get shareButton => 'Share';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get scriptureTitle => 'Today\'s Scripture';

  @override
  String get bibleStoryTitle => 'Bible Story';

  @override
  String get testimonyTitle => 'Testimony · My prayer';

  @override
  String get testimonyHelperText =>
      'Reflect on what you prayed · can be shared to community';

  @override
  String get myPrayerAudioLabel => 'My prayer recording';

  @override
  String get testimonyEdit => 'Edit';

  @override
  String get guidanceTitle => 'AI Guidance';

  @override
  String get aiPrayerTitle => 'A Prayer for You';

  @override
  String get originalLangTitle => 'Original Language';

  @override
  String get proUnlock => 'Unlock with Pro';

  @override
  String get qtPageTitle => 'Morning Garden';

  @override
  String get qtMeditateButton => 'Begin Meditation';

  @override
  String get qtCompleted => 'Completed';

  @override
  String get communityTitle => 'Prayer Garden';

  @override
  String get filterAll => 'All';

  @override
  String get filterTestimony => 'Testimony';

  @override
  String get filterPrayerRequest => 'Prayer Request';

  @override
  String get likeButton => 'Like';

  @override
  String get commentButton => 'Comment';

  @override
  String get saveButton => 'Save';

  @override
  String get replyButton => 'Reply';

  @override
  String get writePostTitle => 'Share';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get sharePostButton => 'Share';

  @override
  String get anonymousToggle => 'Anonymous';

  @override
  String get realNameToggle => 'Real Name';

  @override
  String get categoryTestimony => 'Testimony';

  @override
  String get categoryPrayerRequest => 'Prayer Request';

  @override
  String get writePostHint => 'Share your testimony or prayer request...';

  @override
  String get importFromPrayer => 'Import from prayer';

  @override
  String get calendarTitle => 'Prayer Calendar';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get bestStreak => 'Best Streak';

  @override
  String get days => 'days';

  @override
  String calendarRecordCount(Object count) {
    return '$count records';
  }

  @override
  String get todayVerse => 'Today\'s Verse';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profileSection => 'Profile';

  @override
  String get totalPrayers => 'Total Prayers';

  @override
  String get consecutiveDays => 'Consecutive Days';

  @override
  String get proSection => 'Membership';

  @override
  String get freePlan => 'Free';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '\$6.99 / mo';

  @override
  String get yearlyPrice => '\$49.99 / yr';

  @override
  String get yearlySave => 'Save 40%';

  @override
  String get launchPromo => '3 months at \$3.99/mo!';

  @override
  String get startPro => 'Start Pro';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get notificationSetting => 'Notifications';

  @override
  String get languageSetting => 'Language';

  @override
  String get darkModeSetting => 'Dark Mode';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get logout => 'Log Out';

  @override
  String appVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get anonymous => 'Anonymous';

  @override
  String timeAgo(Object time) {
    return '$time ago';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get cancel => 'Cancel';

  @override
  String get noPrayersRecorded => 'No prayers recorded';

  @override
  String get deletePost => 'Delete';

  @override
  String get reportPost => 'Report';

  @override
  String get reportSubmitted => 'Report submitted. Thank you.';

  @override
  String get reportReasonHint =>
      'Please describe the reason for reporting. It will be sent via email.';

  @override
  String get reportReasonPlaceholder => 'Enter the reason for reporting...';

  @override
  String get reportSubmitButton => 'Report';

  @override
  String get deleteConfirmTitle => 'Delete Post';

  @override
  String get deleteConfirmMessage =>
      'Are you sure you want to delete this post?';

  @override
  String get errorNetwork =>
      'Please check your internet connection and try again.';

  @override
  String get errorAiFallback =>
      'We couldn\'t reach AI right now. Here\'s a verse for you.';

  @override
  String get errorSttFailed =>
      'Voice recognition is not available. Please type instead.';

  @override
  String get errorPayment =>
      'There was a problem with payment. Please try again in Settings.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again later.';

  @override
  String get offlineNotice => 'You are offline. Some features may be limited.';

  @override
  String get retryButton => 'Try Again';

  @override
  String get groupSection => 'My Groups';

  @override
  String get createGroup => 'Create a Prayer Group';

  @override
  String get inviteFriends => 'Invite Friends';

  @override
  String get groupInviteMessage =>
      'Let\'s pray together! Join my prayer group on Abba.';

  @override
  String get noGroups => 'Join or create a group to pray together.';

  @override
  String get promoTitle => 'Launch Special';

  @override
  String get promoBanner => 'First 3 months at \$3.99/mo!';

  @override
  String promoEndsOn(Object date) {
    return 'Offer ends $date';
  }

  @override
  String get proLimitTitle => 'Today\'s prayer is complete';

  @override
  String get proLimitBody => 'See you tomorrow!\nPray unlimited with Pro';

  @override
  String get laterButton => 'Maybe later';

  @override
  String get proPromptTitle => 'Pro Feature';

  @override
  String get proPromptBody =>
      'This feature is available with Pro.\nWould you like to see our plans?';

  @override
  String get viewProducts => 'View Plans';

  @override
  String get maybeLater => 'Maybe later';

  @override
  String get proHeadline => 'Closer to God, every day';

  @override
  String get proBenefit1 => 'Unlimited Prayer & QT';

  @override
  String get proBenefit2 => 'AI-powered prayer & guidance';

  @override
  String get proBenefit3 => 'Stories of faith from history';

  @override
  String get proBenefit5 => 'Original language Bible study';

  @override
  String get bestValue => 'BEST VALUE';

  @override
  String get perMonth => 'mo';

  @override
  String get cancelAnytime => 'Cancel anytime';

  @override
  String get restorePurchase => 'Restore purchase';

  @override
  String get yearlyPriceMonthly => '\$4.17/mo';

  @override
  String get morningPrayerReminder => 'Morning Prayer';

  @override
  String get eveningGratitudeReminder => 'Evening Gratitude';

  @override
  String get streakReminder => 'Streak Reminder';

  @override
  String get afternoonNudgeReminder => 'Afternoon Prayer Nudge';

  @override
  String get weeklySummaryReminder => 'Weekly Summary';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get streakRecovery => 'It\'s okay, you can start again 🌱';

  @override
  String get prayerSaved => 'Prayer saved successfully';

  @override
  String get quietTimeLabel => 'Quiet Time';

  @override
  String get morningPrayerLabel => 'Morning Prayer';

  @override
  String get gardenSeed => 'A seed of faith';

  @override
  String get gardenSprout => 'Growing sprout';

  @override
  String get gardenBud => 'Budding flower';

  @override
  String get gardenBloom => 'Full bloom';

  @override
  String get gardenTree => 'Strong tree';

  @override
  String get gardenForest => 'Forest of prayer';

  @override
  String get milestoneShare => 'Share';

  @override
  String get milestoneThankGod => 'Thank God!';

  @override
  String shareStreakText(Object count) {
    return '$count day prayer streak! My prayer journey with Abba #Abba #Prayer';
  }

  @override
  String get shareDaysLabel => 'day prayer streak';

  @override
  String get shareSubtitle => 'Daily prayer with God';

  @override
  String get proActive => 'Membership Active';

  @override
  String get planOncePerDay => '1x/day';

  @override
  String get planUnlimited => 'Unlimited';

  @override
  String get closeRecording => 'Close recording';

  @override
  String get qtRevealMessage => 'Let\'s open today\'s Word';

  @override
  String get qtSelectPrompt => 'Choose one and start today\'s QT';

  @override
  String get qtTopicLabel => 'Topic';

  @override
  String get prayerStartPrompt => 'Start your prayer';

  @override
  String get startPrayerButton => 'Begin Prayer';

  @override
  String get switchToTextMode => 'Type instead';

  @override
  String get switchToVoiceMode => 'Speak instead';

  @override
  String get prayerDashboardTitle => 'Prayer Garden';

  @override
  String get qtDashboardTitle => 'QT Garden';

  @override
  String get prayerSummaryTitle => 'Prayer Summary';

  @override
  String get gratitudeLabel => 'Gratitude';

  @override
  String get petitionLabel => 'Petition';

  @override
  String get intercessionLabel => 'Intercession';

  @override
  String get historicalStoryTitle => 'Story from History';

  @override
  String get todayLesson => 'Today\'s Lesson';

  @override
  String get applicationTitle => 'Today\'s Application';

  @override
  String get applicationWhat => 'What';

  @override
  String get applicationWhen => 'When';

  @override
  String get applicationContext => 'Where';

  @override
  String get applicationMorningLabel => 'Morning';

  @override
  String get applicationDayLabel => 'Day';

  @override
  String get applicationEveningLabel => 'Evening';

  @override
  String get relatedKnowledgeTitle => 'Related Knowledge';

  @override
  String get originalWordLabel => 'Original Word';

  @override
  String get historicalContextLabel => 'Historical Context';

  @override
  String get crossReferencesLabel => 'Cross References';

  @override
  String get growthStoryTitle => 'Growth Story';

  @override
  String get prayerGuideTitle => 'How to pray with Abba';

  @override
  String get prayerGuide1 => 'Pray out loud or in a clear voice';

  @override
  String get prayerGuide2 =>
      'Abba listens to your words and finds Scripture that speaks to your heart';

  @override
  String get prayerGuide3 => 'You can also type your prayer if you prefer';

  @override
  String get qtGuideTitle => 'How to do QT with Abba';

  @override
  String get qtGuide1 => 'Read the passage and meditate quietly';

  @override
  String get qtGuide2 =>
      'Share what you discovered — speak or type your reflection';

  @override
  String get qtGuide3 => 'Abba will help you apply the Word to your daily life';

  @override
  String get scriptureReasonLabel => 'Why this Scripture';

  @override
  String get scripturePostureLabel => 'How should I read it?';

  @override
  String get scriptureOriginalWordsTitle =>
      'Deeper meaning in the original language';

  @override
  String get originalWordMeaningLabel => 'Meaning';

  @override
  String get originalWordNuanceLabel => 'Nuance vs translation';

  @override
  String originalWordsCountLabel(int count) {
    return '$count words';
  }

  @override
  String get seeMore => 'See more';

  @override
  String seeAllComments(Object count) {
    return 'View all $count comments';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name and $count others liked this';
  }

  @override
  String get commentsTitle => 'Comments';

  @override
  String get myPageTitle => 'My Prayer Garden';

  @override
  String get myPrayers => 'My Prayers';

  @override
  String get myTestimonies => 'My Testimonies';

  @override
  String get savedPosts => 'Saved';

  @override
  String get totalPrayersCount => 'Prayers';

  @override
  String get streakCount => 'Streak';

  @override
  String get testimoniesCount => 'Testimonies';

  @override
  String get linkAccountTitle => 'Link Account';

  @override
  String get linkAccountDescription =>
      'Link your account to keep prayer records when switching devices';

  @override
  String get linkWithApple => 'Link with Apple';

  @override
  String get linkWithGoogle => 'Link with Google';

  @override
  String get linkAccountSuccess => 'Account linked successfully!';

  @override
  String get anonymousUser => 'Prayer Warrior';

  @override
  String showReplies(Object count) {
    return 'View $count replies';
  }

  @override
  String get hideReplies => 'Hide replies';

  @override
  String replyingTo(Object name) {
    return 'Replying to $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'View all $count comments';
  }

  @override
  String get membershipTitle => 'Membership';

  @override
  String get membershipSubtitle => 'Deepen your prayer journey';

  @override
  String get monthlyPlan => 'Monthly';

  @override
  String get yearlyPlan => 'Yearly';

  @override
  String get yearlySavings => '\$4.17/mo (40% off)';

  @override
  String get startMembership => 'Get Started';

  @override
  String get membershipActive => 'Membership Active';

  @override
  String get leaveRecordingTitle => 'Leave Recording?';

  @override
  String get leaveRecordingMessage =>
      'Your recording will be lost. Are you sure?';

  @override
  String get leaveButton => 'Leave';

  @override
  String get stayButton => 'Stay';

  @override
  String likedByCount(Object count) {
    return '$count people empathized';
  }

  @override
  String get actionLike => 'Like';

  @override
  String get actionComment => 'Comment';

  @override
  String get actionSave => 'Save';

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
  String get billingIssueTitle => 'Payment issue detected';

  @override
  String billingIssueBody(int days) {
    return 'Your Pro benefits will end in $days days unless payment is updated.';
  }

  @override
  String get billingIssueAction => 'Update payment';

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
      '💛 Love — Think of someone you love for 10 seconds';

  @override
  String get qtLoadingHint2 =>
      '🌿 Grace — Recall one small grace you received today';

  @override
  String get qtLoadingHint3 =>
      '🌅 Hope — Picture tomorrow\'s small hope in your heart';

  @override
  String get qtLoadingHint4 => '🕊️ Peace — Take three slow, deep breaths';

  @override
  String get qtLoadingHint5 => '🌳 Faith — Remember one unchanging truth';

  @override
  String get qtLoadingHint6 =>
      '🌸 Gratitude — Name one thing you\'re thankful for now';

  @override
  String get qtLoadingHint7 =>
      '🌊 Forgiveness — Bring to mind someone to forgive';

  @override
  String get qtLoadingHint8 => '📖 Wisdom — Hold onto one lesson from today';

  @override
  String get qtLoadingHint9 =>
      '⏳ Patience — Think of what you\'re quietly waiting for';

  @override
  String get qtLoadingHint10 => '✨ Joy — Remember a moment you smiled today';

  @override
  String get qtLoadingTitle => 'Preparing today\'s Word...';

  @override
  String get coachingTitle => 'Prayer Coaching';

  @override
  String get coachingLoadingText => 'Reflecting on your prayer...';

  @override
  String get coachingErrorText => 'Temporary error — please retry';

  @override
  String get coachingRetryButton => 'Retry';

  @override
  String get coachingScoreSpecificity => 'Specificity';

  @override
  String get coachingScoreGodCentered => 'God-centered';

  @override
  String get coachingScoreActs => 'ACTS balance';

  @override
  String get coachingScoreAuthenticity => 'Authenticity';

  @override
  String get coachingStrengthsTitle => 'What you did well ✨';

  @override
  String get coachingImprovementsTitle => 'To go deeper 💡';

  @override
  String get coachingProCta => 'Unlock Prayer Coaching with Pro';

  @override
  String get coachingLevelBeginner => '🌱 Beginner';

  @override
  String get coachingLevelGrowing => '🌿 Growing';

  @override
  String get coachingLevelExpert => '🌳 Expert';

  @override
  String get aiPrayerCitationsTitle => 'References · Citations';

  @override
  String get citationTypeQuote => 'Quote';

  @override
  String get citationTypeScience => 'Research';

  @override
  String get citationTypeExample => 'Example';

  @override
  String get citationTypeHistory => 'History';

  @override
  String get aiPrayerReadingTime => '2-minute read';

  @override
  String get scriptureKeyWordHintTitle => 'Today\'s Key Word';

  @override
  String get bibleLookupReferenceHint =>
      'Find this passage in your Bible and meditate on it.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Bible Translations';

  @override
  String get settingsBibleTranslationsIntro =>
      'Bible verses in this app come from Public Domain translations. AI commentary, prayers, and stories are Abba\'s creative work.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'QT Coaching';

  @override
  String get qtCoachingLoadingText => 'Reflecting on your meditation...';

  @override
  String get qtCoachingErrorText => 'Temporary error — please retry';

  @override
  String get qtCoachingRetryButton => 'Retry';

  @override
  String get qtCoachingScoreComprehension => 'Scripture Comprehension';

  @override
  String get qtCoachingScoreApplication => 'Personal Application';

  @override
  String get qtCoachingScoreDepth => 'Spiritual Depth';

  @override
  String get qtCoachingScoreAuthenticity => 'Authenticity';

  @override
  String get qtCoachingStrengthsTitle => 'What you did well ✨';

  @override
  String get qtCoachingImprovementsTitle => 'To go deeper 💡';

  @override
  String get qtCoachingProCta => 'Unlock QT Coaching with Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Beginner';

  @override
  String get qtCoachingLevelGrowing => '🌿 Growing';

  @override
  String get qtCoachingLevelExpert => '🌳 Expert';

  @override
  String get notifyMorning1Title => '🙏 Time to pray';

  @override
  String notifyMorning1Body(String name) {
    return '$name, talk with God today as well';
  }

  @override
  String get notifyMorning2Title => '🌅 A new morning has come';

  @override
  String notifyMorning2Body(String name) {
    return '$name, start the day with gratitude';
  }

  @override
  String get notifyMorning3Title => '✨ Today\'s grace';

  @override
  String notifyMorning3Body(String name) {
    return '$name, meet the grace God has prepared';
  }

  @override
  String get notifyMorning4Title => '🕊️ Peaceful morning';

  @override
  String notifyMorning4Body(String name) {
    return '$name, fill your heart with peace through prayer';
  }

  @override
  String get notifyMorning5Title => '📖 With the Word';

  @override
  String notifyMorning5Body(String name) {
    return '$name, listen to God\'s voice today';
  }

  @override
  String get notifyMorning6Title => '🌿 Time to rest';

  @override
  String notifyMorning6Body(String name) {
    return '$name, pause for a moment and pray';
  }

  @override
  String get notifyMorning7Title => '💫 Today as well';

  @override
  String notifyMorning7Body(String name) {
    return '$name, a day that begins with prayer is different';
  }

  @override
  String get notifyEvening1Title => '✨ Thankful for today';

  @override
  String get notifyEvening1Body =>
      'Look back on today and offer a prayer of thanks';

  @override
  String get notifyEvening2Title => '🌙 Wrapping up the day';

  @override
  String get notifyEvening2Body => 'Express today\'s gratitude through prayer';

  @override
  String get notifyEvening3Title => '🙏 Evening prayer';

  @override
  String get notifyEvening3Body => 'At the end of the day, give thanks to God';

  @override
  String get notifyEvening4Title => '🌟 Counting today\'s blessings';

  @override
  String get notifyEvening4Body =>
      'If you have something to be thankful for, share it in prayer';

  @override
  String get notifyStreak3Title => '🌱 3 days in a row!';

  @override
  String get notifyStreak3Body => 'Your prayer habit has begun';

  @override
  String get notifyStreak7Title => '🌿 A full week!';

  @override
  String get notifyStreak7Body => 'Prayer is becoming a habit';

  @override
  String get notifyStreak14Title => '🌳 2 weeks in a row!';

  @override
  String get notifyStreak14Body => 'Amazing growth!';

  @override
  String get notifyStreak21Title => '🌻 3 weeks in a row!';

  @override
  String get notifyStreak21Body => 'The flower of prayer is blooming';

  @override
  String get notifyStreak30Title => '🏆 A full month!';

  @override
  String get notifyStreak30Body => 'Your prayer is shining';

  @override
  String get notifyStreak50Title => '👑 50 days in a row!';

  @override
  String get notifyStreak50Body => 'Your walk with God is deepening';

  @override
  String get notifyStreak100Title => '🎉 100 days in a row!';

  @override
  String get notifyStreak100Body => 'You\'ve become a prayer warrior!';

  @override
  String get notifyStreak365Title => '✝️ A full year!';

  @override
  String get notifyStreak365Body => 'What an amazing journey of faith!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ Have you prayed today?';

  @override
  String get notifyAfternoonNudgeBody => 'A brief prayer can change the day';

  @override
  String get notifyChannelName => 'Prayer Reminders';

  @override
  String get notifyChannelDescription =>
      'Morning prayer, evening gratitude, and other prayer reminders';

  @override
  String get milestoneFirstPrayerTitle => 'First Prayer!';

  @override
  String get milestoneFirstPrayerDesc =>
      'Your prayer journey has begun. God is listening.';

  @override
  String get milestoneSevenDayStreakTitle => '7 Days of Prayer!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'A week of faithful prayer. Your garden is growing!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 Days!';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'Your garden has blossomed into a flower field!';

  @override
  String get milestoneHundredPrayersTitle => '100th Prayer!';

  @override
  String get milestoneHundredPrayersDesc =>
      'A hundred conversations with God. You are deeply rooted.';

  @override
  String get homeFirstPrayerPrompt => 'Start your first prayer';

  @override
  String get homeFirstQtPrompt => 'Start your first QT';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Pray $activityName today as well';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'Day $count of continuous $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'It\'s been $days days since your last $activityName';
  }

  @override
  String get homeActivityPrayer => 'prayer';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Loading...';

  @override
  String get heatmapNoPrayer => 'No prayer';

  @override
  String get qtPassagesLoadError =>
      'Couldn\'t load today\'s passages. Please check your connection.';

  @override
  String get qtPassagesRetryButton => 'Try again';
}
