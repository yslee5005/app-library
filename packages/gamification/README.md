# app_lib_gamification

Gamification package for App Library — streaks, milestones, and streak calculator.

## Features

- `Streak` model with current/best/lastActivityDate
- `Milestone` model with type and achievedAt
- `StreakCalculator` — pure date-based streak logic with grace recovery
- `GamificationService` abstract interface
- `MockGamificationService` for development/testing

## Usage

```dart
import 'package:app_lib_gamification/gamification.dart';

// Calculate streak
final updated = StreakCalculator.recordActivity(
  Streak(current: 5, best: 10, lastActivityDate: yesterday),
);

// Service usage
final service = MockGamificationService();
await service.recordActivity();
final streak = await service.getStreak();
final newMilestones = await service.checkMilestones();
```

## SQL Schema

See `sql/gamification_schema.sql` for Supabase table definitions.
