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
  String get testimonyTitle => 'ကျွန်ုပ်၏ သက်သေခံချက်';

  @override
  String get testimonyEdit => 'တည်းဖြတ်ရန်';

  @override
  String get guidanceTitle => 'AI လမ်းညွှန်ချက်';

  @override
  String get aiPrayerTitle => 'သင့်အတွက် ဆုတောင်းချက်';

  @override
  String get originalLangTitle => 'မူရင်းဘာသာ';

  @override
  String get premiumUnlock => 'Premium ဖြင့် ဖွင့်ရန်';

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
  String get premiumSection => 'Premium';

  @override
  String get freePlan => 'အခမဲ့';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get monthlyPrice => '\$3.49/လ';

  @override
  String get yearlyPrice => '\$24.99/နှစ်';

  @override
  String get yearlySave => '40% ချွေတာ';

  @override
  String get launchPromo => '3 လ \$4.99/လ ဖြင့်!';

  @override
  String get startPremium => 'Premium စတင်ရန်';

  @override
  String get comingSoon => 'မကြာမီ';

  @override
  String get notificationSetting => 'အကြောင်းကြားချက်များ';

  @override
  String get aiVoiceSetting => 'AI အသံ';

  @override
  String get voiceWarm => 'နွေးထွေး';

  @override
  String get voiceCalm => 'တည်ငြိမ်';

  @override
  String get voiceStrong => 'ခိုင်မာ';

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
  String get premiumLimitTitle => 'ယနေ့ဆုတောင်းချက် ပြီးဆုံးပါပြီ';

  @override
  String get premiumLimitBody =>
      'မနက်ဖြန် ပြန်ဆုံကြမယ်!\nPremium ဖြင့် အကန့်အသတ်မရှိ ဆုတောင်းပါ';

  @override
  String get laterButton => 'နောက်မှ';

  @override
  String get premiumPromptTitle => 'Pro လုပ်ဆောင်ချက်';

  @override
  String get premiumPromptBody =>
      'ဤလုပ်ဆောင်ချက်သည် Pro ဖြင့် ရနိုင်ပါသည်။\nအစီအစဉ်များ ကြည့်လိုပါသလား?';

  @override
  String get viewProducts => 'အစီအစဉ်များ ကြည့်ရန်';

  @override
  String get maybeLater => 'နောက်မှ';

  @override
  String get premiumHeadline => 'ဘုရားသခင်နှင့် နေ့တိုင်း ပိုနီးကပ်စွာ';

  @override
  String get premiumBenefit1 => 'အကန့်အသတ်မဲ့ ဆုတောင်းခြင်း & တိတ်ဆိတ်ချိန်';

  @override
  String get premiumBenefit2 => 'AI ဆုတောင်းချက် & လမ်းညွှန်ချက်';

  @override
  String get premiumBenefit3 => 'သမိုင်းမှ ယုံကြည်ခြင်းဇာတ်လမ်းများ';

  @override
  String get premiumBenefit4 => 'ဆုတောင်းချက် ဖတ်ပြခြင်း (TTS)';

  @override
  String get premiumBenefit5 => 'မူရင်းဘာသာဖြင့် ကျမ်းစာလေ့လာခြင်း';

  @override
  String get bestValue => 'တန်ဖိုးအရှိဆုံး';

  @override
  String get perMonth => 'လ';

  @override
  String get cancelAnytime => 'အချိန်မရွေး ပယ်ဖျက်နိုင်';

  @override
  String get restorePurchase => 'ဝယ်ယူမှု ပြန်ရယူရန်';

  @override
  String get yearlyPriceMonthly => '\$2.08/လ';

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
  String get premiumActive => 'Premium အသုံးပြုနေဆဲ';

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
  String get meditationAnalysisTitle => 'ဆင်ခြင်ခြင်း ခွဲခြမ်းစိတ်ဖြာမှု';

  @override
  String get keyThemeLabel => 'အဓိကခေါင်းစဉ်';

  @override
  String get applicationTitle => 'ယနေ့အသုံးချခြင်း';

  @override
  String get applicationWhat => 'ဘာ';

  @override
  String get applicationWhen => 'ဘယ်အချိန်';

  @override
  String get applicationContext => 'ဘယ်နေရာ';

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
}
