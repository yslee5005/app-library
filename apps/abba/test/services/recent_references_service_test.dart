import 'package:abba/services/recent_references_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('canonicalizeReference', () {
    test('Korean Matthew → Matthew', () {
      expect(canonicalizeReference('마태복음 6:33'), 'Matthew 6:33');
    });

    test('Korean Psalm → Psalm', () {
      expect(canonicalizeReference('시편 23:1'), 'Psalm 23:1');
    });

    test('Lamentations longer prefix takes priority over Jeremiah', () {
      // 예레미야애가 must NOT be matched as 예레미야 + "애가 ..."
      expect(canonicalizeReference('예레미야애가 3:22-23'), 'Lamentations 3:22-23');
      expect(canonicalizeReference('예레미야 29:11'), 'Jeremiah 29:11');
    });

    test('English passes through unchanged', () {
      expect(canonicalizeReference('Romans 8:28'), 'Romans 8:28');
      expect(canonicalizeReference('1 Corinthians 13:4-7'), '1 Corinthians 13:4-7');
    });

    test('unknown localized name passes through unchanged', () {
      expect(canonicalizeReference('Mateo 6:33'), 'Mateo 6:33');
    });

    test('empty/whitespace tolerated', () {
      expect(canonicalizeReference(''), '');
      expect(canonicalizeReference('   '), '');
    });
  });

  group('chapterKeyOf', () {
    test('strips verse → "Book Chapter"', () {
      expect(chapterKeyOf('Psalm 4:8'), 'Psalm 4');
      expect(chapterKeyOf('Psalm 4:5-7'), 'Psalm 4');
    });

    test('handles multi-word book names', () {
      expect(chapterKeyOf('1 Corinthians 13:4-7'), '1 Corinthians 13');
    });

    test('returns input when no colon', () {
      expect(chapterKeyOf('Psalm 23'), 'Psalm 23');
    });
  });

  group('NoopRecentReferencesService', () {
    test('always returns empty list', () async {
      final svc = NoopRecentReferencesService();
      expect(await svc.getRecentReferences(userId: 'u1'), isEmpty);
      expect(await svc.getRecentReferences(userId: ''), isEmpty);
    });
  });

  // RecentReferencesService against a real Supabase client is covered by
  // integration tests; the unit-level dedup/canonicalization logic is tested
  // via the pure helpers above. This avoids depending on supabase_flutter
  // SupabaseClient construction in flutter_test.
}
