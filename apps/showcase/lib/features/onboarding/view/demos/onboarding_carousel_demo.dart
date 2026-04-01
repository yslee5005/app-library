import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../sample_data/sample_data.dart';

class OnboardingCarouselDemo extends StatelessWidget {
  const OnboardingCarouselDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OnboardingCarousel')),
      body: OnboardingCarousel(
        pages: SampleData.onboardingPages
            .map(
              (p) => OnboardingPage(
                title: p['title']!,
                subtitle: p['subtitle']!,
                image: Icon(
                  Icons.widgets,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
            .toList(),
        onFinish: () => Navigator.pop(context),
      ),
    );
  }
}
