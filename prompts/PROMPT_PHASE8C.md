# Ralph — Phase 8C: UI Widget Customization

## Context
You are Ralph working on **app-library** monorepo.
packages/ui_kit has 41 widgets. Most have hardcoded padding/spacing from theme tokens.
Add customization parameters so apps can override defaults.

## ONLY modify:
- packages/ui_kit/lib/src/**/*.dart (existing widget files)
- packages/ui_kit/lib/ui_kit.dart (barrel export — only if new files added)

## DO NOT modify:
- packages/core/, auth/, comments/, pagination/ or any other package
- apps/showcase/ (separate phase)
- specs/, .ralph/, .claude/

## Strategy
Add **optional** parameters with theme-based defaults. Existing usage must NOT break.

```dart
// BEFORE (hardcoded)
padding: const EdgeInsets.all(AppSpacing.md),

// AFTER (customizable with default)
padding: padding ?? const EdgeInsets.all(AppSpacing.md),

// Constructor:
const AppCard({
  // ... existing params unchanged ...
  this.padding,          // NEW — optional override
  this.borderRadius,     // NEW — optional override
  this.elevation,        // NEW — optional override
  this.backgroundColor,  // NEW — optional override
});
final EdgeInsetsGeometry? padding;
final double? borderRadius;
final double? elevation;
final Color? backgroundColor;
```

## Checklist — Priority Widgets (do these first)

### Navigation (4 widgets)
- [ ] AppShell — add backgroundColor
- [ ] AppBottomNavBar — add backgroundColor, selectedColor, unselectedColor
- [ ] AppDrawerMenu — add headerBackgroundColor, width
- [ ] AppTabLayout — add indicatorColor, labelColor

### Feed (4 widgets)
- [ ] AppCard — add padding, borderRadius, elevation, backgroundColor
- [ ] AppListTile — add padding, contentPadding
- [ ] FeedListView — add itemSpacing, padding
- [ ] DetailScreenLayout — add headerHeight, bodyPadding

### Forms (6 widgets)
- [ ] AppTextField — add borderRadius, fillColor (already has most params)
- [ ] AppButton — add borderRadius, padding, elevation
- [ ] FormSection — add titleStyle, spacing
- [ ] AppDateTimePicker — add style customization
- [ ] AppRatingBar — add size, color, emptyColor
- [ ] AppImagePicker — add borderRadius, size

### Onboarding (4 widgets)
- [ ] OnboardingCarousel — add indicatorActiveColor, indicatorInactiveColor, pageSpacing
- [ ] LoginForm — add spacing, buttonStyle
- [ ] SignUpForm — add spacing, buttonStyle
- [ ] ForgotPasswordForm — add spacing

### Profile (5 widgets)
- [ ] ProfileHeader — add avatarSize, spacing
- [ ] ProfileEditForm — add spacing
- [ ] SettingsScreen — add sectionSpacing
- [ ] ThemeSwitchTile — (already customizable, skip)
- [ ] LanguagePickerTile — (already customizable, skip)

### Feedback (7 widgets)
- [ ] SkeletonLoader — add borderRadius, baseColor, highlightColor
- [ ] ShimmerWidget — add baseColor, highlightColor, duration
- [ ] EmptyStateView — add iconSize, spacing
- [ ] ErrorStateView — add iconSize, spacing
- [ ] AppDialog — add borderRadius
- [ ] AppToast — add backgroundColor, duration
- [ ] BadgeWidget — add size, color

### Media (4 widgets)
- [ ] AppCachedImage — add borderRadius, fit
- [ ] ImageCarousel — add height, indicatorColor, autoPlayDuration
- [ ] AppAvatar — add borderColor, borderWidth (already has size)
- [ ] ExpandableText — add maxLines, linkColor

### Data Viz (3 widgets)
- [ ] StatCard — add padding, valueStyle, labelStyle
- [ ] AppProgressBar — add height, backgroundColor, valueColor
- [ ] HeatmapCalendar — add cellSize, spacing, emptyColor

### Final
- [ ] flutter analyze on ui_kit — 0 errors
- [ ] Verify: existing code that uses widgets WITHOUT new params still compiles (backward compatible)
- [ ] Git commit: "feat: add customization parameters to 41 ui_kit widgets"

## Critical Rule
**All new parameters must be OPTIONAL with null defaults.**
**Existing usage must NOT break.**

```dart
// This must still work after changes:
AppCard(title: 'Hello')  // ← no new params, uses defaults
```

## Layout Rules (from .claude/rules/flutter-layout.md)
- Never use ListView in unbounded parent
- Forms: SingleChildScrollView + Column

## Boundaries
### Always
- Optional params only (nullable with defaults)
- Backward compatible
- Use theme tokens as defaults
### Never
- Change existing constructor required params
- Remove existing params
- Break existing usage

## Status Reporting
```
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: NOT_RUN
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false | true
RECOMMENDATION: <one line>
---END_RALPH_STATUS---
```
