import 'package:app_lib_logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/qt_passage.dart';
import '../qt_repository.dart';

/// Thrown when today's QT passages cannot be served from any source
/// (cache miss + Edge Function failure + English fallback empty).
/// UI should render an error state with a Retry affordance.
class QtPassagesUnavailableException implements Exception {
  final String message;
  const QtPassagesUnavailableException([
    this.message = 'No QT passages available — network or service unavailable',
  ]);

  @override
  String toString() => 'QtPassagesUnavailableException: $message';
}

/// On-demand QT repository.
/// - Cache hit: read today's rows for requested locale from abba.qt_passages.
/// - Cache miss: invoke the `abba-get-qt-passages` Edge Function which
///   generates + inserts for this single locale. Race-safe via unique index.
/// - Edge Function failure: fall back to English cache.
/// - If everything fails: throw [QtPassagesUnavailableException] so the UI
///   can render an error + Retry state instead of showing hardcoded English
///   Scripture to users in 35 locales.
class SupabaseQtRepository implements QtRepository {
  SupabaseQtRepository(this._client);

  final SupabaseClient _client;

  static const String _batchSlot = 'daily';

  @override
  Future<List<QTPassage>> getTodayPassages({required String locale}) async {
    final String today = _getEstDate();

    // 1. Try cache first (fast path — <100ms).
    final List<QTPassage> cached = await _fetchFromDb(today, locale);
    if (cached.length >= 10) return cached;

    // 2. Cache miss — call Edge Function to generate for this locale.
    try {
      await _client.functions.invoke(
        'abba-get-qt-passages',
        body: {'locale': locale},
      );
      final List<QTPassage> fresh = await _fetchFromDb(today, locale);
      if (fresh.isNotEmpty) return fresh;
    } catch (e, stackTrace) {
      // Edge Function failure is recoverable (fallback below), but we still
      // want Sentry to see it — signals backend degradation.
      appLogger.error(
        'QT Edge Function invoke failed; falling back to en/unavailable',
        category: LogCategory.qt,
        error: e,
        stackTrace: stackTrace,
      );
    }

    // 3. Edge Function failed or returned nothing — English fallback
    // (last resort before surfacing an error to the user).
    if (locale != 'en') {
      final List<QTPassage> en = await _fetchFromDb(today, 'en');
      if (en.isNotEmpty) return en;
    }

    // 4. Nothing available — surface to UI so Retry can be offered.
    throw const QtPassagesUnavailableException();
  }

  Future<List<QTPassage>> _fetchFromDb(String date, String locale) async {
    final List<dynamic> data = await _client
        .schema('abba')
        .from('qt_passages')
        .select()
        .eq('app_id', 'abba')
        .eq('date', date)
        .eq('batch_slot', _batchSlot)
        .eq('locale', locale)
        .order('created_at', ascending: true);
    return data
        .map((e) => QTPassage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get current date in EST (UTC-5) — server uses same anchor.
  String _getEstDate() {
    final DateTime utc = DateTime.now().toUtc();
    final DateTime est = utc.subtract(const Duration(hours: 5));
    return est.toIso8601String().substring(0, 10);
  }
}
