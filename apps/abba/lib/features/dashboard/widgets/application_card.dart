import 'package:flutter/material.dart';

import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationSuggestion application;
  final String title;
  final String whatLabel;
  final String whenLabel;
  final String contextLabel;
  final String locale;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.title,
    required this.whatLabel,
    required this.whenLabel,
    required this.contextLabel,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return AbbaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✅', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AbbaSpacing.sm),
              Text(title, style: AbbaTypography.h2),
            ],
          ),
          const SizedBox(height: AbbaSpacing.md),
          _buildRow(whatLabel, application.action(locale), Icons.check_circle_outline),
          const SizedBox(height: AbbaSpacing.sm),
          _buildRow(whenLabel, application.when(locale), Icons.schedule),
          const SizedBox(height: AbbaSpacing.sm),
          _buildRow(contextLabel, application.context(locale), Icons.place_outlined),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AbbaColors.sage),
        const SizedBox(width: AbbaSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AbbaTypography.caption.copyWith(
                  color: AbbaColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: AbbaTypography.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
