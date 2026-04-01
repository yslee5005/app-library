/// Configuration for connecting to a Supabase project.
class SupabaseConfig {
  const SupabaseConfig({
    required this.url,
    required this.anonKey,
    required this.appId,
  });

  /// Supabase project URL.
  final String url;

  /// Supabase anonymous key (safe for client-side).
  final String anonKey;

  /// App identifier for multi-tenant isolation.
  final String appId;
}
