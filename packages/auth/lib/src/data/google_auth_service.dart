import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    hide AuthException, AuthState;

import 'package:app_lib_core/core.dart';

/// Handles Google Sign-In and exchanges the credential with Supabase Auth.
class GoogleAuthService {
  GoogleAuthService({
    required GoTrueClient auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final GoTrueClient _auth;
  final GoogleSignIn _googleSignIn;

  /// Signs in with Google and returns the Supabase auth response.
  ///
  /// Flow: Google Sign-In → get idToken → Supabase signInWithIdToken.
  Future<Result<AuthResponse>> signIn() async {
    try {
      final (idToken, accessToken) = await _getGoogleTokens();

      final response = await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return Result.success(response);
    } on _GoogleCancelledException {
      return const Result.failure(
        AuthException(message: 'Google sign-in cancelled', code: 'cancelled'),
      );
    } on _GoogleNoTokenException {
      return const Result.failure(
        AuthException(
          message: 'Failed to get Google ID token',
          code: 'no_id_token',
        ),
      );
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
          message: 'Google sign-in failed: $e',
          code: 'google_sign_in_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// Links Google identity to the current anonymous user.
  ///
  /// Uses [linkIdentityWithIdToken] to preserve the anonymous UUID.
  /// Falls back to [signInWithIdToken] if the identity is already linked
  /// to another user (e.g., app reinstall scenario).
  Future<Result<AuthResponse>> link() async {
    try {
      final (idToken, accessToken) = await _getGoogleTokens();

      try {
        final response = await _auth.linkIdentityWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
        return Result.success(response);
      } on AuthApiException catch (e) {
        // Identity already linked to another user (e.g., app reinstall).
        // Fall back to signInWithIdToken to recover the existing account.
        if (e.code == 'identity_already_exists') {
          final response = await _auth.signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken,
          );
          return Result.success(response);
        }
        rethrow;
      }
    } on _GoogleCancelledException {
      return const Result.failure(
        AuthException(message: 'Google link cancelled', code: 'cancelled'),
      );
    } on _GoogleNoTokenException {
      return const Result.failure(
        AuthException(
          message: 'Failed to get Google ID token',
          code: 'no_id_token',
        ),
      );
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
          message: 'Google link failed: $e',
          code: 'google_link_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// Signs out of Google.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  /// Common helper to get Google ID token and access token.
  Future<(String idToken, String? accessToken)> _getGoogleTokens() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw _GoogleCancelledException();

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) throw _GoogleNoTokenException();

    return (idToken, googleAuth.accessToken);
  }
}

class _GoogleCancelledException implements Exception {}

class _GoogleNoTokenException implements Exception {}
