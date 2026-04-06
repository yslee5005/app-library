import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

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
    Locale('ko'),
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
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
