import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// D7. 소아과 리포트 — 기간별 요약 + PDF/공유
class DoctorReportScreen extends StatefulWidget {
  const DoctorReportScreen({super.key});

  @override
  State<DoctorReportScreen> createState() => _DoctorReportScreenState();
}

class _DoctorReportScreenState extends State<DoctorReportScreen> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.coral,
              onPrimary: Colors.white,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '소아과 리포트',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: Column(
        children: [
          // Period selector
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: GestureDetector(
              onTap: _pickDateRange,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textHint.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 18, color: AppColors.coral),
                    const SizedBox(width: 10),
                    Text(
                      '${_formatDate(_dateRange.start)} ~ ${_formatDate(_dateRange.end)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 20, color: AppColors.textHint),
                  ],
                ),
              ),
            ),
          ),

          // Report sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // 수유 요약
                _ReportCard(
                  icon: '🍼',
                  title: '수유 요약',
                  items: const [
                    _ReportItem(label: '일평균 횟수', value: '8회'),
                    _ReportItem(label: '일평균 총량', value: '약 600ml'),
                    _ReportItem(label: '패턴 변화', value: '야간 수유 1회 감소'),
                  ],
                ),
                const SizedBox(height: 12),

                // 수면 요약
                _ReportCard(
                  icon: '😴',
                  title: '수면 요약',
                  items: const [
                    _ReportItem(label: '일평균 시간', value: '14.2시간'),
                    _ReportItem(label: '낮잠/밤잠 비율', value: '25% / 75%'),
                    _ReportItem(label: '최장 연속 수면', value: '5시간 30분'),
                  ],
                ),
                const SizedBox(height: 12),

                // 배변 요약
                _ReportCard(
                  icon: '💩',
                  title: '배변 요약',
                  items: const [
                    _ReportItem(label: '일평균 횟수', value: '4회'),
                    _ReportItem(label: '주요 색상', value: '노란색'),
                    _ReportItem(label: '이상 기록', value: '없음'),
                  ],
                ),
                const SizedBox(height: 12),

                // 성장 기록
                _ReportCard(
                  icon: '📏',
                  title: '성장 기록',
                  items: const [
                    _ReportItem(label: '키', value: '55.2cm'),
                    _ReportItem(label: '몸무게', value: '4.8kg'),
                  ],
                ),
                const SizedBox(height: 12),

                // 마일스톤 달성
                _ReportCard(
                  icon: '⭐',
                  title: '마일스톤 달성',
                  items: const [
                    _ReportItem(
                        label: '사회적 미소', value: 'D+42 달성'),
                    _ReportItem(
                        label: '고개 돌리기', value: 'D+38 달성'),
                    _ReportItem(label: '쿠잉 소리', value: 'D+35 달성'),
                  ],
                ),
                const SizedBox(height: 12),

                // 특이사항
                _ReportCard(
                  icon: '📝',
                  title: '특이사항',
                  items: const [
                    _ReportItem(
                      label: '메모',
                      value: '수유 후 게워냄 1회 (D+43). 이후 정상.',
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.cream,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Text('📄', style: TextStyle(fontSize: 16)),
                    label: const Text('PDF 내보내기'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.textHint),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Text('📤', style: TextStyle(fontSize: 16)),
                    label: const Text('공유하기'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.coral,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String icon;
  final String title;
  final List<_ReportItem> items;

  const _ReportCard({
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.cream),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      item.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportItem {
  final String label;
  final String value;

  const _ReportItem({required this.label, required this.value});
}
