import '../models/content_item.dart';

/// Static catalog of all available content items.
///
/// Each entry maps to an actual markdown file under `assets/content/`.
class ContentCatalog {
  ContentCatalog._();

  static const List<ContentItem> items = [
    // ---------------------------------------------------------------
    // Korean Course (guide/)
    // ---------------------------------------------------------------
    ContentItem(
      id: 'ko-00',
      title: '코스 소개',
      section: ContentSection.koreanCourse,
      language: Language.ko,
      assetPath: 'guide/00-코스-소개.md',
      order: 0,
    ),
    ContentItem(
      id: 'ko-01',
      title: '에이전틱 루프 이해하기',
      section: ContentSection.koreanCourse,
      language: Language.ko,
      assetPath: 'guide/01-에이전틱-루프-이해하기.md',
      order: 1,
    ),
    ContentItem(
      id: 'ko-02',
      title: '메모리와 컨텍스트',
      section: ContentSection.koreanCourse,
      language: Language.ko,
      assetPath: 'guide/02-메모리와-컨텍스트.md',
      order: 2,
    ),
    ContentItem(
      id: 'ko-03',
      title: '훅, 스킬, 권한 시스템',
      section: ContentSection.koreanCourse,
      language: Language.ko,
      assetPath: 'guide/03-훅-스킬-권한-시스템.md',
      order: 3,
    ),
    ContentItem(
      id: 'ko-04',
      title: 'CLI와 도구 마스터하기',
      section: ContentSection.koreanCourse,
      language: Language.ko,
      assetPath: 'guide/04-CLI와-도구-마스터하기.md',
      order: 4,
    ),
    ContentItem(
      id: 'ko-05',
      title: '실전 활용과 베스트 프랙티스',
      section: ContentSection.koreanCourse,
      language: Language.ko,
      assetPath: 'guide/05-실전-활용과-베스트-프랙티스.md',
      order: 5,
    ),

    // ---------------------------------------------------------------
    // Agentic Loop sub-chapters (guide/에이전틱-루프/)
    // ---------------------------------------------------------------
    ContentItem(
      id: 'ko-agentic-01',
      title: '루프 전체 흐름',
      section: ContentSection.agenticLoop,
      language: Language.ko,
      assetPath: 'guide/에이전틱-루프/01-루프-전체-흐름.md',
      order: 0,
      parentId: 'ko-01',
    ),
    ContentItem(
      id: 'ko-agentic-02',
      title: '도구 시스템 패턴',
      section: ContentSection.agenticLoop,
      language: Language.ko,
      assetPath: 'guide/에이전틱-루프/02-도구-시스템-패턴.md',
      order: 1,
      parentId: 'ko-01',
    ),
    ContentItem(
      id: 'ko-agentic-03',
      title: '권한 파이프라인',
      section: ContentSection.agenticLoop,
      language: Language.ko,
      assetPath: 'guide/에이전틱-루프/03-권한-파이프라인.md',
      order: 2,
      parentId: 'ko-01',
    ),
    ContentItem(
      id: 'ko-agentic-04',
      title: '컨텍스트 압축',
      section: ContentSection.agenticLoop,
      language: Language.ko,
      assetPath: 'guide/에이전틱-루프/04-컨텍스트-압축.md',
      order: 3,
      parentId: 'ko-01',
    ),
    ContentItem(
      id: 'ko-agentic-05',
      title: '서브에이전트 실행모델',
      section: ContentSection.agenticLoop,
      language: Language.ko,
      assetPath: 'guide/에이전틱-루프/05-서브에이전트-실행모델.md',
      order: 4,
      parentId: 'ko-01',
    ),

    // ---------------------------------------------------------------
    // Deep Dive (deep-dive/)
    // ---------------------------------------------------------------
    ContentItem(
      id: 'dd-01',
      title: 'Agentic Loop',
      section: ContentSection.deepDive,
      language: Language.ko,
      assetPath: 'deep-dive/01-agentic-loop.md',
      order: 0,
    ),
    ContentItem(
      id: 'dd-02',
      title: 'Memory & Context',
      section: ContentSection.deepDive,
      language: Language.ko,
      assetPath: 'deep-dive/02-memory-context.md',
      order: 1,
    ),
    ContentItem(
      id: 'dd-03',
      title: 'Hooks, Skills & Permissions',
      section: ContentSection.deepDive,
      language: Language.ko,
      assetPath: 'deep-dive/03-hooks-skills-permissions.md',
      order: 2,
    ),
    ContentItem(
      id: 'dd-04',
      title: 'CLI Commands & Tools',
      section: ContentSection.deepDive,
      language: Language.ko,
      assetPath: 'deep-dive/04-cli-commands-tools.md',
      order: 3,
    ),
    ContentItem(
      id: 'dd-05',
      title: 'Source Catalog',
      section: ContentSection.deepDive,
      language: Language.ko,
      assetPath: 'deep-dive/05-source-catalog.md',
      order: 4,
    ),
    ContentItem(
      id: 'dd-06',
      title: 'Hidden Features',
      section: ContentSection.deepDive,
      language: Language.ko,
      assetPath: 'deep-dive/06-hidden-features.md',
      order: 5,
    ),
    ContentItem(
      id: 'dd-07',
      title: 'Anti-Distillation & Security',
      section: ContentSection.deepDive,
      language: Language.ko,
      assetPath: 'deep-dive/07-anti-distillation-security.md',
      order: 6,
    ),
    ContentItem(
      id: 'dd-08',
      title: 'Leak Timeline & Impact',
      section: ContentSection.deepDive,
      language: Language.ko,
      assetPath: 'deep-dive/08-leak-timeline-impact.md',
      order: 7,
    ),

    // ---------------------------------------------------------------
    // Getting Started (getting-started/)
    // ---------------------------------------------------------------
    ContentItem(
      id: 'gs-intro',
      title: 'Introduction',
      section: ContentSection.gettingStarted,
      language: Language.en,
      assetPath: 'getting-started/introduction.md',
      order: 0,
    ),
    ContentItem(
      id: 'gs-install',
      title: 'Installation',
      section: ContentSection.gettingStarted,
      language: Language.en,
      assetPath: 'getting-started/installation.md',
      order: 1,
    ),
    ContentItem(
      id: 'gs-quick',
      title: 'Quickstart',
      section: ContentSection.gettingStarted,
      language: Language.en,
      assetPath: 'getting-started/quickstart.md',
      order: 2,
    ),

    // ---------------------------------------------------------------
    // Concepts (concepts/)
    // ---------------------------------------------------------------
    ContentItem(
      id: 'co-how',
      title: 'How It Works',
      section: ContentSection.concepts,
      language: Language.en,
      assetPath: 'concepts/how-it-works.md',
      order: 0,
    ),
    ContentItem(
      id: 'co-memory',
      title: 'Memory & Context',
      section: ContentSection.concepts,
      language: Language.en,
      assetPath: 'concepts/memory-context.md',
      order: 1,
    ),
    ContentItem(
      id: 'co-perm',
      title: 'Permissions',
      section: ContentSection.concepts,
      language: Language.en,
      assetPath: 'concepts/permissions.md',
      order: 2,
    ),
    ContentItem(
      id: 'co-tools',
      title: 'Tools',
      section: ContentSection.concepts,
      language: Language.en,
      assetPath: 'concepts/tools.md',
      order: 3,
    ),

    // ---------------------------------------------------------------
    // Configuration (configuration/)
    // ---------------------------------------------------------------
    ContentItem(
      id: 'cfg-claudemd',
      title: 'CLAUDE.md',
      section: ContentSection.configuration,
      language: Language.en,
      assetPath: 'configuration/claudemd.md',
      order: 0,
    ),
    ContentItem(
      id: 'cfg-env',
      title: 'Environment Variables',
      section: ContentSection.configuration,
      language: Language.en,
      assetPath: 'configuration/environment-variables.md',
      order: 1,
    ),
    ContentItem(
      id: 'cfg-settings',
      title: 'Settings',
      section: ContentSection.configuration,
      language: Language.en,
      assetPath: 'configuration/settings.md',
      order: 2,
    ),

    // ---------------------------------------------------------------
    // Guides (guides/)
    // ---------------------------------------------------------------
    ContentItem(
      id: 'gd-auth',
      title: 'Authentication',
      section: ContentSection.guides,
      language: Language.en,
      assetPath: 'guides/authentication.md',
      order: 0,
    ),
    ContentItem(
      id: 'gd-hooks',
      title: 'Hooks',
      section: ContentSection.guides,
      language: Language.en,
      assetPath: 'guides/hooks.md',
      order: 1,
    ),
    ContentItem(
      id: 'gd-mcp',
      title: 'MCP Servers',
      section: ContentSection.guides,
      language: Language.en,
      assetPath: 'guides/mcp-servers.md',
      order: 2,
    ),
    ContentItem(
      id: 'gd-multi',
      title: 'Multi-Agent',
      section: ContentSection.guides,
      language: Language.en,
      assetPath: 'guides/multi-agent.md',
      order: 3,
    ),
    ContentItem(
      id: 'gd-skills',
      title: 'Skills',
      section: ContentSection.guides,
      language: Language.en,
      assetPath: 'guides/skills.md',
      order: 4,
    ),

    // ---------------------------------------------------------------
    // Reference — Commands (reference/commands/)
    // ---------------------------------------------------------------
    ContentItem(
      id: 'rc-overview',
      title: 'Commands Overview',
      section: ContentSection.referenceCommands,
      language: Language.en,
      assetPath: 'reference/commands/overview.md',
      order: 0,
    ),
    ContentItem(
      id: 'rc-flags',
      title: 'CLI Flags',
      section: ContentSection.referenceCommands,
      language: Language.en,
      assetPath: 'reference/commands/cli-flags.md',
      order: 1,
    ),
    ContentItem(
      id: 'rc-slash',
      title: 'Slash Commands',
      section: ContentSection.referenceCommands,
      language: Language.en,
      assetPath: 'reference/commands/slash-commands.md',
      order: 2,
    ),

    // ---------------------------------------------------------------
    // Reference — SDK (reference/sdk/)
    // ---------------------------------------------------------------
    ContentItem(
      id: 'rs-overview',
      title: 'SDK Overview',
      section: ContentSection.referenceSdk,
      language: Language.en,
      assetPath: 'reference/sdk/overview.md',
      order: 0,
    ),
    ContentItem(
      id: 'rs-hooks',
      title: 'Hooks Reference',
      section: ContentSection.referenceSdk,
      language: Language.en,
      assetPath: 'reference/sdk/hooks-reference.md',
      order: 1,
    ),
    ContentItem(
      id: 'rs-perm',
      title: 'Permissions API',
      section: ContentSection.referenceSdk,
      language: Language.en,
      assetPath: 'reference/sdk/permissions-api.md',
      order: 2,
    ),

    // ---------------------------------------------------------------
    // Reference — Tools (reference/tools/)
    // ---------------------------------------------------------------
    ContentItem(
      id: 'rt-agent',
      title: 'Agent',
      section: ContentSection.referenceTools,
      language: Language.en,
      assetPath: 'reference/tools/agent.md',
      order: 0,
    ),
    ContentItem(
      id: 'rt-bash',
      title: 'Bash',
      section: ContentSection.referenceTools,
      language: Language.en,
      assetPath: 'reference/tools/bash.md',
      order: 1,
    ),
    ContentItem(
      id: 'rt-file',
      title: 'File Operations',
      section: ContentSection.referenceTools,
      language: Language.en,
      assetPath: 'reference/tools/file-operations.md',
      order: 2,
    ),
    ContentItem(
      id: 'rt-search',
      title: 'Search',
      section: ContentSection.referenceTools,
      language: Language.en,
      assetPath: 'reference/tools/search.md',
      order: 3,
    ),
    ContentItem(
      id: 'rt-web',
      title: 'Web',
      section: ContentSection.referenceTools,
      language: Language.en,
      assetPath: 'reference/tools/web.md',
      order: 4,
    ),
  ];

  /// Look up a single item by its id.
  static ContentItem? findById(String id) {
    try {
      return items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// All items belonging to a given section, sorted by order.
  static List<ContentItem> bySection(ContentSection section) {
    return items.where((e) => e.section == section).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// Human-readable label for a section.
  static String sectionLabel(ContentSection section) {
    return switch (section) {
      ContentSection.koreanCourse => '한국어 코스',
      ContentSection.agenticLoop => '에이전틱 루프 상세',
      ContentSection.deepDive => 'Deep Dive 분석',
      ContentSection.gettingStarted => 'Getting Started',
      ContentSection.concepts => 'Concepts',
      ContentSection.configuration => 'Configuration',
      ContentSection.guides => 'Guides',
      ContentSection.referenceCommands => 'Reference: Commands',
      ContentSection.referenceSdk => 'Reference: SDK',
      ContentSection.referenceTools => 'Reference: Tools',
    };
  }
}
