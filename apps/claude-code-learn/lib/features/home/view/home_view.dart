import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/content_catalog.dart';
import '../../../models/content_item.dart';
import '../../../models/reading_progress.dart';
import '../../../providers/providers.dart';
import '../../../theme/learn_theme.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(allProgressProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Claude Code Learn', style: LearnTypography.h1),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '한국어 코스'),
            Tab(text: 'English Docs'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Overall progress ring
          progressAsync.when(
            data: (progressList) => _ProgressHeader(
              progressList: progressList,
              colorScheme: colorScheme,
            ),
            loading: () => const SizedBox(height: 80),
            error: (_, __) => const SizedBox(height: 80),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _KoreanTab(progressList: progressAsync.value ?? []),
                _EnglishTab(progressList: progressAsync.value ?? []),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Progress header
// ---------------------------------------------------------------------------

class _ProgressHeader extends StatelessWidget {
  final List<ReadingProgress> progressList;
  final ColorScheme colorScheme;

  const _ProgressHeader({
    required this.progressList,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final total = ContentCatalog.items.length;
    final completed = progressList.where((p) => p.isCompleted).length;
    final ratio = total > 0 ? completed / total : 0.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: ratio,
                  strokeWidth: 5,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: LearnColors.progressGreen,
                ),
                Center(
                  child: Text(
                    '${(ratio * 100).toInt()}%',
                    style: LearnTypography.label,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Overall Progress', style: LearnTypography.h2),
                Text(
                  '$completed / $total articles completed',
                  style: LearnTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Korean tab
// ---------------------------------------------------------------------------

class _KoreanTab extends StatelessWidget {
  final List<ReadingProgress> progressList;

  const _KoreanTab({required this.progressList});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        _SectionCard(
          title: '한국어 코스',
          subtitle: 'Claude Code 완전 정복 6강',
          icon: Icons.school,
          sectionId: ContentSection.koreanCourse.name,
          itemCount: ContentCatalog.bySection(
            ContentSection.koreanCourse,
          ).length,
          completedCount: _completedIn(ContentSection.koreanCourse),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: '에이전틱 루프 상세',
          subtitle: '심화 학습 5편',
          icon: Icons.loop,
          sectionId: ContentSection.agenticLoop.name,
          itemCount: ContentCatalog.bySection(
            ContentSection.agenticLoop,
          ).length,
          completedCount: _completedIn(ContentSection.agenticLoop),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: 'Deep Dive 분석',
          subtitle: '소스코드 기반 심층 분석 8편',
          icon: Icons.code,
          sectionId: ContentSection.deepDive.name,
          itemCount: ContentCatalog.bySection(ContentSection.deepDive).length,
          completedCount: _completedIn(ContentSection.deepDive),
        ),
      ],
    );
  }

  int _completedIn(ContentSection section) {
    final ids = ContentCatalog.bySection(section).map((e) => e.id).toSet();
    return progressList
        .where((p) => p.isCompleted && ids.contains(p.contentId))
        .length;
  }
}

// ---------------------------------------------------------------------------
// English tab
// ---------------------------------------------------------------------------

class _EnglishTab extends StatelessWidget {
  final List<ReadingProgress> progressList;

  const _EnglishTab({required this.progressList});

  @override
  Widget build(BuildContext context) {
    final sections = [
      (ContentSection.gettingStarted, 'Getting Started', Icons.rocket_launch),
      (ContentSection.concepts, 'Concepts', Icons.lightbulb_outline),
      (ContentSection.configuration, 'Configuration', Icons.settings),
      (ContentSection.guides, 'Guides', Icons.menu_book),
      (ContentSection.referenceCommands, 'Reference: Commands', Icons.terminal),
      (
        ContentSection.referenceSdk,
        'Reference: SDK',
        Icons.integration_instructions,
      ),
      (ContentSection.referenceTools, 'Reference: Tools', Icons.build),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: sections.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final (section, title, icon) = sections[index];
        final items = ContentCatalog.bySection(section);
        final ids = items.map((e) => e.id).toSet();
        final completed = progressList
            .where((p) => p.isCompleted && ids.contains(p.contentId))
            .length;

        return _SectionCard(
          title: title,
          subtitle: '${items.length} articles',
          icon: icon,
          sectionId: section.name,
          itemCount: items.length,
          completedCount: completed,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Section card
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String sectionId;
  final int itemCount;
  final int completedCount;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.sectionId,
    required this.itemCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ratio = itemCount > 0 ? completedCount / itemCount : 0.0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/chapter/$sectionId'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: LearnTypography.h2),
                    const SizedBox(height: 4),
                    Text(subtitle, style: LearnTypography.caption),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: ratio,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      color: LearnColors.progressGreen,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text('$completedCount/$itemCount', style: LearnTypography.label),
            ],
          ),
        ),
      ),
    );
  }
}
