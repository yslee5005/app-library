// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'عندما تُصلّي،\nالله يستجيب.';

  @override
  String get welcomeSubtitle => 'رفيقك اليومي في الصلاة والخلوة';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get loginTitle => 'مرحبًا بك في Abba';

  @override
  String get loginSubtitle => 'سجّل الدخول لتبدأ رحلتك في الصلاة';

  @override
  String get signInWithApple => 'المتابعة مع Apple';

  @override
  String get signInWithGoogle => 'المتابعة مع Google';

  @override
  String get signInWithEmail => 'المتابعة بالبريد الإلكتروني';

  @override
  String greetingMorning(Object name) {
    return 'صباح الخير، $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'مساء الخير، $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'مساء الخير، $name';
  }

  @override
  String get prayButton => 'صلِّ';

  @override
  String get qtButton => 'خلوة';

  @override
  String streakDays(Object count) {
    return '$count يوم صلاة متواصلة';
  }

  @override
  String get dailyVerse => 'آية اليوم';

  @override
  String get tabHome => 'الرئيسية';

  @override
  String get tabCalendar => 'التقويم';

  @override
  String get tabCommunity => 'المجتمع';

  @override
  String get tabSettings => 'الإعدادات';

  @override
  String get recordingTitle => 'جاري الصلاة...';

  @override
  String get recordingPause => 'إيقاف مؤقت';

  @override
  String get recordingResume => 'استئناف';

  @override
  String get finishPrayer => 'إنهاء الصلاة';

  @override
  String get finishPrayerConfirm => 'هل تريد إنهاء صلاتك؟';

  @override
  String get switchToText => 'الكتابة بدلاً من ذلك';

  @override
  String get textInputHint => 'اكتب صلاتك هنا...';

  @override
  String get aiLoadingText => 'جاري التأمل في صلاتك...';

  @override
  String get aiLoadingVerse => 'كُفّوا واعلموا أني أنا الله.\n— مزمور 46:10';

  @override
  String get dashboardTitle => 'حديقة الصلاة';

  @override
  String get shareButton => 'مشاركة';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get scriptureTitle => 'كلمة اليوم';

  @override
  String get bibleStoryTitle => 'قصة من الكتاب المقدس';

  @override
  String get testimonyTitle => 'شهادة · صلاتي';

  @override
  String get testimonyHelperText => 'تأمل في صلاتك · يمكن مشاركتها مع المجتمع';

  @override
  String get myPrayerAudioLabel => 'تسجيل صلاتي';

  @override
  String get testimonyEdit => 'تعديل';

  @override
  String get guidanceTitle => 'إرشاد الذكاء الاصطناعي';

  @override
  String get aiPrayerTitle => 'صلاة من أجلك';

  @override
  String get originalLangTitle => 'اللغة الأصلية';

  @override
  String get proUnlock => 'افتح مع Pro';

  @override
  String get qtPageTitle => 'حديقة الصباح';

  @override
  String get qtMeditateButton => 'ابدأ التأمل';

  @override
  String get qtCompleted => 'مكتملة';

  @override
  String get communityTitle => 'حديقة الصلاة';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterTestimony => 'شهادة';

  @override
  String get filterPrayerRequest => 'طلب صلاة';

  @override
  String get likeButton => 'إعجاب';

  @override
  String get commentButton => 'تعليق';

  @override
  String get saveButton => 'حفظ';

  @override
  String get replyButton => 'رد';

  @override
  String get writePostTitle => 'مشاركة';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get sharePostButton => 'نشر';

  @override
  String get anonymousToggle => 'مجهول';

  @override
  String get realNameToggle => 'الاسم الحقيقي';

  @override
  String get categoryTestimony => 'شهادة';

  @override
  String get categoryPrayerRequest => 'طلب صلاة';

  @override
  String get writePostHint => 'شارك شهادتك أو طلب صلاتك...';

  @override
  String get importFromPrayer => 'استيراد من الصلاة';

  @override
  String get calendarTitle => 'تقويم الصلاة';

  @override
  String get currentStreak => 'السلسلة الحالية';

  @override
  String get bestStreak => 'أفضل سلسلة';

  @override
  String get days => 'أيام';

  @override
  String calendarRecordCount(Object count) {
    return '$count سجلات';
  }

  @override
  String get todayVerse => 'آية اليوم';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get profileSection => 'الملف الشخصي';

  @override
  String get totalPrayers => 'إجمالي الصلوات';

  @override
  String get consecutiveDays => 'أيام متتالية';

  @override
  String get proSection => 'العضوية';

  @override
  String get freePlan => 'مجاني';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '\$6.99 / شهر';

  @override
  String get yearlyPrice => '\$49.99 / سنة';

  @override
  String get yearlySave => 'وفّر 40%';

  @override
  String get launchPromo => '3 أشهر بسعر \$4.99/شهر!';

  @override
  String get startPro => 'ابدأ Pro';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get notificationSetting => 'الإشعارات';

  @override
  String get languageSetting => 'اللغة';

  @override
  String get darkModeSetting => 'الوضع الداكن';

  @override
  String get helpCenter => 'مركز المساعدة';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String appVersion(Object version) {
    return 'الإصدار $version';
  }

  @override
  String get anonymous => 'مجهول';

  @override
  String timeAgo(Object time) {
    return 'منذ $time';
  }

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get cancel => 'إلغاء';

  @override
  String get noPrayersRecorded => 'لا توجد صلوات مسجلة';

  @override
  String get deletePost => 'حذف';

  @override
  String get reportPost => 'إبلاغ';

  @override
  String get reportSubmitted => 'تم إرسال البلاغ. شكرًا لك.';

  @override
  String get reportReasonHint =>
      'يرجى وصف سبب الإبلاغ. سيتم إرساله عبر البريد الإلكتروني.';

  @override
  String get reportReasonPlaceholder => 'أدخل سبب الإبلاغ...';

  @override
  String get reportSubmitButton => 'إبلاغ';

  @override
  String get deleteConfirmTitle => 'حذف المنشور';

  @override
  String get deleteConfirmMessage => 'هل أنت متأكد من حذف هذا المنشور؟';

  @override
  String get errorNetwork =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get errorAiFallback =>
      'تعذر الوصول إلى الذكاء الاصطناعي. إليك آية لك.';

  @override
  String get errorSttFailed =>
      'التعرف على الصوت غير متاح. يرجى الكتابة بدلاً من ذلك.';

  @override
  String get errorPayment =>
      'حدثت مشكلة في الدفع. يرجى المحاولة مرة أخرى من الإعدادات.';

  @override
  String get errorGeneric => 'حدث خطأ ما. يرجى المحاولة لاحقًا.';

  @override
  String get offlineNotice =>
      'أنت غير متصل بالإنترنت. بعض الميزات قد تكون محدودة.';

  @override
  String get retryButton => 'حاول مرة أخرى';

  @override
  String get groupSection => 'مجموعاتي';

  @override
  String get createGroup => 'إنشاء مجموعة صلاة';

  @override
  String get inviteFriends => 'دعوة الأصدقاء';

  @override
  String get groupInviteMessage =>
      'لنصلِّ معًا! انضم إلى مجموعة الصلاة على Abba.';

  @override
  String get noGroups => 'انضم أو أنشئ مجموعة للصلاة معًا.';

  @override
  String get promoTitle => 'عرض الإطلاق';

  @override
  String get promoBanner => 'أول 3 أشهر بسعر \$4.99/شهر!';

  @override
  String promoEndsOn(Object date) {
    return 'ينتهي العرض في $date';
  }

  @override
  String get proLimitTitle => 'اكتملت صلاة اليوم';

  @override
  String get proLimitBody => 'نراك غدًا!\nصلِّ بلا حدود مع Pro';

  @override
  String get laterButton => 'لاحقًا';

  @override
  String get proPromptTitle => 'ميزة Pro';

  @override
  String get proPromptBody =>
      'هذه الميزة متاحة مع Pro.\nهل تريد الاطلاع على الخطط؟';

  @override
  String get viewProducts => 'عرض الخطط';

  @override
  String get maybeLater => 'ربما لاحقًا';

  @override
  String get proHeadline => 'أقرب إلى الله، كل يوم';

  @override
  String get proBenefit1 => 'صلاة وخلوة بلا حدود';

  @override
  String get proBenefit2 => 'صلاة وإرشاد بالذكاء الاصطناعي';

  @override
  String get proBenefit3 => 'قصص إيمان من التاريخ';

  @override
  String get proBenefit5 => 'دراسة الكتاب المقدس باللغة الأصلية';

  @override
  String get bestValue => 'أفضل قيمة';

  @override
  String get perMonth => 'شهر';

  @override
  String get cancelAnytime => 'إلغاء في أي وقت';

  @override
  String get restorePurchase => 'استعادة الشراء';

  @override
  String get yearlyPriceMonthly => '\$4.17/شهر';

  @override
  String get morningPrayerReminder => 'صلاة الصباح';

  @override
  String get eveningGratitudeReminder => 'شكر المساء';

  @override
  String get streakReminder => 'تذكير السلسلة';

  @override
  String get afternoonNudgeReminder => 'تذكير صلاة الظهر';

  @override
  String get weeklySummaryReminder => 'الملخص الأسبوعي';

  @override
  String get unlimited => 'غير محدود';

  @override
  String get streakRecovery => 'لا بأس، يمكنك البدء من جديد 🌱';

  @override
  String get prayerSaved => 'تم حفظ الصلاة بنجاح';

  @override
  String get quietTimeLabel => 'خلوة';

  @override
  String get morningPrayerLabel => 'صلاة الصباح';

  @override
  String get gardenSeed => 'بذرة إيمان';

  @override
  String get gardenSprout => 'برعم ينمو';

  @override
  String get gardenBud => 'زهرة ناشئة';

  @override
  String get gardenBloom => 'إزهار كامل';

  @override
  String get gardenTree => 'شجرة قوية';

  @override
  String get gardenForest => 'غابة الصلاة';

  @override
  String get milestoneShare => 'مشاركة';

  @override
  String get milestoneThankGod => 'الحمد لله!';

  @override
  String shareStreakText(Object count) {
    return '$count يوم صلاة متواصلة! رحلتي في الصلاة مع Abba #Abba #صلاة';
  }

  @override
  String get shareDaysLabel => 'يوم صلاة متواصلة';

  @override
  String get shareSubtitle => 'صلاة يومية مع الله';

  @override
  String get proActive => 'العضوية نشطة';

  @override
  String get planOncePerDay => 'مرة/يوم';

  @override
  String get planUnlimited => 'غير محدود';

  @override
  String get closeRecording => 'إغلاق التسجيل';

  @override
  String get qtRevealMessage => 'لنفتح كلمة اليوم';

  @override
  String get qtSelectPrompt => 'اختر موضوعًا وابدأ خلوتك اليوم';

  @override
  String get qtTopicLabel => 'الموضوع';

  @override
  String get prayerStartPrompt => 'ابدأ صلاتك';

  @override
  String get startPrayerButton => 'ابدأ الصلاة';

  @override
  String get switchToTextMode => 'الكتابة بدلاً من ذلك';

  @override
  String get switchToVoiceMode => 'تحويل للصوت';

  @override
  String get prayerDashboardTitle => 'حديقة الصلاة';

  @override
  String get qtDashboardTitle => 'حديقة الخلوة';

  @override
  String get prayerSummaryTitle => 'ملخص الصلاة';

  @override
  String get gratitudeLabel => 'شكر';

  @override
  String get petitionLabel => 'طلب';

  @override
  String get intercessionLabel => 'شفاعة';

  @override
  String get historicalStoryTitle => 'قصة من التاريخ';

  @override
  String get todayLesson => 'درس اليوم';

  @override
  String get meditationAnalysisTitle => 'تحليل التأمل';

  @override
  String get keyThemeLabel => 'الموضوع الرئيسي';

  @override
  String get applicationTitle => 'تطبيق اليوم';

  @override
  String get applicationWhat => 'ماذا';

  @override
  String get applicationWhen => 'متى';

  @override
  String get applicationContext => 'أين';

  @override
  String get relatedKnowledgeTitle => 'معرفة ذات صلة';

  @override
  String get originalWordLabel => 'الكلمة الأصلية';

  @override
  String get historicalContextLabel => 'السياق التاريخي';

  @override
  String get crossReferencesLabel => 'مراجع متقاطعة';

  @override
  String get growthStoryTitle => 'قصة نمو';

  @override
  String get prayerGuideTitle => 'كيف تصلي مع Abba';

  @override
  String get prayerGuide1 => 'صلِّ بصوت عالٍ وواضح';

  @override
  String get prayerGuide2 => 'Abba يستمع لصلاتك ويجد آيات تلمس قلبك';

  @override
  String get prayerGuide3 => 'يمكنك أيضًا كتابة صلاتك';

  @override
  String get qtGuideTitle => 'كيف تقوم بالخلوة مع Abba';

  @override
  String get qtGuide1 => 'اقرأ النص وتأمل بهدوء';

  @override
  String get qtGuide2 => 'شارك ما اكتشفته — تحدث أو اكتب تأملك';

  @override
  String get qtGuide3 => 'Abba سيساعدك في تطبيق الكلمة في حياتك اليومية';

  @override
  String get scriptureReasonLabel => 'لماذا هذه الآية';

  @override
  String get scripturePostureLabel => 'بأي موقف أقرأها؟';

  @override
  String get scriptureOriginalWordsTitle => 'المعنى الأعمق في اللغة الأصلية';

  @override
  String get originalWordMeaningLabel => 'المعنى';

  @override
  String get originalWordNuanceLabel => 'الفرق عن الترجمة';

  @override
  String originalWordsCountLabel(int count) {
    return '$count كلمات';
  }

  @override
  String get seeMore => 'عرض المزيد';

  @override
  String seeAllComments(Object count) {
    return 'عرض جميع التعليقات ($count)';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name و$count آخرون أعجبهم هذا';
  }

  @override
  String get commentsTitle => 'التعليقات';

  @override
  String get myPageTitle => 'حديقة صلاتي';

  @override
  String get myPrayers => 'صلواتي';

  @override
  String get myTestimonies => 'شهاداتي';

  @override
  String get savedPosts => 'المحفوظات';

  @override
  String get totalPrayersCount => 'الصلوات';

  @override
  String get streakCount => 'السلسلة';

  @override
  String get testimoniesCount => 'الشهادات';

  @override
  String get linkAccountTitle => 'ربط الحساب';

  @override
  String get linkAccountDescription =>
      'اربط حسابك للحفاظ على سجلات الصلاة عند تغيير الجهاز';

  @override
  String get linkWithApple => 'الربط مع Apple';

  @override
  String get linkWithGoogle => 'الربط مع Google';

  @override
  String get linkAccountSuccess => 'تم ربط الحساب بنجاح!';

  @override
  String get anonymousUser => 'محارب الصلاة';

  @override
  String showReplies(Object count) {
    return 'عرض $count ردود';
  }

  @override
  String get hideReplies => 'إخفاء الردود';

  @override
  String replyingTo(Object name) {
    return 'الرد على $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'عرض جميع التعليقات ($count)';
  }

  @override
  String get membershipTitle => 'العضوية';

  @override
  String get membershipSubtitle => 'عمّق حياتك في الصلاة';

  @override
  String get monthlyPlan => 'شهري';

  @override
  String get yearlyPlan => 'سنوي';

  @override
  String get yearlySavings => '\$4.17/شهر (خصم 40%)';

  @override
  String get startMembership => 'ابدأ الآن';

  @override
  String get membershipActive => 'العضوية نشطة';

  @override
  String get leaveRecordingTitle => 'مغادرة التسجيل؟';

  @override
  String get leaveRecordingMessage => 'سيتم فقدان تسجيلك. هل أنت متأكد؟';

  @override
  String get leaveButton => 'مغادرة';

  @override
  String get stayButton => 'البقاء';

  @override
  String likedByCount(Object count) {
    return '$count أشخاص تعاطفوا';
  }

  @override
  String get actionLike => 'إعجاب';

  @override
  String get actionComment => 'تعليق';

  @override
  String get actionSave => 'حفظ';

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
  String get qtLoadingHint1 => '💛 محبة — فكّر في شخص تحبه لمدة ١٠ ثوانٍ';

  @override
  String get qtLoadingHint2 => '🌿 نعمة — تذكّر نعمة صغيرة نلتها اليوم';

  @override
  String get qtLoadingHint3 => '🌅 رجاء — تخيّل رجاءً صغيرًا للغد';

  @override
  String get qtLoadingHint4 => '🕊️ سلام — خذ ثلاثة أنفاس عميقة ببطء';

  @override
  String get qtLoadingHint5 => '🌳 إيمان — تذكّر حقيقة لا تتغير';

  @override
  String get qtLoadingHint6 => '🌸 شكر — اذكر شيئًا تشكر عليه الآن';

  @override
  String get qtLoadingHint7 => '🌊 غفران — تذكّر شخصًا تودّ أن تسامحه';

  @override
  String get qtLoadingHint8 => '📖 حكمة — احفظ درسًا من هذا اليوم';

  @override
  String get qtLoadingHint9 => '⏳ صبر — فكّر فيما تنتظره بهدوء';

  @override
  String get qtLoadingHint10 => '✨ فرح — تذكّر لحظة ابتسمت فيها اليوم';

  @override
  String get qtLoadingTitle => 'جاري إعداد كلمة اليوم...';

  @override
  String get coachingTitle => 'إرشاد الصلاة';

  @override
  String get coachingLoadingText => 'نتأمل في صلاتك...';

  @override
  String get coachingErrorText => 'خطأ مؤقت — يرجى المحاولة مرة أخرى';

  @override
  String get coachingRetryButton => 'إعادة المحاولة';

  @override
  String get coachingScoreSpecificity => 'التحديد';

  @override
  String get coachingScoreGodCentered => 'التركيز على الله';

  @override
  String get coachingScoreActs => 'توازن ACTS';

  @override
  String get coachingScoreAuthenticity => 'الأصالة';

  @override
  String get coachingStrengthsTitle => 'ما قمت به بشكل جيد ✨';

  @override
  String get coachingImprovementsTitle => 'للتعمق أكثر 💡';

  @override
  String get coachingProCta => 'افتح إرشاد الصلاة مع Pro';

  @override
  String get coachingLevelBeginner => '🌱 مبتدئ';

  @override
  String get coachingLevelGrowing => '🌿 ينمو';

  @override
  String get coachingLevelExpert => '🌳 خبير';

  @override
  String get aiPrayerCitationsTitle => 'المراجع · الاقتباسات';

  @override
  String get citationTypeQuote => 'اقتباس';

  @override
  String get citationTypeScience => 'بحث';

  @override
  String get citationTypeExample => 'مثال';

  @override
  String get aiPrayerReadingTime => 'قراءة لمدة دقيقتين';

  @override
  String get scriptureKeyWordHintTitle => 'الكلمة المفتاحية لليوم';

  @override
  String get bibleLookupReferenceHint =>
      'ابحث عن هذا المقطع في كتابك المقدس وتأمل فيه.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'ترجمات الكتاب المقدس';

  @override
  String get settingsBibleTranslationsIntro =>
      'تأتي الآيات الكتابية في هذا التطبيق من ترجمات في الملكية العامة. التعليقات والصلوات والقصص التي يولدها الذكاء الاصطناعي هي من إبداع أبا.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';
}
