import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// D1. 성장탭 메인 — 임신 중 타임라인 기본
class GrowthScreen extends StatelessWidget {
  const GrowthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: UserState에서 모드 분기
    return _PregnancyTimelineView();
  }
}

class _PregnancyTimelineView extends StatelessWidget {
  // 타임라인 노드 데이터
  static const _nodes = [
    _TimelineNode('Stage 1', '수정', '0.1mm', true),
    _TimelineNode('Stage 9', '심장 형성', '2mm', true),
    _TimelineNode('Stage 14', '팔다리 형성', '7mm', true),
    _TimelineNode('Stage 23', '사람 형태 완성', '30mm', true),
    _TimelineNode('Week 9', '손가락 분리', '3cm', true),
    _TimelineNode('Week 12', '하품 반사', '6cm', true),
    _TimelineNode('Week 16', '빛 반응', '16cm', true),
    _TimelineNode('Week 20', '청각 발달', '25cm', true),
    _TimelineNode('Week 24', '눈꺼풀 열림', '30cm', true, isCurrent: true),
    _TimelineNode('Week 28', '순목반사', '35cm', false),
    _TimelineNode('Week 32', '두위 전환', '42cm', false),
    _TimelineNode('Week 36', '폐 성숙', '47cm', false),
    _TimelineNode('Week 40', '출산!', '50cm', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '성장',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🤰 임신 24주 3일',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 타임라인
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final node = _nodes[index];
                return _TimelineItem(
                  node: node,
                  isFirst: index == 0,
                  isLast: index == _nodes.length - 1,
                );
              }, childCount: _nodes.length),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _TimelineNode {
  final String label;
  final String milestone;
  final String size;
  final bool isPast;
  final bool isCurrent;

  const _TimelineNode(
    this.label,
    this.milestone,
    this.size,
    this.isPast, {
    this.isCurrent = false,
  });
}

class _TimelineItem extends StatelessWidget {
  final _TimelineNode node;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.node,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = node.isCurrent
        ? AppColors.coral
        : node.isPast
        ? AppColors.amber
        : AppColors.textHint.withValues(alpha: 0.3);
    final lineColor = node.isPast
        ? AppColors.amber.withValues(alpha: 0.5)
        : AppColors.textHint.withValues(alpha: 0.15);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타임라인 선 + 노드
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  if (!isFirst)
                    Container(width: 2, height: 8, color: lineColor),
                  Container(
                    width: node.isCurrent ? 20 : 14,
                    height: node.isCurrent ? 20 : 14,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                      border: node.isCurrent
                          ? Border.all(color: AppColors.coralLight, width: 3)
                          : null,
                    ),
                    child: node.isPast && !node.isCurrent
                        ? null
                        : node.isCurrent
                        ? null
                        : Icon(
                            Icons.lock_rounded,
                            size: 8,
                            color: AppColors.textHint,
                          ),
                  ),
                  if (!isLast)
                    Expanded(child: Container(width: 2, color: lineColor)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 카드
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: node.isCurrent
                      ? AppColors.coralLight.withValues(alpha: 0.5)
                      : node.isPast
                      ? AppColors.surface
                      : AppColors.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: node.isCurrent
                      ? Border.all(color: AppColors.coral, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            node.label,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: node.isPast || node.isCurrent
                                      ? AppColors.textPrimary
                                      : AppColors.textHint,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${node.milestone} · ${node.size}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: node.isPast || node.isCurrent
                                      ? AppColors.textSecondary
                                      : AppColors.textHint,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (node.isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.coral,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '현재',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    if (node.isPast && !node.isCurrent)
                      const Icon(
                        Icons.play_circle_outline_rounded,
                        color: AppColors.amber,
                        size: 24,
                      ),
                    if (!node.isPast && !node.isCurrent)
                      const Icon(
                        Icons.lock_rounded,
                        color: AppColors.textHint,
                        size: 18,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
