// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Когда ты молишься,\nБог отвечает.';

  @override
  String get welcomeSubtitle =>
      'Твой ежедневный спутник в молитве и тихом времени с Богом';

  @override
  String get getStarted => 'Начать';

  @override
  String get loginTitle => 'Добро пожаловать в Abba';

  @override
  String get loginSubtitle => 'Войди, чтобы начать путь молитвы';

  @override
  String get signInWithApple => 'Продолжить с Apple';

  @override
  String get signInWithGoogle => 'Продолжить с Google';

  @override
  String get signInWithEmail => 'Продолжить с Email';

  @override
  String greetingMorning(Object name) {
    return 'Доброе утро, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Добрый день, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Добрый вечер, $name';
  }

  @override
  String get prayButton => 'Молиться';

  @override
  String get qtButton => 'Тихое время';

  @override
  String streakDays(Object count) {
    return '$count дней непрерывной молитвы';
  }

  @override
  String get dailyVerse => 'Стих дня';

  @override
  String get tabHome => 'Главная';

  @override
  String get tabCalendar => 'Календарь';

  @override
  String get tabCommunity => 'Община';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get recordingTitle => 'Молитва...';

  @override
  String get recordingPause => 'Пауза';

  @override
  String get recordingResume => 'Продолжить';

  @override
  String get finishPrayer => 'Завершить молитву';

  @override
  String get finishPrayerConfirm => 'Хотите завершить молитву?';

  @override
  String get switchToText => 'Написать вместо этого';

  @override
  String get textInputHint => 'Напишите свою молитву здесь...';

  @override
  String get aiLoadingText => 'Размышляю над вашей молитвой...';

  @override
  String get aiLoadingVerse =>
      'Остановитесь и познайте, что Я — Бог.\n— Псалом 45:11';

  @override
  String get dashboardTitle => 'Сад молитвы';

  @override
  String get shareButton => 'Поделиться';

  @override
  String get backToHome => 'Вернуться на главную';

  @override
  String get scriptureTitle => 'Писание на сегодня';

  @override
  String get bibleStoryTitle => 'Библейская история';

  @override
  String get testimonyTitle => 'Свидетельство · Моя молитва';

  @override
  String get testimonyHelperText =>
      'Размышляйте о своей молитве · можно поделиться с сообществом';

  @override
  String get myPrayerAudioLabel => 'Запись моей молитвы';

  @override
  String get testimonyEdit => 'Редактировать';

  @override
  String get guidanceTitle => 'Наставление ИИ';

  @override
  String get aiPrayerTitle => 'Молитва для тебя';

  @override
  String get originalLangTitle => 'Оригинальный язык';

  @override
  String get proUnlock => 'Разблокировать с Pro';

  @override
  String get qtPageTitle => 'Утренний сад';

  @override
  String get qtMeditateButton => 'Начать размышление';

  @override
  String get qtCompleted => 'Завершено';

  @override
  String get communityTitle => 'Сад молитвы';

  @override
  String get filterAll => 'Все';

  @override
  String get filterTestimony => 'Свидетельство';

  @override
  String get filterPrayerRequest => 'Молитвенная просьба';

  @override
  String get likeButton => 'Нравится';

  @override
  String get commentButton => 'Комментарий';

  @override
  String get saveButton => 'Сохранить';

  @override
  String get replyButton => 'Ответить';

  @override
  String get writePostTitle => 'Поделиться';

  @override
  String get cancelButton => 'Отмена';

  @override
  String get sharePostButton => 'Поделиться';

  @override
  String get anonymousToggle => 'Анонимно';

  @override
  String get realNameToggle => 'Настоящее имя';

  @override
  String get categoryTestimony => 'Свидетельство';

  @override
  String get categoryPrayerRequest => 'Молитвенная просьба';

  @override
  String get writePostHint =>
      'Поделитесь свидетельством или молитвенной просьбой...';

  @override
  String get importFromPrayer => 'Импорт из молитвы';

  @override
  String get calendarTitle => 'Календарь молитвы';

  @override
  String get currentStreak => 'Текущая серия';

  @override
  String get bestStreak => 'Лучшая серия';

  @override
  String get days => 'дней';

  @override
  String calendarRecordCount(Object count) {
    return '$count записей';
  }

  @override
  String get todayVerse => 'Стих на сегодня';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get profileSection => 'Профиль';

  @override
  String get totalPrayers => 'Всего молитв';

  @override
  String get consecutiveDays => 'Дней подряд';

  @override
  String get proSection => 'Подписка';

  @override
  String get freePlan => 'Бесплатно';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '599 ₽ / мес';

  @override
  String get yearlyPrice => '4 390 ₽ / год';

  @override
  String get yearlySave => 'Экономия 40%';

  @override
  String get launchPromo => '3 месяца за 399₽/мес.!';

  @override
  String get startPro => 'Начать Pro';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get notificationSetting => 'Уведомления';

  @override
  String get languageSetting => 'Язык';

  @override
  String get darkModeSetting => 'Тёмная тема';

  @override
  String get helpCenter => 'Центр помощи';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get logout => 'Выйти';

  @override
  String appVersion(Object version) {
    return 'Версия $version';
  }

  @override
  String get anonymous => 'Анонимно';

  @override
  String timeAgo(Object time) {
    return '$time назад';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get signIn => 'Войти';

  @override
  String get cancel => 'Отмена';

  @override
  String get noPrayersRecorded => 'Нет записанных молитв';

  @override
  String get deletePost => 'Удалить';

  @override
  String get reportPost => 'Пожаловаться';

  @override
  String get reportSubmitted => 'Жалоба отправлена. Спасибо.';

  @override
  String get reportReasonHint =>
      'Опишите причину жалобы. Она будет отправлена по email.';

  @override
  String get reportReasonPlaceholder => 'Укажите причину жалобы...';

  @override
  String get reportSubmitButton => 'Пожаловаться';

  @override
  String get deleteConfirmTitle => 'Удалить запись';

  @override
  String get deleteConfirmMessage =>
      'Вы уверены, что хотите удалить эту запись?';

  @override
  String get errorNetwork =>
      'Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get errorAiFallback => 'ИИ сейчас недоступен. Вот стих для тебя.';

  @override
  String get errorSttFailed =>
      'Распознавание речи недоступно. Напишите вместо этого.';

  @override
  String get errorPayment =>
      'Возникла проблема с оплатой. Попробуйте снова в Настройках.';

  @override
  String get errorGeneric => 'Что-то пошло не так. Попробуйте позже.';

  @override
  String get offlineNotice =>
      'Вы офлайн. Некоторые функции могут быть ограничены.';

  @override
  String get retryButton => 'Попробовать снова';

  @override
  String get groupSection => 'Мои группы';

  @override
  String get createGroup => 'Создать молитвенную группу';

  @override
  String get inviteFriends => 'Пригласить друзей';

  @override
  String get groupInviteMessage =>
      'Давай молиться вместе! Присоединяйся к моей молитвенной группе в Abba.';

  @override
  String get noGroups =>
      'Присоединитесь или создайте группу для совместной молитвы.';

  @override
  String get promoTitle => 'Специальное предложение';

  @override
  String get promoBanner => 'Первые 3 месяца за 399₽/мес.!';

  @override
  String promoEndsOn(Object date) {
    return 'Предложение действует до $date';
  }

  @override
  String get proLimitTitle => 'Сегодняшняя молитва завершена';

  @override
  String get proLimitBody => 'До завтра!\nМолитесь без ограничений с Pro';

  @override
  String get laterButton => 'Может быть позже';

  @override
  String get proPromptTitle => 'Функция Pro';

  @override
  String get proPromptBody =>
      'Эта функция доступна с Pro.\nХотите посмотреть наши планы?';

  @override
  String get viewProducts => 'Посмотреть планы';

  @override
  String get maybeLater => 'Может быть позже';

  @override
  String get proHeadline => 'Ближе к Богу каждый день';

  @override
  String get proBenefit1 => 'Безлимитная молитва и тихое время';

  @override
  String get proBenefit2 => 'Молитва и наставление с ИИ';

  @override
  String get proBenefit3 => 'Истории веры из прошлого';

  @override
  String get proBenefit5 => 'Изучение Библии на оригинальных языках';

  @override
  String get bestValue => 'ЛУЧШЕЕ ПРЕДЛОЖЕНИЕ';

  @override
  String get perMonth => 'мес.';

  @override
  String get cancelAnytime => 'Отмена в любое время';

  @override
  String get restorePurchase => 'Восстановить покупку';

  @override
  String get yearlyPriceMonthly => '366 ₽/мес';

  @override
  String get morningPrayerReminder => 'Утренняя молитва';

  @override
  String get eveningGratitudeReminder => 'Вечерняя благодарность';

  @override
  String get streakReminder => 'Напоминание о серии';

  @override
  String get afternoonNudgeReminder => 'Напоминание о дневной молитве';

  @override
  String get weeklySummaryReminder => 'Недельный итог';

  @override
  String get unlimited => 'Безлимитно';

  @override
  String get streakRecovery => 'Ничего страшного, можно начать заново 🌱';

  @override
  String get prayerSaved => 'Молитва успешно сохранена';

  @override
  String get quietTimeLabel => 'Тихое время';

  @override
  String get morningPrayerLabel => 'Утренняя молитва';

  @override
  String get gardenSeed => 'Семя веры';

  @override
  String get gardenSprout => 'Растущий росток';

  @override
  String get gardenBud => 'Распускающийся бутон';

  @override
  String get gardenBloom => 'Полное цветение';

  @override
  String get gardenTree => 'Крепкое дерево';

  @override
  String get gardenForest => 'Лес молитвы';

  @override
  String get milestoneShare => 'Поделиться';

  @override
  String get milestoneThankGod => 'Слава Богу!';

  @override
  String shareStreakText(Object count) {
    return '$count дней непрерывной молитвы! Мой путь молитвы с Abba #Abba #Молитва';
  }

  @override
  String get shareDaysLabel => 'дней непрерывной молитвы';

  @override
  String get shareSubtitle => 'Ежедневная молитва с Богом';

  @override
  String get proActive => 'Подписка Активна';

  @override
  String get planOncePerDay => '1x/день';

  @override
  String get planUnlimited => 'Безлимитно';

  @override
  String get closeRecording => 'Закрыть запись';

  @override
  String get qtRevealMessage => 'Откроем сегодняшнее Слово';

  @override
  String get qtSelectPrompt =>
      'Выберите одно и начните сегодняшнее тихое время';

  @override
  String get qtTopicLabel => 'Тема';

  @override
  String get prayerStartPrompt => 'Начните молитву';

  @override
  String get startPrayerButton => 'Начать молитву';

  @override
  String get switchToTextMode => 'Написать вместо этого';

  @override
  String get switchToVoiceMode => 'Говорить';

  @override
  String get prayerDashboardTitle => 'Сад молитвы';

  @override
  String get qtDashboardTitle => 'Сад тихого времени';

  @override
  String get prayerSummaryTitle => 'Итог молитвы';

  @override
  String get gratitudeLabel => 'Благодарность';

  @override
  String get petitionLabel => 'Прошение';

  @override
  String get intercessionLabel => 'Ходатайство';

  @override
  String get historicalStoryTitle => 'История из прошлого';

  @override
  String get todayLesson => 'Урок на сегодня';

  @override
  String get meditationAnalysisTitle => 'Анализ размышления';

  @override
  String get keyThemeLabel => 'Ключевая тема';

  @override
  String get applicationTitle => 'Применение на сегодня';

  @override
  String get applicationWhat => 'Что';

  @override
  String get applicationWhen => 'Когда';

  @override
  String get applicationContext => 'Где';

  @override
  String get relatedKnowledgeTitle => 'Дополнительные знания';

  @override
  String get originalWordLabel => 'Оригинальное слово';

  @override
  String get historicalContextLabel => 'Исторический контекст';

  @override
  String get crossReferencesLabel => 'Перекрёстные ссылки';

  @override
  String get growthStoryTitle => 'История роста';

  @override
  String get prayerGuideTitle => 'Как молиться с Abba';

  @override
  String get prayerGuide1 => 'Молитесь вслух или чётким голосом';

  @override
  String get prayerGuide2 =>
      'Abba слушает ваши слова и находит Писание, которое говорит к вашему сердцу';

  @override
  String get prayerGuide3 => 'Вы также можете написать свою молитву';

  @override
  String get qtGuideTitle => 'Как проводить тихое время с Abba';

  @override
  String get qtGuide1 => 'Прочитайте отрывок и размышляйте в тишине';

  @override
  String get qtGuide2 =>
      'Поделитесь тем, что вы открыли — скажите или напишите свои мысли';

  @override
  String get qtGuide3 =>
      'Abba поможет вам применить Слово в повседневной жизни';

  @override
  String get scriptureReasonLabel => 'Почему это Писание';

  @override
  String get scripturePostureLabel => 'С каким настроем это читать?';

  @override
  String get scriptureOriginalWordsTitle => 'Глубокий смысл на языке оригинала';

  @override
  String get originalWordMeaningLabel => 'Значение';

  @override
  String get originalWordNuanceLabel => 'Нюанс vs перевод';

  @override
  String originalWordsCountLabel(int count) {
    return '$count слов';
  }

  @override
  String get seeMore => 'Показать ещё';

  @override
  String seeAllComments(Object count) {
    return 'Посмотреть все $count комментариев';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name и ещё $count понравилось';
  }

  @override
  String get commentsTitle => 'Комментарии';

  @override
  String get myPageTitle => 'Мой сад молитвы';

  @override
  String get myPrayers => 'Мои молитвы';

  @override
  String get myTestimonies => 'Мои свидетельства';

  @override
  String get savedPosts => 'Сохранённое';

  @override
  String get totalPrayersCount => 'Молитвы';

  @override
  String get streakCount => 'Серия';

  @override
  String get testimoniesCount => 'Свидетельства';

  @override
  String get linkAccountTitle => 'Привязать аккаунт';

  @override
  String get linkAccountDescription =>
      'Привяжите аккаунт, чтобы сохранить записи молитв при смене устройства';

  @override
  String get linkWithApple => 'Привязать к Apple';

  @override
  String get linkWithGoogle => 'Привязать к Google';

  @override
  String get linkAccountSuccess => 'Аккаунт успешно привязан!';

  @override
  String get anonymousUser => 'Молитвенный воин';

  @override
  String showReplies(Object count) {
    return 'Показать $count ответов';
  }

  @override
  String get hideReplies => 'Скрыть ответы';

  @override
  String replyingTo(Object name) {
    return 'Ответ для $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Посмотреть все $count комментариев';
  }

  @override
  String get membershipTitle => 'Подписка';

  @override
  String get membershipSubtitle => 'Углубите вашу молитвенную жизнь';

  @override
  String get monthlyPlan => 'Ежемесячно';

  @override
  String get yearlyPlan => 'Ежегодно';

  @override
  String get yearlySavings => '233 ₽/мес (40% скидка)';

  @override
  String get startMembership => 'Начать';

  @override
  String get membershipActive => 'Подписка Активна';

  @override
  String get leaveRecordingTitle => 'Покинуть запись?';

  @override
  String get leaveRecordingMessage => 'Ваша запись будет потеряна. Вы уверены?';

  @override
  String get leaveButton => 'Выйти';

  @override
  String get stayButton => 'Остаться';

  @override
  String likedByCount(Object count) {
    return '$count человек сочувствуют';
  }

  @override
  String get actionLike => 'Нравится';

  @override
  String get actionComment => 'Комментарий';

  @override
  String get actionSave => 'Сохранить';

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
      '💛 Любовь — Подумайте о близком человеке 10 секунд';

  @override
  String get qtLoadingHint2 =>
      '🌿 Благодать — Вспомните малую благодать, полученную сегодня';

  @override
  String get qtLoadingHint3 =>
      '🌅 Надежда — Представьте маленькую надежду на завтра';

  @override
  String get qtLoadingHint4 =>
      '🕊️ Мир — Сделайте три медленных глубоких вдоха';

  @override
  String get qtLoadingHint5 => '🌳 Вера — Вспомните одну неизменную истину';

  @override
  String get qtLoadingHint6 =>
      '🌸 Благодарность — Назовите то, за что вы благодарны сейчас';

  @override
  String get qtLoadingHint7 =>
      '🌊 Прощение — Вспомните того, кого хотите простить';

  @override
  String get qtLoadingHint8 => '📖 Мудрость — Сохраните в сердце один урок дня';

  @override
  String get qtLoadingHint9 => '⏳ Терпение — Подумайте, чего вы тихо ждёте';

  @override
  String get qtLoadingHint10 => '✨ Радость — Вспомните улыбку сегодняшнего дня';

  @override
  String get qtLoadingTitle => 'Готовим сегодняшнее Слово...';

  @override
  String get coachingTitle => 'Наставничество в молитве';

  @override
  String get coachingLoadingText => 'Размышляем над вашей молитвой...';

  @override
  String get coachingErrorText => 'Временная ошибка — попробуйте ещё раз';

  @override
  String get coachingRetryButton => 'Повторить';

  @override
  String get coachingScoreSpecificity => 'Конкретность';

  @override
  String get coachingScoreGodCentered => 'Богоцентричность';

  @override
  String get coachingScoreActs => 'Баланс ACTS';

  @override
  String get coachingScoreAuthenticity => 'Подлинность';

  @override
  String get coachingStrengthsTitle => 'Что у вас получилось ✨';

  @override
  String get coachingImprovementsTitle => 'Чтобы углубить 💡';

  @override
  String get coachingProCta => 'Откройте Наставничество с Pro';

  @override
  String get coachingLevelBeginner => '🌱 Новичок';

  @override
  String get coachingLevelGrowing => '🌿 Развивается';

  @override
  String get coachingLevelExpert => '🌳 Эксперт';

  @override
  String get aiPrayerCitationsTitle => 'Ссылки · Цитаты';

  @override
  String get citationTypeQuote => 'Цитата';

  @override
  String get citationTypeScience => 'Исследование';

  @override
  String get citationTypeExample => 'Пример';

  @override
  String get aiPrayerReadingTime => 'Чтение на 2 минуты';

  @override
  String get scriptureKeyWordHintTitle => 'Ключевое слово сегодня';

  @override
  String get bibleLookupReferenceHint =>
      'Найдите этот отрывок в вашей Библии и размышляйте над ним.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }
}
