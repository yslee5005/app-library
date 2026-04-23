import 'dart:convert';

import 'package:abba/services/prayer_template_service.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory AssetBundle — flutter_test's default rootBundle cannot
/// resolve pubspec assets without a running Flutter engine, so we stub
/// loadString for each (path → payload) entry.
class _InMemoryAssetBundle extends CachingAssetBundle {
  _InMemoryAssetBundle(this._assets);

  final Map<String, String> _assets;

  @override
  Future<ByteData> load(String key) async {
    final v = _assets[key];
    if (v == null) {
      throw FlutterError('Asset not found: $key');
    }
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(v)));
  }
}

String _fixture({
  required String category,
  required String locale,
  String reference = 'Psalm 1:1',
  String testimony = 'Thank you God.',
}) =>
    jsonEncode({
      'category': category,
      'locale': locale,
      'scripture': {'reference': reference},
      'bible_story': {'title': 'title', 'summary': 'summary'},
      'testimony': testimony,
      'prayer_summary': {
        'gratitude': ['g'],
        'petition': [],
        'intercession': [],
      },
    });

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Service logs via prayerLog → requires appLogger to be initialised.
    appLogger = Logger(
      config: LogConfig.development,
      outputs: const [NoopOutput()],
    );
  });

  group('PrayerTemplateService', () {
    test('loads health_ko template from injected bundle', () async {
      final bundle = _InMemoryAssetBundle({
        'assets/prayer_templates/health_ko.json':
            _fixture(category: 'health', locale: 'ko', reference: 'Psalm 103:3'),
      });
      final service = PrayerTemplateService(bundle: bundle);

      final result = await service.loadTemplate(
        category: 'health',
        locale: 'ko',
      );

      expect(result, isNotNull);
      expect(result!.scripture.reference, 'Psalm 103:3');
    });

    test('unsupported category is normalised to gratitude', () async {
      final bundle = _InMemoryAssetBundle({
        'assets/prayer_templates/gratitude_en.json': _fixture(
          category: 'gratitude',
          locale: 'en',
          reference: '1 Thessalonians 5:18',
        ),
      });
      final service = PrayerTemplateService(bundle: bundle);

      final result = await service.loadTemplate(
        category: 'unknownCategory',
        locale: 'en',
      );
      expect(result, isNotNull);
      expect(result!.scripture.reference, '1 Thessalonians 5:18');
    });

    test('unsupported locale falls back to English asset', () async {
      final bundle = _InMemoryAssetBundle({
        'assets/prayer_templates/family_en.json': _fixture(
          category: 'family',
          locale: 'en',
          reference: 'Joshua 24:15',
          testimony: 'God hears this prayer for the family.',
        ),
      });
      final service = PrayerTemplateService(bundle: bundle);

      final result = await service.loadTemplate(
        category: 'family',
        locale: 'fr',
      );
      expect(result, isNotNull);
      expect(result!.scripture.reference, 'Joshua 24:15');
    });

    test('second call for the same key hits the cache (identity check)',
        () async {
      final bundle = _InMemoryAssetBundle({
        'assets/prayer_templates/gratitude_ko.json': _fixture(
          category: 'gratitude',
          locale: 'ko',
        ),
      });
      final service = PrayerTemplateService(bundle: bundle);

      final first = await service.loadTemplate(
        category: 'gratitude',
        locale: 'ko',
      );
      final second = await service.loadTemplate(
        category: 'gratitude',
        locale: 'ko',
      );
      expect(identical(first, second), isTrue);
    });

    test('returns null when neither primary nor fallback asset exists',
        () async {
      final bundle = _InMemoryAssetBundle({});
      final service = PrayerTemplateService(bundle: bundle);

      final result = await service.loadTemplate(
        category: 'health',
        locale: 'ja',
      );
      expect(result, isNull);
    });
  });
}
