import 'daily_routine.dart';
import 'favorite_activity.dart';

class PetProfile {
  final String name;
  final String breedId;
  final DateTime birthDate;
  final double weightKg;
  final bool neutered;
  final List<DailyRoutine> routines;
  final List<FavoriteActivity> favoriteActivities;
  final Map<String, DateTime> lastActivityDates; // activityId → last done date
  final DateTime createdAt;

  const PetProfile({
    required this.name,
    required this.breedId,
    required this.birthDate,
    required this.weightKg,
    this.neutered = false,
    required this.routines,
    this.favoriteActivities = const [],
    this.lastActivityDates = const {},
    required this.createdAt,
  });

  double get ageYears {
    final now = DateTime.now();
    final diff = now.difference(birthDate);
    return diff.inDays / 365.25;
  }

  String get ageDisplay {
    final years = ageYears;
    if (years < 1) {
      final months = (years * 12).round();
      return '$months개월';
    }
    return '${years.floor()}세';
  }

  PetProfile copyWith({
    String? name,
    String? breedId,
    DateTime? birthDate,
    double? weightKg,
    bool? neutered,
    List<DailyRoutine>? routines,
    List<FavoriteActivity>? favoriteActivities,
    Map<String, DateTime>? lastActivityDates,
    DateTime? createdAt,
  }) {
    return PetProfile(
      name: name ?? this.name,
      breedId: breedId ?? this.breedId,
      birthDate: birthDate ?? this.birthDate,
      weightKg: weightKg ?? this.weightKg,
      neutered: neutered ?? this.neutered,
      routines: routines ?? this.routines,
      favoriteActivities: favoriteActivities ?? this.favoriteActivities,
      lastActivityDates: lastActivityDates ?? this.lastActivityDates,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'breedId': breedId,
      'birthDate': birthDate.toIso8601String(),
      'weightKg': weightKg,
      'neutered': neutered,
      'routines': routines.map((r) => r.toJson()).toList(),
      'favoriteActivities': favoriteActivities.map((a) => a.toJson()).toList(),
      'lastActivityDates': lastActivityDates.map(
        (k, v) => MapEntry(k, v.toIso8601String()),
      ),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PetProfile.fromJson(Map<String, dynamic> json) {
    return PetProfile(
      name: json['name'] as String,
      breedId: json['breedId'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      weightKg: (json['weightKg'] as num).toDouble(),
      neutered: json['neutered'] as bool? ?? false,
      routines: (json['routines'] as List<dynamic>)
          .map((e) => DailyRoutine.fromJson(e as Map<String, dynamic>))
          .toList(),
      favoriteActivities: (json['favoriteActivities'] as List<dynamic>?)
              ?.map((e) => FavoriteActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastActivityDates: (json['lastActivityDates'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, DateTime.parse(v as String))) ??
          {},
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
