import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/project.dart';
import '../repositories/project_repository.dart';

/// Supabase-backed implementation of ProjectRepository
/// Maps blacklabelled.products -> Project model
///
/// Filters products whose main_category belongs to the "PROJECT" parent category.
/// Category names under PROJECT: Boutiques, Cosmetics, Residence, Commercial
class SupabaseProjectRepository implements ProjectRepository {
  final SupabaseClient _client;

  static final _supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';

  /// Cached PROJECT child category UUIDs (loaded once from DB)
  List<String>? _projectCategoryIds;

  SupabaseProjectRepository(this._client);

  SupabaseQueryBuilder get _products =>
      _client.schema('blacklabelled').from('products');

  SupabaseQueryBuilder get _categories =>
      _client.schema('blacklabelled').from('categories');

  String _storageUrl(String path) =>
      '$_supabaseUrl/storage/v1/object/public/blacklabelled/$path';

  /// Display-friendly category name (e.g. Design_Furniture -> Design Furniture)
  static String _displayName(String dbName) => dbName.replaceAll('_', ' ');

  /// Load PROJECT child category UUIDs from DB (cached after first call)
  Future<List<String>> _getProjectCategoryIds() async {
    if (_projectCategoryIds != null) return _projectCategoryIds!;

    // 1. Find the "PROJECT" parent category
    final parentRows = await _categories
        .select('id')
        .eq('name', 'PROJECT')
        .isFilter('parent_id', null)
        .limit(1);

    if ((parentRows as List).isEmpty) {
      _projectCategoryIds = [];
      return _projectCategoryIds!;
    }

    final projectParentId = parentRows[0]['id'] as String;

    // 2. Get all child categories under PROJECT (excluding Layout_Design)
    final childRows = await _categories
        .select('id, name')
        .eq('parent_id', projectParentId);

    _projectCategoryIds =
        (childRows as List)
            .where((row) => row['name'] != 'Layout_Design')
            .map<String>((row) => row['id'] as String)
            .toList();

    return _projectCategoryIds!;
  }

  Project _fromRow(Map<String, dynamic> row) {
    final images =
        (row['product_images'] as List? ?? [])
            .where((img) => img['deleted_at'] == null)
            .toList()
          ..sort(
            (a, b) =>
                (a['sort_order'] as int).compareTo(b['sort_order'] as int),
          );

    final imageUrls =
        images
            .map<String>((img) => _storageUrl(img['storage_path'] as String))
            .toList();

    final mainCatName = row['categories']?['name'] as String? ?? '';

    return Project(
      id: row['id'].toString(),
      title: row['name'] as String,
      location: _extractLocation(row['name'] as String),
      category: _displayName(mainCatName),
      area: null,
      year: null,
      description: row['description'] as String? ?? '',
      images: imageUrls,
      featured: false,
    );
  }

  String _extractLocation(String name) {
    final parts = name.replaceAll('_', ' ').split(' ');
    return parts.isNotEmpty ? parts.first : '';
  }

  static const _select = '''
    id, name, slug, description, price, status, main_category_id,
    categories!products_main_category_id_fkey(id, name),
    product_images(sort_order, type, storage_path, original_url, original_filename, width, height, deleted_at)
  ''';

  @override
  Future<List<Project>> getAll() async {
    final categoryIds = await _getProjectCategoryIds();
    if (categoryIds.isEmpty) return [];

    final response = await _products
        .select(_select)
        .eq('status', 'published')
        .isFilter('deleted_at', null)
        .inFilter('main_category_id', categoryIds)
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
    final response =
        await _products
            .select(_select)
            .eq('id', id)
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
