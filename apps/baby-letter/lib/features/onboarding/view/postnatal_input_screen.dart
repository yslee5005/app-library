import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../shared/models/feeding_type.dart';

/// A5. 정보입력 — 출산 후
/// 3단계: 생년월일+조산 → 이름+성별 → 수유방식
/// Layer 1(연령) + Layer 2(수유방식) 즉시 완성 → 분산 37-70% 감소
class PostnatalInputScreen extends StatefulWidget {
  const PostnatalInputScreen({super.key});

  @override
  State<PostnatalInputScreen> createState() => _PostnatalInputScreenState();
}

class _PostnatalInputScreenState extends State<PostnatalInputScreen> {
  int _step = 0;
  DateTime? _birthDate;
  bool _isPremature = false;
  final _nameController = TextEditingController();
  BabyGender _gender = BabyGender.unspecified;
  FeedingType? _feedingType;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step == 0 && _birthDate == null) return;
    if (_step == 2 && _feedingType == null) return;
    if (_step < 2) {
      setState(() => _step++);
    } else {
      // TODO: 상태 저장 후 홈으로
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        leading: _step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _step--),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/welcome'),
              ),
        title: Text('Step ${_step + 1}/3'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_step + 1) / 3,
              minHeight: 4,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: switch (_step) {
                    0 => _buildBirthDateStep(),
                    1 => _buildNameStep(),
                    2 => _buildFeedingStep(),
                    _ => const SizedBox(),
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_step == 0 && _birthDate == null) ||
                          (_step == 2 && _feedingType == null)
                      ? null
                      : _nextStep,
                  child: Text(_step == 2 ? '시작하기' : '다음'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBirthDateStep() {
    return Column(
      key: const ValueKey('birth'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          '아기가 언제\n태어났나요?',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '정확한 발달 단계를 계산할게요',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _birthDate ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: AppColors.coral,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() => _birthDate = picked);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _birthDate != null
                    ? AppColors.coral
                    : AppColors.textHint.withValues(alpha: 0.3),
                width: _birthDate != null ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.cake_rounded,
                  color:
                      _birthDate != null ? AppColors.coral : AppColors.textHint,
                ),
                const SizedBox(width: 12),
                Text(
                  _birthDate != null
                      ? '${_birthDate!.year}년 ${_birthDate!.month}월 ${_birthDate!.day}일'
                      : '생년월일을 선택해주세요',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _birthDate != null
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_birthDate != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.coralLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'D+${DateTime.now().difference(_birthDate!).inDays}',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.coralDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        // 조산 여부
        GestureDetector(
          onTap: () => setState(() => _isPremature = !_isPremature),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isPremature
                  ? AppColors.amberLight
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isPremature
                    ? AppColors.amber
                    : AppColors.textHint.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isPremature
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color:
                      _isPremature ? AppColors.amber : AppColors.textHint,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '37주 이전에 태어났어요',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '교정 월령으로 발달 단계를 계산해드릴게요',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameStep() {
    return Column(
      key: const ValueKey('name'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          '아기 이름을\n알려주세요',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '편지에서 아기를 불러줄 이름이에요',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: '아기 이름',
            prefixIcon: Icon(Icons.child_care_rounded),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '성별',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: BabyGender.values.map((g) {
            final isSelected = _gender == g;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: g != BabyGender.values.last ? 8 : 0,
                ),
                child: GestureDetector(
                  onTap: () => setState(() => _gender = g),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.coralLight
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.coral
                            : AppColors.textHint.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        g.label,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.coral
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeedingStep() {
    return Column(
      key: const ValueKey('feeding'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          '수유 방식이\n어떻게 되나요?',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '아기 패턴을 더 정확하게 이해할 수 있어요',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '수유 방식에 따라 아기 패턴의 편차가 41-70% 줄어들어요',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: 32),
        ...FeedingType.values.map((type) {
          final isSelected = _feedingType == type;
          final icon = switch (type) {
            FeedingType.breastfeeding => '🤱',
            FeedingType.formula => '🍼',
            FeedingType.mixed => '🔄',
          };
          final desc = switch (type) {
            FeedingType.breastfeeding => '직접 수유 또는 유축',
            FeedingType.formula => '분유 수유',
            FeedingType.mixed => '모유 + 분유 병행',
          };
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => setState(() => _feedingType = type),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.coralLight
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.coral
                        : AppColors.textHint.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type.label,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? AppColors.coral
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            desc,
                            style:
                                Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.coral),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
