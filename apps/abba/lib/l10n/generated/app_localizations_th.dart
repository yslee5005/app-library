// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'เมื่อคุณอธิษฐาน\nพระเจ้าทรงตอบ';

  @override
  String get welcomeSubtitle => 'เพื่อนร่วมทางการอธิษฐานและเฝ้าเดี่ยวประจำวัน';

  @override
  String get getStarted => 'เริ่มต้น';

  @override
  String get loginTitle => 'ยินดีต้อนรับสู่ Abba';

  @override
  String get loginSubtitle =>
      'เข้าสู่ระบบเพื่อเริ่มต้นการเดินทางแห่งการอธิษฐาน';

  @override
  String get signInWithApple => 'ดำเนินการต่อกับ Apple';

  @override
  String get signInWithGoogle => 'ดำเนินการต่อกับ Google';

  @override
  String get signInWithEmail => 'ดำเนินการต่อกับอีเมล';

  @override
  String greetingMorning(Object name) {
    return 'สวัสดีตอนเช้า $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'สวัสดีตอนบ่าย $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'สวัสดีตอนเย็น $name';
  }

  @override
  String get prayButton => 'อธิษฐาน';

  @override
  String get qtButton => 'เฝ้าเดี่ยว';

  @override
  String streakDays(Object count) {
    return 'อธิษฐานต่อเนื่อง $count วัน';
  }

  @override
  String get dailyVerse => 'พระวจนะประจำวัน';

  @override
  String get tabHome => 'หน้าแรก';

  @override
  String get tabCalendar => 'ปฏิทิน';

  @override
  String get tabCommunity => 'ชุมชน';

  @override
  String get tabSettings => 'ตั้งค่า';

  @override
  String get recordingTitle => 'กำลังอธิษฐาน...';

  @override
  String get recordingPause => 'หยุดชั่วคราว';

  @override
  String get recordingResume => 'ดำเนินการต่อ';

  @override
  String get finishPrayer => 'จบการอธิษฐาน';

  @override
  String get finishPrayerConfirm => 'คุณต้องการจบการอธิษฐานหรือไม่?';

  @override
  String get switchToText => 'พิมพ์แทน';

  @override
  String get textInputHint => 'พิมพ์คำอธิษฐานของคุณที่นี่...';

  @override
  String get aiLoadingText => 'กำลังใคร่ครวญคำอธิษฐานของคุณ...';

  @override
  String get aiLoadingVerse =>
      'จงนิ่งสงบและรู้เถิดว่าเราคือพระเจ้า\n— สดุดี 46:10';

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
  String get dashboardTitle => 'สวนอธิษฐาน';

  @override
  String get shareButton => 'แชร์';

  @override
  String get backToHome => 'กลับหน้าแรก';

  @override
  String get scriptureTitle => 'พระวจนะวันนี้';

  @override
  String get bibleStoryTitle => 'เรื่องราวจากพระคัมภีร์';

  @override
  String get testimonyTitle => 'คำพยาน · คำอธิษฐานของฉัน';

  @override
  String get testimonyHelperText => 'ทบทวนคำอธิษฐานของคุณ · แบ่งปันในชุมชนได้';

  @override
  String get myPrayerAudioLabel => 'การบันทึกคำอธิษฐานของฉัน';

  @override
  String get testimonyEdit => 'แก้ไข';

  @override
  String get guidanceTitle => 'คำแนะนำ AI';

  @override
  String get aiPrayerTitle => 'คำอธิษฐานสำหรับคุณ';

  @override
  String get originalLangTitle => 'ภาษาต้นฉบับ';

  @override
  String get proUnlock => 'ปลดล็อกด้วย Pro';

  @override
  String get qtPageTitle => 'สวนยามเช้า';

  @override
  String get qtMeditateButton => 'เริ่มการเฝ้าเดี่ยว';

  @override
  String get qtCompleted => 'เสร็จสิ้น';

  @override
  String get communityTitle => 'สวนอธิษฐาน';

  @override
  String get filterAll => 'ทั้งหมด';

  @override
  String get filterTestimony => 'คำพยาน';

  @override
  String get filterPrayerRequest => 'ขอการอธิษฐาน';

  @override
  String get likeButton => 'ถูกใจ';

  @override
  String get commentButton => 'ความคิดเห็น';

  @override
  String get saveButton => 'บันทึก';

  @override
  String get replyButton => 'ตอบกลับ';

  @override
  String get writePostTitle => 'แชร์';

  @override
  String get cancelButton => 'ยกเลิก';

  @override
  String get sharePostButton => 'โพสต์';

  @override
  String get anonymousToggle => 'ไม่ระบุชื่อ';

  @override
  String get realNameToggle => 'ชื่อจริง';

  @override
  String get categoryTestimony => 'คำพยาน';

  @override
  String get categoryPrayerRequest => 'ขอการอธิษฐาน';

  @override
  String get writePostHint => 'แบ่งปันคำพยานหรือคำขออธิษฐาน...';

  @override
  String get importFromPrayer => 'นำเข้าจากคำอธิษฐาน';

  @override
  String get calendarTitle => 'ปฏิทินอธิษฐาน';

  @override
  String get currentStreak => 'ต่อเนื่องปัจจุบัน';

  @override
  String get bestStreak => 'สถิติสูงสุด';

  @override
  String get days => 'วัน';

  @override
  String calendarRecordCount(Object count) {
    return '$count รายการ';
  }

  @override
  String get todayVerse => 'พระวจนะวันนี้';

  @override
  String get settingsTitle => 'ตั้งค่า';

  @override
  String get profileSection => 'โปรไฟล์';

  @override
  String get totalPrayers => 'จำนวนอธิษฐานทั้งหมด';

  @override
  String get consecutiveDays => 'วันต่อเนื่อง';

  @override
  String get proSection => 'สมาชิก';

  @override
  String get freePlan => 'ฟรี';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '฿239 / เดือน';

  @override
  String get yearlyPrice => '฿1,790 / ปี';

  @override
  String get yearlySave => 'ประหยัด 40%';

  @override
  String get launchPromo => '3 เดือนแรก ฿159/เดือน!';

  @override
  String get startPro => 'เริ่มต้น Pro';

  @override
  String get comingSoon => 'เร็วๆ นี้';

  @override
  String get notificationSetting => 'การแจ้งเตือน';

  @override
  String get languageSetting => 'ภาษา';

  @override
  String get darkModeSetting => 'โหมดมืด';

  @override
  String get helpCenter => 'ศูนย์ช่วยเหลือ';

  @override
  String get termsOfService => 'ข้อกำหนดการใช้งาน';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String appVersion(Object version) {
    return 'เวอร์ชัน $version';
  }

  @override
  String get anonymous => 'ไม่ระบุชื่อ';

  @override
  String timeAgo(Object time) {
    return '$time ที่แล้ว';
  }

  @override
  String get emailLabel => 'อีเมล';

  @override
  String get passwordLabel => 'รหัสผ่าน';

  @override
  String get signIn => 'เข้าสู่ระบบ';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get noPrayersRecorded => 'ยังไม่มีบันทึกการอธิษฐาน';

  @override
  String get deletePost => 'ลบ';

  @override
  String get reportPost => 'รายงาน';

  @override
  String get reportSubmitted => 'รายงานถูกส่งแล้ว ขอบคุณ';

  @override
  String get reportReasonHint => 'โปรดอธิบายเหตุผลในการรายงาน จะถูกส่งทางอีเมล';

  @override
  String get reportReasonPlaceholder => 'ป้อนเหตุผลในการรายงาน...';

  @override
  String get reportSubmitButton => 'รายงาน';

  @override
  String get deleteConfirmTitle => 'ลบโพสต์';

  @override
  String get deleteConfirmMessage => 'คุณแน่ใจหรือไม่ว่าต้องการลบโพสต์นี้?';

  @override
  String get errorNetwork =>
      'กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตแล้วลองอีกครั้ง';

  @override
  String get errorAiFallback =>
      'ไม่สามารถเชื่อมต่อ AI ได้ นี่คือพระวจนะสำหรับคุณ';

  @override
  String get errorSttFailed => 'การรู้จำเสียงไม่พร้อมใช้งาน กรุณาพิมพ์แทน';

  @override
  String get errorPayment => 'เกิดปัญหาในการชำระเงิน กรุณาลองอีกครั้งในตั้งค่า';

  @override
  String get errorGeneric => 'เกิดข้อผิดพลาด กรุณาลองอีกครั้งภายหลัง';

  @override
  String get offlineNotice => 'คุณออฟไลน์อยู่ บางฟีเจอร์อาจถูกจำกัด';

  @override
  String get retryButton => 'ลองอีกครั้ง';

  @override
  String get groupSection => 'กลุ่มของฉัน';

  @override
  String get createGroup => 'สร้างกลุ่มอธิษฐาน';

  @override
  String get inviteFriends => 'เชิญเพื่อน';

  @override
  String get groupInviteMessage =>
      'มาอธิษฐานด้วยกัน! เข้าร่วมกลุ่มอธิษฐานของฉันบน Abba';

  @override
  String get noGroups => 'เข้าร่วมหรือสร้างกลุ่มเพื่ออธิษฐานด้วยกัน';

  @override
  String get promoTitle => 'โปรโมชันพิเศษ';

  @override
  String get promoBanner => '3 เดือนแรก ฿159/เดือน!';

  @override
  String promoEndsOn(Object date) {
    return 'ข้อเสนอสิ้นสุด $date';
  }

  @override
  String get proLimitTitle => 'การอธิษฐานวันนี้เสร็จสิ้นแล้ว';

  @override
  String get proLimitBody => 'พบกันพรุ่งนี้!\nอธิษฐานไม่จำกัดด้วย Pro';

  @override
  String get laterButton => 'ไว้ทีหลัง';

  @override
  String get proPromptTitle => 'ฟีเจอร์ Pro';

  @override
  String get proPromptBody =>
      'ฟีเจอร์นี้ใช้ได้กับ Pro\nต้องการดูแพ็กเกจหรือไม่?';

  @override
  String get viewProducts => 'ดูแพ็กเกจ';

  @override
  String get maybeLater => 'ไว้ทีหลัง';

  @override
  String get proHeadline => 'ใกล้ชิดพระเจ้ามากขึ้นทุกวัน';

  @override
  String get proBenefit1 => 'อธิษฐานและเฝ้าเดี่ยวไม่จำกัด';

  @override
  String get proBenefit2 => 'คำอธิษฐานและคำแนะนำด้วย AI';

  @override
  String get proBenefit3 => 'เรื่องราวแห่งศรัทธาจากประวัติศาสตร์';

  @override
  String get proBenefit5 => 'ศึกษาพระคัมภีร์ภาษาต้นฉบับ';

  @override
  String get bestValue => 'คุ้มค่าที่สุด';

  @override
  String get perMonth => 'เดือน';

  @override
  String get cancelAnytime => 'ยกเลิกได้ทุกเมื่อ';

  @override
  String get restorePurchase => 'กู้คืนการซื้อ';

  @override
  String get yearlyPriceMonthly => '฿149/เดือน';

  @override
  String get morningPrayerReminder => 'อธิษฐานเช้า';

  @override
  String get eveningGratitudeReminder => 'ขอบพระคุณยามเย็น';

  @override
  String get streakReminder => 'เตือนสถิติต่อเนื่อง';

  @override
  String get afternoonNudgeReminder => 'เตือนอธิษฐานบ่าย';

  @override
  String get weeklySummaryReminder => 'สรุปประจำสัปดาห์';

  @override
  String get unlimited => 'ไม่จำกัด';

  @override
  String get streakRecovery => 'ไม่เป็นไร คุณเริ่มใหม่ได้ 🌱';

  @override
  String get prayerSaved => 'บันทึกคำอธิษฐานแล้ว';

  @override
  String get quietTimeLabel => 'เฝ้าเดี่ยว';

  @override
  String get morningPrayerLabel => 'อธิษฐานเช้า';

  @override
  String get gardenSeed => 'เมล็ดพันธุ์แห่งศรัทธา';

  @override
  String get gardenSprout => 'ต้นกล้ากำลังเติบโต';

  @override
  String get gardenBud => 'ดอกตูม';

  @override
  String get gardenBloom => 'บานสะพรั่ง';

  @override
  String get gardenTree => 'ต้นไม้แข็งแรง';

  @override
  String get gardenForest => 'ป่าแห่งการอธิษฐาน';

  @override
  String get milestoneShare => 'แชร์';

  @override
  String get milestoneThankGod => 'ขอบพระคุณพระเจ้า!';

  @override
  String shareStreakText(Object count) {
    return 'อธิษฐานต่อเนื่อง $count วัน! เส้นทางการอธิษฐานกับ Abba #Abba #อธิษฐาน';
  }

  @override
  String get shareDaysLabel => 'วันอธิษฐานต่อเนื่อง';

  @override
  String get shareSubtitle => 'อธิษฐานกับพระเจ้าทุกวัน';

  @override
  String get proActive => 'สมาชิกใช้งานอยู่';

  @override
  String get planOncePerDay => '1 ครั้ง/วัน';

  @override
  String get planUnlimited => 'ไม่จำกัด';

  @override
  String get closeRecording => 'ปิดการบันทึก';

  @override
  String get qtRevealMessage => 'มาเปิดพระวจนะวันนี้กัน';

  @override
  String get qtSelectPrompt => 'เลือกหนึ่งหัวข้อแล้วเริ่มเฝ้าเดี่ยววันนี้';

  @override
  String get qtTopicLabel => 'หัวข้อ';

  @override
  String get prayerStartPrompt => 'เริ่มอธิษฐาน';

  @override
  String get startPrayerButton => 'เริ่มอธิษฐาน';

  @override
  String get switchToTextMode => 'พิมพ์แทน';

  @override
  String get switchToVoiceMode => 'พูดแทน';

  @override
  String get prayerDashboardTitle => 'สวนอธิษฐาน';

  @override
  String get qtDashboardTitle => 'สวนเฝ้าเดี่ยว';

  @override
  String get prayerSummaryTitle => 'สรุปการอธิษฐาน';

  @override
  String get gratitudeLabel => 'ขอบพระคุณ';

  @override
  String get petitionLabel => 'ทูลขอ';

  @override
  String get intercessionLabel => 'อธิษฐานเผื่อ';

  @override
  String get historicalStoryTitle => 'เรื่องราวจากประวัติศาสตร์';

  @override
  String get todayLesson => 'บทเรียนวันนี้';

  @override
  String get applicationTitle => 'การประยุกต์ใช้วันนี้';

  @override
  String get applicationWhat => 'อะไร';

  @override
  String get applicationWhen => 'เมื่อไหร่';

  @override
  String get applicationContext => 'ที่ไหน';

  @override
  String get applicationMorningLabel => 'เช้า';

  @override
  String get applicationDayLabel => 'กลางวัน';

  @override
  String get applicationEveningLabel => 'เย็น';

  @override
  String get relatedKnowledgeTitle => 'ความรู้ที่เกี่ยวข้อง';

  @override
  String get originalWordLabel => 'คำภาษาต้นฉบับ';

  @override
  String get historicalContextLabel => 'บริบทประวัติศาสตร์';

  @override
  String get crossReferencesLabel => 'ข้อพระคัมภีร์อ้างอิง';

  @override
  String get growthStoryTitle => 'เรื่องราวการเติบโต';

  @override
  String get prayerGuideTitle => 'วิธีอธิษฐานกับ Abba';

  @override
  String get prayerGuide1 => 'อธิษฐานออกเสียงดังชัดเจน';

  @override
  String get prayerGuide2 => 'Abba จะฟังคำอธิษฐานของคุณและค้นหาพระวจนะที่ตรงใจ';

  @override
  String get prayerGuide3 => 'คุณสามารถพิมพ์คำอธิษฐานได้เช่นกัน';

  @override
  String get qtGuideTitle => 'วิธีเฝ้าเดี่ยวกับ Abba';

  @override
  String get qtGuide1 => 'อ่านพระวจนะและใคร่ครวญอย่างสงบ';

  @override
  String get qtGuide2 => 'แบ่งปันสิ่งที่คุณค้นพบ — พูดหรือพิมพ์ข้อคิด';

  @override
  String get qtGuide3 => 'Abba จะช่วยคุณนำพระวจนะไปใช้ในชีวิตประจำวัน';

  @override
  String get scriptureReasonLabel => 'ทำไมพระวจนะนี้';

  @override
  String get scripturePostureLabel => 'ควรอ่านด้วยใจแบบไหน?';

  @override
  String get scriptureOriginalWordsTitle => 'ความหมายที่ลึกกว่าในภาษาต้นฉบับ';

  @override
  String get originalWordMeaningLabel => 'ความหมาย';

  @override
  String get originalWordNuanceLabel => 'ความแตกต่างจากการแปล';

  @override
  String originalWordsCountLabel(int count) {
    return '$count คำ';
  }

  @override
  String get seeMore => 'ดูเพิ่มเติม';

  @override
  String seeAllComments(Object count) {
    return 'ดูความคิดเห็นทั้ง $count รายการ';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name และอีก $count คนถูกใจ';
  }

  @override
  String get commentsTitle => 'ความคิดเห็น';

  @override
  String get myPageTitle => 'สวนอธิษฐานของฉัน';

  @override
  String get myPrayers => 'คำอธิษฐานของฉัน';

  @override
  String get myTestimonies => 'คำพยานของฉัน';

  @override
  String get savedPosts => 'ที่บันทึกไว้';

  @override
  String get totalPrayersCount => 'อธิษฐาน';

  @override
  String get streakCount => 'ต่อเนื่อง';

  @override
  String get testimoniesCount => 'คำพยาน';

  @override
  String get linkAccountTitle => 'เชื่อมต่อบัญชี';

  @override
  String get linkAccountDescription =>
      'เชื่อมต่อบัญชีเพื่อเก็บบันทึกการอธิษฐานเมื่อเปลี่ยนเครื่อง';

  @override
  String get linkWithApple => 'เชื่อมต่อกับ Apple';

  @override
  String get linkWithGoogle => 'เชื่อมต่อกับ Google';

  @override
  String get linkAccountSuccess => 'เชื่อมต่อบัญชีสำเร็จ!';

  @override
  String get anonymousUser => 'นักอธิษฐาน';

  @override
  String showReplies(Object count) {
    return 'ดู $count การตอบกลับ';
  }

  @override
  String get hideReplies => 'ซ่อนการตอบกลับ';

  @override
  String replyingTo(Object name) {
    return 'กำลังตอบกลับ $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'ดูความคิดเห็นทั้ง $count รายการ';
  }

  @override
  String get membershipTitle => 'สมาชิก';

  @override
  String get membershipSubtitle => 'ลึกซึ้งกับการอธิษฐาน';

  @override
  String get monthlyPlan => 'รายเดือน';

  @override
  String get yearlyPlan => 'รายปี';

  @override
  String get yearlySavings => '฿90/เดือน (ลด 40%)';

  @override
  String get startMembership => 'เริ่มต้น';

  @override
  String get membershipActive => 'สมาชิกใช้งานอยู่';

  @override
  String get leaveRecordingTitle => 'ออกจากการบันทึก?';

  @override
  String get leaveRecordingMessage => 'การบันทึกของคุณจะหายไป คุณแน่ใจหรือไม่?';

  @override
  String get leaveButton => 'ออก';

  @override
  String get stayButton => 'อยู่ต่อ';

  @override
  String likedByCount(Object count) {
    return '$count คนเห็นด้วย';
  }

  @override
  String get actionLike => 'ชอบ';

  @override
  String get actionComment => 'แสดงความคิดเห็น';

  @override
  String get actionSave => 'บันทึก';

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
  String get billingIssueTitle => 'ตรวจพบปัญหาการชำระเงิน';

  @override
  String billingIssueBody(int days) {
    return 'สิทธิประโยชน์ Pro จะสิ้นสุดใน $days วันหากไม่อัปเดตการชำระเงิน';
  }

  @override
  String get billingIssueAction => 'อัปเดตการชำระเงิน';

  @override
  String accessUntil(String date) {
    return 'Access until: $date';
  }

  @override
  String subscriptionCancelledNotice(String date) {
    return 'Your subscription has been cancelled. You\'ll have access until $date.';
  }

  @override
  String get qtLoadingHint1 => '💛 ความรัก — นึกถึงคนที่คุณรักสัก 10 วินาที';

  @override
  String get qtLoadingHint2 =>
      '🌿 พระคุณ — ระลึกถึงพระคุณเล็กๆ ที่ได้รับวันนี้';

  @override
  String get qtLoadingHint3 =>
      '🌅 ความหวัง — วาดภาพความหวังเล็กๆ สำหรับพรุ่งนี้';

  @override
  String get qtLoadingHint4 => '🕊️ สันติ — หายใจลึกๆ ช้าๆ สามครั้ง';

  @override
  String get qtLoadingHint5 =>
      '🌳 ความเชื่อ — ระลึกถึงความจริงที่ไม่เปลี่ยนแปลง';

  @override
  String get qtLoadingHint6 => '🌸 ความขอบคุณ — บอกสิ่งที่คุณขอบคุณในตอนนี้';

  @override
  String get qtLoadingHint7 => '🌊 การให้อภัย — นึกถึงคนที่อยากให้อภัย';

  @override
  String get qtLoadingHint8 => '📖 ปัญญา — เก็บบทเรียนหนึ่งของวันนี้ไว้ในใจ';

  @override
  String get qtLoadingHint9 =>
      '⏳ ความอดทน — นึกถึงสิ่งที่คุณกำลังรอคอยอย่างสงบ';

  @override
  String get qtLoadingHint10 => '✨ ความยินดี — จำช่วงเวลาที่ยิ้มในวันนี้';

  @override
  String get qtLoadingTitle => 'กำลังเตรียมพระวจนะของวันนี้...';

  @override
  String get coachingTitle => 'การโค้ชการอธิษฐาน';

  @override
  String get coachingLoadingText => 'กำลังไตร่ตรองคำอธิษฐานของคุณ...';

  @override
  String get coachingErrorText => 'ข้อผิดพลาดชั่วคราว — โปรดลองอีกครั้ง';

  @override
  String get coachingRetryButton => 'ลองอีกครั้ง';

  @override
  String get coachingScoreSpecificity => 'ความเฉพาะเจาะจง';

  @override
  String get coachingScoreGodCentered => 'ศูนย์กลางที่พระเจ้า';

  @override
  String get coachingScoreActs => 'สมดุล ACTS';

  @override
  String get coachingScoreAuthenticity => 'ความจริงใจ';

  @override
  String get coachingStrengthsTitle => 'สิ่งที่คุณทำได้ดี ✨';

  @override
  String get coachingImprovementsTitle => 'เพื่อก้าวลึกขึ้น 💡';

  @override
  String get coachingProCta => 'ปลดล็อกการโค้ชการอธิษฐานด้วย Pro';

  @override
  String get coachingLevelBeginner => '🌱 ผู้เริ่มต้น';

  @override
  String get coachingLevelGrowing => '🌿 กำลังเติบโต';

  @override
  String get coachingLevelExpert => '🌳 ผู้เชี่ยวชาญ';

  @override
  String get aiPrayerCitationsTitle => 'อ้างอิง · ข้ออ้าง';

  @override
  String get citationTypeQuote => 'ข้ออ้าง';

  @override
  String get citationTypeScience => 'งานวิจัย';

  @override
  String get citationTypeExample => 'ตัวอย่าง';

  @override
  String get citationTypeHistory => 'ประวัติศาสตร์';

  @override
  String get aiPrayerReadingTime => 'อ่าน 2 นาที';

  @override
  String get scriptureKeyWordHintTitle => 'คำสำคัญวันนี้';

  @override
  String get bibleLookupReferenceHint =>
      'หาข้อนี้ในพระคัมภีร์ของคุณแล้วใคร่ครวญ';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'ฉบับแปลพระคัมภีร์';

  @override
  String get settingsBibleTranslationsIntro =>
      'ข้อพระคัมภีร์ในแอปนี้มาจากฉบับแปลที่อยู่ในสาธารณสมบัติ คำอธิบาย คำอธิษฐาน และเรื่องราวที่สร้างโดย AI เป็นผลงานสร้างสรรค์ของ Abba';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'การโค้ช QT';

  @override
  String get qtCoachingLoadingText => 'กำลังไตร่ตรองการใคร่ครวญของคุณ...';

  @override
  String get qtCoachingErrorText => 'ข้อผิดพลาดชั่วคราว — โปรดลองอีกครั้ง';

  @override
  String get qtCoachingRetryButton => 'ลองอีกครั้ง';

  @override
  String get qtCoachingScoreComprehension => 'ความเข้าใจพระคัมภีร์';

  @override
  String get qtCoachingScoreApplication => 'การประยุกต์ส่วนตัว';

  @override
  String get qtCoachingScoreDepth => 'ความลึกทางจิตวิญญาณ';

  @override
  String get qtCoachingScoreAuthenticity => 'ความจริงใจ';

  @override
  String get qtCoachingStrengthsTitle => 'สิ่งที่คุณทำได้ดี ✨';

  @override
  String get qtCoachingImprovementsTitle => 'เพื่อก้าวลึกขึ้น 💡';

  @override
  String get qtCoachingProCta => 'ปลดล็อกการโค้ช QT ด้วย Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 ผู้เริ่มต้น';

  @override
  String get qtCoachingLevelGrowing => '🌿 กำลังเติบโต';

  @override
  String get qtCoachingLevelExpert => '🌳 ผู้เชี่ยวชาญ';

  @override
  String get notifyMorning1Title => '🙏 ถึงเวลาอธิษฐานแล้ว';

  @override
  String notifyMorning1Body(String name) {
    return '$name มาพูดคุยกับพระเจ้าในวันนี้';
  }

  @override
  String get notifyMorning2Title => '🌅 เช้าวันใหม่มาถึงแล้ว';

  @override
  String notifyMorning2Body(String name) {
    return '$name เริ่มต้นวันด้วยความขอบพระคุณ';
  }

  @override
  String get notifyMorning3Title => '✨ พระคุณของวันนี้';

  @override
  String notifyMorning3Body(String name) {
    return '$name พบกับพระคุณที่พระเจ้าเตรียมไว้';
  }

  @override
  String get notifyMorning4Title => '🕊️ เช้าที่สงบ';

  @override
  String notifyMorning4Body(String name) {
    return '$name เติมใจด้วยสันติสุขผ่านการอธิษฐาน';
  }

  @override
  String get notifyMorning5Title => '📖 กับพระวจนะ';

  @override
  String notifyMorning5Body(String name) {
    return '$name ฟังพระสุรเสียงของพระเจ้าในวันนี้';
  }

  @override
  String get notifyMorning6Title => '🌿 เวลาพักผ่อน';

  @override
  String notifyMorning6Body(String name) {
    return '$name หยุดสักครู่แล้วอธิษฐาน';
  }

  @override
  String get notifyMorning7Title => '💫 วันนี้ก็เช่นกัน';

  @override
  String notifyMorning7Body(String name) {
    return '$name วันที่เริ่มต้นด้วยการอธิษฐานจะแตกต่าง';
  }

  @override
  String get notifyEvening1Title => '✨ ขอบพระคุณสำหรับวันนี้';

  @override
  String get notifyEvening1Body => 'ย้อนดูวันนี้แล้วอธิษฐานขอบพระคุณ';

  @override
  String get notifyEvening2Title => '🌙 ปิดท้ายวัน';

  @override
  String get notifyEvening2Body => 'แสดงความขอบพระคุณของวันนี้ผ่านการอธิษฐาน';

  @override
  String get notifyEvening3Title => '🙏 การอธิษฐานยามเย็น';

  @override
  String get notifyEvening3Body => 'ในตอนท้ายของวัน ขอบพระคุณพระเจ้า';

  @override
  String get notifyEvening4Title => '🌟 นับพระพรของวันนี้';

  @override
  String get notifyEvening4Body =>
      'หากมีสิ่งที่ต้องขอบพระคุณ ให้แบ่งปันในการอธิษฐาน';

  @override
  String get notifyStreak3Title => '🌱 3 วันติด!';

  @override
  String get notifyStreak3Body => 'นิสัยการอธิษฐานของคุณเริ่มต้นแล้ว';

  @override
  String get notifyStreak7Title => '🌿 หนึ่งสัปดาห์เต็ม!';

  @override
  String get notifyStreak7Body => 'การอธิษฐานกำลังกลายเป็นนิสัย';

  @override
  String get notifyStreak14Title => '🌳 2 สัปดาห์ติด!';

  @override
  String get notifyStreak14Body => 'การเติบโตที่น่าทึ่ง!';

  @override
  String get notifyStreak21Title => '🌻 3 สัปดาห์ติด!';

  @override
  String get notifyStreak21Body => 'ดอกไม้แห่งการอธิษฐานกำลังผลิบาน';

  @override
  String get notifyStreak30Title => '🏆 หนึ่งเดือนเต็ม!';

  @override
  String get notifyStreak30Body => 'การอธิษฐานของคุณกำลังส่องสว่าง';

  @override
  String get notifyStreak50Title => '👑 50 วันติด!';

  @override
  String get notifyStreak50Body => 'การเดินกับพระเจ้าของคุณกำลังลึกซึ้งขึ้น';

  @override
  String get notifyStreak100Title => '🎉 100 วันติด!';

  @override
  String get notifyStreak100Body => 'คุณได้กลายเป็นนักรบแห่งการอธิษฐาน!';

  @override
  String get notifyStreak365Title => '✝️ หนึ่งปีเต็ม!';

  @override
  String get notifyStreak365Body => 'เป็นการเดินทางแห่งความเชื่อที่น่าทึ่ง!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ วันนี้คุณอธิษฐานหรือยัง?';

  @override
  String get notifyAfternoonNudgeBody =>
      'การอธิษฐานเพียงชั่วครู่ก็เปลี่ยนวันได้';

  @override
  String get notifyChannelName => 'การแจ้งเตือนอธิษฐาน';

  @override
  String get notifyChannelDescription =>
      'อธิษฐานตอนเช้า ขอบพระคุณตอนเย็น และการแจ้งเตือนอื่นๆ';

  @override
  String get milestoneFirstPrayerTitle => 'การอธิษฐานครั้งแรก!';

  @override
  String get milestoneFirstPrayerDesc =>
      'การเดินทางแห่งการอธิษฐานของคุณได้เริ่มต้นแล้ว พระเจ้ากำลังฟังอยู่';

  @override
  String get milestoneSevenDayStreakTitle => 'อธิษฐาน 7 วันติดต่อกัน!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'หนึ่งสัปดาห์ของการอธิษฐานที่สัตย์ซื่อ สวนของคุณกำลังเติบโต!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 วัน!';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'สวนของคุณได้เบ่งบานเป็นทุ่งดอกไม้!';

  @override
  String get milestoneHundredPrayersTitle => 'การอธิษฐานครั้งที่ 100!';

  @override
  String get milestoneHundredPrayersDesc =>
      'การสนทนากับพระเจ้าร้อยครั้ง คุณหยั่งรากลึกแล้ว';

  @override
  String get homeFirstPrayerPrompt => 'เริ่มการอธิษฐานครั้งแรกของคุณ';

  @override
  String get homeFirstQtPrompt => 'เริ่ม QT ครั้งแรกของคุณ';

  @override
  String homeActivityPrompt(String activityName) {
    return 'วันนี้ก็ $activityName ด้วย';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return '$activityName ต่อเนื่องวันที่ $count';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'ผ่านไป $days วันนับจาก $activityName ครั้งล่าสุด';
  }

  @override
  String get homeActivityPrayer => 'การอธิษฐาน';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'กำลังโหลด...';

  @override
  String get heatmapNoPrayer => 'ไม่มีการอธิษฐาน';

  @override
  String get heatmapLegendLess => 'น้อย';

  @override
  String get heatmapLegendMore => 'มาก';

  @override
  String get qtPassagesLoadError =>
      'ไม่สามารถโหลดข้อพระคัมภีร์ของวันนี้ กรุณาตรวจสอบการเชื่อมต่อ';

  @override
  String get qtPassagesRetryButton => 'ลองอีกครั้ง';

  @override
  String get aiStreamingInitial => 'Meditating on your prayer...';

  @override
  String get aiTierProcessing => 'More reflections coming...';

  @override
  String get aiScriptureValidating => 'Finding the right scripture...';

  @override
  String get aiScriptureValidatingFailed =>
      'Preparing this scripture for you...';

  @override
  String get aiTemplateFallback => 'While we prepare your full analysis...';

  @override
  String get aiPendingMore => 'Preparing more...';

  @override
  String get aiTierIncomplete => 'Coming soon, check back later';

  @override
  String get tierCompleted => 'New reflection added';

  @override
  String get tierProcessingNotice => 'Generating more reflections...';

  @override
  String get proSectionLoading => 'Preparing your premium content...';

  @override
  String get proSectionWillArrive => 'Your deep reflection will appear here';

  @override
  String get templateCategoryHealth => 'For Health Concerns';

  @override
  String get templateCategoryFamily => 'For Family';

  @override
  String get templateCategoryWork => 'For Work & Studies';

  @override
  String get templateCategoryGratitude => 'A Thankful Heart';

  @override
  String get templateCategoryGrief => 'In Grief or Loss';

  @override
  String get sectionStatusCompleted => 'Analysis complete';

  @override
  String get sectionStatusPartial => 'Partial analysis (more coming)';

  @override
  String get sectionStatusPending => 'Analysis in progress';
}
