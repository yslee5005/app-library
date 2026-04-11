import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/scrap.dart';
import '../repositories/scrap_repository.dart';

/// Supabase-backed implementation of ScrapRepository
/// Anonymous-First: uses auth.uid() from anonymous sign-in
/// Maps blacklabelled.scraps → Scrap model
class SupabaseScrapRepository implements ScrapRepository {
  final SupabaseClient _client;

  SupabaseScrapRepository(this._client);

  SupabaseQueryBuilder get _scraps =>
      _client.schema('blacklabelled').from('scraps');

  String? get _userId => _client.auth.currentUser?.id;

  /// Get tenant_id for blacklabelled (cached)
  String? _tenantId;
  Future<String> _getTenantId() async {
    if (_tenantId != null) return _tenantId!;
    final result = await _client
        .from('tenants')
        .select('id')
        .eq('slug', 'blacklabelled')
        .single();
    _tenantId = result['id'] as String;
    return _tenantId!;
  }

  Scrap _fromRow(Map<String, dynamic> row) {
    return Scrap(
      contentType: row['content_type'] as String,
      contentId: row['content_id'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  @override
  Future<List<Scrap>> getAll() async {
    if (_userId == null) return [];

    final response = await _scraps
        .select('content_type, content_id, created_at')
        .eq('user_id', _userId!)
        .order('created_at', ascending: false);

    return (response as List).map((row) => _fromRow(row)).toList();
  }

  @override
  Future<void> toggle(String contentType, String contentId) async {
    if (_userId == null) return;

    final existing = await _scraps
        .select('id')
        .eq('user_id', _userId!)
        .eq('content_type', contentType)
        .eq('content_id', contentId)
        .maybeSingle();

    if (existing != null) {
      // Remove scrap
      await _scraps.delete().eq('id', existing['id']).execute();
    } else {
      // Add scrap
      final tenantId = await _getTenantId();
      await _scraps.insert({
        'tenant_id': tenantId,
        'user_id': _userId!,
        'content_type': contentType,
        'content_id': contentId,
      }).execute();
    }
  }

  @override
  Future<bool> isScrapped(String contentType, String contentId) async {
    if (_userId == null) return false;

    final result = await _scraps
        .select('id')
        .eq('user_id', _userId!)
        .eq('content_type', contentType)
        .eq('content_id', contentId)
        .maybeSingle();

    return result != null;
  }
}
