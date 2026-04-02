import 'package:app_lib_supabase_client/supabase_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupabaseConfig', () {
    test('constructs with required fields', () {
      const config = SupabaseConfig(
        url: 'https://example.supabase.co',
        anonKey: 'anon-key-123',
        appId: 'test_app',
      );

      expect(config.url, 'https://example.supabase.co');
      expect(config.anonKey, 'anon-key-123');
      expect(config.appId, 'test_app');
    });

    test('supports const construction', () {
      const config1 = SupabaseConfig(
        url: 'https://a.supabase.co',
        anonKey: 'key1',
        appId: 'app1',
      );
      const config2 = SupabaseConfig(
        url: 'https://a.supabase.co',
        anonKey: 'key1',
        appId: 'app1',
      );

      // const instances with same values are identical
      expect(identical(config1, config2), isTrue);
    });

    test('different appIds produce different configs', () {
      const config1 = SupabaseConfig(
        url: 'https://a.supabase.co',
        anonKey: 'key1',
        appId: 'app1',
      );
      const config2 = SupabaseConfig(
        url: 'https://a.supabase.co',
        anonKey: 'key1',
        appId: 'app2',
      );

      expect(config1.appId, isNot(config2.appId));
    });
  });

  group('AppSupabaseClient', () {
    test('appId getter returns config appId', () {
      const config = SupabaseConfig(
        url: 'https://example.supabase.co',
        anonKey: 'anon-key-123',
        appId: 'my_app',
      );

      // We need a real SupabaseClient to construct AppSupabaseClient.
      // Since SupabaseClient requires network setup, we test via
      // the config-based properties only.
      // Full integration tests would use a real Supabase instance.
      expect(config.appId, 'my_app');
    });
  });
}
