import 'package:app_lib_core/core.dart';

import 'auth_state.dart';
import 'user_profile.dart';

/// Abstract interface for authentication operations.
///
/// Implementations handle the specifics of each auth provider
/// (Google, Apple, Email) while maintaining a consistent API.
///
/// All methods return [Result] for type-safe error handling.
abstract interface class AuthRepository {
  /// Signs in with Google OAuth.
  Future<Result<UserProfile>> signInWithGoogle();

  /// Signs in with Apple OAuth.
  Future<Result<UserProfile>> signInWithApple();

  /// Signs in with email and password.
  Future<Result<UserProfile>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Creates a new account with email and password.
  Future<Result<UserProfile>> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  /// Signs out the current user.
  Future<Result<void>> signOut();

  /// Deletes the current user's account and profile.
  Future<Result<void>> deleteAccount();

  /// Returns the currently authenticated user's profile, or null.
  Future<Result<UserProfile?>> getCurrentUser();

  /// Updates the current user's profile.
  Future<Result<UserProfile>> updateProfile({
    String? displayName,
    String? avatarUrl,
    bool? onboardingCompleted,
  });

  /// Signs in anonymously. Used for Anonymous-First pattern.
  Future<Result<UserProfile>> signInAnonymously();

  /// Links the current anonymous user's account with Google.
  /// Uses [linkIdentityWithIdToken] to preserve the anonymous UUID and data.
  Future<Result<UserProfile>> linkWithGoogle();

  /// Links the current anonymous user's account with Apple.
  /// Uses [linkIdentityWithIdToken] to preserve the anonymous UUID and data.
  Future<Result<UserProfile>> linkWithApple();

  /// Links the current anonymous user's account with email/password.
  Future<Result<UserProfile>> linkWithEmail({
    required String email,
    required String password,
  });

  /// Whether the current user is anonymous.
  bool get isAnonymous;

  /// Stream of authentication state changes.
  Stream<AuthState> onAuthStateChange();
}
