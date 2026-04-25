import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../models/breed_info.dart';
import '../../../models/pet_profile.dart';
import '../../../services/breed_data_service.dart';
import '../../../services/pet_storage_service.dart';
import '../../../widgets/glass_card.dart';

class GuideView extends StatefulWidget {
  const GuideView({super.key});

  @override
  State<GuideView> createState() => _GuideViewState();
}

class _GuideViewState extends State<GuideView> {
  PetProfile? _profile;
  BreedInfo? _breedInfo;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await PetStorageService().loadProfile();
    if (profile == null) return;
    final breedInfo = BreedDataService().getBreedById(profile.breedId);

    setState(() {
      _profile = profile;
      _breedInfo = breedInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('가이드', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                '나이 맞춤 건강 관리 가이드',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _buildHealthChecklistSection(),
              const SizedBox(height: 24),
              _buildVaccinationSection(),
              const SizedBox(height: 24),
              _buildExerciseSection(),
              const SizedBox(height: 24),
              _buildDietSection(),
              const SizedBox(height: 24),
              _buildDementiaPreventionSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthChecklistSection() {
    final age = _profile?.ageYears ?? 0;
    final isSenior = age >= (_breedInfo?.seniorAge ?? 7);

    final checklist = <_CheckItem>[
      _CheckItem('기본 건강검진', isSenior ? '연 2회' : '연 1회', '혈액검사, 신체검사, 체중 측정'),
      _CheckItem('치과 검진', '연 1회', '치석 제거, 치주 질환 확인'),
      _CheckItem('예방접종', '매년', 'DHPP, 광견병, 보르데텔라'),
      _CheckItem('심장사상충 예방', '매월', '월 1회 예방약 투여'),
      _CheckItem('외부 기생충 예방', '매월', '벼룩, 진드기 예방'),
    ];

    if (isSenior) {
      checklist.addAll([
        _CheckItem('갑상선 검사', '연 1회', '시니어 필수 검사'),
        _CheckItem('관절 검진', '연 1-2회', 'X-ray, 활동성 평가'),
        _CheckItem('안과 검진', '연 1회', '백내장, 녹내장 확인'),
      ]);
    }

    return _buildSection(
      title: '건강검진 체크리스트',
      icon: Icons.checklist,
      subtitle: isSenior ? '시니어 강화 검진 포함' : null,
      child: Column(
        children: checklist.map((item) => _buildCheckItem(item)).toList(),
      ),
    );
  }

  Widget _buildVaccinationSection() {
    final schedules = [
      _VacSchedule('6-8주', 'DHPP 1차', '디스템퍼, 파보바이러스 등'),
      _VacSchedule('10-12주', 'DHPP 2차', '추가 접종'),
      _VacSchedule('14-16주', 'DHPP 3차 + 광견병', '법정 의무 접종'),
      _VacSchedule('매년', 'DHPP + 광견병 보강', '연간 추가 접종'),
      _VacSchedule('6개월마다', '보르데텔라', '기관지 질환 예방'),
    ];

    return _buildSection(
      title: '예방접종 스케줄',
      icon: Icons.vaccines,
      child: Column(
        children:
            schedules.map((s) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        s.timing,
                        style: TextStyle(
                          color: AppConfig.accentColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            s.description,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildExerciseSection() {
    final exercise = _breedInfo?.exerciseMinutesPerDay;

    return _buildSection(
      title: '운동 권장량',
      icon: Icons.directions_run,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (exercise != null)
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.pets, color: AppConfig.accentColor, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_breedInfo!.nameKo} 권장 운동량',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          '하루 ${exercise.min.toInt()}-${exercise.max.toInt()}분',
                          style: TextStyle(
                            color: AppConfig.accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          _buildGuideItem(
            '퍼피 (1세 미만)',
            '5분 × 월령 (예: 3개월 = 15분)',
            '뼈와 관절이 아직 발달 중이므로 과도한 운동은 금지',
          ),
          _buildGuideItem('성견 (1-7세)', '견종별 권장량 준수', '산책 + 놀이 + 훈련을 적절히 배분'),
          _buildGuideItem(
            '시니어 (7세+)',
            '성견의 50-75%로 감소',
            '짧고 잦은 산책이 좋음. 관절에 무리가 가지 않도록 주의',
          ),
        ],
      ),
    );
  }

  Widget _buildDietSection() {
    final isSenior = (_profile?.ageYears ?? 0) >= (_breedInfo?.seniorAge ?? 7);

    return _buildSection(
      title: isSenior ? '시니어 식이 가이드' : '식이 가이드',
      icon: Icons.restaurant_menu,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSenior) ...[
            _buildGuideItem('단백질', '고품질 단백질 25% 이상', '근육량 유지를 위해 단백질 비중을 높이세요'),
            _buildGuideItem('칼로리', '성견 대비 20-30% 감소', '활동량 감소에 맞춰 비만을 방지하세요'),
            _buildGuideItem(
              '관절 보조제',
              '글루코사민 + 콘드로이틴',
              '관절 건강을 위해 수의사와 상담 후 추가',
            ),
            _buildGuideItem('오메가-3', 'EPA/DHA 보충', '인지 기능 유지와 염증 감소에 도움'),
          ] else ...[
            _buildGuideItem('급여 횟수', '성견 1일 2회', '규칙적인 식사 시간을 유지하세요'),
            _buildGuideItem(
              '적정 체중',
              _breedInfo?.weightKg != null
                  ? '${_breedInfo!.weightKg!.min.toInt()}-${_breedInfo!.weightKg!.max.toInt()} kg'
                  : '견종별 적정 체중 유지',
              '비만은 수명을 평균 2.5년 줄입니다 (AVMA)',
            ),
            _buildGuideItem(
              '금지 음식',
              '초콜릿, 포도, 양파, 마늘, 자일리톨',
              '사람 음식 중 독성이 있는 것에 주의',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDementiaPreventionSection() {
    return _buildSection(
      title: '치매 예방 활동',
      icon: Icons.psychology,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGuideItem(
            '노즈워크',
            '후각 자극 활동',
            '간식 숨기기, 노즈워크 매트 활용. 두뇌 활성화에 효과적',
          ),
          _buildGuideItem(
            '새로운 산책 경로',
            '주 1-2회 새 장소',
            '새로운 환경의 감각 자극이 인지 기능을 유지합니다',
          ),
          _buildGuideItem(
            '간단한 훈련',
            '하루 5-10분',
            '기존 명령 복습 + 새 트릭 학습. "사용하지 않으면 잃는다"',
          ),
          _buildGuideItem('사회적 상호작용', '다른 강아지/사람과의 교류', '사회화는 정신 건강에 매우 중요합니다'),
          _buildGuideItem('퍼즐 장난감', '인터랙티브 피더', '식사 시간에 퍼즐 피더를 사용하여 두뇌 자극'),
        ],
      ),
    );
  }

  // ─── Helpers ───

  Widget _buildSection({
    required String title,
    required IconData icon,
    String? subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppConfig.accentColor, size: 22),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: AppConfig.accentColor, fontSize: 12),
          ),
        ],
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildCheckItem(_CheckItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.frequency,
                      style: TextStyle(
                        color: AppConfig.accentColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  item.description,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(String title, String value, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(color: AppConfig.accentColor, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckItem {
  final String title;
  final String frequency;
  final String description;
  const _CheckItem(this.title, this.frequency, this.description);
}

class _VacSchedule {
  final String timing;
  final String name;
  final String description;
  const _VacSchedule(this.timing, this.name, this.description);
}
