import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/project.dart';
import '../repositories/project_repository.dart';

class LocalProjectRepository implements ProjectRepository {
  List<Project>? _cachedProjects;

  Future<List<Project>> _loadProjects() async {
    if (_cachedProjects != null) return _cachedProjects!;

    final jsonString = await rootBundle.loadString('assets/data/projects.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _cachedProjects =
        jsonList
            .map((e) => Project.fromJson(e as Map<String, dynamic>))
            .toList();
    return _cachedProjects!;
  }

  @override
  Future<List<Project>> getAll() => _loadProjects();

  @override
  Future<List<Project>> getByCategory(String category) async {
    final projects = await _loadProjects();
    return projects.where((p) => p.category == category).toList();
  }

  @override
  Future<Project?> getById(String id) async {
    final projects = await _loadProjects();
    try {
      return projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Project>> getFeatured() async {
    final projects = await _loadProjects();
    return projects.where((p) => p.featured).toList();
  }
}
