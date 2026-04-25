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
  String get finishPrayerConfirm => '祈りを終えますか？';

  @override
  String get switchToText => 'テキストに切替';

  @override
  String get textInputHint => '祈りを入力してください...';

  @override
  String get aiLoadingText => 'あなたの祈りを黙想しています...';

  @override
  String get aiLoadingVerse => '静まりて、わたしこそ神であることを知れ。\n— 詩篇 46:10';

  @override
  String get aiErrorNetworkTitle => '接続が不安定です';

  @override
  String get aiErrorNetworkBody => 'お祈りは安全に保存されました。少し経ってからもう一度お試しください。';

  @override
  String get aiErrorApiTitle => 'AIサービスが不安定です';

  @override
  String get aiErrorApiBody => 'お祈りは安全に保存されました。少し経ってからもう一度お試しください。';

  @override
  String get aiErrorRetry => 'もう一度';

  @override
  String get aiErrorWaitAndCheck => '後ほど改めて分析いたします。またすぐお越しください — お祈りがお待ちしています。';

  @override
  String get aiErrorHome => 'ホームに戻る';

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
  String get testimonyTitle => '証し · 私の祈り';

  @override
  String get testimonyHelperText => '祈った内容を振り返る · コミュニティ共有にも使用';

  @override
  String get myPrayerAudioLabel => '私の祈りの録音';

  @override
  String get testimonyEdit => '編集';

  @override
  String get guidanceTitle => 'AIガイダンス';

  @override
  String get aiPrayerTitle => 'あなたのための祈り';

  @override
  String get originalLangTitle => '原語の深い意味';

  @override
  String get proUnlock => 'Proで見る';

  @override
  String get proPreviewHistoricalHint => 'あなたの祈りに込められた一つの言葉、その深い歴史をお届けします';

  @override
  String get proPreviewPrayerHint => 'あなたのための深い祈りの言葉が用意されています';

  @override
  String get proPreviewCoachingHint => '次の祈りをより深くする一つのアドバイスがあります';

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
  String calendarRecordCount(Object count) {
    return '$count件の記録';
  }

  @override
  String get todayVerse => '今日のみことば';

  @override
  String get settingsTitle => '設定';

  @override
  String get profileSection => 'プロフィール';

  @override
  String get totalPrayers => '祈りの合計';

  @override
  String get consecutiveDays => '連続日数';

  @override
  String get proSection => 'メンバーシップ';

  @override
  String get freePlan => '無料';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '¥1,200 / 月';

  @override
  String get yearlyPrice => '¥9,800 / 年';

  @override
  String get yearlySave => '40%お得';

  @override
  String get launchPromo => '';

  @override
  String get startPro => 'Pro開始';

  @override
  String get comingSoon => '近日公開';

  @override
  String get notificationSetting => '通知';

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
  String get reportReasonHint => '報告の理由を記入してください。メールで送信されます。';

  @override
  String get reportReasonPlaceholder => '報告の理由を入力してください...';

  @override
  String get reportSubmitButton => '報告する';

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
  String get promoBanner => '';

  @override
  String promoEndsOn(Object date) {
    return '$dateまで特別価格';
  }

  @override
  String get proLimitTitle => '今日の祈りが完了しました';

  @override
  String get proLimitBody => 'また明日お会いしましょう！\nProで無制限に祈りましょう';

  @override
  String get laterButton => '後で';

  @override
  String get proPromptTitle => 'Pro機能です';

  @override
  String get proPromptBody => 'この機能はProでご利用いただけます。\nプランを確認しますか？';

  @override
  String get viewProducts => 'プランを見る';

  @override
  String get maybeLater => 'また今度';

  @override
  String get proHeadline => '毎日、神様とより近く';

  @override
  String get proBenefit1 => '無制限の祈り & QT';

  @override
  String get proBenefit2 => 'AI祈りと導き';

  @override
  String get proBenefit3 => '歴史の中の信仰物語';

  @override
  String get proBenefit5 => '原語聖書解釈';

  @override
  String get bestValue => 'お得';

  @override
  String get perMonth => '月';

  @override
  String get cancelAnytime => 'いつでもキャンセル可能';

  @override
  String get restorePurchase => '購入を復元';

  @override
  String get yearlyPriceMonthly => '¥817/月';

  @override
  String get morningPrayerReminder => '朝の祈り';

  @override
  String get eveningGratitudeReminder => '夕方の感謝';

  @override
  String get streakReminder => '連続記録リマインダー';

  @override
  String get afternoonNudgeReminder => '午後の祈りリマインダー';

  @override
  String get weeklySummaryReminder => '週間まとめ';

  @override
  String get unlimited => '無制限';

  @override
  String get streakRecovery => '大丈夫、また始めましょう 🌱';

  @override
  String get prayerSaved => '祈りが保存されました';

  @override
  String get quietTimeLabel => 'QT';

  @override
  String get morningPrayerLabel => '朝の祈り';

  @override
  String get gardenSeed => '信仰の種';

  @override
  String get gardenSprout => '育つ芽';

  @override
  String get gardenBud => 'つぼみ';

  @override
  String get gardenBloom => '満開の花';

  @override
  String get gardenTree => '大きな木';

  @override
  String get gardenForest => '祈りの森';

  @override
  String get milestoneShare => '共有する';

  @override
  String get milestoneThankGod => '神に感謝!';

  @override
  String shareStreakText(Object count) {
    return '$count日連続の祈り！Abbaとの祈りの旅 #Abba #祈り';
  }

  @override
  String get shareDaysLabel => '日連続の祈り';

  @override
  String get shareSubtitle => '神と共にある毎日の祈り';

  @override
  String get proActive => 'メンバーシップ有効';

  @override
  String get planOncePerDay => '1日1回';

  @override
  String get planUnlimited => '無制限';

  @override
  String get closeRecording => '録音を閉じる';

  @override
  String get qtRevealMessage => '今日のみ言葉を開いてみましょう';

  @override
  String get qtSelectPrompt => '一つを選んで今日のQTを始めましょう 🌿';

  @override
  String get qtTopicLabel => 'テーマ';

  @override
  String get prayerStartPrompt => 'お祈りを始めましょう';

  @override
  String get startPrayerButton => 'お祈り開始';

  @override
  String get switchToTextMode => 'テキストに切替';

  @override
  String get switchToVoiceMode => '音声に切替';

  @override
  String get prayerDashboardTitle => '祈りの庭';

  @override
  String get qtDashboardTitle => 'QTの庭';

  @override
  String get prayerSummaryTitle => '祈りの要約';

  @override
  String get gratitudeLabel => '感謝';

  @override
  String get petitionLabel => '願い';

  @override
  String get intercessionLabel => 'とりなし';

  @override
  String get historicalStoryTitle => '歴史の物語';

  @override
  String get todayLesson => '今日の教訓';

  @override
  String get applicationTitle => '今日の適用';

  @override
  String get applicationWhat => '何を';

  @override
  String get applicationWhen => 'いつ';

  @override
  String get applicationContext => 'どこで';

  @override
  String get applicationMorningLabel => '朝';

  @override
  String get applicationDayLabel => '昼';

  @override
  String get applicationEveningLabel => '夜';

  @override
  String get relatedKnowledgeTitle => '関連知識';

  @override
  String get originalWordLabel => '原語';

  @override
  String get historicalContextLabel => '歴史的背景';

  @override
  String get crossReferencesLabel => '関連聖句';

  @override
  String get growthStoryTitle => '霊的成長の物語';

  @override
  String get prayerGuideTitle => 'このようにお祈りしてください';

  @override
  String get prayerGuide1 => '声に出してお祈りしてください';

  @override
  String get prayerGuide2 => 'アバがお祈りを聞いて心に響く聖句を見つけます';

  @override
  String get prayerGuide3 => 'テキストで入力しても大丈夫です';

  @override
  String get qtGuideTitle => 'このように黙想してください';

  @override
  String get qtGuide1 => 'み言葉を読んで静かに黙想してください';

  @override
  String get qtGuide2 => '気づいたことを声に出すか書いてください';

  @override
  String get qtGuide3 => 'アバがみ言葉を生活に適用できるようお手伝いします';

  @override
  String get scriptureReasonLabel => 'このみ言葉を選んだ理由';

  @override
  String get scripturePostureLabel => 'どんな心で読みましょうか?';

  @override
  String get scriptureOriginalWordsTitle => '原語で出会う深い意味';

  @override
  String get originalWordMeaningLabel => '意味';

  @override
  String get originalWordNuanceLabel => '翻訳とのニュアンスの違い';

  @override
  String originalWordsCountLabel(int count) {
    return '$count語';
  }

  @override
  String get seeMore => 'もっと見る';

  @override
  String get seeLess => '閉じる';

  @override
  String seeAllComments(Object count) {
    return 'コメント$count件すべて見る';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$nameと他$count人がいいねしました';
  }

  @override
  String get commentsTitle => 'コメント';

  @override
  String get myPageTitle => '祈りの庭';

  @override
  String get myPrayers => '私の祈り';

  @override
  String get myTestimonies => '私の証し';

  @override
  String get savedPosts => '保存済み';

  @override
  String get totalPrayersCount => '祈り';

  @override
  String get streakCount => '連続';

  @override
  String get testimoniesCount => '証し';

  @override
  String get linkAccountTitle => 'アカウント連携';

  @override
  String get linkAccountDescription => 'アカウントを連携すると、デバイスを変えても祈りの記録が保持されます';

  @override
  String get linkWithApple => 'Appleで連携';

  @override
  String get linkWithGoogle => 'Googleで連携';

  @override
  String get linkAccountSuccess => 'アカウントが連携されました！';

  @override
  String get anonymousUser => '祈りの人';

  @override
  String showReplies(Object count) {
    return '返信$count件を見る';
  }

  @override
  String get hideReplies => '返信を隠す';

  @override
  String replyingTo(Object name) {
    return '$nameに返信中';
  }

  @override
  String viewAllComments(Object count) {
    return 'コメント$count件すべて見る';
  }

  @override
  String get membershipTitle => 'メンバーシップ';

  @override
  String get membershipSubtitle => '祈りをもっと深く';

  @override
  String get monthlyPlan => '月額';

  @override
  String get yearlyPlan => '年額';

  @override
  String get yearlySavings => '月¥383 (40%お得)';

  @override
  String get startMembership => '始める';

  @override
  String get membershipActive => 'メンバーシップ有効';

  @override
  String get leaveRecordingTitle => '録音を中断しますか？';

  @override
  String get leaveRecordingMessage => '録音内容が失われます。本当に退出しますか？';

  @override
  String get leaveButton => '退出する';

  @override
  String get stayButton => '留まる';

  @override
  String likedByCount(Object count) {
    return '$count人が共感しました';
  }

  @override
  String get actionLike => '共感';

  @override
  String get actionComment => 'コメント';

  @override
  String get actionSave => '保存';

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
  String get billingIssueTitle => 'お支払いの問題が検出されました';

  @override
  String billingIssueBody(int days) {
    return '$days日以内にお支払い方法を更新しないとProの特典が終了します。';
  }

  @override
  String get billingIssueAction => 'お支払い方法を更新';

  @override
  String accessUntil(String date) {
    return 'Access until: $date';
  }

  @override
  String subscriptionCancelledNotice(String date) {
    return 'Your subscription has been cancelled. You\'ll have access until $date.';
  }

  @override
  String get qtLoadingHint1 => '💛 愛 — 10秒間、愛する人を思い浮かべてください';

  @override
  String get qtLoadingHint2 => '🌿 恵み — 今日受けた小さな恵みを一つ思い出してください';

  @override
  String get qtLoadingHint3 => '🌅 希望 — 明日への小さな希望を心に描いてください';

  @override
  String get qtLoadingHint4 => '🕊️ 平安 — ゆっくり三回、深く息をしてください';

  @override
  String get qtLoadingHint5 => '🌳 信仰 — 変わらない真理を一つ思い出してください';

  @override
  String get qtLoadingHint6 => '🌸 感謝 — 今、感謝できることを一つ見つけてください';

  @override
  String get qtLoadingHint7 => '🌊 赦し — 赦したい人を心に思い浮かべてください';

  @override
  String get qtLoadingHint8 => '📖 知恵 — 今日学んだ一つの教えを心に留めてください';

  @override
  String get qtLoadingHint9 => '⏳ 忍耐 — 静かに待っているものを思い浮かべてください';

  @override
  String get qtLoadingHint10 => '✨ 喜び — 今日微笑んだ瞬間を思い出してください';

  @override
  String get qtLoadingTitle => '今日のみ言葉を準備しています...';

  @override
  String get coachingTitle => '祈りコーチング';

  @override
  String get coachingLoadingText => 'あなたの祈りを振り返っています...';

  @override
  String get coachingErrorText => '一時的なエラーです — しばらくしてから再試行してください';

  @override
  String get coachingRetryButton => '再試行';

  @override
  String get coachingScoreSpecificity => '具体性';

  @override
  String get coachingScoreGodCentered => '神中心';

  @override
  String get coachingScoreActs => 'ACTS バランス';

  @override
  String get coachingScoreAuthenticity => '真実性';

  @override
  String get coachingStrengthsTitle => 'よくできた点 ✨';

  @override
  String get coachingImprovementsTitle => 'さらに深めるために 💡';

  @override
  String get coachingProCta => 'Pro で祈りコーチングを解放';

  @override
  String get coachingLevelBeginner => '🌱 初心者';

  @override
  String get coachingLevelGrowing => '🌿 成長中';

  @override
  String get coachingLevelExpert => '🌳 熟達者';

  @override
  String get aiPrayerCitationsTitle => '参照 · 引用';

  @override
  String get citationTypeQuote => '名言';

  @override
  String get citationTypeScience => '研究';

  @override
  String get citationTypeExample => '例';

  @override
  String get citationTypeHistory => '歴史';

  @override
  String get aiPrayerReadingTime => '2分で読める';

  @override
  String get scriptureKeyWordHintTitle => '今日のキーワード';

  @override
  String get bibleLookupReferenceHint => 'ご自分の聖書でこの箇所を見つけて黙想してください。';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => '聖書翻訳一覧';

  @override
  String get settingsBibleTranslationsIntro =>
      'このアプリの聖書の言葉はすべて著作権が切れたパブリックドメインの翻訳を使用しています。AIが生成する注釈・祈り・物語はAbbaの創作物です。';

  @override
  String get meditationSummaryTitle => '今日の黙想';

  @override
  String get meditationTopicLabel => '主題';

  @override
  String get meditationSummaryLabel => '一言で';

  @override
  String get qtScriptureTitle => '今日のみことば';

  @override
  String get qtCoachingTitle => 'QT コーチング';

  @override
  String get qtCoachingLoadingText => 'あなたの黙想を振り返っています...';

  @override
  String get qtCoachingErrorText => '一時的なエラーです — しばらくしてから再試行してください';

  @override
  String get qtCoachingRetryButton => '再試行';

  @override
  String get qtCoachingScoreComprehension => '本文の理解';

  @override
  String get qtCoachingScoreApplication => '個人的な適用';

  @override
  String get qtCoachingScoreDepth => '霊的な深さ';

  @override
  String get qtCoachingScoreAuthenticity => '真実性';

  @override
  String get qtCoachingStrengthsTitle => 'よくできた点 ✨';

  @override
  String get qtCoachingImprovementsTitle => 'さらに深めるために 💡';

  @override
  String get qtCoachingProCta => 'Pro で QT コーチングを解放';

  @override
  String get qtCoachingLevelBeginner => '🌱 初心者';

  @override
  String get qtCoachingLevelGrowing => '🌿 成長中';

  @override
  String get qtCoachingLevelExpert => '🌳 熟達者';

  @override
  String get notifyMorning1Title => '🙏 祈りの時間です';

  @override
  String notifyMorning1Body(String name) {
    return '$nameさん、今日も神様と対話してみましょう';
  }

  @override
  String get notifyMorning2Title => '🌅 新しい朝が来ました';

  @override
  String notifyMorning2Body(String name) {
    return '$nameさん、感謝で一日を始めましょう';
  }

  @override
  String get notifyMorning3Title => '✨ 今日の恵み';

  @override
  String notifyMorning3Body(String name) {
    return '$nameさん、神様が用意された恵みに出会いましょう';
  }

  @override
  String get notifyMorning4Title => '🕊️ 平安な朝';

  @override
  String notifyMorning4Body(String name) {
    return '$nameさん、祈りで心に平安を満たしましょう';
  }

  @override
  String get notifyMorning5Title => '📖 み言葉とともに';

  @override
  String notifyMorning5Body(String name) {
    return '$nameさん、今日神様の声を聞いてみましょう';
  }

  @override
  String get notifyMorning6Title => '🌿 休みの時間';

  @override
  String notifyMorning6Body(String name) {
    return '$nameさん、少し立ち止まって祈ってみましょう';
  }

  @override
  String get notifyMorning7Title => '💫 今日という日も';

  @override
  String notifyMorning7Body(String name) {
    return '$nameさん、祈りで始まる一日は違います';
  }

  @override
  String get notifyEvening1Title => '✨ 今日一日に感謝';

  @override
  String get notifyEvening1Body => '今日一日を振り返り感謝の祈りをささげましょう';

  @override
  String get notifyEvening2Title => '🌙 一日を締めくくりながら';

  @override
  String get notifyEvening2Body => '今日の感謝を祈りで表してみましょう';

  @override
  String get notifyEvening3Title => '🙏 夕べの祈り';

  @override
  String get notifyEvening3Body => '一日の終わりに神様に感謝をささげましょう';

  @override
  String get notifyEvening4Title => '🌟 今日の恵みを数えながら';

  @override
  String get notifyEvening4Body => '感謝したいことがあれば祈りで分かち合いましょう';

  @override
  String get notifyStreak3Title => '🌱 3日連続!';

  @override
  String get notifyStreak3Body => '祈りの習慣が始まりました';

  @override
  String get notifyStreak7Title => '🌿 一週間連続!';

  @override
  String get notifyStreak7Body => '祈りが習慣になっています';

  @override
  String get notifyStreak14Title => '🌳 2週間連続!';

  @override
  String get notifyStreak14Body => '素晴らしい成長です';

  @override
  String get notifyStreak21Title => '🌻 3週間連続!';

  @override
  String get notifyStreak21Body => '祈りの花が咲いています';

  @override
  String get notifyStreak30Title => '🏆 1か月連続!';

  @override
  String get notifyStreak30Body => 'あなたの祈りが輝いています';

  @override
  String get notifyStreak50Title => '👑 50日連続!';

  @override
  String get notifyStreak50Body => '神様との歩みが深まっています';

  @override
  String get notifyStreak100Title => '🎉 100日連続!';

  @override
  String get notifyStreak100Body => '祈りの戦士となりました!';

  @override
  String get notifyStreak365Title => '✝️ 1年連続!';

  @override
  String get notifyStreak365Body => '驚くべき信仰の旅路です!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ 今日はもう祈りましたか?';

  @override
  String get notifyAfternoonNudgeBody => 'ほんの少しの祈りが一日を変えます';

  @override
  String get notifyChannelName => '祈りのリマインダー';

  @override
  String get notifyChannelDescription => '朝の祈り、夕べの感謝などの祈りのリマインダー';

  @override
  String get milestoneFirstPrayerTitle => '初めての祈り!';

  @override
  String get milestoneFirstPrayerDesc => 'あなたの祈りの旅が始まりました。神様が聞いておられます。';

  @override
  String get milestoneSevenDayStreakTitle => '7日連続の祈り!';

  @override
  String get milestoneSevenDayStreakDesc => '一週間の忠実な祈り。あなたの庭は育っています!';

  @override
  String get milestoneThirtyDayStreakTitle => '30日連続!';

  @override
  String get milestoneThirtyDayStreakDesc => 'あなたの庭が花畑になりました!';

  @override
  String get milestoneHundredPrayersTitle => '100回目の祈り!';

  @override
  String get milestoneHundredPrayersDesc => '神様との100回の対話。深く根を下ろしました。';

  @override
  String get homeFirstPrayerPrompt => '最初の祈りを始めましょう';

  @override
  String get homeFirstQtPrompt => '最初のQTを始めましょう';

  @override
  String homeActivityPrompt(String activityName) {
    return '今日も$activityNameしてみましょう';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return '$count日連続$activityName中';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return '$days日間$activityNameを休んでいます';
  }

  @override
  String get homeActivityPrayer => '祈り';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => '読み込み中...';

  @override
  String get heatmapNoPrayer => '祈りなし';

  @override
  String get heatmapLegendLess => '少ない';

  @override
  String get heatmapLegendMore => '多い';

  @override
  String get qtPassagesLoadError => '今日の御言葉を読み込めませんでした。接続をご確認ください。';

  @override
  String get qtPassagesRetryButton => '再試行';

  @override
  String get aiStreamingInitial => 'あなたのお祈りに静かに耳を傾けています...';

  @override
  String get aiTierProcessing => 'ほかのお話も、まもなく届きます...';

  @override
  String get aiScriptureValidating => 'あなたにふさわしいみことばを探しています...';

  @override
  String get aiScriptureValidatingFailed => 'このみことばを、少しずつ準備しています...';

  @override
  String get aiTemplateFallback => '分析が整うまで、ひとときお供します...';

  @override
  String get aiPendingMore => '準備中...';

  @override
  String get aiTierIncomplete => 'もうすぐ届きます。後ほどご確認ください';

  @override
  String get tierCompleted => '新しいお話が届きました';

  @override
  String get tierProcessingNotice => 'さらなるお話をお届けしています...';

  @override
  String get proSectionLoading => 'プレミアムコンテンツを準備中です...';

  @override
  String get proSectionWillArrive => '深いお話がここに届きます';

  @override
  String get templateCategoryHealth => '健康のための祈り';

  @override
  String get templateCategoryFamily => '家族のための祈り';

  @override
  String get templateCategoryWork => '仕事と学びのための祈り';

  @override
  String get templateCategoryGratitude => '感謝の心';

  @override
  String get templateCategoryGrief => '大切な方を失ったとき';

  @override
  String get sectionStatusCompleted => '分析完了';

  @override
  String get sectionStatusPartial => '部分的な分析(続きが届きます)';

  @override
  String get sectionStatusPending => '分析中';

  @override
  String get trialStartCta => '1ヶ月間無料で開始';

  @override
  String trialAutoRenewDisclosure(Object price) {
    return 'その後、年 $price で自動更新されます。設定からいつでもキャンセルできます。';
  }

  @override
  String get trialLimitTitle => '今日は3回お祈りされました 🌸';

  @override
  String get trialLimitBody => 'また明日お会いしましょう — もしくは Pro で無制限に祈りを。';

  @override
  String get trialLimitCta => 'Pro で続ける';

  @override
  String get prayerTooShort => 'もう少し書いてください';

  @override
  String get switchToTextModeTitle => 'テキストモードに切り替えますか?';

  @override
  String get switchToTextModeBody =>
      'これまで録音した音声の祈りは破棄されます。代わりにテキストで祈りを書く必要があります。';

  @override
  String get switchToTextModeConfirm => 'テキストに切り替え';

  @override
  String get switchToTextModeCancel => '録音を続ける';

  @override
  String get recordingInterruptedTitle => '祈りの録音が中断されました';

  @override
  String get recordingInterruptedBody => '離れている間に録音が停止しました。どうしますか?';

  @override
  String get recordingInterruptedRestart => '録音を再開';

  @override
  String get recordingInterruptedSwitchToText => 'テキストで書く';

  @override
  String get dashboardPartialFailedQt => '一部の黙想内容を読み込めませんでした。新しい黙想を始めてください。';

  @override
  String get dashboardPartialFailedPrayer =>
      '一部の祈りの分析を読み込めませんでした。新しい祈りを始めてください。';

  @override
  String get dashboardPartialFailedHint => '保存済みの内容はそのまま保管されます。';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get deleteAccountTitle => 'アカウントを削除しますか？';

  @override
  String get deleteAccountBody =>
      'Abbaのすべてのデータ（祈り、黙想、音声録音）が完全に削除されます。他のystechアプリを使用していない場合は、サインインアカウントも削除されます。';

  @override
  String get deleteAccountConfirmHint => '確認するには \'DELETE\' と入力してください。';

  @override
  String get deleteAccountFailed => 'アカウントを削除できませんでした。しばらくしてから再度お試しください。';
}
