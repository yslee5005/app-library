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
  String get premiumUnlock => 'Premium으로 보기';

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
  String get settingsTitle => '설정';

  @override
  String get profileSection => '프로필';

  @override
  String get totalPrayers => '총 기도 횟수';

  @override
  String get consecutiveDays => '연속 기도일';

  @override
  String get premiumSection => '프리미엄';

  @override
  String get freePlan => '무료';

  @override
  String get premiumPlan => '프리미엄';

  @override
  String get monthlyPrice => '₩9,900/월';

  @override
  String get yearlyPrice => '₩69,000/년';

  @override
  String get yearlySave => '40% 절약';

  @override
  String get launchPromo => '3개월간 ₩5,900/월!';

  @override
  String get startPremium => 'Premium 시작하기';

  @override
  String get comingSoon => '곧 출시됩니다';

  @override
  String get notificationSetting => '알림';

  @override
  String get aiVoiceSetting => 'AI 목소리';

  @override
  String get voiceWarm => '따뜻한';

  @override
  String get voiceCalm => '차분한';

  @override
  String get voiceStrong => '힘있는';

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
}
