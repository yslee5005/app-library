import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/furniture.dart';
import '../repositories/furniture_repository.dart';

/// Supabase-backed implementation of FurnitureRepository
/// Maps blacklabelled.products -> Furniture model
///
/// Filters products whose main_category belongs to the "FURNITURE" parent category.
/// Category names under FURNITURE: Kitchen, Bath, Design_Furniture, System
class SupabaseFurnitureRepository implements FurnitureRepository {
  final SupabaseClient _client;

  static const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// Cached FURNITURE child category UUIDs (loaded once from DB)
  List<String>? _furnitureCategoryIds;

  SupabaseFurnitureRepository(this._client);

  SupabaseQueryBuilder get _products =>
      _client.schema('blacklabelled').from('products');

  SupabaseQueryBuilder get _categories =>
      _client.schema('blacklabelled').from('categories');

  String _storageUrl(String path) =>
      '$_supabaseUrl/storage/v1/object/public/blacklabelled/$path';

  /// Display-friendly category name (e.g. Design_Furniture -> Design Furniture)
  static String _displayName(String dbName) => dbName.replaceAll('_', ' ');

  /// Load FURNITURE child category UUIDs from DB (cached after first call)
  Future<List<String>> _getFurnitureCategoryIds() async {
    if (_furnitureCategoryIds != null) return _furnitureCategoryIds!;

    // 1. Find the "FURNITURE" parent category
    final parentRows = await _categories
        .select('id')
        .eq('name', 'FURNITURE')
        .isFilter('parent_id', null)
        .limit(1);

    if ((parentRows as List).isEmpty) {
      _furnitureCategoryIds = [];
      return _furnitureCategoryIds!;
    }

    final furnitureParentId = parentRows[0]['id'] as String;

    // 2. Get all child categories under FURNITURE
    final childRows = await _categories
        .select('id, name')
        .eq('parent_id', furnitureParentId);

    _furnitureCategoryIds = (childRows as List)
        .map<String>((row) => row['id'] as String)
        .toList();

    return _furnitureCategoryIds!;
  }

  Furniture _fromRow(Map<String, dynamic> row) {
    final images = (row['product_images'] as List? ?? [])
        .where((img) => img['deleted_at'] == null)
        .toList()
      ..sort(
          (a, b) => (a['sort_order'] as int).compareTo(b['sort_order'] as int));

    final imageUrls = images
        .map<String>((img) => _storageUrl(img['storage_path'] as String))
        .toList();

    final mainCatName = row['categories']?['name'] as String? ?? '';

    return Furniture(
      id: row['id'].toString(),
      title: row['name'] as String,
      category: _displayName(mainCatName),
      description: row['description'] as String? ?? '',
      images: imageUrls,
    );
  }

  static const _select = '''
    id, name, slug, description, price, status, main_category_id,
    categories!products_main_category_id_fkey(id, name),
    product_images(sort_order, type, storage_path, original_url, original_filename, width, height, deleted_at)
  ''';

  @override
  Future<List<Furniture>> getAll() async {
    final categoryIds = await _getFurnitureCategoryIds();
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
  Future<List<Furniture>> getByCategory(String category) async {
    final all = await getAll();
    return all.where((f) => f.category == category).toList();
  }

  @override
  Future<Furniture?> getById(String id) async {
    final response = await _products
        .select(_select)
        .eq('id', id)
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (response == null) return null;
    return _fromRow(response);
  }
}
