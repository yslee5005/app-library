import 'daily_routine.dart';

class PetProfile {
  final String name;
  final String breedId;
  final DateTime birthDate;
  final double weightKg;
  final bool neutered;
  final List<DailyRoutine> routines;
  final DateTime createdAt;

  const PetProfile({
    required this.name,
    required this.breedId,
    required this.birthDate,
    required this.weightKg,
    this.neutered = false,
    required this.routines,
    required this.createdAt,
  });

  /// Age in years (fractional)
  double get ageYears {
    final now = DateTime.now();
    final diff = now.difference(birthDate);
    return diff.inDays / 365.25;
  }

  /// Age as display string
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
    DateTime? createdAt,
  }) {
    return PetProfile(
      name: name ?? this.name,
      breedId: breedId ?? this.breedId,
      birthDate: birthDate ?? this.birthDate,
      weightKg: weightKg ?? this.weightKg,
      neutered: neutered ?? this.neutered,
      routines: routines ?? this.routines,
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
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
