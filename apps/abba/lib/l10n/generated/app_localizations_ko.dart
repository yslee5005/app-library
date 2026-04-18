// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => '아바';

  @override
  String get welcomeTitle => '기도하면,\n하나님이 응답하십니다.';

  @override
  String get welcomeSubtitle => '매일 기도와 큐티를 함께하는 AI 동반자';

  @override
  String get getStarted => '시작하기';

  @override
  String get loginTitle => '아바에 오신 것을 환영합니다';

  @override
  String get loginSubtitle => '로그인하고 기도 여정을 시작하세요';

  @override
  String get signInWithApple => 'Apple로 계속하기';

  @override
  String get signInWithGoogle => 'Google로 계속하기';

  @override
  String get signInWithEmail => '이메일로 계속하기';

  @override
  String greetingMorning(Object name) {
    return '좋은 아침이에요, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return '좋은 오후에요, $name';
  }

  @override
  String greetingEvening(Object name) {
    return '좋은 저녁이에요, $name';
  }

  @override
  String get prayButton => '기도하기';

  @override
  String get qtButton => 'QT하기';

  @override
  String streakDays(Object count) {
    return '$count일 연속 기도';
  }

  @override
  String get dailyVerse => '오늘의 말씀';

  @override
  String get tabHome => '홈';

  @override
  String get tabCalendar => '달력';

  @override
  String get tabCommunity => '커뮤니티';

  @override
  String get tabSettings => '설정';

  @override
  String get recordingTitle => '기도 중...';

  @override
  String get recordingPause => '일시정지';

  @override
  String get recordingResume => '계속하기';

  @override
  String get finishPrayer => '기도를 마칩니다';

  @override
  String get finishPrayerConfirm => '기도를 마치시겠습니까?';

  @override
  String get switchToText => '텍스트로 전환';

  @override
  String get textInputHint => '기도를 적어주세요...';

  @override
  String get aiLoadingText => '당신의 기도를 묵상하고 있습니다...';

  @override
  String get aiLoadingVerse => '너희는 가만히 있어 내가 하나님 됨을 알지어다.\n— 시편 46:10';

  @override
  String get dashboardTitle => '기도 정원';

  @override
  String get shareButton => '공유';

  @override
  String get backToHome => '홈으로 돌아가기';

  @override
  String get scriptureTitle => '오늘의 말씀';

  @override
  String get bibleStoryTitle => '성경 이야기';

  @override
  String get testimonyTitle => '나의 간증';

  @override
  String get testimonyEdit => '수정';

  @override
  String get guidanceTitle => 'AI 조언';

  @override
  String get aiPrayerTitle => '당신을 위한 기도';

  @override
  String get originalLangTitle => '원어의 깊은 뜻';

  @override
  String get premiumUnlock => '프리미엄으로 보기';

  @override
  String get qtPageTitle => '아침 정원';

  @override
  String get qtMeditateButton => '묵상 시작하기';

  @override
  String get qtCompleted => '완료';

  @override
  String get communityTitle => '기도 정원';

  @override
  String get filterAll => '전체';

  @override
  String get filterTestimony => '간증';

  @override
  String get filterPrayerRequest => '기도요청';

  @override
  String get likeButton => '좋아요';

  @override
  String get commentButton => '댓글';

  @override
  String get saveButton => '저장';

  @override
  String get replyButton => '답글';

  @override
  String get writePostTitle => '나누기';

  @override
  String get cancelButton => '취소';

  @override
  String get sharePostButton => '공유하기';

  @override
  String get anonymousToggle => '익명';

  @override
  String get realNameToggle => '실명';

  @override
  String get categoryTestimony => '간증';

  @override
  String get categoryPrayerRequest => '기도요청';

  @override
  String get writePostHint => '간증이나 기도요청을 나눠주세요...';

  @override
  String get importFromPrayer => '기도에서 가져오기';

  @override
  String get calendarTitle => '기도 달력';

  @override
  String get currentStreak => '현재 연속';

  @override
  String get bestStreak => '최장 기록';

  @override
  String get days => '일';

  @override
  String calendarRecordCount(Object count) {
    return '$count개의 기록';
  }

  @override
  String get todayVerse => '오늘의 한 줄';

  @override
  String get settingsTitle => '설정';

  @override
  String get profileSection => '프로필';

  @override
  String get totalPrayers => '총 기도 횟수';

  @override
  String get consecutiveDays => '연속 기도일';

  @override
  String get premiumSection => '멤버십';

  @override
  String get freePlan => '무료';

  @override
  String get premiumPlan => '프리미엄';

  @override
  String get monthlyPrice => '₩9,900 / 월';

  @override
  String get yearlyPrice => '₩79,900 / 년';

  @override
  String get yearlySave => '40% 절약';

  @override
  String get launchPromo => '3개월간 ₩5,900/월!';

  @override
  String get startPremium => '프리미엄 시작하기';

  @override
  String get comingSoon => '곧 출시됩니다';

  @override
  String get notificationSetting => '알림';

  @override
  String get languageSetting => '언어';

  @override
  String get darkModeSetting => '다크모드';

  @override
  String get helpCenter => '도움말';

  @override
  String get termsOfService => '이용약관';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get logout => '로그아웃';

  @override
  String appVersion(Object version) {
    return '버전 $version';
  }

  @override
  String get anonymous => '익명';

  @override
  String timeAgo(Object time) {
    return '$time 전';
  }

  @override
  String get emailLabel => '이메일';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get signIn => '로그인';

  @override
  String get cancel => '취소';

  @override
  String get noPrayersRecorded => '기도 기록이 없습니다';

  @override
  String get deletePost => '삭제';

  @override
  String get reportPost => '신고';

  @override
  String get reportSubmitted => '신고가 접수되었습니다. 감사합니다.';

  @override
  String get reportReasonHint => '신고 사유를 작성해주세요. 이메일로 전송됩니다.';

  @override
  String get reportReasonPlaceholder => '신고 사유를 입력하세요...';

  @override
  String get reportSubmitButton => '신고하기';

  @override
  String get deleteConfirmTitle => '글 삭제';

  @override
  String get deleteConfirmMessage => '이 글을 삭제하시겠습니까?';

  @override
  String get errorNetwork => '인터넷 연결을 확인하고 다시 시도해주세요.';

  @override
  String get errorAiFallback => 'AI에 연결할 수 없습니다. 오늘의 말씀을 보여드릴게요.';

  @override
  String get errorSttFailed => '음성 인식을 사용할 수 없습니다. 텍스트로 입력해주세요.';

  @override
  String get errorPayment => '결제에 문제가 있습니다. 설정에서 다시 시도해주세요.';

  @override
  String get errorGeneric => '잠시 후 다시 시도해주세요.';

  @override
  String get offlineNotice => '오프라인 상태입니다. 일부 기능이 제한될 수 있습니다.';

  @override
  String get retryButton => '다시 시도';

  @override
  String get groupSection => '내 그룹';

  @override
  String get createGroup => '기도 그룹 만들기';

  @override
  String get inviteFriends => '친구 초대하기';

  @override
  String get groupInviteMessage => '같이 기도해요! Abba에서 기도 그룹에 참여하세요.';

  @override
  String get noGroups => '그룹에 참여하거나 만들어 함께 기도하세요.';

  @override
  String get promoTitle => '런칭 특가';

  @override
  String get promoBanner => '3개월간 ₩5,900/월!';

  @override
  String promoEndsOn(Object date) {
    return '$date까지 특가';
  }

  @override
  String get premiumLimitTitle => '오늘의 기도를 마쳤습니다';

  @override
  String get premiumLimitBody => '내일 다시 만나요!\n프리미엄으로 무제한 기도하기';

  @override
  String get laterButton => '다음에 하기';

  @override
  String get premiumPromptTitle => 'Pro 기능이에요';

  @override
  String get premiumPromptBody => '이 기능은 Pro에서 사용할 수 있어요.\n프리미엄 상품을 확인해보시겠어요?';

  @override
  String get viewProducts => '상품 보기';

  @override
  String get maybeLater => '다음에 할게요';

  @override
  String get premiumHeadline => '매일 하나님과 더 가까이';

  @override
  String get premiumBenefit1 => '무제한 기도 & QT';

  @override
  String get premiumBenefit2 => 'AI 맞춤 기도문 & 조언';

  @override
  String get premiumBenefit3 => '역사 속 믿음의 이야기';

  @override
  String get premiumBenefit5 => '원어 성경 해석';

  @override
  String get bestValue => 'BEST VALUE';

  @override
  String get perMonth => '월';

  @override
  String get cancelAnytime => '언제든 취소 가능';

  @override
  String get restorePurchase => '구독 복원';

  @override
  String get yearlyPriceMonthly => '₩2,800/월';

  @override
  String get morningPrayerReminder => '아침 기도';

  @override
  String get eveningGratitudeReminder => '저녁 감사';

  @override
  String get streakReminder => '스트릭 알림';

  @override
  String get afternoonNudgeReminder => '오후 기도 알림';

  @override
  String get weeklySummaryReminder => '주간 요약';

  @override
  String get unlimited => '무제한';

  @override
  String get streakRecovery => '괜찮아요, 다시 시작하면 돼요 🌱';

  @override
  String get prayerSaved => '기도가 저장되었습니다';

  @override
  String get quietTimeLabel => '큐티';

  @override
  String get morningPrayerLabel => '아침 기도';

  @override
  String get gardenSeed => '믿음의 씨앗';

  @override
  String get gardenSprout => '자라나는 새싹';

  @override
  String get gardenBud => '꽃봉오리';

  @override
  String get gardenBloom => '만개한 꽃';

  @override
  String get gardenTree => '든든한 나무';

  @override
  String get gardenForest => '기도의 숲';

  @override
  String get milestoneShare => '공유하기';

  @override
  String get milestoneThankGod => '감사합니다!';

  @override
  String shareStreakText(Object count) {
    return '$count일 연속 기도! Abba와 함께하는 기도 여정 #Abba #기도';
  }

  @override
  String get shareDaysLabel => '일 연속 기도';

  @override
  String get shareSubtitle => '하나님과 함께하는 매일의 기도';

  @override
  String get premiumActive => '멤버십 활성';

  @override
  String get planOncePerDay => '1일 1회';

  @override
  String get planUnlimited => '무제한';

  @override
  String get closeRecording => '녹음 닫기';

  @override
  String get qtRevealMessage => '오늘의 말씀을 펼쳐볼까요?';

  @override
  String get qtSelectPrompt => '하나를 선택해서 오늘 QT를 해보아요 🌿';

  @override
  String get qtTopicLabel => '주제';

  @override
  String get prayerStartPrompt => '기도를 시작하세요';

  @override
  String get startPrayerButton => '기도 시작하기';

  @override
  String get switchToTextMode => '텍스트로 전환';

  @override
  String get switchToVoiceMode => '음성으로 전환';

  @override
  String get prayerDashboardTitle => '기도 정원';

  @override
  String get qtDashboardTitle => 'QT 정원';

  @override
  String get prayerSummaryTitle => '기도 요약';

  @override
  String get gratitudeLabel => '감사';

  @override
  String get petitionLabel => '간구';

  @override
  String get intercessionLabel => '중보';

  @override
  String get historicalStoryTitle => '역사 속 이야기';

  @override
  String get todayLesson => '오늘의 교훈';

  @override
  String get meditationAnalysisTitle => '묵상 분석';

  @override
  String get keyThemeLabel => '핵심 테마';

  @override
  String get applicationTitle => '오늘의 적용';

  @override
  String get applicationWhat => '무엇을';

  @override
  String get applicationWhen => '언제';

  @override
  String get applicationContext => '어디서';

  @override
  String get relatedKnowledgeTitle => '관련 지식';

  @override
  String get originalWordLabel => '원어';

  @override
  String get historicalContextLabel => '역사적 배경';

  @override
  String get crossReferencesLabel => '관련 구절';

  @override
  String get growthStoryTitle => '영적 성장 이야기';

  @override
  String get prayerGuideTitle => '이렇게 기도해 보세요';

  @override
  String get prayerGuide1 => '소리 내어 기도해 주세요';

  @override
  String get prayerGuide2 => '아바가 기도를 듣고 마음에 와닿는 말씀을 찾아드려요';

  @override
  String get prayerGuide3 => '텍스트로 입력하셔도 괜찮아요';

  @override
  String get qtGuideTitle => '이렇게 묵상해 보세요';

  @override
  String get qtGuide1 => '말씀을 읽고 조용히 묵상해 주세요';

  @override
  String get qtGuide2 => '깨달은 것을 소리 내어 나누거나 글로 적어주세요';

  @override
  String get qtGuide3 => '아바가 말씀을 삶에 적용할 수 있도록 도와드려요';

  @override
  String get scriptureReasonLabel => '이 말씀을 드리는 이유';

  @override
  String get seeMore => '더 보기';

  @override
  String seeAllComments(Object count) {
    return '댓글 $count개 모두 보기';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name 외 $count명이 좋아합니다';
  }

  @override
  String get commentsTitle => '댓글';

  @override
  String get myPageTitle => '내 기도 정원';

  @override
  String get myPrayers => '내 기도';

  @override
  String get myTestimonies => '내 간증';

  @override
  String get savedPosts => '저장됨';

  @override
  String get totalPrayersCount => '기도';

  @override
  String get streakCount => '연속';

  @override
  String get testimoniesCount => '간증';

  @override
  String get linkAccountTitle => '계정 연결';

  @override
  String get linkAccountDescription => '계정을 연결하면 기기를 변경해도 기도 기록이 유지됩니다';

  @override
  String get linkWithApple => 'Apple로 연결';

  @override
  String get linkWithGoogle => 'Google로 연결';

  @override
  String get linkAccountSuccess => '계정이 연결되었습니다!';

  @override
  String get anonymousUser => '기도하는 사람';

  @override
  String showReplies(Object count) {
    return '답글 $count개 보기';
  }

  @override
  String get hideReplies => '답글 숨기기';

  @override
  String replyingTo(Object name) {
    return '$name에게 답글 작성 중';
  }

  @override
  String viewAllComments(Object count) {
    return '댓글 $count개 모두 보기';
  }

  @override
  String get membershipTitle => '멤버십';

  @override
  String get membershipSubtitle => '기도의 깊이를 더해보세요';

  @override
  String get monthlyPlan => '월간';

  @override
  String get yearlyPlan => '연간';

  @override
  String get yearlySavings => '월 ₩6,658 (33% 할인)';

  @override
  String get startMembership => '시작하기';

  @override
  String get membershipActive => '멤버십 활성';

  @override
  String get leaveRecordingTitle => '녹음을 중단하시겠습니까?';

  @override
  String get leaveRecordingMessage => '녹음 내용이 사라집니다. 정말 나가시겠습니까?';

  @override
  String get leaveButton => '나가기';

  @override
  String get stayButton => '머무르기';

  @override
  String likedByCount(Object count) {
    return '$count명이 공감했습니다';
  }

  @override
  String get actionLike => '공감';

  @override
  String get actionComment => '댓글';

  @override
  String get actionSave => '저장';
}
