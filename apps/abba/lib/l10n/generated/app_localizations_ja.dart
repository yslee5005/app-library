// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'アバ';

  @override
  String get welcomeTitle => '祈れば、\n神が応えてくださいます。';

  @override
  String get welcomeSubtitle => '毎日の祈りとデボーションのAIコンパニオン';

  @override
  String get getStarted => '始める';

  @override
  String get loginTitle => 'アバへようこそ';

  @override
  String get loginSubtitle => 'サインインして祈りの旅を始めましょう';

  @override
  String get signInWithApple => 'Appleで続ける';

  @override
  String get signInWithGoogle => 'Googleで続ける';

  @override
  String get signInWithEmail => 'メールで続ける';

  @override
  String greetingMorning(Object name) {
    return 'おはようございます、$nameさん';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'こんにちは、$nameさん';
  }

  @override
  String greetingEvening(Object name) {
    return 'こんばんは、$nameさん';
  }

  @override
  String get prayButton => '祈る';

  @override
  String get qtButton => 'デボーション';

  @override
  String streakDays(Object count) {
    return '$count日連続の祈り';
  }

  @override
  String get dailyVerse => '今日のみことば';

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabCalendar => 'カレンダー';

  @override
  String get tabCommunity => 'コミュニティ';

  @override
  String get tabSettings => '設定';

  @override
  String get recordingTitle => '祈り中...';

  @override
  String get recordingPause => '一時停止';

  @override
  String get recordingResume => '再開';

  @override
  String get finishPrayer => '祈りを終える';

  @override
  String get switchToText => 'テキストに切替';

  @override
  String get textInputHint => '祈りを入力してください...';

  @override
  String get aiLoadingText => 'あなたの祈りを黙想しています...';

  @override
  String get aiLoadingVerse => '静まりて、わたしこそ神であることを知れ。\n— 詩篇 46:10';

  @override
  String get dashboardTitle => '祈りの庭';

  @override
  String get shareButton => '共有';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String get scriptureTitle => '今日のみことば';

  @override
  String get bibleStoryTitle => '聖書の物語';

  @override
  String get testimonyTitle => '私の証し';

  @override
  String get testimonyEdit => '編集';

  @override
  String get guidanceTitle => 'AIガイダンス';

  @override
  String get aiPrayerTitle => 'あなたのための祈り';

  @override
  String get originalLangTitle => '原語の深い意味';

  @override
  String get premiumUnlock => 'Premiumで見る';

  @override
  String get qtPageTitle => '朝の庭';

  @override
  String get qtMeditateButton => '黙想を始める';

  @override
  String get qtCompleted => '完了';

  @override
  String get communityTitle => '祈りの庭';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterTestimony => '証し';

  @override
  String get filterPrayerRequest => '祈りの依頼';

  @override
  String get likeButton => 'いいね';

  @override
  String get commentButton => 'コメント';

  @override
  String get saveButton => '保存';

  @override
  String get replyButton => '返信';

  @override
  String get writePostTitle => '分かち合い';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get sharePostButton => '共有する';

  @override
  String get anonymousToggle => '匿名';

  @override
  String get realNameToggle => '実名';

  @override
  String get categoryTestimony => '証し';

  @override
  String get categoryPrayerRequest => '祈りの依頼';

  @override
  String get writePostHint => '証しや祈りの依頼を分かち合いましょう...';

  @override
  String get importFromPrayer => '祈りから取得';

  @override
  String get calendarTitle => '祈りカレンダー';

  @override
  String get currentStreak => '現在の連続';

  @override
  String get bestStreak => '最高記録';

  @override
  String get days => '日';

  @override
  String get settingsTitle => '設定';

  @override
  String get profileSection => 'プロフィール';

  @override
  String get totalPrayers => '祈りの合計';

  @override
  String get consecutiveDays => '連続日数';

  @override
  String get premiumSection => 'プレミアム';

  @override
  String get freePlan => '無料';

  @override
  String get premiumPlan => 'プレミアム';

  @override
  String get monthlyPrice => '¥980/月';

  @override
  String get yearlyPrice => '¥6,800/年';

  @override
  String get yearlySave => '40%お得';

  @override
  String get launchPromo => '3ヶ月間¥580/月!';

  @override
  String get startPremium => 'Premium開始';

  @override
  String get comingSoon => '近日公開';

  @override
  String get notificationSetting => '通知';

  @override
  String get aiVoiceSetting => 'AIの声';

  @override
  String get voiceWarm => '温かい';

  @override
  String get voiceCalm => '穏やか';

  @override
  String get voiceStrong => '力強い';

  @override
  String get languageSetting => '言語';

  @override
  String get darkModeSetting => 'ダークモード';

  @override
  String get helpCenter => 'ヘルプセンター';

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get logout => 'ログアウト';

  @override
  String appVersion(Object version) {
    return 'バージョン $version';
  }

  @override
  String get anonymous => '匿名';

  @override
  String timeAgo(Object time) {
    return '$time前';
  }

  @override
  String get emailLabel => 'メール';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get signIn => 'サインイン';

  @override
  String get cancel => 'キャンセル';

  @override
  String get noPrayersRecorded => '祈りの記録がありません';

  @override
  String get deletePost => '削除';

  @override
  String get reportPost => '報告';

  @override
  String get reportSubmitted => '報告が送信されました。ありがとうございます。';

  @override
  String get deleteConfirmTitle => '投稿を削除';

  @override
  String get deleteConfirmMessage => 'この投稿を削除しますか？';

  @override
  String get errorNetwork => 'インターネット接続を確認してもう一度お試しください。';

  @override
  String get errorAiFallback => 'AIに接続できませんでした。みことばをお届けします。';

  @override
  String get errorSttFailed => '音声認識が利用できません。テキストで入力してください。';

  @override
  String get errorPayment => '支払いに問題がありました。設定でもう一度お試しください。';

  @override
  String get errorGeneric => '問題が発生しました。しばらくしてからもう一度お試しください。';

  @override
  String get offlineNotice => 'オフラインです。一部の機能が制限されます。';

  @override
  String get retryButton => '再試行';

  @override
  String get groupSection => 'マイグループ';

  @override
  String get createGroup => '祈りグループを作る';

  @override
  String get inviteFriends => '友達を招待';

  @override
  String get groupInviteMessage => '一緒に祈りましょう！Abbaの祈りグループに参加してください。';

  @override
  String get noGroups => 'グループに参加または作成して一緒に祈りましょう。';

  @override
  String get promoTitle => '特別キャンペーン';

  @override
  String get promoBanner => '3ヶ月間¥580/月!';

  @override
  String promoEndsOn(Object date) {
    return '$dateまで特別価格';
  }
}
