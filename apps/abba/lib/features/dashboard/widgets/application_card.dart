import 'package:flutter/material.dart';

import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationSuggestion application;
  final String title;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AbbaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✏️', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AbbaSpacing.sm),
              Text(title, style: AbbaTypography.h2),
            ],
          ),
          const SizedBox(height: AbbaSpacing.md),
          Text(
            application.action,
            style: AbbaTypography.body.copyWith(
              color: AbbaColors.warmBrown,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
