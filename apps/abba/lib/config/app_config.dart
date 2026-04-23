import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App configuration loaded from .env.client via flutter_dotenv (runtime).
class AppConfig {
  AppConfig._();

  static String get env => dotenv.env['ENV'] ?? 'mock';

  static String get appId => dotenv.env['APP_ID'] ?? 'abba';

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static String get sentryDsn => dotenv.env['SENTRY_DSN'] ?? '';

  /// RevenueCat SDK key — platform-specific.
  ///
  /// `.env.client` defines `REVENUECAT_IOS_KEY` (`appl_*`) and
  /// `REVENUECAT_ANDROID_KEY` (`goog_*`) separately. This getter selects
  /// the correct key based on the runtime platform. Web returns empty
  /// (RevenueCat is not configured for web builds).
  ///
  /// Legacy `REVENUECAT_API_KEY` is still honored as a fallback for
  /// local developer setups that predate the per-platform split.
  static String get revenueCatApiKey {
    if (kIsWeb) return dotenv.env['REVENUECAT_API_KEY'] ?? '';
    if (Platform.isIOS) {
      return dotenv.env['REVENUECAT_IOS_KEY'] ??
          dotenv.env['REVENUECAT_API_KEY'] ??
          '';
    }
    if (Platform.isAndroid) {
      return dotenv.env['REVENUECAT_ANDROID_KEY'] ??
          dotenv.env['REVENUECAT_API_KEY'] ??
          '';
    }
    return dotenv.env['REVENUECAT_API_KEY'] ?? '';
  }

  /// Help center URL. Fallback to GitHub Pages so the app keeps working
  /// before a custom domain is provisioned.
  static String get helpUrl {
    final envValue = dotenv.env['HELP_URL'];
    if (envValue != null && envValue.isNotEmpty) return envValue;
    return 'https://yslee5005.github.io/abba-docs/help';
  }

  /// Terms of Service URL (Apple Guideline 3.1.2 requires link under purchase
  /// button). Fallback to GitHub Pages.
  static String get termsUrl {
    final envValue = dotenv.env['TERMS_URL'];
    if (envValue != null && envValue.isNotEmpty) return envValue;
    return 'https://yslee5005.github.io/abba-docs/terms';
  }

  /// Privacy Policy URL (Apple Guideline 3.1.2 requires link under purchase
  /// button). Fallback to GitHub Pages.
  static String get privacyUrl {
    final envValue = dotenv.env['PRIVACY_URL'];
    if (envValue != null && envValue.isNotEmpty) return envValue;
    return 'https://yslee5005.github.io/abba-docs/privacy';
  }

  static String get googleWebClientId =>
      dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  static String get googleIosClientId =>
      dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '';

  /// true when running in mock mode (JSON data, no external services)
  static bool get useMock => env == 'mock';

  /// true when running with real backend services
  static bool get isProduction => env == 'prod';

  /// AI-only toggle: when true, AiService skips Gemini calls and returns
  /// hardcoded mock responses. Independent from `useMock` so dev builds can
  /// exercise real Supabase + real Gemini while sharing the `dev` ENV.
  /// Defaults to `true` (safe — no accidental API cost) when unset.
  static bool get useMockAi =>
      (dotenv.env['ENABLE_MOCK_AI'] ?? 'true').toLowerCase() == 'true';

  /// FCM toggle: when false, RealNotificationService skips Firebase
  /// initialization entirely. Local notifications (flutter_local_notifications)
  /// keep working independently. Flip to `true` once GoogleService-Info.plist
  /// / google-services.json are configured. Defaults to `false` (safe —
  /// no Firebase config required for local dev / 1st-pass launch).
  static bool get enableFcm =>
      (dotenv.env['ENABLE_FCM'] ?? 'false').toLowerCase() == 'true';

  /// Phase 4.1: Gemini Context Cache. When true, `GeminiCacheManager`
  /// creates a shared cache (Strategy B) to reduce input token cost ~83%.
  /// Falls back to uncached calls when the Dart SDK doesn't support
  /// context caching yet (current state) or on cache miss. Defaults to
  /// `true` — no downside when SDK is not ready (graceful degrade).
  static bool get enableGeminiCache =>
      (dotenv.env['ENABLE_GEMINI_CACHE'] ?? 'true').toLowerCase() == 'true';

  /// Validate required environment variables.
  /// Skipped in mock mode — real mode requires Supabase + Gemini + RevenueCat + Google OAuth keys.
  ///
  /// Called from `main()` *before* the structured logger is initialized, so
  /// warnings use `debugPrint` instead of `appLogger`.
  static void validate() {
    if (useMock) return;

    final missing = <String>[];

    // Fatal — required for core app functionality
    if (supabaseUrl.isEmpty) missing.add('SUPABASE_URL');
    if (supabaseAnonKey.isEmpty) missing.add('SUPABASE_ANON_KEY');
    if (geminiApiKey.isEmpty) missing.add('GEMINI_API_KEY');

    // RevenueCat — required for subscription purchases (iOS/Android only)
    if (!kIsWeb && revenueCatApiKey.isEmpty) {
      if (Platform.isIOS) {
        missing.add('REVENUECAT_IOS_KEY');
      } else if (Platform.isAndroid) {
        missing.add('REVENUECAT_ANDROID_KEY');
      }
    }

    // Google OAuth — required for account linking (social sign-in)
    if (googleWebClientId.isEmpty) missing.add('GOOGLE_WEB_CLIENT_ID');
    if (googleIosClientId.isEmpty) missing.add('GOOGLE_IOS_CLIENT_ID');

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing required environment variables: ${missing.join(', ')}',
      );
    }

    // Optional — warn but don't fail startup
    if (sentryDsn.isEmpty) {
      debugPrint(
        '[AppConfig] SENTRY_DSN empty — Sentry error reporting disabled.',
      );
    }
  }
}
