import 'dart:async';

import '../../models/user_profile.dart';
import '../auth_service.dart';
import '../mock_data.dart';

class MockAuthService implements AuthService {
  final MockDataService _mockData;
  final _controller = StreamController<AbbaAuthState>.broadcast();
  bool _isAnonymous = true;

  MockAuthService(this._mockData);

  @override
  Future<UserProfile> signInWithGoogle() => _mockSignIn();

  @override
  Future<UserProfile> signInWithApple() => _mockSignIn();

  @override
  Future<UserProfile> signInWithEmail(String email, String password) =>
      _mockSignIn();

  Future<UserProfile> _mockSignIn() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _isAnonymous = false;
    final profile = await _mockData.getUserProfile();
    _controller.add(
      AbbaAuthState(status: AuthStatus.authenticated, user: profile),
    );
    return profile;
  }

  @override
  Future<void> signOut() async {
    _controller.add(const AbbaAuthState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    return _mockData.getUserProfile();
  }

  @override
  Future<UserProfile> signInAnonymously() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _isAnonymous = true;
    final profile = UserProfile(
      id: 'anon-${DateTime.now().millisecondsSinceEpoch}',
      name: '',
      email: '',
    );
    _controller.add(
      AbbaAuthState(status: AuthStatus.authenticated, user: profile),
    );
    return profile;
  }

  @override
  bool get isAnonymous => _isAnonymous;

  @override
  Future<UserProfile> linkWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _isAnonymous = false;
    final profile = await _mockData.getUserProfile();
    _controller.add(
      AbbaAuthState(status: AuthStatus.authenticated, user: profile),
    );
    return profile;
  }

  @override
  Future<UserProfile> linkWithApple() => linkWithGoogle();

  @override
  Future<UserProfile> linkWithEmail(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _isAnonymous = false;
    final profile = UserProfile(
      id: 'user-linked',
      name: email.split('@').first,
      email: email,
    );
    _controller.add(
      AbbaAuthState(status: AuthStatus.authenticated, user: profile),
    );
    return profile;
  }

  @override
  Stream<AbbaAuthState> get authStateChanges => _controller.stream;
}
