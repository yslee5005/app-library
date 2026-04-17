import 'package:app_lib_auth/auth.dart' hide UserProfile;
import 'package:app_lib_core/core.dart';
import 'package:app_lib_supabase_client/supabase_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'app.dart';
import 'config/app_config.dart';
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
    debugPrint('Notification init failed: $e — falling back to mock');
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
      debugPrint('Supabase init failed: $e — falling back to mock mode');
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

  runApp(ProviderScope(overrides: overrides, child: const AbbaApp()));
}
