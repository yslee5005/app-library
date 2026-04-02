import 'dart:async';

import 'package:app_lib_auth/auth.dart';
import 'package:app_lib_core/core.dart';

/// Mock implementation of [AuthRepository] for the showcase app.
///
/// Simulates network delays and returns fake data — no real backend.
class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<AuthState>.broadcast();
  UserProfile? _currentUser;

  @override
  Future<Result<UserProfile>> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _currentUser = _mockUser(provider: 'google');
    _controller.add(Authenticated(user: _currentUser!));
    return Success(_currentUser!);
  }

  @override
  Future<Result<UserProfile>> signInWithApple() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _currentUser = _mockUser(provider: 'apple');
    _controller.add(Authenticated(user: _currentUser!));
    return Success(_currentUser!);
  }

  @override
  Future<Result<UserProfile>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _currentUser = _mockUser(email: email, provider: 'email');
    _controller.add(Authenticated(user: _currentUser!));
    return Success(_currentUser!);
  }

  @override
  Future<Result<UserProfile>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _currentUser = _mockUser(
      email: email,
      displayName: displayName ?? 'New User',
      provider: 'email',
    );
    _controller.add(Authenticated(user: _currentUser!));
    return Success(_currentUser!);
  }

  @override
  Future<Result<void>> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _controller.add(const Unauthenticated());
    return const Success(null);
  }

  @override
  Future<Result<void>> deleteAccount() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _controller.add(const Unauthenticated());
    return const Success(null);
  }

  @override
  Future<Result<UserProfile?>> getCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return Success(_currentUser);
  }

  @override
  Future<Result<UserProfile>> updateProfile({
    String? displayName,
    String? avatarUrl,
    bool? onboardingCompleted,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _currentUser = _currentUser?.copyWith(
      displayName: displayName,
      avatarUrl: avatarUrl,
      onboardingCompleted: onboardingCompleted,
    );
    return Success(_currentUser!);
  }

  @override
  Stream<AuthState> onAuthStateChange() => _controller.stream;

  UserProfile _mockUser({
    String? email,
    String? displayName,
    String provider = 'google',
  }) {
    return UserProfile(
      id: 'mock-user-1',
      appId: 'showcase',
      email: email ?? 'demo@example.com',
      displayName: displayName ?? 'Demo User',
      provider: provider,
      onboardingCompleted: true,
      createdAt: DateTime.now(),
    );
  }
}
