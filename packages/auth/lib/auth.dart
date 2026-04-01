/// App Library Auth — Google/Apple/Email authentication with Supabase.
///
/// Provides multi-tenant authentication with automatic app_id isolation.
/// Supports Google Sign-In, Apple Sign-In, and Email/Password.
library;

// Domain
export 'src/domain/auth_repository.dart';
export 'src/domain/auth_state.dart';
export 'src/domain/user_profile.dart';

// Data
export 'src/data/apple_auth_service.dart';
export 'src/data/email_auth_service.dart';
export 'src/data/google_auth_service.dart';
export 'src/data/supabase_auth_repository.dart';
