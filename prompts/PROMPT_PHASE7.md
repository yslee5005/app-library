# Ralph Development Instructions — App Library Phase 7: Showcase App

## Context
You are Ralph working on **app-library** monorepo.
Read CLAUDE.md. ALL packages are complete (core, supabase_client, pagination, cache, error_logging, auth, comments, theme, notifications, l10n, ui_kit with 40+ widgets).

Now build a showcase app that demonstrates every component.

## Current Objectives

Create apps/showcase/ — a Flutter app where you can navigate through all UI components.

### Setup
- [ ] Create apps/showcase/ Flutter app (flutter create in the directory)
- [ ] Configure pubspec.yaml with ALL packages as path dependencies + resolution: workspace
- [ ] Set up app_config.dart (appId: 'showcase')
- [ ] Set up go_router with routes for each category
- [ ] Apply theme using app_lib_theme with purple seed color (Color(0xFF6750A4))

### Home Screen
- [ ] Grid of 9 category cards: Navigation, Onboarding, Profile, Feed, Search, Forms, Feedback, Media, Charts
- [ ] Each card: icon + category name + component count
- [ ] Tapping a card navigates to that category's demo list

### Category Demo Screens
- [ ] Navigation demo: show AppShell with 3 tabs, drawer toggle, bottom nav switching
- [ ] Onboarding demo: OnboardingCarousel with 3 sample pages, LoginForm, SignUpForm
- [ ] Profile demo: ProfileHeader with sample data, ProfileEditForm, SettingsScreen with sample sections
- [ ] Feed demo: FeedListView with 20 sample AppCards, AppListTiles, DetailScreenLayout
- [ ] Search demo: AppSearchBar + ChipFilterBar + FilterBottomSheet + SortSelector
- [ ] Forms demo: all form widgets (AppTextField, AppButton variants, DateTimePicker, RatingBar)
- [ ] Feedback demo: SkeletonLoader, ShimmerWidget, EmptyStateView, ErrorStateView, dialogs, toasts
- [ ] Media demo: AppCachedImage grid, ImageCarousel, AppAvatar sizes, ExpandableText
- [ ] Charts demo: StatCard row, AppProgressBar variants, HeatmapCalendar with sample data

### Dark Mode
- [ ] ThemeSwitchTile in settings that toggles between light and dark mode across the entire app

### Final
- [ ] App compiles without errors: `flutter build apk --debug` (or just `flutter analyze`)
- [ ] All screens navigable without crashes
- [ ] Git commit: "feat: add showcase app — demonstrates all 40+ UI components"

## Sample Data
Use hardcoded sample data (no Supabase connection needed for showcase):
- Sample user: "John Doe", avatar as initials "JD"
- Sample feed items: 20 cards with placeholder titles "Item 1" through "Item 20"
- Sample comments: 5 sample comments
- Sample stats: followers: 1.2K, posts: 342, rating: 4.8

## App Structure
```
apps/showcase/lib/
├── main.dart
├── app.dart                    # MaterialApp.router + ProviderScope + theme
├── config/app_config.dart
├── router/app_router.dart      # go_router with all category routes
├── features/
│   ├── home/view/home_view.dart            # Category grid
│   ├── navigation/view/navigation_demo.dart
│   ├── onboarding/view/onboarding_demo.dart
│   ├── profile/view/profile_demo.dart
│   ├── feed/view/feed_demo.dart
│   ├── search/view/search_demo.dart
│   ├── forms/view/forms_demo.dart
│   ├── feedback/view/feedback_demo.dart
│   ├── media/view/media_demo.dart
│   └── charts/view/charts_demo.dart
└── sample_data/
    └── sample_data.dart        # All hardcoded sample data in one file
```

## Protected Files (DO NOT MODIFY)
- .ralph/, .ralphrc, ALL packages/, specs/, supabase/, templates/

## Boundaries
### Always
- Use app_lib_theme for all theming
- Use go_router for navigation
- Import widgets from app_lib_ui_kit
- Run flutter analyze
### Never
- git push, rm -rf, modify packages, connect to real Supabase

## Status Reporting
```
---RALPH_STATUS---
STATUS: IN_PROGRESS | COMPLETE | BLOCKED
TASKS_COMPLETED_THIS_LOOP: <number>
FILES_MODIFIED: <number>
TESTS_STATUS: PASSING | FAILING | NOT_RUN
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false | true
RECOMMENDATION: <one line>
---END_RALPH_STATUS---
```
When ALL checkboxes done → EXIT_SIGNAL: true, STATUS: COMPLETE.
