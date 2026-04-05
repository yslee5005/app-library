import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_config.dart';
import '../../../models/daily_routine.dart';
import '../../../models/pet_profile.dart';
import '../../../services/breed_data_service.dart';
import '../../../services/pet_storage_service.dart';
import '../../../models/breed_info.dart';
import '../../../widgets/glass_card.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Step 1: Pet info
  final _nameController = TextEditingController();
  final _breedSearchController = TextEditingController();
  final _weightController = TextEditingController();
  BreedInfo? _selectedBreed;
  DateTime? _birthDate;
  bool _showBreedResults = false;

  // Step 2: Routines
  final Set<String> _selectedRoutineIds = {
    'walk_am',
    'walk_pm',
    'meal_am',
    'meal_pm',
  };

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _breedSearchController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (_selectedBreed == null || _birthDate == null) return;

    final weight = double.tryParse(_weightController.text) ?? 10.0;
    final allRoutines = [...DailyRoutine.defaults, ...DailyRoutine.optionals];
    final selectedRoutines = allRoutines
        .where((r) => _selectedRoutineIds.contains(r.id))
        .toList();

    final profile = PetProfile(
      name: _nameController.text.trim(),
      breedId: _selectedBreed!.id,
      birthDate: _birthDate!,
      weightKg: weight,
      routines: selectedRoutines,
      createdAt: DateTime.now(),
    );

    final storage = PetStorageService();
    await storage.saveProfile(profile);
    await storage.setOnboardingComplete(true);

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(3, (i) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: i <= _currentPage
                            ? AppConfig.accentColor
                            : Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                children: [
                  _buildStep1PetInfo(),
                  _buildStep2Routines(),
                  _buildStep3Summary(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step 1: Pet Info ───
  Widget _buildStep1PetInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            '반려견 정보',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '함께하는 가족을 알려주세요',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Name
          Text('이름', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: '반려견 이름'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 24),

          // Breed search
          Text('견종', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _breedSearchController,
            decoration: InputDecoration(
              hintText: '견종 검색 (예: 골든 리트리버)',
              suffixIcon: _selectedBreed != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        setState(() {
                          _selectedBreed = null;
                          _breedSearchController.clear();
                          _showBreedResults = false;
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (v) {
              setState(() => _showBreedResults = v.isNotEmpty);
            },
          ),
          if (_showBreedResults && _selectedBreed == null)
            _buildBreedSearchResults(),
          if (_selectedBreed != null) _buildBreedInfoCard(),
          const SizedBox(height: 24),

          // Birth date
          Text('생년월일', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate:
                    _birthDate ?? DateTime.now().subtract(const Duration(days: 365)),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: AppConfig.accentColor,
                        surface: AppConfig.backgroundColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                setState(() => _birthDate = date);
              }
            },
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: AppConfig.accentColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  _birthDate != null
                      ? '${_birthDate!.year}년 ${_birthDate!.month}월 ${_birthDate!.day}일'
                      : '날짜 선택',
                  style: TextStyle(
                    color: _birthDate != null ? Colors.white : Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Weight
          Text('체중 (kg)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _weightController,
            decoration: InputDecoration(
              hintText: '현재 체중',
              suffixText: 'kg',
              helperText: _selectedBreed?.weightKg != null
                  ? '적정 범위: ${_selectedBreed!.weightKg!.min.toInt()}-${_selectedBreed!.weightKg!.max.toInt()} kg'
                  : null,
              helperStyle: TextStyle(color: AppConfig.accentColor),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 40),

          // Next button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canProceedStep1() ? _nextPage : null,
              child: const Text('다음'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  bool _canProceedStep1() {
    return _nameController.text.trim().isNotEmpty &&
        _selectedBreed != null &&
        _birthDate != null;
  }

  Widget _buildBreedSearchResults() {
    final results =
        BreedDataService().searchBreeds(_breedSearchController.text);
    final displayResults = results.take(10).toList();

    return Container(
      margin: const EdgeInsets.only(top: 4),
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: displayResults.length,
        itemBuilder: (context, index) {
          final breed = displayResults[index];
          return ListTile(
            dense: true,
            title: Text(breed.nameKo,
                style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              '${breed.name} · ${breed.size} · 수명 ${breed.lifespanYears.median.toStringAsFixed(0)}년',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            onTap: () {
              setState(() {
                _selectedBreed = breed;
                _breedSearchController.text = breed.nameKo;
                _showBreedResults = false;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildBreedInfoCard() {
    final breed = _selectedBreed!;
    return GlassCard(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pets, color: AppConfig.accentColor, size: 20),
              const SizedBox(width: 8),
              Text(breed.nameKo,
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 8),
          _infoRow('크기', breed.size),
          _infoRow('평균 수명', '${breed.lifespanYears.median.toStringAsFixed(0)}년'),
          if (breed.exerciseMinutesPerDay != null)
            _infoRow(
              '운동 권장',
              '${breed.exerciseMinutesPerDay!.min.toInt()}-${breed.exerciseMinutesPerDay!.max.toInt()}분/일',
            ),
          if (breed.dataConfidence == 'limited' ||
              breed.dataConfidence == 'moderate')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                breed.dataNote ?? '데이터가 제한적입니다.',
                style: TextStyle(
                  color: Colors.amber.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ),
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }

  // ─── Step 2: Routines ───
  Widget _buildStep2Routines() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            '데일리 루틴',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '매일 챙길 루틴을 선택하세요',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          Text('기본 추천',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...DailyRoutine.defaults.map(_buildRoutineToggle),

          const SizedBox(height: 24),
          Text('선택 루틴',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...DailyRoutine.optionals.map(_buildRoutineToggle),

          // Breed-based recommendation
          if (_selectedBreed?.exerciseMinutesPerDay != null) ...[
            const SizedBox(height: 24),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: AppConfig.accentColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${_selectedBreed!.nameKo}는 하루 '
                      '${_selectedBreed!.exerciseMinutesPerDay!.min.toInt()}-'
                      '${_selectedBreed!.exerciseMinutesPerDay!.max.toInt()}분 '
                      '산책을 권장해요',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevPage,
                  child: const Text('이전'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed:
                      _selectedRoutineIds.isNotEmpty ? _nextPage : null,
                  child: const Text('다음'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildRoutineToggle(DailyRoutine routine) {
    final selected = _selectedRoutineIds.contains(routine.id);
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: () {
        setState(() {
          if (selected) {
            _selectedRoutineIds.remove(routine.id);
          } else {
            _selectedRoutineIds.add(routine.id);
          }
        });
      },
      child: Row(
        children: [
          Icon(routine.icon,
              color: selected ? AppConfig.accentColor : Colors.white38,
              size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              routine.name,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white54,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? AppConfig.accentColor
                  : Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: selected
                    ? AppConfig.accentColor
                    : Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: selected
                ? const Icon(Icons.check, size: 16, color: Colors.black)
                : null,
          ),
        ],
      ),
    );
  }

  // ─── Step 3: Summary ───
  Widget _buildStep3Summary() {
    final allRoutines = [...DailyRoutine.defaults, ...DailyRoutine.optionals];
    final selectedRoutines = allRoutines
        .where((r) => _selectedRoutineIds.contains(r.id))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            '준비 완료!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '정보를 확인하고 시작하세요',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Dog placeholder
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppConfig.accentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(Icons.pets,
                  size: 48, color: AppConfig.accentColor),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _nameController.text.trim().isNotEmpty
                  ? _nameController.text.trim()
                  : '반려견',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 24),

          // Info summary
          GlassCard(
            child: Column(
              children: [
                _summaryRow('견종', _selectedBreed?.nameKo ?? '-'),
                const Divider(height: 24),
                _summaryRow(
                  '생년월일',
                  _birthDate != null
                      ? '${_birthDate!.year}.${_birthDate!.month}.${_birthDate!.day}'
                      : '-',
                ),
                const Divider(height: 24),
                _summaryRow('체중', '${_weightController.text} kg'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Routines summary
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('데일리 루틴 (${selectedRoutines.length}개)',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedRoutines.map((r) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppConfig.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(r.icon,
                              size: 16, color: AppConfig.accentColor),
                          const SizedBox(width: 4),
                          Text(r.name,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.white)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevPage,
                  child: const Text('이전'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _completeOnboarding,
                  child: const Text('시작하기 🐾'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54)),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
