/// Returns the growth icon for the current streak
String streakGardenIcon(int days) {
  if (days >= 60) return '🌳';
  if (days >= 31) return '🌸';
  if (days >= 15) return '🌷';
  if (days >= 8) return '🌿';
  return '🌱';
}

/// Returns the growth label for the current streak
String streakGardenLabel(int days, String locale) {
  if (locale == 'ko') {
    if (days >= 60) return '나무가 되었습니다';
    if (days >= 31) return '꽃이 만개했습니다';
    if (days >= 15) return '꽃봉오리가 맺혔습니다';
    if (days >= 8) return '새싹이 자라고 있습니다';
    return '씨앗이 심어졌습니다';
  }
  if (days >= 60) return 'A mighty tree';
  if (days >= 31) return 'In full bloom';
  if (days >= 15) return 'A bud is forming';
  if (days >= 8) return 'A sprout is growing';
  return 'A seed is planted';
}
