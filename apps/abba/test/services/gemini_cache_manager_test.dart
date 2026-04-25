import 'dart:convert';

import 'package:abba/services/gemini_cache_manager.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// In-memory bundle — flutter_test's rootBundle can't resolve pubspec
/// assets, so we stub loadString with a fixture map.
class _InMemoryBundle extends CachingAssetBundle {
  _InMemoryBundle(this._data);
  final Map<String, String> _data;

  @override
  Future<ByteData> load(String key) async {
    final v = _data[key];
    if (v == null) {
      throw FlutterError('Asset not found: $key');
    }
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(v)));
  }
}

/// Minimal SupabaseClient stub — these tests only exercise the bundle
/// hash / in-memory caching path, so we never hit the network.
class _NoopSupabaseClient implements SupabaseClient {
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

const _allAssets = <String>[
  'assets/prompts/system_base.md',
  'assets/prompts/prayer/summary_rubric.md',
  'assets/prompts/prayer/scripture_rubric.md',
  'assets/prompts/prayer/bible_story_rubric.md',
  'assets/prompts/prayer/testimony_rubric.md',
  'assets/prompts/prayer/guidance_rubric.md',
  'assets/prompts/prayer/ai_prayer_rubric.md',
  'assets/prompts/prayer/historical_story_rubric.md',
  'assets/prompts/qt/meditation_summary_rubric.md',
  'assets/prompts/qt/application_rubric.md',
  'assets/prompts/qt/knowledge_rubric.md',
];

Map<String, String> _bundleWith(String systemBase) => {
  for (final p in _allAssets) p: '# ${p.split('/').last}\nplaceholder body',
  'assets/prompts/system_base.md': systemBase,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    appLogger = Logger(
      config: LogConfig.development,
      outputs: const [NoopOutput()],
    );
  });

  group('GeminiCacheManager.loadRubricBundle', () {
    test('prayer mode concatenates prayer assets', () async {
      final cm = GeminiCacheManager(
        _NoopSupabaseClient(),
        bundle: _InMemoryBundle(_bundleWith('# system base')),
      );
      final bundle = await cm.loadRubricBundle('prayer');
      expect(bundle, contains('# system base'));
      expect(bundle, contains('summary_rubric.md'));
      expect(bundle, contains('ai_prayer_rubric.md'));
      // QT-only files not included in prayer bundle.
      expect(bundle, isNot(contains('application_rubric.md')));
    });

    test('qt mode concatenates qt assets', () async {
      final cm = GeminiCacheManager(
        _NoopSupabaseClient(),
        bundle: _InMemoryBundle(_bundleWith('# system base')),
      );
      final bundle = await cm.loadRubricBundle('qt');
      expect(bundle, contains('# system base'));
      expect(bundle, contains('application_rubric.md'));
      expect(bundle, contains('meditation_summary_rubric.md'));
      // Prayer-only files not included in qt bundle.
      expect(bundle, isNot(contains('ai_prayer_rubric.md')));
    });

    test('second call returns cached in-memory copy (identity)', () async {
      final cm = GeminiCacheManager(
        _NoopSupabaseClient(),
        bundle: _InMemoryBundle(_bundleWith('# system base')),
      );
      final first = await cm.loadRubricBundle('prayer');
      final second = await cm.loadRubricBundle('prayer');
      expect(identical(first, second), isTrue);
    });
  });

  group('GeminiCacheManager.computeBundleHash', () {
    test('produces 16-char hex hash', () async {
      final cm = GeminiCacheManager(
        _NoopSupabaseClient(),
        bundle: _InMemoryBundle(_bundleWith('# v1')),
      );
      final hash = await cm.computeBundleHash('prayer');
      expect(hash.length, 16);
      expect(RegExp(r'^[0-9a-f]{16}$').hasMatch(hash), isTrue);
    });

    test('same content → same hash', () async {
      final a = GeminiCacheManager(
        _NoopSupabaseClient(),
        bundle: _InMemoryBundle(_bundleWith('# v1')),
      );
      final b = GeminiCacheManager(
        _NoopSupabaseClient(),
        bundle: _InMemoryBundle(_bundleWith('# v1')),
      );
      expect(
        await a.computeBundleHash('prayer'),
        await b.computeBundleHash('prayer'),
      );
    });

    test('changed system_base → different hash', () async {
      final a = GeminiCacheManager(
        _NoopSupabaseClient(),
        bundle: _InMemoryBundle(_bundleWith('# v1')),
      );
      final b = GeminiCacheManager(
        _NoopSupabaseClient(),
        bundle: _InMemoryBundle(_bundleWith('# v2 — new rule added')),
      );
      expect(
        await a.computeBundleHash('prayer'),
        isNot(await b.computeBundleHash('prayer')),
      );
    });

    test('prayer and qt hashes differ (different asset lists)', () async {
      final cm = GeminiCacheManager(
        _NoopSupabaseClient(),
        bundle: _InMemoryBundle(_bundleWith('# system')),
      );
      final ph = await cm.computeBundleHash('prayer');
      final qh = await cm.computeBundleHash('qt');
      expect(ph, isNot(qh));
    });
  });
}
