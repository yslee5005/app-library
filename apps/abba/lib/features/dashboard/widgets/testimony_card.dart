import 'package:flutter/material.dart';

import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class TestimonyCard extends StatelessWidget {
  final String testimony;
  final String title;
  final String editLabel;

  const TestimonyCard({
    super.key,
    required this.testimony,
    required this.title,
    required this.editLabel,
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
          Text(testimony, style: AbbaTypography.body),
          const SizedBox(height: AbbaSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 18, color: AbbaColors.sage),
              label: Text(
                editLabel,
                style: AbbaTypography.bodySmall.copyWith(
                  color: AbbaColors.sage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
