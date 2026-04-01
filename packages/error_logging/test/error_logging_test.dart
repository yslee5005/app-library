import 'package:app_lib_error_logging/error_logging.dart';
import 'package:test/test.dart';

void main() {
  group('ErrorLevel', () {
    test('has all expected values', () {
      expect(ErrorLevel.values, hasLength(4));
      expect(ErrorLevel.values, contains(ErrorLevel.fatal));
      expect(ErrorLevel.values, contains(ErrorLevel.error));
      expect(ErrorLevel.values, contains(ErrorLevel.warning));
      expect(ErrorLevel.values, contains(ErrorLevel.info));
    });

    test('ordinal ordering: fatal is most severe', () {
      expect(ErrorLevel.fatal.index, lessThan(ErrorLevel.error.index));
      expect(ErrorLevel.error.index, lessThan(ErrorLevel.warning.index));
      expect(ErrorLevel.warning.index, lessThan(ErrorLevel.info.index));
    });
  });

  group('SensitiveDataFilter', () {
    group('email masking', () {
      test('masks simple email', () {
        final result = SensitiveDataFilter.mask('user@example.com');
        expect(result, isNot(contains('user@example.com')));
        expect(result, contains('@'));
        expect(result, contains('.com'));
      });

      test('masks email preserving first and last chars', () {
        final result = SensitiveDataFilter.mask('hello@domain.com');
        expect(result, startsWith('h'));
        expect(result, contains('@'));
      });

      test('masks email in context', () {
        final result = SensitiveDataFilter.mask(
          'User rrallvv@gmail.com logged in',
        );
        expect(result, isNot(contains('rrallvv@gmail.com')));
        expect(result, contains('logged in'));
      });

      test('masks multiple emails', () {
        final result = SensitiveDataFilter.mask(
          'From a@b.com to c@d.com',
        );
        expect(result, isNot(contains('a@b.com')));
        expect(result, isNot(contains('c@d.com')));
      });

      test('short email parts still masked', () {
        final result = SensitiveDataFilter.mask('ab@cd.com');
        expect(result, isNot(equals('ab@cd.com')));
      });
    });

    group('Bearer token masking', () {
      test('masks Bearer token', () {
        final result = SensitiveDataFilter.mask(
          'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.test.sig',
        );
        expect(result, contains('Bearer ***REDACTED***'));
        expect(result, isNot(contains('eyJhbGciOiJIUzI1NiJ9')));
      });

      test('case insensitive bearer', () {
        final result = SensitiveDataFilter.mask('bearer my_secret_token');
        expect(result, isNot(contains('my_secret_token')));
      });
    });

    group('API key masking', () {
      test('masks api_key=value', () {
        final result = SensitiveDataFilter.mask('api_key=sk_live_abc123');
        expect(result, contains('***REDACTED***'));
        expect(result, isNot(contains('sk_live_abc123')));
      });

      test('masks apikey=value', () {
        final result = SensitiveDataFilter.mask('apikey=my_secret');
        expect(result, contains('***REDACTED***'));
        expect(result, isNot(contains('my_secret')));
      });

      test('masks secret=value', () {
        final result = SensitiveDataFilter.mask('secret=top_secret_123');
        expect(result, contains('***REDACTED***'));
        expect(result, isNot(contains('top_secret_123')));
      });

      test('masks token=value', () {
        final result = SensitiveDataFilter.mask('token=abc123def');
        expect(result, contains('***REDACTED***'));
        expect(result, isNot(contains('abc123def')));
      });

      test('masks password=value', () {
        final result = SensitiveDataFilter.mask('password=hunter2');
        expect(result, contains('***REDACTED***'));
        expect(result, isNot(contains('hunter2')));
      });

      test('masks with colon separator', () {
        final result = SensitiveDataFilter.mask('api-key: sk_test_abc');
        expect(result, contains('***REDACTED***'));
        expect(result, isNot(contains('sk_test_abc')));
      });
    });

    group('JWT masking', () {
      test('masks standalone JWT token', () {
        const jwt =
            'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U';
        final result = SensitiveDataFilter.mask('JWT is $jwt here');
        expect(result, contains('***JWT_REDACTED***'));
        expect(result, isNot(contains('eyJhbGciOiJIUzI1NiJ9')));
      });

      test('masks JWT in Bearer header', () {
        const jwt =
            'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U';
        final result = SensitiveDataFilter.mask('Bearer $jwt');
        // JWT is masked first, then Bearer redaction applies
        expect(result, isNot(contains('eyJhbGciOiJIUzI1NiJ9')));
      });
    });

    group('mixed sensitive data', () {
      test('masks multiple types in one string', () {
        final result = SensitiveDataFilter.mask(
          'User test@email.com with api_key=secret123',
        );
        expect(result, isNot(contains('test@email.com')));
        expect(result, isNot(contains('secret123')));
      });

      test('preserves non-sensitive text', () {
        final result = SensitiveDataFilter.mask(
          'Error in /api/users at line 42',
        );
        expect(result, 'Error in /api/users at line 42');
      });

      test('empty string returns empty', () {
        expect(SensitiveDataFilter.mask(''), '');
      });
    });
  });

  group('ErrorLoggingService', () {
    test('can be implemented', () async {
      final service = _MockLoggingService();

      await service.log('test message');
      await service.captureException(
        Exception('test'),
        level: ErrorLevel.error,
      );
      service.addBreadcrumb(message: 'user clicked button');

      expect(service.messages, ['test message']);
      expect(service.exceptions, hasLength(1));
      expect(service.breadcrumbs, ['user clicked button']);
    });
  });
}

class _MockLoggingService implements ErrorLoggingService {
  final List<String> messages = [];
  final List<Object> exceptions = [];
  final List<String> breadcrumbs = [];

  @override
  Future<void> log(
    String message, {
    ErrorLevel level = ErrorLevel.info,
  }) async {
    messages.add(message);
  }

  @override
  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    ErrorLevel level = ErrorLevel.error,
    Map<String, String>? tags,
  }) async {
    exceptions.add(exception);
  }

  @override
  void addBreadcrumb({
    required String message,
    String? category,
    Map<String, String>? data,
  }) {
    breadcrumbs.add(message);
  }
}
