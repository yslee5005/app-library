/// App Library UI Kit — reusable widgets for navigation, onboarding,
/// profile, and feed screens.
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
export 'src/feed/app_card.dart';
export 'src/feed/app_list_tile.dart';
export 'src/feed/detail_screen_layout.dart';
export 'src/feed/feed_list_view.dart';
