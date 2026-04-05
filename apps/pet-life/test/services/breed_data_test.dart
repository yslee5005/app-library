import 'package:flutter_test/flutter_test.dart';
import 'package:pet_life/models/breed_info.dart';

void main() {
  group('BreedInfo', () {
    test('fromJson creates breed with all fields', () {
      final json = {
        'id': 'golden_retriever',
        'name': 'Golden Retriever',
        'name_ko': '골든 리트리버',
        'group': 'Sporting',
        'size': 'large',
        'weight_kg': {'min': 25, 'max': 34},
        'height_cm': {'min': 51, 'max': 61},
        'lifespan_years': {'min': 10, 'max': 12, 'median': 11.0},
        'senior_age': 7,
        'temperament': ['Intelligent', 'Friendly'],
        'exercise_minutes_per_day': {'min': 60, 'max': 120},
        'genetic_health_risks': [
          {
            'condition': 'Cancer',
            'condition_ko': '암',
            'prevalence_percent': 60,
            'severity': 'critical',
            'source': 'Morris Animal Foundation',
            'description': '약 60%의 골든 리트리버가 암으로 사망합니다.',
            'prevention': '정기 검진',
          },
        ],
        'age_milestones': [
          {
            'age': 0.5,
            'event': '사회화 완료기',
            'description': '3-14주 사이 사회화가 매우 중요합니다.',
          },
        ],
      };

      final breed = BreedInfo.fromJson(json);

      expect(breed.id, 'golden_retriever');
      expect(breed.name, 'Golden Retriever');
      expect(breed.nameKo, '골든 리트리버');
      expect(breed.size, 'large');
      expect(breed.lifespanYears.median, 11.0);
      expect(breed.seniorAge, 7);
      expect(breed.weightKg?.min, 25);
      expect(breed.weightKg?.max, 34);
      expect(breed.geneticHealthRisks.length, 1);
      expect(breed.geneticHealthRisks.first.severity, 'critical');
      expect(breed.ageMilestones?.length, 1);
    });

    test('fromJson handles minimal breed data (tier4)', () {
      final json = {
        'id': 'airedale_terrier',
        'name': 'Airedale Terrier',
        'name_ko': '에어데일 테리어',
        'size': 'large',
        'lifespan_years': {'min': 11, 'max': 14, 'median': 12.5},
        'weight_kg': {'min': 20, 'max': 30},
        'senior_age': 8,
        'data_confidence': 'standard',
      };

      final breed = BreedInfo.fromJson(json);

      expect(breed.id, 'airedale_terrier');
      expect(breed.nameKo, '에어데일 테리어');
      expect(breed.geneticHealthRisks, isEmpty);
      expect(breed.ageMilestones, isNull);
      expect(breed.dataConfidence, 'standard');
    });

    test('returns empty risks for breed with no health data', () {
      final json = {
        'id': 'test_breed',
        'name': 'Test',
        'name_ko': '테스트',
        'size': 'medium',
        'lifespan_years': {'min': 10, 'max': 14, 'median': 12.0},
        'senior_age': 8,
      };

      final breed = BreedInfo.fromJson(json);
      expect(breed.geneticHealthRisks, isEmpty);
    });

    test('returns data_confidence for rare breeds', () {
      final json = {
        'id': 'rare_breed',
        'name': 'Rare',
        'name_ko': '희귀견',
        'size': 'small',
        'lifespan_years': {'min': 12, 'max': 15, 'median': 13.5},
        'senior_age': 10,
        'data_confidence': 'limited',
        'data_note': '연구 데이터가 제한적입니다.',
      };

      final breed = BreedInfo.fromJson(json);
      expect(breed.dataConfidence, 'limited');
      expect(breed.dataNote, contains('제한적'));
    });
  });

  group('HealthRisk', () {
    test('fromJson creates risk correctly', () {
      final json = {
        'condition': 'Hip Dysplasia',
        'condition_ko': '고관절 이형성증',
        'prevalence_percent': 20,
        'severity': 'high',
        'source': 'OFA Statistics',
        'description': '고관절이 비정상적으로 발달합니다.',
        'prevention': '적정 체중 유지',
      };

      final risk = HealthRisk.fromJson(json);
      expect(risk.condition, 'Hip Dysplasia');
      expect(risk.conditionKo, '고관절 이형성증');
      expect(risk.prevalencePercent, 20);
      expect(risk.severity, 'high');
      expect(risk.description, isNotNull);
      expect(risk.prevention, isNotNull);
    });
  });

  group('LifespanData', () {
    test('fromJson extracts min, max, median', () {
      final data = LifespanData.fromJson({
        'min': 10,
        'max': 12,
        'median': 11.0,
      });

      expect(data.min, 10.0);
      expect(data.max, 12.0);
      expect(data.median, 11.0);
    });
  });
}
