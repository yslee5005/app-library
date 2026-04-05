import '../../models/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getAll();
  Future<List<Project>> getByCategory(String category);
  Future<Project?> getById(String id);
  Future<List<Project>> getFeatured();
}
