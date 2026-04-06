import 'dart:async';

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
    // Mask prayer transcript and email from breadcrumbs/exceptions
    final message = event.message?.formatted;
    if (message != null) {
      final masked = _maskSensitive(message);
      return event.copyWith(
        message: SentryMessage(masked),
      );
    }
    return event;
  }

  static String _maskSensitive(String text) {
    // Mask emails
    final emailMasked = text.replaceAll(
      RegExp(r'[\w.+-]+@[\w-]+\.[\w.]+'),
      '[EMAIL]',
    );
    // Truncate long prayer text
    if (emailMasked.length > 200) {
      return '${emailMasked.substring(0, 200)}... [TRUNCATED]';
    }
    return emailMasked;
  }

  static void captureException(Object error, StackTrace stackTrace) {
    if (AppConfig.sentryDsn.isEmpty) return;
    Sentry.captureException(error, stackTrace: stackTrace);
  }

  static void addBreadcrumb(String message, {String? category}) {
    if (AppConfig.sentryDsn.isEmpty) return;
    Sentry.addBreadcrumb(Breadcrumb(
      message: message,
      category: category ?? 'app',
    ));
  }
}
