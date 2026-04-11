import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/furniture.dart';
import '../repositories/furniture_repository.dart';

/// Supabase-backed implementation of FurnitureRepository
/// Maps blacklabelled.products → Furniture model
///
/// DB categories with parent "FURNITURE": Kitchen, Bath, Design_Furniture, System
class SupabaseFurnitureRepository implements FurnitureRepository {
  final SupabaseClient _client;

  // FURNITURE parent category IDs
  static const _furnitureCategoryIds = [34, 35, 46, 47]; // Kitchen, Bath, Design_Furniture, System

  SupabaseFurnitureRepository(this._client);

  SupabaseQueryBuilder get _products =>
      _client.schema('blacklabelled').from('products');

  String _storageUrl(String path) =>
      '${_client.supabaseUrl}/storage/v1/object/public/portfolio-images/$path';

  Furniture _fromRow(Map<String, dynamic> row) {
    final images = (row['product_images'] as List? ?? [])
        .where((img) => img['deleted_at'] == null)
        .toList()
      ..sort((a, b) => (a['sort_order'] as int).compareTo(b['sort_order'] as int));

    final imageUrls = images
        .map<String>((img) => _storageUrl(img['storage_path'] as String))
        .toList();

    final mainCatName = row['categories']?['name'] as String? ?? '';

    return Furniture(
      id: row['id'].toString(),
      title: row['name'] as String,
      category: mainCatName,
      description: row['description'] as String? ?? '',
      images: imageUrls,
    );
  }

  static const _select = '''
    id, name, slug, description, price, status, main_category_id,
    categories!products_main_category_id_fkey(id, name),
    product_images(sort_order, type, storage_path, deleted_at)
  ''';

  @override
  Future<List<Furniture>> getAll() async {
    final response = await _products
        .select(_select)
        .eq('status', 'published')
        .isFilter('deleted_at', null)
        .inFilter('main_category_id', _furnitureCategoryIds)
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
        .eq('id', int.parse(id))
        .isFilter('deleted_at', null)
        .maybeSingle();

    if (response == null) return null;
    return _fromRow(response);
  }
}
