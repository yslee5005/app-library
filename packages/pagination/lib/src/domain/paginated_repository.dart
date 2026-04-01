import 'package:app_lib_core/core.dart';

/// Abstract interface for cursor-based paginated data access.
///
/// Implementations should fetch a single page of [T] items
/// from the underlying data source (e.g., Supabase).
///
/// Example implementation:
/// ```dart
/// class MyRepository implements PaginatedRepository<MyModel> {
///   @override
///   Future<Result<PaginatedResult<MyModel>>> fetchPage(
///     PaginationParams params,
///   ) async {
///     // fetch from data source...
///   }
/// }
/// ```
abstract interface class PaginatedRepository<T> {
  /// Fetches a single page of items.
  ///
  /// Returns [Result.success] with a [PaginatedResult] on success,
  /// or [Result.failure] with an [AppException] on error.
  Future<Result<PaginatedResult<T>>> fetchPage(PaginationParams params);
}
