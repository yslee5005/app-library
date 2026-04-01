# Ralph Development Instructions — App Library Phase 5: UI Kit (Navigation, Onboarding, Profile, Feed)

## Context
You are Ralph, an autonomous AI development agent working on the **app-library** monorepo.

Read CLAUDE.md. All infrastructure packages are complete. Now building UI components.

## Current Objectives

Create packages/ui_kit/ with categories A-D (17 widgets).
This is a Flutter package — use `flutter test` for testing.

### Setup
- [ ] Create packages/ui_kit/ with pubspec.yaml (depends on app_lib_core + app_lib_theme + flutter, resolution: workspace)
- [ ] Create analysis_options.yaml inheriting from root

### Category A: Navigation/Layout
- [ ] A1: AppShell widget — Scaffold with configurable BottomNavigationBar + body + optional AppBar + optional Drawer. Takes list of AppShellTab(icon, label, body).
- [ ] A2: AppBottomNavBar widget — Custom bottom navigation with icon, label, optional badge count. Callback onTap(index).
- [ ] A3: AppDrawerMenu widget — Side drawer with header (avatar+name) + list of DrawerMenuItem(icon, label, onTap).
- [ ] A4: AppTabLayout widget — TabBar + TabBarView wrapper. Takes list of AppTab(label, icon, body).

### Category B: Onboarding/Auth Screens
- [ ] B1: OnboardingCarousel widget — PageView with pages(image, title, subtitle) + page indicator + skip/next buttons.
- [ ] B2: LoginForm widget — Email field + password field + login button + social login buttons row + forgot password link. Callbacks: onLogin, onGoogleLogin, onAppleLogin, onForgotPassword.
- [ ] B3: SignUpForm widget — Name + email + password + confirm password + sign up button. Callback: onSignUp.
- [ ] B4: ForgotPasswordForm widget — Email field + submit button. Callback: onSubmit.

### Category C: Profile/Settings
- [ ] C1: ProfileHeader widget — Circular avatar + display name + bio text + stats row (followers, following, posts counts).
- [ ] C2: ProfileEditForm widget — Avatar picker + name field + bio field + save button. Callback: onSave.
- [ ] C3: SettingsScreen widget — ListView of SettingsSection(title, items). SettingsItem types: toggle, navigation, select.
- [ ] C4: ThemeSwitchTile widget — ListTile with dark mode toggle switch. Callback: onChanged(bool).
- [ ] C5: LanguagePickerTile widget — ListTile showing current language, taps to show picker dialog.

### Category D: Feed/List/Detail
- [ ] D1: FeedListView widget — ListView.builder with pull-to-refresh + load more indicator at bottom. Takes itemBuilder + onLoadMore + onRefresh.
- [ ] D2: AppCard widget — Card with optional image, title, subtitle, trailing action. Configurable: horizontal/vertical layout.
- [ ] D3: AppListTile widget — Leading icon/avatar + title + subtitle + trailing widget (arrow, badge, etc).
- [ ] D4: DetailScreenLayout widget — SliverAppBar with hero image + scrollable body content + bottom action bar.

### Finalize
- [ ] Create ui_kit.dart barrel export (export all widgets)
- [ ] Write widget tests for key widgets (AppShell, OnboardingCarousel, AppCard, FeedListView)
- [ ] Run `flutter analyze` — 0 issues
- [ ] Git commit: "feat: add ui_kit package — navigation, onboarding, profile, feed widgets"

## Widget Design Rules
- All widgets use theme tokens from app_lib_theme (never hardcode colors/spacing)
- All widgets are stateless where possible (state managed by parent)
- All callbacks are required or optional named parameters
- Use const constructors
- Material 3 design language
- No hardcoded strings (pass text as parameters)

## Protected Files (DO NOT MODIFY)
- .ralph/, .ralphrc, all existing packages, specs/, supabase/

## Boundaries
### Always
- Use theme tokens (AppColors, AppSpacing, AppRadius) not hardcoded values
- Run flutter analyze after completion
- Git commit when done
### Never
- git push, rm -rf, .env modification, delete existing code
- Hardcode colors, padding, or text strings

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
