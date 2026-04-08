import 'package:flutter/material.dart';

import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationSuggestion application;
  final String title;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.title,
  });

  String get _summary {
    final text = application.action;
    if (text.length <= 40) return text;
    return '${text.substring(0, 40)}...';
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      icon: '✏️',
      title: title,
      summary: _summary,
      expandedContent: Text(
        application.action,
        style: AbbaTypography.body.copyWith(
          color: AbbaColors.warmBrown,
          height: 1.8,
        ),
      ),
    );
  }
}
