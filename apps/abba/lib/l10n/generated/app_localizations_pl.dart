// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Gdy się modlisz,\nBóg odpowiada.';

  @override
  String get welcomeSubtitle =>
      'Twój codzienny towarzysz modlitwy i cichej chwili z Bogiem';

  @override
  String get getStarted => 'Zacznij';

  @override
  String get loginTitle => 'Witaj w Abba';

  @override
  String get loginSubtitle => 'Zaloguj się, aby rozpocząć swoją drogę modlitwy';

  @override
  String get signInWithApple => 'Kontynuuj z Apple';

  @override
  String get signInWithGoogle => 'Kontynuuj z Google';

  @override
  String get signInWithEmail => 'Kontynuuj z E-mailem';

  @override
  String greetingMorning(Object name) {
    return 'Dzień dobry, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Dzień dobry, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Dobry wieczór, $name';
  }

  @override
  String get prayButton => 'Módl się';

  @override
  String get qtButton => 'Cisza z Bogiem';

  @override
  String streakDays(Object count) {
    return '$count dni ciągłej modlitwy';
  }

  @override
  String get dailyVerse => 'Werset dnia';

  @override
  String get tabHome => 'Główna';

  @override
  String get tabCalendar => 'Kalendarz';

  @override
  String get tabCommunity => 'Wspólnota';

  @override
  String get tabSettings => 'Ustawienia';

  @override
  String get recordingTitle => 'Modlitwa...';

  @override
  String get recordingPause => 'Pauza';

  @override
  String get recordingResume => 'Wznów';

  @override
  String get finishPrayer => 'Zakończ modlitwę';

  @override
  String get finishPrayerConfirm => 'Czy chcesz zakończyć modlitwę?';

  @override
  String get switchToText => 'Pisz zamiast tego';

  @override
  String get textInputHint => 'Napisz swoją modlitwę tutaj...';

  @override
  String get aiLoadingText => 'Rozważam Twoją modlitwę...';

  @override
  String get aiLoadingVerse =>
      'Zatrzymajcie się i poznajcie, że Ja jestem Bogiem.\n— Psalm 46:11';

  @override
  String get dashboardTitle => 'Ogród modlitwy';

  @override
  String get shareButton => 'Udostępnij';

  @override
  String get backToHome => 'Wróć na stronę główną';

  @override
  String get scriptureTitle => 'Dzisiejsze Pismo';

  @override
  String get bibleStoryTitle => 'Historia biblijna';

  @override
  String get testimonyTitle => 'Świadectwo · Moja modlitwa';

  @override
  String get testimonyHelperText =>
      'Zastanów się nad modlitwą · można udostępnić społeczności';

  @override
  String get myPrayerAudioLabel => 'Nagranie mojej modlitwy';

  @override
  String get testimonyEdit => 'Edytuj';

  @override
  String get guidanceTitle => 'Przewodnictwo AI';

  @override
  String get aiPrayerTitle => 'Modlitwa dla Ciebie';

  @override
  String get originalLangTitle => 'Język oryginalny';

  @override
  String get proUnlock => 'Odblokuj z Pro';

  @override
  String get qtPageTitle => 'Poranny ogród';

  @override
  String get qtMeditateButton => 'Rozpocznij medytację';

  @override
  String get qtCompleted => 'Ukończone';

  @override
  String get communityTitle => 'Ogród modlitwy';

  @override
  String get filterAll => 'Wszystkie';

  @override
  String get filterTestimony => 'Świadectwo';

  @override
  String get filterPrayerRequest => 'Prośba o modlitwę';

  @override
  String get likeButton => 'Lubię to';

  @override
  String get commentButton => 'Komentarz';

  @override
  String get saveButton => 'Zapisz';

  @override
  String get replyButton => 'Odpowiedz';

  @override
  String get writePostTitle => 'Udostępnij';

  @override
  String get cancelButton => 'Anuluj';

  @override
  String get sharePostButton => 'Udostępnij';

  @override
  String get anonymousToggle => 'Anonimowo';

  @override
  String get realNameToggle => 'Prawdziwe imię';

  @override
  String get categoryTestimony => 'Świadectwo';

  @override
  String get categoryPrayerRequest => 'Prośba o modlitwę';

  @override
  String get writePostHint =>
      'Podziel się świadectwem lub prośbą o modlitwę...';

  @override
  String get importFromPrayer => 'Importuj z modlitwy';

  @override
  String get calendarTitle => 'Kalendarz modlitwy';

  @override
  String get currentStreak => 'Obecna seria';

  @override
  String get bestStreak => 'Najlepsza seria';

  @override
  String get days => 'dni';

  @override
  String calendarRecordCount(Object count) {
    return '$count wpisów';
  }

  @override
  String get todayVerse => 'Werset na dziś';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Łączna liczba modlitw';

  @override
  String get consecutiveDays => 'Dni z rzędu';

  @override
  String get proSection => 'Członkostwo';

  @override
  String get freePlan => 'Bezpłatny';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '29,99 zł / mies.';

  @override
  String get yearlyPrice => '219,99 zł / rok';

  @override
  String get yearlySave => 'Oszczędź 40%';

  @override
  String get launchPromo => '3 miesiące za 15,99zł/mies.!';

  @override
  String get startPro => 'Rozpocznij Pro';

  @override
  String get comingSoon => 'Wkrótce';

  @override
  String get notificationSetting => 'Powiadomienia';

  @override
  String get languageSetting => 'Język';

  @override
  String get darkModeSetting => 'Tryb ciemny';

  @override
  String get helpCenter => 'Centrum pomocy';

  @override
  String get termsOfService => 'Regulamin';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get logout => 'Wyloguj się';

  @override
  String appVersion(Object version) {
    return 'Wersja $version';
  }

  @override
  String get anonymous => 'Anonimowo';

  @override
  String timeAgo(Object time) {
    return '$time temu';
  }

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Hasło';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get cancel => 'Anuluj';

  @override
  String get noPrayersRecorded => 'Brak zapisanych modlitw';

  @override
  String get deletePost => 'Usuń';

  @override
  String get reportPost => 'Zgłoś';

  @override
  String get reportSubmitted => 'Zgłoszenie wysłane. Dziękujemy.';

  @override
  String get reportReasonHint =>
      'Opisz powód zgłoszenia. Zostanie wysłane e-mailem.';

  @override
  String get reportReasonPlaceholder => 'Podaj powód zgłoszenia...';

  @override
  String get reportSubmitButton => 'Zgłoś';

  @override
  String get deleteConfirmTitle => 'Usuń post';

  @override
  String get deleteConfirmMessage => 'Czy na pewno chcesz usunąć ten post?';

  @override
  String get errorNetwork =>
      'Sprawdź połączenie z internetem i spróbuj ponownie.';

  @override
  String get errorAiFallback =>
      'AI jest teraz niedostępne. Oto werset dla Ciebie.';

  @override
  String get errorSttFailed =>
      'Rozpoznawanie mowy jest niedostępne. Napisz zamiast tego.';

  @override
  String get errorPayment =>
      'Wystąpił problem z płatnością. Spróbuj ponownie w Ustawieniach.';

  @override
  String get errorGeneric => 'Coś poszło nie tak. Spróbuj ponownie później.';

  @override
  String get offlineNotice =>
      'Jesteś offline. Niektóre funkcje mogą być ograniczone.';

  @override
  String get retryButton => 'Spróbuj ponownie';

  @override
  String get groupSection => 'Moje grupy';

  @override
  String get createGroup => 'Utwórz grupę modlitewną';

  @override
  String get inviteFriends => 'Zaproś znajomych';

  @override
  String get groupInviteMessage =>
      'Módlmy się razem! Dołącz do mojej grupy modlitewnej w Abba.';

  @override
  String get noGroups => 'Dołącz lub utwórz grupę, aby modlić się razem.';

  @override
  String get promoTitle => 'Oferta premierowa';

  @override
  String get promoBanner => 'Pierwsze 3 miesiące za 15,99zł/mies.!';

  @override
  String promoEndsOn(Object date) {
    return 'Oferta kończy się $date';
  }

  @override
  String get proLimitTitle => 'Dzisiejsza modlitwa zakończona';

  @override
  String get proLimitBody => 'Do jutra!\nMódl się bez limitu z Pro';

  @override
  String get laterButton => 'Może później';

  @override
  String get proPromptTitle => 'Funkcja Pro';

  @override
  String get proPromptBody =>
      'Ta funkcja jest dostępna z Pro.\nChcesz zobaczyć nasze plany?';

  @override
  String get viewProducts => 'Zobacz plany';

  @override
  String get maybeLater => 'Może później';

  @override
  String get proHeadline => 'Bliżej Boga, każdego dnia';

  @override
  String get proBenefit1 => 'Nielimitowana modlitwa i cisza z Bogiem';

  @override
  String get proBenefit2 => 'Modlitwa i przewodnictwo z AI';

  @override
  String get proBenefit3 => 'Historie wiary z przeszłości';

  @override
  String get proBenefit5 => 'Studium Biblii w językach oryginalnych';

  @override
  String get bestValue => 'NAJLEPSZA OFERTA';

  @override
  String get perMonth => 'mies.';

  @override
  String get cancelAnytime => 'Anuluj w dowolnym momencie';

  @override
  String get restorePurchase => 'Przywróć zakup';

  @override
  String get yearlyPriceMonthly => '18,33 zł/mies.';

  @override
  String get morningPrayerReminder => 'Poranna modlitwa';

  @override
  String get eveningGratitudeReminder => 'Wieczorna wdzięczność';

  @override
  String get streakReminder => 'Przypomnienie o serii';

  @override
  String get afternoonNudgeReminder =>
      'Przypomnienie o popołudniowej modlitwie';

  @override
  String get weeklySummaryReminder => 'Podsumowanie tygodnia';

  @override
  String get unlimited => 'Bez limitu';

  @override
  String get streakRecovery => 'Nic się nie stało, możesz zacząć od nowa 🌱';

  @override
  String get prayerSaved => 'Modlitwa zapisana pomyślnie';

  @override
  String get quietTimeLabel => 'Cisza z Bogiem';

  @override
  String get morningPrayerLabel => 'Poranna modlitwa';

  @override
  String get gardenSeed => 'Ziarno wiary';

  @override
  String get gardenSprout => 'Rosnący kiełek';

  @override
  String get gardenBud => 'Rozkwitający pąk';

  @override
  String get gardenBloom => 'Pełny rozkwit';

  @override
  String get gardenTree => 'Mocne drzewo';

  @override
  String get gardenForest => 'Las modlitwy';

  @override
  String get milestoneShare => 'Udostępnij';

  @override
  String get milestoneThankGod => 'Chwała Bogu!';

  @override
  String shareStreakText(Object count) {
    return '$count dni ciągłej modlitwy! Moja droga modlitwy z Abba #Abba #Modlitwa';
  }

  @override
  String get shareDaysLabel => 'dni ciągłej modlitwy';

  @override
  String get shareSubtitle => 'Codzienna modlitwa z Bogiem';

  @override
  String get proActive => 'Członkostwo Aktywne';

  @override
  String get planOncePerDay => '1x/dzień';

  @override
  String get planUnlimited => 'Bez limitu';

  @override
  String get closeRecording => 'Zamknij nagrywanie';

  @override
  String get qtRevealMessage => 'Otwórzmy dzisiejsze Słowo';

  @override
  String get qtSelectPrompt =>
      'Wybierz jedno i rozpocznij dzisiejszą ciszę z Bogiem';

  @override
  String get qtTopicLabel => 'Temat';

  @override
  String get prayerStartPrompt => 'Rozpocznij modlitwę';

  @override
  String get startPrayerButton => 'Zacznij się modlić';

  @override
  String get switchToTextMode => 'Pisz zamiast tego';

  @override
  String get switchToVoiceMode => 'Mow';

  @override
  String get prayerDashboardTitle => 'Ogród modlitwy';

  @override
  String get qtDashboardTitle => 'Ogród ciszy z Bogiem';

  @override
  String get prayerSummaryTitle => 'Podsumowanie modlitwy';

  @override
  String get gratitudeLabel => 'Wdzięczność';

  @override
  String get petitionLabel => 'Prośba';

  @override
  String get intercessionLabel => 'Wstawiennictwo';

  @override
  String get historicalStoryTitle => 'Historia z przeszłości';

  @override
  String get todayLesson => 'Dzisiejsza lekcja';

  @override
  String get meditationAnalysisTitle => 'Analiza medytacji';

  @override
  String get keyThemeLabel => 'Kluczowy temat';

  @override
  String get applicationTitle => 'Dzisiejsze zastosowanie';

  @override
  String get applicationWhat => 'Co';

  @override
  String get applicationWhen => 'Kiedy';

  @override
  String get applicationContext => 'Gdzie';

  @override
  String get relatedKnowledgeTitle => 'Powiązana wiedza';

  @override
  String get originalWordLabel => 'Słowo oryginalne';

  @override
  String get historicalContextLabel => 'Kontekst historyczny';

  @override
  String get crossReferencesLabel => 'Odnośniki krzyżowe';

  @override
  String get growthStoryTitle => 'Historia wzrostu';

  @override
  String get prayerGuideTitle => 'Jak modlić się z Abba';

  @override
  String get prayerGuide1 => 'Módl się na głos lub wyraźnym głosem';

  @override
  String get prayerGuide2 =>
      'Abba słucha Twoich słów i znajduje Pismo, które przemawia do Twojego serca';

  @override
  String get prayerGuide3 => 'Możesz też napisać swoją modlitwę';

  @override
  String get qtGuideTitle => 'Jak spędzić ciszę z Bogiem z Abba';

  @override
  String get qtGuide1 => 'Przeczytaj fragment i medytuj w ciszy';

  @override
  String get qtGuide2 =>
      'Podziel się tym, co odkryłeś — powiedz lub napisz swoją refleksję';

  @override
  String get qtGuide3 => 'Abba pomoże Ci zastosować Słowo w codziennym życiu';

  @override
  String get scriptureReasonLabel => 'Dlaczego to Pismo';

  @override
  String get scripturePostureLabel => 'W jakim nastawieniu to czytać?';

  @override
  String get scriptureOriginalWordsTitle => 'Głębsze znaczenie w oryginale';

  @override
  String get originalWordMeaningLabel => 'Znaczenie';

  @override
  String get originalWordNuanceLabel => 'Niuans vs tłumaczenie';

  @override
  String originalWordsCountLabel(int count) {
    return '$count słów';
  }

  @override
  String get seeMore => 'Zobacz więcej';

  @override
  String seeAllComments(Object count) {
    return 'Zobacz wszystkie komentarze ($count)';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name i $count innych polubili to';
  }

  @override
  String get commentsTitle => 'Komentarze';

  @override
  String get myPageTitle => 'Mój ogród modlitwy';

  @override
  String get myPrayers => 'Moje modlitwy';

  @override
  String get myTestimonies => 'Moje świadectwa';

  @override
  String get savedPosts => 'Zapisane';

  @override
  String get totalPrayersCount => 'Modlitwy';

  @override
  String get streakCount => 'Seria';

  @override
  String get testimoniesCount => 'Świadectwa';

  @override
  String get linkAccountTitle => 'Połącz konto';

  @override
  String get linkAccountDescription =>
      'Połącz konto, aby zachować zapisy modlitw przy zmianie urządzenia';

  @override
  String get linkWithApple => 'Połącz z Apple';

  @override
  String get linkWithGoogle => 'Połącz z Google';

  @override
  String get linkAccountSuccess => 'Konto połączone pomyślnie!';

  @override
  String get anonymousUser => 'Wojownik modlitwy';

  @override
  String showReplies(Object count) {
    return 'Pokaż $count odpowiedzi';
  }

  @override
  String get hideReplies => 'Ukryj odpowiedzi';

  @override
  String replyingTo(Object name) {
    return 'Odpowiedź do $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Zobacz wszystkie komentarze ($count)';
  }

  @override
  String get membershipTitle => 'Członkostwo';

  @override
  String get membershipSubtitle => 'Pogłęb swoje życie modlitewne';

  @override
  String get monthlyPlan => 'Miesięczny';

  @override
  String get yearlyPlan => 'Roczny';

  @override
  String get yearlySavings => '11,66 zł/mies. (40% taniej)';

  @override
  String get startMembership => 'Rozpocznij';

  @override
  String get membershipActive => 'Członkostwo Aktywne';

  @override
  String get leaveRecordingTitle => 'Opuścić nagrywanie?';

  @override
  String get leaveRecordingMessage =>
      'Twoje nagranie zostanie utracone. Czy na pewno?';

  @override
  String get leaveButton => 'Opuść';

  @override
  String get stayButton => 'Zostań';

  @override
  String likedByCount(Object count) {
    return '$count osób okazało empatię';
  }

  @override
  String get actionLike => 'Lubię';

  @override
  String get actionComment => 'Komentarz';

  @override
  String get actionSave => 'Zapisz';

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
      '💛 Miłość — Pomyśl o kimś, kogo kochasz, przez 10 sekund';

  @override
  String get qtLoadingHint2 =>
      '🌿 Łaska — Przypomnij sobie jedną małą łaskę otrzymaną dzisiaj';

  @override
  String get qtLoadingHint3 =>
      '🌅 Nadzieja — Wyobraź sobie małą nadzieję na jutro';

  @override
  String get qtLoadingHint4 => '🕊️ Pokój — Weź trzy powolne, głębokie oddechy';

  @override
  String get qtLoadingHint5 =>
      '🌳 Wiara — Przypomnij sobie jedną niezmienną prawdę';

  @override
  String get qtLoadingHint6 =>
      '🌸 Wdzięczność — Wymień jedną rzecz, za którą jesteś teraz wdzięczny';

  @override
  String get qtLoadingHint7 =>
      '🌊 Przebaczenie — Przywołaj w pamięci kogoś, komu chcesz wybaczyć';

  @override
  String get qtLoadingHint8 =>
      '📖 Mądrość — Zachowaj jedną lekcję z dnia dzisiejszego';

  @override
  String get qtLoadingHint9 =>
      '⏳ Cierpliwość — Pomyśl o tym, na co cicho czekasz';

  @override
  String get qtLoadingHint10 =>
      '✨ Radość — Przypomnij sobie chwilę uśmiechu dzisiaj';

  @override
  String get qtLoadingTitle => 'Przygotowuję dzisiejsze Słowo...';

  @override
  String get coachingTitle => 'Coaching modlitwy';

  @override
  String get coachingLoadingText => 'Rozważamy twoją modlitwę...';

  @override
  String get coachingErrorText => 'Błąd tymczasowy — spróbuj ponownie';

  @override
  String get coachingRetryButton => 'Ponów';

  @override
  String get coachingScoreSpecificity => 'Konkretność';

  @override
  String get coachingScoreGodCentered => 'Skupienie na Bogu';

  @override
  String get coachingScoreActs => 'Równowaga ACTS';

  @override
  String get coachingScoreAuthenticity => 'Autentyczność';

  @override
  String get coachingStrengthsTitle => 'Co zrobiłeś dobrze ✨';

  @override
  String get coachingImprovementsTitle => 'Aby pójść głębiej 💡';

  @override
  String get coachingProCta => 'Odblokuj Coaching modlitwy z Pro';

  @override
  String get coachingLevelBeginner => '🌱 Początkujący';

  @override
  String get coachingLevelGrowing => '🌿 Rozwijający się';

  @override
  String get coachingLevelExpert => '🌳 Ekspert';

  @override
  String get aiPrayerCitationsTitle => 'Odwołania · Cytaty';

  @override
  String get citationTypeQuote => 'Cytat';

  @override
  String get citationTypeScience => 'Badanie';

  @override
  String get citationTypeExample => 'Przykład';

  @override
  String get aiPrayerReadingTime => 'Czytanie 2 min';

  @override
  String get scriptureKeyWordHintTitle => 'Kluczowe słowo dzisiaj';

  @override
  String get bibleLookupReferenceHint =>
      'Odszukaj ten fragment w swojej Biblii i rozważaj go.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Tłumaczenia Biblii';

  @override
  String get settingsBibleTranslationsIntro =>
      'Wersety biblijne w tej aplikacji pochodzą z tłumaczeń w domenie publicznej. Komentarze, modlitwy i historie generowane przez AI są twórczym dziełem Abba.';
}
