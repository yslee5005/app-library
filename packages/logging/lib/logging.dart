/// App Library Logging — Structured logging with category filtering,
/// sensitive data redaction, and Sentry breadcrumb integration.
library;

// Domain
export 'src/domain/log_category.dart';
export 'src/domain/log_config.dart';
export 'src/domain/log_entry.dart';
export 'src/domain/log_level.dart';
export 'src/domain/log_output.dart';

// Data
export 'src/data/logger.dart';
export 'src/data/outputs/console_output.dart';
export 'src/data/outputs/noop_output.dart';
export 'src/data/outputs/sentry_breadcrumb_output.dart';
export 'src/data/redaction/log_redactor.dart';
export 'src/data/http/logging_http_client.dart';

// History
export 'src/data/outputs/history_output.dart';

// Widgets
export 'src/widgets/log_viewer_screen.dart';

// Providers
export 'src/providers/logging_providers.dart';
