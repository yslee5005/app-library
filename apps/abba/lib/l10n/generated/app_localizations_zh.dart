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
  String get testimonyTitle => '我的见证';

  @override
  String get testimonyEdit => '编辑';

  @override
  String get guidanceTitle => 'AI指引';

  @override
  String get aiPrayerTitle => '为你的祷告';

  @override
  String get originalLangTitle => '原文深意';

  @override
  String get premiumUnlock => '用Premium解锁';

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
  String get settingsTitle => '设置';

  @override
  String get profileSection => '个人资料';

  @override
  String get totalPrayers => '祷告总数';

  @override
  String get consecutiveDays => '连续天数';

  @override
  String get premiumSection => '高级版';

  @override
  String get freePlan => '免费';

  @override
  String get premiumPlan => '高级版';

  @override
  String get monthlyPrice => '¥45/月';

  @override
  String get yearlyPrice => '¥328/年';

  @override
  String get yearlySave => '省40%';

  @override
  String get launchPromo => '3个月¥25/月!';

  @override
  String get startPremium => '开通Premium';

  @override
  String get comingSoon => '即将推出';

  @override
  String get notificationSetting => '通知';

  @override
  String get aiVoiceSetting => 'AI语音';

  @override
  String get voiceWarm => '温暖';

  @override
  String get voiceCalm => '平静';

  @override
  String get voiceStrong => '有力';

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
  String get premiumLimitTitle => '今天的祷告已完成';

  @override
  String get premiumLimitBody => '明天见！\n升级Premium无限祷告';

  @override
  String get laterButton => '以后再说';

  @override
  String get morningPrayerReminder => '早祷';

  @override
  String get eveningGratitudeReminder => '晚间感恩';

  @override
  String get streakReminder => '连续记录提醒';

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
  String get premiumActive => '已订阅Premium';

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
  String get meditationAnalysisTitle => '默想分析';

  @override
  String get keyThemeLabel => '核心主题';

  @override
  String get applicationTitle => '今日应用';

  @override
  String get applicationWhat => '做什么';

  @override
  String get applicationWhen => '何时';

  @override
  String get applicationContext => '何地';

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
}
