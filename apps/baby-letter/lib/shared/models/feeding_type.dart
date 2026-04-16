/// 수유 방식 — Layer 2 프로파일링
enum FeedingType {
  breastfeeding('모유수유'),
  formula('분유'),
  mixed('혼합수유');

  final String label;
  const FeedingType(this.label);
}

/// 아기 성별
enum BabyGender {
  male('남아'),
  female('여아'),
  unspecified('선택안함');

  final String label;
  const BabyGender(this.label);
}
