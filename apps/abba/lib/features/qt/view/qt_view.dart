import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/qt_passage.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../recording/view/recording_overlay.dart';

class QtView extends ConsumerWidget {
  const QtView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final passagesAsync = ref.watch(qtPassagesProvider);

    final today = DateFormat.yMMMMd(locale).format(DateTime.now());

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text('${l10n.qtPageTitle} 🌱', style: AbbaTypography.h1),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.lg),
            child: Text(
              today,
              style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
            ),
          ),
          const SizedBox(height: AbbaSpacing.md),
          Expanded(
            child: passagesAsync.when(
              data: (passages) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.md),
                itemCount: passages.length,
                itemBuilder: (context, index) => _QtPassageCard(
                  passage: passages[index],
                  locale: locale,
                  meditateLabel: l10n.qtMeditateButton,
                  completedLabel: l10n.qtCompleted,
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtPassageCard extends StatefulWidget {
  final QTPassage passage;
  final String locale;
  final String meditateLabel;
  final String completedLabel;

  const _QtPassageCard({
    required this.passage,
    required this.locale,
    required this.meditateLabel,
    required this.completedLabel,
  });

  @override
  State<_QtPassageCard> createState() => _QtPassageCardState();
}

class _QtPassageCardState extends State<_QtPassageCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final passage = widget.passage;

    return Card(
      margin: const EdgeInsets.only(bottom: AbbaSpacing.md),
      color: passage.color.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AbbaRadius.lg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AbbaRadius.lg),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(AbbaSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(passage.icon, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: AbbaSpacing.sm),
                  Expanded(
                    child: Text(
                      passage.reference,
                      style: AbbaTypography.h2.copyWith(fontSize: 22),
                    ),
                  ),
                  if (passage.isCompleted)
                    Container(
                      padding: const EdgeInsets.all(AbbaSpacing.xs),
                      decoration: const BoxDecoration(
                        color: AbbaColors.sage,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 18,
                        color: AbbaColors.white,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AbbaSpacing.sm),
              // Preview (always visible)
              Text(
                passage.text(widget.locale),
                style: AbbaTypography.bodySmall,
                maxLines: _expanded ? null : 2,
                overflow: _expanded ? null : TextOverflow.ellipsis,
              ),
              // Expanded content
              if (_expanded) ...[
                const SizedBox(height: AbbaSpacing.lg),
                AbbaButton(
                  label: '🎙️ ${widget.meditateLabel}',
                  onPressed: () => _showRecording(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showRecording(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RecordingOverlay(),
    );
  }
}
