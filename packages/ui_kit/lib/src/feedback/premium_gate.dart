import 'dart:ui';
import 'package:flutter/material.dart';

/// Generic premium content gate with blur effect.
/// Wrap any content — when [isLocked], shows blur + unlock CTA.
class PremiumGate extends StatelessWidget {
  const PremiumGate({
    super.key,
    required this.content,
    required this.isLocked,
    required this.title,
    this.icon,
    required this.unlockLabel,
    required this.onUnlock,
  });

  final Widget content;
  final bool isLocked;
  final String title;
  final String? icon; // emoji
  final String unlockLabel; // "Unlock with Premium"
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    if (!isLocked) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null)
                    Text(icon!, style: const TextStyle(fontSize: 24)),
                  if (icon != null) const SizedBox(width: 8),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 12),
              content,
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null)
                  Text(icon!, style: const TextStyle(fontSize: 24)),
                if (icon != null) const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: content,
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.3),
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: onUnlock,
                        icon: const Text('💎'),
                        label: Text(unlockLabel),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
