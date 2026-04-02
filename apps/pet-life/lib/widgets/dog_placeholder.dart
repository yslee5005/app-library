import 'package:flutter/material.dart';

import '../config/app_config.dart';

/// Placeholder for dog character — will be replaced with Lottie later
class DogPlaceholder extends StatelessWidget {
  final double size;

  const DogPlaceholder({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppConfig.accentColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Icon(
        Icons.pets,
        size: size * 0.4,
        color: AppConfig.accentColor,
      ),
    );
  }
}
