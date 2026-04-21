// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Khi bạn cầu nguyện,\nĐức Chúa Trời đáp lời.';

  @override
  String get welcomeSubtitle =>
      'Bạn đồng hành cầu nguyện & tĩnh nguyện mỗi ngày';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get loginTitle => 'Chào mừng đến với Abba';

  @override
  String get loginSubtitle => 'Đăng nhập để bắt đầu hành trình cầu nguyện';

  @override
  String get signInWithApple => 'Tiếp tục với Apple';

  @override
  String get signInWithGoogle => 'Tiếp tục với Google';

  @override
  String get signInWithEmail => 'Tiếp tục với Email';

  @override
  String greetingMorning(Object name) {
    return 'Chào buổi sáng, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Chào buổi chiều, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Chào buổi tối, $name';
  }

  @override
  String get prayButton => 'Cầu nguyện';

  @override
  String get qtButton => 'Tĩnh nguyện';

  @override
  String streakDays(Object count) {
    return '$count ngày cầu nguyện liên tiếp';
  }

  @override
  String get dailyVerse => 'Câu gốc hôm nay';

  @override
  String get tabHome => 'Trang chủ';

  @override
  String get tabCalendar => 'Lịch';

  @override
  String get tabCommunity => 'Cộng đồng';

  @override
  String get tabSettings => 'Cài đặt';

  @override
  String get recordingTitle => 'Đang cầu nguyện...';

  @override
  String get recordingPause => 'Tạm dừng';

  @override
  String get recordingResume => 'Tiếp tục';

  @override
  String get finishPrayer => 'Kết thúc cầu nguyện';

  @override
  String get finishPrayerConfirm => 'Bạn có muốn kết thúc cầu nguyện không?';

  @override
  String get switchToText => 'Nhập văn bản';

  @override
  String get textInputHint => 'Viết lời cầu nguyện tại đây...';

  @override
  String get aiLoadingText => 'Đang suy ngẫm lời cầu nguyện của bạn...';

  @override
  String get aiLoadingVerse =>
      'Hãy yên lặng và biết rằng Ta là Đức Chúa Trời.\n— Thi thiên 46:10';

  @override
  String get dashboardTitle => 'Vườn Cầu Nguyện';

  @override
  String get shareButton => 'Chia sẻ';

  @override
  String get backToHome => 'Về trang chủ';

  @override
  String get scriptureTitle => 'Lời Chúa hôm nay';

  @override
  String get bibleStoryTitle => 'Câu chuyện Kinh Thánh';

  @override
  String get testimonyTitle => 'Chứng lời · Lời cầu nguyện của tôi';

  @override
  String get testimonyHelperText =>
      'Suy ngẫm về lời cầu nguyện · có thể chia sẻ với cộng đồng';

  @override
  String get myPrayerAudioLabel => 'Bản ghi lời cầu nguyện của tôi';

  @override
  String get testimonyEdit => 'Chỉnh sửa';

  @override
  String get guidanceTitle => 'Hướng dẫn AI';

  @override
  String get aiPrayerTitle => 'Lời cầu nguyện cho bạn';

  @override
  String get originalLangTitle => 'Ngôn ngữ gốc';

  @override
  String get proUnlock => 'Mở khóa với Pro';

  @override
  String get qtPageTitle => 'Vườn buổi sáng';

  @override
  String get qtMeditateButton => 'Bắt đầu suy ngẫm';

  @override
  String get qtCompleted => 'Hoàn thành';

  @override
  String get communityTitle => 'Vườn Cầu Nguyện';

  @override
  String get filterAll => 'Tất cả';

  @override
  String get filterTestimony => 'Lời chứng';

  @override
  String get filterPrayerRequest => 'Xin cầu nguyện';

  @override
  String get likeButton => 'Thích';

  @override
  String get commentButton => 'Bình luận';

  @override
  String get saveButton => 'Lưu';

  @override
  String get replyButton => 'Trả lời';

  @override
  String get writePostTitle => 'Chia sẻ';

  @override
  String get cancelButton => 'Hủy';

  @override
  String get sharePostButton => 'Đăng';

  @override
  String get anonymousToggle => 'Ẩn danh';

  @override
  String get realNameToggle => 'Tên thật';

  @override
  String get categoryTestimony => 'Lời chứng';

  @override
  String get categoryPrayerRequest => 'Xin cầu nguyện';

  @override
  String get writePostHint => 'Chia sẻ lời chứng hoặc lời xin cầu nguyện...';

  @override
  String get importFromPrayer => 'Lấy từ lời cầu nguyện';

  @override
  String get calendarTitle => 'Lịch cầu nguyện';

  @override
  String get currentStreak => 'Chuỗi hiện tại';

  @override
  String get bestStreak => 'Chuỗi dài nhất';

  @override
  String get days => 'ngày';

  @override
  String calendarRecordCount(Object count) {
    return '$count bản ghi';
  }

  @override
  String get todayVerse => 'Câu gốc hôm nay';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get profileSection => 'Hồ sơ';

  @override
  String get totalPrayers => 'Tổng số lần cầu nguyện';

  @override
  String get consecutiveDays => 'Ngày liên tiếp';

  @override
  String get proSection => 'Thành viên';

  @override
  String get freePlan => 'Miễn phí';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '169.000đ / tháng';

  @override
  String get yearlyPrice => '1.249.000đ / năm';

  @override
  String get yearlySave => 'Tiết kiệm 40%';

  @override
  String get launchPromo => '3 tháng chỉ 99.000₫/tháng!';

  @override
  String get startPro => 'Bắt đầu Pro';

  @override
  String get comingSoon => 'Sắp ra mắt';

  @override
  String get notificationSetting => 'Thông báo';

  @override
  String get languageSetting => 'Ngôn ngữ';

  @override
  String get darkModeSetting => 'Chế độ tối';

  @override
  String get helpCenter => 'Trung tâm hỗ trợ';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get logout => 'Đăng xuất';

  @override
  String appVersion(Object version) {
    return 'Phiên bản $version';
  }

  @override
  String get anonymous => 'Ẩn danh';

  @override
  String timeAgo(Object time) {
    return '$time trước';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get cancel => 'Hủy';

  @override
  String get noPrayersRecorded => 'Chưa có lời cầu nguyện nào';

  @override
  String get deletePost => 'Xóa';

  @override
  String get reportPost => 'Báo cáo';

  @override
  String get reportSubmitted => 'Báo cáo đã được gửi. Cảm ơn bạn.';

  @override
  String get reportReasonHint =>
      'Vui lòng mô tả lý do báo cáo. Nội dung sẽ được gửi qua email.';

  @override
  String get reportReasonPlaceholder => 'Nhập lý do báo cáo...';

  @override
  String get reportSubmitButton => 'Báo cáo';

  @override
  String get deleteConfirmTitle => 'Xóa bài viết';

  @override
  String get deleteConfirmMessage => 'Bạn có chắc muốn xóa bài viết này không?';

  @override
  String get errorNetwork => 'Vui lòng kiểm tra kết nối internet và thử lại.';

  @override
  String get errorAiFallback =>
      'Không thể kết nối AI. Đây là một câu Kinh Thánh cho bạn.';

  @override
  String get errorSttFailed =>
      'Nhận dạng giọng nói không khả dụng. Vui lòng nhập văn bản.';

  @override
  String get errorPayment =>
      'Đã xảy ra lỗi thanh toán. Vui lòng thử lại trong Cài đặt.';

  @override
  String get errorGeneric => 'Đã xảy ra lỗi. Vui lòng thử lại sau.';

  @override
  String get offlineNotice =>
      'Bạn đang ngoại tuyến. Một số tính năng có thể bị hạn chế.';

  @override
  String get retryButton => 'Thử lại';

  @override
  String get groupSection => 'Nhóm của tôi';

  @override
  String get createGroup => 'Tạo nhóm cầu nguyện';

  @override
  String get inviteFriends => 'Mời bạn bè';

  @override
  String get groupInviteMessage =>
      'Hãy cùng cầu nguyện! Tham gia nhóm cầu nguyện của tôi trên Abba.';

  @override
  String get noGroups => 'Tham gia hoặc tạo nhóm để cùng cầu nguyện.';

  @override
  String get promoTitle => 'Ưu đãi ra mắt';

  @override
  String get promoBanner => '3 tháng đầu chỉ 99.000₫/tháng!';

  @override
  String promoEndsOn(Object date) {
    return 'Ưu đãi kết thúc $date';
  }

  @override
  String get proLimitTitle => 'Lời cầu nguyện hôm nay đã hoàn tất';

  @override
  String get proLimitBody =>
      'Hẹn gặp bạn ngày mai!\nCầu nguyện không giới hạn với Pro';

  @override
  String get laterButton => 'Để sau';

  @override
  String get proPromptTitle => 'Tính năng Pro';

  @override
  String get proPromptBody =>
      'Tính năng này dành cho Pro.\nBạn muốn xem các gói không?';

  @override
  String get viewProducts => 'Xem gói';

  @override
  String get maybeLater => 'Để sau';

  @override
  String get proHeadline => 'Mỗi ngày gần Chúa hơn';

  @override
  String get proBenefit1 => 'Cầu nguyện & Tĩnh nguyện không giới hạn';

  @override
  String get proBenefit2 => 'Cầu nguyện & hướng dẫn bằng AI';

  @override
  String get proBenefit3 => 'Câu chuyện đức tin từ lịch sử';

  @override
  String get proBenefit5 => 'Học Kinh Thánh nguyên ngữ';

  @override
  String get bestValue => 'GIÁ TRỊ NHẤT';

  @override
  String get perMonth => 'tháng';

  @override
  String get cancelAnytime => 'Hủy bất cứ lúc nào';

  @override
  String get restorePurchase => 'Khôi phục giao dịch';

  @override
  String get yearlyPriceMonthly => '104.083đ/tháng';

  @override
  String get morningPrayerReminder => 'Cầu nguyện buổi sáng';

  @override
  String get eveningGratitudeReminder => 'Tạ ơn buổi tối';

  @override
  String get streakReminder => 'Nhắc nhở chuỗi ngày';

  @override
  String get afternoonNudgeReminder => 'Nhắc cầu nguyện buổi chiều';

  @override
  String get weeklySummaryReminder => 'Tổng kết tuần';

  @override
  String get unlimited => 'Không giới hạn';

  @override
  String get streakRecovery => 'Không sao, bạn có thể bắt đầu lại 🌱';

  @override
  String get prayerSaved => 'Lời cầu nguyện đã được lưu';

  @override
  String get quietTimeLabel => 'Tĩnh nguyện';

  @override
  String get morningPrayerLabel => 'Cầu nguyện sáng';

  @override
  String get gardenSeed => 'Hạt giống đức tin';

  @override
  String get gardenSprout => 'Mầm non đang lớn';

  @override
  String get gardenBud => 'Nụ hoa';

  @override
  String get gardenBloom => 'Hoa nở rộ';

  @override
  String get gardenTree => 'Cây vững chắc';

  @override
  String get gardenForest => 'Rừng cầu nguyện';

  @override
  String get milestoneShare => 'Chia sẻ';

  @override
  String get milestoneThankGod => 'Tạ ơn Chúa!';

  @override
  String shareStreakText(Object count) {
    return '$count ngày cầu nguyện liên tiếp! Hành trình cầu nguyện cùng Abba #Abba #CầuNguyện';
  }

  @override
  String get shareDaysLabel => 'ngày cầu nguyện liên tiếp';

  @override
  String get shareSubtitle => 'Cầu nguyện mỗi ngày cùng Chúa';

  @override
  String get proActive => 'Thành viên Hoạt động';

  @override
  String get planOncePerDay => '1 lần/ngày';

  @override
  String get planUnlimited => 'Không giới hạn';

  @override
  String get closeRecording => 'Đóng ghi âm';

  @override
  String get qtRevealMessage => 'Hãy mở Lời Chúa hôm nay';

  @override
  String get qtSelectPrompt => 'Chọn một đề tài và bắt đầu tĩnh nguyện hôm nay';

  @override
  String get qtTopicLabel => 'Chủ đề';

  @override
  String get prayerStartPrompt => 'Bắt đầu cầu nguyện';

  @override
  String get startPrayerButton => 'Bắt đầu cầu nguyện';

  @override
  String get switchToTextMode => 'Nhập văn bản';

  @override
  String get switchToVoiceMode => 'Noi';

  @override
  String get prayerDashboardTitle => 'Vườn Cầu Nguyện';

  @override
  String get qtDashboardTitle => 'Vườn Tĩnh Nguyện';

  @override
  String get prayerSummaryTitle => 'Tóm tắt cầu nguyện';

  @override
  String get gratitudeLabel => 'Tạ ơn';

  @override
  String get petitionLabel => 'Cầu xin';

  @override
  String get intercessionLabel => 'Cầu thay';

  @override
  String get historicalStoryTitle => 'Câu chuyện lịch sử';

  @override
  String get todayLesson => 'Bài học hôm nay';

  @override
  String get meditationAnalysisTitle => 'Phân tích suy ngẫm';

  @override
  String get keyThemeLabel => 'Chủ đề chính';

  @override
  String get applicationTitle => 'Áp dụng hôm nay';

  @override
  String get applicationWhat => 'Điều gì';

  @override
  String get applicationWhen => 'Khi nào';

  @override
  String get applicationContext => 'Ở đâu';

  @override
  String get relatedKnowledgeTitle => 'Kiến thức liên quan';

  @override
  String get originalWordLabel => 'Từ nguyên gốc';

  @override
  String get historicalContextLabel => 'Bối cảnh lịch sử';

  @override
  String get crossReferencesLabel => 'Tham chiếu chéo';

  @override
  String get growthStoryTitle => 'Câu chuyện tăng trưởng';

  @override
  String get prayerGuideTitle => 'Cách cầu nguyện với Abba';

  @override
  String get prayerGuide1 => 'Hãy cầu nguyện thành tiếng rõ ràng';

  @override
  String get prayerGuide2 =>
      'Abba lắng nghe lời cầu nguyện và tìm câu Kinh Thánh chạm đến lòng bạn';

  @override
  String get prayerGuide3 => 'Bạn cũng có thể nhập lời cầu nguyện bằng văn bản';

  @override
  String get qtGuideTitle => 'Cách tĩnh nguyện với Abba';

  @override
  String get qtGuide1 => 'Đọc đoạn Kinh Thánh và suy ngẫm trong yên lặng';

  @override
  String get qtGuide2 =>
      'Chia sẻ điều bạn khám phá — nói hoặc viết suy ngẫm của bạn';

  @override
  String get qtGuide3 =>
      'Abba sẽ giúp bạn áp dụng Lời Chúa vào cuộc sống hàng ngày';

  @override
  String get scriptureReasonLabel => 'Tại sao câu Kinh Thánh này';

  @override
  String get scripturePostureLabel => 'Đọc với tâm thế nào?';

  @override
  String get scriptureOriginalWordsTitle =>
      'Ý nghĩa sâu sắc trong ngôn ngữ gốc';

  @override
  String get originalWordMeaningLabel => 'Ý nghĩa';

  @override
  String get originalWordNuanceLabel => 'Sắc thái so với bản dịch';

  @override
  String originalWordsCountLabel(int count) {
    return '$count từ';
  }

  @override
  String get seeMore => 'Xem thêm';

  @override
  String seeAllComments(Object count) {
    return 'Xem tất cả $count bình luận';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name và $count người khác đã thích';
  }

  @override
  String get commentsTitle => 'Bình luận';

  @override
  String get myPageTitle => 'Vườn cầu nguyện của tôi';

  @override
  String get myPrayers => 'Lời cầu nguyện';

  @override
  String get myTestimonies => 'Lời chứng';

  @override
  String get savedPosts => 'Đã lưu';

  @override
  String get totalPrayersCount => 'Cầu nguyện';

  @override
  String get streakCount => 'Chuỗi ngày';

  @override
  String get testimoniesCount => 'Lời chứng';

  @override
  String get linkAccountTitle => 'Liên kết tài khoản';

  @override
  String get linkAccountDescription =>
      'Liên kết tài khoản để giữ lại dữ liệu cầu nguyện khi đổi thiết bị';

  @override
  String get linkWithApple => 'Liên kết với Apple';

  @override
  String get linkWithGoogle => 'Liên kết với Google';

  @override
  String get linkAccountSuccess => 'Liên kết tài khoản thành công!';

  @override
  String get anonymousUser => 'Chiến sĩ cầu nguyện';

  @override
  String showReplies(Object count) {
    return 'Xem $count trả lời';
  }

  @override
  String get hideReplies => 'Ẩn trả lời';

  @override
  String replyingTo(Object name) {
    return 'Đang trả lời $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Xem tất cả $count bình luận';
  }

  @override
  String get membershipTitle => 'Thành viên';

  @override
  String get membershipSubtitle => 'Làm sâu thêm đời sống cầu nguyện';

  @override
  String get monthlyPlan => 'Hàng tháng';

  @override
  String get yearlyPlan => 'Hàng năm';

  @override
  String get yearlySavings => '64.917đ/tháng (giảm 40%)';

  @override
  String get startMembership => 'Bắt đầu';

  @override
  String get membershipActive => 'Thành viên Hoạt động';

  @override
  String get leaveRecordingTitle => 'Rời khỏi bản ghi?';

  @override
  String get leaveRecordingMessage =>
      'Bản ghi của bạn sẽ bị mất. Bạn có chắc không?';

  @override
  String get leaveButton => 'Rời đi';

  @override
  String get stayButton => 'Ở lại';

  @override
  String likedByCount(Object count) {
    return '$count người đã đồng cảm';
  }

  @override
  String get actionLike => 'Thích';

  @override
  String get actionComment => 'Bình luận';

  @override
  String get actionSave => 'Lưu';

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
  String get qtLoadingHint1 =>
      '💛 Tình yêu — Nghĩ về người bạn yêu thương trong 10 giây';

  @override
  String get qtLoadingHint2 => '🌿 Ân điển — Nhớ lại một ân điển nhỏ hôm nay';

  @override
  String get qtLoadingHint3 =>
      '🌅 Hy vọng — Hình dung một hy vọng nhỏ cho ngày mai';

  @override
  String get qtLoadingHint4 => '🕊️ Bình an — Hít thở sâu ba lần thật chậm';

  @override
  String get qtLoadingHint5 => '🌳 Đức tin — Nhớ một sự thật không đổi';

  @override
  String get qtLoadingHint6 =>
      '🌸 Lòng biết ơn — Nói ra một điều bạn biết ơn ngay bây giờ';

  @override
  String get qtLoadingHint7 => '🌊 Tha thứ — Nghĩ đến người bạn muốn tha thứ';

  @override
  String get qtLoadingHint8 =>
      '📖 Sự khôn ngoan — Ghi nhớ một bài học của hôm nay';

  @override
  String get qtLoadingHint9 =>
      '⏳ Kiên nhẫn — Nghĩ về điều bạn đang lặng lẽ chờ đợi';

  @override
  String get qtLoadingHint10 =>
      '✨ Niềm vui — Nhớ khoảnh khắc bạn mỉm cười hôm nay';

  @override
  String get qtLoadingTitle => 'Đang chuẩn bị Lời hôm nay...';

  @override
  String get coachingTitle => 'Huấn luyện cầu nguyện';

  @override
  String get coachingLoadingText =>
      'Đang suy ngẫm về lời cầu nguyện của bạn...';

  @override
  String get coachingErrorText => 'Lỗi tạm thời — vui lòng thử lại';

  @override
  String get coachingRetryButton => 'Thử lại';

  @override
  String get coachingScoreSpecificity => 'Tính cụ thể';

  @override
  String get coachingScoreGodCentered => 'Lấy Chúa làm trung tâm';

  @override
  String get coachingScoreActs => 'Cân bằng ACTS';

  @override
  String get coachingScoreAuthenticity => 'Tính chân thực';

  @override
  String get coachingStrengthsTitle => 'Điều bạn đã làm tốt ✨';

  @override
  String get coachingImprovementsTitle => 'Để đi sâu hơn 💡';

  @override
  String get coachingProCta => 'Mở Huấn luyện cầu nguyện với Pro';

  @override
  String get coachingLevelBeginner => '🌱 Người mới';

  @override
  String get coachingLevelGrowing => '🌿 Đang phát triển';

  @override
  String get coachingLevelExpert => '🌳 Chuyên gia';

  @override
  String get aiPrayerCitationsTitle => 'Tham khảo · Trích dẫn';

  @override
  String get citationTypeQuote => 'Trích dẫn';

  @override
  String get citationTypeScience => 'Nghiên cứu';

  @override
  String get citationTypeExample => 'Ví dụ';

  @override
  String get aiPrayerReadingTime => 'Đọc trong 2 phút';

  @override
  String get scriptureKeyWordHintTitle => 'Từ khóa hôm nay';

  @override
  String get bibleLookupReferenceHint =>
      'Tìm đoạn Kinh Thánh này trong Kinh Thánh của bạn và suy ngẫm.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Các bản dịch Kinh Thánh';

  @override
  String get settingsBibleTranslationsIntro =>
      'Các câu Kinh Thánh trong ứng dụng này đến từ các bản dịch thuộc phạm vi công cộng. Các bình luận, lời cầu nguyện và câu chuyện do AI tạo ra là tác phẩm sáng tạo của Abba.';
}
