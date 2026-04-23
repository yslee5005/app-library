// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '阿爸';

  @override
  String get welcomeTitle => '当你祷告时，\n上帝会回应。';

  @override
  String get welcomeSubtitle => '你每日祷告与灵修的AI伴侣';

  @override
  String get getStarted => '开始';

  @override
  String get loginTitle => '欢迎来到阿爸';

  @override
  String get loginSubtitle => '登录开始你的祷告之旅';

  @override
  String get signInWithApple => '通过Apple继续';

  @override
  String get signInWithGoogle => '通过Google继续';

  @override
  String get signInWithEmail => '通过邮箱继续';

  @override
  String greetingMorning(Object name) {
    return '早上好，$name';
  }

  @override
  String greetingAfternoon(Object name) {
    return '下午好，$name';
  }

  @override
  String greetingEvening(Object name) {
    return '晚上好，$name';
  }

  @override
  String get prayButton => '祷告';

  @override
  String get qtButton => '灵修';

  @override
  String streakDays(Object count) {
    return '连续$count天祷告';
  }

  @override
  String get dailyVerse => '今日经文';

  @override
  String get tabHome => '首页';

  @override
  String get tabCalendar => '日历';

  @override
  String get tabCommunity => '社区';

  @override
  String get tabSettings => '设置';

  @override
  String get recordingTitle => '祷告中...';

  @override
  String get recordingPause => '暂停';

  @override
  String get recordingResume => '继续';

  @override
  String get finishPrayer => '结束祷告';

  @override
  String get finishPrayerConfirm => '您确定要结束祷告吗？';

  @override
  String get switchToText => '文字输入';

  @override
  String get textInputHint => '在这里输入你的祷告...';

  @override
  String get aiLoadingText => '正在默想你的祷告...';

  @override
  String get aiLoadingVerse => '你们要休息，要知道我是神。\n— 诗篇 46:10';

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
  String get dashboardTitle => '祷告花园';

  @override
  String get shareButton => '分享';

  @override
  String get backToHome => '回到首页';

  @override
  String get scriptureTitle => '今日经文';

  @override
  String get bibleStoryTitle => '圣经故事';

  @override
  String get testimonyTitle => '见证 · 我的祷告';

  @override
  String get testimonyHelperText => '回顾你所祈祷的 · 也可分享到社区';

  @override
  String get myPrayerAudioLabel => '我的祷告录音';

  @override
  String get testimonyEdit => '编辑';

  @override
  String get guidanceTitle => 'AI指引';

  @override
  String get aiPrayerTitle => '为你的祷告';

  @override
  String get originalLangTitle => '原文深意';

  @override
  String get proUnlock => '用Pro解锁';

  @override
  String get qtPageTitle => '晨间花园';

  @override
  String get qtMeditateButton => '开始默想';

  @override
  String get qtCompleted => '已完成';

  @override
  String get communityTitle => '祷告花园';

  @override
  String get filterAll => '全部';

  @override
  String get filterTestimony => '见证';

  @override
  String get filterPrayerRequest => '代祷请求';

  @override
  String get likeButton => '喜欢';

  @override
  String get commentButton => '评论';

  @override
  String get saveButton => '收藏';

  @override
  String get replyButton => '回复';

  @override
  String get writePostTitle => '分享';

  @override
  String get cancelButton => '取消';

  @override
  String get sharePostButton => '发布';

  @override
  String get anonymousToggle => '匿名';

  @override
  String get realNameToggle => '实名';

  @override
  String get categoryTestimony => '见证';

  @override
  String get categoryPrayerRequest => '代祷请求';

  @override
  String get writePostHint => '分享你的见证或代祷请求...';

  @override
  String get importFromPrayer => '从祷告导入';

  @override
  String get calendarTitle => '祷告日历';

  @override
  String get currentStreak => '当前连续';

  @override
  String get bestStreak => '最佳记录';

  @override
  String get days => '天';

  @override
  String calendarRecordCount(Object count) {
    return '$count条记录';
  }

  @override
  String get todayVerse => '今日金句';

  @override
  String get settingsTitle => '设置';

  @override
  String get profileSection => '个人资料';

  @override
  String get totalPrayers => '祷告总数';

  @override
  String get consecutiveDays => '连续天数';

  @override
  String get proSection => '会员';

  @override
  String get freePlan => '免费';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '¥50 / 月';

  @override
  String get yearlyPrice => '¥388 / 年';

  @override
  String get yearlySave => '省40%';

  @override
  String get launchPromo => '3个月¥25/月!';

  @override
  String get startPro => '开通Pro';

  @override
  String get comingSoon => '即将推出';

  @override
  String get notificationSetting => '通知';

  @override
  String get languageSetting => '语言';

  @override
  String get darkModeSetting => '深色模式';

  @override
  String get helpCenter => '帮助中心';

  @override
  String get termsOfService => '服务条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get logout => '退出登录';

  @override
  String appVersion(Object version) {
    return '版本 $version';
  }

  @override
  String get anonymous => '匿名';

  @override
  String timeAgo(Object time) {
    return '$time前';
  }

  @override
  String get emailLabel => '邮箱';

  @override
  String get passwordLabel => '密码';

  @override
  String get signIn => '登录';

  @override
  String get cancel => '取消';

  @override
  String get noPrayersRecorded => '暂无祷告记录';

  @override
  String get deletePost => '删除';

  @override
  String get reportPost => '举报';

  @override
  String get reportSubmitted => '举报已提交。谢谢。';

  @override
  String get reportReasonHint => '请填写举报原因。将通过电子邮件发送。';

  @override
  String get reportReasonPlaceholder => '请输入举报原因...';

  @override
  String get reportSubmitButton => '举报';

  @override
  String get deleteConfirmTitle => '删除帖子';

  @override
  String get deleteConfirmMessage => '确定要删除这条帖子吗？';

  @override
  String get errorNetwork => '请检查网络连接后重试。';

  @override
  String get errorAiFallback => '无法连接AI。为你准备了一段经文。';

  @override
  String get errorSttFailed => '语音识别不可用，请改用文字输入。';

  @override
  String get errorPayment => '支付出现问题，请在设置中重试。';

  @override
  String get errorGeneric => '出了点问题，请稍后重试。';

  @override
  String get offlineNotice => '当前离线，部分功能可能受限。';

  @override
  String get retryButton => '重试';

  @override
  String get groupSection => '我的小组';

  @override
  String get createGroup => '创建祷告小组';

  @override
  String get inviteFriends => '邀请朋友';

  @override
  String get groupInviteMessage => '一起祷告吧！加入我在Abba的祷告小组。';

  @override
  String get noGroups => '加入或创建小组，一起祷告。';

  @override
  String get promoTitle => '上线特惠';

  @override
  String get promoBanner => '3个月¥25/月!';

  @override
  String promoEndsOn(Object date) {
    return '优惠截止$date';
  }

  @override
  String get proLimitTitle => '今天的祷告已完成';

  @override
  String get proLimitBody => '明天见！\n升级Pro无限祷告';

  @override
  String get laterButton => '以后再说';

  @override
  String get proPromptTitle => 'Pro功能';

  @override
  String get proPromptBody => '此功能需要Pro版本。\n要查看我们的方案吗？';

  @override
  String get viewProducts => '查看方案';

  @override
  String get maybeLater => '下次再说';

  @override
  String get proHeadline => '每天与神更亲近';

  @override
  String get proBenefit1 => '无限祷告 & 灵修';

  @override
  String get proBenefit2 => 'AI定制祷告与指导';

  @override
  String get proBenefit3 => '历史信仰故事';

  @override
  String get proBenefit5 => '原文圣经解读';

  @override
  String get bestValue => '最划算';

  @override
  String get perMonth => '月';

  @override
  String get cancelAnytime => '随时取消';

  @override
  String get restorePurchase => '恢复购买';

  @override
  String get yearlyPriceMonthly => '¥32/月';

  @override
  String get morningPrayerReminder => '早祷';

  @override
  String get eveningGratitudeReminder => '晚间感恩';

  @override
  String get streakReminder => '连续记录提醒';

  @override
  String get afternoonNudgeReminder => '下午祷告提醒';

  @override
  String get weeklySummaryReminder => '每周总结';

  @override
  String get unlimited => '无限';

  @override
  String get streakRecovery => '没关系，重新开始吧 🌱';

  @override
  String get prayerSaved => '祷告已保存';

  @override
  String get quietTimeLabel => '灵修';

  @override
  String get morningPrayerLabel => '早祷';

  @override
  String get gardenSeed => '信心的种子';

  @override
  String get gardenSprout => '成长的嫩芽';

  @override
  String get gardenBud => '花蕾';

  @override
  String get gardenBloom => '盛开的花';

  @override
  String get gardenTree => '参天大树';

  @override
  String get gardenForest => '祷告之林';

  @override
  String get milestoneShare => '分享';

  @override
  String get milestoneThankGod => '感谢上帝!';

  @override
  String shareStreakText(Object count) {
    return '连续$count天祷告！与Abba同行的祷告之旅 #Abba #祷告';
  }

  @override
  String get shareDaysLabel => '天连续祷告';

  @override
  String get shareSubtitle => '与上帝同行的每日祷告';

  @override
  String get proActive => '会员已激活';

  @override
  String get planOncePerDay => '每天1次';

  @override
  String get planUnlimited => '无限';

  @override
  String get closeRecording => '关闭录音';

  @override
  String get qtRevealMessage => '让我们打开今天的话语';

  @override
  String get qtSelectPrompt => '选择一个开始今天的灵修 🌿';

  @override
  String get qtTopicLabel => '主题';

  @override
  String get prayerStartPrompt => '开始祷告';

  @override
  String get startPrayerButton => '开始祷告';

  @override
  String get switchToTextMode => '切换到文字输入';

  @override
  String get switchToVoiceMode => '语音输入';

  @override
  String get prayerDashboardTitle => '祷告花园';

  @override
  String get qtDashboardTitle => '灵修花园';

  @override
  String get prayerSummaryTitle => '祷告摘要';

  @override
  String get gratitudeLabel => '感恩';

  @override
  String get petitionLabel => '祈求';

  @override
  String get intercessionLabel => '代祷';

  @override
  String get historicalStoryTitle => '历史故事';

  @override
  String get todayLesson => '今日教训';

  @override
  String get applicationTitle => '今日应用';

  @override
  String get applicationWhat => '做什么';

  @override
  String get applicationWhen => '何时';

  @override
  String get applicationContext => '何地';

  @override
  String get applicationMorningLabel => '早晨';

  @override
  String get applicationDayLabel => '白天';

  @override
  String get applicationEveningLabel => '晚上';

  @override
  String get relatedKnowledgeTitle => '相关知识';

  @override
  String get originalWordLabel => '原文';

  @override
  String get historicalContextLabel => '历史背景';

  @override
  String get crossReferencesLabel => '相关经文';

  @override
  String get growthStoryTitle => '成长故事';

  @override
  String get prayerGuideTitle => '请这样祷告';

  @override
  String get prayerGuide1 => '请出声祷告';

  @override
  String get prayerGuide2 => 'Abba会聆听您的祷告，找到触动心灵的经文';

  @override
  String get prayerGuide3 => '您也可以用文字输入祷告';

  @override
  String get qtGuideTitle => '请这样默想';

  @override
  String get qtGuide1 => '请阅读经文并安静默想';

  @override
  String get qtGuide2 => '请分享您的领悟——说出来或写下来';

  @override
  String get qtGuide3 => 'Abba会帮助您将话语应用到日常生活中';

  @override
  String get scriptureReasonLabel => '选择这段经文的原因';

  @override
  String get scripturePostureLabel => '以什么样的心读它?';

  @override
  String get scriptureOriginalWordsTitle => '通过原文遇见更深的含义';

  @override
  String get originalWordMeaningLabel => '含义';

  @override
  String get originalWordNuanceLabel => '与译文的细微差别';

  @override
  String originalWordsCountLabel(int count) {
    return '$count个词';
  }

  @override
  String get seeMore => '查看更多';

  @override
  String seeAllComments(Object count) {
    return '查看全部$count条评论';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name和其他$count人点赞了';
  }

  @override
  String get commentsTitle => '评论';

  @override
  String get myPageTitle => '我的祷告花园';

  @override
  String get myPrayers => '我的祷告';

  @override
  String get myTestimonies => '我的见证';

  @override
  String get savedPosts => '已收藏';

  @override
  String get totalPrayersCount => '祷告';

  @override
  String get streakCount => '连续';

  @override
  String get testimoniesCount => '见证';

  @override
  String get linkAccountTitle => '关联账号';

  @override
  String get linkAccountDescription => '关联账号后，更换设备时祷告记录将会保留';

  @override
  String get linkWithApple => '通过Apple关联';

  @override
  String get linkWithGoogle => '通过Google关联';

  @override
  String get linkAccountSuccess => '账号关联成功！';

  @override
  String get anonymousUser => '祷告勇士';

  @override
  String showReplies(Object count) {
    return '查看$count条回复';
  }

  @override
  String get hideReplies => '隐藏回复';

  @override
  String replyingTo(Object name) {
    return '正在回复$name';
  }

  @override
  String viewAllComments(Object count) {
    return '查看全部$count条评论';
  }

  @override
  String get membershipTitle => '会员';

  @override
  String get membershipSubtitle => '让祷告更加深入';

  @override
  String get monthlyPlan => '月度';

  @override
  String get yearlyPlan => '年度';

  @override
  String get yearlySavings => '月¥18 (40%折扣)';

  @override
  String get startMembership => '立即开通';

  @override
  String get membershipActive => '会员已激活';

  @override
  String get leaveRecordingTitle => '离开录音？';

  @override
  String get leaveRecordingMessage => '录音内容将会丢失。确定要离开吗？';

  @override
  String get leaveButton => '离开';

  @override
  String get stayButton => '留下';

  @override
  String likedByCount(Object count) {
    return '$count人表示共鸣';
  }

  @override
  String get actionLike => '共鸣';

  @override
  String get actionComment => '评论';

  @override
  String get actionSave => '收藏';

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
  String get billingIssueTitle => '检测到付款问题';

  @override
  String billingIssueBody(int days) {
    return '请在$days天内更新付款方式，否则 Pro 权益将中止。';
  }

  @override
  String get billingIssueAction => '更新付款方式';

  @override
  String accessUntil(String date) {
    return 'Access until: $date';
  }

  @override
  String subscriptionCancelledNotice(String date) {
    return 'Your subscription has been cancelled. You\'ll have access until $date.';
  }

  @override
  String get qtLoadingHint1 => '💛 爱 — 闭上眼睛,用10秒想一个你爱的人';

  @override
  String get qtLoadingHint2 => '🌿 恩典 — 回想今天领受的一点小恩典';

  @override
  String get qtLoadingHint3 => '🌅 盼望 — 在心中描绘明天的一点盼望';

  @override
  String get qtLoadingHint4 => '🕊️ 平安 — 慢慢深呼吸三次';

  @override
  String get qtLoadingHint5 => '🌳 信心 — 想起一个不变的真理';

  @override
  String get qtLoadingHint6 => '🌸 感恩 — 说出一件你现在感谢的事';

  @override
  String get qtLoadingHint7 => '🌊 饶恕 — 在心中想起一个要饶恕的人';

  @override
  String get qtLoadingHint8 => '📖 智慧 — 记住今天学到的一个教训';

  @override
  String get qtLoadingHint9 => '⏳ 忍耐 — 想想你静静等待的事情';

  @override
  String get qtLoadingHint10 => '✨ 喜乐 — 回想今天微笑的一刻';

  @override
  String get qtLoadingTitle => '正在准备今日的话语...';

  @override
  String get coachingTitle => '祷告辅导';

  @override
  String get coachingLoadingText => '正在回顾您的祷告...';

  @override
  String get coachingErrorText => '临时错误 — 请稍后重试';

  @override
  String get coachingRetryButton => '重试';

  @override
  String get coachingScoreSpecificity => '具体性';

  @override
  String get coachingScoreGodCentered => '以神为中心';

  @override
  String get coachingScoreActs => 'ACTS 平衡';

  @override
  String get coachingScoreAuthenticity => '真实性';

  @override
  String get coachingStrengthsTitle => '你做得好的地方 ✨';

  @override
  String get coachingImprovementsTitle => '更进一步 💡';

  @override
  String get coachingProCta => '使用 Pro 解锁祷告辅导';

  @override
  String get coachingLevelBeginner => '🌱 初学者';

  @override
  String get coachingLevelGrowing => '🌿 成长中';

  @override
  String get coachingLevelExpert => '🌳 专家';

  @override
  String get aiPrayerCitationsTitle => '参考 · 引用';

  @override
  String get citationTypeQuote => '名言';

  @override
  String get citationTypeScience => '研究';

  @override
  String get citationTypeExample => '例子';

  @override
  String get citationTypeHistory => '历史';

  @override
  String get aiPrayerReadingTime => '2分钟阅读';

  @override
  String get scriptureKeyWordHintTitle => '今日关键词';

  @override
  String get bibleLookupReferenceHint => '请在您的圣经中找到这段经文并默想。';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => '圣经译本';

  @override
  String get settingsBibleTranslationsIntro =>
      '本应用中的圣经经文均来自公共领域译本。AI 生成的注释、祷告和故事是 Abba 的原创作品。';

  @override
  String get meditationSummaryTitle => '今日默想';

  @override
  String get meditationTopicLabel => '主题';

  @override
  String get meditationSummaryLabel => '一句话';

  @override
  String get qtScriptureTitle => '今日经文';

  @override
  String get qtCoachingTitle => 'QT 辅导';

  @override
  String get qtCoachingLoadingText => '正在回顾您的默想...';

  @override
  String get qtCoachingErrorText => '临时错误 — 请稍后重试';

  @override
  String get qtCoachingRetryButton => '重试';

  @override
  String get qtCoachingScoreComprehension => '经文理解';

  @override
  String get qtCoachingScoreApplication => '个人应用';

  @override
  String get qtCoachingScoreDepth => '属灵深度';

  @override
  String get qtCoachingScoreAuthenticity => '真实性';

  @override
  String get qtCoachingStrengthsTitle => '你做得好的地方 ✨';

  @override
  String get qtCoachingImprovementsTitle => '更进一步 💡';

  @override
  String get qtCoachingProCta => '使用 Pro 解锁 QT 辅导';

  @override
  String get qtCoachingLevelBeginner => '🌱 初学者';

  @override
  String get qtCoachingLevelGrowing => '🌿 成长中';

  @override
  String get qtCoachingLevelExpert => '🌳 专家';

  @override
  String get notifyMorning1Title => '🙏 祷告时间到了';

  @override
  String notifyMorning1Body(String name) {
    return '$name,今天也与神交谈吧';
  }

  @override
  String get notifyMorning2Title => '🌅 新的一天开始了';

  @override
  String notifyMorning2Body(String name) {
    return '$name,以感恩开始新的一天';
  }

  @override
  String get notifyMorning3Title => '✨ 今日的恩典';

  @override
  String notifyMorning3Body(String name) {
    return '$name,领受神为你预备的恩典';
  }

  @override
  String get notifyMorning4Title => '🕊️ 平安的早晨';

  @override
  String notifyMorning4Body(String name) {
    return '$name,用祷告将平安充满你的心';
  }

  @override
  String get notifyMorning5Title => '📖 与神的话同在';

  @override
  String notifyMorning5Body(String name) {
    return '$name,今天聆听神的声音';
  }

  @override
  String get notifyMorning6Title => '🌿 安息的时刻';

  @override
  String notifyMorning6Body(String name) {
    return '$name,稍作停顿来祷告吧';
  }

  @override
  String get notifyMorning7Title => '💫 今天也一样';

  @override
  String notifyMorning7Body(String name) {
    return '$name,以祷告开始的一天与众不同';
  }

  @override
  String get notifyEvening1Title => '✨ 感恩今日';

  @override
  String get notifyEvening1Body => '回顾今日并献上感恩的祷告';

  @override
  String get notifyEvening2Title => '🌙 一天的尾声';

  @override
  String get notifyEvening2Body => '用祷告表达今日的感恩';

  @override
  String get notifyEvening3Title => '🙏 晚间祷告';

  @override
  String get notifyEvening3Body => '在一日的尾声,向神献上感恩';

  @override
  String get notifyEvening4Title => '🌟 数算今日的恩典';

  @override
  String get notifyEvening4Body => '若有感恩的事,就在祷告中分享';

  @override
  String get notifyStreak3Title => '🌱 连续3天!';

  @override
  String get notifyStreak3Body => '祷告的习惯已经开始';

  @override
  String get notifyStreak7Title => '🌿 连续一周!';

  @override
  String get notifyStreak7Body => '祷告正在成为习惯';

  @override
  String get notifyStreak14Title => '🌳 连续两周!';

  @override
  String get notifyStreak14Body => '惊人的成长!';

  @override
  String get notifyStreak21Title => '🌻 连续三周!';

  @override
  String get notifyStreak21Body => '祷告的花正在绽放';

  @override
  String get notifyStreak30Title => '🏆 连续一个月!';

  @override
  String get notifyStreak30Body => '你的祷告正在闪耀';

  @override
  String get notifyStreak50Title => '👑 连续50天!';

  @override
  String get notifyStreak50Body => '与神同行的日子越来越深';

  @override
  String get notifyStreak100Title => '🎉 连续100天!';

  @override
  String get notifyStreak100Body => '你成了祷告的勇士!';

  @override
  String get notifyStreak365Title => '✝️ 连续一整年!';

  @override
  String get notifyStreak365Body => '这是一段惊人的信仰旅程!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ 今天祷告了吗?';

  @override
  String get notifyAfternoonNudgeBody => '短短的祷告能改变一天';

  @override
  String get notifyChannelName => '祷告提醒';

  @override
  String get notifyChannelDescription => '晨祷、晚间感恩等祷告提醒';

  @override
  String get milestoneFirstPrayerTitle => '第一次祷告!';

  @override
  String get milestoneFirstPrayerDesc => '您的祷告之旅已经开始。神正在倾听。';

  @override
  String get milestoneSevenDayStreakTitle => '7天连续祷告!';

  @override
  String get milestoneSevenDayStreakDesc => '一周忠实的祷告。您的花园正在生长!';

  @override
  String get milestoneThirtyDayStreakTitle => '30天连续!';

  @override
  String get milestoneThirtyDayStreakDesc => '您的花园已经变成了花田!';

  @override
  String get milestoneHundredPrayersTitle => '第100次祷告!';

  @override
  String get milestoneHundredPrayersDesc => '与神进行了100次对话。您已深深扎根。';

  @override
  String get homeFirstPrayerPrompt => '开始您的第一次祷告';

  @override
  String get homeFirstQtPrompt => '开始您的第一次QT';

  @override
  String homeActivityPrompt(String activityName) {
    return '今天也$activityName吧';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return '连续$activityName第$count天';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return '已经$days天没有$activityName了';
  }

  @override
  String get homeActivityPrayer => '祷告';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => '加载中...';

  @override
  String get heatmapNoPrayer => '无祷告';

  @override
  String get heatmapLegendLess => '少';

  @override
  String get heatmapLegendMore => '多';

  @override
  String get qtPassagesLoadError => '无法加载今天的经文。请检查网络连接。';

  @override
  String get qtPassagesRetryButton => '重试';
}
