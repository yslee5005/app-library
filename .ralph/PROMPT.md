# Ralph Development Instructions — Showcase App: Component-Level Navigation

## Context
You are Ralph working on **app-library** monorepo.
Read CLAUDE.md and .claude/rules/flutter-layout.md for layout rules.

The showcase app (apps/showcase/) already exists and runs. Currently each category (Navigation, Onboarding, etc.) shows all widgets mixed together on one screen.

## Objective
Refactor ALL 9 category demo screens so each shows a **list of component names** → tapping one opens a **dedicated demo screen** for that single component.

## Architecture Pattern

For EACH category, create this structure:
```
features/{category}/
├── view/{category}_demo.dart          ← Component list (names + descriptions)
└── view/demos/
    ├── {widget1}_demo.dart            ← Individual demo screen
    ├── {widget2}_demo.dart
    └── ...
```

### Example: Onboarding category

**onboarding_demo.dart** (REPLACE existing — becomes a list):
```dart
class OnboardingDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Onboarding')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.swipe),
            title: Text('OnboardingCarousel'),
            subtitle: Text('Swipeable pages with indicator'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => OnboardingCarouselDemo(),
            )),
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('LoginForm'),
            subtitle: Text('Email + password + social login'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => LoginFormDemo(),
            )),
          ),
          // ... more components
        ],
      ),
    );
  }
}
```

**demos/onboarding_carousel_demo.dart** (individual demo):
```dart
class OnboardingCarouselDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OnboardingCarousel')),
      body: OnboardingCarousel(
        pages: SampleData.onboardingPages.map((p) => OnboardingPage(
          title: p['title']!,
          subtitle: p['subtitle']!,
        )).toList(),
        onComplete: () => Navigator.pop(context),
      ),
    );
  }
}
```

## Checklist — ALL 9 categories

### 1. Navigation (4 widgets)
- [ ] Create features/navigation/view/demos/ directory
- [ ] app_shell_demo.dart — Full AppShell with 3 tabs + bottom nav
- [ ] bottom_nav_bar_demo.dart — Standalone bottom nav switching content
- [ ] drawer_menu_demo.dart — Drawer with sample menu items
- [ ] tab_layout_demo.dart — TabBar with 3 tabs
- [ ] Update navigation_demo.dart → list of 4 components with ListTile navigation

### 2. Onboarding (4 widgets)
- [ ] Create features/onboarding/view/demos/
- [ ] onboarding_carousel_demo.dart — 3 sample pages carousel
- [ ] login_form_demo.dart — Login form with all fields
- [ ] sign_up_form_demo.dart — Sign up form
- [ ] forgot_password_form_demo.dart — Forgot password form
- [ ] Update onboarding_demo.dart → list of 4 components

### 3. Profile (5 widgets)
- [ ] Create features/profile/view/demos/
- [ ] profile_header_demo.dart — Sample profile header with stats
- [ ] profile_edit_form_demo.dart — Editable profile form
- [ ] settings_screen_demo.dart — Settings with sections
- [ ] theme_switch_tile_demo.dart — Dark mode toggle
- [ ] language_picker_tile_demo.dart — Language selector
- [ ] Update profile_demo.dart → list of 5 components

### 4. Feed (4 widgets)
- [ ] Create features/feed/view/demos/
- [ ] feed_list_view_demo.dart — Infinite scroll feed with sample cards
- [ ] app_card_demo.dart — Card variants (vertical, horizontal, with/without image)
- [ ] app_list_tile_demo.dart — ListTile variants
- [ ] detail_screen_layout_demo.dart — Detail screen with hero image
- [ ] Update feed_demo.dart → list of 4 components

### 5. Search (4 widgets)
- [ ] Create features/search/view/demos/
- [ ] search_bar_demo.dart — Search bar with debounced results
- [ ] filter_bottom_sheet_demo.dart — Filter sheet with options
- [ ] sort_selector_demo.dart — Sort dropdown
- [ ] chip_filter_bar_demo.dart — Horizontal chip filters
- [ ] Update search_demo.dart → list of 4 components

### 6. Forms (6 widgets)
- [ ] Create features/forms/view/demos/
- [ ] app_text_field_demo.dart — TextField variants (normal, password, error)
- [ ] app_button_demo.dart — Button variants (primary, secondary, outline, loading)
- [ ] form_section_demo.dart — Form with sections
- [ ] date_time_picker_demo.dart — Date/time picker
- [ ] image_picker_demo.dart — Image selection
- [ ] rating_bar_demo.dart — Star rating input
- [ ] Update forms_demo.dart → list of 6 components

### 7. Feedback (7 widgets)
- [ ] Create features/feedback/view/demos/
- [ ] skeleton_loader_demo.dart — Skeleton placeholder
- [ ] shimmer_widget_demo.dart — Shimmer effect
- [ ] empty_state_view_demo.dart — Empty state with icon and action
- [ ] error_state_view_demo.dart — Error state with retry
- [ ] app_dialog_demo.dart — Dialog variants (success, error, confirm)
- [ ] app_toast_demo.dart — Toast/snackbar variants
- [ ] badge_widget_demo.dart — Badge on icons
- [ ] Update feedback_demo.dart → list of 7 components

### 8. Media (4 widgets)
- [ ] Create features/media/view/demos/
- [ ] app_cached_image_demo.dart — Cached image with placeholder
- [ ] image_carousel_demo.dart — Image slider
- [ ] app_avatar_demo.dart — Avatar sizes (sm, md, lg) with image and initials
- [ ] expandable_text_demo.dart — Show more/less text
- [ ] Update media_demo.dart → list of 4 components

### 9. Charts (3 widgets)
- [ ] Create features/charts/view/demos/
- [ ] stat_card_demo.dart — Stat cards with trend indicators
- [ ] app_progress_bar_demo.dart — Linear and circular progress
- [ ] heatmap_calendar_demo.dart — GitHub-style heatmap
- [ ] Update charts_demo.dart → list of 3 components

### Final
- [ ] flutter analyze — 0 errors
- [ ] Git commit: "feat: refactor showcase — component-level navigation for all 9 categories"

## CRITICAL Layout Rules (from .claude/rules/flutter-layout.md)
- **NEVER** use ListView inside another scrollable without shrinkWrap
- **Forms**: use SingleChildScrollView + Column, NOT ListView
- **Individual demo screens**: Scaffold body is bounded, so ListView is OK there
- **List screens**: ListView with ListTile is fine (direct Scaffold child)

## Sample Data
Import from `sample_data/sample_data.dart` for demo content.

## Widget Imports
Import widgets from `package:app_lib_ui_kit/ui_kit.dart`.
Use Navigator.push with MaterialPageRoute for demo navigation (not go_router for sub-screens).

## Protected Files (DO NOT MODIFY)
- .ralph/, .ralphrc, packages/, specs/, templates/, supabase/
- Do NOT modify any ui_kit widget source code — only modify apps/showcase/

## Boundaries
### Always
- Each demo screen: Scaffold with AppBar showing widget name
- Use theme tokens (never hardcode colors)
- Run flutter analyze before committing
### Never
- git push, rm -rf, modify packages/
- Use ListView in unbounded parent (use SingleChildScrollView+Column for forms)

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
When ALL 9 categories refactored → EXIT_SIGNAL: true, STATUS: COMPLETE.
