// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle =>
      'Kapag ikaw ay nananalangin,\ntumutugon ang Diyos.';

  @override
  String get welcomeSubtitle =>
      'Ang iyong araw-araw na kasama sa panalangin at quiet time';

  @override
  String get getStarted => 'Magsimula';

  @override
  String get loginTitle => 'Maligayang pagdating sa Abba';

  @override
  String get loginSubtitle =>
      'Mag-sign in upang simulan ang iyong paglalakbay sa panalangin';

  @override
  String get signInWithApple => 'Magpatuloy sa Apple';

  @override
  String get signInWithGoogle => 'Magpatuloy sa Google';

  @override
  String get signInWithEmail => 'Magpatuloy sa Email';

  @override
  String greetingMorning(Object name) {
    return 'Magandang umaga, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Magandang hapon, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Magandang gabi, $name';
  }

  @override
  String get prayButton => 'Manalangin';

  @override
  String get qtButton => 'Quiet Time';

  @override
  String streakDays(Object count) {
    return '$count araw na sunod-sunod na panalangin';
  }

  @override
  String get dailyVerse => 'Talata ng Araw';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCalendar => 'Kalendaryo';

  @override
  String get tabCommunity => 'Komunidad';

  @override
  String get tabSettings => 'Settings';

  @override
  String get recordingTitle => 'Nananalangin...';

  @override
  String get recordingPause => 'I-pause';

  @override
  String get recordingResume => 'Ituloy';

  @override
  String get finishPrayer => 'Tapusin ang Panalangin';

  @override
  String get finishPrayerConfirm =>
      'Nais mo bang tapusin ang iyong panalangin?';

  @override
  String get switchToText => 'I-type na lang';

  @override
  String get textInputHint => 'I-type ang iyong panalangin dito...';

  @override
  String get aiLoadingText => 'Pinagninilayan ang iyong panalangin...';

  @override
  String get aiLoadingVerse =>
      'Tumahimik kayo at kilalanin ninyo na ako ang Diyos.\n— Awit 46:10';

  @override
  String get dashboardTitle => 'Hardin ng Panalangin';

  @override
  String get shareButton => 'I-share';

  @override
  String get backToHome => 'Bumalik sa Home';

  @override
  String get scriptureTitle => 'Kasulatan Ngayong Araw';

  @override
  String get bibleStoryTitle => 'Kwento sa Bibliya';

  @override
  String get testimonyTitle => 'Patotoo · Aking dasal';

  @override
  String get testimonyHelperText =>
      'Pagnilayan ang iyong dasal · pwedeng ibahagi sa komunidad';

  @override
  String get myPrayerAudioLabel => 'Rekording ng aking dasal';

  @override
  String get testimonyEdit => 'I-edit';

  @override
  String get guidanceTitle => 'AI Gabay';

  @override
  String get aiPrayerTitle => 'Isang Panalangin para sa Iyo';

  @override
  String get originalLangTitle => 'Orihinal na Wika';

  @override
  String get proUnlock => 'I-unlock sa Pro';

  @override
  String get qtPageTitle => 'Hardin sa Umaga';

  @override
  String get qtMeditateButton => 'Simulan ang Pagbubulay-bulay';

  @override
  String get qtCompleted => 'Tapos na';

  @override
  String get communityTitle => 'Hardin ng Panalangin';

  @override
  String get filterAll => 'Lahat';

  @override
  String get filterTestimony => 'Testimonya';

  @override
  String get filterPrayerRequest => 'Prayer Request';

  @override
  String get likeButton => 'Like';

  @override
  String get commentButton => 'Comment';

  @override
  String get saveButton => 'I-save';

  @override
  String get replyButton => 'Reply';

  @override
  String get writePostTitle => 'I-share';

  @override
  String get cancelButton => 'Kanselahin';

  @override
  String get sharePostButton => 'I-share';

  @override
  String get anonymousToggle => 'Anonymous';

  @override
  String get realNameToggle => 'Tunay na Pangalan';

  @override
  String get categoryTestimony => 'Testimonya';

  @override
  String get categoryPrayerRequest => 'Prayer Request';

  @override
  String get writePostHint =>
      'Ibahagi ang iyong testimonya o prayer request...';

  @override
  String get importFromPrayer => 'I-import mula sa panalangin';

  @override
  String get calendarTitle => 'Kalendaryo ng Panalangin';

  @override
  String get currentStreak => 'Kasalukuyang Streak';

  @override
  String get bestStreak => 'Pinakamataas na Streak';

  @override
  String get days => 'araw';

  @override
  String calendarRecordCount(Object count) {
    return '$count tala';
  }

  @override
  String get todayVerse => 'Talata Ngayong Araw';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profileSection => 'Profile';

  @override
  String get totalPrayers => 'Kabuuang Panalangin';

  @override
  String get consecutiveDays => 'Sunod-sunod na Araw';

  @override
  String get proSection => 'Membership';

  @override
  String get freePlan => 'Libre';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '₱399 / buwan';

  @override
  String get yearlyPrice => '₱2,990 / taon';

  @override
  String get yearlySave => 'Makatipid ng 40%';

  @override
  String get launchPromo => '3 buwan sa ₱117/buwan!';

  @override
  String get startPro => 'Simulan ang Pro';

  @override
  String get comingSoon => 'Malapit na';

  @override
  String get notificationSetting => 'Mga Notification';

  @override
  String get languageSetting => 'Wika';

  @override
  String get darkModeSetting => 'Dark Mode';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get termsOfService => 'Mga Tuntunin ng Serbisyo';

  @override
  String get privacyPolicy => 'Patakaran sa Privacy';

  @override
  String get logout => 'Mag-log Out';

  @override
  String appVersion(Object version) {
    return 'Bersyon $version';
  }

  @override
  String get anonymous => 'Anonymous';

  @override
  String timeAgo(Object time) {
    return '$time nakalipas';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signIn => 'Mag-sign In';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get noPrayersRecorded => 'Walang naitala na panalangin';

  @override
  String get deletePost => 'I-delete';

  @override
  String get reportPost => 'I-report';

  @override
  String get reportSubmitted => 'Nai-submit na ang report. Salamat.';

  @override
  String get reportReasonHint =>
      'Ilarawan ang dahilan ng pag-report. Ipapadala ito sa email.';

  @override
  String get reportReasonPlaceholder => 'Ilagay ang dahilan ng pag-report...';

  @override
  String get reportSubmitButton => 'I-report';

  @override
  String get deleteConfirmTitle => 'I-delete ang Post';

  @override
  String get deleteConfirmMessage =>
      'Sigurado ka bang gusto mong i-delete ang post na ito?';

  @override
  String get errorNetwork =>
      'Pakisuri ang iyong koneksyon sa internet at subukan muli.';

  @override
  String get errorAiFallback =>
      'Hindi namin maabot ang AI sa ngayon. Narito ang isang talata para sa iyo.';

  @override
  String get errorSttFailed =>
      'Hindi available ang voice recognition. Pakitype na lang.';

  @override
  String get errorPayment =>
      'May problema sa pagbabayad. Pakisubukan muli sa Settings.';

  @override
  String get errorGeneric => 'May nangyaring mali. Pakisubukan muli mamaya.';

  @override
  String get offlineNotice =>
      'Ikaw ay offline. Maaaring limitado ang ilang features.';

  @override
  String get retryButton => 'Subukan Muli';

  @override
  String get groupSection => 'Mga Grupo Ko';

  @override
  String get createGroup => 'Gumawa ng Prayer Group';

  @override
  String get inviteFriends => 'Mag-imbita ng Kaibigan';

  @override
  String get groupInviteMessage =>
      'Manalangin tayo nang sama-sama! Sumali sa aking prayer group sa Abba.';

  @override
  String get noGroups =>
      'Sumali o gumawa ng grupo para manalangin nang sama-sama.';

  @override
  String get promoTitle => 'Launch Special';

  @override
  String get promoBanner => 'Unang 3 buwan sa ₱117/buwan!';

  @override
  String promoEndsOn(Object date) {
    return 'Ang alok ay hanggang $date';
  }

  @override
  String get proLimitTitle => 'Tapos na ang panalangin ngayong araw';

  @override
  String get proLimitBody =>
      'Magkita-kita bukas!\nManalangin nang walang limitasyon sa Pro';

  @override
  String get laterButton => 'Mamaya na';

  @override
  String get proPromptTitle => 'Pro Feature';

  @override
  String get proPromptBody =>
      'Ang feature na ito ay available sa Pro.\nGusto mo bang tingnan ang mga plano?';

  @override
  String get viewProducts => 'Tingnan ang mga Plano';

  @override
  String get maybeLater => 'Mamaya na';

  @override
  String get proHeadline => 'Mas malapit sa Diyos, araw-araw';

  @override
  String get proBenefit1 => 'Walang limitasyong Panalangin at QT';

  @override
  String get proBenefit2 => 'AI-powered na panalangin at gabay';

  @override
  String get proBenefit3 => 'Mga kwento ng pananampalataya mula sa kasaysayan';

  @override
  String get proBenefit5 => 'Pag-aaral ng Bibliya sa orihinal na wika';

  @override
  String get bestValue => 'PINAKAMAHUSAY NA HALAGA';

  @override
  String get perMonth => 'buwan';

  @override
  String get cancelAnytime => 'Kanselahin kahit kailan';

  @override
  String get restorePurchase => 'I-restore ang binili';

  @override
  String get yearlyPriceMonthly => '₱249/buwan';

  @override
  String get morningPrayerReminder => 'Panalangin sa Umaga';

  @override
  String get eveningGratitudeReminder => 'Pasasalamat sa Gabi';

  @override
  String get streakReminder => 'Paalala ng Streak';

  @override
  String get afternoonNudgeReminder => 'Paalala ng Panalangin sa Hapon';

  @override
  String get weeklySummaryReminder => 'Lingguhang Buod';

  @override
  String get unlimited => 'Walang limitasyon';

  @override
  String get streakRecovery => 'Okay lang, pwede kang magsimula ulit 🌱';

  @override
  String get prayerSaved => 'Matagumpay na na-save ang panalangin';

  @override
  String get quietTimeLabel => 'Quiet Time';

  @override
  String get morningPrayerLabel => 'Panalangin sa Umaga';

  @override
  String get gardenSeed => 'Isang binhi ng pananampalataya';

  @override
  String get gardenSprout => 'Lumalaking sibol';

  @override
  String get gardenBud => 'Umuusbong na bulaklak';

  @override
  String get gardenBloom => 'Ganap na pamumukadkad';

  @override
  String get gardenTree => 'Matatag na puno';

  @override
  String get gardenForest => 'Kagubatan ng panalangin';

  @override
  String get milestoneShare => 'I-share';

  @override
  String get milestoneThankGod => 'Salamat sa Diyos!';

  @override
  String shareStreakText(Object count) {
    return '$count araw na sunod-sunod na panalangin! Ang aking paglalakbay sa panalangin kasama ang Abba #Abba #Panalangin';
  }

  @override
  String get shareDaysLabel => 'araw na sunod-sunod na panalangin';

  @override
  String get shareSubtitle => 'Araw-araw na panalangin kasama ang Diyos';

  @override
  String get proActive => 'Membership Aktibo';

  @override
  String get planOncePerDay => '1x/araw';

  @override
  String get planUnlimited => 'Walang limitasyon';

  @override
  String get closeRecording => 'Isara ang recording';

  @override
  String get qtRevealMessage => 'Buksan natin ang Salita ngayong araw';

  @override
  String get qtSelectPrompt => 'Pumili at simulan ang QT ngayong araw';

  @override
  String get qtTopicLabel => 'Paksa';

  @override
  String get prayerStartPrompt => 'Simulan ang iyong panalangin';

  @override
  String get startPrayerButton => 'Magsimulang Manalangin';

  @override
  String get switchToTextMode => 'I-type na lang';

  @override
  String get switchToVoiceMode => 'Magsalita';

  @override
  String get prayerDashboardTitle => 'Hardin ng Panalangin';

  @override
  String get qtDashboardTitle => 'Hardin ng QT';

  @override
  String get prayerSummaryTitle => 'Buod ng Panalangin';

  @override
  String get gratitudeLabel => 'Pasasalamat';

  @override
  String get petitionLabel => 'Kahilingan';

  @override
  String get intercessionLabel => 'Pamamagitan';

  @override
  String get historicalStoryTitle => 'Kwento mula sa Kasaysayan';

  @override
  String get todayLesson => 'Aral Ngayong Araw';

  @override
  String get meditationAnalysisTitle => 'Pagsusuri ng Pagbubulay-bulay';

  @override
  String get keyThemeLabel => 'Pangunahing Tema';

  @override
  String get applicationTitle => 'Aplikasyon Ngayong Araw';

  @override
  String get applicationWhat => 'Ano';

  @override
  String get applicationWhen => 'Kailan';

  @override
  String get applicationContext => 'Saan';

  @override
  String get applicationMorningLabel => 'Umaga';

  @override
  String get applicationDayLabel => 'Araw';

  @override
  String get applicationEveningLabel => 'Gabi';

  @override
  String get relatedKnowledgeTitle => 'Kaugnay na Kaalaman';

  @override
  String get originalWordLabel => 'Orihinal na Salita';

  @override
  String get historicalContextLabel => 'Kontekstong Pangkasaysayan';

  @override
  String get crossReferencesLabel => 'Mga Cross Reference';

  @override
  String get growthStoryTitle => 'Kwento ng Paglago';

  @override
  String get prayerGuideTitle => 'Paano manalangin kasama ang Abba';

  @override
  String get prayerGuide1 => 'Manalangin nang malakas o malinaw na boses';

  @override
  String get prayerGuide2 =>
      'Nakikinig ang Abba sa iyong mga salita at naghahanap ng Kasulatan na nagsasalita sa iyong puso';

  @override
  String get prayerGuide3 =>
      'Pwede mo ring i-type ang iyong panalangin kung gusto mo';

  @override
  String get qtGuideTitle => 'Paano mag-QT kasama ang Abba';

  @override
  String get qtGuide1 => 'Basahin ang talata at tahimik na magbulay-bulay';

  @override
  String get qtGuide2 =>
      'Ibahagi ang iyong natuklasan — magsalita o mag-type ng iyong repleksyon';

  @override
  String get qtGuide3 =>
      'Tutulungan ka ng Abba na ilapat ang Salita sa iyong pang-araw-araw na buhay';

  @override
  String get scriptureReasonLabel => 'Bakit ang Kasulatang ito';

  @override
  String get scripturePostureLabel => 'Sa anong pag-iisip ko ito babasahin?';

  @override
  String get scriptureOriginalWordsTitle =>
      'Mas malalim na kahulugan sa orihinal na wika';

  @override
  String get originalWordMeaningLabel => 'Kahulugan';

  @override
  String get originalWordNuanceLabel => 'Nuance vs pagsasalin';

  @override
  String originalWordsCountLabel(int count) {
    return '$count salita';
  }

  @override
  String get seeMore => 'Tingnan pa';

  @override
  String seeAllComments(Object count) {
    return 'Tingnan lahat ng $count komento';
  }

  @override
  String likedBy(Object name, Object count) {
    return 'Ni-like ni $name at $count iba pa';
  }

  @override
  String get commentsTitle => 'Mga Komento';

  @override
  String get myPageTitle => 'Aking Hardin ng Panalangin';

  @override
  String get myPrayers => 'Mga Panalangin Ko';

  @override
  String get myTestimonies => 'Mga Testimonya Ko';

  @override
  String get savedPosts => 'Na-save';

  @override
  String get totalPrayersCount => 'Mga Panalangin';

  @override
  String get streakCount => 'Streak';

  @override
  String get testimoniesCount => 'Mga Testimonya';

  @override
  String get linkAccountTitle => 'I-link ang Account';

  @override
  String get linkAccountDescription =>
      'I-link ang iyong account upang mapanatili ang mga tala ng panalangin kapag nagpalit ng device';

  @override
  String get linkWithApple => 'I-link sa Apple';

  @override
  String get linkWithGoogle => 'I-link sa Google';

  @override
  String get linkAccountSuccess => 'Matagumpay na na-link ang account!';

  @override
  String get anonymousUser => 'Mandirigma ng Panalangin';

  @override
  String showReplies(Object count) {
    return 'Tingnan ang $count reply';
  }

  @override
  String get hideReplies => 'Itago ang mga reply';

  @override
  String replyingTo(Object name) {
    return 'Tumutugon kay $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Tingnan lahat ng $count komento';
  }

  @override
  String get membershipTitle => 'Membership';

  @override
  String get membershipSubtitle => 'Palalimin ang iyong buhay-panalangin';

  @override
  String get monthlyPlan => 'Buwanan';

  @override
  String get yearlyPlan => 'Taunan';

  @override
  String get yearlySavings => '₱150/buwan (40% diskwento)';

  @override
  String get startMembership => 'Magsimula';

  @override
  String get membershipActive => 'Membership Aktibo';

  @override
  String get leaveRecordingTitle => 'Umalis sa recording?';

  @override
  String get leaveRecordingMessage =>
      'Mawawala ang iyong recording. Sigurado ka ba?';

  @override
  String get leaveButton => 'Umalis';

  @override
  String get stayButton => 'Manatili';

  @override
  String likedByCount(Object count) {
    return '$count tao ang nakiramay';
  }

  @override
  String get actionLike => 'Like';

  @override
  String get actionComment => 'Komento';

  @override
  String get actionSave => 'I-save';

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
      '💛 Pag-ibig — Isipin ang isang mahal mo sa loob ng 10 segundo';

  @override
  String get qtLoadingHint2 =>
      '🌿 Biyaya — Alalahanin ang isang maliit na biyayang natanggap ngayon';

  @override
  String get qtLoadingHint3 =>
      '🌅 Pag-asa — Isipin ang isang maliit na pag-asa para bukas';

  @override
  String get qtLoadingHint4 =>
      '🕊️ Kapayapaan — Huminga nang malalim ng tatlong beses, dahan-dahan';

  @override
  String get qtLoadingHint5 =>
      '🌳 Pananampalataya — Alalahanin ang isang katotohanang hindi nagbabago';

  @override
  String get qtLoadingHint6 =>
      '🌸 Pasasalamat — Pangalanan ang isang bagay na ipinagpapasalamat mo ngayon';

  @override
  String get qtLoadingHint7 =>
      '🌊 Kapatawaran — Isipin ang isang taong nais mong patawarin';

  @override
  String get qtLoadingHint8 =>
      '📖 Karunungan — Itago sa puso ang isang aral ngayong araw';

  @override
  String get qtLoadingHint9 =>
      '⏳ Pagtitiis — Isipin ang tahimik mong hinihintay';

  @override
  String get qtLoadingHint10 =>
      '✨ Kagalakan — Alalahanin ang isang sandali ng ngiti ngayon';

  @override
  String get qtLoadingTitle => 'Inihahanda ang Salita ngayon...';

  @override
  String get coachingTitle => 'Coaching sa Panalangin';

  @override
  String get coachingLoadingText => 'Nag-iisip tungkol sa iyong panalangin...';

  @override
  String get coachingErrorText => 'Pansamantalang error — subukan muli';

  @override
  String get coachingRetryButton => 'Subukan muli';

  @override
  String get coachingScoreSpecificity => 'Kasipagan';

  @override
  String get coachingScoreGodCentered => 'Nakasentro sa Diyos';

  @override
  String get coachingScoreActs => 'Balanse ng ACTS';

  @override
  String get coachingScoreAuthenticity => 'Pagiging tunay';

  @override
  String get coachingStrengthsTitle => 'Magaling mong ginawa ✨';

  @override
  String get coachingImprovementsTitle => 'Upang palalimin 💡';

  @override
  String get coachingProCta =>
      'I-unlock ang Coaching sa Panalangin gamit ang Pro';

  @override
  String get coachingLevelBeginner => '🌱 Baguhan';

  @override
  String get coachingLevelGrowing => '🌿 Lumalago';

  @override
  String get coachingLevelExpert => '🌳 Eksperto';

  @override
  String get aiPrayerCitationsTitle => 'Mga Sanggunian · Sipi';

  @override
  String get citationTypeQuote => 'Sipi';

  @override
  String get citationTypeScience => 'Pananaliksik';

  @override
  String get citationTypeExample => 'Halimbawa';

  @override
  String get citationTypeHistory => 'Kasaysayan';

  @override
  String get aiPrayerReadingTime => '2-minutong pagbasa';

  @override
  String get scriptureKeyWordHintTitle => 'Susing salita ngayong araw';

  @override
  String get bibleLookupReferenceHint =>
      'Hanapin ang talatang ito sa inyong Bibliya at pag-isipan ito.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Mga Pagsasalin ng Bibliya';

  @override
  String get settingsBibleTranslationsIntro =>
      'Ang mga talata ng Bibliya sa app na ito ay mula sa mga pagsasalin sa pampublikong domain. Ang mga komentaryo, panalangin, at kuwento na binuo ng AI ay malikhaing gawa ng Abba.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'QT Coaching';

  @override
  String get qtCoachingLoadingText =>
      'Nag-iisip tungkol sa iyong pagninilay...';

  @override
  String get qtCoachingErrorText => 'Pansamantalang error — subukan muli';

  @override
  String get qtCoachingRetryButton => 'Subukan muli';

  @override
  String get qtCoachingScoreComprehension => 'Pag-unawa sa Kasulatan';

  @override
  String get qtCoachingScoreApplication => 'Personal na aplikasyon';

  @override
  String get qtCoachingScoreDepth => 'Espirituwal na lalim';

  @override
  String get qtCoachingScoreAuthenticity => 'Pagiging tunay';

  @override
  String get qtCoachingStrengthsTitle => 'Magaling mong ginawa ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Upang palalimin 💡';

  @override
  String get qtCoachingProCta => 'I-unlock ang QT Coaching gamit ang Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Baguhan';

  @override
  String get qtCoachingLevelGrowing => '🌿 Lumalago';

  @override
  String get qtCoachingLevelExpert => '🌳 Eksperto';
}
