import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
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
  /// Flow: generate nonce → Apple Sign-In → get identityToken
  /// → Supabase signInWithIdToken with raw nonce.
  Future<Result<AuthResponse>> signIn() async {
    try {
      final (rawNonce, credential) = await _getAppleCredential();

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
        nonce: rawNonce,
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

  /// Links Apple identity to the current anonymous user.
  ///
  /// Uses [linkIdentityWithIdToken] to preserve the anonymous UUID.
  /// Falls back to [signInWithIdToken] if the identity is already linked
  /// to another user (e.g., app reinstall scenario).
  Future<Result<AuthResponse>> link() async {
    try {
      final (rawNonce, credential) = await _getAppleCredential();

      final idToken = credential.identityToken;
      if (idToken == null) {
        return const Result.failure(
          AuthException(
            message: 'Failed to get Apple ID token',
            code: 'no_id_token',
          ),
        );
      }

      try {
        final response = await _auth.linkIdentityWithIdToken(
          provider: OAuthProvider.apple,
          idToken: idToken,
          nonce: rawNonce,
        );
        return Result.success(response);
      } on AuthApiException catch (e) {
        // Identity already linked to another user (e.g., app reinstall).
        // Fall back to signInWithIdToken to recover the existing account.
        if (e.code == 'identity_already_exists') {
          final response = await _auth.signInWithIdToken(
            provider: OAuthProvider.apple,
            idToken: idToken,
            nonce: rawNonce,
          );
          return Result.success(response);
        }
        rethrow;
      }
    } on SignInWithAppleAuthorizationException catch (e, st) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return const Result.failure(
          AuthException(
            message: 'Apple link cancelled',
            code: 'cancelled',
          ),
        );
      }
      return Result.failure(
        AuthException(
          message: 'Apple link failed: ${e.message}',
          code: 'apple_link_error',
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
          message: 'Apple link failed: $e',
          code: 'apple_link_error',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// Gets Apple credential with a generated nonce.
  Future<(String rawNonce, AuthorizationCredentialAppleID credential)>
      _getAppleCredential() async {
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    return (rawNonce, credential);
  }

  /// Generates a cryptographically secure random nonce.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }
}
