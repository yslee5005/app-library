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

  /// Stream of authentication state changes.
  Stream<AuthState> onAuthStateChange();
}
