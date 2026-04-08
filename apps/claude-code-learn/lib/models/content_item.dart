/// Sections of the content catalog.
enum ContentSection {
  koreanCourse,
  agenticLoop,
  deepDive,
  gettingStarted,
  concepts,
  configuration,
  guides,
  referenceCommands,
  referenceSdk,
  referenceTools,
}

/// Language of a content item.
enum Language { ko, en }

/// A single piece of readable content backed by a markdown asset.
class ContentItem {
  const ContentItem({
    required this.id,
    required this.title,
    required this.section,
    required this.language,
    required this.assetPath,
    required this.order,
    this.parentId,
  });

  final String id;
  final String title;
  final ContentSection section;
  final Language language;

  /// Relative path under `assets/content/`.
  final String assetPath;

  /// Display order within its section.
  final int order;

  /// Optional parent id for nested items (e.g. sub-chapters).
  final String? parentId;
}
