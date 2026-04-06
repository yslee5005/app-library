import 'package:app_lib_core/core.dart';
import 'package:test/test.dart';

void main() {
  group('EnvValidator', () {
    test('passes when all required keys present and valid', () {
      expect(
        () => EnvValidator.validate(
          required: ['SUPABASE_URL', 'APP_ID'],
          values: {
            'SUPABASE_URL': 'https://example.supabase.co',
            'APP_ID': 'pet-life',
          },
        ),
        returnsNormally,
      );
    });

    test('throws for missing required keys', () {
      expect(
        () => EnvValidator.validate(
          required: ['SUPABASE_URL', 'APP_ID'],
          values: {'SUPABASE_URL': 'https://example.supabase.co'},
        ),
        throwsA(
          isA<EnvValidationException>().having(
            (e) => e.missing,
            'missing',
            contains('APP_ID'),
          ),
        ),
      );
    });

    test('throws for empty required keys', () {
      expect(
        () => EnvValidator.validate(
          required: ['SUPABASE_URL'],
          values: {'SUPABASE_URL': ''},
        ),
        throwsA(
          isA<EnvValidationException>().having(
            (e) => e.empty,
            'empty',
            contains('SUPABASE_URL'),
          ),
        ),
      );
    });

    test('validates URL format', () {
      expect(
        () => EnvValidator.validate(
          required: ['SUPABASE_URL'],
          values: {'SUPABASE_URL': 'not-a-url'},
        ),
        throwsA(
          isA<EnvValidationException>().having(
            (e) => e.formatErrors,
            'formatErrors',
            containsPair('SUPABASE_URL', contains('http')),
          ),
        ),
      );
    });

    test('validates APP_ID format', () {
      expect(
        () => EnvValidator.validate(
          required: ['APP_ID'],
          values: {'APP_ID': 'Has Spaces'},
        ),
        throwsA(isA<EnvValidationException>()),
      );
    });

    test('accepts valid APP_ID formats', () {
      for (final id in ['pet-life', 'my_app', 'app123']) {
        expect(
          () => EnvValidator.validate(
            required: ['APP_ID'],
            values: {'APP_ID': id},
          ),
          returnsNormally,
          reason: 'APP_ID "$id" should be valid',
        );
      }
    });

    test('skips format check for empty optional keys', () {
      expect(
        () => EnvValidator.validate(
          required: ['APP_ID'],
          optional: ['SENTRY_DSN'],
          values: {'APP_ID': 'my-app', 'SENTRY_DSN': ''},
        ),
        returnsNormally,
      );
    });

    test('validates format for non-empty optional keys', () {
      expect(
        () => EnvValidator.validate(
          required: ['APP_ID'],
          optional: ['SENTRY_DSN'],
          values: {'APP_ID': 'my-app', 'SENTRY_DSN': 'not-a-url'},
        ),
        throwsA(isA<EnvValidationException>()),
      );
    });

    test('toString provides readable error message', () {
      const e = EnvValidationException(
        missing: ['KEY_A'],
        empty: ['KEY_B'],
        formatErrors: {'KEY_C': 'bad format'},
      );
      expect(e.toString(), contains('Missing: KEY_A'));
      expect(e.toString(), contains('Empty: KEY_B'));
      expect(e.toString(), contains('KEY_C: bad format'));
    });
  });

  group('AppEnvironment', () {
    test('fromString parses known values', () {
      expect(AppEnvironment.fromString('dev'), AppEnvironment.dev);
      expect(AppEnvironment.fromString('staging'), AppEnvironment.staging);
      expect(AppEnvironment.fromString('stg'), AppEnvironment.staging);
      expect(AppEnvironment.fromString('prod'), AppEnvironment.prod);
      expect(AppEnvironment.fromString('production'), AppEnvironment.prod);
    });

    test('fromString defaults to dev for unknown values', () {
      expect(AppEnvironment.fromString('unknown'), AppEnvironment.dev);
      expect(AppEnvironment.fromString(''), AppEnvironment.dev);
    });

    test('dev has debug properties', () {
      expect(AppEnvironment.dev.isDebug, isTrue);
      expect(AppEnvironment.dev.showStackTraces, isTrue);
      expect(AppEnvironment.dev.verboseLogging, isTrue);
    });

    test('prod has production properties', () {
      expect(AppEnvironment.prod.isProd, isTrue);
      expect(AppEnvironment.prod.isDebug, isFalse);
      expect(AppEnvironment.prod.showStackTraces, isFalse);
      expect(AppEnvironment.prod.performanceMonitoring, isTrue);
    });
  });

  group('ScreenSize', () {
    test('fromWidth returns correct size class', () {
      expect(ScreenSize.fromWidth(320), ScreenSize.compact);
      expect(ScreenSize.fromWidth(599), ScreenSize.compact);
      expect(ScreenSize.fromWidth(600), ScreenSize.medium);
      expect(ScreenSize.fromWidth(839), ScreenSize.medium);
      expect(ScreenSize.fromWidth(840), ScreenSize.expanded);
      expect(ScreenSize.fromWidth(1199), ScreenSize.expanded);
      expect(ScreenSize.fromWidth(1200), ScreenSize.large);
      expect(ScreenSize.fromWidth(1920), ScreenSize.large);
    });

    test('columns follow Material 3 guidelines', () {
      expect(ScreenSize.compact.columns, 4);
      expect(ScreenSize.medium.columns, 8);
      expect(ScreenSize.expanded.columns, 12);
      expect(ScreenSize.large.columns, 12);
    });

    test('horizontal padding increases with size', () {
      expect(
        ScreenSize.compact.horizontalPadding,
        lessThan(ScreenSize.large.horizontalPadding),
      );
    });
  });
}
