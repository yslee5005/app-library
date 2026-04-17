import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart'
    hide AuthException, AuthState;

import 'package:app_lib_core/core.dart';
import 'package:app_lib_supabase_client/supabase_client.dart';

import '../domain/auth_repository.dart';
import '../domain/auth_state.dart';
import '../domain/user_profile.dart';
import 'apple_auth_service.dart';
import 'email_auth_service.dart';
import 'google_auth_service.dart';

/// Supabase implementation of [AuthRepository].
///
/// Coordinates between social auth services and Supabase Auth,
/// managing user profiles with multi-tenant app_id isolation.
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    required AppSupabaseClient client,
    required GoogleAuthService googleAuth,
    required AppleAuthService appleAuth,
    required EmailAuthService emailAuth,
  })  : _client = client,
        _googleAuth = googleAuth,
        _appleAuth = appleAuth,
        _emailAuth = emailAuth;

  final AppSupabaseClient _client;
  final GoogleAuthService _googleAuth;
  final AppleAuthService _appleAuth;
  final EmailAuthService _emailAuth;

  GoTrueClient get _auth => _client.auth;

  @override
  Future<Result<UserProfile>> signInWithGoogle() async {
    final result = await _googleAuth.signIn();
    return switch (result) {
      Success(:final value) => _fetchOrCreateProfile(value, 'google'),
      Failure(:final exception) => Result.failure(exception),
    };
  }

  @override
  Future<Result<UserProfile>> signInWithApple() async {
    final result = await _appleAuth.signIn();
    return switch (result) {
      Success(:final value) => _fetchOrCreateProfile(value, 'apple'),
      Failure(:final exception) => Result.failure(exception),
    };
  }

  @override
  Future<Result<UserProfile>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _emailAuth.signIn(
      email: email,
      password: password,
    );
    return switch (result) {
      Success(:final value) => _fetchOrCreateProfile(value, 'email'),
      Failure(:final exception) => Result.failure(exception),
    };
  }

  @override
  Future<Result<UserProfile>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final result = await _emailAuth.signUp(
      email: email,
      password: password,
      metadata: {
        if (displayName != null) 'full_name': displayName,
      },
    );
    return switch (result) {
      Success(:final value) => _fetchOrCreateProfile(value, 'email'),
      Failure(:final exception) => Result.failure(exception),
    };
  }

  @override
  Future<Result<UserProfile>> signInAnonymously() async {
    try {
      final response = await _auth.signInAnonymously(
        data: {'app_id': _client.appId},
      );
      final user = response.user;
      if (user == null) {
        return const Result.failure(
          AuthException(
            message: 'Anonymous sign-in failed',
            code: 'anonymous_sign_in_error',
          ),
        );
      }
      return _fetchOrCreateProfile(response, 'anonymous');
    } catch (e, st) {
      return Result.failure(
        AuthException(
          message: 'Anonymous sign-in failed: $e',
          code: 'anonymous_sign_in_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<UserProfile>> linkWithGoogle() async {
    final result = await _googleAuth.link();
    return switch (result) {
      Success(:final value) => _fetchOrCreateProfile(value, 'google'),
      Failure(:final exception) => Result.failure(exception),
    };
  }

  @override
  Future<Result<UserProfile>> linkWithApple() async {
    final result = await _appleAuth.link();
    return switch (result) {
      Success(:final value) => _fetchOrCreateProfile(value, 'apple'),
      Failure(:final exception) => Result.failure(exception),
    };
  }

  @override
  Future<Result<UserProfile>> linkWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _emailAuth.linkEmail(
      email: email,
      password: password,
    );
    return switch (result) {
      Success() => _refreshProfile(),
      Failure(:final exception) => Result.failure(exception),
    };
  }

  @override
  bool get isAnonymous {
    final user = _auth.currentUser;
    return user?.isAnonymous ?? true;
  }

  /// Refreshes the current user's profile after a link operation.
  Future<Result<UserProfile>> _refreshProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      return const Result.failure(
        AuthException(message: 'No authenticated user', code: 'not_auth'),
      );
    }
    final data = await _client
        .from('profiles')
        .eq('id', user.id)
        .maybeSingle();
    if (data == null) {
      return const Result.failure(
        AuthException(
          message: 'Profile not found after linking',
          code: 'fetch_profile_error',
        ),
      );
    }
    return Result.success(UserProfile.fromJson(data));
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _googleAuth.signOut();
      await _auth.signOut();
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(
        AuthException(
          message: 'Sign out failed: $e',
          code: 'sign_out_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      final userId = _auth.currentUser?.id;
      if (userId == null) {
        return const Result.failure(
          AuthException(message: 'No authenticated user', code: 'not_auth'),
        );
      }

      // Delete profile first (cascade will handle related data).
      await _client.raw
          .from('profiles')
          .delete()
          .eq('app_id', _client.appId)
          .eq('id', userId);

      // Sign out (actual user deletion requires service_role via Edge Function).
      await _auth.signOut();

      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(
        AuthException(
          message: 'Delete account failed: $e',
          code: 'delete_account_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<UserProfile?>> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Result.success(null);
      }

      final data = await _client
          .from('profiles')
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) {
        return const Result.success(null);
      }

      return Result.success(UserProfile.fromJson(data));
    } catch (e, st) {
      return Result.failure(
        AuthException(
          message: 'Failed to get current user: $e',
          code: 'get_user_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<UserProfile>> updateProfile({
    String? displayName,
    String? avatarUrl,
    bool? onboardingCompleted,
  }) async {
    try {
      final userId = _auth.currentUser?.id;
      if (userId == null) {
        return const Result.failure(
          AuthException(message: 'No authenticated user', code: 'not_auth'),
        );
      }

      final updates = <String, dynamic>{
        if (displayName != null) 'display_name': displayName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (onboardingCompleted != null)
          'onboarding_completed': onboardingCompleted,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      final data = await _client.raw
          .from('profiles')
          .update(updates)
          .eq('app_id', _client.appId)
          .eq('id', userId)
          .select()
          .single();

      return Result.success(UserProfile.fromJson(data));
    } catch (e, st) {
      return Result.failure(
        AuthException(
          message: 'Failed to update profile: $e',
          code: 'update_profile_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Stream<AuthState> onAuthStateChange() {
    return _auth.onAuthStateChange.asyncMap((event) async {
      switch (event.event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
        case AuthChangeEvent.userUpdated:
          final profileResult = await getCurrentUser();
          return switch (profileResult) {
            Success(value: final profile?) => Authenticated(user: profile),
            Success(value: null) => const Unauthenticated(),
            Failure(:final exception) =>
              AuthError(message: exception.message),
          };
        case AuthChangeEvent.signedOut:
          return const Unauthenticated();
        default:
          return const Unauthenticated();
      }
    });
  }

  /// Fetches the existing profile or waits for the trigger to create one.
  Future<Result<UserProfile>> _fetchOrCreateProfile(
    AuthResponse response,
    String provider,
  ) async {
    try {
      final user = response.user;
      if (user == null) {
        return const Result.failure(
          AuthException(message: 'No user in auth response', code: 'no_user'),
        );
      }

      // The handle_new_user trigger creates the profile automatically.
      // Try fetching it; if not found, create it manually as a fallback.
      final data = await _client
              .from('profiles')
              .eq('id', user.id)
              .maybeSingle() ??
          await _client.insert('profiles', {
            'id': user.id,
            'email': user.email,
            'display_name': user.userMetadata?['full_name'] as String? ??
                user.userMetadata?['name'] as String?,
            'avatar_url': user.userMetadata?['avatar_url'] as String?,
            'provider': provider,
          });

      return Result.success(UserProfile.fromJson(data));
    } catch (e, st) {
      return Result.failure(
        AuthException(
          message: 'Failed to fetch profile: $e',
          code: 'fetch_profile_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }
}
