import 'package:flutter/material.dart';

import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class TestimonyCard extends StatelessWidget {
  final String testimony;
  final String title;
  final String? helperText;

  const TestimonyCard({
    super.key,
    required this.testimony,
    required this.title,
    this.helperText,
  });

  String get _summary {
    if (testimony.length <= 40) return testimony;
    return '${testimony.substring(0, 40)}...';
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      icon: '✍️',
      title: title,
      summary: _summary,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (helperText != null) ...[
            Text(
              helperText!,
              style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
            ),
            const SizedBox(height: AbbaSpacing.sm),
          ],
          Text(testimony, style: AbbaTypography.body),
        ],
      ),
    );
  }
}
