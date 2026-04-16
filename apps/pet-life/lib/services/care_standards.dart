import '../models/breed_info.dart';
import '../models/pet_profile.dart';

/// Recommended care standards based on breed, size, and age.
/// All values sourced from veterinary research.
class CareStandards {
  final PetProfile profile;
  final BreedInfo? breed;

  CareStandards({required this.profile, this.breed});

  double get _age => profile.ageYears;
  String get _size => breed?.size ?? 'medium';
  bool get _isSenior => _age >= (breed?.seniorAge ?? 7);
  bool get _isPuppy => _age < 1;

  /// All 15 comparison items grouped by category
  List<CareCategory> get categories => [
        CareCategory(
          name: '활동',
          icon: '🏃',
          items: [
            CareItem(
              id: 'walk_frequency',
              icon: '🦴',
              name: '산책 빈도',
              unit: '회/주',
              recommended: _recommendedWeeklyWalks,
              tip: _walkFrequencyTip,
              source: 'AKC Exercise Guidelines',
              routineCategory: 'walk',
            ),
            CareItem(
              id: 'walk_duration',
              icon: '⏱️',
              name: '산책 시간',
              unit: '분/일',
              recommended: _recommendedDailyWalkMinutes,
              tip: '${breed?.name ?? "강아지"}는 하루 $_recommendedDailyWalkMinutes분 산책 권장',
              source: 'AKC by breed',
              routineCategory: null, // tracked differently
            ),
            CareItem(
              id: 'mental_stimulation',
              icon: '🧠',
              name: '정신 자극',
              unit: '분/일',
              recommended: _recommendedMentalMinutes,
              tip: '비활동 강아지는 치매 위험 6.47배 높아요. 노즈워크/퍼즐을 해보세요',
              source: 'Dog Aging Project — Nature Scientific Reports',
              routineCategory: 'custom',
            ),
            CareItem(
              id: 'socialization',
              icon: '🐕',
              name: '사회화',
              unit: '회/주',
              recommended: _isPuppy ? 4 : 1,
              tip: _isPuppy
                  ? '3-14주 사회화 결정적 시기! 다양한 경험을 시켜주세요'
                  : '주 1회 다른 강아지와 만남이 정서에 좋아요',
              source: 'PMC Puppy Socialization Study',
              routineCategory: null,
            ),
          ],
        ),
        CareCategory(
          name: '건강',
          icon: '🏥',
          items: [
            CareItem(
              id: 'teeth_brushing',
              icon: '🦷',
              name: '양치질',
              unit: '회/주',
              recommended: 7,
              tip: _teethTip,
              source: 'Cornell Vet: 3세 이상 80-90% 치주질환',
              routineCategory: 'care',
            ),
            CareItem(
              id: 'weight',
              icon: '⚖️',
              name: '체중',
              unit: 'kg',
              recommended: (breed?.weightKg?.max ?? 30).toInt(),
              tip: '과체중은 수명을 최대 2.5년 단축시켜요',
              source: 'AVMA Study — 50,000+ dogs',
              routineCategory: null,
              isWeightItem: true,
            ),
            CareItem(
              id: 'health_checkup',
              icon: '🏥',
              name: '건강검진',
              unit: '회/년',
              recommended: _isSenior ? 2 : 1,
              tip: _isSenior
                  ? '시니어는 연 2회 건강검진 필수예요'
                  : '연 1회 건강검진을 권장해요',
              source: 'AAHA Senior Care Guidelines',
              routineCategory: null,
            ),
            CareItem(
              id: 'preventive_meds',
              icon: '💊',
              name: '예방약',
              unit: '회/월',
              recommended: 1,
              tip: '심장사상충 + 벼룩/진드기 월 1회 예방 필수',
              source: 'American Heartworm Society',
              routineCategory: null,
            ),
            CareItem(
              id: 'ear_cleaning',
              icon: '👂',
              name: '귀 청소',
              unit: '회/주',
              recommended: _earCleaningFrequency,
              tip: _earCleaningTip,
              source: 'VCA Animal Hospitals',
              routineCategory: null,
            ),
          ],
        ),
        CareCategory(
          name: '영양',
          icon: '🍖',
          items: [
            CareItem(
              id: 'meals',
              icon: '🍖',
              name: '식사',
              unit: '회/일',
              recommended: _isPuppy ? 3 : 2,
              tip: _isPuppy ? '퍼피는 하루 3-4회 소량 급식' : '성견은 하루 2회 적정',
              source: 'Merck Veterinary Manual',
              routineCategory: 'meal',
            ),
            CareItem(
              id: 'water_intake',
              icon: '💧',
              name: '수분 섭취',
              unit: 'ml/일',
              recommended: (profile.weightKg * 55).round(), // 50-60ml per kg
              tip: '체중 1kg당 50-60ml 권장. ${profile.name}는 하루 ${(profile.weightKg * 55).round()}ml',
              source: 'WSAVA Nutrition Guidelines',
              routineCategory: null,
            ),
            CareItem(
              id: 'supplements',
              icon: '🐟',
              name: '보충제',
              unit: '',
              recommended: _isSenior ? 1 : 0,
              tip: _isSenior
                  ? '시니어: 관절 보조제(글루코사민) + 오메가3 권장'
                  : '현재 나이에는 필수는 아니지만 오메가3는 도움이 돼요',
              source: 'Cosequin & Welactin — #1 Vet Recommended',
              routineCategory: null,
            ),
          ],
        ),
        CareCategory(
          name: '관리',
          icon: '🛁',
          items: [
            CareItem(
              id: 'bathing',
              icon: '🛁',
              name: '목욕',
              unit: '회/월',
              recommended: _recommendedMonthlyBaths,
              tip: '${breed?.name ?? "강아지"}는 월 $_recommendedMonthlyBaths회 목욕 권장',
              source: 'AKC Grooming Guidelines',
              routineCategory: null,
            ),
            CareItem(
              id: 'brushing',
              icon: '✂️',
              name: '브러싱',
              unit: '회/주',
              recommended: _recommendedWeeklyBrushing,
              tip: _brushingTip,
              source: 'AKC by breed shedding level',
              routineCategory: null,
            ),
            CareItem(
              id: 'nail_trim',
              icon: '💅',
              name: '발톱 깎기',
              unit: '회/월',
              recommended: 2,
              tip: '과성장 시 보행 장애. 월 1-2회 권장',
              source: 'AVMA Pet Care',
              routineCategory: null,
            ),
          ],
        ),
      ];

