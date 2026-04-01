# Ralph Development Instructions — App Library Phase 6: UI Kit (Search, Forms, Feedback, Media, Charts)

## Context
You are Ralph working on **app-library** monorepo.
Read CLAUDE.md. packages/ui_kit/ already exists with categories A-D.
Now adding categories E-I to the SAME ui_kit package.

## Current Objectives

Add widgets to existing packages/ui_kit/ — categories E-I (19 widgets).

### Category E: Search/Filter
- [ ] E1: AppSearchBar widget — TextField with search icon, clear button, debounced onChanged callback (300ms).
- [ ] E2: FilterBottomSheet widget — ModalBottomSheet with sections of filter options (checkboxes, range slider, chips). Callback: onApply(FilterState).
- [ ] E3: SortSelector widget — DropdownButton or popup menu with sort options. Callback: onSortChanged(SortOption).
- [ ] E4: ChipFilterBar widget — Horizontal scrollable row of FilterChip. Callback: onSelectionChanged(Set<String>).

### Category F: Input/Forms
- [ ] F1: AppTextField widget — TextFormField with label, hint, error text, prefix/suffix icon, obscure toggle for passwords.
- [ ] F2: AppButton widget — ElevatedButton/OutlinedButton/TextButton with loading state, disabled state. Variants: primary, secondary, outline, text.
- [ ] F3: FormSection widget — Column with section title + list of form fields + optional description text.
- [ ] F4: AppDateTimePicker widget — Tap to show date/time picker dialog. Displays selected value. Callback: onChanged(DateTime).
- [ ] F5: AppImagePicker widget — Tap to show camera/gallery choice. Displays selected image thumbnail. Callback: onImageSelected(File).
- [ ] F6: AppRatingBar widget — Row of star icons, tappable for input or read-only for display. Callback: onRatingChanged(double).

### Category G: Feedback/State
- [ ] G1: SkeletonLoader widget — Animated placeholder mimicking content layout. Takes child shape (rectangle, circle, text lines).
- [ ] G2: ShimmerWidget widget — Shimmer animation overlay. Wraps any child widget.
- [ ] G3: EmptyStateView widget — Centered icon + title + subtitle + optional action button.
- [ ] G4: ErrorStateView widget — Centered error icon + message + retry button. Callback: onRetry.
- [ ] G5: AppDialog widget — Configurable dialog: title, content, primary/secondary actions. Variants: success, error, confirm.
- [ ] G6: AppToast widget — Static method to show snackbar/toast. Variants: success, error, info, warning.
- [ ] G7: BadgeWidget widget — Small badge overlay on any widget. Shows count number or dot.

### Category H: Media/Content
- [ ] H1: AppCachedImage widget — Image.network with placeholder, error widget, and fade-in animation. Uses cached_network_image pattern.
- [ ] H2: ImageCarousel widget — PageView of images with page indicator dots. Optional auto-play.
- [ ] H3: AppAvatar widget — CircleAvatar with image URL fallback to initials. Configurable size (sm, md, lg).
- [ ] H4: ExpandableText widget — Text with "Show more"/"Show less" toggle. maxLines parameter.

### Category I: Data Visualization
- [ ] I1: StatCard widget — Card showing big number + label + optional trend indicator (up/down arrow + percentage).
- [ ] I2: AppProgressBar widget — Linear or circular progress indicator with label and percentage text.
- [ ] I3: HeatmapCalendar widget — Grid of colored cells representing activity over time (GitHub contribution style). Takes Map<DateTime, int>.

### Finalize
- [ ] Update ui_kit.dart barrel export with all new widgets
- [ ] Write widget tests for AppSearchBar, AppButton, EmptyStateView, AppAvatar
- [ ] Run `flutter analyze` — 0 issues
- [ ] Git commit: "feat: add ui_kit search, forms, feedback, media, charts widgets"

## Widget Design Rules
- Use theme tokens from app_lib_theme (never hardcode)
- Stateless where possible
- All text passed as parameters (no hardcoded strings)
- const constructors
- Material 3

## Protected Files (DO NOT MODIFY)
- .ralph/, .ralphrc, all existing packages except ui_kit additions, specs/, supabase/
- DO NOT modify existing ui_kit widgets from Phase 5

## Boundaries
### Always
- Theme tokens only, run flutter analyze, git commit
### Never
- git push, rm -rf, delete existing code, hardcode values

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
