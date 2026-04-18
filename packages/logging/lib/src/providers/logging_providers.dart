import '../data/logger.dart';
import '../data/outputs/history_output.dart';
import '../domain/log_category.dart';

// Re-export for convenience
export '../data/logger.dart';
export '../data/outputs/history_output.dart';
export '../domain/log_category.dart';
export '../domain/log_config.dart';
export '../domain/log_level.dart';

/// Global logger instance, set during app initialization.
late final Logger appLogger;

/// Global log history for in-app viewer, set during app initialization.
late final HistoryOutput logHistory;

/// Convenience: category-scoped loggers for common use cases.
CategoryLogger get dbLog => appLogger.forCategory(LogCategory.db);
CategoryLogger get apiLog => appLogger.forCategory(LogCategory.api);
CategoryLogger get authLog => appLogger.forCategory(LogCategory.auth);
CategoryLogger get prayerLog => appLogger.forCategory(LogCategory.prayer);
CategoryLogger get qtLog => appLogger.forCategory(LogCategory.qt);
CategoryLogger get communityLog => appLogger.forCategory(LogCategory.community);
CategoryLogger get ttsLog => appLogger.forCategory(LogCategory.tts);
CategoryLogger get sttLog => appLogger.forCategory(LogCategory.stt);
CategoryLogger get fcmLog => appLogger.forCategory(LogCategory.fcm);
