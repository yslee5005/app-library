import 'package:flutter/material.dart';

class ImageCarouselDemo extends StatelessWidget {
  const ImageCarouselDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ImageCarousel')),
      body: Center(
        child: SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.primaries[(index * 3) % Colors.primaries.length]
                      .withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Slide ${index + 1}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
