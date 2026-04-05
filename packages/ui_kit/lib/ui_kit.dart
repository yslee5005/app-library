/// App Library UI Kit — reusable widgets for navigation, onboarding,
/// profile, feed, search, forms, feedback, media, and data-viz screens.
///
/// Depends on `app_lib_theme` for design tokens. All widgets use theme
/// tokens from the current [ThemeData] — never hardcode colors or spacing.
library;

// ── Navigation / Layout ────────────────────────────────────────────
export 'src/navigation/app_bottom_nav_bar.dart';
export 'src/navigation/app_drawer_menu.dart';
export 'src/navigation/app_shell.dart';
export 'src/navigation/app_tab_layout.dart';

// ── Onboarding / Auth ──────────────────────────────────────────────
export 'src/onboarding/forgot_password_form.dart';
export 'src/onboarding/login_form.dart';
export 'src/onboarding/onboarding_carousel.dart';
export 'src/onboarding/sign_up_form.dart';

// ── Profile / Settings ─────────────────────────────────────────────
export 'src/profile/language_picker_tile.dart';
export 'src/profile/profile_edit_form.dart';
export 'src/profile/profile_header.dart';
export 'src/profile/settings_screen.dart';
export 'src/profile/theme_switch_tile.dart';

// ── Feed / List / Detail ───────────────────────────────────────────
export 'src/feed/bento_grid.dart';
export 'src/feed/app_card.dart';
export 'src/feed/app_list_tile.dart';
export 'src/feed/detail_screen_layout.dart';
export 'src/feed/feed_list_view.dart';

// ── Search / Filter ────────────────────────────────────────────────
export 'src/search/app_search_bar.dart';
export 'src/search/chip_filter_bar.dart';
export 'src/search/filter_bottom_sheet.dart';
export 'src/search/sort_selector.dart';

// ── Input / Forms ──────────────────────────────────────────────────
export 'src/forms/app_button.dart';
export 'src/forms/app_date_time_picker.dart';
export 'src/forms/app_image_picker.dart';
export 'src/forms/app_rating_bar.dart';
export 'src/forms/app_text_field.dart';
export 'src/forms/form_section.dart';

// ── Feedback / State ───────────────────────────────────────────────
export 'src/feedback/app_dialog.dart';
export 'src/feedback/app_toast.dart';
export 'src/feedback/badge_widget.dart';
export 'src/feedback/empty_state_view.dart';
export 'src/feedback/error_state_view.dart';
export 'src/feedback/shimmer_widget.dart';
export 'src/feedback/skeleton_loader.dart';

// ── Media / Content ────────────────────────────────────────────────
export 'src/media/app_avatar.dart';
export 'src/media/app_cached_image.dart';
export 'src/media/expandable_text.dart';
export 'src/media/image_carousel.dart';

// ── Data Visualization ─────────────────────────────────────────────
export 'src/data_viz/app_progress_bar.dart';
export 'src/data_viz/heatmap_calendar.dart';
export 'src/data_viz/stat_card.dart';
