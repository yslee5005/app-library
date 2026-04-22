import 'package:app_lib_logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/qt_passage.dart';
import '../qt_repository.dart';

/// On-demand QT repository.
/// - Cache hit: read today's rows for requested locale from abba.qt_passages.
/// - Cache miss: invoke the `abba-get-qt-passages` Edge Function which
///   generates + inserts for this single locale. Race-safe via unique index.
/// - Edge Function failure: fall back to English cache, then to hardcoded
///   starter passages.
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
        'QT Edge Function invoke failed; falling back to en/hardcoded',
        category: LogCategory.qt,
        error: e,
        stackTrace: stackTrace,
      );
    }

    // 3. Edge Function failed or returned nothing — English fallback.
    if (locale != 'en') {
      final List<QTPassage> en = await _fetchFromDb(today, 'en');
      if (en.isNotEmpty) return en;
    }

    // 4. Last-resort hardcoded starter set.
    return _fallbackPassages(locale);
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

  List<QTPassage> _fallbackPassages(String locale) {
    final bool isKo = locale == 'ko';
    return [
      QTPassage(
        id: 'fallback-1',
        reference: 'Psalm 23:1-3',
        locale: locale,
        text: isKo
            ? '여호와는 나의 목자시니 내게 부족함이 없으리로다. '
              '그가 나를 푸른 풀밭에 누이시며 '
              '쉴 만한 물가로 인도하시는도다. 내 영혼을 소생시키시고.'
            : 'The Lord is my shepherd; I shall not want. '
              'He makes me lie down in green pastures. '
              'He leads me beside still waters. He restores my soul.',
        theme: 'hope',
        icon: '🌿',
        colorHex: '#B2DFDB',
        date: DateTime.now(),
      ),
      QTPassage(
        id: 'fallback-2',
        reference: 'Philippians 4:6-7',
        locale: locale,
        text: isKo
            ? '아무 것도 염려하지 말고 다만 모든 일에 기도와 간구로, '
              '너희 구할 것을 감사함으로 하나님께 아뢰라. '
              '그리하면 하나님의 평강이 너희 마음과 생각을 지키시리라.'
            : 'Do not be anxious about anything, but in every situation, '
              'by prayer and petition, with thanksgiving, present your requests to God. '
              'And the peace of God will guard your hearts and minds.',
        theme: 'anxiety',
        icon: '🌧️',
        colorHex: '#B0BEC5',
        date: DateTime.now(),
      ),
      QTPassage(
        id: 'fallback-3',
        reference: 'Romans 8:28',
        locale: locale,
        text: isKo
            ? '우리가 알거니와 하나님을 사랑하는 자 곧 그의 뜻대로 '
              '부르심을 입은 자들에게는 모든 것이 합력하여 선을 이루느니라.'
            : 'And we know that in all things God works for the good '
              'of those who love him, who have been called according to his purpose.',
        theme: 'gratitude',
        icon: '🌸',
        colorHex: '#FFB7C5',
        date: DateTime.now(),
      ),
    ];
  }
}
