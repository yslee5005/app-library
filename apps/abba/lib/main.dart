import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'config/app_config.dart';
import 'providers/providers.dart';
import 'services/error_logging_service.dart';
import 'services/mock/mock_ai_service.dart';
import 'services/mock/mock_auth_service.dart';
import 'services/mock/mock_prayer_repository.dart';
import 'services/mock/mock_stt_service.dart';
import 'services/mock/mock_tts_service.dart';
import 'services/mock_data.dart';
import 'services/real/openai_service.dart';
import 'services/real/real_stt_service.dart';
import 'services/real/real_tts_service.dart';
import 'services/real/supabase_auth_service.dart';
import 'services/real/supabase_prayer_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate environment variables (skipped in mock mode)
  AppConfig.validate();

  // Initialize Sentry error logging
  await ErrorLoggingService.initialize();

  final overrides = <Override>[];

  if (AppConfig.useMock) {
    // Mock mode — all services return JSON data
    final mockData = MockDataService();
    overrides.addAll([
      authServiceProvider.overrideWithValue(MockAuthService(mockData)),
      aiServiceProvider.overrideWithValue(MockAiService(mockData)),
      sttServiceProvider.overrideWithValue(MockSttService()),
      ttsServiceProvider.overrideWithValue(MockTtsService()),
      prayerRepositoryProvider.overrideWithValue(MockPrayerRepository()),
    ]);
  } else {
    // Real mode — connect to Supabase, OpenAI, etc.
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    final supabase = Supabase.instance.client;

    overrides.addAll([
      authServiceProvider.overrideWithValue(SupabaseAuthService(supabase)),
      aiServiceProvider.overrideWithValue(OpenAiService()),
      sttServiceProvider.overrideWithValue(RealSttService()),
      ttsServiceProvider.overrideWithValue(RealTtsService()),
      prayerRepositoryProvider
          .overrideWithValue(SupabasePrayerRepository(supabase)),
    ]);
  }

  runApp(
    ProviderScope(
      overrides: overrides,
      child: const AbbaApp(),
    ),
  );
}
