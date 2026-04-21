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
  String get testimonyTitle => 'Моє свідчення';

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
  String get meditationAnalysisTitle => 'Аналіз роздумів';

  @override
  String get keyThemeLabel => 'Ключова тема';

  @override
  String get applicationTitle => 'Застосування на сьогодні';

  @override
  String get applicationWhat => 'Що';

  @override
  String get applicationWhen => 'Коли';

  @override
  String get applicationContext => 'Де';

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
}
