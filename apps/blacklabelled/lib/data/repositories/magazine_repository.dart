import '../../models/magazine.dart';

abstract class MagazineRepository {
  Future<List<Magazine>> getAll();
}
