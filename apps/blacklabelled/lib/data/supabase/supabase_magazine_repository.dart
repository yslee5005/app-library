import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/magazine.dart';
import '../repositories/magazine_repository.dart';

/// Supabase-backed implementation of MagazineRepository
/// Maps blacklabelled.magazines → Magazine model
///
/// DB column is `thumbnail_path` (Storage path like "magazines/xxx.jpg").
/// Full URL = ${SUPABASE_URL}/storage/v1/object/public/blacklabelled/{path}
class SupabaseMagazineRepository implements MagazineRepository {
  final SupabaseClient _client;

  SupabaseMagazineRepository(this._client);

  static const _supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');

  SupabaseQueryBuilder get _magazines =>
      _client.schema('blacklabelled').from('magazines');

  /// Build a full public Storage URL from a thumbnail_path.
  /// Returns empty string when path is null or empty.
  String _buildThumbnailUrl(String? path) {
    if (path == null || path.isEmpty || _supabaseUrl.isEmpty) return '';
    return '$_supabaseUrl/storage/v1/object/public/blacklabelled/$path';
  }

  Magazine _fromRow(Map<String, dynamic> row) {
    return Magazine(
      id: row['id'] as String,
      title: row['title'] as String,
      summary: row['summary'] as String? ?? '',
      thumbnail: _buildThumbnailUrl(row['thumbnail_path'] as String?),
      date: row['date'] as String? ?? '',
    );
  }

  @override
  Future<List<Magazine>> getAll() async {
    final response = await _magazines
        .select('id, title, summary, thumbnail_path, date')
        .order('date', ascending: false);

    return (response as List).map((row) => _fromRow(row)).toList();
  }
}
