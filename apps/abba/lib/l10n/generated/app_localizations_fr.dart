// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Quand vous priez,\nDieu répond.';

  @override
  String get welcomeSubtitle =>
      'Votre compagnon quotidien de prière et de temps calme';

  @override
  String get getStarted => 'Commencer';

  @override
  String get loginTitle => 'Bienvenue sur Abba';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour commencer votre parcours de prière';

  @override
  String get signInWithApple => 'Continuer avec Apple';

  @override
  String get signInWithGoogle => 'Continuer avec Google';

  @override
  String get signInWithEmail => 'Continuer avec e-mail';

  @override
  String greetingMorning(Object name) {
    return 'Bonjour, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Bon après-midi, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Bonsoir, $name';
  }

  @override
  String get prayButton => 'Prier';

  @override
  String get qtButton => 'Temps Calme';

  @override
  String streakDays(Object count) {
    return '$count jours de prière consécutifs';
  }

  @override
  String get dailyVerse => 'Verset du Jour';

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabCalendar => 'Calendrier';

  @override
  String get tabCommunity => 'Communauté';

  @override
  String get tabSettings => 'Paramètres';

  @override
  String get recordingTitle => 'En prière...';

  @override
  String get recordingPause => 'Pause';

  @override
  String get recordingResume => 'Reprendre';

  @override
  String get finishPrayer => 'Terminer la Prière';

  @override
  String get finishPrayerConfirm => 'Souhaitez-vous terminer votre prière ?';

  @override
  String get switchToText => 'Saisir au clavier';

  @override
  String get textInputHint => 'Écrivez votre prière ici...';

  @override
  String get aiLoadingText => 'Méditation sur votre prière...';

  @override
  String get aiLoadingVerse =>
      'Arrêtez, et sachez que je suis Dieu.\n— Psaume 46:10';

  @override
  String get dashboardTitle => 'Jardin de Prière';

  @override
  String get shareButton => 'Partager';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get scriptureTitle => 'Écriture du Jour';

  @override
  String get bibleStoryTitle => 'Récit Biblique';

  @override
  String get testimonyTitle => 'Témoignage · Ma prière';

  @override
  String get testimonyHelperText =>
      'Réfléchissez à votre prière · peut être partagé avec la communauté';

  @override
  String get myPrayerAudioLabel => 'Enregistrement de ma prière';

  @override
  String get testimonyEdit => 'Modifier';

  @override
  String get guidanceTitle => 'Guidance IA';

  @override
  String get aiPrayerTitle => 'Une Prière pour Vous';

  @override
  String get originalLangTitle => 'Langue Originale';

  @override
  String get proUnlock => 'Débloquer avec Pro';

  @override
  String get qtPageTitle => 'Jardin du Matin';

  @override
  String get qtMeditateButton => 'Commencer la Méditation';

  @override
  String get qtCompleted => 'Terminé';

  @override
  String get communityTitle => 'Jardin de Prière';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterTestimony => 'Témoignage';

  @override
  String get filterPrayerRequest => 'Demande de Prière';

  @override
  String get likeButton => 'Aimer';

  @override
  String get commentButton => 'Commenter';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get replyButton => 'Répondre';

  @override
  String get writePostTitle => 'Partager';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get sharePostButton => 'Partager';

  @override
  String get anonymousToggle => 'Anonyme';

  @override
  String get realNameToggle => 'Nom Réel';

  @override
  String get categoryTestimony => 'Témoignage';

  @override
  String get categoryPrayerRequest => 'Demande de Prière';

  @override
  String get writePostHint =>
      'Partagez votre témoignage ou demande de prière...';

  @override
  String get importFromPrayer => 'Importer de la prière';

  @override
  String get calendarTitle => 'Calendrier de Prière';

  @override
  String get currentStreak => 'Série en cours';

  @override
  String get bestStreak => 'Meilleure Série';

  @override
  String get days => 'jours';

  @override
  String calendarRecordCount(Object count) {
    return '$count enregistrements';
  }

  @override
  String get todayVerse => 'Verset du Jour';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get profileSection => 'Profil';

  @override
  String get totalPrayers => 'Total des Prières';

  @override
  String get consecutiveDays => 'Jours Consécutifs';

  @override
  String get proSection => 'Abonnement';

  @override
  String get freePlan => 'Gratuit';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => '6,99€ / mois';

  @override
  String get yearlyPrice => '49,99€ / an';

  @override
  String get yearlySave => 'Économisez 40%';

  @override
  String get launchPromo => '3 mois à 2,92€/mois !';

  @override
  String get startPro => 'Passer au Pro';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get notificationSetting => 'Notifications';

  @override
  String get languageSetting => 'Langue';

  @override
  String get darkModeSetting => 'Mode Sombre';

  @override
  String get helpCenter => 'Centre d\'aide';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get logout => 'Se déconnecter';

  @override
  String appVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get anonymous => 'Anonyme';

  @override
  String timeAgo(Object time) {
    return 'il y a $time';
  }

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get cancel => 'Annuler';

  @override
  String get noPrayersRecorded => 'Aucune prière enregistrée';

  @override
  String get deletePost => 'Supprimer';

  @override
  String get reportPost => 'Signaler';

  @override
  String get reportSubmitted => 'Signalement envoyé. Merci.';

  @override
  String get reportReasonHint =>
      'Décrivez la raison du signalement. Il sera envoyé par e-mail.';

  @override
  String get reportReasonPlaceholder => 'Indiquez la raison du signalement...';

  @override
  String get reportSubmitButton => 'Signaler';

  @override
  String get deleteConfirmTitle => 'Supprimer la Publication';

  @override
  String get deleteConfirmMessage =>
      'Êtes-vous sûr de vouloir supprimer cette publication ?';

  @override
  String get errorNetwork =>
      'Veuillez vérifier votre connexion internet et réessayer.';

  @override
  String get errorAiFallback =>
      'Impossible de se connecter à l\'IA pour le moment. Voici un verset pour vous.';

  @override
  String get errorSttFailed =>
      'La reconnaissance vocale n\'est pas disponible. Veuillez saisir au clavier.';

  @override
  String get errorPayment =>
      'Un problème est survenu lors du paiement. Réessayez dans les Paramètres.';

  @override
  String get errorGeneric =>
      'Une erreur s\'est produite. Veuillez réessayer plus tard.';

  @override
  String get offlineNotice =>
      'Vous êtes hors ligne. Certaines fonctionnalités peuvent être limitées.';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get groupSection => 'Mes Groupes';

  @override
  String get createGroup => 'Créer un Groupe de Prière';

  @override
  String get inviteFriends => 'Inviter des Amis';

  @override
  String get groupInviteMessage =>
      'Prions ensemble ! Rejoignez mon groupe de prière sur Abba.';

  @override
  String get noGroups => 'Rejoignez ou créez un groupe pour prier ensemble.';

  @override
  String get promoTitle => 'Offre de Lancement';

  @override
  String get promoBanner => 'Les 3 premiers mois à 2,92€/mois !';

  @override
  String promoEndsOn(Object date) {
    return 'Offre valable jusqu\'au $date';
  }

  @override
  String get proLimitTitle => 'Prière du jour terminée';

  @override
  String get proLimitBody => 'À demain !\nPriez sans limite avec Pro';

  @override
  String get laterButton => 'Peut-être plus tard';

  @override
  String get proPromptTitle => 'Fonctionnalité Pro';

  @override
  String get proPromptBody =>
      'Cette fonctionnalité est disponible avec Pro.\nSouhaitez-vous voir nos offres ?';

  @override
  String get viewProducts => 'Voir les Offres';

  @override
  String get maybeLater => 'Peut-être plus tard';

  @override
  String get proHeadline => 'Plus proche de Dieu, chaque jour';

  @override
  String get proBenefit1 => 'Prière et Temps Calme illimités';

  @override
  String get proBenefit2 => 'Prière et guidance assistées par IA';

  @override
  String get proBenefit3 => 'Récits de foi à travers l\'histoire';

  @override
  String get proBenefit5 => 'Étude biblique en langue originale';

  @override
  String get bestValue => 'MEILLEURE OFFRE';

  @override
  String get perMonth => 'mois';

  @override
  String get cancelAnytime => 'Annulez à tout moment';

  @override
  String get restorePurchase => 'Restaurer l\'achat';

  @override
  String get yearlyPriceMonthly => '4,17€/mois';

  @override
  String get morningPrayerReminder => 'Prière du Matin';

  @override
  String get eveningGratitudeReminder => 'Gratitude du Soir';

  @override
  String get streakReminder => 'Rappel de Série';

  @override
  String get afternoonNudgeReminder => 'Rappel de Prière de l\'après-midi';

  @override
  String get weeklySummaryReminder => 'Résumé Hebdomadaire';

  @override
  String get unlimited => 'Illimité';

  @override
  String get streakRecovery =>
      'Ce n\'est pas grave, vous pouvez recommencer 🌱';

  @override
  String get prayerSaved => 'Prière enregistrée avec succès';

  @override
  String get quietTimeLabel => 'Temps Calme';

  @override
  String get morningPrayerLabel => 'Prière du Matin';

  @override
  String get gardenSeed => 'Une graine de foi';

  @override
  String get gardenSprout => 'Pousse en croissance';

  @override
  String get gardenBud => 'Fleur en bouton';

  @override
  String get gardenBloom => 'Pleine floraison';

  @override
  String get gardenTree => 'Arbre solide';

  @override
  String get gardenForest => 'Forêt de prière';

  @override
  String get milestoneShare => 'Partager';

  @override
  String get milestoneThankGod => 'Merci Seigneur !';

  @override
  String shareStreakText(Object count) {
    return '$count jours de prière consécutifs ! Mon parcours de prière avec Abba #Abba #Prière';
  }

  @override
  String get shareDaysLabel => 'jours de prière consécutifs';

  @override
  String get shareSubtitle => 'Prière quotidienne avec Dieu';

  @override
  String get proActive => 'Abonnement Actif';

  @override
  String get planOncePerDay => '1x/jour';

  @override
  String get planUnlimited => 'Illimité';

  @override
  String get closeRecording => 'Fermer l\'enregistrement';

  @override
  String get qtRevealMessage => 'Ouvrons la Parole du jour';

  @override
  String get qtSelectPrompt =>
      'Choisissez et commencez le temps calme d\'aujourd\'hui';

  @override
  String get qtTopicLabel => 'Thème';

  @override
  String get prayerStartPrompt => 'Commencez votre prière';

  @override
  String get startPrayerButton => 'Commencer la Prière';

  @override
  String get switchToTextMode => 'Saisir au clavier';

  @override
  String get switchToVoiceMode => 'Parler';

  @override
  String get prayerDashboardTitle => 'Jardin de Prière';

  @override
  String get qtDashboardTitle => 'Jardin Temps Calme';

  @override
  String get prayerSummaryTitle => 'Résumé de Prière';

  @override
  String get gratitudeLabel => 'Gratitude';

  @override
  String get petitionLabel => 'Supplication';

  @override
  String get intercessionLabel => 'Intercession';

  @override
  String get historicalStoryTitle => 'Récit de l\'Histoire';

  @override
  String get todayLesson => 'Leçon du Jour';

  @override
  String get applicationTitle => 'Application du Jour';

  @override
  String get applicationWhat => 'Quoi';

  @override
  String get applicationWhen => 'Quand';

  @override
  String get applicationContext => 'Où';

  @override
  String get applicationMorningLabel => 'Matin';

  @override
  String get applicationDayLabel => 'Jour';

  @override
  String get applicationEveningLabel => 'Soir';

  @override
  String get relatedKnowledgeTitle => 'Connaissances Liées';

  @override
  String get originalWordLabel => 'Mot Original';

  @override
  String get historicalContextLabel => 'Contexte Historique';

  @override
  String get crossReferencesLabel => 'Références Croisées';

  @override
  String get growthStoryTitle => 'Histoire de Croissance';

  @override
  String get prayerGuideTitle => 'Comment prier avec Abba';

  @override
  String get prayerGuide1 => 'Priez à voix haute ou d\'une voix claire';

  @override
  String get prayerGuide2 =>
      'Abba écoute vos paroles et trouve les Écritures qui parlent à votre cœur';

  @override
  String get prayerGuide3 =>
      'Vous pouvez aussi saisir votre prière au clavier si vous préférez';

  @override
  String get qtGuideTitle => 'Comment faire le Temps Calme avec Abba';

  @override
  String get qtGuide1 => 'Lisez le passage et méditez en silence';

  @override
  String get qtGuide2 =>
      'Partagez ce que vous avez découvert — parlez ou écrivez votre réflexion';

  @override
  String get qtGuide3 =>
      'Abba vous aidera à appliquer la Parole dans votre vie quotidienne';

  @override
  String get scriptureReasonLabel => 'Pourquoi cette Écriture';

  @override
  String get scripturePostureLabel => 'Dans quel état d\'esprit le lire ?';

  @override
  String get scriptureOriginalWordsTitle => 'Sens profond en langue originale';

  @override
  String get originalWordMeaningLabel => 'Signification';

  @override
  String get originalWordNuanceLabel => 'Nuance vs traduction';

  @override
  String originalWordsCountLabel(int count) {
    return '$count mots';
  }

  @override
  String get seeMore => 'Voir plus';

  @override
  String seeAllComments(Object count) {
    return 'Voir les $count commentaires';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name et $count autres ont aimé';
  }

  @override
  String get commentsTitle => 'Commentaires';

  @override
  String get myPageTitle => 'Mon Jardin de Prière';

  @override
  String get myPrayers => 'Mes Prières';

  @override
  String get myTestimonies => 'Mes Témoignages';

  @override
  String get savedPosts => 'Enregistrés';

  @override
  String get totalPrayersCount => 'Prières';

  @override
  String get streakCount => 'Série';

  @override
  String get testimoniesCount => 'Témoignages';

  @override
  String get linkAccountTitle => 'Associer un Compte';

  @override
  String get linkAccountDescription =>
      'Associez votre compte pour conserver vos données de prière lors d\'un changement d\'appareil';

  @override
  String get linkWithApple => 'Associer avec Apple';

  @override
  String get linkWithGoogle => 'Associer avec Google';

  @override
  String get linkAccountSuccess => 'Compte associé avec succès !';

  @override
  String get anonymousUser => 'Guerrier de Prière';

  @override
  String showReplies(Object count) {
    return 'Voir $count réponses';
  }

  @override
  String get hideReplies => 'Masquer les réponses';

  @override
  String replyingTo(Object name) {
    return 'Réponse à $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Voir les $count commentaires';
  }

  @override
  String get membershipTitle => 'Abonnement';

  @override
  String get membershipSubtitle => 'Approfondissez votre vie de prière';

  @override
  String get monthlyPlan => 'Mensuel';

  @override
  String get yearlyPlan => 'Annuel';

  @override
  String get yearlySavings => '4,17€/mois (40% de réduction)';

  @override
  String get startMembership => 'Commencer';

  @override
  String get membershipActive => 'Abonnement Actif';

  @override
  String get leaveRecordingTitle => 'Quitter l\'enregistrement ?';

  @override
  String get leaveRecordingMessage =>
      'Votre enregistrement sera perdu. Êtes-vous sûr ?';

  @override
  String get leaveButton => 'Quitter';

  @override
  String get stayButton => 'Rester';

  @override
  String likedByCount(Object count) {
    return '$count personnes ont compati';
  }

  @override
  String get actionLike => 'J\'aime';

  @override
  String get actionComment => 'Commenter';

  @override
  String get actionSave => 'Sauvegarder';

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
  String get billingIssueTitle => 'Problème de paiement détecté';

  @override
  String billingIssueBody(int days) {
    return 'Vos avantages Pro prendront fin dans $days jours sans mise à jour du paiement.';
  }

  @override
  String get billingIssueAction => 'Mettre à jour le paiement';

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
      '💛 Amour — Pensez à quelqu\'un que vous aimez pendant 10 secondes';

  @override
  String get qtLoadingHint2 =>
      '🌿 Grâce — Rappelez-vous une petite grâce reçue aujourd\'hui';

  @override
  String get qtLoadingHint3 =>
      '🌅 Espérance — Imaginez un petit espoir pour demain';

  @override
  String get qtLoadingHint4 =>
      '🕊️ Paix — Respirez profondément trois fois, lentement';

  @override
  String get qtLoadingHint5 => '🌳 Foi — Souvenez-vous d\'une vérité immuable';

  @override
  String get qtLoadingHint6 =>
      '🌸 Gratitude — Nommez une chose pour laquelle vous êtes reconnaissant';

  @override
  String get qtLoadingHint7 => '🌊 Pardon — Pensez à quelqu\'un à pardonner';

  @override
  String get qtLoadingHint8 =>
      '📖 Sagesse — Gardez une leçon d\'aujourd\'hui dans votre cœur';

  @override
  String get qtLoadingHint9 =>
      '⏳ Patience — Pensez à ce que vous attendez tranquillement';

  @override
  String get qtLoadingHint10 =>
      '✨ Joie — Souvenez-vous d\'un sourire d\'aujourd\'hui';

  @override
  String get qtLoadingTitle => 'Préparation de la Parole d\'aujourd\'hui...';

  @override
  String get coachingTitle => 'Coaching de prière';

  @override
  String get coachingLoadingText => 'Nous réfléchissons à votre prière...';

  @override
  String get coachingErrorText => 'Erreur temporaire — veuillez réessayer';

  @override
  String get coachingRetryButton => 'Réessayer';

  @override
  String get coachingScoreSpecificity => 'Précision';

  @override
  String get coachingScoreGodCentered => 'Centré sur Dieu';

  @override
  String get coachingScoreActs => 'Équilibre ACTS';

  @override
  String get coachingScoreAuthenticity => 'Authenticité';

  @override
  String get coachingStrengthsTitle => 'Ce que vous avez bien fait ✨';

  @override
  String get coachingImprovementsTitle => 'Pour aller plus loin 💡';

  @override
  String get coachingProCta => 'Débloquez le Coaching avec Pro';

  @override
  String get coachingLevelBeginner => '🌱 Débutant';

  @override
  String get coachingLevelGrowing => '🌿 En croissance';

  @override
  String get coachingLevelExpert => '🌳 Expert';

  @override
  String get aiPrayerCitationsTitle => 'Références · Citations';

  @override
  String get citationTypeQuote => 'Citation';

  @override
  String get citationTypeScience => 'Étude';

  @override
  String get citationTypeExample => 'Exemple';

  @override
  String get citationTypeHistory => 'Histoire';

  @override
  String get aiPrayerReadingTime => 'Lecture de 2 min';

  @override
  String get scriptureKeyWordHintTitle => 'Mot-clé du jour';

  @override
  String get bibleLookupReferenceHint =>
      'Trouvez ce passage dans votre Bible et méditez-le.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Traductions de la Bible';

  @override
  String get settingsBibleTranslationsIntro =>
      'Les versets bibliques de cette application proviennent de traductions du domaine public. Les commentaires, prières et histoires générés par IA sont des œuvres créatives d\'Abba.';

  @override
  String get meditationSummaryTitle => 'Méditation d\'aujourd\'hui';

  @override
  String get meditationTopicLabel => 'Thème';

  @override
  String get meditationSummaryLabel => 'En une phrase';

  @override
  String get qtScriptureTitle => 'Passage d\'aujourd\'hui';

  @override
  String get qtCoachingTitle => 'Coaching QT';

  @override
  String get qtCoachingLoadingText =>
      'Nous réfléchissons à votre méditation...';

  @override
  String get qtCoachingErrorText => 'Erreur temporaire — veuillez réessayer';

  @override
  String get qtCoachingRetryButton => 'Réessayer';

  @override
  String get qtCoachingScoreComprehension => 'Compréhension du texte';

  @override
  String get qtCoachingScoreApplication => 'Application personnelle';

  @override
  String get qtCoachingScoreDepth => 'Profondeur spirituelle';

  @override
  String get qtCoachingScoreAuthenticity => 'Authenticité';

  @override
  String get qtCoachingStrengthsTitle => 'Ce que vous avez bien fait ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Pour aller plus loin 💡';

  @override
  String get qtCoachingProCta => 'Débloquez le Coaching QT avec Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Débutant';

  @override
  String get qtCoachingLevelGrowing => '🌿 En croissance';

  @override
  String get qtCoachingLevelExpert => '🌳 Expert';

  @override
  String get notifyMorning1Title => '🙏 C\'est l\'heure de prier';

  @override
  String notifyMorning1Body(String name) {
    return '$name, parle avec Dieu aujourd\'hui aussi';
  }

  @override
  String get notifyMorning2Title => '🌅 Un nouveau matin est arrivé';

  @override
  String notifyMorning2Body(String name) {
    return '$name, commence la journée avec gratitude';
  }

  @override
  String get notifyMorning3Title => '✨ La grâce du jour';

  @override
  String notifyMorning3Body(String name) {
    return '$name, découvre la grâce que Dieu a préparée';
  }

  @override
  String get notifyMorning4Title => '🕊️ Matin paisible';

  @override
  String notifyMorning4Body(String name) {
    return '$name, remplis ton cœur de paix par la prière';
  }

  @override
  String get notifyMorning5Title => '📖 Avec la Parole';

  @override
  String notifyMorning5Body(String name) {
    return '$name, écoute la voix de Dieu aujourd\'hui';
  }

  @override
  String get notifyMorning6Title => '🌿 Temps de repos';

  @override
  String notifyMorning6Body(String name) {
    return '$name, arrête-toi un instant et prie';
  }

  @override
  String get notifyMorning7Title => '💫 Aujourd\'hui aussi';

  @override
  String notifyMorning7Body(String name) {
    return '$name, une journée qui commence par la prière est différente';
  }

  @override
  String get notifyEvening1Title => '✨ Merci pour aujourd\'hui';

  @override
  String get notifyEvening1Body =>
      'Revois ta journée et offre une prière de gratitude';

  @override
  String get notifyEvening2Title => '🌙 En terminant la journée';

  @override
  String get notifyEvening2Body =>
      'Exprime la gratitude de la journée par la prière';

  @override
  String get notifyEvening3Title => '🙏 Prière du soir';

  @override
  String get notifyEvening3Body => 'À la fin de la journée, rends grâce à Dieu';

  @override
  String get notifyEvening4Title => '🌟 En comptant les grâces du jour';

  @override
  String get notifyEvening4Body =>
      'Si tu as de quoi être reconnaissant, partage-le dans la prière';

  @override
  String get notifyStreak3Title => '🌱 3 jours de suite !';

  @override
  String get notifyStreak3Body => 'Ton habitude de prière a commencé';

  @override
  String get notifyStreak7Title => '🌿 Une semaine d\'affilée !';

  @override
  String get notifyStreak7Body => 'La prière devient une habitude';

  @override
  String get notifyStreak14Title => '🌳 2 semaines d\'affilée !';

  @override
  String get notifyStreak14Body => 'Une croissance incroyable !';

  @override
  String get notifyStreak21Title => '🌻 3 semaines d\'affilée !';

  @override
  String get notifyStreak21Body => 'La fleur de la prière s\'épanouit';

  @override
  String get notifyStreak30Title => '🏆 Un mois entier !';

  @override
  String get notifyStreak30Body => 'Ta prière rayonne';

  @override
  String get notifyStreak50Title => '👑 50 jours d\'affilée !';

  @override
  String get notifyStreak50Body => 'Ta marche avec Dieu s\'approfondit';

  @override
  String get notifyStreak100Title => '🎉 100 jours d\'affilée !';

  @override
  String get notifyStreak100Body => 'Tu es devenu un guerrier de la prière !';

  @override
  String get notifyStreak365Title => '✝️ Une année entière !';

  @override
  String get notifyStreak365Body => 'Quel incroyable voyage de foi !';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ As-tu déjà prié aujourd\'hui ?';

  @override
  String get notifyAfternoonNudgeBody =>
      'Une courte prière peut changer la journée';

  @override
  String get notifyChannelName => 'Rappels de prière';

  @override
  String get notifyChannelDescription =>
      'Prière du matin, gratitude du soir et autres rappels';

  @override
  String get milestoneFirstPrayerTitle => 'Première prière !';

  @override
  String get milestoneFirstPrayerDesc =>
      'Votre voyage de prière a commencé. Dieu écoute.';

  @override
  String get milestoneSevenDayStreakTitle => '7 jours de prière !';

  @override
  String get milestoneSevenDayStreakDesc =>
      'Une semaine de prière fidèle. Votre jardin grandit !';

  @override
  String get milestoneThirtyDayStreakTitle => '30 jours !';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'Votre jardin est devenu un champ de fleurs !';

  @override
  String get milestoneHundredPrayersTitle => '100e prière !';

  @override
  String get milestoneHundredPrayersDesc =>
      'Cent conversations avec Dieu. Vous êtes profondément enraciné.';

  @override
  String get homeFirstPrayerPrompt => 'Commencez votre première prière';

  @override
  String get homeFirstQtPrompt => 'Commencez votre premier QT';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Aujourd\'hui aussi, faites $activityName';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'Jour $count continu de $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'Cela fait $days jours depuis votre dernier $activityName';
  }

  @override
  String get homeActivityPrayer => 'prière';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Chargement...';

  @override
  String get heatmapNoPrayer => 'Aucune prière';
}
