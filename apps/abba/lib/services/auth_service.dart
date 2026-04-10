import '../models/user_profile.dart';

enum AuthStatus { unauthenticated, authenticated, loading }

class AbbaAuthState {
  final AuthStatus status;
  final UserProfile? user;
  final String? error;

  const AbbaAuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.error,
  });

  AbbaAuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    String? error,
  }) {
    return AbbaAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

/// Abstract auth service — mock returns instantly, real calls Supabase
abstract class AuthService {
  Future<UserProfile> signInWithGoogle();
  Future<UserProfile> signInWithApple();
  Future<UserProfile> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserProfile?> getCurrentUser();
  Stream<AbbaAuthState> get authStateChanges;

  // Anonymous auth
  Future<UserProfile> signInAnonymously();
  Future<UserProfile> linkWithGoogle();
  Future<UserProfile> linkWithApple();
  Future<UserProfile> linkWithEmail(String email, String password);
  bool get isAnonymous;
}
