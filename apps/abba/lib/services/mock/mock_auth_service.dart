import 'dart:async';

import '../../models/user_profile.dart';
import '../auth_service.dart';
import '../mock_data.dart';

class MockAuthService implements AuthService {
  final MockDataService _mockData;
  final _controller = StreamController<AbbaAuthState>.broadcast();

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
  Stream<AbbaAuthState> get authStateChanges => _controller.stream;
}
