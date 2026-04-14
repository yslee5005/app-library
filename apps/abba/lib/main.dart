import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'config/app_config.dart';
import 'providers/providers.dart';
import 'services/auth_service.dart';
import 'services/error_logging_service.dart';
import 'services/mock/mock_ai_service.dart';
import 'services/mock/mock_auth_service.dart';
import 'services/mock/mock_community_repository.dart';
import 'services/mock/mock_notification_service.dart';
import 'services/mock/mock_prayer_repository.dart';
import 'services/mock/mock_qt_repository.dart';
import 'services/mock/mock_stt_service.dart';
import 'services/mock/mock_subscription_service.dart';
import 'services/mock/mock_tts_service.dart';
import 'services/mock_data.dart';
import 'services/cached_ai_service.dart';
import 'services/real/openai_service.dart';
import 'services/real/real_notification_service.dart';
import 'services/real/real_stt_service.dart';
import 'services/real/supabase_qt_repository.dart';
import 'services/real/real_tts_service.dart';
import 'services/real/revenuecat_subscription_service.dart';
import 'services/real/supabase_auth_service.dart';
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

  final overrides = <Override>[];

  AuthService authService;

  if (AppConfig.useMock) {
    // Mock mode — all services return JSON data
    final mockData = MockDataService();
    authService = MockAuthService(mockData);
    overrides.addAll([
      authServiceProvider.overrideWithValue(authService),
      aiServiceProvider.overrideWithValue(MockAiService(mockData)),
      sttServiceProvider.overrideWithValue(MockSttService()),
      ttsServiceProvider.overrideWithValue(MockTtsService()),
      prayerRepositoryProvider.overrideWithValue(MockPrayerRepository()),
      communityRepositoryProvider.overrideWithValue(
        MockCommunityRepository(mockData),
      ),
      subscriptionServiceProvider.overrideWithValue(MockSubscriptionService()),
      notificationServiceProvider.overrideWithValue(MockNotificationService()),
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
      // Fall back to mock mode if Supabase fails to initialize
      final mockData = MockDataService();
      authService = MockAuthService(mockData);
      overrides.addAll([
        authServiceProvider.overrideWithValue(authService),
        aiServiceProvider.overrideWithValue(MockAiService(mockData)),
        sttServiceProvider.overrideWithValue(MockSttService()),
        ttsServiceProvider.overrideWithValue(MockTtsService()),
        prayerRepositoryProvider.overrideWithValue(MockPrayerRepository()),
        communityRepositoryProvider.overrideWithValue(
          MockCommunityRepository(mockData),
        ),
        subscriptionServiceProvider
            .overrideWithValue(MockSubscriptionService()),
        notificationServiceProvider
            .overrideWithValue(MockNotificationService()),
        qtRepositoryProvider.overrideWithValue(MockQtRepository(mockData)),
      ]);

      // Anonymous-first: auto sign in if no existing session
      final currentUser = await authService.getCurrentUser();
      if (currentUser == null) {
        await authService.signInAnonymously();
      }

      runApp(ProviderScope(overrides: overrides, child: const AbbaApp()));
      return;
    }

    final supabase = Supabase.instance.client;
    final supabaseAuth = SupabaseAuthService(supabase);
    supabaseAuth.init(); // Attach listener after Supabase is confirmed ready
    authService = supabaseAuth;

    overrides.addAll([
      authServiceProvider.overrideWithValue(authService),
      aiServiceProvider.overrideWithValue(CachedAiService(OpenAiService())),
      sttServiceProvider.overrideWithValue(RealSttService()),
      ttsServiceProvider.overrideWithValue(RealTtsService()),
      prayerRepositoryProvider.overrideWithValue(
        SupabasePrayerRepository(supabase),
      ),
      communityRepositoryProvider.overrideWithValue(
        SupabaseCommunityRepository(supabase),
      ),
      subscriptionServiceProvider.overrideWithValue(
        RevenueCatSubscriptionService(),
      ),
      notificationServiceProvider.overrideWithValue(
        RealNotificationService(supabase),
      ),
      qtRepositoryProvider.overrideWithValue(SupabaseQtRepository(supabase)),
    ]);
  }

  // Anonymous-first: auto sign in if no existing session
  final currentUser = await authService.getCurrentUser();
  if (currentUser == null) {
    await authService.signInAnonymously();
  }

  runApp(ProviderScope(overrides: overrides, child: const AbbaApp()));
}
