import '../../models/scrap.dart';

abstract class ScrapRepository {
  Future<List<Scrap>> getAll();
  Future<void> toggle(String contentType, String contentId);
  Future<bool> isScrapped(String contentType, String contentId);
}
