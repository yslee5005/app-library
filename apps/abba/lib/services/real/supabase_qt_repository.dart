import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/qt_passage.dart';
import '../qt_repository.dart';

class SupabaseQtRepository implements QtRepository {
  final SupabaseClient _client;

  SupabaseQtRepository(this._client);

  @override
  Future<List<QTPassage>> getTodayPassages() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final data = await _client
        .from('qt_passages')
        .select()
        .eq('app_id', 'abba')
        .eq('date', today)
        .order('created_at', ascending: true);

    final passages = (data as List)
        .map((e) => QTPassage.fromJson(e as Map<String, dynamic>))
        .toList();

    // Fallback: if no passages for today (cronjob failed), return Psalm 23
    if (passages.isEmpty) {
      return _fallbackPassages();
    }

    return passages;
  }

  List<QTPassage> _fallbackPassages() {
    return [
      QTPassage(
        id: 'fallback-1',
        reference: 'Psalm 23:1-3',
        textEn: 'The Lord is my shepherd; I shall not want. '
            'He makes me lie down in green pastures. '
            'He leads me beside still waters. He restores my soul.',
        textKo: '여호와는 나의 목자시니 내게 부족함이 없으리로다. '
            '그가 나를 푸른 풀밭에 누이시며 '
            '쉴 만한 물가로 인도하시는도다. 내 영혼을 소생시키시고.',
        icon: '🌿',
        colorHex: '#B2DFDB',
        date: DateTime.now(),
      ),
    ];
  }
}
