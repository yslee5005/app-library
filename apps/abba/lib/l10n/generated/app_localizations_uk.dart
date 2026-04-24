// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Коли ти молишся,\nБог відповідає.';

  @override
  String get welcomeSubtitle =>
      'Твій щоденний супутник у молитві та тихому часі з Богом';

  @override
  String get getStarted => 'Почати';

  @override
  String get loginTitle => 'Ласкаво просимо до Abba';

  @override
  String get loginSubtitle => 'Увійдіть, щоб розпочати шлях молитви';

  @override
  String get signInWithApple => 'Продовжити з Apple';

  @override
  String get signInWithGoogle => 'Продовжити з Google';

  @override
  String get signInWithEmail => 'Продовжити з Email';

  @override
  String greetingMorning(Object name) {
    return 'Доброго ранку, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Доброго дня, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Доброго вечора, $name';
  }

  @override
  String get prayButton => 'Молитися';

  @override
  String get qtButton => 'Тихий час';

  @override
  String streakDays(Object count) {
    return '$count днів безперервної молитви';
  }

  @override
  String get dailyVerse => 'Вірш дня';

  @override
  String get tabHome => 'Головна';

  @override
  String get tabCalendar => 'Календар';

  @override
  String get tabCommunity => 'Спільнота';

  @override
  String get tabSettings => 'Налаштування';

  @override
  String get recordingTitle => 'Молитва...';

  @override
  String get recordingPause => 'Пауза';

  @override
  String get recordingResume => 'Продовжити';

  @override
  String get finishPrayer => 'Завершити молитву';

  @override
  String get finishPrayerConfirm => 'Бажаєте завершити молитву?';

  @override
  String get switchToText => 'Краще написати';

  @override
  String get textInputHint => 'Напишіть свою молитву тут...';

  @override
  String get aiLoadingText => 'Роздумую над вашою молитвою...';

  @override
  String get aiLoadingVerse =>
      'Зупиніться і пізнайте, що Я — Бог.\n— Псалом 45:11';

  @override
  String get aiErrorNetworkTitle => 'З’єднання нестабільне';

  @override
  String get aiErrorNetworkBody =>
      'Ваша молитва надійно збережена. Спробуйте ще раз за хвилину.';

  @override
  String get aiErrorApiTitle => 'Сервіс ШІ нестабільний';

  @override
  String get aiErrorApiBody =>
      'Ваша молитва надійно збережена. Спробуйте ще раз за хвилину.';

  @override
  String get aiErrorRetry => 'Спробувати знову';

  @override
  String get aiErrorWaitAndCheck =>
      'Ми спробуємо аналіз пізніше. Поверніться скоро — ваша молитва чекатиме.';

  @override
  String get aiErrorHome => 'На головну';

  @override
  String get dashboardTitle => 'Сад молитви';

  @override
  String get shareButton => 'Поділитися';

  @override
  String get backToHome => 'Повернутися на головну';

  @override
  String get scriptureTitle => 'Писання на сьогодні';

  @override
  String get bibleStoryTitle => 'Біблійна історія';

  @override
  String get testimonyTitle => 'Свідчення · Моя молитва';

  @override
  String get testimonyHelperText =>
      'Розмірковуйте про свою молитву · можна поділитися зі спільнотою';

  @override
  String get myPrayerAudioLabel => 'Запис моєї молитви';

  @override
  String get testimonyEdit => 'Редагувати';

  @override
  String get guidanceTitle => 'Настанова ШІ';

  @override
  String get aiPrayerTitle => 'Молитва для тебе';

  @override
  String get originalLangTitle => 'Мова оригіналу';

  @override
  String get proUnlock => 'Розблокувати з Pro';

  @override
  String get qtPageTitle => 'Ранковий сад';

  @override
  String get qtMeditateButton => 'Почати роздуми';

  @override
  String get qtCompleted => 'Завершено';

  @override
  String get communityTitle => 'Сад молитви';

  @override
  String get filterAll => 'Усі';

  @override
  String get filterTestimony => 'Свідчення';

  @override
  String get filterPrayerRequest => 'Молитовне прохання';

  @override
  String get likeButton => 'Подобається';

  @override
  String get commentButton => 'Коментар';

  @override
  String get saveButton => 'Зберегти';

  @override
  String get replyButton => 'Відповісти';

  @override
  String get writePostTitle => 'Поділитися';

  @override
  String get cancelButton => 'Скасувати';

  @override
  String get sharePostButton => 'Поділитися';

  @override
  String get anonymousToggle => 'Анонімно';

  @override
  String get realNameToggle => 'Справжнє ім\'я';

  @override
  String get categoryTestimony => 'Свідчення';

  @override
  String get categoryPrayerRequest => 'Молитовне прохання';

  @override
  String get writePostHint =>
      'Поділіться свідченням або молитовним проханням...';

  @override
  String get importFromPrayer => 'Імпортувати з молитви';

  @override
  String get calendarTitle => 'Календар молитви';

  @override
  String get currentStreak => 'Поточна серія';

  @override
  String get bestStreak => 'Найкраща серія';

  @override
  String get days => 'днів';

  @override
  String calendarRecordCount(Object count) {
    return '$count записів';
  }

  @override
  String get todayVerse => 'Вірш на сьогодні';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get profileSection => 'Профіль';

  @override
  String get totalPrayers => 'Загалом молитов';

  @override
  String get consecutiveDays => 'Днів поспіль';

  @override
  String get proSection => 'Підписка';

  @override
  String get freePlan => 'Безкоштовно';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '\$6.99 / міс';

  @override
  String get yearlyPrice => '\$49.99 / рік';

  @override
  String get yearlySave => 'Економія 40%';

  @override
  String get launchPromo => '3 місяці за 159₴/міс.!';

  @override
  String get startPro => 'Почати Pro';

  @override
  String get comingSoon => 'Незабаром';

  @override
  String get notificationSetting => 'Сповіщення';

  @override
  String get languageSetting => 'Мова';

  @override
  String get darkModeSetting => 'Темна тема';

  @override
  String get helpCenter => 'Центр допомоги';

  @override
  String get termsOfService => 'Умови використання';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get logout => 'Вийти';

  @override
  String appVersion(Object version) {
    return 'Версія $version';
  }

  @override
  String get anonymous => 'Анонімно';

  @override
  String timeAgo(Object time) {
    return '$time тому';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get signIn => 'Увійти';

  @override
  String get cancel => 'Скасувати';

  @override
  String get noPrayersRecorded => 'Немає записаних молитов';

  @override
  String get deletePost => 'Видалити';

  @override
  String get reportPost => 'Поскаржитись';

  @override
  String get reportSubmitted => 'Скаргу надіслано. Дякуємо.';

  @override
  String get reportReasonHint =>
      'Опишіть причину скарги. Вона буде надіслана електронною поштою.';

  @override
  String get reportReasonPlaceholder => 'Вкажіть причину скарги...';

  @override
  String get reportSubmitButton => 'Поскаржитись';

  @override
  String get deleteConfirmTitle => 'Видалити запис';

  @override
  String get deleteConfirmMessage =>
      'Ви впевнені, що хочете видалити цей запис?';

  @override
  String get errorNetwork =>
      'Перевірте з\'єднання з інтернетом і спробуйте знову.';

  @override
  String get errorAiFallback => 'ШІ зараз недоступний. Ось вірш для тебе.';

  @override
  String get errorSttFailed =>
      'Розпізнавання мовлення недоступне. Будь ласка, напишіть.';

  @override
  String get errorPayment =>
      'Виникла проблема з оплатою. Спробуйте ще раз у Налаштуваннях.';

  @override
  String get errorGeneric => 'Щось пішло не так. Спробуйте пізніше.';

  @override
  String get offlineNotice => 'Ви офлайн. Деякі функції можуть бути обмежені.';

  @override
  String get retryButton => 'Спробувати знову';

  @override
  String get groupSection => 'Мої групи';

  @override
  String get createGroup => 'Створити молитовну групу';

  @override
  String get inviteFriends => 'Запросити друзів';

  @override
  String get groupInviteMessage =>
      'Давай молитися разом! Приєднуйся до моєї молитовної групи в Abba.';

  @override
  String get noGroups =>
      'Приєднайтесь або створіть групу для спільної молитви.';

  @override
  String get promoTitle => 'Спеціальна пропозиція';

  @override
  String get promoBanner => 'Перші 3 місяці за 159₴/міс.!';

  @override
  String promoEndsOn(Object date) {
    return 'Пропозиція діє до $date';
  }

  @override
  String get proLimitTitle => 'Сьогоднішня молитва завершена';

  @override
  String get proLimitBody => 'До завтра!\nМолітеся без обмежень з Pro';

  @override
  String get laterButton => 'Можливо пізніше';

  @override
  String get proPromptTitle => 'Функція Pro';

  @override
  String get proPromptBody =>
      'Ця функція доступна з Pro.\nБажаєте переглянути наші плани?';

  @override
  String get viewProducts => 'Переглянути плани';

  @override
  String get maybeLater => 'Можливо пізніше';

  @override
  String get proHeadline => 'Ближче до Бога щодня';

  @override
  String get proBenefit1 => 'Необмежена молитва і тихий час';

  @override
  String get proBenefit2 => 'Молитва та настанова з ШІ';

  @override
  String get proBenefit3 => 'Історії віри з минулого';

  @override
  String get proBenefit5 => 'Вивчення Біблії мовою оригіналу';

  @override
  String get bestValue => 'НАЙКРАЩА ПРОПОЗИЦІЯ';

  @override
  String get perMonth => 'міс.';

  @override
  String get cancelAnytime => 'Скасувати будь-коли';

  @override
  String get restorePurchase => 'Відновити покупку';

  @override
  String get yearlyPriceMonthly => '\$4.17/міс';

  @override
  String get morningPrayerReminder => 'Ранкова молитва';

  @override
  String get eveningGratitudeReminder => 'Вечірня подяка';

  @override
  String get streakReminder => 'Нагадування про серію';

  @override
  String get afternoonNudgeReminder => 'Нагадування про денну молитву';

  @override
  String get weeklySummaryReminder => 'Тижневий підсумок';

  @override
  String get unlimited => 'Необмежено';

  @override
  String get streakRecovery => 'Нічого страшного, можна почати знову 🌱';

  @override
  String get prayerSaved => 'Молитву успішно збережено';

  @override
  String get quietTimeLabel => 'Тихий час';

  @override
  String get morningPrayerLabel => 'Ранкова молитва';

  @override
  String get gardenSeed => 'Насіння віри';

  @override
  String get gardenSprout => 'Зростаючий паросток';

  @override
  String get gardenBud => 'Бутон, що розпускається';

  @override
  String get gardenBloom => 'Повне цвітіння';

  @override
  String get gardenTree => 'Міцне дерево';

  @override
  String get gardenForest => 'Ліс молитви';

  @override
  String get milestoneShare => 'Поділитися';

  @override
  String get milestoneThankGod => 'Слава Богу!';

  @override
  String shareStreakText(Object count) {
    return '$count днів безперервної молитви! Мій шлях молитви з Abba #Abba #Молитва';
  }

  @override
  String get shareDaysLabel => 'днів безперервної молитви';

  @override
  String get shareSubtitle => 'Щоденна молитва з Богом';

  @override
  String get proActive => 'Підписка Активна';

  @override
  String get planOncePerDay => '1x/день';

  @override
  String get planUnlimited => 'Необмежено';

  @override
  String get closeRecording => 'Закрити запис';

  @override
  String get qtRevealMessage => 'Відкриємо сьогоднішнє Слово';

  @override
  String get qtSelectPrompt => 'Оберіть одне і почніть сьогоднішній тихий час';

  @override
  String get qtTopicLabel => 'Тема';

  @override
  String get prayerStartPrompt => 'Почніть молитву';

  @override
  String get startPrayerButton => 'Почати молитву';

  @override
  String get switchToTextMode => 'Краще написати';

  @override
  String get switchToVoiceMode => 'Говоріть';

  @override
  String get prayerDashboardTitle => 'Сад молитви';

  @override
  String get qtDashboardTitle => 'Сад тихого часу';

  @override
  String get prayerSummaryTitle => 'Підсумок молитви';

  @override
  String get gratitudeLabel => 'Подяка';

  @override
  String get petitionLabel => 'Прохання';

  @override
  String get intercessionLabel => 'Заступництво';

  @override
  String get historicalStoryTitle => 'Історія з минулого';

  @override
  String get todayLesson => 'Урок на сьогодні';

  @override
  String get applicationTitle => 'Застосування на сьогодні';

  @override
  String get applicationWhat => 'Що';

  @override
  String get applicationWhen => 'Коли';

  @override
  String get applicationContext => 'Де';

  @override
  String get applicationMorningLabel => 'Ранок';

  @override
  String get applicationDayLabel => 'День';

  @override
  String get applicationEveningLabel => 'Вечір';

  @override
  String get relatedKnowledgeTitle => 'Додаткові знання';

  @override
  String get originalWordLabel => 'Оригінальне слово';

  @override
  String get historicalContextLabel => 'Історичний контекст';

  @override
  String get crossReferencesLabel => 'Перехресні посилання';

  @override
  String get growthStoryTitle => 'Історія зростання';

  @override
  String get prayerGuideTitle => 'Як молитися з Abba';

  @override
  String get prayerGuide1 => 'Молітеся вголос або чітким голосом';

  @override
  String get prayerGuide2 =>
      'Abba слухає ваші слова і знаходить Писання, що говорить до вашого серця';

  @override
  String get prayerGuide3 => 'Ви також можете написати свою молитву';

  @override
  String get qtGuideTitle => 'Як проводити тихий час з Abba';

  @override
  String get qtGuide1 => 'Прочитайте уривок і роздумуйте в тиші';

  @override
  String get qtGuide2 =>
      'Поділіться тим, що ви відкрили — скажіть або напишіть свої думки';

  @override
  String get qtGuide3 =>
      'Abba допоможе вам застосувати Слово у щоденному житті';

  @override
  String get scriptureReasonLabel => 'Чому саме це Писання';

  @override
  String get scripturePostureLabel => 'З яким настроєм це читати?';

  @override
  String get scriptureOriginalWordsTitle => 'Глибший зміст мовою оригіналу';

  @override
  String get originalWordMeaningLabel => 'Значення';

  @override
  String get originalWordNuanceLabel => 'Нюанс vs переклад';

  @override
  String originalWordsCountLabel(int count) {
    return '$count слів';
  }

  @override
  String get seeMore => 'Показати більше';

  @override
  String seeAllComments(Object count) {
    return 'Переглянути всі $count коментарів';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name та ще $count сподобалось';
  }

  @override
  String get commentsTitle => 'Коментарі';

  @override
  String get myPageTitle => 'Мій сад молитви';

  @override
  String get myPrayers => 'Мої молитви';

  @override
  String get myTestimonies => 'Мої свідчення';

  @override
  String get savedPosts => 'Збережене';

  @override
  String get totalPrayersCount => 'Молитви';

  @override
  String get streakCount => 'Серія';

  @override
  String get testimoniesCount => 'Свідчення';

  @override
  String get linkAccountTitle => 'Прив\'язати акаунт';

  @override
  String get linkAccountDescription =>
      'Прив\'яжіть акаунт, щоб зберегти записи молитов при зміні пристрою';

  @override
  String get linkWithApple => 'Прив\'язати до Apple';

  @override
  String get linkWithGoogle => 'Прив\'язати до Google';

  @override
  String get linkAccountSuccess => 'Акаунт успішно прив\'язано!';

  @override
  String get anonymousUser => 'Молитовний воїн';

  @override
  String showReplies(Object count) {
    return 'Показати $count відповідей';
  }

  @override
  String get hideReplies => 'Сховати відповіді';

  @override
  String replyingTo(Object name) {
    return 'Відповідь для $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Переглянути всі $count коментарів';
  }

  @override
  String get membershipTitle => 'Підписка';

  @override
  String get membershipSubtitle => 'Поглибте ваше молитовне життя';

  @override
  String get monthlyPlan => 'Щомісяця';

  @override
  String get yearlyPlan => 'Щороку';

  @override
  String get yearlySavings => '\$4.17/міс (знижка 40%)';

  @override
  String get startMembership => 'Розпочати';

  @override
  String get membershipActive => 'Підписка Активна';

  @override
  String get leaveRecordingTitle => 'Залишити запис?';

  @override
  String get leaveRecordingMessage => 'Ваш запис буде втрачено. Ви впевнені?';

  @override
  String get leaveButton => 'Залишити';

  @override
  String get stayButton => 'Залишитися';

  @override
  String likedByCount(Object count) {
    return '$count осіб співпереживають';
  }

  @override
  String get actionLike => 'Подобається';

  @override
  String get actionComment => 'Коментар';

  @override
  String get actionSave => 'Зберегти';

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
  String get billingIssueTitle => 'Виявлено проблему з оплатою';

  @override
  String billingIssueBody(int days) {
    return 'Переваги Pro завершаться через $days днів, якщо спосіб оплати не оновлено.';
  }

  @override
  String get billingIssueAction => 'Оновити оплату';

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
      '💛 Любов — Подумайте про близьку людину 10 секунд';

  @override
  String get qtLoadingHint2 =>
      '🌿 Благодать — Згадайте одну маленьку благодать сьогодні';

  @override
  String get qtLoadingHint3 => '🌅 Надія — Уявіть невелику надію на завтра';

  @override
  String get qtLoadingHint4 => '🕊️ Мир — Зробіть три повільні глибокі вдихи';

  @override
  String get qtLoadingHint5 => '🌳 Віра — Згадайте одну незмінну істину';

  @override
  String get qtLoadingHint6 =>
      '🌸 Вдячність — Назвіть одну річ, за яку ви вдячні зараз';

  @override
  String get qtLoadingHint7 =>
      '🌊 Прощення — Пригадайте того, кого хочете простити';

  @override
  String get qtLoadingHint8 =>
      '📖 Мудрість — Збережіть один урок сьогоднішнього дня';

  @override
  String get qtLoadingHint9 => '⏳ Терпіння — Подумайте, на що ви тихо чекаєте';

  @override
  String get qtLoadingHint10 =>
      '✨ Радість — Згадайте усмішку сьогоднішнього дня';

  @override
  String get qtLoadingTitle => 'Готується сьогоднішнє Слово...';

  @override
  String get coachingTitle => 'Наставництво в молитві';

  @override
  String get coachingLoadingText => 'Розмірковуємо над вашою молитвою...';

  @override
  String get coachingErrorText => 'Тимчасова помилка — спробуйте ще раз';

  @override
  String get coachingRetryButton => 'Повторити';

  @override
  String get coachingScoreSpecificity => 'Конкретність';

  @override
  String get coachingScoreGodCentered => 'Богоцентричність';

  @override
  String get coachingScoreActs => 'Баланс ACTS';

  @override
  String get coachingScoreAuthenticity => 'Автентичність';

  @override
  String get coachingStrengthsTitle => 'Що ви зробили добре ✨';

  @override
  String get coachingImprovementsTitle => 'Щоб заглибитися 💡';

  @override
  String get coachingProCta => 'Відкрити Наставництво з Pro';

  @override
  String get coachingLevelBeginner => '🌱 Початківець';

  @override
  String get coachingLevelGrowing => '🌿 Зростає';

  @override
  String get coachingLevelExpert => '🌳 Експерт';

  @override
  String get aiPrayerCitationsTitle => 'Посилання · Цитати';

  @override
  String get citationTypeQuote => 'Цитата';

  @override
  String get citationTypeScience => 'Дослідження';

  @override
  String get citationTypeExample => 'Приклад';

  @override
  String get citationTypeHistory => 'Історія';

  @override
  String get aiPrayerReadingTime => 'Читання 2 хвилини';

  @override
  String get scriptureKeyWordHintTitle => 'Ключове слово сьогодні';

  @override
  String get bibleLookupReferenceHint =>
      'Знайдіть цей уривок у вашій Біблії та роздумуйте над ним.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Переклади Біблії';

  @override
  String get settingsBibleTranslationsIntro =>
      'Біблійні вірші в цьому додатку взяті з перекладів у суспільному надбанні. Коментарі, молитви та історії, створені ШІ, є творчою роботою Abba.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'Наставництво в QT';

  @override
  String get qtCoachingLoadingText => 'Розмірковуємо над вашими роздумами...';

  @override
  String get qtCoachingErrorText => 'Тимчасова помилка — спробуйте ще раз';

  @override
  String get qtCoachingRetryButton => 'Повторити';

  @override
  String get qtCoachingScoreComprehension => 'Розуміння тексту';

  @override
  String get qtCoachingScoreApplication => 'Особисте застосування';

  @override
  String get qtCoachingScoreDepth => 'Духовна глибина';

  @override
  String get qtCoachingScoreAuthenticity => 'Автентичність';

  @override
  String get qtCoachingStrengthsTitle => 'Що ви зробили добре ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Щоб заглибитися 💡';

  @override
  String get qtCoachingProCta => 'Відкрити Наставництво в QT з Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Початківець';

  @override
  String get qtCoachingLevelGrowing => '🌿 Зростає';

  @override
  String get qtCoachingLevelExpert => '🌳 Експерт';

  @override
  String get notifyMorning1Title => '🙏 Час молитися';

  @override
  String notifyMorning1Body(String name) {
    return '$name, поговори з Богом і сьогодні';
  }

  @override
  String get notifyMorning2Title => '🌅 Настав новий ранок';

  @override
  String notifyMorning2Body(String name) {
    return '$name, почни день з вдячності';
  }

  @override
  String get notifyMorning3Title => '✨ Благодать сьогодні';

  @override
  String notifyMorning3Body(String name) {
    return '$name, зустрінь благодать, яку Бог приготував';
  }

  @override
  String get notifyMorning4Title => '🕊️ Мирний ранок';

  @override
  String notifyMorning4Body(String name) {
    return '$name, наповни серце миром через молитву';
  }

  @override
  String get notifyMorning5Title => '📖 Зі Словом';

  @override
  String notifyMorning5Body(String name) {
    return '$name, послухай сьогодні голос Бога';
  }

  @override
  String get notifyMorning6Title => '🌿 Час відпочинку';

  @override
  String notifyMorning6Body(String name) {
    return '$name, зупинися на мить і помолися';
  }

  @override
  String get notifyMorning7Title => '💫 І сьогодні';

  @override
  String notifyMorning7Body(String name) {
    return '$name, день, що починається з молитви, інакший';
  }

  @override
  String get notifyEvening1Title => '✨ Вдячність за сьогодні';

  @override
  String get notifyEvening1Body =>
      'Оглянься на день і звершимо подячну молитву';

  @override
  String get notifyEvening2Title => '🌙 Завершуючи день';

  @override
  String get notifyEvening2Body => 'Вислови сьогоднішню вдячність у молитві';

  @override
  String get notifyEvening3Title => '🙏 Вечірня молитва';

  @override
  String get notifyEvening3Body => 'У кінці дня подякуй Богові';

  @override
  String get notifyEvening4Title => '🌟 Рахуючи благословення дня';

  @override
  String get notifyEvening4Body => 'Якщо є за що дякувати, поділись у молитві';

  @override
  String get notifyStreak3Title => '🌱 3 дні поспіль!';

  @override
  String get notifyStreak3Body => 'Ваша звичка молитися розпочалася';

  @override
  String get notifyStreak7Title => '🌿 Цілий тиждень!';

  @override
  String get notifyStreak7Body => 'Молитва стає звичкою';

  @override
  String get notifyStreak14Title => '🌳 2 тижні поспіль!';

  @override
  String get notifyStreak14Body => 'Вражаючий ріст!';

  @override
  String get notifyStreak21Title => '🌻 3 тижні поспіль!';

  @override
  String get notifyStreak21Body => 'Квітка молитви розквітає';

  @override
  String get notifyStreak30Title => '🏆 Цілий місяць!';

  @override
  String get notifyStreak30Body => 'Ваша молитва сяє';

  @override
  String get notifyStreak50Title => '👑 50 днів поспіль!';

  @override
  String get notifyStreak50Body => 'Ваша дорога з Богом поглиблюється';

  @override
  String get notifyStreak100Title => '🎉 100 днів поспіль!';

  @override
  String get notifyStreak100Body => 'Ви стали воїном молитви!';

  @override
  String get notifyStreak365Title => '✝️ Цілий рік!';

  @override
  String get notifyStreak365Body => 'Вражаюча подорож віри!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ Ви вже помолилися сьогодні?';

  @override
  String get notifyAfternoonNudgeBody => 'Коротка молитва може змінити день';

  @override
  String get notifyChannelName => 'Нагадування про молитву';

  @override
  String get notifyChannelDescription =>
      'Ранкова молитва, вечірня вдячність та інші нагадування';

  @override
  String get milestoneFirstPrayerTitle => 'Перша молитва!';

  @override
  String get milestoneFirstPrayerDesc =>
      'Ваша молитовна подорож розпочалася. Бог слухає.';

  @override
  String get milestoneSevenDayStreakTitle => '7 днів молитви!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'Тиждень вірної молитви. Ваш сад росте!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 днів!';

  @override
  String get milestoneThirtyDayStreakDesc => 'Ваш сад розквітнув полем квітів!';

  @override
  String get milestoneHundredPrayersTitle => '100-та молитва!';

  @override
  String get milestoneHundredPrayersDesc =>
      'Сто розмов з Богом. Ви глибоко вкоренилися.';

  @override
  String get homeFirstPrayerPrompt => 'Почніть свою першу молитву';

  @override
  String get homeFirstQtPrompt => 'Почніть свій перший QT';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Сьогодні також $activityName';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'День $count безперервної $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'Минуло $days днів з останньої $activityName';
  }

  @override
  String get homeActivityPrayer => 'молитва';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Завантаження...';

  @override
  String get heatmapNoPrayer => 'Немає молитви';

  @override
  String get heatmapLegendLess => 'Менше';

  @override
  String get heatmapLegendMore => 'Більше';

  @override
  String get qtPassagesLoadError =>
      'Не вдалося завантажити сьогоднішні уривки. Перевірте з\'єднання.';

  @override
  String get qtPassagesRetryButton => 'Повторити';

  @override
  String get aiStreamingInitial => 'Розмірковуємо над вашою молитвою...';

  @override
  String get aiTierProcessing => 'Ще роздуми на підході...';

  @override
  String get aiScriptureValidating => 'Шукаємо відповідне місце з Писання...';

  @override
  String get aiScriptureValidatingFailed =>
      'Готуємо це місце з Писання для вас...';

  @override
  String get aiTemplateFallback => 'Поки ми готуємо повний аналіз...';

  @override
  String get aiPendingMore => 'Готуємо більше...';

  @override
  String get aiTierIncomplete => 'Незабаром, загляньте пізніше';

  @override
  String get tierCompleted => 'Додано новий роздум';

  @override
  String get tierProcessingNotice => 'Створюємо нові роздуми...';

  @override
  String get proSectionLoading => 'Готуємо ваш преміум-вміст...';

  @override
  String get proSectionWillArrive => 'Ваш глибокий роздум з’явиться тут';

  @override
  String get templateCategoryHealth => 'Про здоров’я';

  @override
  String get templateCategoryFamily => 'Про сім’ю';

  @override
  String get templateCategoryWork => 'Про роботу й навчання';

  @override
  String get templateCategoryGratitude => 'Вдячне серце';

  @override
  String get templateCategoryGrief => 'У скорботі чи втраті';

  @override
  String get sectionStatusCompleted => 'Аналіз завершено';

  @override
  String get sectionStatusPartial => 'Частковий аналіз (незабаром буде більше)';

  @override
  String get sectionStatusPending => 'Аналіз виконується';
}
