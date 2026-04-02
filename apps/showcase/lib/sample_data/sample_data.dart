import 'package:flutter/material.dart';

class SampleData {
  SampleData._();

  // User
  static const String userName = 'John Doe';
  static const String userInitials = 'JD';
  static const String userEmail = 'john.doe@example.com';
  static const String userBio =
      'Flutter developer & open source enthusiast. Building great apps one widget at a time.';

  // Profile stats
  static const int followersCount = 1200;
  static const int postsCount = 342;
  static const double rating = 4.8;

  // Feed items
  static List<Map<String, String>> feedItems = List.generate(
    20,
    (i) => {
      'title': 'Item ${i + 1}',
      'subtitle': 'Description for item ${i + 1}. Tap to see more details.',
    },
  );

  // Comments
  static const List<Map<String, String>> comments = [
    {'name': 'Alice', 'body': 'This is amazing! Great work on this.'},
    {'name': 'Bob', 'body': 'Really useful, thanks for sharing.'},
    {'name': 'Carol', 'body': 'I have a question about the implementation.'},
    {'name': 'Dave', 'body': 'Awesome showcase app!'},
    {'name': 'Eve', 'body': 'Would love to see more examples.'},
  ];

  // Onboarding pages
  static const List<Map<String, String>> onboardingPages = [
    {
      'title': 'Welcome to Showcase',
      'subtitle':
          'Explore all 40+ reusable UI components built with Material 3.',
    },
    {
      'title': 'Customizable Themes',
      'subtitle': 'Every widget adapts to your seed color and dark mode.',
    },
    {
      'title': 'Ready to Build',
      'subtitle': 'Pick the components you need and assemble your next app.',
    },
  ];

  // Category data for home grid
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Navigation', 'icon': Icons.navigation, 'count': 4},
    {'name': 'Onboarding', 'icon': Icons.start, 'count': 4},
    {'name': 'Profile', 'icon': Icons.person, 'count': 5},
    {'name': 'Feed', 'icon': Icons.feed, 'count': 4},
    {'name': 'Search', 'icon': Icons.search, 'count': 4},
    {'name': 'Forms', 'icon': Icons.edit_note, 'count': 6},
    {'name': 'Feedback', 'icon': Icons.feedback, 'count': 7},
    {'name': 'Media', 'icon': Icons.image, 'count': 4},
    {'name': 'Charts', 'icon': Icons.bar_chart, 'count': 3},
    {'name': 'Full Flow', 'icon': Icons.route, 'count': 3},
  ];

  // Settings sections
  static const List<String> languages = ['English', 'Korean', 'Japanese'];

  // Heatmap data (last 17 weeks of sample activity)
  static Map<DateTime, int> get heatmapData {
    final now = DateTime.now();
    final data = <DateTime, int>{};
    for (var i = 0; i < 119; i++) {
      final date = now.subtract(Duration(days: i));
      final normalized = DateTime(date.year, date.month, date.day);
      data[normalized] = (i * 7 + 3) % 5;
    }
    return data;
  }
}
