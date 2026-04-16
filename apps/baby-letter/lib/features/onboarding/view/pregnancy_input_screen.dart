import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';

/// A4. 정보입력 — 임신 중
/// 3단계: 출산예정일 + 태명(선택) + 파트너초대(선택)
class PregnancyInputScreen extends StatefulWidget {
  const PregnancyInputScreen({super.key});

  @override
  State<PregnancyInputScreen> createState() => _PregnancyInputScreenState();
}

class _PregnancyInputScreenState extends State<PregnancyInputScreen> {
  int _step = 0;
  DateTime? _dueDate;
  final _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step == 0 && _dueDate == null) return;
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
            // 진행바
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
                    0 => _buildDueDateStep(),
                    1 => _buildNicknameStep(),
                    2 => _buildPartnerStep(),
                    _ => const SizedBox(),
                  },
                ),
              ),
            ),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_step == 0 && _dueDate == null)
                          ? null
                          : _nextStep,
                      child: Text(_step == 2 ? '시작하기' : '다음'),
                    ),
                  ),
                  if (_step > 0) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _nextStep,
                      child: Text(
                        '나중에 할게요',
                        style: TextStyle(color: AppColors.textHint),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDueDateStep() {
    return Column(
      key: const ValueKey('due_date'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          '출산 예정일이\n언제인가요?',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '아기의 성장 단계를 알려드릴게요',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        // 날짜 선택 카드
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _dueDate ??
                  DateTime.now().add(const Duration(days: 140)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 300)),
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
              setState(() => _dueDate = picked);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _dueDate != null
                    ? AppColors.coral
                    : AppColors.textHint.withValues(alpha: 0.3),
                width: _dueDate != null ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: _dueDate != null ? AppColors.coral : AppColors.textHint,
                ),
                const SizedBox(width: 12),
                Text(
                  _dueDate != null
                      ? '${_dueDate!.year}년 ${_dueDate!.month}월 ${_dueDate!.day}일'
                      : '날짜를 선택해주세요',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _dueDate != null
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_dueDate != null) ...[
          const SizedBox(height: 16),
          _InfoChip(
            icon: Icons.child_care_rounded,
            text: '현재 약 ${_calculateWeek()}주차예요',
          ),
        ],
      ],
    );
  }

  int _calculateWeek() {
    if (_dueDate == null) return 0;
    final conception = _dueDate!.subtract(const Duration(days: 280));
    return DateTime.now().difference(conception).inDays ~/ 7;
  }

  Widget _buildNicknameStep() {
    return Column(
      key: const ValueKey('nickname'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          '아기의 태명이\n있나요?',
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
          controller: _nicknameController,
          decoration: InputDecoration(
            hintText: '태명이 없으면 "콩순이"라고 부를게요 💛',
            prefixIcon: const Icon(Icons.edit_rounded),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _nextStep(),
        ),
      ],
    );
  }

  Widget _buildPartnerStep() {
    return Column(
      key: const ValueKey('partner'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          '파트너를\n초대할까요?',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '함께 기록하면 삼각형 케어가 완성돼요',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        // 삼각형 비주얼
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text('👶', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('👩', style: TextStyle(fontSize: 32)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '💛',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const Text('👨', style: TextStyle(fontSize: 32)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '아기 — 엄마 — 아빠\n삼각형 케어 모델',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: 초대코드 생성 + 공유
            },
            icon: const Icon(Icons.share_rounded),
            label: const Text('초대 링크 보내기'),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.coralLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.coral),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.coralDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
