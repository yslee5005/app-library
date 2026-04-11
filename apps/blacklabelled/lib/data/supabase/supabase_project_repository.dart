import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/project.dart';
import '../repositories/project_repository.dart';

/// Supabase-backed implementation of ProjectRepository
/// Maps blacklabelled.products → Project model
///
/// DB categories with parent "PROJECT": Boutiques, Cosmetics, Residence, Commercial
class SupabaseProjectRepository implements ProjectRepository {
  final SupabaseClient _client;

  // PROJECT parent category IDs
  static const _projectCategoryIds = [42, 43, 44, 49]; // Boutiques, Cosmetics, Residence, Commercial

  SupabaseProjectRepository(this._client);

  SupabaseQueryBuilder get _products =>
      _client.schema('blacklabelled').from('products');

  String _storageUrl(String path) =>
      '${_client.supabaseUrl}/storage/v1/object/public/portfolio-images/$path';

  Project _fromRow(Map<String, dynamic> row) {
    final images = (row['product_images'] as List? ?? [])
        .where((img) => img['deleted_at'] == null)
        .toList()
      ..sort((a, b) => (a['sort_order'] as int).compareTo(b['sort_order'] as int));

    final imageUrls = images
        .map<String>((img) => _storageUrl(img['storage_path'] as String))
        .toList();

    final mainCatName = row['categories']?['name'] as String? ?? '';

    return Project(
      id: row['id'].toString(),
      title: row['name'] as String,
      location: _extractLocation(row['name'] as String),
      category: mainCatName,
      area: null,
      year: null,
      description: row['description'] as String? ?? '',
      images: imageUrls,
      featured: false,
    );
  }

  String _extractLocation(String name) {
    // Extract location from product name (e.g. "잠실 트리지움" → "잠실")
    final parts = name.replaceAll('_', ' ').split(' ');
    return parts.isNotEmpty ? parts.first : '';
  }

  static const _select = '''
    id, name, slug, description, price, status, main_category_id,
    categories!products_main_category_id_fkey(id, name),
    product_images(sort_order, type, storage_path, deleted_at)
  ''';

  @override
  Future<List<Project>> getAll() async {
    final response = await _products
        .select(_select)
        .eq('status', 'published')
        .isFilter('deleted_at', null)
        .inFilter('main_category_id', _projectCategoryIds)
        .order('id', ascending: false);

    return (response as List).map((row) => _fromRow(row)).toList();
  }

  @override
  Future<List<Project>> getByCategory(String category) async {
    final all = await getAll();
    return all.where((p) => p.category == category).toList();
  }

  @override
  Future<Project?> getById(String id) async {
    final response = await _products
        .select(_select)
        .eq('id', int.parse(id))
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (response == null) return null;
    return _fromRow(response);
  }

  @override
  Future<List<Project>> getFeatured() async {
    final all = await getAll();
    return all.take(6).toList();
  }
}
