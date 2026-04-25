import 'package:app_lib_logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';

class WritePostView extends ConsumerStatefulWidget {
  const WritePostView({super.key});

  @override
  ConsumerState<WritePostView> createState() => _WritePostViewState();
}

class _WritePostViewState extends ConsumerState<WritePostView> {
  bool _isAnonymous = true;
  String _category = 'testimony';
  final _textController = TextEditingController();
  bool _isSubmitting = false;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final hasContent = _textController.text.isNotEmpty;
      if (hasContent != _hasContent) {
        setState(() => _hasContent = hasContent);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_hasContent,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showDiscardDialog();
        }
      },
      child: Scaffold(
        backgroundColor: AbbaColors.cream,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (_textController.text.isEmpty) {
                context.pop();
              } else {
                _showDiscardDialog();
              }
            },
            icon: const Icon(Icons.close),
          ),
          title: Text('${l10n.writePostTitle} 🌸', style: AbbaTypography.h1),
          actions: [
            TextButton(
              onPressed: _isSubmitting ? null : _submitPost,
              child: Text(
                l10n.sharePostButton,
                style: AbbaTypography.body.copyWith(
                  color: _isSubmitting ? AbbaColors.muted : AbbaColors.sage,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AbbaSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Anonymous/Real name toggle
              Container(
                padding: const EdgeInsets.all(AbbaSpacing.sm),
                decoration: BoxDecoration(
                  color: AbbaColors.white,
                  borderRadius: BorderRadius.circular(AbbaRadius.xl),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isAnonymous = true),
                        child: Container(
                          height: abbaButtonHeight,
                          decoration: BoxDecoration(
                            color: _isAnonymous
                                ? AbbaColors.sage
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(AbbaRadius.xl),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '🌿 ${l10n.anonymousToggle}',
                            style: AbbaTypography.body.copyWith(
                              color: _isAnonymous
                                  ? AbbaColors.white
                                  : AbbaColors.warmBrown,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isAnonymous = false),
                        child: Container(
                          height: abbaButtonHeight,
                          decoration: BoxDecoration(
                            color: !_isAnonymous
                                ? AbbaColors.sage
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(AbbaRadius.xl),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.realNameToggle,
                            style: AbbaTypography.body.copyWith(
                              color: !_isAnonymous
                                  ? AbbaColors.white
                                  : AbbaColors.warmBrown,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AbbaSpacing.lg),
              // Category chips
              Row(
                children: [
                  _CategoryChip(
                    label: l10n.categoryTestimony,
                    isSelected: _category == 'testimony',
                    onTap: () => setState(() => _category = 'testimony'),
                  ),
                  const SizedBox(width: AbbaSpacing.sm),
                  _CategoryChip(
                    label: l10n.categoryPrayerRequest,
                    isSelected: _category == 'prayer_request',
                    onTap: () => setState(() => _category = 'prayer_request'),
                  ),
                ],
              ),
              const SizedBox(height: AbbaSpacing.lg),
              // Text input
              TextField(
                controller: _textController,
                maxLines: null,
                minLines: 8,
                style: AbbaTypography.body,
                decoration: InputDecoration(
                  hintText: l10n.writePostHint,
                  hintStyle: AbbaTypography.body.copyWith(
                    color: AbbaColors.muted,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.lg),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AbbaColors.white,
                  contentPadding: const EdgeInsets.all(AbbaSpacing.md),
                ),
              ),
              const SizedBox(height: AbbaSpacing.md),
              // Import from prayer
              OutlinedButton.icon(
                onPressed: _importFromPrayer,
                icon: const Text('🎙️', style: TextStyle(fontSize: 18)),
                label: Text(
                  l10n.importFromPrayer,
                  style: AbbaTypography.body.copyWith(color: AbbaColors.sage),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, abbaButtonHeight),
                  side: const BorderSide(color: AbbaColors.sage),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AbbaSpacing.xl),
              // Share button
              AbbaButton(
                label: '${l10n.sharePostButton} 🌱',
                onPressed: () {
                  if (!_isSubmitting) _submitPost();
                },
                isHero: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiscardDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
        ),
        title: Text(l10n.leaveRecordingTitle, style: AbbaTypography.h2),
        content: Text(l10n.leaveRecordingMessage, style: AbbaTypography.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.stayButton,
              style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: Text(
              l10n.leaveButton,
              style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _importFromPrayer() {
    // Get latest prayer result testimony
    final result = ref.read(prayerResultProvider);
    result.when(
      data: (prayerResult) {
        _textController.text = prayerResult.testimony;
      },
      loading: () {},
      error: (e, s) {},
    );
  }

  Future<void> _submitPost() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(communityRepositoryProvider);
      final profile = ref.read(userProfileProvider).value;

      await repo.createPost(
        category: _category,
        content: text,
        displayName: _isAnonymous ? null : profile?.name,
      );
      communityLog.info('New post created: category=$_category');

      // Refresh community posts
      ref.invalidate(filteredCommunityPostsProvider);

      if (mounted) context.pop(true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AbbaSpacing.lg,
          vertical: AbbaSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AbbaColors.sage : AbbaColors.white,
          borderRadius: BorderRadius.circular(AbbaRadius.xl),
          border: Border.all(
            color: isSelected ? AbbaColors.sage : AbbaColors.muted,
          ),
        ),
        child: Text(
          label,
          style: AbbaTypography.body.copyWith(
            color: isSelected ? AbbaColors.white : AbbaColors.warmBrown,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
