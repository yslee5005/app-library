import 'package:flutter/material.dart';

import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class TestimonyCard extends StatelessWidget {
  final String testimony;
  final String title;

  const TestimonyCard({
    super.key,
    required this.testimony,
    required this.title,
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
      expandedContent: Text(testimony, style: AbbaTypography.body),
    );
  }
}