  // ─── Private Helpers ───

  int get _recommendedWeeklyWalks {
    final exerciseMin = breed?.exerciseMinutesPerDay?.min ?? 60;
    if (exerciseMin >= 90) return 14; // 2x daily
    if (exerciseMin >= 60) return 14;
    if (exerciseMin >= 30) return 10;
    return 7;
  }

  int get _recommendedDailyWalkMinutes {
    return (breed?.exerciseMinutesPerDay?.min ?? 60).toInt();
  }

  int get _recommendedMentalMinutes {
    if (_size == 'small') return 10;
    if (_size == 'giant') return 15;
    // High energy breeds need more
    final exerciseMin = breed?.exerciseMinutesPerDay?.min ?? 60;
    if (exerciseMin >= 90) return 30;
    if (exerciseMin >= 60) return 20;
    return 15;
  }

  int get _earCleaningFrequency {
    // Floppy ear breeds need more frequent cleaning
    final breedName = breed?.name.toLowerCase() ?? '';
    if (breedName.contains('cocker') ||
        breedName.contains('basset') ||
        breedName.contains('beagle') ||
        breedName.contains('retriever')) {
      return 2; // twice per week
    }
    return 1; // once per week
  }

  int get _recommendedMonthlyBaths {
    final shedding = breed?.sheddingLevel ?? 'moderate';
    if (shedding == 'high') return 2;
    if (shedding == 'low') return 1;
    return 1;
  }

  int get _recommendedWeeklyBrushing {
    final shedding = breed?.sheddingLevel ?? 'moderate';
    if (shedding == 'high') return 4;
    if (shedding == 'low') return 2;
    return 3;
  }

  String get _walkFrequencyTip {
    final rec = _recommendedWeeklyWalks;
    return '${breed?.name ?? "이 견종"}은 주 $rec회 산책 권장 (하루 ${rec ~/ 7 > 1 ? "2" : "1"}회)';
  }

  String get _teethTip {
    if (_size == 'small') {
      return '소형견은 치아가 밀집되어 치주질환 위험이 더 높아요. 매일 양치 필수!';
    }
    return '3세 이상 강아지의 80-90%가 치주질환. 매일 양치가 가장 효과적';
  }

  String get _earCleaningTip {
    if (_earCleaningFrequency >= 2) {
      return '늘어진 귀 견종은 감염 위험이 높아요. 주 2회 청소 권장';
    }
    return '주 1회 귀 확인 + 청소. 냄새/발적 시 수의사 상담';
  }

  String get _brushingTip {
    final shedding = breed?.sheddingLevel ?? 'moderate';
    if (shedding == 'high') return '털 빠짐이 많은 견종이에요. 주 4회+ 브러싱 권장';
    if (shedding == 'low') return '털 빠짐이 적지만 엉킴 방지를 위해 주 2회 권장';
    return '주 3회 브러싱으로 건강한 모질 유지';
  }
}

class CareCategory {
  final String name;
  final String icon;
  final List<CareItem> items;

  const CareCategory({
    required this.name,
    required this.icon,
    required this.items,
  });
}

class CareItem {
  final String id;
  final String icon;
  final String name;
  final String unit;
  final int recommended;
  final String tip;
  final String source;
  final String? routineCategory; // if linked to a routine category for auto-counting
  final bool isWeightItem;

  const CareItem({
    required this.id,
    required this.icon,
    required this.name,
    required this.unit,
    required this.recommended,
    required this.tip,
    required this.source,
    this.routineCategory,
    this.isWeightItem = false,
  });
}
