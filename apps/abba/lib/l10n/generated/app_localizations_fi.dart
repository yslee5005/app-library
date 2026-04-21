// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Kun rukoilet,\nJumala vastaa.';

  @override
  String get welcomeSubtitle =>
      'Päivittäinen rukous- ja hiljaisuuden hetki -kumppanisi';

  @override
  String get getStarted => 'Aloita';

  @override
  String get loginTitle => 'Tervetuloa Abbaan';

  @override
  String get loginSubtitle => 'Kirjaudu sisään aloittaaksesi rukouksesi matkan';

  @override
  String get signInWithApple => 'Jatka Apple-tilillä';

  @override
  String get signInWithGoogle => 'Jatka Google-tilillä';

  @override
  String get signInWithEmail => 'Jatka sähköpostilla';

  @override
  String greetingMorning(Object name) {
    return 'Hyvää huomenta, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Hyvää iltapäivää, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Hyvää iltaa, $name';
  }

  @override
  String get prayButton => 'Rukoile';

  @override
  String get qtButton => 'Hiljaisuuden hetki';

  @override
  String streakDays(Object count) {
    return '$count päivän rukousputki';
  }

  @override
  String get dailyVerse => 'Päivän jae';

  @override
  String get tabHome => 'Koti';

  @override
  String get tabCalendar => 'Kalenteri';

  @override
  String get tabCommunity => 'Yhteisö';

  @override
  String get tabSettings => 'Asetukset';

  @override
  String get recordingTitle => 'Rukoillaan...';

  @override
  String get recordingPause => 'Tauko';

  @override
  String get recordingResume => 'Jatka';

  @override
  String get finishPrayer => 'Lopeta rukous';

  @override
  String get finishPrayerConfirm => 'Haluatko lopettaa rukouksen?';

  @override
  String get switchToText => 'Kirjoita sen sijaan';

  @override
  String get textInputHint => 'Kirjoita rukouksesi tähän...';

  @override
  String get aiLoadingText => 'Pohditaan rukoustasi...';

  @override
  String get aiLoadingVerse =>
      'Olkaa hiljaa ja tietäkää, että minä olen Jumala.\n— Psalmi 46:10';

  @override
  String get dashboardTitle => 'Rukouspuutarha';

  @override
  String get shareButton => 'Jaa';

  @override
  String get backToHome => 'Takaisin kotiin';

  @override
  String get scriptureTitle => 'Päivän Raamatun sana';

  @override
  String get bibleStoryTitle => 'Raamatun kertomus';

  @override
  String get testimonyTitle => 'Todistukseni';

  @override
  String get testimonyEdit => 'Muokkaa';

  @override
  String get guidanceTitle => 'AI-ohjaus';

  @override
  String get aiPrayerTitle => 'Rukous sinulle';

  @override
  String get originalLangTitle => 'Alkukieli';

  @override
  String get proUnlock => 'Avaa Pro';

  @override
  String get qtPageTitle => 'Aamun puutarha';

  @override
  String get qtMeditateButton => 'Aloita mietiskely';

  @override
  String get qtCompleted => 'Valmis';

  @override
  String get communityTitle => 'Rukouspuutarha';

  @override
  String get filterAll => 'Kaikki';

  @override
  String get filterTestimony => 'Todistus';

  @override
  String get filterPrayerRequest => 'Rukousaihe';

  @override
  String get likeButton => 'Tykkää';

  @override
  String get commentButton => 'Kommentoi';

  @override
  String get saveButton => 'Tallenna';

  @override
  String get replyButton => 'Vastaa';

  @override
  String get writePostTitle => 'Jaa';

  @override
  String get cancelButton => 'Peruuta';

  @override
  String get sharePostButton => 'Julkaise';

  @override
  String get anonymousToggle => 'Nimetön';

  @override
  String get realNameToggle => 'Oikea nimi';

  @override
  String get categoryTestimony => 'Todistus';

  @override
  String get categoryPrayerRequest => 'Rukousaihe';

  @override
  String get writePostHint => 'Jaa todistuksesi tai rukousaiheesi...';

  @override
  String get importFromPrayer => 'Tuo rukouksesta';

  @override
  String get calendarTitle => 'Rukouskalenteri';

  @override
  String get currentStreak => 'Nykyinen putki';

  @override
  String get bestStreak => 'Paras putki';

  @override
  String get days => 'päivää';

  @override
  String calendarRecordCount(Object count) {
    return '$count merkintää';
  }

  @override
  String get todayVerse => 'Päivän jae';

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get profileSection => 'Profiili';

  @override
  String get totalPrayers => 'Rukouksia yhteensä';

  @override
  String get consecutiveDays => 'Peräkkäiset päivät';

  @override
  String get proSection => 'Jäsenyys';

  @override
  String get freePlan => 'Ilmainen';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '6,99€ / kk';

  @override
  String get yearlyPrice => '49,99€ / vuosi';

  @override
  String get yearlySave => 'Säästä 40%';

  @override
  String get launchPromo => '3 kuukautta hintaan 3,99€/kk!';

  @override
  String get startPro => 'Aloita Pro';

  @override
  String get comingSoon => 'Tulossa pian';

  @override
  String get notificationSetting => 'Ilmoitukset';

  @override
  String get languageSetting => 'Kieli';

  @override
  String get darkModeSetting => 'Tumma tila';

  @override
  String get helpCenter => 'Ohjekeskus';

  @override
  String get termsOfService => 'Käyttöehdot';

  @override
  String get privacyPolicy => 'Tietosuojakäytäntö';

  @override
  String get logout => 'Kirjaudu ulos';

  @override
  String appVersion(Object version) {
    return 'Versio $version';
  }

  @override
  String get anonymous => 'Nimetön';

  @override
  String timeAgo(Object time) {
    return '$time sitten';
  }

  @override
  String get emailLabel => 'Sähköposti';

  @override
  String get passwordLabel => 'Salasana';

  @override
  String get signIn => 'Kirjaudu sisään';

  @override
  String get cancel => 'Peruuta';

  @override
  String get noPrayersRecorded => 'Ei tallennettuja rukouksia';

  @override
  String get deletePost => 'Poista';

  @override
  String get reportPost => 'Ilmianna';

  @override
  String get reportSubmitted => 'Ilmianto lähetetty. Kiitos.';

  @override
  String get reportReasonHint =>
      'Kuvaile ilmiannon syy. Se lähetetään sähköpostilla.';

  @override
  String get reportReasonPlaceholder => 'Syötä ilmiannon syy...';

  @override
  String get reportSubmitButton => 'Ilmianna';

  @override
  String get deleteConfirmTitle => 'Poista julkaisu';

  @override
  String get deleteConfirmMessage =>
      'Haluatko varmasti poistaa tämän julkaisun?';

  @override
  String get errorNetwork => 'Tarkista internet-yhteytesi ja yritä uudelleen.';

  @override
  String get errorAiFallback =>
      'Emme saaneet yhteyttä AI:hin juuri nyt. Tässä jae sinulle.';

  @override
  String get errorSttFailed =>
      'Puheentunnistus ei ole käytettävissä. Kirjoita sen sijaan.';

  @override
  String get errorPayment =>
      'Maksussa oli ongelma. Yritä uudelleen Asetuksissa.';

  @override
  String get errorGeneric => 'Jokin meni pieleen. Yritä myöhemmin uudelleen.';

  @override
  String get offlineNotice =>
      'Olet offline-tilassa. Jotkin ominaisuudet voivat olla rajoitettuja.';

  @override
  String get retryButton => 'Yritä uudelleen';

  @override
  String get groupSection => 'Ryhmäni';

  @override
  String get createGroup => 'Luo rukousryhmä';

  @override
  String get inviteFriends => 'Kutsu ystäviä';

  @override
  String get groupInviteMessage =>
      'Rukoillaan yhdessä! Liity rukousryhmääni Abbassa.';

  @override
  String get noGroups => 'Liity tai luo ryhmä rukoillaksesi yhdessä.';

  @override
  String get promoTitle => 'Lanseeraustarjous';

  @override
  String get promoBanner => '3 ensimmäistä kuukautta 3,99€/kk!';

  @override
  String promoEndsOn(Object date) {
    return 'Tarjous päättyy $date';
  }

  @override
  String get proLimitTitle => 'Päivän rukous on valmis';

  @override
  String get proLimitBody => 'Nähdään huomenna!\nRukoile rajattomasti Pro';

  @override
  String get laterButton => 'Ehkä myöhemmin';

  @override
  String get proPromptTitle => 'Pro-ominaisuus';

  @override
  String get proPromptBody =>
      'Tämä ominaisuus on saatavilla Prolla.\nHaluatko nähdä suunnitelmat?';

  @override
  String get viewProducts => 'Näytä suunnitelmat';

  @override
  String get maybeLater => 'Ehkä myöhemmin';

  @override
  String get proHeadline => 'Lähempänä Jumalaa joka päivä';

  @override
  String get proBenefit1 => 'Rajaton rukous & hiljaisuuden hetki';

  @override
  String get proBenefit2 => 'AI-avusteinen rukous & ohjaus';

  @override
  String get proBenefit3 => 'Uskon tarinoita historiasta';

  @override
  String get proBenefit5 => 'Raamatun opiskelu alkukielellä';

  @override
  String get bestValue => 'PARAS ARVO';

  @override
  String get perMonth => 'kk';

  @override
  String get cancelAnytime => 'Peru milloin tahansa';

  @override
  String get restorePurchase => 'Palauta ostos';

  @override
  String get yearlyPriceMonthly => '4,17€/kk';

  @override
  String get morningPrayerReminder => 'Aamurukous';

  @override
  String get eveningGratitudeReminder => 'Iltakiitos';

  @override
  String get streakReminder => 'Putkimuistutus';

  @override
  String get afternoonNudgeReminder => 'Iltapäivän rukousmuistutus';

  @override
  String get weeklySummaryReminder => 'Viikkoyhteenveto';

  @override
  String get unlimited => 'Rajaton';

  @override
  String get streakRecovery => 'Se on okei, voit aloittaa alusta 🌱';

  @override
  String get prayerSaved => 'Rukous tallennettu';

  @override
  String get quietTimeLabel => 'Hiljaisuuden hetki';

  @override
  String get morningPrayerLabel => 'Aamurukous';

  @override
  String get gardenSeed => 'Uskon siemen';

  @override
  String get gardenSprout => 'Kasvava taimi';

  @override
  String get gardenBud => 'Nuppu';

  @override
  String get gardenBloom => 'Täydessä kukassa';

  @override
  String get gardenTree => 'Vahva puu';

  @override
  String get gardenForest => 'Rukouksen metsä';

  @override
  String get milestoneShare => 'Jaa';

  @override
  String get milestoneThankGod => 'Kiitos Jumalalle!';

  @override
  String shareStreakText(Object count) {
    return '$count päivän rukousputki! Rukousmatkani Abban kanssa #Abba #Rukous';
  }

  @override
  String get shareDaysLabel => 'päivän rukousputki';

  @override
  String get shareSubtitle => 'Päivittäinen rukous Jumalan kanssa';

  @override
  String get proActive => 'Jäsenyys Aktiivinen';

  @override
  String get planOncePerDay => '1x/päivä';

  @override
  String get planUnlimited => 'Rajaton';

  @override
  String get closeRecording => 'Sulje nauhoitus';

  @override
  String get qtRevealMessage => 'Avataan päivän Sana';

  @override
  String get qtSelectPrompt =>
      'Valitse aihe ja aloita päivän hiljaisuuden hetki';

  @override
  String get qtTopicLabel => 'Aihe';

  @override
  String get prayerStartPrompt => 'Aloita rukouksesi';

  @override
  String get startPrayerButton => 'Aloita rukous';

  @override
  String get switchToTextMode => 'Kirjoita sen sijaan';

  @override
  String get switchToVoiceMode => 'Puhu';

  @override
  String get prayerDashboardTitle => 'Rukouspuutarha';

  @override
  String get qtDashboardTitle => 'Hiljaisuuden puutarha';

  @override
  String get prayerSummaryTitle => 'Rukousyhteenveto';

  @override
  String get gratitudeLabel => 'Kiitollisuus';

  @override
  String get petitionLabel => 'Anomus';

  @override
  String get intercessionLabel => 'Esirukous';

  @override
  String get historicalStoryTitle => 'Tarina historiasta';

  @override
  String get todayLesson => 'Päivän opetus';

  @override
  String get meditationAnalysisTitle => 'Mietiskelyanalyysi';

  @override
  String get keyThemeLabel => 'Avainteema';

  @override
  String get applicationTitle => 'Päivän sovellus';

  @override
  String get applicationWhat => 'Mitä';

  @override
  String get applicationWhen => 'Milloin';

  @override
  String get applicationContext => 'Missä';

  @override
  String get relatedKnowledgeTitle => 'Liittyvä tieto';

  @override
  String get originalWordLabel => 'Alkuperäinen sana';

  @override
  String get historicalContextLabel => 'Historiallinen konteksti';

  @override
  String get crossReferencesLabel => 'Ristiviittaukset';

  @override
  String get growthStoryTitle => 'Kasvutarina';

  @override
  String get prayerGuideTitle => 'Näin rukoilet Abban kanssa';

  @override
  String get prayerGuide1 => 'Rukoile ääneen tai selkeällä äänellä';

  @override
  String get prayerGuide2 =>
      'Abba kuuntelee rukouksesi ja löytää jakeita, jotka puhuttelevat sydäntäsi';

  @override
  String get prayerGuide3 => 'Voit myös kirjoittaa rukouksesi';

  @override
  String get qtGuideTitle => 'Näin pidät hiljaisuuden hetken Abban kanssa';

  @override
  String get qtGuide1 => 'Lue teksti ja mietiskele hiljaa';

  @override
  String get qtGuide2 => 'Jaa löytösi — puhu tai kirjoita pohdintasi';

  @override
  String get qtGuide3 => 'Abba auttaa sinua soveltamaan Sanaa arkielämässäsi';

  @override
  String get scriptureReasonLabel => 'Miksi tämä jae';

  @override
  String get seeMore => 'Näytä lisää';

  @override
  String seeAllComments(Object count) {
    return 'Näytä kaikki $count kommenttia';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name ja $count muuta tykkäsi tästä';
  }

  @override
  String get commentsTitle => 'Kommentit';

  @override
  String get myPageTitle => 'Rukouspuutarhani';

  @override
  String get myPrayers => 'Rukoukseni';

  @override
  String get myTestimonies => 'Todistukseni';

  @override
  String get savedPosts => 'Tallennetut';

  @override
  String get totalPrayersCount => 'Rukoukset';

  @override
  String get streakCount => 'Putki';

  @override
  String get testimoniesCount => 'Todistukset';

  @override
  String get linkAccountTitle => 'Yhdistä tili';

  @override
  String get linkAccountDescription =>
      'Yhdistä tilisi säilyttääksesi rukoushistorian laitetta vaihtaessasi';

  @override
  String get linkWithApple => 'Yhdistä Appleen';

  @override
  String get linkWithGoogle => 'Yhdistä Googleen';

  @override
  String get linkAccountSuccess => 'Tili yhdistetty!';

  @override
  String get anonymousUser => 'Rukoussotija';

  @override
  String showReplies(Object count) {
    return 'Näytä $count vastausta';
  }

  @override
  String get hideReplies => 'Piilota vastaukset';

  @override
  String replyingTo(Object name) {
    return 'Vastataan käyttäjälle $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Näytä kaikki $count kommenttia';
  }

  @override
  String get membershipTitle => 'Jäsenyys';

  @override
  String get membershipSubtitle => 'Syvennä rukouselämääsi';

  @override
  String get monthlyPlan => 'Kuukausittain';

  @override
  String get yearlyPlan => 'Vuosittain';

  @override
  String get yearlySavings => '4,17€/kk (40% alennus)';

  @override
  String get startMembership => 'Aloita';

  @override
  String get membershipActive => 'Jäsenyys Aktiivinen';

  @override
  String get leaveRecordingTitle => 'Poistu nauhoituksesta?';

  @override
  String get leaveRecordingMessage => 'Nauhoituksesi menetetään. Oletko varma?';

  @override
  String get leaveButton => 'Poistu';

  @override
  String get stayButton => 'Jää';

  @override
  String likedByCount(Object count) {
    return '$count ihmistä myötäeli';
  }

  @override
  String get actionLike => 'Tykkää';

  @override
  String get actionComment => 'Kommentti';

  @override
  String get actionSave => 'Tallenna';
}
