import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// D6. 발달 마일스톤 체크리스트 — CDC 기반, 따뜻한 톤
class MilestoneChecklistScreen extends StatefulWidget {
  const MilestoneChecklistScreen({super.key});

  @override
  State<MilestoneChecklistScreen> createState() =>
      _MilestoneChecklistScreenState();
}

class _MilestoneChecklistScreenState extends State<MilestoneChecklistScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Checklist state per period
  final Map<String, bool> _checkedItems = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          '발달 마일스톤',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.coral,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.coral,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: '0-3개월'),
            Tab(text: '3-6개월'),
            Tab(text: '6-9개월'),
            Tab(text: '9-12개월'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPeriodContent(_period0to3),
                _buildPeriodContent(_period3to6),
                _buildPeriodContent(_period6to9),
                _buildPeriodContent(_period9to12),
              ],
            ),
          ),
          // Bottom link
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.coral,
              ),
              child: const Text('📋 소아과용 리포트 →'),
            ),
          ),
          // Footer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Text(
              'ℹ️ CDC 기반 체크리스트. 발달은 범위이지 정확한 시점이 아닙니다.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textHint,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodContent(List<_MilestoneCategory> categories) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 20),
            // Category header
            Row(
              children: [
                Text(category.icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  category.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Checklist items
            ...category.items.map((item) => _buildChecklistItem(item)),
          ],
        );
      },
    );
  }

  Widget _buildChecklistItem(_MilestoneItem item) {
    final key = item.id;
    final isChecked = _checkedItems[key] ?? item.achieved;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        value: isChecked,
        onChanged: (v) {
          setState(() => _checkedItems[key] = v ?? false);
        },
        activeColor: AppColors.coral,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Text(
          item.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: isChecked ? FontWeight.w500 : FontWeight.w400,
              ),
        ),
        subtitle: isChecked
            ? Text(
                item.achievedDate ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                    ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.expectedRange != null)
                    Text(
                      '예상 시기: ${item.expectedRange}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textHint,
                          ),
                    ),
                  Text(
                    '아직이어도 괜찮아요 💛',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.amber,
                        ),
                  ),
                ],
              ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

// --- Data Models ---

class _MilestoneCategory {
  final String icon;
  final String title;
  final List<_MilestoneItem> items;

  const _MilestoneCategory({
    required this.icon,
    required this.title,
    required this.items,
  });
}

class _MilestoneItem {
  final String id;
  final String label;
  final bool achieved;
  final String? achievedDate;
  final String? expectedRange;

  const _MilestoneItem({
    required this.id,
    required this.label,
    this.achieved = false,
    this.achievedDate,
    this.expectedRange,
  });
}

// --- Demo Data ---

const _period0to3 = [
  _MilestoneCategory(
    icon: '🏃',
    title: '대근육',
    items: [
      _MilestoneItem(
        id: '0_3_gross_1',
        label: '엎드려 머리 들기',
        achieved: true,
        achievedDate: 'D+30 달성',
      ),
      _MilestoneItem(
        id: '0_3_gross_2',
        label: '고개 좌우 돌리기',
        achieved: true,
        achievedDate: 'D+38 달성',
      ),
      _MilestoneItem(
        id: '0_3_gross_3',
        label: '팔로 상체 들기',
        expectedRange: '2-4개월',
      ),
    ],
  ),
  _MilestoneCategory(
    icon: '🗣️',
    title: '언어/소통',
    items: [
      _MilestoneItem(
        id: '0_3_lang_1',
        label: '울음 외 소리내기 (쿠잉)',
        achieved: true,
        achievedDate: 'D+35 달성',
      ),
      _MilestoneItem(
        id: '0_3_lang_2',
        label: '사회적 미소',
        achieved: true,
        achievedDate: 'D+42 달성',
      ),
      _MilestoneItem(
        id: '0_3_lang_3',
        label: '옹알이 시작',
        expectedRange: '2-3개월',
      ),
    ],
  ),
  _MilestoneCategory(
    icon: '👁️',
    title: '인지/감각',
    items: [
      _MilestoneItem(
        id: '0_3_cog_1',
        label: '움직이는 물체 눈으로 추적',
        achieved: true,
        achievedDate: 'D+25 달성',
      ),
      _MilestoneItem(
        id: '0_3_cog_2',
        label: '소리 나는 쪽으로 고개 돌리기',
        achieved: true,
        achievedDate: 'D+38 달성',
      ),
      _MilestoneItem(
        id: '0_3_cog_3',
        label: '손 쳐다보기',
        expectedRange: '2-3개월',
      ),
    ],
  ),
];

