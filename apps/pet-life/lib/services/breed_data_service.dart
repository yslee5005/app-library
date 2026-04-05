import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/breed_info.dart';

class BreedDataService {
  List<BreedInfo>? _breeds;
  Map<String, BreedInfo>? _breedMap;

  static final BreedDataService _instance = BreedDataService._();
  factory BreedDataService() => _instance;
  BreedDataService._();

  bool get isLoaded => _breeds != null;

  Future<void> loadBreeds() async {
    if (_breeds != null) return;

    final allBreeds = <BreedInfo>[];

    // Load all 4 tier files
    final files = [
      'assets/data/breed_database.json',
      'assets/data/breeds_tier2.json',
      'assets/data/breeds_tier3.json',
      'assets/data/breeds_tier4.json',
    ];

    for (final file in files) {
      try {
        final jsonStr = await rootBundle.loadString(file);
        final data = json.decode(jsonStr) as Map<String, dynamic>;
        final breeds = (data['breeds'] as List<dynamic>)
            .map((e) => BreedInfo.fromJson(e as Map<String, dynamic>))
            .toList();
        allBreeds.addAll(breeds);
      } catch (_) {
        // Tier file might not exist, skip
      }
    }

    _breeds = allBreeds;
    _breedMap = {for (final b in allBreeds) b.id: b};
  }

  List<BreedInfo> get allBreeds => _breeds ?? [];

  BreedInfo? getBreedById(String id) => _breedMap?[id];

  List<BreedInfo> searchBreeds(String query) {
    if (_breeds == null || query.isEmpty) return allBreeds;
    final lower = query.toLowerCase();
    return _breeds!.where((b) {
      return b.name.toLowerCase().contains(lower) ||
          b.nameKo.contains(query) ||
          b.id.contains(lower);
    }).toList();
  }

  List<HealthRisk> getHealthRisks(String breedId) {
    final breed = getBreedById(breedId);
    return breed?.geneticHealthRisks ?? [];
  }

  List<AgeMilestone> getAgeMilestones(String breedId) {
    final breed = getBreedById(breedId);
    return breed?.ageMilestones ?? _defaultMilestones(breed);
  }

  /// Generate default milestones based on breed size if not provided
  List<AgeMilestone> _defaultMilestones(BreedInfo? breed) {
    if (breed == null) return [];
    final seniorAge = breed.seniorAge.toDouble();
    return [
      const AgeMilestone(
        age: 0.5,
        event: '사회화 완료기',
        description: '3-14주 사이 사회화가 매우 중요합니다.',
      ),
      AgeMilestone(
        age: breed.size == 'small' || breed.size == 'medium' ? 1.0 : 1.5,
        event: '성견 도달',
        description: '신체 성장이 대부분 완료됩니다.',
      ),
      const AgeMilestone(
        age: 2.0,
        event: '정서 성숙',
        description: '행동이 안정됩니다.',
      ),
      AgeMilestone(
        age: seniorAge,
        event: '시니어 진입',
        description: '연 2회 건강검진 권장. 건강 변화에 주의하세요.',
      ),
      AgeMilestone(
        age: seniorAge + 2,
        event: '고령기',
        description: '관절, 심장, 인지 기능 주의 필요.',
      ),
    ];
  }
}
