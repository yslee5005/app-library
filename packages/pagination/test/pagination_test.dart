import 'package:app_lib_core/core.dart';
import 'package:app_lib_pagination/pagination.dart';
import 'package:test/test.dart';

void main() {
  group('PaginationState', () {
    test('initial state', () {
      const state = PaginationInitial<String>();
      expect(state, isA<PaginationState<String>>());
    });

    test('loading state with empty items', () {
      const state = PaginationLoading<String>();
      expect(state.items, isEmpty);
    });

    test('loading state preserves previous items', () {
      const state = PaginationLoading<String>(items: ['a', 'b']);
      expect(state.items, ['a', 'b']);
    });

    test('loaded state with data', () {
      const state = PaginationLoaded<String>(
        items: ['a', 'b', 'c'],
        hasMore: true,
        cursor: 'cursor_1',
        totalCount: 10,
      );
      expect(state.items.length, 3);
      expect(state.hasMore, isTrue);
      expect(state.cursor, 'cursor_1');
      expect(state.totalCount, 10);
    });

    test('loaded state without optional fields', () {
      const state = PaginationLoaded<String>(items: ['a'], hasMore: false);
      expect(state.cursor, isNull);
      expect(state.totalCount, isNull);
    });

    test('appendPage combines items', () {
      const state = PaginationLoaded<String>(
        items: ['a', 'b'],
        hasMore: true,
        cursor: 'cursor_1',
      );

      const nextPage = PaginatedResult<String>(
        items: ['c', 'd'],
        hasMore: false,
        cursor: 'cursor_2',
        totalCount: 4,
      );

      final newState = state.appendPage(nextPage);
      expect(newState.items, ['a', 'b', 'c', 'd']);
      expect(newState.hasMore, isFalse);
      expect(newState.cursor, 'cursor_2');
      expect(newState.totalCount, 4);
    });

    test('appendPage preserves totalCount when new page has none', () {
      const state = PaginationLoaded<String>(
        items: ['a'],
        hasMore: true,
        cursor: 'c1',
        totalCount: 10,
      );

      const nextPage = PaginatedResult<String>(items: ['b'], hasMore: false);

      final newState = state.appendPage(nextPage);
      expect(newState.totalCount, 10);
    });

    test('error state with exception', () {
      const state = PaginationError<String>(
        exception: NetworkException(message: 'timeout'),
      );
      expect(state.exception, isA<NetworkException>());
      expect(state.items, isEmpty);
    });

    test('error state preserves previous items', () {
      const state = PaginationError<String>(
        exception: DatabaseException(message: 'query failed'),
        items: ['a', 'b'],
      );
      expect(state.items, ['a', 'b']);
      expect(state.exception.message, 'query failed');
    });

    test('exhaustive pattern matching', () {
      const PaginationState<int> state = PaginationLoaded<int>(
        items: [1, 2, 3],
        hasMore: false,
      );

      final description = switch (state) {
        PaginationInitial() => 'initial',
        PaginationLoading() => 'loading',
        PaginationLoaded(:final items) => 'loaded ${items.length}',
        PaginationError(:final exception) => 'error ${exception.message}',
      };

      expect(description, 'loaded 3');
    });
  });

  group('PaginationParams', () {
    test('default values', () {
      const params = PaginationParams();
      expect(params.cursor, isNull);
      expect(params.limit, 20);
      expect(params.orderBy, 'created_at');
      expect(params.ascending, isFalse);
    });

    test('custom values', () {
      const params = PaginationParams(
        cursor: 'abc',
        limit: 50,
        orderBy: 'updated_at',
        ascending: true,
      );
      expect(params.cursor, 'abc');
      expect(params.limit, 50);
      expect(params.orderBy, 'updated_at');
      expect(params.ascending, isTrue);
    });
  });

  group('PaginatedResult', () {
    test('re-exported from core', () {
      const result = PaginatedResult<String>(
        items: ['a'],
        hasMore: true,
        cursor: 'c1',
      );
      expect(result.items, ['a']);
      expect(result.hasMore, isTrue);
    });

    test('empty result', () {
      const result = PaginatedResult<String>.empty();
      expect(result.items, isEmpty);
      expect(result.hasMore, isFalse);
    });
  });

  group('PaginatedRepository', () {
    test('can be implemented', () async {
      final repo = _MockPaginatedRepository();
      final result = await repo.fetchPage(const PaginationParams());
      expect(result.isSuccess, isTrue);
      expect(result.getOrThrow().items, ['item1', 'item2']);
    });

    test('can return failure', () async {
      final repo = _FailingPaginatedRepository();
      final result = await repo.fetchPage(const PaginationParams());
      expect(result.isFailure, isTrue);
    });
  });
}

class _MockPaginatedRepository implements PaginatedRepository<String> {
  @override
  Future<Result<PaginatedResult<String>>> fetchPage(
    PaginationParams params,
  ) async {
    return const Result.success(
      PaginatedResult(items: ['item1', 'item2'], hasMore: false),
    );
  }
}

class _FailingPaginatedRepository implements PaginatedRepository<String> {
  @override
  Future<Result<PaginatedResult<String>>> fetchPage(
    PaginationParams params,
  ) async {
    return const Result.failure(
      NetworkException(message: 'connection refused'),
    );
  }
}
