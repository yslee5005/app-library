class BreedInfo {
  final String id;
  final String name;
  final String nameKo;
  final String? group;
  final String size;
  final RangeData? weightKg;
  final RangeData? heightCm;
  final LifespanData lifespanYears;
  final int seniorAge;
  final List<String>? temperament;
  final RangeData? exerciseMinutesPerDay;
  final String? groomingFrequency;
  final String? sheddingLevel;
  final List<HealthRisk> geneticHealthRisks;
  final List<AgeMilestone>? ageMilestones;
  final List<String>? funFacts;
  final String? dataConfidence;
  final String? dataNote;

  const BreedInfo({
    required this.id,
    required this.name,
    required this.nameKo,
    this.group,
    required this.size,
    this.weightKg,
    this.heightCm,
    required this.lifespanYears,
    required this.seniorAge,
    this.temperament,
    this.exerciseMinutesPerDay,
    this.groomingFrequency,
    this.sheddingLevel,
    this.geneticHealthRisks = const [],
    this.ageMilestones,
    this.funFacts,
    this.dataConfidence,
    this.dataNote,
  });

  factory BreedInfo.fromJson(Map<String, dynamic> json) {
    return BreedInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      nameKo: json['name_ko'] as String,
      group: json['group'] as String?,
      size: json['size'] as String,
      weightKg: json['weight_kg'] != null
          ? RangeData.fromJson(json['weight_kg'] as Map<String, dynamic>)
          : null,
      heightCm: json['height_cm'] != null
          ? RangeData.fromJson(json['height_cm'] as Map<String, dynamic>)
          : null,
      lifespanYears:
          LifespanData.fromJson(json['lifespan_years'] as Map<String, dynamic>),
      seniorAge: json['senior_age'] as int,
      temperament: (json['temperament'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      exerciseMinutesPerDay: json['exercise_minutes_per_day'] != null
          ? RangeData.fromJson(
              json['exercise_minutes_per_day'] as Map<String, dynamic>)
          : null,
      groomingFrequency: json['grooming_frequency'] as String?,
      sheddingLevel: json['shedding_level'] as String?,
      geneticHealthRisks: (json['genetic_health_risks'] as List<dynamic>?)
              ?.map((e) => HealthRisk.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ageMilestones: (json['age_milestones'] as List<dynamic>?)
          ?.map((e) => AgeMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      funFacts: (json['fun_facts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dataConfidence: json['data_confidence'] as String?,
      dataNote: json['data_note'] as String?,
    );
  }
}

class RangeData {
  final double min;
  final double max;

  const RangeData({required this.min, required this.max});

  factory RangeData.fromJson(Map<String, dynamic> json) {
    return RangeData(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
    );
  }
}

class LifespanData {
  final double min;
  final double max;
  final double median;

  const LifespanData({
    required this.min,
    required this.max,
    required this.median,
  });

  factory LifespanData.fromJson(Map<String, dynamic> json) {
    return LifespanData(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      median: (json['median'] as num).toDouble(),
    );
  }
}

class HealthRisk {
  final String condition;
  final String conditionKo;
  final int prevalencePercent;
  final String severity; // 'critical', 'high', 'moderate', 'low'
  final String source;
  final String? description;
  final String? prevention;

  const HealthRisk({
    required this.condition,
    required this.conditionKo,
    required this.prevalencePercent,
    required this.severity,
    required this.source,
    this.description,
    this.prevention,
  });

  factory HealthRisk.fromJson(Map<String, dynamic> json) {
    return HealthRisk(
      condition: json['condition'] as String,
      conditionKo: json['condition_ko'] as String,
      prevalencePercent: json['prevalence_percent'] as int,
      severity: json['severity'] as String,
      source: json['source'] as String,
      description: json['description'] as String?,
      prevention: json['prevention'] as String?,
    );
  }
}

class AgeMilestone {
  final double age;
  final String event;
  final String description;

  const AgeMilestone({
    required this.age,
    required this.event,
    required this.description,
  });

  factory AgeMilestone.fromJson(Map<String, dynamic> json) {
    return AgeMilestone(
      age: (json['age'] as num).toDouble(),
      event: json['event'] as String,
      description: json['description'] as String,
    );
  }
}
