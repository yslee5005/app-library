import 'dart:async';

import 'package:app_lib_auth/auth.dart';
import 'package:app_lib_core/core.dart';

import '../mock_data.dart';

/// Mock implementation of [AuthRepository] for development/testing.
///
/// Returns fake data instantly with small delays for UX realism.
class MockAuthRepository implements AuthRepository {
  final MockDataService _mockData;
  final _controller = StreamController<AuthState>.broadcast();
  bool _isAnonymous = true;

  MockAuthRepository(this._mockData);

  @override
  Future<Result<UserProfile>> signInWithGoogle() => _mockSignIn('google');

  @override
  Future<Result<UserProfile>> signInWithApple() => _mockSignIn('apple');

  @override
  Future<Result<UserProfile>> signInWithEmail({
    required String email,
    required String password,
  }) => _mockSignIn('email');

  @override
  Future<Result<UserProfile>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) => _mockSignIn('email');

  @override
  Future<Result<UserProfile>> signInAnonymously() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _isAnonymous = true;
    final profile = UserProfile(
      id: 'anon-${DateTime.now().millisecondsSinceEpoch}',
      appId: 'abba',
    );
    _controller.add(Authenticated(user: profile));
    return Result.success(profile);
  }

  @override
  Future<Result<UserProfile>> linkWithGoogle() => _mockLink('google');

  @override
  Future<Result<UserProfile>> linkWithApple() => _mockLink('apple');

  @override
  Future<Result<UserProfile>> linkWithEmail({
    required String email,
    required String password,
  }) => _mockLink('email');

  @override
  bool get isAnonymous => _isAnonymous;

  @override
  Future<Result<void>> signOut() async {
    _isAnonymous = true;
    _controller.add(const Unauthenticated());
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteAccount() async {
    _controller.add(const Unauthenticated());
    return const Result.success(null);
  }

  @override
  Future<Result<UserProfile?>> getCurrentUser() async {
    final mockProfile = await _mockData.getUserProfile();
    final profile = UserProfile(
      id: mockProfile.id,
      appId: 'abba',
      email: mockProfile.email,
      displayName: mockProfile.name,
    );
    return Result.success(profile);
  }

  @override
  Future<Result<UserProfile>> updateProfile({
    String? displayName,
    String? avatarUrl,
    bool? onboardingCompleted,
  }) async {
    final mockProfile = await _mockData.getUserProfile();
    return Result.success(UserProfile(
      id: mockProfile.id,
      appId: 'abba',
      email: mockProfile.email,
      displayName: displayName ?? mockProfile.name,
      avatarUrl: avatarUrl,
    ));
  }

  @override
  Stream<AuthState> onAuthStateChange() => _controller.stream;

  Future<Result<UserProfile>> _mockSignIn(String provider) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _isAnonymous = false;
    final mockProfile = await _mockData.getUserProfile();
    final profile = UserProfile(
      id: mockProfile.id,
      appId: 'abba',
      email: mockProfile.email,
      displayName: mockProfile.name,
      provider: provider,
    );
    _controller.add(Authenticated(user: profile));
    return Result.success(profile);
  }

  Future<Result<UserProfile>> _mockLink(String provider) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _isAnonymous = false;
    final mockProfile = await _mockData.getUserProfile();
    final profile = UserProfile(
      id: mockProfile.id,
      appId: 'abba',
      email: mockProfile.email,
      displayName: mockProfile.name,
      provider: provider,
    );
    _controller.add(Authenticated(user: profile));
    return Result.success(profile);
  }
}
