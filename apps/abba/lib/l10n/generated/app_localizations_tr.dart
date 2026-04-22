// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Dua ettiğinde,\nTanrı cevap verir.';

  @override
  String get welcomeSubtitle => 'Günlük dua ve sessiz zaman arkadaşın';

  @override
  String get getStarted => 'Başla';

  @override
  String get loginTitle => 'Abba\'ya Hoş Geldiniz';

  @override
  String get loginSubtitle => 'Dua yolculuğunuza başlamak için giriş yapın';

  @override
  String get signInWithApple => 'Apple ile devam et';

  @override
  String get signInWithGoogle => 'Google ile devam et';

  @override
  String get signInWithEmail => 'E-posta ile devam et';

  @override
  String greetingMorning(Object name) {
    return 'Günaydın, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'İyi günler, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'İyi akşamlar, $name';
  }

  @override
  String get prayButton => 'Dua Et';

  @override
  String get qtButton => 'Sessiz Zaman';

  @override
  String streakDays(Object count) {
    return '$count gün kesintisiz dua';
  }

  @override
  String get dailyVerse => 'Günün Ayeti';

  @override
  String get tabHome => 'Ana Sayfa';

  @override
  String get tabCalendar => 'Takvim';

  @override
  String get tabCommunity => 'Topluluk';

  @override
  String get tabSettings => 'Ayarlar';

  @override
  String get recordingTitle => 'Dua ediliyor...';

  @override
  String get recordingPause => 'Duraklat';

  @override
  String get recordingResume => 'Devam Et';

  @override
  String get finishPrayer => 'Duayı Bitir';

  @override
  String get finishPrayerConfirm => 'Duanızı bitirmek ister misiniz?';

  @override
  String get switchToText => 'Yazarak devam et';

  @override
  String get textInputHint => 'Duanızı buraya yazın...';

  @override
  String get aiLoadingText => 'Duanız üzerine düşünülüyor...';

  @override
  String get aiLoadingVerse =>
      'Sakin olun ve bilin ki ben Tanrı\'yım.\n— Mezmur 46:10';

  @override
  String get dashboardTitle => 'Dua Bahçesi';

  @override
  String get shareButton => 'Paylaş';

  @override
  String get backToHome => 'Ana sayfaya dön';

  @override
  String get scriptureTitle => 'Bugünün Kutsal Yazısı';

  @override
  String get bibleStoryTitle => 'Kutsal Kitap Hikayesi';

  @override
  String get testimonyTitle => 'Şahitlik · Duam';

  @override
  String get testimonyHelperText =>
      'Duanızı yansıtın · toplulukla paylaşılabilir';

  @override
  String get myPrayerAudioLabel => 'Dua kaydım';

  @override
  String get testimonyEdit => 'Düzenle';

  @override
  String get guidanceTitle => 'AI Rehberliği';

  @override
  String get aiPrayerTitle => 'Sizin İçin Bir Dua';

  @override
  String get originalLangTitle => 'Orijinal Dil';

  @override
  String get proUnlock => 'Pro ile Aç';

  @override
  String get qtPageTitle => 'Sabah Bahçesi';

  @override
  String get qtMeditateButton => 'Meditasyona Başla';

  @override
  String get qtCompleted => 'Tamamlandı';

  @override
  String get communityTitle => 'Dua Bahçesi';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterTestimony => 'Tanıklık';

  @override
  String get filterPrayerRequest => 'Dua İsteği';

  @override
  String get likeButton => 'Beğen';

  @override
  String get commentButton => 'Yorum';

  @override
  String get saveButton => 'Kaydet';

  @override
  String get replyButton => 'Yanıtla';

  @override
  String get writePostTitle => 'Paylaş';

  @override
  String get cancelButton => 'İptal';

  @override
  String get sharePostButton => 'Paylaş';

  @override
  String get anonymousToggle => 'Anonim';

  @override
  String get realNameToggle => 'Gerçek Ad';

  @override
  String get categoryTestimony => 'Tanıklık';

  @override
  String get categoryPrayerRequest => 'Dua İsteği';

  @override
  String get writePostHint => 'Tanıklığınızı veya dua isteğinizi paylaşın...';

  @override
  String get importFromPrayer => 'Duadan içe aktar';

  @override
  String get calendarTitle => 'Dua Takvimi';

  @override
  String get currentStreak => 'Mevcut Seri';

  @override
  String get bestStreak => 'En İyi Seri';

  @override
  String get days => 'gün';

  @override
  String calendarRecordCount(Object count) {
    return '$count kayıt';
  }

  @override
  String get todayVerse => 'Bugünün Ayeti';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Toplam Dua';

  @override
  String get consecutiveDays => 'Ardışık Gün';

  @override
  String get proSection => 'Üyelik';

  @override
  String get freePlan => 'Ücretsiz';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '₺219 / ay';

  @override
  String get yearlyPrice => '₺1.590 / yıl';

  @override
  String get yearlySave => '%40 Tasarruf';

  @override
  String get launchPromo => '3 ay boyunca ₺129/ay!';

  @override
  String get startPro => 'Pro Başlat';

  @override
  String get comingSoon => 'Yakında';

  @override
  String get notificationSetting => 'Bildirimler';

  @override
  String get languageSetting => 'Dil';

  @override
  String get darkModeSetting => 'Karanlık Mod';

  @override
  String get helpCenter => 'Yardım Merkezi';

  @override
  String get termsOfService => 'Kullanım Koşulları';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String appVersion(Object version) {
    return 'Sürüm $version';
  }

  @override
  String get anonymous => 'Anonim';

  @override
  String timeAgo(Object time) {
    return '$time önce';
  }

  @override
  String get emailLabel => 'E-posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get cancel => 'İptal';

  @override
  String get noPrayersRecorded => 'Kayıtlı dua yok';

  @override
  String get deletePost => 'Sil';

  @override
  String get reportPost => 'Şikayet Et';

  @override
  String get reportSubmitted => 'Şikayet gönderildi. Teşekkürler.';

  @override
  String get reportReasonHint =>
      'Lütfen şikayet nedenini açıklayın. E-posta ile gönderilecektir.';

  @override
  String get reportReasonPlaceholder => 'Şikayet nedenini girin...';

  @override
  String get reportSubmitButton => 'Şikayet Et';

  @override
  String get deleteConfirmTitle => 'Gönderiyi Sil';

  @override
  String get deleteConfirmMessage =>
      'Bu gönderiyi silmek istediğinizden emin misiniz?';

  @override
  String get errorNetwork =>
      'Lütfen internet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get errorAiFallback =>
      'AI\'ya şu an ulaşamadık. İşte sizin için bir ayet.';

  @override
  String get errorSttFailed =>
      'Ses tanıma kullanılamıyor. Lütfen yazarak devam edin.';

  @override
  String get errorPayment =>
      'Ödemede bir sorun oluştu. Lütfen Ayarlar\'dan tekrar deneyin.';

  @override
  String get errorGeneric =>
      'Bir şeyler ters gitti. Lütfen daha sonra tekrar deneyin.';

  @override
  String get offlineNotice =>
      'Çevrimdışısınız. Bazı özellikler sınırlı olabilir.';

  @override
  String get retryButton => 'Tekrar Dene';

  @override
  String get groupSection => 'Gruplarım';

  @override
  String get createGroup => 'Dua Grubu Oluştur';

  @override
  String get inviteFriends => 'Arkadaşları Davet Et';

  @override
  String get groupInviteMessage =>
      'Birlikte dua edelim! Abba\'daki dua grubuma katıl.';

  @override
  String get noGroups =>
      'Birlikte dua etmek için bir gruba katılın veya oluşturun.';

  @override
  String get promoTitle => 'Lansman Özel';

  @override
  String get promoBanner => 'İlk 3 ay ₺129/ay!';

  @override
  String promoEndsOn(Object date) {
    return 'Teklif $date tarihinde sona erer';
  }

  @override
  String get proLimitTitle => 'Bugünkü dua tamamlandı';

  @override
  String get proLimitBody => 'Yarın görüşmek üzere!\nPro ile sınırsız dua edin';

  @override
  String get laterButton => 'Daha sonra';

  @override
  String get proPromptTitle => 'Pro Özellik';

  @override
  String get proPromptBody =>
      'Bu özellik Pro ile kullanılabilir.\nPlanları görmek ister misiniz?';

  @override
  String get viewProducts => 'Planları Gör';

  @override
  String get maybeLater => 'Belki sonra';

  @override
  String get proHeadline => 'Her gün Tanrı\'ya daha yakın';

  @override
  String get proBenefit1 => 'Sınırsız Dua & Sessiz Zaman';

  @override
  String get proBenefit2 => 'AI destekli dua & rehberlik';

  @override
  String get proBenefit3 => 'Tarihten iman hikayeleri';

  @override
  String get proBenefit5 => 'Orijinal dilde Kutsal Kitap çalışması';

  @override
  String get bestValue => 'EN İYİ DEĞer';

  @override
  String get perMonth => 'ay';

  @override
  String get cancelAnytime => 'İstediğiniz zaman iptal edin';

  @override
  String get restorePurchase => 'Satın almayı geri yükle';

  @override
  String get yearlyPriceMonthly => '₺133/ay';

  @override
  String get morningPrayerReminder => 'Sabah Duası';

  @override
  String get eveningGratitudeReminder => 'Akşam Şükrü';

  @override
  String get streakReminder => 'Seri Hatırlatıcı';

  @override
  String get afternoonNudgeReminder => 'Öğleden Sonra Dua Hatırlatması';

  @override
  String get weeklySummaryReminder => 'Haftalık Özet';

  @override
  String get unlimited => 'Sınırsız';

  @override
  String get streakRecovery => 'Sorun değil, yeniden başlayabilirsin 🌱';

  @override
  String get prayerSaved => 'Dua başarıyla kaydedildi';

  @override
  String get quietTimeLabel => 'Sessiz Zaman';

  @override
  String get morningPrayerLabel => 'Sabah Duası';

  @override
  String get gardenSeed => 'İman tohumu';

  @override
  String get gardenSprout => 'Büyüyen filiz';

  @override
  String get gardenBud => 'Tomurcuk';

  @override
  String get gardenBloom => 'Tam çiçek';

  @override
  String get gardenTree => 'Güçlü ağaç';

  @override
  String get gardenForest => 'Dua ormanı';

  @override
  String get milestoneShare => 'Paylaş';

  @override
  String get milestoneThankGod => 'Tanrı\'ya Şükür!';

  @override
  String shareStreakText(Object count) {
    return '$count gün kesintisiz dua! Abba ile dua yolculuğum #Abba #Dua';
  }

  @override
  String get shareDaysLabel => 'gün kesintisiz dua';

  @override
  String get shareSubtitle => 'Tanrı ile günlük dua';

  @override
  String get proActive => 'Üyelik Aktif';

  @override
  String get planOncePerDay => 'Günde 1';

  @override
  String get planUnlimited => 'Sınırsız';

  @override
  String get closeRecording => 'Kaydı kapat';

  @override
  String get qtRevealMessage => 'Bugünün Sözünü açalım';

  @override
  String get qtSelectPrompt =>
      'Birini seçin ve bugünkü sessiz zamanınıza başlayın';

  @override
  String get qtTopicLabel => 'Konu';

  @override
  String get prayerStartPrompt => 'Duanıza başlayın';

  @override
  String get startPrayerButton => 'Duaya Başla';

  @override
  String get switchToTextMode => 'Yazarak devam et';

  @override
  String get switchToVoiceMode => 'Konus';

  @override
  String get prayerDashboardTitle => 'Dua Bahçesi';

  @override
  String get qtDashboardTitle => 'Sessiz Zaman Bahçesi';

  @override
  String get prayerSummaryTitle => 'Dua Özeti';

  @override
  String get gratitudeLabel => 'Şükür';

  @override
  String get petitionLabel => 'Dilekçe';

  @override
  String get intercessionLabel => 'Şefaat';

  @override
  String get historicalStoryTitle => 'Tarihten Bir Hikaye';

  @override
  String get todayLesson => 'Bugünün Dersi';

  @override
  String get meditationAnalysisTitle => 'Tefekkür Analizi';

  @override
  String get keyThemeLabel => 'Ana Tema';

  @override
  String get applicationTitle => 'Bugünün Uygulaması';

  @override
  String get applicationWhat => 'Ne';

  @override
  String get applicationWhen => 'Ne zaman';

  @override
  String get applicationContext => 'Nerede';

  @override
  String get relatedKnowledgeTitle => 'İlgili Bilgi';

  @override
  String get originalWordLabel => 'Orijinal Kelime';

  @override
  String get historicalContextLabel => 'Tarihsel Bağlam';

  @override
  String get crossReferencesLabel => 'Çapraz Referanslar';

  @override
  String get growthStoryTitle => 'Büyüme Hikayesi';

  @override
  String get prayerGuideTitle => 'Abba ile nasıl dua edilir';

  @override
  String get prayerGuide1 => 'Sesli ve net bir şekilde dua edin';

  @override
  String get prayerGuide2 =>
      'Abba duanızı dinler ve kalbinize dokunan ayetleri bulur';

  @override
  String get prayerGuide3 => 'İsterseniz duanızı yazarak da iletebilirsiniz';

  @override
  String get qtGuideTitle => 'Abba ile sessiz zaman nasıl yapılır';

  @override
  String get qtGuide1 => 'Pasajı okuyun ve sessizce tefekkür edin';

  @override
  String get qtGuide2 => 'Keşfettiklerinizi paylaşın — konuşun ya da yazın';

  @override
  String get qtGuide3 =>
      'Abba, Söz\'ü günlük hayatınıza uygulamanıza yardımcı olacak';

  @override
  String get scriptureReasonLabel => 'Neden bu ayet';

  @override
  String get scripturePostureLabel => 'Hangi ruh haliyle okumalıyım?';

  @override
  String get scriptureOriginalWordsTitle => 'Orijinal dilde daha derin anlam';

  @override
  String get originalWordMeaningLabel => 'Anlam';

  @override
  String get originalWordNuanceLabel => 'Çeviri farkı';

  @override
  String originalWordsCountLabel(int count) {
    return '$count kelime';
  }

  @override
  String get seeMore => 'Daha fazla';

  @override
  String seeAllComments(Object count) {
    return 'Tüm $count yorumu gör';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name ve $count kişi daha beğendi';
  }

  @override
  String get commentsTitle => 'Yorumlar';

  @override
  String get myPageTitle => 'Dua Bahçem';

  @override
  String get myPrayers => 'Dualarım';

  @override
  String get myTestimonies => 'Tanıklıklarım';

  @override
  String get savedPosts => 'Kaydedilenler';

  @override
  String get totalPrayersCount => 'Dualar';

  @override
  String get streakCount => 'Seri';

  @override
  String get testimoniesCount => 'Tanıklıklar';

  @override
  String get linkAccountTitle => 'Hesabı Bağla';

  @override
  String get linkAccountDescription =>
      'Cihaz değiştirirken dua kayıtlarınızı korumak için hesabınızı bağlayın';

  @override
  String get linkWithApple => 'Apple ile Bağla';

  @override
  String get linkWithGoogle => 'Google ile Bağla';

  @override
  String get linkAccountSuccess => 'Hesap başarıyla bağlandı!';

  @override
  String get anonymousUser => 'Dua Savaşçısı';

  @override
  String showReplies(Object count) {
    return '$count yanıtı gör';
  }

  @override
  String get hideReplies => 'Yanıtları gizle';

  @override
  String replyingTo(Object name) {
    return '$name kişisine yanıt veriliyor';
  }

  @override
  String viewAllComments(Object count) {
    return 'Tüm $count yorumu gör';
  }

  @override
  String get membershipTitle => 'Üyelik';

  @override
  String get membershipSubtitle => 'Dua hayatınızı derinleştirin';

  @override
  String get monthlyPlan => 'Aylık';

  @override
  String get yearlyPlan => 'Yıllık';

  @override
  String get yearlySavings => '₺86/ay (%40 indirim)';

  @override
  String get startMembership => 'Başla';

  @override
  String get membershipActive => 'Üyelik Aktif';

  @override
  String get leaveRecordingTitle => 'Kayıttan çıkılsın mı?';

  @override
  String get leaveRecordingMessage => 'Kaydınız kaybolacak. Emin misiniz?';

  @override
  String get leaveButton => 'Çık';

  @override
  String get stayButton => 'Kal';

  @override
  String likedByCount(Object count) {
    return '$count kişi empati kurdu';
  }

  @override
  String get actionLike => 'Beğen';

  @override
  String get actionComment => 'Yorum';

  @override
  String get actionSave => 'Kaydet';

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
      '💛 Sevgi — 10 saniye boyunca sevdiğiniz birini düşünün';

  @override
  String get qtLoadingHint2 =>
      '🌿 Lütuf — Bugün aldığınız küçük bir lütfu hatırlayın';

  @override
  String get qtLoadingHint3 => '🌅 Umut — Yarın için küçük bir umut hayal edin';

  @override
  String get qtLoadingHint4 => '🕊️ Huzur — Yavaşça üç kez derin nefes alın';

  @override
  String get qtLoadingHint5 => '🌳 İman — Değişmeyen bir gerçeği hatırlayın';

  @override
  String get qtLoadingHint6 =>
      '🌸 Şükran — Şu an şükrettiğiniz bir şeyi söyleyin';

  @override
  String get qtLoadingHint7 =>
      '🌊 Bağışlama — Bağışlamak istediğiniz birini düşünün';

  @override
  String get qtLoadingHint8 =>
      '📖 Hikmet — Bugünün bir dersini kalbinizde tutun';

  @override
  String get qtLoadingHint9 => '⏳ Sabır — Sessizce beklediğiniz şeyi düşünün';

  @override
  String get qtLoadingHint10 =>
      '✨ Sevinç — Bugün gülümsediğiniz anı hatırlayın';

  @override
  String get qtLoadingTitle => 'Bugünün Sözü hazırlanıyor...';

  @override
  String get coachingTitle => 'Dua Koçluğu';

  @override
  String get coachingLoadingText => 'Duanız üzerinde düşünüyoruz...';

  @override
  String get coachingErrorText => 'Geçici hata — lütfen yeniden deneyin';

  @override
  String get coachingRetryButton => 'Yeniden dene';

  @override
  String get coachingScoreSpecificity => 'Somutluk';

  @override
  String get coachingScoreGodCentered => 'Tanrı merkezli';

  @override
  String get coachingScoreActs => 'ACTS dengesi';

  @override
  String get coachingScoreAuthenticity => 'Samimiyet';

  @override
  String get coachingStrengthsTitle => 'İyi yaptığınız şeyler ✨';

  @override
  String get coachingImprovementsTitle => 'Daha derine inmek için 💡';

  @override
  String get coachingProCta => 'Dua Koçluğunu Pro ile açın';

  @override
  String get coachingLevelBeginner => '🌱 Başlangıç';

  @override
  String get coachingLevelGrowing => '🌿 Gelişiyor';

  @override
  String get coachingLevelExpert => '🌳 Uzman';

  @override
  String get aiPrayerCitationsTitle => 'Referanslar · Alıntılar';

  @override
  String get citationTypeQuote => 'Alıntı';

  @override
  String get citationTypeScience => 'Araştırma';

  @override
  String get citationTypeExample => 'Örnek';

  @override
  String get citationTypeHistory => 'Tarih';

  @override
  String get aiPrayerReadingTime => '2 dakikalık okuma';

  @override
  String get scriptureKeyWordHintTitle => 'Bugünün anahtar kelimesi';

  @override
  String get bibleLookupReferenceHint =>
      'Bu ayeti kendi Kutsal Kitabınızda bulun ve üzerinde meditasyon yapın.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Kutsal Kitap Çevirileri';

  @override
  String get settingsBibleTranslationsIntro =>
      'Bu uygulamadaki Kutsal Kitap ayetleri kamu malı çevirilerden alınmıştır. AI tarafından oluşturulan yorumlar, dualar ve hikayeler Abba\'nın yaratıcı çalışmasıdır.';

  @override
  String get meditationSummaryTitle => 'Today\'s Meditation';

  @override
  String get meditationTopicLabel => 'Topic';

  @override
  String get meditationSummaryLabel => 'Summary';

  @override
  String get qtScriptureTitle => 'Today\'s Passage';

  @override
  String get qtCoachingTitle => 'QT Koçluğu';

  @override
  String get qtCoachingLoadingText => 'Tefekkürünüz üzerinde düşünüyoruz...';

  @override
  String get qtCoachingErrorText => 'Geçici hata — lütfen yeniden deneyin';

  @override
  String get qtCoachingRetryButton => 'Yeniden dene';

  @override
  String get qtCoachingScoreComprehension => 'Metin anlayışı';

  @override
  String get qtCoachingScoreApplication => 'Kişisel uygulama';

  @override
  String get qtCoachingScoreDepth => 'Ruhsal derinlik';

  @override
  String get qtCoachingScoreAuthenticity => 'Samimiyet';

  @override
  String get qtCoachingStrengthsTitle => 'İyi yaptığınız şeyler ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Daha derine inmek için 💡';

  @override
  String get qtCoachingProCta => 'QT Koçluğunu Pro ile açın';

  @override
  String get qtCoachingLevelBeginner => '🌱 Başlangıç';

  @override
  String get qtCoachingLevelGrowing => '🌿 Gelişiyor';

  @override
  String get qtCoachingLevelExpert => '🌳 Uzman';
}
