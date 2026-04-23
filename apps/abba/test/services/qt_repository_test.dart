import 'package:flutter_test/flutter_test.dart';

import 'package:abba/services/mock/mock_qt_repository.dart';
import 'package:abba/services/mock_data.dart';

import '../helpers/test_fixtures.dart';

/// Contract tests for [MockQtRepository]. The real Supabase implementation
/// needs an integration environment to exercise — this suite just pins the
/// in-memory mock so widget tests can rely on its shape.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MockQtRepository', () {
    late MockQtRepository repo;

    setUp(() {
      // fromData avoids the rootBundle.loadString asset read that is
      // unavailable inside flutter_test.
      final mockData = MockDataService.fromData(
        qtPassages: TestFixtures.qtPassages(),
      );
      repo = MockQtRepository(mockData);
    });

    test('getTodayPassages returns 5 passages for any locale', () async {
      final en = await repo.getTodayPassages(locale: 'en');
      final ko = await repo.getTodayPassages(locale: 'ko');

      expect(en, hasLength(5));
      expect(ko, hasLength(5));
    });

    test('getTodayPassages passages have non-empty reference + text',
        () async {
      final passages = await repo.getTodayPassages(locale: 'en');
      for (final p in passages) {
        expect(p.reference, isNotEmpty);
        expect(p.text, isNotEmpty);
        expect(p.id, isNotEmpty);
      }
    });

    test('passages include expected scripture references', () async {
      final passages = await repo.getTodayPassages(locale: 'en');
      final refs = passages.map((p) => p.reference).toSet();
      expect(refs, contains('Psalm 23:1-6'));
      expect(refs, contains('Philippians 4:6-7'));
      expect(refs, contains('Jeremiah 29:11'));
    });
  });
}
