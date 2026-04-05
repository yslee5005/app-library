import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/furniture.dart';
import '../repositories/furniture_repository.dart';

class LocalFurnitureRepository implements FurnitureRepository {
  List<Furniture>? _cachedFurniture;

  Future<List<Furniture>> _loadFurniture() async {
    if (_cachedFurniture != null) return _cachedFurniture!;

    final jsonString = await rootBundle.loadString(
      'assets/data/furniture.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    _cachedFurniture =
        jsonList
            .map((e) => Furniture.fromJson(e as Map<String, dynamic>))
            .toList();
    return _cachedFurniture!;
  }

  @override
  Future<List<Furniture>> getAll() => _loadFurniture();

  @override
  Future<List<Furniture>> getByCategory(String category) async {
    final furniture = await _loadFurniture();
    return furniture.where((f) => f.category == category).toList();
  }

  @override
  Future<Furniture?> getById(String id) async {
    final furniture = await _loadFurniture();
    try {
      return furniture.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }
}
