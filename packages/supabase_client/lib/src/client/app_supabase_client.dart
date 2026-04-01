import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// A Supabase client wrapper that automatically scopes all queries to an [appId].
///
/// All table queries are automatically filtered by `app_id`,
/// ensuring multi-tenant data isolation at the application level.
/// RLS policies provide the actual security layer at the database level.
class AppSupabaseClient {
  AppSupabaseClient({
    required this.config,
    required SupabaseClient client,
  }) : _client = client;

  final SupabaseConfig config;
  final SupabaseClient _client;

  /// The app identifier for multi-tenant scoping.
  String get appId => config.appId;

  /// Access the underlying Supabase client directly.
  /// Use with caution — prefer scoped methods.
  SupabaseClient get raw => _client;

  /// Access Supabase Auth.
  GoTrueClient get auth => _client.auth;

  /// Query a table with automatic app_id filtering (SELECT).
  PostgrestFilterBuilder<List<Map<String, dynamic>>> from(String table) {
    return _client.from(table).select().eq('app_id', appId);
  }

  /// Insert into a table with automatic app_id injection.
  PostgrestTransformBuilder<Map<String, dynamic>> insert(
    String table,
    Map<String, dynamic> data,
  ) {
    return _client.from(table).insert({
      ...data,
      'app_id': appId,
    }).select().single();
  }

  /// Update a row in a table (app_id scoping via RLS).
  PostgrestTransformBuilder<List<Map<String, dynamic>>> update(
    String table,
    Map<String, dynamic> data,
  ) {
    return _client.from(table).update(data).eq('app_id', appId).select();
  }

  /// Delete from a table (app_id scoping via RLS).
  PostgrestTransformBuilder<List<Map<String, dynamic>>> delete(String table) {
    return _client.from(table).delete().eq('app_id', appId).select();
  }

  /// Call an RPC function with automatic app_id parameter.
  PostgrestFilterBuilder<dynamic> rpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) {
    return _client.rpc(functionName, params: {
      'p_app_id': appId,
      ...?params,
    });
  }

  /// Initialize Supabase Flutter. Call once in main.dart.
  static Future<void> initialize(SupabaseConfig config) async {
    await Supabase.initialize(
      url: config.url,
      anonKey: config.anonKey,
    );
  }
}
