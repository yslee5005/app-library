import 'package:flutter/material.dart';

import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return AbbaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✍️', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AbbaSpacing.sm),
              Expanded(child: Text(title, style: AbbaTypography.h2)),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 18, color: AbbaColors.sage),
                label: Text(
                  editLabel,
                  style: AbbaTypography.bodySmall.copyWith(
                    color: AbbaColors.sage,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AbbaSpacing.md),
          Text(testimony, style: AbbaTypography.body),
        ],
      ),
    );
  }
}
