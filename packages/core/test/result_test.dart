import 'package:app_lib_core/core.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('Success contains value', () {
      const result = Result<int>.success(42);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.getOrThrow(), 42);
    });

    test('Failure contains exception', () {
      const result = Result<int>.failure(NetworkException(message: 'timeout'));
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(() => result.getOrThrow(), throwsA(isA<NetworkException>()));
    });

    test('getOrDefault returns default on failure', () {
      const result = Result<int>.failure(
        DatabaseException(message: 'not found'),
      );
      expect(result.getOrDefault(0), 0);
    });

    test('getOrDefault returns value on success', () {
      const result = Result<int>.success(42);
      expect(result.getOrDefault(0), 42);
    });

    test('map transforms success value', () {
      const result = Result<int>.success(42);
      final mapped = result.map((v) => v.toString());
      expect(mapped.getOrThrow(), '42');
    });

    test('map preserves failure', () {
      const result = Result<int>.failure(CacheException(message: 'expired'));
      final mapped = result.map((v) => v.toString());
      expect(mapped.isFailure, isTrue);
    });

    test('pattern matching works', () {
      const Result<int> result = Result.success(42);
      final message = switch (result) {
        Success(:final value) => 'Got $value',
        Failure(:final exception) => 'Error: ${exception.message}',
      };
      expect(message, 'Got 42');
    });
  });

  group('AppException', () {
    test('NetworkException with status code', () {
      const e = NetworkException(message: 'Not Found', statusCode: 404);
      expect(e.message, 'Not Found');
      expect(e.statusCode, 404);
      expect(e.toString(), 'NetworkException: Not Found');
    });

    test('DatabaseException with table', () {
      const e = DatabaseException(message: 'insert failed', table: 'comments');
      expect(e.table, 'comments');
    });

    test('AuthException with code', () {
      const e = AuthException(message: 'invalid token', code: 'AUTH_EXPIRED');
      expect(e.code, 'AUTH_EXPIRED');
    });

    test('ValidationException with field', () {
      const e = ValidationException(message: 'required', field: 'email');
      expect(e.field, 'email');
    });

    test('sealed class exhaustive switch', () {
      const AppException e = NetworkException(message: 'test');
      final type = switch (e) {
        NetworkException() => 'network',
        DatabaseException() => 'database',
        AuthException() => 'auth',
        CacheException() => 'cache',
        ValidationException() => 'validation',
      };
      expect(type, 'network');
    });
  });

  group('PaginatedResult', () {
    test('empty result', () {
      const result = PaginatedResult<String>.empty();
      expect(result.items, isEmpty);
      expect(result.hasMore, isFalse);
      expect(result.cursor, isNull);
    });

    test('result with items', () {
      const result = PaginatedResult<String>(
        items: ['a', 'b', 'c'],
        hasMore: true,
        cursor: 'abc123',
        totalCount: 10,
      );
      expect(result.items.length, 3);
      expect(result.hasMore, isTrue);
      expect(result.cursor, 'abc123');
      expect(result.totalCount, 10);
    });
  });
}
