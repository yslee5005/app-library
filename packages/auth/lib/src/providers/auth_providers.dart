import 'package:app_lib_core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_repository.dart';
import '../domain/auth_state.dart';
import '../domain/user_profile.dart';

/// Provides the [AuthRepository] implementation.
///
/// Apps **must** override this provider with their concrete implementation
/// (e.g., [SupabaseAuthRepository]) in [ProviderScope.overrides].
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     authRepositoryProvider.overrideWithValue(myAuthRepo),
///   ],
///   child: MyApp(),
/// )
/// ```
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError(
    'authRepositoryProvider must be overridden in your app. '
    'Add it to ProviderScope.overrides with your AuthRepository implementation.',
  );
});

/// Manages authentication state via [AuthNotifier].
///
/// Automatically resolves the initial auth state on build by checking
/// for an existing session through [AuthRepository.getCurrentUser].
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Async notifier that manages the [AuthState] lifecycle.
///
/// Methods:
/// - [signInWithGoogle] / [signInWithApple] / [signInWithEmail] — sign in
/// - [signUp] — create new account
/// - [signOut] — end session
class AuthNotifier extends AsyncNotifier<AuthState> {
  late final AuthRepository _repo;

  @override
  Future<AuthState> build() async {
    _repo = ref.watch(authRepositoryProvider);

    // Listen to auth state changes from the repository stream
    final subscription = _repo.onAuthStateChange().listen((authState) {
      state = AsyncData(authState);
    });
    ref.onDispose(subscription.cancel);

    // Resolve initial state
    final result = await _repo.getCurrentUser();
    return switch (result) {
      Success(value: final user?) => Authenticated(user: user),
      _ => const Unauthenticated(),
    };
  }

  /// Signs in with Google OAuth.
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    final result = await _repo.signInWithGoogle();
    state = switch (result) {
      Success(:final value) => AsyncData(Authenticated(user: value)),
      Failure(:final exception) => AsyncData(
        AuthError(
          message: exception.message,
          code: exception is AuthException ? exception.code : null,
        ),
      ),
    };
  }

  /// Signs in with Apple OAuth.
  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    final result = await _repo.signInWithApple();
    state = switch (result) {
      Success(:final value) => AsyncData(Authenticated(user: value)),
      Failure(:final exception) => AsyncData(
        AuthError(
          message: exception.message,
          code: exception is AuthException ? exception.code : null,
        ),
      ),
    };
  }

  /// Signs in with email and password.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await _repo.signInWithEmail(
      email: email,
      password: password,
    );
    state = switch (result) {
      Success(:final value) => AsyncData(Authenticated(user: value)),
      Failure(:final exception) => AsyncData(
        AuthError(
          message: exception.message,
          code: exception is AuthException ? exception.code : null,
        ),
      ),
    };
  }

  /// Creates a new account with email and password.
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncLoading();
    final result = await _repo.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );
    state = switch (result) {
      Success(:final value) => AsyncData(Authenticated(user: value)),
      Failure(:final exception) => AsyncData(
        AuthError(
          message: exception.message,
          code: exception is AuthException ? exception.code : null,
        ),
      ),
    };
  }

  /// Signs in anonymously. Used for Anonymous-First pattern.
  Future<void> signInAnonymously() async {
    state = const AsyncLoading();
    final result = await _repo.signInAnonymously();
    state = switch (result) {
      Success(:final value) => AsyncData(Authenticated(user: value)),
      Failure(:final exception) => AsyncData(
        AuthError(
          message: exception.message,
          code: exception is AuthException ? exception.code : null,
        ),
      ),
    };
  }

  /// Links the current anonymous account with Google.
  Future<void> linkWithGoogle() async {
    state = const AsyncLoading();
    final result = await _repo.linkWithGoogle();
    state = switch (result) {
      Success(:final value) => AsyncData(Authenticated(user: value)),
      Failure(:final exception) => AsyncData(
        AuthError(
          message: exception.message,
          code: exception is AuthException ? exception.code : null,
        ),
      ),
    };
  }

  /// Links the current anonymous account with Apple.
  Future<void> linkWithApple() async {
    state = const AsyncLoading();
    final result = await _repo.linkWithApple();
    state = switch (result) {
      Success(:final value) => AsyncData(Authenticated(user: value)),
      Failure(:final exception) => AsyncData(
        AuthError(
          message: exception.message,
          code: exception is AuthException ? exception.code : null,
        ),
      ),
    };
  }

  /// Links the current anonymous account with email/password.
  Future<void> linkWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await _repo.linkWithEmail(email: email, password: password);
    state = switch (result) {
      Success(:final value) => AsyncData(Authenticated(user: value)),
      Failure(:final exception) => AsyncData(
        AuthError(
          message: exception.message,
          code: exception is AuthException ? exception.code : null,
        ),
      ),
    };
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    state = const AsyncLoading();
    final result = await _repo.signOut();
    state = switch (result) {
      Success() => const AsyncData(Unauthenticated()),
      Failure(:final exception) => AsyncData(
        AuthError(
          message: exception.message,
          code: exception is AuthException ? exception.code : null,
        ),
      ),
    };
  }
}

/// Whether the current user is anonymous.
///
/// Reactively updates when auth state changes (sign-in, link, sign-out).
/// Returns `true` when no user is logged in or the user is anonymous.
final isAnonymousProvider = Provider<bool>((ref) {
  // Watch authNotifierProvider to trigger rebuild on state changes.
  final authState = ref.watch(authNotifierProvider);
  return switch (authState) {
    AsyncData(value: Authenticated()) =>
      ref.read(authRepositoryProvider).isAnonymous,
    _ => true,
  };
});

/// Derives the current [UserProfile] from the auth state.
///
/// Returns `null` when unauthenticated or loading.
/// Convenient for widgets that only need the user profile.
final currentUserProvider = Provider<UserProfile?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return switch (authState) {
    AsyncData(value: Authenticated(:final user)) => user,
    _ => null,
  };
});
