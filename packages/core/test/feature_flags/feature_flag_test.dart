import 'package:app_lib_core/core.dart';
import 'package:test/test.dart';

void main() {
  setUp(() => FeatureFlagRegistry.reset());

  group('FeatureFlag', () {
    test('uses defaultValue when registry not initialized', () {
      const flag = FeatureFlag('test_flag', defaultValue: true);
      expect(flag.isEnabled, isTrue);

      const flag2 = FeatureFlag('test_flag2', defaultValue: false);
      expect(flag2.isEnabled, isFalse);
    });

    test('uses registry value over default', () {
      FeatureFlagRegistry.init({'test_flag': false});

      const flag = FeatureFlag('test_flag', defaultValue: true);
      expect(flag.isEnabled, isFalse);
    });

    test('isDisabled is inverse of isEnabled', () {
      const flag = FeatureFlag('x', defaultValue: true);
      expect(flag.isDisabled, isFalse);

      FeatureFlagRegistry.init({'x': false});
      expect(flag.isDisabled, isTrue);
    });

    test('toString shows key and status', () {
      const flag = FeatureFlag('dark_mode', defaultValue: true);
      expect(flag.toString(), contains('dark_mode'));
      expect(flag.toString(), contains('ON'));
    });
  });

  group('FeatureFlagRegistry', () {
    test('isInitialized is false before init', () {
      expect(FeatureFlagRegistry.isInitialized, isFalse);
    });

    test('isInitialized is true after init', () {
      FeatureFlagRegistry.init({});
      expect(FeatureFlagRegistry.isInitialized, isTrue);
    });

    test('init merges values on subsequent calls', () {
      FeatureFlagRegistry.init({'a': true});
      FeatureFlagRegistry.init({'b': false});

      expect(FeatureFlagRegistry.isEnabled('a'), isTrue);
      expect(FeatureFlagRegistry.isEnabled('b'), isFalse);
    });

    test('set overrides a single flag', () {
      FeatureFlagRegistry.init({'feature': false});
      expect(FeatureFlagRegistry.isEnabled('feature'), isFalse);

      FeatureFlagRegistry.set('feature', true);
      expect(FeatureFlagRegistry.isEnabled('feature'), isTrue);
    });

    test('all returns unmodifiable map', () {
      FeatureFlagRegistry.init({'a': true, 'b': false});

      final all = FeatureFlagRegistry.all;
      expect(all, {'a': true, 'b': false});
      expect(() => (all as Map)['c'] = true, throwsA(anything));
    });

    test('isEnabled returns defaultValue for unknown keys', () {
      FeatureFlagRegistry.init({});
      expect(FeatureFlagRegistry.isEnabled('unknown', true), isTrue);
      expect(FeatureFlagRegistry.isEnabled('unknown', false), isFalse);
    });

    test('reset clears all flags', () {
      FeatureFlagRegistry.init({'a': true});
      FeatureFlagRegistry.reset();

      expect(FeatureFlagRegistry.isInitialized, isFalse);
      expect(FeatureFlagRegistry.isEnabled('a'), isFalse);
    });
  });
}
