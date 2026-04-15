// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Cuando oras,\nDios responde.';

  @override
  String get welcomeSubtitle =>
      'Tu compañero diario de oración y tiempo devocional con IA';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get loginTitle => 'Bienvenido a Abba';

  @override
  String get loginSubtitle =>
      'Inicia sesión para comenzar tu camino de oración';

  @override
  String get signInWithApple => 'Continuar con Apple';

  @override
  String get signInWithGoogle => 'Continuar con Google';

  @override
  String get signInWithEmail => 'Continuar con correo';

  @override
  String greetingMorning(Object name) {
    return 'Buenos días, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Buenas tardes, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Buenas noches, $name';
  }

  @override
  String get prayButton => 'Orar';

  @override
  String get qtButton => 'Devocional';

  @override
  String streakDays(Object count) {
    return '$count días seguidos de oración';
  }

  @override
  String get dailyVerse => 'Versículo del día';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabCalendar => 'Calendario';

  @override
  String get tabCommunity => 'Comunidad';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get recordingTitle => 'Orando...';

  @override
  String get recordingPause => 'Pausar';

  @override
  String get recordingResume => 'Reanudar';

  @override
  String get finishPrayer => 'Terminar oración';

  @override
  String get finishPrayerConfirm => '¿Desea terminar su oración?';

  @override
  String get switchToText => 'Escribir';

  @override
  String get textInputHint => 'Escribe tu oración aquí...';

  @override
  String get aiLoadingText => 'Meditando en tu oración...';

  @override
  String get aiLoadingVerse =>
      'Estad quietos, y conoced que yo soy Dios.\n— Salmo 46:10';

  @override
  String get dashboardTitle => 'Jardín de oración';

  @override
  String get shareButton => 'Compartir';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String get scriptureTitle => 'Escritura del día';

  @override
  String get bibleStoryTitle => 'Historia bíblica';

  @override
  String get testimonyTitle => 'Mi testimonio';

  @override
  String get testimonyEdit => 'Editar';

  @override
  String get guidanceTitle => 'Guía de IA';

  @override
  String get aiPrayerTitle => 'Una oración para ti';

  @override
  String get originalLangTitle => 'Significado original';

  @override
  String get premiumUnlock => 'Desbloquear con Premium';

  @override
  String get qtPageTitle => 'Jardín de la mañana';

  @override
  String get qtMeditateButton => 'Comenzar meditación';

  @override
  String get qtCompleted => 'Completado';

  @override
  String get communityTitle => 'Jardín de oración';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterTestimony => 'Testimonio';

  @override
  String get filterPrayerRequest => 'Petición de oración';

  @override
  String get likeButton => 'Me gusta';

  @override
  String get commentButton => 'Comentar';

  @override
  String get saveButton => 'Guardar';

  @override
  String get replyButton => 'Responder';

  @override
  String get writePostTitle => 'Compartir';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get sharePostButton => 'Compartir';

  @override
  String get anonymousToggle => 'Anónimo';

  @override
  String get realNameToggle => 'Nombre real';

  @override
  String get categoryTestimony => 'Testimonio';

  @override
  String get categoryPrayerRequest => 'Petición de oración';

  @override
  String get writePostHint => 'Comparte tu testimonio o petición de oración...';

  @override
  String get importFromPrayer => 'Importar de la oración';

  @override
  String get calendarTitle => 'Calendario de oración';

  @override
  String get currentStreak => 'Racha actual';

  @override
  String get bestStreak => 'Mejor racha';

  @override
  String get days => 'días';

  @override
  String calendarRecordCount(Object count) {
    return '$count registros';
  }

  @override
  String get todayVerse => 'Versículo del día';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get profileSection => 'Perfil';

  @override
  String get totalPrayers => 'Total de oraciones';

  @override
  String get consecutiveDays => 'Días consecutivos';

  @override
  String get premiumSection => 'Premium';

  @override
  String get freePlan => 'Gratis';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get monthlyPrice => '\$3.49/mes';

  @override
  String get yearlyPrice => '\$24.99/año';

  @override
  String get yearlySave => 'Ahorra 40%';

  @override
  String get launchPromo => '¡3 meses a \$3.99/mes!';

  @override
  String get startPremium => 'Iniciar Premium';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get notificationSetting => 'Notificaciones';

  @override
  String get aiVoiceSetting => 'Voz de IA';

  @override
  String get voiceWarm => 'Cálida';

  @override
  String get voiceCalm => 'Tranquila';

  @override
  String get voiceStrong => 'Fuerte';

  @override
  String get languageSetting => 'Idioma';

  @override
  String get darkModeSetting => 'Modo oscuro';

  @override
  String get helpCenter => 'Centro de ayuda';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String appVersion(Object version) {
    return 'Versión $version';
  }

  @override
  String get anonymous => 'Anónimo';

  @override
  String timeAgo(Object time) {
    return 'hace $time';
  }

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get cancel => 'Cancelar';

  @override
  String get noPrayersRecorded => 'No hay oraciones registradas';

  @override
  String get deletePost => 'Eliminar';

  @override
  String get reportPost => 'Reportar';

  @override
  String get reportSubmitted => 'Reporte enviado. Gracias.';

  @override
  String get reportReasonHint =>
      'Describe el motivo de la denuncia. Se enviará por correo electrónico.';

  @override
  String get reportReasonPlaceholder => 'Ingrese el motivo de la denuncia...';

  @override
  String get reportSubmitButton => 'Reportar';

  @override
  String get deleteConfirmTitle => 'Eliminar publicación';

  @override
  String get deleteConfirmMessage =>
      '¿Estás seguro de que quieres eliminar esta publicación?';

  @override
  String get errorNetwork =>
      'Revisa tu conexión a internet e intenta de nuevo.';

  @override
  String get errorAiFallback =>
      'No pudimos conectar con la IA. Aquí tienes un versículo.';

  @override
  String get errorSttFailed =>
      'El reconocimiento de voz no está disponible. Escribe en su lugar.';

  @override
  String get errorPayment =>
      'Hubo un problema con el pago. Intenta de nuevo en Ajustes.';

  @override
  String get errorGeneric => 'Algo salió mal. Intenta de nuevo más tarde.';

  @override
  String get offlineNotice =>
      'Estás sin conexión. Algunas funciones pueden estar limitadas.';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get groupSection => 'Mis Grupos';

  @override
  String get createGroup => 'Crear grupo de oración';

  @override
  String get inviteFriends => 'Invitar amigos';

  @override
  String get groupInviteMessage =>
      '¡Oremos juntos! Únete a mi grupo de oración en Abba.';

  @override
  String get noGroups => 'Únete o crea un grupo para orar juntos.';

  @override
  String get promoTitle => 'Oferta de lanzamiento';

  @override
  String get promoBanner => '¡3 meses a \$3.99/mes!';

  @override
  String promoEndsOn(Object date) {
    return 'Oferta hasta $date';
  }

  @override
  String get premiumLimitTitle => 'La oración de hoy está completa';

  @override
  String get premiumLimitBody =>
      '¡Nos vemos mañana!\nOra sin límites con Premium';

  @override
  String get laterButton => 'Quizás después';

  @override
  String get premiumPromptTitle => 'Función Pro';

  @override
  String get premiumPromptBody =>
      'Esta función está disponible con Pro.\n¿Te gustaría ver nuestros planes?';

  @override
  String get viewProducts => 'Ver planes';

  @override
  String get maybeLater => 'Quizás después';

  @override
  String get premiumHeadline => 'Más cerca de Dios, cada día';

  @override
  String get premiumBenefit1 => 'Oración & QT ilimitados';

  @override
  String get premiumBenefit2 => 'Oración y guía con IA';

  @override
  String get premiumBenefit3 => 'Historias de fe';

  @override
  String get premiumBenefit4 => 'Lectura de oración (TTS)';

  @override
  String get premiumBenefit5 => 'Estudio bíblico en idioma original';

  @override
  String get bestValue => 'MEJOR VALOR';

  @override
  String get perMonth => 'mes';

  @override
  String get cancelAnytime => 'Cancela cuando quieras';

  @override
  String get restorePurchase => 'Restaurar compra';

  @override
  String get yearlyPriceMonthly => '\$2.08/mes';

  @override
  String get morningPrayerReminder => 'Oración matutina';

  @override
  String get eveningGratitudeReminder => 'Gratitud vespertina';

  @override
  String get streakReminder => 'Recordatorio de racha';

  @override
  String get afternoonNudgeReminder => 'Recordatorio de oración vespertina';

  @override
  String get weeklySummaryReminder => 'Resumen semanal';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String get streakRecovery => 'Está bien, puedes empezar de nuevo 🌱';

  @override
  String get prayerSaved => 'Oración guardada exitosamente';

  @override
  String get quietTimeLabel => 'Tiempo de quietud';

  @override
  String get morningPrayerLabel => 'Oración matutina';

  @override
  String get gardenSeed => 'Semilla de fe';

  @override
  String get gardenSprout => 'Brote creciendo';

  @override
  String get gardenBud => 'Capullo';

  @override
  String get gardenBloom => 'Flor en plena';

  @override
  String get gardenTree => 'Árbol fuerte';

  @override
  String get gardenForest => 'Bosque de oración';

  @override
  String get milestoneShare => 'Compartir';

  @override
  String get milestoneThankGod => '¡Gracias a Dios!';

  @override
  String shareStreakText(Object count) {
    return '¡$count días seguidos de oración! Mi viaje con Abba #Abba #Oración';
  }

  @override
  String get shareDaysLabel => 'días de oración';

  @override
  String get shareSubtitle => 'Oración diaria con Dios';

  @override
  String get premiumActive => 'Premium Activo';

  @override
  String get planOncePerDay => '1x/día';

  @override
  String get planUnlimited => 'Ilimitado';

  @override
  String get closeRecording => 'Cerrar grabación';

  @override
  String get qtRevealMessage => 'Abramos la Palabra de hoy';

  @override
  String get qtSelectPrompt => 'Elige una y comienza el QT de hoy 🌿';

  @override
  String get qtTopicLabel => 'Tema';

  @override
  String get prayerStartPrompt => 'Comienza tu oración';

  @override
  String get startPrayerButton => 'Iniciar oración';

  @override
  String get switchToTextMode => 'Escribir en su lugar';

  @override
  String get prayerDashboardTitle => 'Jardín de Oración';

  @override
  String get qtDashboardTitle => 'Jardín Devocional';

  @override
  String get prayerSummaryTitle => 'Resumen de Oración';

  @override
  String get gratitudeLabel => 'Gratitud';

  @override
  String get petitionLabel => 'Petición';

  @override
  String get intercessionLabel => 'Intercesión';

  @override
  String get historicalStoryTitle => 'Historia';

  @override
  String get todayLesson => 'Lección de hoy';

  @override
  String get meditationAnalysisTitle => 'Análisis de Meditación';

  @override
  String get keyThemeLabel => 'Tema clave';

  @override
  String get applicationTitle => 'Aplicación de hoy';

  @override
  String get applicationWhat => 'Qué';

  @override
  String get applicationWhen => 'Cuándo';

  @override
  String get applicationContext => 'Dónde';

  @override
  String get relatedKnowledgeTitle => 'Conocimiento Relacionado';

  @override
  String get originalWordLabel => 'Palabra original';

  @override
  String get historicalContextLabel => 'Contexto histórico';

  @override
  String get crossReferencesLabel => 'Referencias cruzadas';

  @override
  String get growthStoryTitle => 'Historia de Crecimiento';

  @override
  String get prayerGuideTitle => 'Cómo orar con Abba';

  @override
  String get prayerGuide1 => 'Ora en voz alta, por favor';

  @override
  String get prayerGuide2 =>
      'Abba escucha tu oración y encuentra versículos para tu corazón';

  @override
  String get prayerGuide3 => 'También puedes escribir tu oración';

  @override
  String get qtGuideTitle => 'Cómo meditar con Abba';

  @override
  String get qtGuide1 => 'Lee el pasaje y medita en silencio';

  @override
  String get qtGuide2 =>
      'Comparte lo que descubriste en voz alta o por escrito';

  @override
  String get qtGuide3 =>
      'Abba te ayudará a aplicar la Palabra a tu vida diaria';

  @override
  String get scriptureReasonLabel => 'Por qué esta Escritura';

  @override
  String get seeMore => 'Ver más';

  @override
  String seeAllComments(Object count) {
    return 'Ver los $count comentarios';
  }

  @override
  String likedBy(Object name, Object count) {
    return 'A $name y $count más les gustó';
  }

  @override
  String get commentsTitle => 'Comentarios';

  @override
  String get myPageTitle => 'Mi Jardín de Oración';

  @override
  String get myPrayers => 'Mis Oraciones';

  @override
  String get myTestimonies => 'Mis Testimonios';

  @override
  String get savedPosts => 'Guardados';

  @override
  String get totalPrayersCount => 'Oraciones';

  @override
  String get streakCount => 'Racha';

  @override
  String get testimoniesCount => 'Testimonios';

  @override
  String get linkAccountTitle => 'Vincular cuenta';

  @override
  String get linkAccountDescription =>
      'Vincula tu cuenta para conservar tus registros de oración al cambiar de dispositivo';

  @override
  String get linkWithApple => 'Vincular con Apple';

  @override
  String get linkWithGoogle => 'Vincular con Google';

  @override
  String get linkAccountSuccess => '¡Cuenta vinculada exitosamente!';

  @override
  String get anonymousUser => 'Guerrero de oración';

  @override
  String showReplies(Object count) {
    return 'Ver $count respuestas';
  }

  @override
  String get hideReplies => 'Ocultar respuestas';

  @override
  String replyingTo(Object name) {
    return 'Respondiendo a $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Ver los $count comentarios';
  }
}
