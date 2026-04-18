import 'package:app_lib_auth/auth.dart' hide UserProfile;
import 'package:app_lib_core/core.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:app_lib_supabase_client/supabase_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'app.dart';
import 'config/app_config.dart';
import 'router/app_router.dart';
import 'providers/providers.dart';
import 'services/error_logging_service.dart';
import 'services/mock/mock_ai_service.dart';
import 'services/mock/mock_auth_repository.dart';
import 'services/mock/mock_community_repository.dart';
import 'services/mock/mock_notification_service.dart';
import 'services/mock/mock_prayer_repository.dart';
import 'services/mock/mock_qt_repository.dart';
import 'services/mock/mock_stt_service.dart';
import 'services/mock/mock_subscription_service.dart';
import 'services/mock/mock_tts_service.dart';
import 'services/mock_data.dart';
import 'services/notification_service.dart';
import 'services/cached_ai_service.dart';
import 'services/real/openai_service.dart';
import 'services/real/real_notification_service.dart';
import 'services/real/real_stt_service.dart';
import 'services/real/supabase_qt_repository.dart';
import 'services/real/google_cloud_tts_service.dart';
import 'services/real/on_device_tts_service.dart';
import 'services/real/hybrid_tts_service.dart';
import 'services/real/revenuecat_subscription_service.dart';
import 'services/real/supabase_community_repository.dart';
import 'services/real/supabase_prayer_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env.client (runtime)
  await dotenv.load(fileName: '.env.client');

  // Validate environment variables (skipped in mock mode)
  AppConfig.validate();

  // Initialize Sentry error logging
  await ErrorLoggingService.initialize();

  // Initialize structured logger with in-memory history
  logHistory = HistoryOutput(maxEntries: 500);
  appLogger = Logger(
    config: AppConfig.isProduction ? LogConfig.production : LogConfig.development,
    outputs: [
      const ConsoleOutput(),
      logHistory,
      if (AppConfig.sentryDsn.isNotEmpty)
        SentryBreadcrumbOutput(errorService: AbbaErrorLoggingBridge()),
    ],
    redactor: const LogRedactor(),
  );

  final overrides = [
    // Seed list with a dummy override so Dart infers the correct type.
    // Immediately replaced below based on mock/real mode.
    authRepositoryProvider.overrideWithValue(MockAuthRepository(MockDataService())),
  ];
  overrides.clear();

  AuthRepository authRepo;

  // Initialize notification service (local-only, works in both mock/real)
  NotificationService notificationService = RealNotificationService();
  try {
    await notificationService.initialize();
    await notificationService.requestPermission();
  } catch (e) {
    appLogger.warning('Notification init failed, falling back to mock', category: LogCategory.fcm, error: e);
    notificationService = MockNotificationService();
  }

  if (AppConfig.useMock) {
    // Mock mode — all services return JSON data
    final mockData = MockDataService();
    authRepo = MockAuthRepository(mockData);
    overrides.addAll([
      authRepositoryProvider.overrideWithValue(authRepo),
      aiServiceProvider.overrideWithValue(MockAiService(mockData)),
      sttServiceProvider.overrideWithValue(MockSttService()),
      ttsServiceProvider.overrideWithValue(
        HybridTtsService(
          primary: GoogleCloudTtsService(),
          fallback: OnDeviceTtsService(),
        ),
      ),
      prayerRepositoryProvider.overrideWithValue(MockPrayerRepository()),
      communityRepositoryProvider.overrideWithValue(
        MockCommunityRepository(mockData),
      ),
      subscriptionServiceProvider.overrideWithValue(MockSubscriptionService()),
      notificationServiceProvider.overrideWithValue(notificationService),
      qtRepositoryProvider.overrideWithValue(MockQtRepository(mockData)),
    ]);
  } else {
    // Real mode — connect to Supabase, OpenAI, etc.
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );
    } catch (e) {
      appLogger.warning('Supabase init failed, falling back to mock mode', category: LogCategory.db, error: e);
      final mockData = MockDataService();
      authRepo = MockAuthRepository(mockData);
      overrides.addAll([
        authRepositoryProvider.overrideWithValue(authRepo),
        aiServiceProvider.overrideWithValue(MockAiService(mockData)),
        sttServiceProvider.overrideWithValue(MockSttService()),
        ttsServiceProvider.overrideWithValue(MockTtsService()),
        prayerRepositoryProvider.overrideWithValue(MockPrayerRepository()),
        communityRepositoryProvider.overrideWithValue(
          MockCommunityRepository(mockData),
        ),
        subscriptionServiceProvider
            .overrideWithValue(MockSubscriptionService()),
        notificationServiceProvider.overrideWithValue(notificationService),
        qtRepositoryProvider.overrideWithValue(MockQtRepository(mockData)),
      ]);

      // Anonymous-first: auto sign in if no existing session
      await authRepo.signInAnonymously();

      final fallbackPrefs = await SharedPreferences.getInstance();
      final fallbackSeen = fallbackPrefs.getBool('has_seen_welcome') ?? false;
      appRouter = createAppRouter(
        initialLocation: fallbackSeen ? '/home' : '/welcome',
      );

      runApp(ProviderScope(overrides: overrides, child: const AbbaApp()));
      return;
    }

    final supabase = Supabase.instance.client;
    final appClient = AppSupabaseClient(
      config: SupabaseConfig(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
        appId: 'abba',
      ),
      client: supabase,
    );

    final googleAuth = GoogleAuthService(
      auth: supabase.auth,
      googleSignIn: GoogleSignIn(
        clientId: AppConfig.googleIosClientId,
        serverClientId: AppConfig.googleWebClientId,
      ),
    );
    final appleAuth = AppleAuthService(auth: supabase.auth);
    final emailAuth = EmailAuthService(auth: supabase.auth);

    authRepo = SupabaseAuthRepository(
      client: appClient,
      googleAuth: googleAuth,
      appleAuth: appleAuth,
      emailAuth: emailAuth,
    );

    overrides.addAll([
      authRepositoryProvider.overrideWithValue(authRepo),
      aiServiceProvider.overrideWithValue(CachedAiService(OpenAiService())),
      sttServiceProvider.overrideWithValue(RealSttService()),
      ttsServiceProvider.overrideWithValue(
        HybridTtsService(
          primary: GoogleCloudTtsService(),
          fallback: OnDeviceTtsService(),
        ),
      ),
      prayerRepositoryProvider.overrideWithValue(
        SupabasePrayerRepository(supabase),
      ),
      communityRepositoryProvider.overrideWithValue(
        SupabaseCommunityRepository(supabase),
      ),
      subscriptionServiceProvider.overrideWithValue(
        RevenueCatSubscriptionService(),
      ),
      notificationServiceProvider.overrideWithValue(notificationService),
      qtRepositoryProvider.overrideWithValue(SupabaseQtRepository(supabase)),
    ]);
  }

  // Anonymous-first: auto sign in if no existing session
  final currentUser = await authRepo.getCurrentUser();
  if (currentUser case Success(value: null)) {
    await authRepo.signInAnonymously();
  }

  // Load persisted settings
  final prefs = await SharedPreferences.getInstance();
  final hasSeenWelcome = prefs.getBool('has_seen_welcome') ?? false;
  final savedLocale = prefs.getString('locale');
  final savedDarkMode = prefs.getBool('dark_mode') ?? false;
  final savedVoice = prefs.getString('voice_preference');

  if (savedLocale != null) {
    overrides.add(localeProvider.overrideWith((ref) => savedLocale));
  }
  if (savedDarkMode) {
    overrides.add(themeModeProvider.overrideWith((ref) => ThemeMode.dark));
  }
  if (savedVoice != null) {
    overrides.add(voicePreferenceProvider.overrideWith((ref) => savedVoice));
  }

  // Create router with correct initial location (skip welcome if already seen)
  appRouter = createAppRouter(
    initialLocation: hasSeenWelcome ? '/home' : '/welcome',
  );

  runApp(ProviderScope(overrides: overrides, child: const AbbaApp()));
}
