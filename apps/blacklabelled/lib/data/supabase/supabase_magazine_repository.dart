import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/magazine.dart';
import '../repositories/magazine_repository.dart';

/// Supabase-backed implementation of MagazineRepository
/// Maps blacklabelled.magazines → Magazine model
class SupabaseMagazineRepository implements MagazineRepository {
  final SupabaseClient _client;

  SupabaseMagazineRepository(this._client);

  SupabaseQueryBuilder get _magazines =>
      _client.schema('blacklabelled').from('magazines');

  Magazine _fromRow(Map<String, dynamic> row) {
    return Magazine(
      id: row['id'] as String,
      title: row['title'] as String,
      summary: row['summary'] as String? ?? '',
      thumbnail: row['thumbnail_url'] as String? ?? '',
      date: row['date'] as String? ?? '',
    );
  }

  @override
  Future<List<Magazine>> getAll() async {
    final response = await _magazines
        .select('id, title, summary, thumbnail_url, date')
        .order('date', ascending: false);

    return (response as List).map((row) => _fromRow(row)).toList();
  }
}
