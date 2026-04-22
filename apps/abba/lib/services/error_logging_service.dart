import 'dart:async';

import 'package:app_lib_error_logging/error_logging.dart' as pkg;
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/app_config.dart';

class ErrorLoggingService {
  ErrorLoggingService._();

  static Future<void> initialize() async {
    if (AppConfig.sentryDsn.isEmpty) return;

    await SentryFlutter.init((options) {
      options.dsn = AppConfig.sentryDsn;
      options.environment = AppConfig.env;
      options.beforeSend = _filterSensitiveData;
      options.tracesSampleRate = AppConfig.isProduction ? 0.2 : 1.0;
    });
  }

  static FutureOr<SentryEvent?> _filterSensitiveData(
    SentryEvent event,
    Hint hint,
  ) {
    // 1. Mask message
    final message = event.message?.formatted;
    if (message != null) {
      event.message = SentryMessage(maskSensitive(message));
    }

    // 2. Mask breadcrumbs (messages carry user input / prayer transcript)
    final breadcrumbs = event.breadcrumbs;
    if (breadcrumbs != null) {
      for (final b in breadcrumbs) {
        if (b.message != null) {
          b.message = maskSensitive(b.message!);
        }
      }
    }

    // 3. Mask exception values (error messages often contain PII)
    final exceptions = event.exceptions;
    if (exceptions != null) {
      for (final exc in exceptions) {
        if (exc.value != null) {
          exc.value = maskSensitive(exc.value!);
        }
      }
    }

    return event;
  }

  /// Masks sensitive data from free-form strings before they reach Sentry.
  ///
  /// Rules (applied in order):
  /// 1. Email addresses → `[EMAIL]`
  /// 2. Phone numbers (E.164 + KR formats) → `[PHONE]`
  /// 3. JWT-like tokens (Supabase/auth) → `[JWT]`
  /// 4. Long Korean runs (50+ chars) = prayer transcript → `[TRANSCRIPT]`
  /// 5. URL query params → `?[PARAMS_REDACTED]`
  /// 6. Truncate to 500 chars
  @visibleForTesting
  static String maskSensitive(String text) {
    var result = text;

    // 1. Email
    result = result.replaceAll(
      RegExp(r'[\w.+-]+@[\w-]+\.[\w.]+'),
      '[EMAIL]',
    );

    // 2. Phone (E.164 `+<digits>` or hyphen-separated KR/US)
    result = result.replaceAll(
      RegExp(r'(\+\d{8,15}|\d{2,3}-\d{3,4}-\d{4})'),
      '[PHONE]',
    );

    // 3. JWT-like tokens (3 base64url segments separated by dots, starts with eyJ)
    result = result.replaceAll(
      RegExp(r'eyJ[\w-]+\.[\w-]+\.[\w-]+'),
      '[JWT]',
    );

    // 4. Long Korean runs (transcript / prayer content)
    result = result.replaceAllMapped(
      RegExp(r'[가-힣][가-힣\s.,!?~]{49,}'),
      (_) => '[TRANSCRIPT]',
    );

    // 5. URL query params (keep scheme + host + path; mask query)
    result = result.replaceAllMapped(
      RegExp(r'(https?://[^\s?]+)\?[^\s]+'),
      (m) => '${m.group(1)}?[PARAMS_REDACTED]',
    );

    // 6. Truncate (500 is generous to preserve stacktrace context after mask)
    if (result.length > 500) {
      return '${result.substring(0, 500)}... [TRUNCATED]';
    }
    return result;
  }

  static void captureException(Object error, StackTrace stackTrace) {
    if (AppConfig.sentryDsn.isEmpty) return;
    Sentry.captureException(error, stackTrace: stackTrace);
  }

  static void addBreadcrumb(String message, {String? category}) {
    if (AppConfig.sentryDsn.isEmpty) return;
    Sentry.addBreadcrumb(
      Breadcrumb(message: message, category: category ?? 'app'),
    );
  }
}

/// Bridge: adapts abba's static ErrorLoggingService to the package interface.
class AbbaErrorLoggingBridge implements pkg.ErrorLoggingService {
  @override
  Future<void> log(
    String message, {
    pkg.ErrorLevel level = pkg.ErrorLevel.info,
  }) async {
    // Sentry breadcrumb covers this
  }

  @override
  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    pkg.ErrorLevel level = pkg.ErrorLevel.error,
    Map<String, String>? tags,
  }) async {
    ErrorLoggingService.captureException(
      exception,
      stackTrace ?? StackTrace.current,
    );
  }

  @override
  void addBreadcrumb({
    required String message,
    String? category,
    Map<String, String>? data,
  }) {
    ErrorLoggingService.addBreadcrumb(message, category: category);
  }
}
