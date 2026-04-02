import 'package:flutter/material.dart';

/// An activity the dog loves, with age-based availability data.
class FavoriteActivity {
  final String id;
  final String name;
  final String emoji;
  final int maxAgeAvailable; // After this age, activity becomes difficult
  final String reason; // Why it becomes difficult
  final int frequencyPerMonth; // How often owner typically does this

  const FavoriteActivity({
    required this.id,
    required this.name,
    required this.emoji,
    required this.maxAgeAvailable,
    required this.reason,
    this.frequencyPerMonth = 2,
  });

  /// Calculate remaining possible times based on current age
  int remainingCount(double currentAge) {
    final yearsLeft = (maxAgeAvailable - currentAge).clamp(0.0, 20.0);
    return (yearsLeft * 12 * frequencyPerMonth).round();
  }

  /// Years remaining for this activity
  double yearsRemaining(double currentAge) {
    return (maxAgeAvailable - currentAge).clamp(0.0, 20.0);
  }

  /// Is this activity still possible?
  bool isAvailable(double currentAge) => currentAge < maxAgeAvailable;

  /// Urgency level: critical (<1yr), warning (<2yr), normal
  String urgencyLevel(double currentAge) {
    final years = yearsRemaining(currentAge);
    if (years <= 1) return 'critical';
    if (years <= 2) return 'warning';
    return 'normal';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'maxAgeAvailable': maxAgeAvailable,
        'reason': reason,
        'frequencyPerMonth': frequencyPerMonth,
      };

  factory FavoriteActivity.fromJson(Map<String, dynamic> json) {
    return FavoriteActivity(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      maxAgeAvailable: json['maxAgeAvailable'] as int,
      reason: json['reason'] as String,
      frequencyPerMonth: json['frequencyPerMonth'] as int? ?? 2,
    );
  }

  /// All available activities for selection
  static List<FavoriteActivity> get allActivities => const [
        FavoriteActivity(
          id: 'swimming',
          name: '수영',
          emoji: '🏊',
          maxAgeAvailable: 10,
          reason: '체력 저하로 수영이 어려워짐',
          frequencyPerMonth: 2,
        ),
        FavoriteActivity(
          id: 'ball_play',
          name: '공놀이',
          emoji: '🎾',
          maxAgeAvailable: 9,
          reason: '관절 문제로 격한 놀이 제한',
          frequencyPerMonth: 15,
        ),
        FavoriteActivity(
          id: 'hiking',
          name: '등산',
          emoji: '🏔️',
          maxAgeAvailable: 10,
          reason: '장거리 보행이 어려워짐',
          frequencyPerMonth: 2,
        ),
        FavoriteActivity(
          id: 'beach',
          name: '해변',
          emoji: '🏖️',
          maxAgeAvailable: 11,
          reason: '더위와 체력 부담',
          frequencyPerMonth: 1,
        ),
        FavoriteActivity(
          id: 'dog_friends',
          name: '친구 만남',
          emoji: '🐕',
          maxAgeAvailable: 8,
          reason: '사회성 감소, 새 만남에 스트레스',
          frequencyPerMonth: 4,
        ),
        FavoriteActivity(
          id: 'car_ride',
          name: '드라이브',
          emoji: '🚗',
          maxAgeAvailable: 12,
          reason: '차멀미 증가, 장시간 탑승 어려움',
          frequencyPerMonth: 4,
        ),
        FavoriteActivity(
          id: 'camping',
          name: '캠핑',
          emoji: '⛺',
          maxAgeAvailable: 10,
          reason: '야외 환경 적응 어려움',
          frequencyPerMonth: 1,
        ),
        FavoriteActivity(
          id: 'snow_play',
          name: '눈놀이',
          emoji: '❄️',
          maxAgeAvailable: 10,
          reason: '추위에 관절 악화, 체온 조절 어려움',
          frequencyPerMonth: 1,
        ),
        FavoriteActivity(
          id: 'training',
          name: '훈련/학습',
          emoji: '🎯',
          maxAgeAvailable: 11,
          reason: '인지 능력 저하로 새 학습 어려움',
          frequencyPerMonth: 8,
        ),
        FavoriteActivity(
          id: 'toy_play',
          name: '장난감 놀이',
          emoji: '🧸',
          maxAgeAvailable: 10,
          reason: '흥미 감소, 활동량 저하',
          frequencyPerMonth: 20,
        ),
        FavoriteActivity(
          id: 'massage',
          name: '마사지',
          emoji: '💆',
          maxAgeAvailable: 15,
          reason: '오히려 나이들수록 필요해요',
          frequencyPerMonth: 8,
        ),
        FavoriteActivity(
          id: 'running',
          name: '달리기',
          emoji: '🏃',
          maxAgeAvailable: 8,
          reason: '관절 부담, 심폐 기능 저하',
          frequencyPerMonth: 8,
        ),
      ];
}
