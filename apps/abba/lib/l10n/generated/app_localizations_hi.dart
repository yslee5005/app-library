// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle =>
      'जब आप प्रार्थना करते हैं,\nपरमेश्वर उत्तर देते हैं।';

  @override
  String get welcomeSubtitle => 'आपका दैनिक प्रार्थना और मनन साथी';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get loginTitle => 'Abba में आपका स्वागत है';

  @override
  String get loginSubtitle =>
      'अपनी प्रार्थना यात्रा शुरू करने के लिए साइन इन करें';

  @override
  String get signInWithApple => 'Apple से जारी रखें';

  @override
  String get signInWithGoogle => 'Google से जारी रखें';

  @override
  String get signInWithEmail => 'ईमेल से जारी रखें';

  @override
  String greetingMorning(Object name) {
    return 'शुभ प्रभात, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'शुभ अपराह्न, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'शुभ संध्या, $name';
  }

  @override
  String get prayButton => 'प्रार्थना';

  @override
  String get qtButton => 'मनन समय';

  @override
  String streakDays(Object count) {
    return '$count दिन लगातार प्रार्थना';
  }

  @override
  String get dailyVerse => 'आज का वचन';

  @override
  String get tabHome => 'होम';

  @override
  String get tabCalendar => 'कैलेंडर';

  @override
  String get tabCommunity => 'समुदाय';

  @override
  String get tabSettings => 'सेटिंग्स';

  @override
  String get recordingTitle => 'प्रार्थना कर रहे हैं...';

  @override
  String get recordingPause => 'रोकें';

  @override
  String get recordingResume => 'जारी रखें';

  @override
  String get finishPrayer => 'प्रार्थना समाप्त करें';

  @override
  String get finishPrayerConfirm =>
      'क्या आप अपनी प्रार्थना समाप्त करना चाहते हैं?';

  @override
  String get switchToText => 'टाइप करें';

  @override
  String get textInputHint => 'अपनी प्रार्थना यहाँ लिखें...';

  @override
  String get aiLoadingText => 'आपकी प्रार्थना पर चिंतन कर रहे हैं...';

  @override
  String get aiLoadingVerse =>
      'शांत रहो और जानो कि मैं परमेश्वर हूँ।\n— भजन संहिता 46:10';

  @override
  String get aiErrorNetworkTitle => 'कनेक्शन अस्थिर है';

  @override
  String get aiErrorNetworkBody =>
      'आपकी प्रार्थना सुरक्षित रूप से सहेजी गई है। कृपया थोड़ी देर में पुनः प्रयास करें।';

  @override
  String get aiErrorApiTitle => 'AI सेवा अस्थिर है';

  @override
  String get aiErrorApiBody =>
      'आपकी प्रार्थना सुरक्षित रूप से सहेजी गई है। कृपया थोड़ी देर में पुनः प्रयास करें।';

  @override
  String get aiErrorRetry => 'पुनः प्रयास करें';

  @override
  String get aiErrorWaitAndCheck =>
      'हम बाद में विश्लेषण का फिर प्रयास करेंगे। जल्द वापस आइए — आपकी प्रार्थना प्रतीक्षा करेगी।';

  @override
  String get aiErrorHome => 'घर वापस';

  @override
  String get dashboardTitle => 'प्रार्थना बगीचा';

  @override
  String get shareButton => 'साझा करें';

  @override
  String get backToHome => 'होम पर वापस';

  @override
  String get scriptureTitle => 'आज का वचन';

  @override
  String get bibleStoryTitle => 'बाइबल कहानी';

  @override
  String get testimonyTitle => 'साक्षी · मेरी प्रार्थना';

  @override
  String get testimonyHelperText =>
      'अपनी प्रार्थना पर विचार करें · समुदाय के साथ साझा कर सकते हैं';

  @override
  String get myPrayerAudioLabel => 'मेरी प्रार्थना की रिकॉर्डिंग';

  @override
  String get testimonyEdit => 'संपादित करें';

  @override
  String get guidanceTitle => 'AI मार्गदर्शन';

  @override
  String get aiPrayerTitle => 'आपके लिए एक प्रार्थना';

  @override
  String get originalLangTitle => 'मूल भाषा';

  @override
  String get proUnlock => 'Pro से अनलॉक करें';

  @override
  String get qtPageTitle => 'प्रातः बगीचा';

  @override
  String get qtMeditateButton => 'मनन शुरू करें';

  @override
  String get qtCompleted => 'पूर्ण';

  @override
  String get communityTitle => 'प्रार्थना बगीचा';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterTestimony => 'गवाही';

  @override
  String get filterPrayerRequest => 'प्रार्थना अनुरोध';

  @override
  String get likeButton => 'पसंद';

  @override
  String get commentButton => 'टिप्पणी';

  @override
  String get saveButton => 'सहेजें';

  @override
  String get replyButton => 'उत्तर दें';

  @override
  String get writePostTitle => 'साझा करें';

  @override
  String get cancelButton => 'रद्द करें';

  @override
  String get sharePostButton => 'साझा करें';

  @override
  String get anonymousToggle => 'गुमनाम';

  @override
  String get realNameToggle => 'असली नाम';

  @override
  String get categoryTestimony => 'गवाही';

  @override
  String get categoryPrayerRequest => 'प्रार्थना अनुरोध';

  @override
  String get writePostHint => 'अपनी गवाही या प्रार्थना अनुरोध साझा करें...';

  @override
  String get importFromPrayer => 'प्रार्थना से आयात करें';

  @override
  String get calendarTitle => 'प्रार्थना कैलेंडर';

  @override
  String get currentStreak => 'वर्तमान श्रृंखला';

  @override
  String get bestStreak => 'सर्वश्रेष्ठ श्रृंखला';

  @override
  String get days => 'दिन';

  @override
  String calendarRecordCount(Object count) {
    return '$count रिकॉर्ड';
  }

  @override
  String get todayVerse => 'आज का वचन';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get profileSection => 'प्रोफ़ाइल';

  @override
  String get totalPrayers => 'कुल प्रार्थनाएँ';

  @override
  String get consecutiveDays => 'लगातार दिन';

  @override
  String get proSection => 'सदस्यता';

  @override
  String get freePlan => 'मुफ़्त';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '₹549 / माह';

  @override
  String get yearlyPrice => '₹4,099 / वर्ष';

  @override
  String get yearlySave => '40% बचाएँ';

  @override
  String get launchPromo => '';

  @override
  String get startPro => 'Pro शुरू करें';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get notificationSetting => 'सूचनाएँ';

  @override
  String get languageSetting => 'भाषा';

  @override
  String get darkModeSetting => 'डार्क मोड';

  @override
  String get helpCenter => 'सहायता केंद्र';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get logout => 'लॉग आउट';

  @override
  String appVersion(Object version) {
    return 'संस्करण $version';
  }

  @override
  String get anonymous => 'गुमनाम';

  @override
  String timeAgo(Object time) {
    return '$time पहले';
  }

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get signIn => 'साइन इन';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get noPrayersRecorded => 'कोई प्रार्थना रिकॉर्ड नहीं';

  @override
  String get deletePost => 'हटाएँ';

  @override
  String get reportPost => 'रिपोर्ट करें';

  @override
  String get reportSubmitted => 'रिपोर्ट भेज दी गई। धन्यवाद।';

  @override
  String get reportReasonHint =>
      'कृपया रिपोर्ट का कारण बताएँ। यह ईमेल द्वारा भेजा जाएगा।';

  @override
  String get reportReasonPlaceholder => 'रिपोर्ट का कारण लिखें...';

  @override
  String get reportSubmitButton => 'रिपोर्ट करें';

  @override
  String get deleteConfirmTitle => 'पोस्ट हटाएँ';

  @override
  String get deleteConfirmMessage =>
      'क्या आप वाकई इस पोस्ट को हटाना चाहते हैं?';

  @override
  String get errorNetwork =>
      'कृपया अपना इंटरनेट कनेक्शन जाँचें और पुनः प्रयास करें।';

  @override
  String get errorAiFallback =>
      'अभी AI से कनेक्ट नहीं हो पा रहा। यहाँ आपके लिए एक वचन है।';

  @override
  String get errorSttFailed => 'वॉइस पहचान उपलब्ध नहीं है। कृपया टाइप करें।';

  @override
  String get errorPayment =>
      'भुगतान में समस्या हुई। कृपया सेटिंग्स में पुनः प्रयास करें।';

  @override
  String get errorGeneric => 'कुछ गलत हो गया। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get offlineNotice => 'आप ऑफ़लाइन हैं। कुछ सुविधाएँ सीमित हो सकती हैं।';

  @override
  String get retryButton => 'पुनः प्रयास';

  @override
  String get groupSection => 'मेरे समूह';

  @override
  String get createGroup => 'प्रार्थना समूह बनाएँ';

  @override
  String get inviteFriends => 'मित्रों को आमंत्रित करें';

  @override
  String get groupInviteMessage =>
      'आइए साथ प्रार्थना करें! Abba पर मेरे प्रार्थना समूह में शामिल हों।';

  @override
  String get noGroups => 'साथ प्रार्थना करने के लिए समूह बनाएँ या जुड़ें।';

  @override
  String get promoTitle => 'लॉन्च ऑफ़र';

  @override
  String get promoBanner => '';

  @override
  String promoEndsOn(Object date) {
    return 'ऑफ़र $date तक';
  }

  @override
  String get proLimitTitle => 'आज की प्रार्थना पूरी हुई';

  @override
  String get proLimitBody => 'कल मिलते हैं!\nPro के साथ असीमित प्रार्थना करें';

  @override
  String get laterButton => 'बाद में';

  @override
  String get proPromptTitle => 'Pro सुविधा';

  @override
  String get proPromptBody =>
      'यह सुविधा Pro के साथ उपलब्ध है।\nक्या आप हमारे प्लान देखना चाहेंगे?';

  @override
  String get viewProducts => 'प्लान देखें';

  @override
  String get maybeLater => 'बाद में';

  @override
  String get proHeadline => 'हर दिन परमेश्वर के और करीब';

  @override
  String get proBenefit1 => 'असीमित प्रार्थना और मनन समय';

  @override
  String get proBenefit2 => 'AI-संचालित प्रार्थना और मार्गदर्शन';

  @override
  String get proBenefit3 => 'इतिहास से विश्वास की कहानियाँ';

  @override
  String get proBenefit5 => 'मूल भाषा में बाइबल अध्ययन';

  @override
  String get bestValue => 'सर्वोत्तम मूल्य';

  @override
  String get perMonth => 'माह';

  @override
  String get cancelAnytime => 'कभी भी रद्द करें';

  @override
  String get restorePurchase => 'खरीदारी पुनर्स्थापित करें';

  @override
  String get yearlyPriceMonthly => '₹342/माह';

  @override
  String get morningPrayerReminder => 'प्रातः प्रार्थना';

  @override
  String get eveningGratitudeReminder => 'संध्या कृतज्ञता';

  @override
  String get streakReminder => 'श्रृंखला अनुस्मारक';

  @override
  String get afternoonNudgeReminder => 'दोपहर प्रार्थना अनुस्मारक';

  @override
  String get weeklySummaryReminder => 'साप्ताहिक सारांश';

  @override
  String get unlimited => 'असीमित';

  @override
  String get streakRecovery => 'कोई बात नहीं, आप फिर से शुरू कर सकते हैं 🌱';

  @override
  String get prayerSaved => 'प्रार्थना सफलतापूर्वक सहेजी गई';

  @override
  String get quietTimeLabel => 'मनन समय';

  @override
  String get morningPrayerLabel => 'प्रातः प्रार्थना';

  @override
  String get gardenSeed => 'विश्वास का बीज';

  @override
  String get gardenSprout => 'बढ़ता अंकुर';

  @override
  String get gardenBud => 'कली';

  @override
  String get gardenBloom => 'पूर्ण खिलावट';

  @override
  String get gardenTree => 'मजबूत वृक्ष';

  @override
  String get gardenForest => 'प्रार्थना का वन';

  @override
  String get milestoneShare => 'साझा करें';

  @override
  String get milestoneThankGod => 'परमेश्वर का धन्यवाद!';

  @override
  String shareStreakText(Object count) {
    return '$count दिन लगातार प्रार्थना! Abba के साथ मेरी प्रार्थना यात्रा #Abba #प्रार्थना';
  }

  @override
  String get shareDaysLabel => 'दिन लगातार प्रार्थना';

  @override
  String get shareSubtitle => 'परमेश्वर के साथ दैनिक प्रार्थना';

  @override
  String get proActive => 'सदस्यता सक्रिय';

  @override
  String get planOncePerDay => '1x/दिन';

  @override
  String get planUnlimited => 'असीमित';

  @override
  String get closeRecording => 'रिकॉर्डिंग बंद करें';

  @override
  String get qtRevealMessage => 'आज का वचन खोलें';

  @override
  String get qtSelectPrompt => 'एक चुनें और आज का मनन समय शुरू करें';

  @override
  String get qtTopicLabel => 'विषय';

  @override
  String get prayerStartPrompt => 'अपनी प्रार्थना शुरू करें';

  @override
  String get startPrayerButton => 'प्रार्थना शुरू करें';

  @override
  String get switchToTextMode => 'टाइप करें';

  @override
  String get switchToVoiceMode => 'बोलें';

  @override
  String get prayerDashboardTitle => 'प्रार्थना बगीचा';

  @override
  String get qtDashboardTitle => 'मनन बगीचा';

  @override
  String get prayerSummaryTitle => 'प्रार्थना सारांश';

  @override
  String get gratitudeLabel => 'कृतज्ञता';

  @override
  String get petitionLabel => 'याचना';

  @override
  String get intercessionLabel => 'मध्यस्थता';

  @override
  String get historicalStoryTitle => 'इतिहास से कहानी';

  @override
  String get todayLesson => 'आज का पाठ';

  @override
  String get applicationTitle => 'आज का अनुप्रयोग';

  @override
  String get applicationWhat => 'क्या';

  @override
  String get applicationWhen => 'कब';

  @override
  String get applicationContext => 'कहाँ';

  @override
  String get applicationMorningLabel => 'सुबह';

  @override
  String get applicationDayLabel => 'दिन';

  @override
  String get applicationEveningLabel => 'शाम';

  @override
  String get relatedKnowledgeTitle => 'संबंधित ज्ञान';

  @override
  String get originalWordLabel => 'मूल शब्द';

  @override
  String get historicalContextLabel => 'ऐतिहासिक संदर्भ';

  @override
  String get crossReferencesLabel => 'क्रॉस रेफ़रेंस';

  @override
  String get growthStoryTitle => 'विकास कहानी';

  @override
  String get prayerGuideTitle => 'Abba के साथ कैसे प्रार्थना करें';

  @override
  String get prayerGuide1 => 'ज़ोर से या स्पष्ट आवाज़ में प्रार्थना करें';

  @override
  String get prayerGuide2 =>
      'Abba आपके शब्दों को सुनता है और आपके हृदय से बात करने वाला वचन खोजता है';

  @override
  String get prayerGuide3 => 'आप चाहें तो अपनी प्रार्थना टाइप भी कर सकते हैं';

  @override
  String get qtGuideTitle => 'Abba के साथ मनन समय कैसे करें';

  @override
  String get qtGuide1 => 'वचन पढ़ें और शांति से मनन करें';

  @override
  String get qtGuide2 => 'जो आपने पाया वह साझा करें — बोलकर या लिखकर';

  @override
  String get qtGuide3 =>
      'Abba आपको वचन को दैनिक जीवन में लागू करने में मदद करेगा';

  @override
  String get scriptureReasonLabel => 'यह वचन क्यों';

  @override
  String get scripturePostureLabel => 'किस भाव से पढ़ूँ?';

  @override
  String get scriptureOriginalWordsTitle => 'मूल भाषा में गहरा अर्थ';

  @override
  String get originalWordMeaningLabel => 'अर्थ';

  @override
  String get originalWordNuanceLabel => 'अनुवाद की तुलना में सूक्ष्मता';

  @override
  String originalWordsCountLabel(int count) {
    return '$count शब्द';
  }

  @override
  String get seeMore => 'और देखें';

  @override
  String get seeLess => 'कम देखें';

  @override
  String seeAllComments(Object count) {
    return 'सभी $count टिप्पणियाँ देखें';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name और $count अन्य ने पसंद किया';
  }

  @override
  String get commentsTitle => 'टिप्पणियाँ';

  @override
  String get myPageTitle => 'मेरा प्रार्थना बगीचा';

  @override
  String get myPrayers => 'मेरी प्रार्थनाएँ';

  @override
  String get myTestimonies => 'मेरी गवाहियाँ';

  @override
  String get savedPosts => 'सहेजे गए';

  @override
  String get totalPrayersCount => 'प्रार्थनाएँ';

  @override
  String get streakCount => 'श्रृंखला';

  @override
  String get testimoniesCount => 'गवाहियाँ';

  @override
  String get linkAccountTitle => 'खाता लिंक करें';

  @override
  String get linkAccountDescription =>
      'डिवाइस बदलते समय प्रार्थना रिकॉर्ड बनाए रखने के लिए अपना खाता लिंक करें';

  @override
  String get linkWithApple => 'Apple से लिंक करें';

  @override
  String get linkWithGoogle => 'Google से लिंक करें';

  @override
  String get linkAccountSuccess => 'खाता सफलतापूर्वक लिंक हो गया!';

  @override
  String get anonymousUser => 'प्रार्थना योद्धा';

  @override
  String showReplies(Object count) {
    return '$count उत्तर देखें';
  }

  @override
  String get hideReplies => 'उत्तर छिपाएँ';

  @override
  String replyingTo(Object name) {
    return '$name को उत्तर';
  }

  @override
  String viewAllComments(Object count) {
    return 'सभी $count टिप्पणियाँ देखें';
  }

  @override
  String get membershipTitle => 'सदस्यता';

  @override
  String get membershipSubtitle => 'अपनी प्रार्थना को और गहरा करें';

  @override
  String get monthlyPlan => 'मासिक';

  @override
  String get yearlyPlan => 'वार्षिक';

  @override
  String get yearlySavings => '₹207/माह (40% छूट)';

  @override
  String get startMembership => 'शुरू करें';

  @override
  String get membershipActive => 'सदस्यता सक्रिय';

  @override
  String get leaveRecordingTitle => 'रिकॉर्डिंग छोड़ें?';

  @override
  String get leaveRecordingMessage =>
      'आपकी रिकॉर्डिंग खो जाएगी। क्या आप निश्चित हैं?';

  @override
  String get leaveButton => 'छोड़ें';

  @override
  String get stayButton => 'रुकें';

  @override
  String likedByCount(Object count) {
    return '$count लोगों ने सहानुभूति व्यक्त की';
  }

  @override
  String get actionLike => 'पसंद';

  @override
  String get actionComment => 'टिप्पणी';

  @override
  String get actionSave => 'सहेजें';

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
  String get billingIssueTitle => 'भुगतान समस्या का पता चला';

  @override
  String billingIssueBody(int days) {
    return 'यदि भुगतान अपडेट नहीं हुआ तो आपके Pro लाभ $days दिनों में समाप्त हो जाएंगे।';
  }

  @override
  String get billingIssueAction => 'भुगतान अपडेट करें';

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
      '💛 प्रेम — 10 सेकंड किसी प्रियजन के बारे में सोचें';

  @override
  String get qtLoadingHint2 => '🌿 अनुग्रह — आज पाई एक छोटी कृपा याद करें';

  @override
  String get qtLoadingHint3 => '🌅 आशा — कल की एक छोटी आशा मन में बनाएँ';

  @override
  String get qtLoadingHint4 => '🕊️ शांति — तीन बार धीरे-धीरे गहरी साँस लें';

  @override
  String get qtLoadingHint5 => '🌳 विश्वास — एक अटल सत्य याद करें';

  @override
  String get qtLoadingHint6 => '🌸 कृतज्ञता — अभी जिसके लिए आभारी हैं उसे कहें';

  @override
  String get qtLoadingHint7 =>
      '🌊 क्षमा — किसी क्षमा करने योग्य व्यक्ति को याद करें';

  @override
  String get qtLoadingHint8 => '📖 ज्ञान — आज का एक सबक हृदय में रखें';

  @override
  String get qtLoadingHint9 =>
      '⏳ धैर्य — चुपचाप जिसकी प्रतीक्षा कर रहे हैं सोचें';

  @override
  String get qtLoadingHint10 => '✨ आनंद — आज मुस्कुराए एक पल को याद करें';

  @override
  String get qtLoadingTitle => 'आज का वचन तैयार हो रहा है...';

  @override
  String get coachingTitle => 'प्रार्थना कोचिंग';

  @override
  String get coachingLoadingText => 'आपकी प्रार्थना पर विचार कर रहे हैं...';

  @override
  String get coachingErrorText => 'अस्थायी त्रुटि — कृपया पुनः प्रयास करें';

  @override
  String get coachingRetryButton => 'पुनः प्रयास';

  @override
  String get coachingScoreSpecificity => 'विशिष्टता';

  @override
  String get coachingScoreGodCentered => 'ईश्वर-केंद्रित';

  @override
  String get coachingScoreActs => 'ACTS संतुलन';

  @override
  String get coachingScoreAuthenticity => 'प्रामाणिकता';

  @override
  String get coachingStrengthsTitle => 'आपने क्या अच्छा किया ✨';

  @override
  String get coachingImprovementsTitle => 'और गहराई में जाने के लिए 💡';

  @override
  String get coachingProCta => 'Pro के साथ प्रार्थना कोचिंग अनलॉक करें';

  @override
  String get coachingLevelBeginner => '🌱 शुरुआती';

  @override
  String get coachingLevelGrowing => '🌿 बढ़ रहा';

  @override
  String get coachingLevelExpert => '🌳 विशेषज्ञ';

  @override
  String get aiPrayerCitationsTitle => 'संदर्भ · उद्धरण';

  @override
  String get citationTypeQuote => 'उद्धरण';

  @override
  String get citationTypeScience => 'अनुसंधान';

  @override
  String get citationTypeExample => 'उदाहरण';

  @override
  String get citationTypeHistory => 'इतिहास';

  @override
  String get aiPrayerReadingTime => '2 मिनट का पठन';

  @override
  String get scriptureKeyWordHintTitle => 'आज का मुख्य शब्द';

  @override
  String get bibleLookupReferenceHint =>
      'अपनी बाइबल में यह अंश ढूंढ़ें और इस पर मनन करें।';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'बाइबल अनुवाद';

  @override
  String get settingsBibleTranslationsIntro =>
      'इस ऐप में बाइबल के वचन सार्वजनिक डोमेन अनुवादों से लिए गए हैं। AI द्वारा उत्पन्न टिप्पणियां, प्रार्थनाएं और कहानियां Abba की रचनात्मक रचना हैं।';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'QT कोचिंग';

  @override
  String get qtCoachingLoadingText => 'आपके ध्यान पर विचार कर रहे हैं...';

  @override
  String get qtCoachingErrorText => 'अस्थायी त्रुटि — कृपया पुनः प्रयास करें';

  @override
  String get qtCoachingRetryButton => 'पुनः प्रयास';

  @override
  String get qtCoachingScoreComprehension => 'शास्त्र की समझ';

  @override
  String get qtCoachingScoreApplication => 'व्यक्तिगत प्रयोग';

  @override
  String get qtCoachingScoreDepth => 'आध्यात्मिक गहराई';

  @override
  String get qtCoachingScoreAuthenticity => 'प्रामाणिकता';

  @override
  String get qtCoachingStrengthsTitle => 'आपने क्या अच्छा किया ✨';

  @override
  String get qtCoachingImprovementsTitle => 'और गहराई में जाने के लिए 💡';

  @override
  String get qtCoachingProCta => 'Pro के साथ QT कोचिंग अनलॉक करें';

  @override
  String get qtCoachingLevelBeginner => '🌱 शुरुआती';

  @override
  String get qtCoachingLevelGrowing => '🌿 बढ़ रहा';

  @override
  String get qtCoachingLevelExpert => '🌳 विशेषज्ञ';

  @override
  String get notifyMorning1Title => '🙏 प्रार्थना का समय है';

  @override
  String notifyMorning1Body(String name) {
    return '$name, आज भी परमेश्वर से बात करें';
  }

  @override
  String get notifyMorning2Title => '🌅 नई सुबह हो गई है';

  @override
  String notifyMorning2Body(String name) {
    return '$name, कृतज्ञता के साथ दिन शुरू करें';
  }

  @override
  String get notifyMorning3Title => '✨ आज का अनुग्रह';

  @override
  String notifyMorning3Body(String name) {
    return '$name, परमेश्वर की तैयार की हुई कृपा से मिलें';
  }

  @override
  String get notifyMorning4Title => '🕊️ शांत सुबह';

  @override
  String notifyMorning4Body(String name) {
    return '$name, प्रार्थना से मन में शांति भरें';
  }

  @override
  String get notifyMorning5Title => '📖 वचन के साथ';

  @override
  String notifyMorning5Body(String name) {
    return '$name, आज परमेश्वर की आवाज़ सुनें';
  }

  @override
  String get notifyMorning6Title => '🌿 विश्राम का समय';

  @override
  String notifyMorning6Body(String name) {
    return '$name, एक पल रुककर प्रार्थना करें';
  }

  @override
  String get notifyMorning7Title => '💫 आज भी';

  @override
  String notifyMorning7Body(String name) {
    return '$name, प्रार्थना से शुरू होने वाला दिन अलग होता है';
  }

  @override
  String get notifyEvening1Title => '✨ आज के लिए धन्यवाद';

  @override
  String get notifyEvening1Body =>
      'आज पर चिंतन करें और धन्यवाद की प्रार्थना करें';

  @override
  String get notifyEvening2Title => '🌙 दिन का समापन करते हुए';

  @override
  String get notifyEvening2Body => 'आज की कृतज्ञता को प्रार्थना से व्यक्त करें';

  @override
  String get notifyEvening3Title => '🙏 शाम की प्रार्थना';

  @override
  String get notifyEvening3Body => 'दिन के अंत में परमेश्वर को धन्यवाद दें';

  @override
  String get notifyEvening4Title => '🌟 आज की आशीषें गिनते हुए';

  @override
  String get notifyEvening4Body =>
      'यदि आभारी होने के लिए कुछ है, तो प्रार्थना में साझा करें';

  @override
  String get notifyStreak3Title => '🌱 लगातार 3 दिन!';

  @override
  String get notifyStreak3Body => 'आपकी प्रार्थना की आदत शुरू हो गई';

  @override
  String get notifyStreak7Title => '🌿 पूरा हफ्ता!';

  @override
  String get notifyStreak7Body => 'प्रार्थना एक आदत बन रही है';

  @override
  String get notifyStreak14Title => '🌳 लगातार 2 हफ्ते!';

  @override
  String get notifyStreak14Body => 'अद्भुत वृद्धि!';

  @override
  String get notifyStreak21Title => '🌻 लगातार 3 हफ्ते!';

  @override
  String get notifyStreak21Body => 'प्रार्थना का फूल खिल रहा है';

  @override
  String get notifyStreak30Title => '🏆 पूरा महीना!';

  @override
  String get notifyStreak30Body => 'आपकी प्रार्थना चमक रही है';

  @override
  String get notifyStreak50Title => '👑 लगातार 50 दिन!';

  @override
  String get notifyStreak50Body => 'परमेश्वर के साथ आपका चलना गहरा हो रहा है';

  @override
  String get notifyStreak100Title => '🎉 लगातार 100 दिन!';

  @override
  String get notifyStreak100Body => 'आप प्रार्थना के योद्धा बन गए हैं!';

  @override
  String get notifyStreak365Title => '✝️ पूरा एक साल!';

  @override
  String get notifyStreak365Body => 'विश्वास की अद्भुत यात्रा!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ क्या आपने आज प्रार्थना की?';

  @override
  String get notifyAfternoonNudgeBody => 'एक छोटी प्रार्थना दिन को बदल सकती है';

  @override
  String get notifyChannelName => 'प्रार्थना अनुस्मारक';

  @override
  String get notifyChannelDescription =>
      'सुबह की प्रार्थना, शाम की कृतज्ञता और अन्य प्रार्थना अनुस्मारक';

  @override
  String get milestoneFirstPrayerTitle => 'पहली प्रार्थना!';

  @override
  String get milestoneFirstPrayerDesc =>
      'आपकी प्रार्थना यात्रा शुरू हो गई है। परमेश्वर सुन रहा है।';

  @override
  String get milestoneSevenDayStreakTitle => '7 दिन की प्रार्थना!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'एक सप्ताह की निष्ठावान प्रार्थना। आपका बगीचा बढ़ रहा है!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 दिन!';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'आपका बगीचा फूलों के खेत में खिल गया है!';

  @override
  String get milestoneHundredPrayersTitle => '100वीं प्रार्थना!';

  @override
  String get milestoneHundredPrayersDesc =>
      'परमेश्वर के साथ सौ बातचीत। आप गहराई से जड़ें जमा चुके हैं।';

  @override
  String get homeFirstPrayerPrompt => 'अपनी पहली प्रार्थना शुरू करें';

  @override
  String get homeFirstQtPrompt => 'अपना पहला QT शुरू करें';

  @override
  String homeActivityPrompt(String activityName) {
    return 'आज भी $activityName करें';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return '$activityName का लगातार $count दिन';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'आपके अंतिम $activityName को $days दिन हो गए';
  }

  @override
  String get homeActivityPrayer => 'प्रार्थना';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'लोड हो रहा है...';

  @override
  String get heatmapNoPrayer => 'कोई प्रार्थना नहीं';

  @override
  String get heatmapLegendLess => 'कम';

  @override
  String get heatmapLegendMore => 'ज्यादा';

  @override
  String get qtPassagesLoadError =>
      'आज के वचन लोड नहीं हो सके। कृपया अपना कनेक्शन जाँचें।';

  @override
  String get qtPassagesRetryButton => 'फिर से प्रयास करें';

  @override
  String get aiStreamingInitial => 'आपकी प्रार्थना पर मनन कर रहे हैं...';

  @override
  String get aiTierProcessing => 'और विचार आ रहे हैं...';

  @override
  String get aiScriptureValidating => 'सही शास्त्रवचन ढूँढ़ रहे हैं...';

  @override
  String get aiScriptureValidatingFailed =>
      'यह शास्त्रवचन आपके लिए तैयार कर रहे हैं...';

  @override
  String get aiTemplateFallback => 'आपका पूरा विश्लेषण तैयार होने तक...';

  @override
  String get aiPendingMore => 'और तैयार हो रहा है...';

  @override
  String get aiTierIncomplete => 'जल्द आ रहा है, बाद में देखें';

  @override
  String get tierCompleted => 'नया मनन जोड़ा गया';

  @override
  String get tierProcessingNotice => 'और मनन बना रहे हैं...';

  @override
  String get proSectionLoading => 'आपकी प्रीमियम सामग्री तैयार कर रहे हैं...';

  @override
  String get proSectionWillArrive => 'आपका गहरा मनन यहाँ दिखाई देगा';

  @override
  String get templateCategoryHealth => 'स्वास्थ्य चिंताओं के लिए';

  @override
  String get templateCategoryFamily => 'परिवार के लिए';

  @override
  String get templateCategoryWork => 'कार्य और अध्ययन के लिए';

  @override
  String get templateCategoryGratitude => 'एक आभारी हृदय';

  @override
  String get templateCategoryGrief => 'शोक या हानि में';

  @override
  String get sectionStatusCompleted => 'विश्लेषण पूर्ण';

  @override
  String get sectionStatusPartial => 'आंशिक विश्लेषण (और आ रहा है)';

  @override
  String get sectionStatusPending => 'विश्लेषण प्रगति पर है';

  @override
  String get trialStartCta => '1 महीना मुफ्त शुरू करें';

  @override
  String trialAutoRenewDisclosure(Object price) {
    return 'फिर $price/वर्ष, स्वतः नवीनीकरण। सेटिंग्स में कभी भी रद्द करें।';
  }

  @override
  String get trialLimitTitle => 'आपने आज 3 बार प्रार्थना की है 🌸';

  @override
  String get trialLimitBody =>
      'कल फिर आएं — या Pro के साथ असीमित प्रार्थना अनलॉक करें।';

  @override
  String get trialLimitCta => 'Pro के साथ जारी रखें';
}
