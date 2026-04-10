import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Abba'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'When you pray,\nGod responds.'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your daily prayer & quiet time companion'**
  String get welcomeSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Abba'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to begin your prayer journey'**
  String get loginSubtitle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get signInWithApple;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get signInWithEmail;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning, {name}'**
  String greetingMorning(Object name);

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon, {name}'**
  String greetingAfternoon(Object name);

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening, {name}'**
  String greetingEvening(Object name);

  /// No description provided for @prayButton.
  ///
  /// In en, this message translates to:
  /// **'Pray'**
  String get prayButton;

  /// No description provided for @qtButton.
  ///
  /// In en, this message translates to:
  /// **'Quiet Time'**
  String get qtButton;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} day prayer streak'**
  String streakDays(Object count);

  /// No description provided for @dailyVerse.
  ///
  /// In en, this message translates to:
  /// **'Daily Verse'**
  String get dailyVerse;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get tabCalendar;

  /// No description provided for @tabCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get tabCommunity;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @recordingTitle.
  ///
  /// In en, this message translates to:
  /// **'Praying...'**
  String get recordingTitle;

  /// No description provided for @recordingPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get recordingPause;

  /// No description provided for @recordingResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get recordingResume;

  /// No description provided for @finishPrayer.
  ///
  /// In en, this message translates to:
  /// **'Finish Prayer'**
  String get finishPrayer;

  /// No description provided for @finishPrayerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Would you like to finish your prayer?'**
  String get finishPrayerConfirm;

  /// No description provided for @switchToText.
  ///
  /// In en, this message translates to:
  /// **'Type instead'**
  String get switchToText;

  /// No description provided for @textInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type your prayer here...'**
  String get textInputHint;

  /// No description provided for @aiLoadingText.
  ///
  /// In en, this message translates to:
  /// **'Reflecting on your prayer...'**
  String get aiLoadingText;

  /// No description provided for @aiLoadingVerse.
  ///
  /// In en, this message translates to:
  /// **'Be still, and know that I am God.\n— Psalm 46:10'**
  String get aiLoadingVerse;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Garden'**
  String get dashboardTitle;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButton;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @scriptureTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Scripture'**
  String get scriptureTitle;

  /// No description provided for @bibleStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Bible Story'**
  String get bibleStoryTitle;

  /// No description provided for @testimonyTitle.
  ///
  /// In en, this message translates to:
  /// **'My Testimony'**
  String get testimonyTitle;

  /// No description provided for @testimonyEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get testimonyEdit;

  /// No description provided for @guidanceTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Guidance'**
  String get guidanceTitle;

  /// No description provided for @aiPrayerTitle.
  ///
  /// In en, this message translates to:
  /// **'A Prayer for You'**
  String get aiPrayerTitle;

  /// No description provided for @originalLangTitle.
  ///
  /// In en, this message translates to:
  /// **'Original Language'**
  String get originalLangTitle;

  /// No description provided for @premiumUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Premium'**
  String get premiumUnlock;

  /// No description provided for @qtPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning Garden'**
  String get qtPageTitle;

  /// No description provided for @qtMeditateButton.
  ///
  /// In en, this message translates to:
  /// **'Begin Meditation'**
  String get qtMeditateButton;

  /// No description provided for @qtCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get qtCompleted;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Garden'**
  String get communityTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterTestimony.
  ///
  /// In en, this message translates to:
  /// **'Testimony'**
  String get filterTestimony;

  /// No description provided for @filterPrayerRequest.
  ///
  /// In en, this message translates to:
  /// **'Prayer Request'**
  String get filterPrayerRequest;

  /// No description provided for @likeButton.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get likeButton;

  /// No description provided for @commentButton.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commentButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @replyButton.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get replyButton;

  /// No description provided for @writePostTitle.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get writePostTitle;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @sharePostButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get sharePostButton;

  /// No description provided for @anonymousToggle.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymousToggle;

  /// No description provided for @realNameToggle.
  ///
  /// In en, this message translates to:
  /// **'Real Name'**
  String get realNameToggle;

  /// No description provided for @categoryTestimony.
  ///
  /// In en, this message translates to:
  /// **'Testimony'**
  String get categoryTestimony;

  /// No description provided for @categoryPrayerRequest.
  ///
  /// In en, this message translates to:
  /// **'Prayer Request'**
  String get categoryPrayerRequest;

  /// No description provided for @writePostHint.
  ///
  /// In en, this message translates to:
  /// **'Share your testimony or prayer request...'**
  String get writePostHint;

  /// No description provided for @importFromPrayer.
  ///
  /// In en, this message translates to:
  /// **'Import from prayer'**
  String get importFromPrayer;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Calendar'**
  String get calendarTitle;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get bestStreak;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSection;

  /// No description provided for @totalPrayers.
  ///
  /// In en, this message translates to:
  /// **'Total Prayers'**
  String get totalPrayers;

  /// No description provided for @consecutiveDays.
  ///
  /// In en, this message translates to:
  /// **'Consecutive Days'**
  String get consecutiveDays;

  /// No description provided for @premiumSection.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumSection;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freePlan;

  /// No description provided for @premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumPlan;

  /// No description provided for @monthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'\$6.99/mo'**
  String get monthlyPrice;

  /// No description provided for @yearlyPrice.
  ///
  /// In en, this message translates to:
  /// **'\$49.99/yr'**
  String get yearlyPrice;

  /// No description provided for @yearlySave.
  ///
  /// In en, this message translates to:
  /// **'Save 40%'**
  String get yearlySave;

  /// No description provided for @launchPromo.
  ///
  /// In en, this message translates to:
  /// **'3 months at \$3.99/mo!'**
  String get launchPromo;

  /// No description provided for @startPremium.
  ///
  /// In en, this message translates to:
  /// **'Start Premium'**
  String get startPremium;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @notificationSetting.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSetting;

  /// No description provided for @aiVoiceSetting.
  ///
  /// In en, this message translates to:
  /// **'AI Voice'**
  String get aiVoiceSetting;

  /// No description provided for @voiceWarm.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get voiceWarm;

  /// No description provided for @voiceCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get voiceCalm;

  /// No description provided for @voiceStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get voiceStrong;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSetting;

  /// No description provided for @darkModeSetting.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeSetting;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(Object version);

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @timeAgo.
  ///
  /// In en, this message translates to:
  /// **'{time} ago'**
  String timeAgo(Object time);

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noPrayersRecorded.
  ///
  /// In en, this message translates to:
  /// **'No prayers recorded'**
  String get noPrayersRecorded;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deletePost;

  /// No description provided for @reportPost.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportPost;

  /// No description provided for @reportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted. Thank you.'**
  String get reportSubmitted;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this post?'**
  String get deleteConfirmMessage;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorAiFallback.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t reach AI right now. Here\'s a verse for you.'**
  String get errorAiFallback;

  /// No description provided for @errorSttFailed.
  ///
  /// In en, this message translates to:
  /// **'Voice recognition is not available. Please type instead.'**
  String get errorSttFailed;

  /// No description provided for @errorPayment.
  ///
  /// In en, this message translates to:
  /// **'There was a problem with payment. Please try again in Settings.'**
  String get errorPayment;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get errorGeneric;

  /// No description provided for @offlineNotice.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Some features may be limited.'**
  String get offlineNotice;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get retryButton;

  /// No description provided for @groupSection.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get groupSection;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create a Prayer Group'**
  String get createGroup;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// No description provided for @groupInviteMessage.
  ///
  /// In en, this message translates to:
  /// **'Let\'s pray together! Join my prayer group on Abba.'**
  String get groupInviteMessage;

  /// No description provided for @noGroups.
  ///
  /// In en, this message translates to:
  /// **'Join or create a group to pray together.'**
  String get noGroups;

  /// No description provided for @promoTitle.
  ///
  /// In en, this message translates to:
  /// **'Launch Special'**
  String get promoTitle;

  /// No description provided for @promoBanner.
  ///
  /// In en, this message translates to:
  /// **'First 3 months at \$3.99/mo!'**
  String get promoBanner;

  /// No description provided for @promoEndsOn.
  ///
  /// In en, this message translates to:
  /// **'Offer ends {date}'**
  String promoEndsOn(Object date);

  /// No description provided for @premiumLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s prayer is complete'**
  String get premiumLimitTitle;

  /// No description provided for @premiumLimitBody.
  ///
  /// In en, this message translates to:
  /// **'See you tomorrow!\nPray unlimited with Premium'**
  String get premiumLimitBody;

  /// No description provided for @laterButton.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get laterButton;

  /// No description provided for @morningPrayerReminder.
  ///
  /// In en, this message translates to:
  /// **'Morning Prayer'**
  String get morningPrayerReminder;

  /// No description provided for @eveningGratitudeReminder.
  ///
  /// In en, this message translates to:
  /// **'Evening Gratitude'**
  String get eveningGratitudeReminder;

  /// No description provided for @streakReminder.
  ///
  /// In en, this message translates to:
  /// **'Streak Reminder'**
  String get streakReminder;

  /// No description provided for @weeklySummaryReminder.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get weeklySummaryReminder;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @streakRecovery.
  ///
  /// In en, this message translates to:
  /// **'It\'s okay, you can start again 🌱'**
  String get streakRecovery;

  /// No description provided for @prayerSaved.
  ///
  /// In en, this message translates to:
  /// **'Prayer saved successfully'**
  String get prayerSaved;

  /// No description provided for @quietTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Quiet Time'**
  String get quietTimeLabel;

  /// No description provided for @morningPrayerLabel.
  ///
  /// In en, this message translates to:
  /// **'Morning Prayer'**
  String get morningPrayerLabel;

  /// No description provided for @gardenSeed.
  ///
  /// In en, this message translates to:
  /// **'A seed of faith'**
  String get gardenSeed;

  /// No description provided for @gardenSprout.
  ///
  /// In en, this message translates to:
  /// **'Growing sprout'**
  String get gardenSprout;

  /// No description provided for @gardenBud.
  ///
  /// In en, this message translates to:
  /// **'Budding flower'**
  String get gardenBud;

  /// No description provided for @gardenBloom.
  ///
  /// In en, this message translates to:
  /// **'Full bloom'**
  String get gardenBloom;

  /// No description provided for @gardenTree.
  ///
  /// In en, this message translates to:
  /// **'Strong tree'**
  String get gardenTree;

  /// No description provided for @milestoneShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get milestoneShare;

  /// No description provided for @milestoneThankGod.
  ///
  /// In en, this message translates to:
  /// **'Thank God!'**
  String get milestoneThankGod;

  /// No description provided for @shareStreakText.
  ///
  /// In en, this message translates to:
  /// **'{count} day prayer streak! My prayer journey with Abba #Abba #Prayer'**
  String shareStreakText(Object count);

  /// No description provided for @shareDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'day prayer streak'**
  String get shareDaysLabel;

  /// No description provided for @shareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily prayer with God'**
  String get shareSubtitle;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium Active'**
  String get premiumActive;

  /// No description provided for @planOncePerDay.
  ///
  /// In en, this message translates to:
  /// **'1x/day'**
  String get planOncePerDay;

  /// No description provided for @planUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get planUnlimited;

  /// No description provided for @closeRecording.
  ///
  /// In en, this message translates to:
  /// **'Close recording'**
  String get closeRecording;

  /// No description provided for @qtRevealMessage.
  ///
  /// In en, this message translates to:
  /// **'Let\'s open today\'s Word'**
  String get qtRevealMessage;

  /// No description provided for @qtSelectPrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose one and start today\'s QT'**
  String get qtSelectPrompt;

  /// No description provided for @qtTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get qtTopicLabel;

  /// No description provided for @prayerStartPrompt.
  ///
  /// In en, this message translates to:
  /// **'Start your prayer'**
  String get prayerStartPrompt;

  /// No description provided for @startPrayerButton.
  ///
  /// In en, this message translates to:
  /// **'Begin Prayer'**
  String get startPrayerButton;

  /// No description provided for @switchToTextMode.
  ///
  /// In en, this message translates to:
  /// **'Type instead'**
  String get switchToTextMode;

  /// No description provided for @prayerDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Garden'**
  String get prayerDashboardTitle;

  /// No description provided for @qtDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'QT Garden'**
  String get qtDashboardTitle;

  /// No description provided for @prayerSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Summary'**
  String get prayerSummaryTitle;

  /// No description provided for @gratitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Gratitude'**
  String get gratitudeLabel;

  /// No description provided for @petitionLabel.
  ///
  /// In en, this message translates to:
  /// **'Petition'**
  String get petitionLabel;

  /// No description provided for @intercessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Intercession'**
  String get intercessionLabel;

  /// No description provided for @historicalStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Story from History'**
  String get historicalStoryTitle;

  /// No description provided for @todayLesson.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Lesson'**
  String get todayLesson;

  /// No description provided for @meditationAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Meditation Analysis'**
  String get meditationAnalysisTitle;

  /// No description provided for @keyThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Key Theme'**
  String get keyThemeLabel;

  /// No description provided for @applicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Application'**
  String get applicationTitle;

  /// No description provided for @applicationWhat.
  ///
  /// In en, this message translates to:
  /// **'What'**
  String get applicationWhat;

  /// No description provided for @applicationWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get applicationWhen;

  /// No description provided for @applicationContext.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get applicationContext;

  /// No description provided for @relatedKnowledgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Related Knowledge'**
  String get relatedKnowledgeTitle;

  /// No description provided for @originalWordLabel.
  ///
  /// In en, this message translates to:
  /// **'Original Word'**
  String get originalWordLabel;

  /// No description provided for @historicalContextLabel.
  ///
  /// In en, this message translates to:
  /// **'Historical Context'**
  String get historicalContextLabel;

  /// No description provided for @crossReferencesLabel.
  ///
  /// In en, this message translates to:
  /// **'Cross References'**
  String get crossReferencesLabel;

  /// No description provided for @growthStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth Story'**
  String get growthStoryTitle;

  /// No description provided for @prayerGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'How to pray with Abba'**
  String get prayerGuideTitle;

  /// No description provided for @prayerGuide1.
  ///
  /// In en, this message translates to:
  /// **'Pray out loud or in a clear voice'**
  String get prayerGuide1;

  /// No description provided for @prayerGuide2.
  ///
  /// In en, this message translates to:
  /// **'Abba listens to your words and finds Scripture that speaks to your heart'**
  String get prayerGuide2;

  /// No description provided for @prayerGuide3.
  ///
  /// In en, this message translates to:
  /// **'You can also type your prayer if you prefer'**
  String get prayerGuide3;

  /// No description provided for @qtGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'How to do QT with Abba'**
  String get qtGuideTitle;

  /// No description provided for @qtGuide1.
  ///
  /// In en, this message translates to:
  /// **'Read the passage and meditate quietly'**
  String get qtGuide1;

  /// No description provided for @qtGuide2.
  ///
  /// In en, this message translates to:
  /// **'Share what you discovered — speak or type your reflection'**
  String get qtGuide2;

  /// No description provided for @qtGuide3.
  ///
  /// In en, this message translates to:
  /// **'Abba will help you apply the Word to your daily life'**
  String get qtGuide3;

  /// No description provided for @scriptureReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Why this Scripture'**
  String get scriptureReasonLabel;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @seeAllComments.
  ///
  /// In en, this message translates to:
  /// **'View all {count} comments'**
  String seeAllComments(Object count);

  /// No description provided for @likedBy.
  ///
  /// In en, this message translates to:
  /// **'{name} and {count} others liked this'**
  String likedBy(Object name, Object count);

  /// No description provided for @commentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// No description provided for @myPageTitle.
  ///
  /// In en, this message translates to:
  /// **'My Prayer Garden'**
  String get myPageTitle;

  /// No description provided for @myPrayers.
  ///
  /// In en, this message translates to:
  /// **'My Prayers'**
  String get myPrayers;

  /// No description provided for @myTestimonies.
  ///
  /// In en, this message translates to:
  /// **'My Testimonies'**
  String get myTestimonies;

  /// No description provided for @savedPosts.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedPosts;

  /// No description provided for @totalPrayersCount.
  ///
  /// In en, this message translates to:
  /// **'Prayers'**
  String get totalPrayersCount;

  /// No description provided for @streakCount.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streakCount;

  /// No description provided for @testimoniesCount.
  ///
  /// In en, this message translates to:
  /// **'Testimonies'**
  String get testimoniesCount;

  /// No description provided for @linkAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Link Account'**
  String get linkAccountTitle;

  /// No description provided for @linkAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Link your account to keep prayer records when switching devices'**
  String get linkAccountDescription;

  /// No description provided for @linkWithApple.
  ///
  /// In en, this message translates to:
  /// **'Link with Apple'**
  String get linkWithApple;

  /// No description provided for @linkWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Link with Google'**
  String get linkWithGoogle;

  /// No description provided for @linkAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account linked successfully!'**
  String get linkAccountSuccess;

  /// No description provided for @anonymousUser.
  ///
  /// In en, this message translates to:
  /// **'Prayer Warrior'**
  String get anonymousUser;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
