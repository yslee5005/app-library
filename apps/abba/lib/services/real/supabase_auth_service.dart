import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user_profile.dart';
import '../auth_service.dart';

class SupabaseAuthService implements AuthService {
  final SupabaseClient _client;
  final _controller = StreamController<AbbaAuthState>.broadcast();

  SupabaseAuthService(this._client) {
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

  @override
  Future<UserProfile> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'com.ystech.abba://callback',
    );
    return _waitForProfile();
  }

  @override
  Future<UserProfile> signInWithApple() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'com.ystech.abba://callback',
    );
    return _waitForProfile();
  }

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
  Future<UserProfile> linkWithGoogle() async {
    await _client.auth.linkIdentity(OAuthProvider.google);
    return _waitForProfile();
  }

  @override
  Future<UserProfile> linkWithApple() async {
    await _client.auth.linkIdentity(OAuthProvider.apple);
    return _waitForProfile();
  }

  @override
  Future<UserProfile> linkWithEmail(String email, String password) async {
    await _client.auth.updateUser(
      UserAttributes(email: email, password: password),
    );
    final user = _client.auth.currentUser!;
    return _ensureProfile(user);
  }

  @override
  Stream<AbbaAuthState> get authStateChanges => _controller.stream;

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

  Future<UserProfile> _waitForProfile() async {
    final state = await authStateChanges.firstWhere(
      (s) => s.status == AuthStatus.authenticated,
    );
    return state.user!;
  }
}
