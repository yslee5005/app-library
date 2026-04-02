import 'package:flutter/material.dart';

/// An activity the dog loves, with age-based availability data.
class FavoriteActivity {
  final String id;
  final String name;
  final String emoji;
  final int maxAgeAvailable;
  final String reason;
  final int frequencyPerMonth; // default/template value
  final String? seasonUnit;
  final int seasonsPerYear;

  // User-personalized frequency
  final double userFrequency; // user's actual frequency
  final String frequencyUnit; // 'weekly', 'monthly', 'yearly'

  const FavoriteActivity({
    required this.id,
    required this.name,
    required this.emoji,
    required this.maxAgeAvailable,
    required this.reason,
    this.frequencyPerMonth = 2,
    this.seasonUnit,
    this.seasonsPerYear = 4,
    this.userFrequency = 0,
    this.frequencyUnit = 'monthly',
  });

  /// Monthly frequency from user input (converted to per-month)
  double get _monthlyFrequency {
    if (userFrequency > 0) {
      return switch (frequencyUnit) {
        'weekly' => userFrequency * 4.33,
        'yearly' => userFrequency / 12,
        _ => userFrequency, // monthly
      };
    }
    return frequencyPerMonth.toDouble();
  }

  /// User-friendly frequency display
  String get frequencyDisplay {
    if (userFrequency <= 0) return '';
    final num = userFrequency % 1 == 0 ? userFrequency.toInt().toString() : userFrequency.toStringAsFixed(1);
    return switch (frequencyUnit) {
      'weekly' => '주 $num회',
      'yearly' => '연 $num회',
      _ => '월 $num회',
    };
  }

  /// Remaining count based on user's frequency
  int remainingCount(double currentAge) {
    final yearsLeft = (maxAgeAvailable - currentAge).clamp(0.0, 20.0);
    return (yearsLeft * 12 * _monthlyFrequency).round();
  }

  /// If user increased frequency by 1 unit, how many more?
  int remainingIfMore(double currentAge) {
    final yearsLeft = (maxAgeAvailable - currentAge).clamp(0.0, 20.0);
    final extraMonthly = switch (frequencyUnit) {
      'weekly' => 4.33,
      'yearly' => 1.0 / 12,
      _ => 1.0,
    };
    return (yearsLeft * 12 * (_monthlyFrequency + extraMonthly)).round();
  }

  /// How many times were "missed" since last activity
  int missedCount(DateTime? lastDate) {
    if (lastDate == null) return 0;
    final daysSince = DateTime.now().difference(lastDate).inDays;
    final monthsSince = daysSince / 30.0;
    return (_monthlyFrequency * monthsSince).round();
  }

  double yearsRemaining(double currentAge) {
    return (maxAgeAvailable - currentAge).clamp(0.0, 20.0);
  }

  /// Remaining in human-friendly unit (seasons or years)
  String remainingHumanUnit(double currentAge) {
    final years = yearsRemaining(currentAge);
    if (seasonUnit != null) {
      final seasons = years.round();
      return '함께 할 수 있는 $seasonUnit이 ${seasons}번 남았어요';
    }
    if (years <= 1) {
      final months = (years * 12).round();
      return '${months}개월 후면 어려워져요';
    }
    return '${years.round()}년 후면 어려워져요';
  }

  /// What you lose if you don't do it this month
  String lossMessage(double currentAge) {
    if (seasonUnit != null) {
      return '이번 $seasonUnit에 안 가면 1번이 영원히 사라져요';
    }
    return '이번 달 안 하면 1번이 영원히 사라져요';
  }

  /// Emotional message based on how long since last done
  String overdueMessage(String petName, int daysSinceLast) {
    if (daysSinceLast > 180) {
      return '반년 동안 ${(daysSinceLast / 30).round()}번의 기회를 놓쳤어요';
    }
    if (daysSinceLast > 60) {
      return '${(daysSinceLast / 30).round()}개월째 $petName를 데려가지 않았어요';
    }
    if (daysSinceLast > 14) {
      return '${(daysSinceLast / 7).round()}주째 못 했어요';
    }
    return '';
  }

  bool isAvailable(double currentAge) => currentAge < maxAgeAvailable;

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
        'userFrequency': userFrequency,
        'frequencyUnit': frequencyUnit,
        'seasonUnit': seasonUnit,
        'seasonsPerYear': seasonsPerYear,
      };

  factory FavoriteActivity.fromJson(Map<String, dynamic> json) {
    return FavoriteActivity(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      maxAgeAvailable: json['maxAgeAvailable'] as int,
      reason: json['reason'] as String,
      frequencyPerMonth: json['frequencyPerMonth'] as int? ?? 2,
      userFrequency: (json['userFrequency'] as num?)?.toDouble() ?? 0,
      frequencyUnit: json['frequencyUnit'] as String? ?? 'monthly',
      seasonUnit: json['seasonUnit'] as String?,
      seasonsPerYear: json['seasonsPerYear'] as int? ?? 4,
    );
  }

  FavoriteActivity copyWith({
    double? userFrequency,
    String? frequencyUnit,
  }) {
    return FavoriteActivity(
      id: id,
      name: name,
      emoji: emoji,
      maxAgeAvailable: maxAgeAvailable,
      reason: reason,
      frequencyPerMonth: frequencyPerMonth,
      seasonUnit: seasonUnit,
      seasonsPerYear: seasonsPerYear,
      userFrequency: userFrequency ?? this.userFrequency,
      frequencyUnit: frequencyUnit ?? this.frequencyUnit,
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
          seasonUnit: '여름',
          seasonsPerYear: 1,
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
          seasonUnit: '가을',
          seasonsPerYear: 2,
        ),
        FavoriteActivity(
          id: 'beach',
          name: '해변',
          emoji: '🏖️',
          maxAgeAvailable: 11,
          reason: '더위와 체력 부담',
          frequencyPerMonth: 1,
          seasonUnit: '여름',
          seasonsPerYear: 1,
        ),
        FavoriteActivity(
          id: 'dog_friends',
          name: '새 친구 사귀기',
          emoji: '🐕',
          maxAgeAvailable: 8,
          reason: '8세 이후 낯선 강아지에게 스트레스',
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
          seasonUnit: '캠핑 시즌',
          seasonsPerYear: 2,
        ),
        FavoriteActivity(
          id: 'snow_play',
          name: '눈놀이',
          emoji: '❄️',
          maxAgeAvailable: 10,
          reason: '추위에 관절 악화, 체온 조절 어려움',
          frequencyPerMonth: 1,
          seasonUnit: '겨울',
          seasonsPerYear: 1,
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
