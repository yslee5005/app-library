import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/app_config.dart';
import '../../models/user_profile.dart';
import '../auth_service.dart';

class SupabaseAuthService implements AuthService {
  final SupabaseClient _client;
  final _controller = StreamController<AbbaAuthState>.broadcast();

  SupabaseAuthService(this._client);

  /// Attach the auth state listener.
  /// Call this after Supabase is confirmed initialized — NOT in the constructor
  /// to avoid EXC_BAD_ACCESS when the client is in an invalid state.
  void init() {
    _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _fetchProfile(session.user.id).then((profile) {
          _controller.add(
            AbbaAuthState(status: AuthStatus.authenticated, user: profile),
          );
        });
      } else {
        _controller.add(
          const AbbaAuthState(status: AuthStatus.unauthenticated),
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Google — native sign-in via google_sign_in + signInWithIdToken
  // ---------------------------------------------------------------------------

  @override
  Future<UserProfile> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      clientId: AppConfig.googleIosClientId,
      serverClientId: AppConfig.googleWebClientId,
    );
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) throw Exception('No Google ID token');

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    return _fetchOrCreateProfile();
  }

  @override
  Future<UserProfile> linkWithGoogle() async {
    if (!isAnonymous) {
      // Already linked — just return current profile
      return _fetchOrCreateProfile();
    }
    // For anonymous users, signInWithIdToken automatically links the identity
    return signInWithGoogle();
  }

  // ---------------------------------------------------------------------------
  // Apple — native sign-in via sign_in_with_apple + signInWithIdToken
  // ---------------------------------------------------------------------------

  @override
  Future<UserProfile> signInWithApple() async {
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) throw Exception('No Apple ID token');

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );

    return _fetchOrCreateProfile();
  }

  @override
  Future<UserProfile> linkWithApple() async {
    if (!isAnonymous) {
      // Already linked — just return current profile
      return _fetchOrCreateProfile();
    }
    // For anonymous users, signInWithIdToken automatically links the identity
    return signInWithApple();
  }

  // ---------------------------------------------------------------------------
  // Email
  // ---------------------------------------------------------------------------

  @override
  Future<UserProfile> signInWithEmail(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      final signUpResponse = await _client.auth.signUp(
        email: email,
        password: password,
      );
      if (signUpResponse.user == null) {
        throw Exception('Authentication failed');
      }
      return _ensureProfile(signUpResponse.user!);
    }
    return _ensureProfile(response.user!);
  }

  @override
  Future<UserProfile> linkWithEmail(String email, String password) async {
    await _client.auth.updateUser(
      UserAttributes(email: email, password: password),
    );
    final user = _client.auth.currentUser!;
    return _ensureProfile(user);
  }

  // ---------------------------------------------------------------------------
  // Sign-out / Anonymous / State
  // ---------------------------------------------------------------------------

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
    _controller.add(const AbbaAuthState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return _fetchProfile(user.id);
  }

  @override
  Future<UserProfile> signInAnonymously() async {
    final response = await _client.auth.signInAnonymously();
    if (response.user == null) {
      throw Exception('Anonymous sign-in failed');
    }
    return _ensureProfile(response.user!);
  }

  @override
  bool get isAnonymous {
    final user = _client.auth.currentUser;
    return user?.isAnonymous ?? true;
  }

  @override
  Stream<AbbaAuthState> get authStateChanges => _controller.stream;

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<UserProfile> _fetchOrCreateProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');
    return _ensureProfile(user);
  }

  Future<UserProfile> _ensureProfile(User user) async {
    final existing = await _fetchProfile(user.id);
    if (existing != null) return existing;

    final profile = UserProfile(
      id: user.id,
      name:
          user.userMetadata?['full_name'] as String? ??
          user.email?.split('@').first ??
          'User',
      email: user.email ?? '',
    );
    await _client.from('profiles').upsert({
      'id': profile.id,
      'app_id': 'abba',
      'name': profile.name,
      'email': profile.email,
    });
    return profile;
  }

  Future<UserProfile?> _fetchProfile(String userId) async {
    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .eq('app_id', 'abba')
          .maybeSingle();
      if (data == null) return null;
      return UserProfile.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Generate a cryptographically secure random nonce for Apple Sign In.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
