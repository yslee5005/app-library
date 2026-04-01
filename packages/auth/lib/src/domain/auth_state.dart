import 'user_profile.dart';

/// Represents the current authentication state of the user.
///
/// Usage with pattern matching:
/// ```dart
/// switch (state) {
///   case Authenticated(:final user):
///     return HomeScreen(user: user);
///   case Unauthenticated():
///     return LoginScreen();
///   case AuthLoading():
///     return LoadingIndicator();
///   case AuthError(:final message):
///     return ErrorScreen(message: message);
/// }
/// ```
sealed class AuthState {
  const AuthState();
}

/// The user is authenticated with a valid session.
final class Authenticated extends AuthState {
  const Authenticated({required this.user});

  final UserProfile user;
}

/// The user is not authenticated (no session or logged out).
final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Authentication is in progress (loading).
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// An authentication error occurred.
final class AuthError extends AuthState {
  const AuthError({required this.message, this.code});

  final String message;
  final String? code;
}
