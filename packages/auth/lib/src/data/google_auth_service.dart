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
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const Result.failure(
          AuthException(message: 'Google sign-in cancelled', code: 'cancelled'),
        );
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        return const Result.failure(
          AuthException(
            message: 'Failed to get Google ID token',
            code: 'no_id_token',
          ),
        );
      }

      final response = await _auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
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
          message: 'Google sign-in failed: $e',
          code: 'google_sign_in_error',
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
}
