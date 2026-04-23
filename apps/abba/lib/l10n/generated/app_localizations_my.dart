// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'သင်ဆုတောင်းသောအခါ\nဘုရားသခင်အဖြေပေးသည်။';

  @override
  String get welcomeSubtitle => 'နေ့စဉ်ဆုတောင်းခြင်းနှင့် တိတ်ဆိတ်ချိန် အဖော်';

  @override
  String get getStarted => 'စတင်ရန်';

  @override
  String get loginTitle => 'Abba မှ ကြိုဆိုပါသည်';

  @override
  String get loginSubtitle => 'ဆုတောင်းခရီးကို စတင်ရန် အကောင့်ဝင်ပါ';

  @override
  String get signInWithApple => 'Apple ဖြင့် ဆက်လက်ရန်';

  @override
  String get signInWithGoogle => 'Google ဖြင့် ဆက်လက်ရန်';

  @override
  String get signInWithEmail => 'အီးမေးလ်ဖြင့် ဆက်လက်ရန်';

  @override
  String greetingMorning(Object name) {
    return 'မင်္ဂလာနံနက်ခင်းပါ $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'မင်္ဂလာနေ့လည်ခင်းပါ $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'မင်္ဂလာညနေခင်းပါ $name';
  }

  @override
  String get prayButton => 'ဆုတောင်းရန်';

  @override
  String get qtButton => 'တိတ်ဆိတ်ချိန်';

  @override
  String streakDays(Object count) {
    return '$count ရက် ဆက်တိုက်ဆုတောင်းခြင်း';
  }

  @override
  String get dailyVerse => 'ယနေ့ကျမ်းပိုဒ်';

  @override
  String get tabHome => 'ပင်မ';

  @override
  String get tabCalendar => 'ပြက္ခဒိန်';

  @override
  String get tabCommunity => 'အသိုင်းအဝိုင်း';

  @override
  String get tabSettings => 'ဆက်တင်များ';

  @override
  String get recordingTitle => 'ဆုတောင်းနေသည်...';

  @override
  String get recordingPause => 'ခဏရပ်ရန်';

  @override
  String get recordingResume => 'ဆက်လက်ရန်';

  @override
  String get finishPrayer => 'ဆုတောင်းပြီးပါပြီ';

  @override
  String get finishPrayerConfirm => 'ဆုတောင်းခြင်းကို အဆုံးသတ်လိုပါသလား?';

  @override
  String get switchToText => 'စာရိုက်ရန်';

  @override
  String get textInputHint => 'ဆုတောင်းချက်ကို ဒီမှာ ရေးပါ...';

  @override
  String get aiLoadingText => 'သင့်ဆုတောင်းချက်ကို ဆင်ခြင်နေသည်...';

  @override
  String get aiLoadingVerse =>
      'ငြိမ်သက်၍ ငါသည် ဘုရားသခင်ဖြစ်ကြောင်း သိကြလော့။\n— ဆာလံ 46:10';

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
  String get dashboardTitle => 'ဆုတောင်းခြင်းဥယျာဉ်';

  @override
  String get shareButton => 'မျှဝေရန်';

  @override
  String get backToHome => 'ပင်မသို့ ပြန်ရန်';

  @override
  String get scriptureTitle => 'ယနေ့ကျမ်းစာ';

  @override
  String get bibleStoryTitle => 'သမ္မာကျမ်းပုံပြင်';

  @override
  String get testimonyTitle => 'သက်သေခံ · ငါ၏ဆုတောင်း';

  @override
  String get testimonyHelperText =>
      'သင်၏ဆုတောင်းကိုပြန်ဆင်ခြင်ပါ · အဖွဲ့ထဲသို့မျှဝေနိုင်';

  @override
  String get myPrayerAudioLabel => 'ငါ၏ဆုတောင်း အသံဖိုင်';

  @override
  String get testimonyEdit => 'တည်းဖြတ်ရန်';

  @override
  String get guidanceTitle => 'AI လမ်းညွှန်ချက်';

  @override
  String get aiPrayerTitle => 'သင့်အတွက် ဆုတောင်းချက်';

  @override
  String get originalLangTitle => 'မူရင်းဘာသာ';

  @override
  String get proUnlock => 'Pro ဖြင့် ဖွင့်ရန်';

  @override
  String get qtPageTitle => 'နံနက်ဥယျာဉ်';

  @override
  String get qtMeditateButton => 'ဆင်ခြင်ခြင်း စတင်ရန်';

  @override
  String get qtCompleted => 'ပြီးဆုံးပါပြီ';

  @override
  String get communityTitle => 'ဆုတောင်းခြင်းဥယျာဉ်';

  @override
  String get filterAll => 'အားလုံး';

  @override
  String get filterTestimony => 'သက်သေခံချက်';

  @override
  String get filterPrayerRequest => 'ဆုတောင်းတောင်းဆိုချက်';

  @override
  String get likeButton => 'နှစ်သက်';

  @override
  String get commentButton => 'မှတ်ချက်';

  @override
  String get saveButton => 'သိမ်းရန်';

  @override
  String get replyButton => 'ပြန်ဖြေရန်';

  @override
  String get writePostTitle => 'မျှဝေရန်';

  @override
  String get cancelButton => 'ပယ်ဖျက်ရန်';

  @override
  String get sharePostButton => 'တင်ရန်';

  @override
  String get anonymousToggle => 'အမည်ဝှက်';

  @override
  String get realNameToggle => 'အမည်ရင်း';

  @override
  String get categoryTestimony => 'သက်သေခံချက်';

  @override
  String get categoryPrayerRequest => 'ဆုတောင်းတောင်းဆိုချက်';

  @override
  String get writePostHint =>
      'သက်သေခံချက် သို့ ဆုတောင်းတောင်းဆိုချက် မျှဝေပါ...';

  @override
  String get importFromPrayer => 'ဆုတောင်းချက်မှ ယူရန်';

  @override
  String get calendarTitle => 'ဆုတောင်းပြက္ခဒိန်';

  @override
  String get currentStreak => 'လက်ရှိဆက်တိုက်';

  @override
  String get bestStreak => 'အကောင်းဆုံးဆက်တိုက်';

  @override
  String get days => 'ရက်';

  @override
  String calendarRecordCount(Object count) {
    return '$count မှတ်တမ်း';
  }

  @override
  String get todayVerse => 'ယနေ့ကျမ်းပိုဒ်';

  @override
  String get settingsTitle => 'ဆက်တင်များ';

  @override
  String get profileSection => 'ပရိုဖိုင်';

  @override
  String get totalPrayers => 'စုစုပေါင်းဆုတောင်းချက်';

  @override
  String get consecutiveDays => 'ဆက်တိုက်ရက်';

  @override
  String get proSection => 'အသင်းဝင်';

  @override
  String get freePlan => 'အခမဲ့';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '\$6.99 / လ';

  @override
  String get yearlyPrice => '\$49.99 / နှစ်';

  @override
  String get yearlySave => '40% ချွေတာ';

  @override
  String get launchPromo => '3 လ \$4.99/လ ဖြင့်!';

  @override
  String get startPro => 'Pro စတင်ရန်';

  @override
  String get comingSoon => 'မကြာမီ';

  @override
  String get notificationSetting => 'အကြောင်းကြားချက်များ';

  @override
  String get languageSetting => 'ဘာသာစကား';

  @override
  String get darkModeSetting => 'မှောင်မိုက်မုဒ်';

  @override
  String get helpCenter => 'အကူအညီဌာန';

  @override
  String get termsOfService => 'ဝန်ဆောင်မှု စည်းကမ်းချက်';

  @override
  String get privacyPolicy => 'ကိုယ်ရေးကိုယ်တာ မူဝါဒ';

  @override
  String get logout => 'ထွက်ရန်';

  @override
  String appVersion(Object version) {
    return 'ဗားရှင်း $version';
  }

  @override
  String get anonymous => 'အမည်ဝှက်';

  @override
  String timeAgo(Object time) {
    return '$time အကြာ';
  }

  @override
  String get emailLabel => 'အီးမေးလ်';

  @override
  String get passwordLabel => 'စကားဝှက်';

  @override
  String get signIn => 'ဝင်ရန်';

  @override
  String get cancel => 'ပယ်ဖျက်ရန်';

  @override
  String get noPrayersRecorded => 'ဆုတောင်းချက် မှတ်တမ်းမရှိပါ';

  @override
  String get deletePost => 'ဖျက်ရန်';

  @override
  String get reportPost => 'တိုင်ကြားရန်';

  @override
  String get reportSubmitted =>
      'တိုင်ကြားချက် ပေးပို့ပြီးပါပြီ။ ကျေးဇူးတင်ပါသည်။';

  @override
  String get reportReasonHint =>
      'တိုင်ကြားရသည့် အကြောင်းရင်းကို ဖော်ပြပါ။ အီးမေးလ်ဖြင့် ပေးပို့ပါမည်။';

  @override
  String get reportReasonPlaceholder => 'တိုင်ကြားရသည့် အကြောင်းရင်း ထည့်ပါ...';

  @override
  String get reportSubmitButton => 'တိုင်ကြားရန်';

  @override
  String get deleteConfirmTitle => 'ပို့စ်ဖျက်ရန်';

  @override
  String get deleteConfirmMessage => 'ဤပို့စ်ကို ဖျက်လိုတာ သေချာပါသလား?';

  @override
  String get errorNetwork => 'အင်တာနက်ချိတ်ဆက်မှုကို စစ်ဆေးပြီး ထပ်ကြိုးစားပါ။';

  @override
  String get errorAiFallback =>
      'AI ကို ယခု ဆက်သွယ်၍မရပါ။ ဒီမှာ ကျမ်းပိုဒ်တစ်ခု ရှိပါသည်။';

  @override
  String get errorSttFailed => 'အသံမှတ်သားခြင်း မရနိုင်ပါ။ စာရိုက်၍ ထည့်ပါ။';

  @override
  String get errorPayment =>
      'ငွေပေးချေမှုတွင် ပြဿနာရှိပါသည်။ ဆက်တင်များတွင် ထပ်ကြိုးစားပါ။';

  @override
  String get errorGeneric => 'တစ်ခုခု မှားသွားပါသည်။ နောက်မှ ထပ်ကြိုးစားပါ။';

  @override
  String get offlineNotice =>
      'အော့ဖ်လိုင်းဖြစ်နေပါသည်။ အချို့လုပ်ဆောင်ချက်များ ကန့်သတ်ထားနိုင်ပါသည်။';

  @override
  String get retryButton => 'ထပ်ကြိုးစားရန်';

  @override
  String get groupSection => 'ကျွန်ုပ်၏ အဖွဲ့များ';

  @override
  String get createGroup => 'ဆုတောင်းအဖွဲ့ ဖွဲ့ရန်';

  @override
  String get inviteFriends => 'သူငယ်ချင်းများ ဖိတ်ရန်';

  @override
  String get groupInviteMessage =>
      'အတူဆုတောင်းကြရအောင်! Abba ပေါ်ရှိ ဆုတောင်းအဖွဲ့သို့ ပါဝင်ပါ။';

  @override
  String get noGroups => 'အတူဆုတောင်းရန် အဖွဲ့တစ်ခု ပါဝင်ပါ သို့ ဖွဲ့စည်းပါ။';

  @override
  String get promoTitle => 'မိတ်ဆက်အထူးလျှော့ဈေး';

  @override
  String get promoBanner => 'ပထမ 3 လ \$4.99/လ ဖြင့်!';

  @override
  String promoEndsOn(Object date) {
    return 'ကမ်းလှမ်းချက် $date တွင် ကုန်ဆုံးမည်';
  }

  @override
  String get proLimitTitle => 'ယနေ့ဆုတောင်းချက် ပြီးဆုံးပါပြီ';

  @override
  String get proLimitBody =>
      'မနက်ဖြန် ပြန်ဆုံကြမယ်!\nPro ဖြင့် အကန့်အသတ်မရှိ ဆုတောင်းပါ';

  @override
  String get laterButton => 'နောက်မှ';

  @override
  String get proPromptTitle => 'Pro လုပ်ဆောင်ချက်';

  @override
  String get proPromptBody =>
      'ဤလုပ်ဆောင်ချက်သည် Pro ဖြင့် ရနိုင်ပါသည်။\nအစီအစဉ်များ ကြည့်လိုပါသလား?';

  @override
  String get viewProducts => 'အစီအစဉ်များ ကြည့်ရန်';

  @override
  String get maybeLater => 'နောက်မှ';

  @override
  String get proHeadline => 'ဘုရားသခင်နှင့် နေ့တိုင်း ပိုနီးကပ်စွာ';

  @override
  String get proBenefit1 => 'အကန့်အသတ်မဲ့ ဆုတောင်းခြင်း & တိတ်ဆိတ်ချိန်';

  @override
  String get proBenefit2 => 'AI ဆုတောင်းချက် & လမ်းညွှန်ချက်';

  @override
  String get proBenefit3 => 'သမိုင်းမှ ယုံကြည်ခြင်းဇာတ်လမ်းများ';

  @override
  String get proBenefit5 => 'မူရင်းဘာသာဖြင့် ကျမ်းစာလေ့လာခြင်း';

  @override
  String get bestValue => 'တန်ဖိုးအရှိဆုံး';

  @override
  String get perMonth => 'လ';

  @override
  String get cancelAnytime => 'အချိန်မရွေး ပယ်ဖျက်နိုင်';

  @override
  String get restorePurchase => 'ဝယ်ယူမှု ပြန်ရယူရန်';

  @override
  String get yearlyPriceMonthly => '\$4.17/လ';

  @override
  String get morningPrayerReminder => 'နံနက်ဆုတောင်းချက်';

  @override
  String get eveningGratitudeReminder => 'ညနေကျေးဇူးတင်ခြင်း';

  @override
  String get streakReminder => 'ဆက်တိုက်သတိပေးချက်';

  @override
  String get afternoonNudgeReminder => 'နေ့လည်ဆုတောင်းသတိပေးချက်';

  @override
  String get weeklySummaryReminder => 'အပတ်စဉ်အကျဉ်းချုပ်';

  @override
  String get unlimited => 'အကန့်အသတ်မရှိ';

  @override
  String get streakRecovery => 'ရပါတယ်၊ ပြန်စနိုင်ပါတယ် 🌱';

  @override
  String get prayerSaved => 'ဆုတောင်းချက် သိမ်းဆည်းပြီးပါပြီ';

  @override
  String get quietTimeLabel => 'တိတ်ဆိတ်ချိန်';

  @override
  String get morningPrayerLabel => 'နံနက်ဆုတောင်းချက်';

  @override
  String get gardenSeed => 'ယုံကြည်ခြင်းအစေ့';

  @override
  String get gardenSprout => 'ပေါက်ပင်ငယ်';

  @override
  String get gardenBud => 'ပန်းငုံ';

  @override
  String get gardenBloom => 'ပန်းပွင့်ပြည့်';

  @override
  String get gardenTree => 'ခိုင်မာသောသစ်ပင်';

  @override
  String get gardenForest => 'ဆုတောင်းခြင်းသစ်တော';

  @override
  String get milestoneShare => 'မျှဝေရန်';

  @override
  String get milestoneThankGod => 'ဘုရားသခင်ကို ကျေးဇူးတင်ပါသည်!';

  @override
  String shareStreakText(Object count) {
    return '$count ရက် ဆက်တိုက်ဆုတောင်းခြင်း! Abba နှင့် ဆုတောင်းခရီး #Abba #ဆုတောင်းခြင်း';
  }

  @override
  String get shareDaysLabel => 'ရက် ဆက်တိုက်ဆုတောင်းခြင်း';

  @override
  String get shareSubtitle => 'ဘုရားသခင်နှင့် နေ့စဉ်ဆုတောင်းခြင်း';

  @override
  String get proActive => 'အသင်းဝင် တက်ကြွ';

  @override
  String get planOncePerDay => '1 ကြိမ်/ရက်';

  @override
  String get planUnlimited => 'အကန့်အသတ်မရှိ';

  @override
  String get closeRecording => 'အသံဖမ်းခြင်း ပိတ်ရန်';

  @override
  String get qtRevealMessage => 'ယနေ့နှုတ်ကပတ်တော်ကို ဖွင့်ကြရအောင်';

  @override
  String get qtSelectPrompt =>
      'ခေါင်းစဉ်တစ်ခု ရွေးပြီး ယနေ့တိတ်ဆိတ်ချိန် စတင်ပါ';

  @override
  String get qtTopicLabel => 'ခေါင်းစဉ်';

  @override
  String get prayerStartPrompt => 'ဆုတောင်းခြင်း စတင်ပါ';

  @override
  String get startPrayerButton => 'ဆုတောင်း စတင်ရန်';

  @override
  String get switchToTextMode => 'စာရိုက်ရန်';

  @override
  String get switchToVoiceMode => 'စကားပြော';

  @override
  String get prayerDashboardTitle => 'ဆုတောင်းခြင်းဥယျာဉ်';

  @override
  String get qtDashboardTitle => 'တိတ်ဆိတ်ချိန်ဥယျာဉ်';

  @override
  String get prayerSummaryTitle => 'ဆုတောင်းချက် အကျဉ်းချုပ်';

  @override
  String get gratitudeLabel => 'ကျေးဇူးတင်ခြင်း';

  @override
  String get petitionLabel => 'တောင်းလျှောက်ခြင်း';

  @override
  String get intercessionLabel => 'ကြားဝင်ဆုတောင်းခြင်း';

  @override
  String get historicalStoryTitle => 'သမိုင်းမှ ဇာတ်လမ်း';

  @override
  String get todayLesson => 'ယနေ့သင်ခန်းစာ';

  @override
  String get applicationTitle => 'ယနေ့အသုံးချခြင်း';

  @override
  String get applicationWhat => 'ဘာ';

  @override
  String get applicationWhen => 'ဘယ်အချိန်';

  @override
  String get applicationContext => 'ဘယ်နေရာ';

  @override
  String get applicationMorningLabel => 'နံနက်';

  @override
  String get applicationDayLabel => 'နေ့လယ်';

  @override
  String get applicationEveningLabel => 'ညနေ';

  @override
  String get relatedKnowledgeTitle => 'ဆက်စပ်ဗဟုသုတ';

  @override
  String get originalWordLabel => 'မူရင်းစကားလုံး';

  @override
  String get historicalContextLabel => 'သမိုင်းဆိုင်ရာ အကြောင်းအရာ';

  @override
  String get crossReferencesLabel => 'ဆက်စပ်ကျမ်းပိုဒ်များ';

  @override
  String get growthStoryTitle => 'ကြီးထွားမှုဇာတ်လမ်း';

  @override
  String get prayerGuideTitle => 'Abba ဖြင့် ဆုတောင်းနည်း';

  @override
  String get prayerGuide1 => 'ကျယ်လောင်စွာ သို့ ရှင်းလင်းစွာ ဆုတောင်းပါ';

  @override
  String get prayerGuide2 =>
      'Abba သင့်ဆုတောင်းချက်ကို နားထောင်ပြီး စိတ်ကိုထိမိသော ကျမ်းပိုဒ်ကို ရှာပေးသည်';

  @override
  String get prayerGuide3 => 'ဆုတောင်းချက်ကို စာဖြင့်လည်း ရေးနိုင်ပါသည်';

  @override
  String get qtGuideTitle => 'Abba ဖြင့် တိတ်ဆိတ်ချိန် ယူနည်း';

  @override
  String get qtGuide1 => 'ကျမ်းပိုဒ်ကို ဖတ်ပြီး တိတ်ဆိတ်စွာ ဆင်ခြင်ပါ';

  @override
  String get qtGuide2 =>
      'သင်ရှာတွေ့သည်ကို မျှဝေပါ — ပြောပါ သို့ သင့်ဆင်ခြင်မှုကို ရေးပါ';

  @override
  String get qtGuide3 =>
      'Abba သည် နှုတ်ကပတ်တော်ကို နေ့စဉ်ဘဝတွင် အသုံးချရန် ကူညီပေးမည်';

  @override
  String get scriptureReasonLabel => 'ဤကျမ်းပိုဒ်ကို ဘာကြောင့်';

  @override
  String get scripturePostureLabel => 'ဘယ်လိုစိတ်ဓာတ်နဲ့ဖတ်ရမလဲ?';

  @override
  String get scriptureOriginalWordsTitle =>
      'မူရင်းဘာသာစကားတွင် ပိုနက်ရှိုင်းသောအဓိပ္ပါယ်';

  @override
  String get originalWordMeaningLabel => 'အဓိပ္ပါယ်';

  @override
  String get originalWordNuanceLabel => 'ဘာသာပြန်နှင့်ခြားနားချက်';

  @override
  String originalWordsCountLabel(int count) {
    return '$count စကားလုံး';
  }

  @override
  String get seeMore => 'ပိုမိုကြည့်ရန်';

  @override
  String seeAllComments(Object count) {
    return 'မှတ်ချက် $count ခုလုံးကို ကြည့်ရန်';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name နှင့် အခြား $count ဦး နှစ်သက်သည်';
  }

  @override
  String get commentsTitle => 'မှတ်ချက်များ';

  @override
  String get myPageTitle => 'ကျွန်ုပ်၏ ဆုတောင်းခြင်းဥယျာဉ်';

  @override
  String get myPrayers => 'ကျွန်ုပ်၏ ဆုတောင်းချက်များ';

  @override
  String get myTestimonies => 'ကျွန်ုပ်၏ သက်သေခံချက်များ';

  @override
  String get savedPosts => 'သိမ်းဆည်းထားသည်';

  @override
  String get totalPrayersCount => 'ဆုတောင်းချက်';

  @override
  String get streakCount => 'ဆက်တိုက်';

  @override
  String get testimoniesCount => 'သက်သေခံချက်';

  @override
  String get linkAccountTitle => 'အကောင့်ချိတ်ဆက်ရန်';

  @override
  String get linkAccountDescription =>
      'စက်ပြောင်းသောအခါ ဆုတောင်းမှတ်တမ်းများ ထိန်းသိမ်းရန် အကောင့်ကို ချိတ်ဆက်ပါ';

  @override
  String get linkWithApple => 'Apple ဖြင့် ချိတ်ဆက်ရန်';

  @override
  String get linkWithGoogle => 'Google ဖြင့် ချိတ်ဆက်ရန်';

  @override
  String get linkAccountSuccess => 'အကောင့် ချိတ်ဆက်မှု အောင်မြင်ပါပြီ!';

  @override
  String get anonymousUser => 'ဆုတောင်းစစ်သည်';

  @override
  String showReplies(Object count) {
    return 'ပြန်ဖြေချက် $count ခု ကြည့်ရန်';
  }

  @override
  String get hideReplies => 'ပြန်ဖြေချက်များ ဖျောက်ရန်';

  @override
  String replyingTo(Object name) {
    return '$name ကို ပြန်ဖြေနေသည်';
  }

  @override
  String viewAllComments(Object count) {
    return 'မှတ်ချက် $count ခုလုံးကို ကြည့်ရန်';
  }

  @override
  String get membershipTitle => 'အသင်းဝင်';

  @override
  String get membershipSubtitle => 'ဆုတောင်းခြင်းကို ပိုမိုနက်ရှိုင်းစေပါ';

  @override
  String get monthlyPlan => 'လစဉ်';

  @override
  String get yearlyPlan => 'နှစ်စဉ်';

  @override
  String get yearlySavings => '\$4.17/လ (40% လျှော့)';

  @override
  String get startMembership => 'စတင်ပါ';

  @override
  String get membershipActive => 'အသင်းဝင် တက်ကြွ';

  @override
  String get leaveRecordingTitle => 'အသံဖမ်းခြင်းမှ ထွက်မလား?';

  @override
  String get leaveRecordingMessage =>
      'သင့်အသံဖမ်းချက် ပျောက်သွားပါမည်။ သေချာပါသလား?';

  @override
  String get leaveButton => 'ထွက်မည်';

  @override
  String get stayButton => 'ဆက်နေမည်';

  @override
  String likedByCount(Object count) {
    return '$count ဦး စာနာခဲ့သည်';
  }

  @override
  String get actionLike => 'နှစ်သက်';

  @override
  String get actionComment => 'မှတ်ချက်';

  @override
  String get actionSave => 'သိမ်းဆည်း';

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
  String get billingIssueTitle => 'ငွေပေးချေမှု ပြဿနာ တွေ့ရှိခဲ့သည်';

  @override
  String billingIssueBody(int days) {
    return 'ငွေပေးချေမှုကို မမွမ်းမံပါက Pro အကျိုးခံစားခွင့်များသည် $days ရက်အတွင်း ကုန်ဆုံးမည်။';
  }

  @override
  String get billingIssueAction => 'ငွေပေးချေမှု မွမ်းမံရန်';

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
      '💛 မေတ္တာ — ချစ်ခင်သူတစ်ယောက်အကြောင်းကို ၁၀ စက္ကန့် စဉ်းစားပါ';

  @override
  String get qtLoadingHint2 =>
      '🌿 ကျေးဇူးတော် — ယနေ့ ရရှိသော ကျေးဇူးတော်ငယ်တစ်ခုကို ပြန်လည်သတိရပါ';

  @override
  String get qtLoadingHint3 =>
      '🌅 မျှော်လင့်ချက် — မနက်ဖြန်အတွက် မျှော်လင့်ချက်ငယ်တစ်ခုကို စိတ်ထဲ ပုံဖော်ပါ';

  @override
  String get qtLoadingHint4 =>
      '🕊️ ငြိမ်သက်ခြင်း — အသက်ကို သုံးကြိမ် ဖြည်းဖြည်း လေးလေးနက်နက် ရှူပါ';

  @override
  String get qtLoadingHint5 =>
      '🌳 ယုံကြည်ခြင်း — မပြောင်းလဲသော အမှန်တရားတစ်ခုကို သတိရပါ';

  @override
  String get qtLoadingHint6 =>
      '🌸 ကျေးဇူးတင်ခြင်း — ယခု ကျေးဇူးတင်စရာ တစ်ခုကို ဖော်ပြပါ';

  @override
  String get qtLoadingHint7 =>
      '🌊 ခွင့်လွှတ်ခြင်း — ခွင့်လွှတ်လိုသူတစ်ယောက်ကို စိတ်ထဲ ရေးဆွဲပါ';

  @override
  String get qtLoadingHint8 =>
      '📖 ဉာဏ်ပညာ — ယနေ့၏ သင်ခန်းစာတစ်ခုကို စိတ်ထဲ မှတ်ထားပါ';

  @override
  String get qtLoadingHint9 =>
      '⏳ သည်းခံခြင်း — တိတ်ဆိတ်စွာ စောင့်ဆိုင်းနေသောအရာကို စဉ်းစားပါ';

  @override
  String get qtLoadingHint10 =>
      '✨ ဝမ်းမြောက်ခြင်း — ယနေ့ ပြုံးခဲ့သည့် အချိန်တစ်ခုကို ပြန်လည်သတိရပါ';

  @override
  String get qtLoadingTitle => 'ယနေ့၏ နှုတ်ကပါဌ်တော်ကို ပြင်ဆင်နေပါသည်...';

  @override
  String get coachingTitle => 'ဆုတောင်းခြင်း သင်တန်း';

  @override
  String get coachingLoadingText =>
      'သင်၏ဆုတောင်းချက်ကို ပြန်လည်သုံးသပ်နေပါသည်...';

  @override
  String get coachingErrorText => 'ယာယီ အမှား — ပြန်စမ်းကြည့်ပါ';

  @override
  String get coachingRetryButton => 'ပြန်ကြိုးစားပါ';

  @override
  String get coachingScoreSpecificity => 'တိကျမှု';

  @override
  String get coachingScoreGodCentered => 'ဘုရားဗဟိုပြု';

  @override
  String get coachingScoreActs => 'ACTS ချိန်ခွင်လျှာ';

  @override
  String get coachingScoreAuthenticity => 'စစ်မှန်မှု';

  @override
  String get coachingStrengthsTitle => 'ကောင်းမွန်စွာလုပ်ခဲ့သည်များ ✨';

  @override
  String get coachingImprovementsTitle => 'ပိုမိုနက်ရှိုင်းရန် 💡';

  @override
  String get coachingProCta => 'Pro ဖြင့် ဆုတောင်းခြင်း သင်တန်းကို ဖွင့်ပါ';

  @override
  String get coachingLevelBeginner => '🌱 စတင်နေသူ';

  @override
  String get coachingLevelGrowing => '🌿 ကြီးထွားနေသူ';

  @override
  String get coachingLevelExpert => '🌳 ကျွမ်းကျင်သူ';

  @override
  String get aiPrayerCitationsTitle => 'ရည်ညွှန်းချက်များ · ကိုးကားချက်များ';

  @override
  String get citationTypeQuote => 'ကိုးကားချက်';

  @override
  String get citationTypeScience => 'သုတေသန';

  @override
  String get citationTypeExample => 'ဥပမာ';

  @override
  String get citationTypeHistory => 'သမိုင်း';

  @override
  String get aiPrayerReadingTime => '၂ မိနစ် ဖတ်ရန်';

  @override
  String get scriptureKeyWordHintTitle => 'ယနေ့ အဓိက စကားလုံး';

  @override
  String get bibleLookupReferenceHint =>
      'ဤကျမ်းပိုဒ်ကို သင်၏ကျမ်းစာတွင် ရှာပြီး ဆင်ခြင်ပါ။';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'ကျမ်းစာ ဘာသာပြန်များ';

  @override
  String get settingsBibleTranslationsIntro =>
      'ဤအက်ပ်မှ ကျမ်းပိုဒ်များသည် ပြည်သူပိုင် ဘာသာပြန်များမှ ရယူထားသည်။ AI ဖြင့် ထုတ်လုပ်သော မှတ်ချက်များ၊ ဆုတောင်းချက်များနှင့် ပုံပြင်များသည် Abba ၏ ဖန်တီးမှုလက်ရာများဖြစ်သည်။';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'QT သင်တန်း';

  @override
  String get qtCoachingLoadingText =>
      'သင်၏ တရားထိုင်ခြင်းကို ပြန်လည်သုံးသပ်နေပါသည်...';

  @override
  String get qtCoachingErrorText => 'ယာယီ အမှား — ပြန်စမ်းကြည့်ပါ';

  @override
  String get qtCoachingRetryButton => 'ပြန်ကြိုးစားပါ';

  @override
  String get qtCoachingScoreComprehension => 'ကျမ်းစာ နားလည်မှု';

  @override
  String get qtCoachingScoreApplication => 'ကိုယ်ပိုင် အသုံးချမှု';

  @override
  String get qtCoachingScoreDepth => 'ဝိညာဉ်ရေး နက်ရှိုင်းမှု';

  @override
  String get qtCoachingScoreAuthenticity => 'စစ်မှန်မှု';

  @override
  String get qtCoachingStrengthsTitle => 'ကောင်းမွန်စွာလုပ်ခဲ့သည်များ ✨';

  @override
  String get qtCoachingImprovementsTitle => 'ပိုမိုနက်ရှိုင်းရန် 💡';

  @override
  String get qtCoachingProCta => 'Pro ဖြင့် QT သင်တန်းကို ဖွင့်ပါ';

  @override
  String get qtCoachingLevelBeginner => '🌱 စတင်နေသူ';

  @override
  String get qtCoachingLevelGrowing => '🌿 ကြီးထွားနေသူ';

  @override
  String get qtCoachingLevelExpert => '🌳 ကျွမ်းကျင်သူ';

  @override
  String get notifyMorning1Title => '🙏 ဆုတောင်းချိန်ရောက်ပြီ';

  @override
  String notifyMorning1Body(String name) {
    return '$name၊ ဒီနေ့လည်း ဘုရားသခင်နှင့် စကားပြောကြည့်ပါ';
  }

  @override
  String get notifyMorning2Title => '🌅 နံနက်အသစ်တစ်ခုရောက်လာပြီ';

  @override
  String notifyMorning2Body(String name) {
    return '$name၊ ကျေးဇူးတင်ခြင်းဖြင့် တစ်နေ့တာကို စတင်ပါ';
  }

  @override
  String get notifyMorning3Title => '✨ ယနေ့ကျေးဇူးတော်';

  @override
  String notifyMorning3Body(String name) {
    return '$name၊ ဘုရားသခင်ပြင်ဆင်ထားသော ကျေးဇူးတော်ကို တွေ့ကြုံပါ';
  }

  @override
  String get notifyMorning4Title => '🕊️ ငြိမ်းချမ်းသောနံနက်';

  @override
  String notifyMorning4Body(String name) {
    return '$name၊ ဆုတောင်းခြင်းဖြင့် စိတ်နှလုံးကို ငြိမ်းချမ်းမှုဖြင့် ဖြည့်ပါ';
  }

  @override
  String get notifyMorning5Title => '📖 နှုတ်ကပါတ်တော်နှင့်အတူ';

  @override
  String notifyMorning5Body(String name) {
    return '$name၊ ယနေ့ ဘုရားသခင်၏အသံကို နားထောင်ပါ';
  }

  @override
  String get notifyMorning6Title => '🌿 အနားယူချိန်';

  @override
  String notifyMorning6Body(String name) {
    return '$name၊ ခဏနားပြီး ဆုတောင်းပါ';
  }

  @override
  String get notifyMorning7Title => '💫 ယနေ့လည်း';

  @override
  String notifyMorning7Body(String name) {
    return '$name၊ ဆုတောင်းခြင်းဖြင့်စတင်သောနေ့သည် ထူးခြားသည်';
  }

  @override
  String get notifyEvening1Title => '✨ ယနေ့အတွက်ကျေးဇူးတင်ပါသည်';

  @override
  String get notifyEvening1Body =>
      'ယနေ့ကို ပြန်လည်သုံးသပ်ပြီး ကျေးဇူးတင်ဆုတောင်းခြင်းပြုပါ';

  @override
  String get notifyEvening2Title => '🌙 တစ်နေ့တာကိုနိဂုံးချုပ်ရင်း';

  @override
  String get notifyEvening2Body =>
      'ယနေ့၏ကျေးဇူးတင်ခြင်းကို ဆုတောင်းခြင်းဖြင့် ဖော်ပြပါ';

  @override
  String get notifyEvening3Title => '🙏 ညနေခင်းဆုတောင်းခြင်း';

  @override
  String get notifyEvening3Body =>
      'တစ်နေ့တာအဆုံးတွင် ဘုရားသခင်ကို ကျေးဇူးတင်ပါ';

  @override
  String get notifyEvening4Title => '🌟 ယနေ့၏ကောင်းချီးများကို ရေတွက်ရင်း';

  @override
  String get notifyEvening4Body =>
      'ကျေးဇူးတင်စရာရှိပါက ဆုတောင်းခြင်းဖြင့် မျှဝေပါ';

  @override
  String get notifyStreak3Title => '🌱 3 ရက်ဆက်တိုက်!';

  @override
  String get notifyStreak3Body => 'သင်၏ ဆုတောင်းအလေ့အထ စတင်နေပြီ';

  @override
  String get notifyStreak7Title => '🌿 တစ်ပတ်လုံး!';

  @override
  String get notifyStreak7Body => 'ဆုတောင်းခြင်းသည် အလေ့အထဖြစ်လာနေပြီ';

  @override
  String get notifyStreak14Title => '🌳 2 ပတ်ဆက်တိုက်!';

  @override
  String get notifyStreak14Body => 'အံ့သြဖွယ်တိုးတက်မှု!';

  @override
  String get notifyStreak21Title => '🌻 3 ပတ်ဆက်တိုက်!';

  @override
  String get notifyStreak21Body => 'ဆုတောင်းခြင်း၏ပန်း ပွင့်လာနေပြီ';

  @override
  String get notifyStreak30Title => '🏆 တစ်လလုံး!';

  @override
  String get notifyStreak30Body => 'သင်၏ဆုတောင်းချက် တောက်ပနေသည်';

  @override
  String get notifyStreak50Title => '👑 50 ရက်ဆက်တိုက်!';

  @override
  String get notifyStreak50Body =>
      'ဘုရားသခင်နှင့်အတူ လျှောက်လှမ်းခြင်းသည် နက်ရှိုင်းလာနေသည်';

  @override
  String get notifyStreak100Title => '🎉 100 ရက်ဆက်တိုက်!';

  @override
  String get notifyStreak100Body => 'သင်သည် ဆုတောင်းခြင်းစစ်သူရဲ ဖြစ်လာပြီ!';

  @override
  String get notifyStreak365Title => '✝️ တစ်နှစ်လုံး!';

  @override
  String get notifyStreak365Body => 'အံ့သြဖွယ်ယုံကြည်ခြင်း၏ခရီးစဉ်!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ ယနေ့ ဆုတောင်းပြီးပြီလား?';

  @override
  String get notifyAfternoonNudgeBody =>
      'ခဏတာဆုတောင်းခြင်းက တစ်နေ့တာကို ပြောင်းလဲနိုင်သည်';

  @override
  String get notifyChannelName => 'ဆုတောင်းခြင်းသတိပေးချက်များ';

  @override
  String get notifyChannelDescription =>
      'နံနက်ဆုတောင်းခြင်း၊ ညနေကျေးဇူးတင်ခြင်းနှင့် အခြားဆုတောင်းခြင်းသတိပေးချက်များ';

  @override
  String get milestoneFirstPrayerTitle => 'ပထမဆုံးဆုတောင်း!';

  @override
  String get milestoneFirstPrayerDesc =>
      'သင်၏ဆုတောင်းခရီးစတင်ပြီ။ ဘုရားသခင်နားထောင်နေသည်။';

  @override
  String get milestoneSevenDayStreakTitle => '၇ ရက်ဆုတောင်း!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'တစ်ပတ်ကြာသစ္စာရှိသောဆုတောင်း။ သင့်ဥယျာဉ်ကြီးထွားနေပါပြီ!';

  @override
  String get milestoneThirtyDayStreakTitle => '၃၀ ရက်!';

  @override
  String get milestoneThirtyDayStreakDesc => 'သင့်ဥယျာဉ်သည် ပန်းခင်းဖြစ်လာပြီ!';

  @override
  String get milestoneHundredPrayersTitle => 'အကြိမ် ၁၀၀ ဆုတောင်း!';

  @override
  String get milestoneHundredPrayersDesc =>
      'ဘုရားသခင်နှင့် စကားပြောဆိုမှု ၁၀၀။ သင်သည် အမြစ်တွယ်ပြီ။';

  @override
  String get homeFirstPrayerPrompt => 'သင်၏ပထမဆုံးဆုတောင်းကိုစတင်ပါ';

  @override
  String get homeFirstQtPrompt => 'သင်၏ပထမဆုံး QT ကိုစတင်ပါ';

  @override
  String homeActivityPrompt(String activityName) {
    return 'ဒီနေ့လည်း $activityName လုပ်ပါ';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return '$activityName ဆက်တိုက် $count ရက်မြောက်';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'နောက်ဆုံး $activityName ကတည်းက $days ရက်ကြာပြီ';
  }

  @override
  String get homeActivityPrayer => 'ဆုတောင်း';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'ဖွင့်နေသည်...';

  @override
  String get heatmapNoPrayer => 'ဆုတောင်းမရှိ';

  @override
  String get heatmapLegendLess => 'နည်း';

  @override
  String get heatmapLegendMore => 'များ';

  @override
  String get qtPassagesLoadError =>
      'ယနေ့ကျမ်းပိုဒ်များကို တင်၍မရပါ။ ချိတ်ဆက်မှုကို စစ်ဆေးပါ။';

  @override
  String get qtPassagesRetryButton => 'ထပ်မံကြိုးစားပါ';

  @override
  String get aiStreamingInitial => 'သင်၏ဆုတောင်းကို ဆင်ခြင်နေပါသည်...';

  @override
  String get aiTierProcessing => 'ထပ်မံသောစဉ်းစားမှုများ လာနေပါသည်...';

  @override
  String get aiScriptureValidating => 'သင့်လျော်သောကျမ်းပိုဒ်ကို ရှာနေပါသည်...';

  @override
  String get aiScriptureValidatingFailed =>
      'ဤကျမ်းပိုဒ်ကို သင့်အတွက် ပြင်ဆင်နေပါသည်...';

  @override
  String get aiTemplateFallback => 'သင်၏ခြုံငုံသုံးသပ်ချက်ကို ပြင်ဆင်နေစဉ်...';

  @override
  String get aiPendingMore => 'ထပ်မံ ပြင်ဆင်နေပါသည်...';

  @override
  String get aiTierIncomplete => 'မကြာမီ ရောက်မည်၊ နောက်ပိုင်း ပြန်ကြည့်ပါ';

  @override
  String get tierCompleted => 'စဉ်းစားမှုအသစ် ထပ်ထည့်ထားသည်';

  @override
  String get tierProcessingNotice => 'ထပ်မံစဉ်းစားမှုများ ဖန်တီးနေပါသည်...';

  @override
  String get proSectionLoading =>
      'သင်၏ premium အကြောင်းအရာကို ပြင်ဆင်နေပါသည်...';

  @override
  String get proSectionWillArrive =>
      'သင်၏နက်နဲသော စဉ်းစားမှုသည် ဤနေရာတွင် ပေါ်လာမည်';

  @override
  String get templateCategoryHealth => 'ကျန်းမာရေးစိုးရိမ်မှုများအတွက်';

  @override
  String get templateCategoryFamily => 'မိသားစုအတွက်';

  @override
  String get templateCategoryWork => 'အလုပ်နှင့် ပညာရေးအတွက်';

  @override
  String get templateCategoryGratitude => 'ကျေးဇူးတင်သောစိတ်';

  @override
  String get templateCategoryGrief =>
      'ဝမ်းနည်းခြင်း သို့မဟုတ် ဆုံးရှုံးခြင်းတွင်';

  @override
  String get sectionStatusCompleted => 'သုံးသပ်ချက် ပြီးဆုံးပြီ';

  @override
  String get sectionStatusPartial => 'တစ်စိတ်တစ်ပိုင်း သုံးသပ်ချက် (ထပ်လာဆဲ)';

  @override
  String get sectionStatusPending => 'သုံးသပ်ချက် ဆက်လက်လုပ်ဆောင်နေသည်';
}
