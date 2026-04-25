/// 사용자 상태 — 임신 중 / 출산 후 분기 핵심
enum UserMode {
  pregnant, // 임신 중
  postnatal, // 출산 후
}

/// 온보딩 완료 여부 + 유저 모드 관리
class UserState {
  final bool onboardingCompleted;
  final UserMode? mode;
  final DateTime? dueDate; // 출산예정일 (임신 중)
  final DateTime? birthDate; // 출생일 (출산 후)
  final String? babyName;
  final String? nickname; // 태명 (임신 중)

  const UserState({
    this.onboardingCompleted = false,
    this.mode,
    this.dueDate,
    this.birthDate,
    this.babyName,
    this.nickname,
  });

  /// 현재 임신 주차 계산 (임신 중)
  int? get currentWeek {
    if (mode != UserMode.pregnant || dueDate == null) return null;
    final now = DateTime.now();
    final conception = dueDate!.subtract(const Duration(days: 280));
    final diff = now.difference(conception).inDays;
    return (diff / 7).floor();
  }

  /// 출생 후 일수 계산 (출산 후)
  int? get daysSinceBirth {
    if (mode != UserMode.postnatal || birthDate == null) return null;
    return DateTime.now().difference(birthDate!).inDays;
  }

  /// 표시용 텍스트
  String get displayAge {
    if (mode == UserMode.pregnant) {
      final week = currentWeek;
      if (week == null) return '';
      final day =
          (DateTime.now()
              .difference(dueDate!.subtract(const Duration(days: 280)))
              .inDays %
          7);
      return '$week주 $day일';
    } else if (mode == UserMode.postnatal) {
      final days = daysSinceBirth;
      if (days == null) return '';
      if (days < 30) return 'D+$days';
      final months = days ~/ 30;
      final remainDays = days % 30;
      return '$months개월 $remainDays일';
    }
    return '';
  }

  UserState copyWith({
    bool? onboardingCompleted,
    UserMode? mode,
    DateTime? dueDate,
    DateTime? birthDate,
    String? babyName,
    String? nickname,
  }) {
    return UserState(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      mode: mode ?? this.mode,
      dueDate: dueDate ?? this.dueDate,
      birthDate: birthDate ?? this.birthDate,
      babyName: babyName ?? this.babyName,
      nickname: nickname ?? this.nickname,
    );
  }
}
