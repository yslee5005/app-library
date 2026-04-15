import '../l10n/generated/app_localizations.dart';

/// Returns the growth icon for the current streak
String streakGardenIcon(int days) {
  if (days >= 100) return '🌲🌳🌲';
  if (days >= 60) return '🌳';
  if (days >= 31) return '🌸';
  if (days >= 15) return '🌷';
  if (days >= 8) return '🌿';
  return '🌱';
}

/// Returns the growth label for the current streak using l10n
String streakGardenLabel(int days, AppLocalizations l10n) {
  if (days >= 100) return l10n.gardenForest;
  if (days >= 60) return l10n.gardenTree;
  if (days >= 31) return l10n.gardenBloom;
  if (days >= 15) return l10n.gardenBud;
  if (days >= 8) return l10n.gardenSprout;
  return l10n.gardenSeed;
}
