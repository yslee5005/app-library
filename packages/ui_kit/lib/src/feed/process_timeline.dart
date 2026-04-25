import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A single step in a [ProcessTimeline].
class ProcessStep {
  const ProcessStep({required this.title, this.description, this.icon});

  /// Short title for the step.
  final String title;

  /// Optional longer description.
  final String? description;

  /// Optional icon displayed inside the step circle.
  /// When null, the step number is shown.
  final IconData? icon;
}

/// A timeline showing numbered steps with connectors.
///
/// Commonly used for order tracking, onboarding flows, or process explanations.
///
/// ```dart
/// ProcessTimeline(
///   steps: [
///     ProcessStep(title: 'Order'),
///     ProcessStep(title: 'Ship'),
///     ProcessStep(title: 'Deliver'),
///   ],
///   activeStep: 1,
/// )
/// ```
class ProcessTimeline extends StatelessWidget {
  const ProcessTimeline({
    required this.steps,
    this.activeStep,
    this.orientation = Axis.horizontal,
    this.circleSize = 36,
    this.connectorThickness = 1,
    this.activeColor,
    this.inactiveColor,
    this.showDescriptions = true,
    super.key,
  });

  /// The steps to display.
  final List<ProcessStep> steps;

  /// Currently active step index (0-based). All steps up to this are active.
  /// When null, all steps are shown in inactive state.
  final int? activeStep;

  /// Layout orientation.
  final Axis orientation;

  /// Size of each step circle.
  final double circleSize;

  /// Thickness of connector lines.
  final double connectorThickness;

  /// Color for active steps. Defaults to theme primary.
  final Color? activeColor;

  /// Color for inactive steps. Defaults to theme onSurfaceVariant.
  final Color? inactiveColor;

  /// Whether to show step descriptions below titles.
  final bool showDescriptions;

  @override
  Widget build(BuildContext context) {
    return orientation == Axis.horizontal
        ? _buildHorizontal(context)
        : _buildVertical(context);
  }

  Widget _buildHorizontal(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final inactive = inactiveColor ?? theme.colorScheme.onSurfaceVariant;

    return Column(
      children: [
        // Circles + connectors row
        Row(
          children: [
            for (int i = 0; i < steps.length; i++) ...[
              if (i > 0)
                Expanded(
                  child: Container(
                    height: connectorThickness,
                    color: _isStepActive(i) ? active : inactive.withAlpha(80),
                  ),
                ),
              _buildCircle(context, i, active, inactive),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        // Labels row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < steps.length; i++)
              SizedBox(
                width: circleSize + AppSpacing.md,
                child: Text(
                  steps[i].title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _isStepActive(i) ? active : inactive,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildVertical(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final inactive = inactiveColor ?? theme.colorScheme.onSurfaceVariant;

    return Column(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _buildCircle(context, i, active, inactive),
                  if (i < steps.length - 1)
                    Container(
                      width: connectorThickness,
                      height: showDescriptions ? 48 : 24,
                      color:
                          _isStepActive(i + 1)
                              ? active
                              : inactive.withAlpha(80),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i].title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: _isStepActive(i) ? null : inactive,
                        ),
                      ),
                      if (showDescriptions && steps[i].description != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          steps[i].description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCircle(
    BuildContext context,
    int index,
    Color active,
    Color inactive,
  ) {
    final isActive = _isStepActive(index);
    final step = steps[index];

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? active : Colors.transparent,
        border: Border.all(
          color: isActive ? active : inactive.withAlpha(80),
          width: connectorThickness,
        ),
      ),
      alignment: Alignment.center,
      child:
          step.icon != null
              ? Icon(
                step.icon,
                size: circleSize * 0.5,
                color: isActive ? Colors.white : inactive,
              )
              : Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: circleSize * 0.38,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : inactive,
                ),
              ),
    );
  }

  bool _isStepActive(int index) {
    if (activeStep == null) return false;
    return index <= activeStep!;
  }
}
