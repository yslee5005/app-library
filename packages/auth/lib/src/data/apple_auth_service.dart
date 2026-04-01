import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    hide AuthException, AuthState;

import 'package:app_lib_core/core.dart';

/// Handles Apple Sign-In and exchanges the credential with Supabase Auth.
class AppleAuthService {
  AppleAuthService({required GoTrueClient auth}) : _auth = auth;

  final GoTrueClient _auth;

  /// Signs in with Apple and returns the Supabase auth response.
  ///
  /// Flow: Apple Sign-In → get authorizationCode → Supabase signInWithIdToken.
  Future<Result<AuthResponse>> signIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        return const Result.failure(
          AuthException(
            message: 'Failed to get Apple ID token',
            code: 'no_id_token',
          ),
        );
      }

      final response = await _auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
      );

      return Result.success(response);
    } on SignInWithAppleAuthorizationException catch (e, st) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return const Result.failure(
          AuthException(message: 'Apple sign-in cancelled', code: 'cancelled'),
        );
      }
      return Result.failure(
        AuthException(
          message: 'Apple sign-in failed: ${e.message}',
          code: 'apple_sign_in_error',
          originalError: e,
          stackTrace: st,
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
          message: 'Apple sign-in failed: $e',
          code: 'apple_sign_in_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }
}
