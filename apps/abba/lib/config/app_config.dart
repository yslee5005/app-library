/// App configuration loaded from --dart-define or --dart-define-from-file
class AppConfig {
  AppConfig._();

  static const String env =
      String.fromEnvironment('ENV', defaultValue: 'mock');

  static const String appId =
      String.fromEnvironment('APP_ID', defaultValue: 'abba');

  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');

  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  static const String openAiApiKey =
      String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');

  static const String sentryDsn =
      String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  static const String revenueCatApiKey =
      String.fromEnvironment('REVENUECAT_API_KEY', defaultValue: '');

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
    if (openAiApiKey.isEmpty) missing.add('OPENAI_API_KEY');
    if (missing.isNotEmpty) {
      throw StateError(
        'Missing required environment variables: ${missing.join(', ')}',
      );
    }
  }
}
