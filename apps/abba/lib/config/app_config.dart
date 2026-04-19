import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App configuration loaded from .env.client via flutter_dotenv (runtime).
class AppConfig {
  AppConfig._();

  static String get env => dotenv.env['ENV'] ?? 'mock';

  static String get appId => dotenv.env['APP_ID'] ?? 'abba';

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static String get openAiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static String get sentryDsn => dotenv.env['SENTRY_DSN'] ?? '';

  static String get revenueCatApiKey => dotenv.env['REVENUECAT_API_KEY'] ?? '';

  static String get googleWebClientId =>
      dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  static String get googleIosClientId =>
      dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '';

  /// true when running in mock mode (JSON data, no external services)
  static bool get useMock => env == 'mock';

  /// true when running with real backend services
  static bool get isProduction => env == 'prod';

  /// Validate required environment variables.
  /// Skipped in mock mode — real mode requires Supabase + OpenAI keys.
  static void validate() {
    if (useMock) return;
    final missing = <String>[];
    if (supabaseUrl.isEmpty) missing.add('SUPABASE_URL');
    if (supabaseAnonKey.isEmpty) missing.add('SUPABASE_ANON_KEY');
    if (geminiApiKey.isEmpty) missing.add('GEMINI_API_KEY');
    if (missing.isNotEmpty) {
      throw StateError(
        'Missing required environment variables: ${missing.join(', ')}',
      );
    }
  }
}
