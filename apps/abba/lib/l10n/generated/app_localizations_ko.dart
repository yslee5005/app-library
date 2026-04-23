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
  String get aiErrorNetworkTitle => '연결이 불안정해요';

  @override
  String get aiErrorNetworkBody => '기도는 안전하게 저장됐어요. 잠시 후 다시 시도해주세요.';

  @override
  String get aiErrorApiTitle => 'AI 서비스가 불안정해요';

  @override
  String get aiErrorApiBody => '기도는 안전하게 저장됐어요. 잠시 후 다시 시도해주세요.';

  @override
  String get aiErrorRetry => '다시 시도';

  @override
  String get aiErrorWaitAndCheck =>
      '저희가 나중에 다시 분석해 드릴게요. 곧 다시 오세요 — 기도가 기다리고 있을 거예요.';

  @override
  String get aiErrorHome => '홈으로';

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
  String get testimonyTitle => '나의 간증 · 기도 원문';

  @override
  String get testimonyHelperText => '내가 뭐라고 기도했는지 돌아보기 · 커뮤니티 공유에도 사용';

  @override
  String get myPrayerAudioLabel => '내 기도 녹음';

  @override
  String get testimonyEdit => '수정';

  @override
  String get guidanceTitle => 'AI 조언';

  @override
  String get aiPrayerTitle => '당신을 위한 기도';

  @override
  String get originalLangTitle => '원어의 깊은 뜻';

  @override
  String get proUnlock => 'Pro로 보기';

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
  String get proSection => '멤버십';

  @override
  String get freePlan => '무료';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '₩8,900 / 월';

  @override
  String get yearlyPrice => '₩65,000 / 년';

  @override
  String get yearlySave => '40% 절약';

  @override
  String get launchPromo => '3개월간 ₩5,900/월!';

  @override
  String get startPro => 'Pro 시작하기';

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
  String get proLimitTitle => '오늘의 기도를 마쳤습니다';

  @override
  String get proLimitBody => '내일 다시 만나요!\nPro로 무제한 기도하기';

  @override
  String get laterButton => '다음에 하기';

  @override
  String get proPromptTitle => 'Pro 기능이에요';

  @override
  String get proPromptBody => '이 기능은 Pro에서 사용할 수 있어요.\nPro 상품을 확인해보시겠어요?';

  @override
  String get viewProducts => '상품 보기';

  @override
  String get maybeLater => '다음에 할게요';

  @override
  String get proHeadline => '매일 하나님과 더 가까이';

  @override
  String get proBenefit1 => '무제한 기도 & QT';

  @override
  String get proBenefit2 => 'AI 맞춤 기도문 & 조언';

  @override
  String get proBenefit3 => '역사 속 믿음의 이야기';

  @override
  String get proBenefit5 => '원어 성경 해석';

  @override
  String get bestValue => 'BEST VALUE';

  @override
  String get perMonth => '월';

  @override
  String get cancelAnytime => '언제든 취소 가능';

  @override
  String get restorePurchase => '구독 복원';

  @override
  String get yearlyPriceMonthly => '₩5,417/월';

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
  String get proActive => '멤버십 활성';

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
  String get applicationTitle => '오늘의 적용';

  @override
  String get applicationWhat => '무엇을';

  @override
  String get applicationWhen => '언제';

  @override
  String get applicationContext => '어디서';

  @override
  String get applicationMorningLabel => '아침';

  @override
  String get applicationDayLabel => '낮';

  @override
  String get applicationEveningLabel => '저녁';

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
  String get scripturePostureLabel => '어떤 마음으로 읽을까요?';

  @override
  String get scriptureOriginalWordsTitle => '원어로 만나는 깊은 뜻';

  @override
  String get originalWordMeaningLabel => '의미';

  @override
  String get originalWordNuanceLabel => '번역과의 뉘앙스 차이';

  @override
  String originalWordsCountLabel(int count) {
    return '$count개 단어';
  }

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
  String get yearlySavings => '월 ₩3,483 (40% 할인)';

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

  @override
  String get manageSubscription => '구독 관리';

  @override
  String currentPlan(String plan) {
    return '현재 플랜: $plan';
  }

  @override
  String nextBillingDate(String date) {
    return '다음 결제일: $date';
  }

  @override
  String get upgradeToYearly => '연간으로 업그레이드 — 40% 절약';

  @override
  String get upgradeSuccess => '연간 구독으로 전환되었습니다 🌸';

  @override
  String get purchaseSuccess => '구독이 시작되었습니다 🌸';

  @override
  String get purchaseFailedNetwork => '네트워크 연결을 확인해 주세요';

  @override
  String get purchaseFailedGeneric => '문제가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get restoreInProgress => '구독을 복구하고 있습니다...';

  @override
  String get restoreSuccess => '구독이 복구되었습니다 ✅';

  @override
  String get restoreNothing => '복구할 구독이 없습니다';

  @override
  String get restoreTimeout => '시간이 초과되었습니다. 다시 시도해 주세요.';

  @override
  String get restoreFailed => '복구에 실패했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get subscriptionExpiredTitle => '구독이 만료되었습니다';

  @override
  String subscriptionExpiredBody(String date) {
    return '$date에 구독이 만료되었습니다. 재구독하고 Abba Pro를 이어가세요.';
  }

  @override
  String get billingIssueTitle => '결제 문제가 감지되었습니다';

  @override
  String billingIssueBody(int days) {
    return '$days일 안에 결제수단을 업데이트하지 않으면 Pro 혜택이 중단됩니다.';
  }

  @override
  String get billingIssueAction => '결제수단 업데이트';

  @override
  String accessUntil(String date) {
    return '이용 가능: $date까지';
  }

  @override
  String subscriptionCancelledNotice(String date) {
    return '구독이 취소되었습니다. $date까지 이용 가능합니다.';
  }

  @override
  String get qtLoadingHint1 => '💛 사랑 — 눈을 감고 10초간 사랑하는 사람을 떠올리세요';

  @override
  String get qtLoadingHint2 => '🌿 은혜 — 오늘 받은 작은 은혜를 하나 떠올려 보세요';

  @override
  String get qtLoadingHint3 => '🌅 소망 — 내일 바라는 작은 소망을 마음에 그려보세요';

  @override
  String get qtLoadingHint4 => '🕊️ 평안 — 깊게 숨을 세 번 들이쉬고 내쉬세요';

  @override
  String get qtLoadingHint5 => '🌳 믿음 — 변하지 않는 진리 하나를 떠올려 보세요';

  @override
  String get qtLoadingHint6 => '🌸 감사 — 지금 감사할 것 하나를 찾아보세요';

  @override
  String get qtLoadingHint7 => '🌊 용서 — 용서하고 싶은 사람을 떠올려 보세요';

  @override
  String get qtLoadingHint8 => '📖 지혜 — 오늘 배운 것 하나를 마음에 새겨 보세요';

  @override
  String get qtLoadingHint9 => '⏳ 인내 — 조용히 기다리고 있는 것을 떠올려 보세요';

  @override
  String get qtLoadingHint10 => '✨ 기쁨 — 오늘 미소 지었던 순간을 기억해 보세요';

  @override
  String get qtLoadingTitle => '오늘의 말씀을 준비하고 있어요...';

  @override
  String get coachingTitle => '기도 코칭';

  @override
  String get coachingLoadingText => '당신의 기도를 돌아보고 있어요...';

  @override
  String get coachingErrorText => '일시적인 오류 — 잠시 후 다시 시도해 주세요';

  @override
  String get coachingRetryButton => '다시 시도';

  @override
  String get coachingScoreSpecificity => '구체성';

  @override
  String get coachingScoreGodCentered => '하나님 중심성';

  @override
  String get coachingScoreActs => 'ACTS 균형';

  @override
  String get coachingScoreAuthenticity => '진정성';

  @override
  String get coachingStrengthsTitle => '잘하신 점 ✨';

  @override
  String get coachingImprovementsTitle => '더 깊어지려면 💡';

  @override
  String get coachingProCta => 'Pro로 기도 코칭 받기';

  @override
  String get coachingLevelBeginner => '🌱 시작하는 중';

  @override
  String get coachingLevelGrowing => '🌿 자라는 중';

  @override
  String get coachingLevelExpert => '🌳 전문가';

  @override
  String get aiPrayerCitationsTitle => '참고 · 인용';

  @override
  String get citationTypeQuote => '명언';

  @override
  String get citationTypeScience => '연구';

  @override
  String get citationTypeExample => '예시';

  @override
  String get citationTypeHistory => '역사';

  @override
  String get aiPrayerReadingTime => '2분 읽기';

  @override
  String get scriptureKeyWordHintTitle => '오늘의 핵심 단어';

  @override
  String get bibleLookupReferenceHint => '나의 성경으로 이 말씀을 찾아 묵상해 보세요.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => '사용된 성경 번역본';

  @override
  String get settingsBibleTranslationsIntro =>
      '이 앱의 성경 구절은 모두 저작권이 만료된 공공 도메인 번역본에서 가져옵니다. AI가 생성하는 주석·기도·이야기는 Abba의 창작물입니다.';

  @override
  String get meditationSummaryTitle => '오늘의 묵상';

  @override
  String get meditationTopicLabel => '주제';

  @override
  String get meditationSummaryLabel => '한 마디로';

  @override
  String get qtScriptureTitle => '오늘의 말씀';

  @override
  String get qtCoachingTitle => 'QT 코칭';

  @override
  String get qtCoachingLoadingText => '당신의 묵상을 돌아보고 있어요...';

  @override
  String get qtCoachingErrorText => '일시적인 오류 — 잠시 후 다시 시도해 주세요';

  @override
  String get qtCoachingRetryButton => '다시 시도';

  @override
  String get qtCoachingScoreComprehension => '본문 이해';

  @override
  String get qtCoachingScoreApplication => '개인 적용';

  @override
  String get qtCoachingScoreDepth => '영적 깊이';

  @override
  String get qtCoachingScoreAuthenticity => '진정성';

  @override
  String get qtCoachingStrengthsTitle => '잘하신 점 ✨';

  @override
  String get qtCoachingImprovementsTitle => '더 깊어지려면 💡';

  @override
  String get qtCoachingProCta => 'Pro로 QT 코칭 받기';

  @override
  String get qtCoachingLevelBeginner => '🌱 시작하는 중';

  @override
  String get qtCoachingLevelGrowing => '🌿 자라는 중';

  @override
  String get qtCoachingLevelExpert => '🌳 전문가';

  @override
  String get notifyMorning1Title => '🙏 기도할 시간이에요';

  @override
  String notifyMorning1Body(String name) {
    return '$name님, 오늘도 하나님과 대화해보세요';
  }

  @override
  String get notifyMorning2Title => '🌅 새 아침이 밝았어요';

  @override
  String notifyMorning2Body(String name) {
    return '$name님, 감사로 하루를 시작해보세요';
  }

  @override
  String get notifyMorning3Title => '✨ 오늘의 은혜';

  @override
  String notifyMorning3Body(String name) {
    return '$name님, 하나님이 준비하신 은혜를 만나보세요';
  }

  @override
  String get notifyMorning4Title => '🕊️ 평안한 아침';

  @override
  String notifyMorning4Body(String name) {
    return '$name님, 기도로 마음에 평안을 채워보세요';
  }

  @override
  String get notifyMorning5Title => '📖 말씀과 함께';

  @override
  String notifyMorning5Body(String name) {
    return '$name님, 오늘 하나님의 음성을 들어보세요';
  }

  @override
  String get notifyMorning6Title => '🌿 쉼의 시간';

  @override
  String notifyMorning6Body(String name) {
    return '$name님, 잠시 멈추고 기도해보세요';
  }

  @override
  String get notifyMorning7Title => '💫 오늘 하루도';

  @override
  String notifyMorning7Body(String name) {
    return '$name님, 기도로 시작하는 하루가 달라요';
  }

  @override
  String get notifyEvening1Title => '✨ 오늘 하루 감사';

  @override
  String get notifyEvening1Body => '오늘 하루를 돌아보며 감사 기도를 드려보세요';

  @override
  String get notifyEvening2Title => '🌙 하루를 마무리하며';

  @override
  String get notifyEvening2Body => '오늘의 감사를 기도로 표현해보세요';

  @override
  String get notifyEvening3Title => '🙏 저녁 기도';

  @override
  String get notifyEvening3Body => '하루의 끝, 하나님께 감사를 올려드려요';

  @override
  String get notifyEvening4Title => '🌟 오늘의 은혜를 세며';

  @override
  String get notifyEvening4Body => '감사할 것이 있다면 기도로 나눠보세요';

  @override
  String get notifyStreak3Title => '🌱 3일 연속!';

  @override
  String get notifyStreak3Body => '기도 습관이 시작됐어요';

  @override
  String get notifyStreak7Title => '🌿 일주일 연속!';

  @override
  String get notifyStreak7Body => '기도가 습관이 되고 있어요';

  @override
  String get notifyStreak14Title => '🌳 2주 연속!';

  @override
  String get notifyStreak14Body => '놀라운 성장이에요';

  @override
  String get notifyStreak21Title => '🌻 3주 연속!';

  @override
  String get notifyStreak21Body => '기도의 꽃이 피고 있어요';

  @override
  String get notifyStreak30Title => '🏆 한 달 연속!';

  @override
  String get notifyStreak30Body => '당신의 기도가 빛나고 있어요';

  @override
  String get notifyStreak50Title => '👑 50일 연속!';

  @override
  String get notifyStreak50Body => '하나님과의 동행이 깊어지고 있어요';

  @override
  String get notifyStreak100Title => '🎉 100일 연속!';

  @override
  String get notifyStreak100Body => '기도의 전사가 되었어요!';

  @override
  String get notifyStreak365Title => '✝️ 1년 연속!';

  @override
  String get notifyStreak365Body => '놀라운 믿음의 여정이에요!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ 오늘 기도는 하셨나요?';

  @override
  String get notifyAfternoonNudgeBody => '잠깐의 기도가 하루를 바꿔요';

  @override
  String get notifyChannelName => '기도 알림';

  @override
  String get notifyChannelDescription => '아침 기도, 저녁 감사 등 기도 알림';

  @override
  String get milestoneFirstPrayerTitle => '첫 기도를 올렸습니다!';

  @override
  String get milestoneFirstPrayerDesc => '기도 여정이 시작되었습니다. 하나님이 듣고 계십니다.';

  @override
  String get milestoneSevenDayStreakTitle => '7일 연속 기도!';

  @override
  String get milestoneSevenDayStreakDesc => '한 주간 신실한 기도. 당신의 정원이 자라고 있습니다!';

  @override
  String get milestoneThirtyDayStreakTitle => '30일 연속!';

  @override
  String get milestoneThirtyDayStreakDesc => '당신의 정원이 꽃밭이 되었습니다!';

  @override
  String get milestoneHundredPrayersTitle => '100번째 기도!';

  @override
  String get milestoneHundredPrayersDesc => '하나님과의 백 번째 대화. 깊이 뿌리내렸습니다.';

  @override
  String get homeFirstPrayerPrompt => '첫 기도를 시작해보세요';

  @override
  String get homeFirstQtPrompt => '첫 QT를 시작해보세요';

  @override
  String homeActivityPrompt(String activityName) {
    return '오늘도 $activityName해보세요';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return '$count일째 연속 $activityName 중';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return '$days일째 $activityName을 쉬고 있어요';
  }

  @override
  String get homeActivityPrayer => '기도';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => '로딩 중...';

  @override
  String get heatmapNoPrayer => '기도 없음';

  @override
  String get heatmapLegendLess => '적음';

  @override
  String get heatmapLegendMore => '많음';

  @override
  String get qtPassagesLoadError => '오늘의 말씀을 불러올 수 없어요. 연결을 확인해주세요.';

  @override
  String get qtPassagesRetryButton => '다시 시도';

  @override
  String get aiStreamingInitial => '당신의 기도를 묵상하고 있어요...';

  @override
  String get aiTierProcessing => '더 많은 이야기가 준비되고 있어요...';

  @override
  String get aiScriptureValidating => '오늘의 말씀을 찾고 있어요...';

  @override
  String get aiScriptureValidatingFailed => '이 말씀은 잠시 후 준비됩니다...';

  @override
  String get aiTemplateFallback => '분석이 완성되는 동안 잠시 묵상해보세요...';

  @override
  String get aiPendingMore => '준비 중...';

  @override
  String get aiTierIncomplete => '곧 완성돼요, 잠시 후 다시 확인해주세요';

  @override
  String get tierCompleted => '새로운 이야기가 도착했어요';

  @override
  String get tierProcessingNotice => '더 많은 이야기를 만들고 있어요...';

  @override
  String get proSectionLoading => '프리미엄 콘텐츠를 준비 중이에요...';

  @override
  String get proSectionWillArrive => '깊은 묵상이 곧 나타날 거예요';

  @override
  String get templateCategoryHealth => '건강을 위한 묵상';

  @override
  String get templateCategoryFamily => '가족을 위한 묵상';

  @override
  String get templateCategoryWork => '일과 공부를 위한 묵상';

  @override
  String get templateCategoryGratitude => '감사의 마음';

  @override
  String get templateCategoryGrief => '슬픔과 상실 중에';

  @override
  String get sectionStatusCompleted => '분석 완료';

  @override
  String get sectionStatusPartial => '부분 완성 (계속 진행 중)';

  @override
  String get sectionStatusPending => '분석 진행 중';
}
