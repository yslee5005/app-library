import '../errors/app_exception.dart';

/// A type that represents either a success value or a failure.
///
/// Usage:
/// ```dart
/// final result = await fetchUser(id);
/// switch (result) {
///   case Success(:final value):
///     print(value.name);
///   case Failure(:final exception):
///     print(exception.message);
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Creates a successful result.
  const factory Result.success(T value) = Success<T>;

  /// Creates a failure result.
  const factory Result.failure(AppException exception) = Failure<T>;

  /// Whether this result is a success.
  bool get isSuccess => this is Success<T>;

  /// Whether this result is a failure.
  bool get isFailure => this is Failure<T>;

  /// Maps the success value to a new type.
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success(:final value) => Result.success(transform(value)),
      Failure(:final exception) => Result.failure(exception),
    };
  }

  /// Returns the success value or throws the exception.
  T getOrThrow() {
    return switch (this) {
      Success(:final value) => value,
      Failure(:final exception) => throw exception,
    };
  }

  /// Returns the success value or a default.
  T getOrDefault(T defaultValue) {
    return switch (this) {
      Success(:final value) => value,
      Failure() => defaultValue,
    };
  }
}

/// A successful result containing a value.
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

/// A failed result containing an exception.
final class Failure<T> extends Result<T> {
  const Failure(this.exception);

  final AppException exception;
}
