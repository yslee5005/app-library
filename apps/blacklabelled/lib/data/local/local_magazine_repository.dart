import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/magazine.dart';
import '../repositories/magazine_repository.dart';

class LocalMagazineRepository implements MagazineRepository {
  List<Magazine>? _cachedMagazines;

  Future<List<Magazine>> _loadMagazines() async {
    if (_cachedMagazines != null) return _cachedMagazines!;

    final jsonString = await rootBundle.loadString(
      'assets/data/magazines.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    _cachedMagazines =
        jsonList
            .map((e) => Magazine.fromJson(e as Map<String, dynamic>))
            .toList();
    return _cachedMagazines!;
  }

  @override
  Future<List<Magazine>> getAll() => _loadMagazines();
}
