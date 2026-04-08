import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/abba_theme.dart';
import 'abba_card.dart';

class ExpandableCard extends StatefulWidget {
  final String icon;
  final String title;
  final String summary;
  final Widget expandedContent;
  final bool initiallyExpanded;

  const ExpandableCard({
    super.key,
    required this.icon,
    required this.title,
    required this.summary,
    required this.expandedContent,
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: _expanded ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.lightImpact();
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _iconController.forward();
      } else {
        _iconController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbbaCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (항상 보임) — 탭 가능
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(AbbaRadius.lg),
            child: Padding(
              padding: const EdgeInsets.all(AbbaSpacing.md + 4),
              child: Row(
                children: [
                  Text(widget.icon, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: AbbaSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: AbbaTypography.h2,
                        ),
                        if (!_expanded && widget.summary.isNotEmpty) ...[
                          const SizedBox(height: AbbaSpacing.xs),
                          Text(
                            widget.summary,
                            style: AbbaTypography.bodySmall.copyWith(
                              color: AbbaColors.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: _iconController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 32,
                      color: AbbaColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 펼쳐진 콘텐츠
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AbbaSpacing.md + 4,
                      0,
                      AbbaSpacing.md + 4,
                      AbbaSpacing.md + 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: AbbaColors.warmBrown.withValues(alpha: 0.1),
                          height: 1,
                        ),
                        const SizedBox(height: AbbaSpacing.md),
                        widget.expandedContent,
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
