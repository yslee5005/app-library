import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class RatingBarDemo extends StatefulWidget {
  const RatingBarDemo({super.key});

  @override
  State<RatingBarDemo> createState() => _RatingBarDemoState();
}

class _RatingBarDemoState extends State<RatingBarDemo> {
  double _rating = 3.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppRatingBar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tap a star to rate:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            AppRatingBar(
              rating: _rating,
              onRatingChanged: (r) => setState(() => _rating = r),
            ),
            const SizedBox(height: 16),
            Text('Rating: ${_rating.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