const _period3to6 = [
  _MilestoneCategory(
    icon: '🏃',
    title: '대근육',
    items: [
      _MilestoneItem(
        id: '3_6_gross_1',
        label: '뒤집기',
        expectedRange: '4-6개월',
      ),
      _MilestoneItem(
        id: '3_6_gross_2',
        label: '도움 없이 앉기 시작',
        expectedRange: '5-6개월',
      ),
      _MilestoneItem(
        id: '3_6_gross_3',
        label: '체중 지지하며 서기',
        expectedRange: '5-6개월',
      ),
    ],
  ),
  _MilestoneCategory(
    icon: '🗣️',
    title: '언어/소통',
    items: [
      _MilestoneItem(
        id: '3_6_lang_1',
        label: '자음+모음 옹알이 (바바, 마마)',
        expectedRange: '4-6개월',
      ),
      _MilestoneItem(
        id: '3_6_lang_2',
        label: '이름에 반응',
        expectedRange: '5-6개월',
      ),
      _MilestoneItem(
        id: '3_6_lang_3',
        label: '감정 표현 (기쁨, 불만)',
        expectedRange: '4-6개월',
      ),
    ],
  ),
  _MilestoneCategory(
    icon: '👁️',
    title: '인지/감각',
    items: [
      _MilestoneItem(
        id: '3_6_cog_1',
        label: '물건 잡아서 입에 넣기',
        expectedRange: '3-5개월',
      ),
      _MilestoneItem(
        id: '3_6_cog_2',
        label: '거울 속 자기 얼굴에 관심',
        expectedRange: '4-6개월',
      ),
      _MilestoneItem(
        id: '3_6_cog_3',
        label: '장난감 양손 간 옮기기',
        expectedRange: '5-6개월',
      ),
    ],
  ),
];

const _period6to9 = [
  _MilestoneCategory(
    icon: '🏃',
    title: '대근육',
    items: [
      _MilestoneItem(
        id: '6_9_gross_1',
        label: '혼자 앉기',
        expectedRange: '6-8개월',
      ),
      _MilestoneItem(
        id: '6_9_gross_2',
        label: '배밀이/기기 시작',
        expectedRange: '7-9개월',
      ),
      _MilestoneItem(
        id: '6_9_gross_3',
        label: '잡고 일어서기',
        expectedRange: '8-9개월',
      ),
    ],
  ),
  _MilestoneCategory(
    icon: '🗣️',
    title: '언어/소통',
    items: [
      _MilestoneItem(
        id: '6_9_lang_1',
        label: '다양한 옹알이 소리',
        expectedRange: '6-8개월',
      ),
      _MilestoneItem(
        id: '6_9_lang_2',
        label: '"안돼" 이해하기',
        expectedRange: '7-9개월',
      ),
      _MilestoneItem(
        id: '6_9_lang_3',
        label: '손가락으로 가리키기',
        expectedRange: '8-9개월',
      ),
    ],
  ),
  _MilestoneCategory(
    icon: '👁️',
    title: '인지/감각',
    items: [
      _MilestoneItem(
        id: '6_9_cog_1',
        label: '까꿍 놀이 이해',
        expectedRange: '6-8개월',
      ),
      _MilestoneItem(
        id: '6_9_cog_2',
        label: '낯가림 시작',
        expectedRange: '7-9개월',
      ),
      _MilestoneItem(
        id: '6_9_cog_3',
        label: '물건 영속성 이해 시작',
        expectedRange: '8-9개월',
      ),
    ],
  ),
];

const _period9to12 = [
  _MilestoneCategory(
    icon: '🏃',
    title: '대근육',
    items: [
      _MilestoneItem(
        id: '9_12_gross_1',
        label: '잡고 걷기 (전이 보행)',
        expectedRange: '9-11개월',
      ),
      _MilestoneItem(
        id: '9_12_gross_2',
        label: '혼자 서기',
        expectedRange: '10-12개월',
      ),
      _MilestoneItem(
        id: '9_12_gross_3',
        label: '첫 걸음',
        expectedRange: '11-14개월',
      ),
    ],
  ),
  _MilestoneCategory(
    icon: '🗣️',
    title: '언어/소통',
    items: [
      _MilestoneItem(
        id: '9_12_lang_1',
        label: '첫 단어 (엄마, 아빠)',
        expectedRange: '10-14개월',
      ),
      _MilestoneItem(
        id: '9_12_lang_2',
        label: '간단한 지시 이해',
        expectedRange: '9-12개월',
      ),
      _MilestoneItem(
        id: '9_12_lang_3',
        label: '제스처로 소통 (손 흔들기)',
        expectedRange: '9-12개월',
      ),
    ],
  ),
  _MilestoneCategory(
    icon: '👁️',
    title: '인지/감각',
    items: [
      _MilestoneItem(
        id: '9_12_cog_1',
        label: '엄지와 검지로 집기 (핀서 그립)',
        expectedRange: '9-12개월',
      ),
      _MilestoneItem(
        id: '9_12_cog_2',
        label: '용도에 맞게 물건 사용',
        expectedRange: '10-12개월',
      ),
      _MilestoneItem(
        id: '9_12_cog_3',
        label: '간단한 인과관계 이해',
        expectedRange: '10-12개월',
      ),
    ],
  ),
];
