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
  String get testimonyTitle => 'คำพยานของฉัน';

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
  String get meditationAnalysisTitle => 'การวิเคราะห์การเฝ้าเดี่ยว';

  @override
  String get keyThemeLabel => 'หัวข้อหลัก';

  @override
  String get applicationTitle => 'การประยุกต์ใช้วันนี้';

  @override
  String get applicationWhat => 'อะไร';

  @override
  String get applicationWhen => 'เมื่อไหร่';

  @override
  String get applicationContext => 'ที่ไหน';

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
  String accessUntil(String date) {
    return 'Access until: $date';
  }

  @override
  String subscriptionCancelledNotice(String date) {
    return 'Your subscription has been cancelled. You\'ll have access until $date.';
  }
}
