// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Abba';

  @override
  String get welcomeTitle => 'Quando você ora,\nDeus responde.';

  @override
  String get welcomeSubtitle =>
      'Seu companheiro diário de oração e tempo devocional';

  @override
  String get getStarted => 'Começar';

  @override
  String get loginTitle => 'Bem-vindo ao Abba';

  @override
  String get loginSubtitle => 'Entre para iniciar sua jornada de oração';

  @override
  String get signInWithApple => 'Continuar com Apple';

  @override
  String get signInWithGoogle => 'Continuar com Google';

  @override
  String get signInWithEmail => 'Continuar com E-mail';

  @override
  String greetingMorning(Object name) {
    return 'Bom dia, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Boa tarde, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Boa noite, $name';
  }

  @override
  String get prayButton => 'Orar';

  @override
  String get qtButton => 'Devocional';

  @override
  String streakDays(Object count) {
    return '$count dias consecutivos de oração';
  }

  @override
  String get dailyVerse => 'Versículo do Dia';

  @override
  String get tabHome => 'Início';

  @override
  String get tabCalendar => 'Calendário';

  @override
  String get tabCommunity => 'Comunidade';

  @override
  String get tabSettings => 'Configurações';

  @override
  String get recordingTitle => 'Orando...';

  @override
  String get recordingPause => 'Pausar';

  @override
  String get recordingResume => 'Continuar';

  @override
  String get finishPrayer => 'Finalizar Oração';

  @override
  String get finishPrayerConfirm => 'Deseja finalizar sua oração?';

  @override
  String get switchToText => 'Digitar';

  @override
  String get textInputHint => 'Digite sua oração aqui...';

  @override
  String get aiLoadingText => 'Refletindo sobre sua oração...';

  @override
  String get aiLoadingVerse =>
      'Aquietai-vos e sabei que eu sou Deus.\n— Salmo 46:10';

  @override
  String get aiErrorNetworkTitle => 'Conexão instável';

  @override
  String get aiErrorNetworkBody =>
      'Sua oração está guardada em segurança. Tente novamente em um instante.';

  @override
  String get aiErrorApiTitle => 'Serviço de IA instável';

  @override
  String get aiErrorApiBody =>
      'Sua oração está guardada em segurança. Tente novamente em um instante.';

  @override
  String get aiErrorRetry => 'Tentar novamente';

  @override
  String get aiErrorWaitAndCheck =>
      'Tentaremos a análise mais tarde. Volte em breve — sua oração estará esperando por você.';

  @override
  String get aiErrorHome => 'Voltar ao início';

  @override
  String get dashboardTitle => 'Jardim de Oração';

  @override
  String get shareButton => 'Compartilhar';

  @override
  String get backToHome => 'Voltar ao Início';

  @override
  String get scriptureTitle => 'Escritura de Hoje';

  @override
  String get bibleStoryTitle => 'História Bíblica';

  @override
  String get testimonyTitle => 'Testemunho · Minha oração';

  @override
  String get testimonyHelperText =>
      'Reflita sobre sua oração · pode ser compartilhado com a comunidade';

  @override
  String get myPrayerAudioLabel => 'Gravação da minha oração';

  @override
  String get testimonyEdit => 'Editar';

  @override
  String get guidanceTitle => 'Orientação da IA';

  @override
  String get aiPrayerTitle => 'Uma Oração para Você';

  @override
  String get originalLangTitle => 'Língua Original';

  @override
  String get proUnlock => 'Desbloquear com Pro';

  @override
  String get proPreviewHistoricalHint =>
      'Descubra a história mais profunda por trás de uma palavra da sua oração';

  @override
  String get proPreviewPrayerHint =>
      'Uma oração de 300 palavras está esperando por você';

  @override
  String get proPreviewCoachingHint =>
      'Um conselho espera para aprofundar sua próxima oração';

  @override
  String get qtPageTitle => 'Jardim Matinal';

  @override
  String get qtMeditateButton => 'Iniciar Meditação';

  @override
  String get qtCompleted => 'Concluído';

  @override
  String get communityTitle => 'Jardim de Oração';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterTestimony => 'Testemunho';

  @override
  String get filterPrayerRequest => 'Pedido de Oração';

  @override
  String get likeButton => 'Curtir';

  @override
  String get commentButton => 'Comentar';

  @override
  String get saveButton => 'Salvar';

  @override
  String get replyButton => 'Responder';

  @override
  String get writePostTitle => 'Compartilhar';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get sharePostButton => 'Compartilhar';

  @override
  String get anonymousToggle => 'Anônimo';

  @override
  String get realNameToggle => 'Nome Real';

  @override
  String get categoryTestimony => 'Testemunho';

  @override
  String get categoryPrayerRequest => 'Pedido de Oração';

  @override
  String get writePostHint =>
      'Compartilhe seu testemunho ou pedido de oração...';

  @override
  String get importFromPrayer => 'Importar da oração';

  @override
  String get calendarTitle => 'Calendário de Oração';

  @override
  String get currentStreak => 'Sequência Atual';

  @override
  String get bestStreak => 'Melhor Sequência';

  @override
  String get days => 'dias';

  @override
  String calendarRecordCount(Object count) {
    return '$count registros';
  }

  @override
  String get todayVerse => 'Versículo de Hoje';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get profileSection => 'Perfil';

  @override
  String get totalPrayers => 'Total de Orações';

  @override
  String get consecutiveDays => 'Dias Consecutivos';

  @override
  String get proSection => 'Assinatura';

  @override
  String get freePlan => 'Gratuito';

  @override
  String get proPlan => 'Pro';

  @override
  String get monthlyPrice => 'R\$34,90 / mês';

  @override
  String get yearlyPrice => 'R\$249,90 / ano';

  @override
  String get yearlySave => 'Economize 40%';

  @override
  String get launchPromo => '';

  @override
  String get startPro => 'Iniciar Pro';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get notificationSetting => 'Notificações';

  @override
  String get languageSetting => 'Idioma';

  @override
  String get darkModeSetting => 'Modo Escuro';

  @override
  String get helpCenter => 'Central de Ajuda';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get logout => 'Sair';

  @override
  String appVersion(Object version) {
    return 'Versão $version';
  }

  @override
  String get anonymous => 'Anônimo';

  @override
  String timeAgo(Object time) {
    return 'há $time';
  }

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get signIn => 'Entrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get noPrayersRecorded => 'Nenhuma oração registrada';

  @override
  String get deletePost => 'Excluir';

  @override
  String get reportPost => 'Denunciar';

  @override
  String get reportSubmitted => 'Denúncia enviada. Obrigado.';

  @override
  String get reportReasonHint =>
      'Descreva o motivo da denúncia. Será enviado por e-mail.';

  @override
  String get reportReasonPlaceholder => 'Digite o motivo da denúncia...';

  @override
  String get reportSubmitButton => 'Denunciar';

  @override
  String get deleteConfirmTitle => 'Excluir Publicação';

  @override
  String get deleteConfirmMessage =>
      'Tem certeza de que deseja excluir esta publicação?';

  @override
  String get errorNetwork =>
      'Verifique sua conexão com a internet e tente novamente.';

  @override
  String get errorAiFallback =>
      'Não conseguimos conectar à IA agora. Aqui está um versículo para você.';

  @override
  String get errorSttFailed =>
      'O reconhecimento de voz não está disponível. Por favor, digite.';

  @override
  String get errorPayment =>
      'Houve um problema com o pagamento. Tente novamente em Configurações.';

  @override
  String get errorGeneric => 'Algo deu errado. Tente novamente mais tarde.';

  @override
  String get offlineNotice =>
      'Você está offline. Alguns recursos podem estar limitados.';

  @override
  String get retryButton => 'Tentar Novamente';

  @override
  String get groupSection => 'Meus Grupos';

  @override
  String get createGroup => 'Criar Grupo de Oração';

  @override
  String get inviteFriends => 'Convidar Amigos';

  @override
  String get groupInviteMessage =>
      'Vamos orar juntos! Junte-se ao meu grupo de oração no Abba.';

  @override
  String get noGroups => 'Participe ou crie um grupo para orar juntos.';

  @override
  String get promoTitle => 'Oferta de Lançamento';

  @override
  String get promoBanner => '';

  @override
  String promoEndsOn(Object date) {
    return 'Oferta termina em $date';
  }

  @override
  String get proLimitTitle => 'Oração de hoje concluída';

  @override
  String get proLimitBody => 'Até amanhã!\nOre sem limites com o Pro';

  @override
  String get laterButton => 'Talvez depois';

  @override
  String get proPromptTitle => 'Recurso Pro';

  @override
  String get proPromptBody =>
      'Este recurso está disponível com o Pro.\nGostaria de ver nossos planos?';

  @override
  String get viewProducts => 'Ver Planos';

  @override
  String get maybeLater => 'Talvez depois';

  @override
  String get proHeadline => 'Mais perto de Deus, todos os dias';

  @override
  String get proBenefit1 => 'Oração e Devocional ilimitados';

  @override
  String get proBenefit2 => 'Oração e orientação com IA';

  @override
  String get proBenefit3 => 'Histórias de fé ao longo da história';

  @override
  String get proBenefit5 => 'Estudo bíblico na língua original';

  @override
  String get bestValue => 'MELHOR VALOR';

  @override
  String get perMonth => 'mês';

  @override
  String get cancelAnytime => 'Cancele a qualquer momento';

  @override
  String get restorePurchase => 'Restaurar compra';

  @override
  String get yearlyPriceMonthly => 'R\$20,83/mês';

  @override
  String get morningPrayerReminder => 'Oração Matinal';

  @override
  String get eveningGratitudeReminder => 'Gratidão Noturna';

  @override
  String get streakReminder => 'Lembrete de Sequência';

  @override
  String get afternoonNudgeReminder => 'Lembrete de Oração Vespertina';

  @override
  String get weeklySummaryReminder => 'Resumo Semanal';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String get streakRecovery => 'Tudo bem, você pode recomeçar 🌱';

  @override
  String get prayerSaved => 'Oração salva com sucesso';

  @override
  String get quietTimeLabel => 'Devocional';

  @override
  String get morningPrayerLabel => 'Oração Matinal';

  @override
  String get gardenSeed => 'Uma semente de fé';

  @override
  String get gardenSprout => 'Broto crescendo';

  @override
  String get gardenBud => 'Flor em botão';

  @override
  String get gardenBloom => 'Flor desabrochada';

  @override
  String get gardenTree => 'Árvore forte';

  @override
  String get gardenForest => 'Floresta de oração';

  @override
  String get milestoneShare => 'Compartilhar';

  @override
  String get milestoneThankGod => 'Graças a Deus!';

  @override
  String shareStreakText(Object count) {
    return '$count dias consecutivos de oração! Minha jornada de oração com Abba #Abba #Oração';
  }

  @override
  String get shareDaysLabel => 'dias consecutivos de oração';

  @override
  String get shareSubtitle => 'Oração diária com Deus';

  @override
  String get proActive => 'Assinatura Ativa';

  @override
  String get planOncePerDay => '1x/dia';

  @override
  String get planUnlimited => 'Ilimitado';

  @override
  String get closeRecording => 'Fechar gravação';

  @override
  String get qtRevealMessage => 'Vamos abrir a Palavra de hoje';

  @override
  String get qtSelectPrompt => 'Escolha um e comece o devocional de hoje';

  @override
  String get qtTopicLabel => 'Tema';

  @override
  String get prayerStartPrompt => 'Comece sua oração';

  @override
  String get startPrayerButton => 'Iniciar Oração';

  @override
  String get switchToTextMode => 'Digitar';

  @override
  String get switchToVoiceMode => 'Falar';

  @override
  String get prayerDashboardTitle => 'Jardim de Oração';

  @override
  String get qtDashboardTitle => 'Jardim Devocional';

  @override
  String get prayerSummaryTitle => 'Resumo da Oração';

  @override
  String get gratitudeLabel => 'Gratidão';

  @override
  String get petitionLabel => 'Petição';

  @override
  String get intercessionLabel => 'Intercessão';

  @override
  String get historicalStoryTitle => 'História da Fé';

  @override
  String get todayLesson => 'Lição de Hoje';

  @override
  String get applicationTitle => 'Aplicação de Hoje';

  @override
  String get applicationWhat => 'O quê';

  @override
  String get applicationWhen => 'Quando';

  @override
  String get applicationContext => 'Onde';

  @override
  String get applicationMorningLabel => 'Manhã';

  @override
  String get applicationDayLabel => 'Dia';

  @override
  String get applicationEveningLabel => 'Noite';

  @override
  String get relatedKnowledgeTitle => 'Conhecimento Relacionado';

  @override
  String get originalWordLabel => 'Palavra Original';

  @override
  String get historicalContextLabel => 'Contexto Histórico';

  @override
  String get crossReferencesLabel => 'Referências Cruzadas';

  @override
  String get growthStoryTitle => 'História de Crescimento';

  @override
  String get prayerGuideTitle => 'Como orar com Abba';

  @override
  String get prayerGuide1 => 'Ore em voz alta ou com voz clara';

  @override
  String get prayerGuide2 =>
      'Abba ouve suas palavras e encontra Escrituras que falam ao seu coração';

  @override
  String get prayerGuide3 => 'Você também pode digitar sua oração, se preferir';

  @override
  String get qtGuideTitle => 'Como fazer devocional com Abba';

  @override
  String get qtGuide1 => 'Leia a passagem e medite em silêncio';

  @override
  String get qtGuide2 =>
      'Compartilhe o que descobriu — fale ou digite sua reflexão';

  @override
  String get qtGuide3 =>
      'Abba ajudará você a aplicar a Palavra no seu dia a dia';

  @override
  String get scriptureReasonLabel => 'Por que esta Escritura';

  @override
  String get scripturePostureLabel => 'Com que atitude devo ler isto?';

  @override
  String get scriptureOriginalWordsTitle =>
      'Significado mais profundo no idioma original';

  @override
  String get originalWordMeaningLabel => 'Significado';

  @override
  String get originalWordNuanceLabel => 'Nuance vs tradução';

  @override
  String originalWordsCountLabel(int count) {
    return '$count palavras';
  }

  @override
  String get seeMore => 'Ver mais';

  @override
  String get seeLess => 'Ver menos';

  @override
  String seeAllComments(Object count) {
    return 'Ver todos os $count comentários';
  }

  @override
  String likedBy(Object name, Object count) {
    return '$name e $count outros curtiram';
  }

  @override
  String get commentsTitle => 'Comentários';

  @override
  String get myPageTitle => 'Meu Jardim de Oração';

  @override
  String get myPrayers => 'Minhas Orações';

  @override
  String get myTestimonies => 'Meus Testemunhos';

  @override
  String get savedPosts => 'Salvos';

  @override
  String get totalPrayersCount => 'Orações';

  @override
  String get streakCount => 'Sequência';

  @override
  String get testimoniesCount => 'Testemunhos';

  @override
  String get linkAccountTitle => 'Vincular Conta';

  @override
  String get linkAccountDescription =>
      'Vincule sua conta para manter seus registros de oração ao trocar de dispositivo';

  @override
  String get linkWithApple => 'Vincular com Apple';

  @override
  String get linkWithGoogle => 'Vincular com Google';

  @override
  String get linkAccountSuccess => 'Conta vinculada com sucesso!';

  @override
  String get anonymousUser => 'Guerreiro de Oração';

  @override
  String showReplies(Object count) {
    return 'Ver $count respostas';
  }

  @override
  String get hideReplies => 'Ocultar respostas';

  @override
  String replyingTo(Object name) {
    return 'Respondendo a $name';
  }

  @override
  String viewAllComments(Object count) {
    return 'Ver todos os $count comentários';
  }

  @override
  String get membershipTitle => 'Assinatura';

  @override
  String get membershipSubtitle => 'Aprofunde sua vida de oração';

  @override
  String get monthlyPlan => 'Mensal';

  @override
  String get yearlyPlan => 'Anual';

  @override
  String get yearlySavings => 'R\$14,07/mês (40% de desconto)';

  @override
  String get startMembership => 'Começar';

  @override
  String get membershipActive => 'Assinatura Ativa';

  @override
  String get leaveRecordingTitle => 'Sair da gravação?';

  @override
  String get leaveRecordingMessage => 'Sua gravação será perdida. Tem certeza?';

  @override
  String get leaveButton => 'Sair';

  @override
  String get stayButton => 'Ficar';

  @override
  String likedByCount(Object count) {
    return '$count pessoas empatizaram';
  }

  @override
  String get actionLike => 'Curtir';

  @override
  String get actionComment => 'Comentar';

  @override
  String get actionSave => 'Salvar';

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
  String get billingIssueTitle => 'Problema de pagamento detectado';

  @override
  String billingIssueBody(int days) {
    return 'Seus benefícios Pro terminarão em $days dias se o pagamento não for atualizado.';
  }

  @override
  String get billingIssueAction => 'Atualizar pagamento';

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
      '💛 Amor — Pense em alguém que você ama por 10 segundos';

  @override
  String get qtLoadingHint2 =>
      '🌿 Graça — Lembre-se de uma pequena graça recebida hoje';

  @override
  String get qtLoadingHint3 =>
      '🌅 Esperança — Imagine uma pequena esperança para amanhã';

  @override
  String get qtLoadingHint4 => '🕊️ Paz — Respire fundo três vezes, devagar';

  @override
  String get qtLoadingHint5 => '🌳 Fé — Lembre-se de uma verdade imutável';

  @override
  String get qtLoadingHint6 =>
      '🌸 Gratidão — Diga uma coisa pela qual é grato agora';

  @override
  String get qtLoadingHint7 => '🌊 Perdão — Traga à mente alguém para perdoar';

  @override
  String get qtLoadingHint8 => '📖 Sabedoria — Guarde uma lição de hoje';

  @override
  String get qtLoadingHint9 => '⏳ Paciência — Pense no que espera em silêncio';

  @override
  String get qtLoadingHint10 => '✨ Alegria — Lembre-se de um sorriso de hoje';

  @override
  String get qtLoadingTitle => 'Preparando a Palavra de hoje...';

  @override
  String get coachingTitle => 'Coaching de oração';

  @override
  String get coachingLoadingText => 'Refletindo sobre sua oração...';

  @override
  String get coachingErrorText =>
      'Erro temporário — por favor, tente novamente';

  @override
  String get coachingRetryButton => 'Tentar novamente';

  @override
  String get coachingScoreSpecificity => 'Especificidade';

  @override
  String get coachingScoreGodCentered => 'Centrado em Deus';

  @override
  String get coachingScoreActs => 'Equilíbrio ACTS';

  @override
  String get coachingScoreAuthenticity => 'Autenticidade';

  @override
  String get coachingStrengthsTitle => 'O que você fez bem ✨';

  @override
  String get coachingImprovementsTitle => 'Para ir mais fundo 💡';

  @override
  String get coachingProCta => 'Desbloqueie o Coaching com o Pro';

  @override
  String get coachingLevelBeginner => '🌱 Iniciante';

  @override
  String get coachingLevelGrowing => '🌿 Crescendo';

  @override
  String get coachingLevelExpert => '🌳 Especialista';

  @override
  String get aiPrayerCitationsTitle => 'Referências · Citações';

  @override
  String get citationTypeQuote => 'Citação';

  @override
  String get citationTypeScience => 'Estudo';

  @override
  String get citationTypeExample => 'Exemplo';

  @override
  String get citationTypeHistory => 'História';

  @override
  String get aiPrayerReadingTime => 'Leitura de 2 minutos';

  @override
  String get scriptureKeyWordHintTitle => 'Palavra-chave de hoje';

  @override
  String get bibleLookupReferenceHint =>
      'Encontre esta passagem em sua Bíblia e medite nela.';

  @override
  String bibleTranslationAttribution(String name) {
    return '($name, Public Domain)';
  }

  @override
  String get settingsBibleTranslationsLabel => 'Traduções da Bíblia';

  @override
  String get settingsBibleTranslationsIntro =>
      'Os versículos bíblicos deste aplicativo vêm de traduções de domínio público. Comentários, orações e histórias gerados por IA são obra criativa da Abba.';

  @override
  String get meditationSummaryTitle => 'Meditação de hoje';

  @override
  String get meditationTopicLabel => 'Tema';

  @override
  String get meditationSummaryLabel => 'Em uma frase';

  @override
  String get qtScriptureTitle => 'Passagem de hoje';

  @override
  String get qtCoachingTitle => 'Coaching de QT';

  @override
  String get qtCoachingLoadingText => 'Refletindo sobre sua meditação...';

  @override
  String get qtCoachingErrorText =>
      'Erro temporário — por favor, tente novamente';

  @override
  String get qtCoachingRetryButton => 'Tentar novamente';

  @override
  String get qtCoachingScoreComprehension => 'Compreensão do texto';

  @override
  String get qtCoachingScoreApplication => 'Aplicação pessoal';

  @override
  String get qtCoachingScoreDepth => 'Profundidade espiritual';

  @override
  String get qtCoachingScoreAuthenticity => 'Autenticidade';

  @override
  String get qtCoachingStrengthsTitle => 'O que você fez bem ✨';

  @override
  String get qtCoachingImprovementsTitle => 'Para ir mais fundo 💡';

  @override
  String get qtCoachingProCta => 'Desbloqueie o Coaching de QT com o Pro';

  @override
  String get qtCoachingLevelBeginner => '🌱 Iniciante';

  @override
  String get qtCoachingLevelGrowing => '🌿 Crescendo';

  @override
  String get qtCoachingLevelExpert => '🌳 Especialista';

  @override
  String get notifyMorning1Title => '🙏 Hora de orar';

  @override
  String notifyMorning1Body(String name) {
    return '$name, converse com Deus hoje também';
  }

  @override
  String get notifyMorning2Title => '🌅 Uma nova manhã chegou';

  @override
  String notifyMorning2Body(String name) {
    return '$name, comece o dia com gratidão';
  }

  @override
  String get notifyMorning3Title => '✨ A graça de hoje';

  @override
  String notifyMorning3Body(String name) {
    return '$name, encontre a graça que Deus preparou';
  }

  @override
  String get notifyMorning4Title => '🕊️ Manhã de paz';

  @override
  String notifyMorning4Body(String name) {
    return '$name, encha o coração de paz pela oração';
  }

  @override
  String get notifyMorning5Title => '📖 Com a Palavra';

  @override
  String notifyMorning5Body(String name) {
    return '$name, escute a voz de Deus hoje';
  }

  @override
  String get notifyMorning6Title => '🌿 Hora de descansar';

  @override
  String notifyMorning6Body(String name) {
    return '$name, pare um instante e ore';
  }

  @override
  String get notifyMorning7Title => '💫 Hoje também';

  @override
  String notifyMorning7Body(String name) {
    return '$name, um dia que começa com oração é diferente';
  }

  @override
  String get notifyEvening1Title => '✨ Grato por hoje';

  @override
  String get notifyEvening1Body =>
      'Recapitule o dia e ofereça uma oração de gratidão';

  @override
  String get notifyEvening2Title => '🌙 Encerrando o dia';

  @override
  String get notifyEvening2Body => 'Expresse a gratidão de hoje em oração';

  @override
  String get notifyEvening3Title => '🙏 Oração da noite';

  @override
  String get notifyEvening3Body => 'No fim do dia, agradeça a Deus';

  @override
  String get notifyEvening4Title => '🌟 Contando as bênçãos de hoje';

  @override
  String get notifyEvening4Body =>
      'Se tem algo a agradecer, compartilhe em oração';

  @override
  String get notifyStreak3Title => '🌱 3 dias seguidos!';

  @override
  String get notifyStreak3Body => 'Seu hábito de oração começou';

  @override
  String get notifyStreak7Title => '🌿 Uma semana seguida!';

  @override
  String get notifyStreak7Body => 'A oração está virando um hábito';

  @override
  String get notifyStreak14Title => '🌳 2 semanas seguidas!';

  @override
  String get notifyStreak14Body => 'Que crescimento incrível!';

  @override
  String get notifyStreak21Title => '🌻 3 semanas seguidas!';

  @override
  String get notifyStreak21Body => 'A flor da oração está desabrochando';

  @override
  String get notifyStreak30Title => '🏆 Um mês inteiro!';

  @override
  String get notifyStreak30Body => 'Sua oração está brilhando';

  @override
  String get notifyStreak50Title => '👑 50 dias seguidos!';

  @override
  String get notifyStreak50Body =>
      'Sua caminhada com Deus está se aprofundando';

  @override
  String get notifyStreak100Title => '🎉 100 dias seguidos!';

  @override
  String get notifyStreak100Body => 'Você se tornou um guerreiro de oração!';

  @override
  String get notifyStreak365Title => '✝️ Um ano inteiro!';

  @override
  String get notifyStreak365Body => 'Que jornada de fé incrível!';

  @override
  String get notifyAfternoonNudgeTitle => '☀️ Você já orou hoje?';

  @override
  String get notifyAfternoonNudgeBody => 'Uma breve oração pode mudar o dia';

  @override
  String get notifyChannelName => 'Lembretes de oração';

  @override
  String get notifyChannelDescription =>
      'Oração da manhã, gratidão noturna e outros lembretes';

  @override
  String get milestoneFirstPrayerTitle => 'Primeira oração!';

  @override
  String get milestoneFirstPrayerDesc =>
      'Sua jornada de oração começou. Deus está ouvindo.';

  @override
  String get milestoneSevenDayStreakTitle => '7 dias de oração!';

  @override
  String get milestoneSevenDayStreakDesc =>
      'Uma semana de oração fiel. Seu jardim está crescendo!';

  @override
  String get milestoneThirtyDayStreakTitle => '30 dias!';

  @override
  String get milestoneThirtyDayStreakDesc =>
      'Seu jardim floresceu em um campo de flores!';

  @override
  String get milestoneHundredPrayersTitle => '100ª oração!';

  @override
  String get milestoneHundredPrayersDesc =>
      'Cem conversas com Deus. Você está profundamente enraizado.';

  @override
  String get homeFirstPrayerPrompt => 'Comece sua primeira oração';

  @override
  String get homeFirstQtPrompt => 'Comece seu primeiro QT';

  @override
  String homeActivityPrompt(String activityName) {
    return 'Hoje também faça $activityName';
  }

  @override
  String homeStreakInProgress(int count, String activityName) {
    return 'Dia $count contínuo de $activityName';
  }

  @override
  String homeDaysSinceLastActivity(int days, String activityName) {
    return 'Já se passaram $days dias desde seu último $activityName';
  }

  @override
  String get homeActivityPrayer => 'oração';

  @override
  String get homeActivityQt => 'QT';

  @override
  String get prayerPlayerLoading => 'Carregando...';

  @override
  String get heatmapNoPrayer => 'Sem oração';

  @override
  String get heatmapLegendLess => 'Menos';

  @override
  String get heatmapLegendMore => 'Mais';

  @override
  String get qtPassagesLoadError =>
      'Não foi possível carregar as passagens de hoje. Verifique sua conexão.';

  @override
  String get qtPassagesRetryButton => 'Tentar novamente';

  @override
  String get aiStreamingInitial => 'Meditando em sua oração...';

  @override
  String get aiTierProcessing => 'Mais reflexões a caminho...';

  @override
  String get aiScriptureValidating => 'Buscando a passagem certa...';

  @override
  String get aiScriptureValidatingFailed =>
      'Preparando esta passagem para você...';

  @override
  String get aiTemplateFallback =>
      'Enquanto preparamos sua análise completa...';

  @override
  String get aiPendingMore => 'Preparando mais...';

  @override
  String get aiTierIncomplete => 'Em breve, volte a verificar mais tarde';

  @override
  String get tierCompleted => 'Nova reflexão adicionada';

  @override
  String get tierProcessingNotice => 'Gerando mais reflexões...';

  @override
  String get proSectionLoading => 'Preparando seu conteúdo premium...';

  @override
  String get proSectionWillArrive => 'Sua reflexão profunda aparecerá aqui';

  @override
  String get templateCategoryHealth => 'Para preocupações de saúde';

  @override
  String get templateCategoryFamily => 'Para a família';

  @override
  String get templateCategoryWork => 'Para o trabalho e estudos';

  @override
  String get templateCategoryGratitude => 'Um coração agradecido';

  @override
  String get templateCategoryGrief => 'Em tempos de luto';

  @override
  String get sectionStatusCompleted => 'Análise concluída';

  @override
  String get sectionStatusPartial => 'Análise parcial (mais a caminho)';

  @override
  String get sectionStatusPending => 'Análise em andamento';

  @override
  String get trialStartCta => 'Começar 1 mês grátis';

  @override
  String trialAutoRenewDisclosure(Object price) {
    return 'Depois $price/ano, com renovação automática. Cancele quando quiser nas Configurações.';
  }

  @override
  String get trialLimitTitle => 'Você orou 3 vezes hoje 🌸';

  @override
  String get trialLimitBody =>
      'Volte amanhã — ou desbloqueie orações ilimitadas com o Pro.';

  @override
  String get trialLimitCta => 'Continuar com Pro';

  @override
  String get prayerTooShort => 'Por favor, escreva um pouco mais';

  @override
  String get switchToTextModeTitle => 'Mudar para modo texto?';

  @override
  String get switchToTextModeBody =>
      'Sua gravação de voz até agora será descartada. Você precisará escrever sua oração como texto.';

  @override
  String get switchToTextModeConfirm => 'Mudar para texto';

  @override
  String get switchToTextModeCancel => 'Continuar gravando';

  @override
  String get recordingInterruptedTitle =>
      'Sua gravação de oração foi interrompida';

  @override
  String get recordingInterruptedBody =>
      'Enquanto você estava ausente, a gravação parou. O que você gostaria de fazer?';

  @override
  String get recordingInterruptedRestart => 'Reiniciar gravação';

  @override
  String get recordingInterruptedSwitchToText => 'Escrever como texto';

  @override
  String get dashboardPartialFailedQt =>
      'Não foi possível carregar parte do conteúdo de meditação. Inicie uma nova meditação.';

  @override
  String get dashboardPartialFailedPrayer =>
      'Não foi possível carregar parte da análise de oração. Inicie uma nova oração.';

  @override
  String get dashboardPartialFailedHint => 'O que já foi salvo é mantido.';
}
