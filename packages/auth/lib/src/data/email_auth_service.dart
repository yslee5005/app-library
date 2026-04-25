import 'package:supabase_flutter/supabase_flutter.dart'
    hide AuthException, AuthState;

import 'package:app_lib_core/core.dart';

/// Handles email/password authentication with Supabase Auth.
class EmailAuthService {
  EmailAuthService({required GoTrueClient auth}) : _auth = auth;

  final GoTrueClient _auth;

  /// Signs in with email and password.
  Future<Result<AuthResponse>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      return Result.success(response);
    } on AuthApiException catch (e, st) {
      return Result.failure(
        AuthException(
          message: e.message,
          code: e.code,
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Result.failure(
        AuthException(
          message: 'Email sign-in failed: $e',
          code: 'email_sign_in_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// Links email/password to the current anonymous user.
  ///
  /// Uses [updateUser] to add email + password credentials to the
  /// existing anonymous session, preserving the user's UUID.
  Future<Result<void>> linkEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.updateUser(UserAttributes(email: email, password: password));
      return const Result.success(null);
    } on AuthApiException catch (e, st) {
      return Result.failure(
        AuthException(
          message: e.message,
          code: e.code,
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Result.failure(
        AuthException(
          message: 'Email link failed: $e',
          code: 'email_link_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// Creates a new account with email and password.
  Future<Result<AuthResponse>> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
      return Result.success(response);
    } on AuthApiException catch (e, st) {
      return Result.failure(
        AuthException(
          message: e.message,
          code: e.code,
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Result.failure(
        AuthException(
          message: 'Sign up failed: $e',
          code: 'sign_up_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }
}
