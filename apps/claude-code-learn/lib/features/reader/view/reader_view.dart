import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../../data/content_catalog.dart';
import '../../../models/reading_progress.dart';
import '../../../providers/providers.dart';
import '../../../theme/learn_theme.dart';

class ReaderView extends ConsumerStatefulWidget {
  final String contentId;

  const ReaderView({super.key, required this.contentId});

  @override
  ConsumerState<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends ConsumerState<ReaderView> {
  String _markdown = '';
  bool _isLoading = true;
  bool _isBookmarked = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _progressTimer;
  int _timeSpent = 0;

  @override
  void initState() {
    super.initState();
    _loadContent();
    _loadBookmarkStatus();
    _scrollController.addListener(_onScroll);
    // Track time spent
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _timeSpent++;
    });
  }

  @override
  void dispose() {
    _saveProgress();
    _progressTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadContent() async {
    final service = ref.read(contentServiceProvider);
    final data = await service.loadById(widget.contentId);
    if (mounted) {
      setState(() {
        _markdown = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBookmarkStatus() async {
    final repo = ref.read(progressRepositoryProvider);
    final bookmarked = await repo.isBookmarked(widget.contentId);
    if (mounted) setState(() => _isBookmarked = bookmarked);
  }

  void _onScroll() {
    // Check if reached near the bottom to mark as completed
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.maxScrollExtent <= 0) return;
    final ratio = pos.pixels / pos.maxScrollExtent;
    if (ratio >= 0.95) {
      _markCompleted();
    }
  }

  Future<void> _markCompleted() async {
    final repo = ref.read(progressRepositoryProvider);
    final existing = await repo.getProgress(widget.contentId);
    if (existing != null && existing.isCompleted) return;

    await repo.upsertProgress(ReadingProgress(
      contentId: widget.contentId,
      scrollPosition: 1.0,
      isCompleted: true,
      lastReadAt: DateTime.now(),
      timeSpentSeconds: _timeSpent,
    ));
    ref.invalidate(allProgressProvider);
  }

  Future<void> _saveProgress() async {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final ratio =
        pos.maxScrollExtent > 0 ? pos.pixels / pos.maxScrollExtent : 0.0;

    final repo = ref.read(progressRepositoryProvider);
    final existing = await repo.getProgress(widget.contentId);

    await repo.upsertProgress(ReadingProgress(
      contentId: widget.contentId,
      scrollPosition: ratio,
      isCompleted: existing?.isCompleted ?? (ratio >= 0.95),
      lastReadAt: DateTime.now(),
      timeSpentSeconds: (existing?.timeSpentSeconds ?? 0) + _timeSpent,
    ));
    ref.invalidate(allProgressProvider);
  }

  Future<void> _toggleBookmark() async {
    final repo = ref.read(progressRepositoryProvider);
    final nowBookmarked = await repo.toggleBookmark(widget.contentId);
    if (mounted) setState(() => _isBookmarked = nowBookmarked);
    ref.invalidate(bookmarksProvider);
  }

  @override
  Widget build(BuildContext context) {
    final item = ContentCatalog.findById(widget.contentId);
    final fontSize = ref.watch(fontSizeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          item?.title ?? 'Reading',
          style: LearnTypography.h2,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleBookmark,
        child: Icon(
          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          color: _isBookmarked ? LearnColors.bookmarkAmber : null,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : MarkdownWidget(
              data: _markdown,
              selectable: true,
              config: isDark
                  ? MarkdownConfig.darkConfig.copy(
                      configs: [
                        PConfig(textStyle: TextStyle(fontSize: fontSize, height: 1.7)),
                      ],
                    )
                  : MarkdownConfig.defaultConfig.copy(
                      configs: [
                        PConfig(textStyle: TextStyle(fontSize: fontSize, height: 1.7)),
                      ],
                    ),
            ),
    );
  }
}
