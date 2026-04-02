import 'package:flutter/material.dart';

class DailyRoutine {
  final String id;
  final String name;
  final IconData icon;
  final int goalPerDay;
  final String category; // 'walk', 'meal', 'care', 'custom'

  const DailyRoutine({
    required this.id,
    required this.name,
    required this.icon,
    this.goalPerDay = 1,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'goalPerDay': goalPerDay,
      'category': category,
    };
  }

  factory DailyRoutine.fromJson(Map<String, dynamic> json) {
    return DailyRoutine(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: IconData(
        json['iconCodePoint'] as int,
        fontFamily: json['iconFontFamily'] as String?,
      ),
      goalPerDay: json['goalPerDay'] as int? ?? 1,
      category: json['category'] as String,
    );
  }

  DailyRoutine copyWith({
    String? id,
    String? name,
    IconData? icon,
    int? goalPerDay,
    String? category,
  }) {
    return DailyRoutine(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      goalPerDay: goalPerDay ?? this.goalPerDay,
      category: category ?? this.category,
    );
  }

  /// Default routines for onboarding
  static List<DailyRoutine> get defaults => [
        const DailyRoutine(
          id: 'walk_am',
          name: '아침 산책',
          icon: Icons.wb_sunny_outlined,
          category: 'walk',
        ),
        const DailyRoutine(
          id: 'walk_pm',
          name: '저녁 산책',
          icon: Icons.nightlight_outlined,
          category: 'walk',
        ),
        const DailyRoutine(
          id: 'meal_am',
          name: '아침 식사',
          icon: Icons.restaurant_outlined,
          category: 'meal',
        ),
        const DailyRoutine(
          id: 'meal_pm',
          name: '저녁 식사',
          icon: Icons.dinner_dining_outlined,
          category: 'meal',
        ),
      ];

  /// Optional routines
  static List<DailyRoutine> get optionals => [
        const DailyRoutine(
          id: 'teeth',
          name: '양치질',
          icon: Icons.clean_hands_outlined,
          category: 'care',
        ),
        const DailyRoutine(
          id: 'meds',
          name: '약 복용',
          icon: Icons.medication_outlined,
          category: 'care',
        ),
        const DailyRoutine(
          id: 'snack',
          name: '간식',
          icon: Icons.cookie_outlined,
          category: 'meal',
        ),
        const DailyRoutine(
          id: 'play',
          name: '놀이시간',
          icon: Icons.sports_tennis_outlined,
          category: 'custom',
        ),
      ];
}
