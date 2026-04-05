import '../../models/furniture.dart';

abstract class FurnitureRepository {
  Future<List<Furniture>> getAll();
  Future<List<Furniture>> getByCategory(String category);
  Future<Furniture?> getById(String id);
}
