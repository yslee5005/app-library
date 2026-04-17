# Abba QA Checklist

> Generated: 2026-04-17
> Scope: All view files, providers, navigation, data sync, edge cases

---

## A) FUNCTIONALITY — Element-Level Verification

### /welcome — WelcomeView

- [ ] /welcome — [Get Started button] → Navigate to /home — STATUS: **implemented**
- [ ] /welcome — [Logo/emoji render] → 🌿 emoji inside circle renders correctly — STATUS: **needs testing**
- [ ] /welcome — [l10n text] → welcomeTitle, welcomeSubtitle, getStarted all display — STATUS: **implemented**
- [ ] /welcome — First launch detection → Welcome should only show on first launch, but no first-launch check exists (initialLocation is /home, /welcome route exists but is never auto-shown) — STATUS: **not wired**

### /login — LoginView

- [ ] /login — [Sign in with Apple] → Calls authNotifier.signInWithApple() → navigates /home — STATUS: **implemented**
- [ ] /login — [Sign in with Google] → Calls authNotifier.signInWithGoogle() → navigates /home — STATUS: **implemented**
- [ ] /login — [Sign in with Email] → Opens email/password dialog → signs in → /home — STATUS: **implemented**
- [ ] /login — [Email dialog validation] → Requires non-empty email and password >= 6 chars — STATUS: **implemented**
- [ ] /login — [Error handling] → Shows SnackBar on auth failure — STATUS: **implemented**
- [ ] /login — Router redirect → `/login` route redirects to `/home` (bypassed by Anonymous-First) — STATUS: **implemented**

### /home — HomeView (Prayer Tab)

- [ ] /home — [Prayer/QT tab toggle] → Switches between prayer and QT tab content — STATUS: **implemented**
- [ ] /home — [Tab toggle disabled during prayer] → Cannot switch tabs while _isPraying is true — STATUS: **implemented**
- [ ] /home — [History button (clock icon)] → Navigates to /home/my-records — STATUS: **implemented**
- [ ] /home — [Start Prayer button] → Starts prayer recording with timer and pulse animation — STATUS: **implemented**
- [ ] /home — [Free user limit check] → Shows premium prompt when todayCount >= 1 and not premium — STATUS: **implemented**
- [ ] /home — [todayPrayerCountProvider increment] → Increments on prayer start — STATUS: **implemented**
- [ ] /home — [Streak status message] → Shows 🔥/😴/🌱 based on streak and heatmap data — STATUS: **implemented**
- [ ] /home — [Prayer heatmap card] → Renders PrayerHeatmap widget with responsive cell size — STATUS: **implemented**
- [ ] /home — [Pulse animation] → Animates while recording, stops on pause — STATUS: **implemented**
- [ ] /home — [Timer display] → Shows MM:SS format, increments every second, pauses when _isPaused — STATUS: **implemented**
- [ ] /home — [Text mode toggle] → Switches between STT mic and text input — STATUS: **implemented**
- [ ] /home — [Pause/Resume button] → Toggles _isPaused, stops/resumes STT and pulse — STATUS: **implemented**
- [ ] /home — [Finish Prayer button] → Shows confirmation dialog — STATUS: **implemented**
- [ ] /home — [Finish confirmation → Yes] → Saves transcript, navigates to /home/ai-loading — STATUS: **implemented**
- [ ] /home — [Finish confirmation → No (Resume)] → Dismisses dialog, continues prayer — STATUS: **implemented**
- [ ] /home — [STT error fallback] → Auto-switches to text mode on STT error — STATUS: **implemented**
- [ ] /home — [STT locale mapping] → Maps app locale to STT locale (ko→ko_KR, ja→ja_JP, etc.) — STATUS: **partial** (only 5 locales mapped; 35 locales supported by app)

### /home — HomeView (QT Tab)

- [ ] /home — [QT tab content] → Shows 📖 emoji, message, streak card, and QT button — STATUS: **implemented**
- [ ] /home — [QT button] → Navigates to /home/qt — STATUS: **implemented**
- [ ] /home — [Streak card] → Shows garden icon, streak days, best streak from userProfile — STATUS: **implemented**

### /home/qt — QtView

- [ ] /home/qt — [Today's date] → Shows formatted date in user locale — STATUS: **implemented**
- [ ] /home/qt — [Passage cards] → 5 QT passages displayed with staggered reveal animation — STATUS: **implemented**
- [ ] /home/qt — [Card tap → select/deselect] → Toggles card selection, dims others — STATUS: **implemented**
- [ ] /home/qt — [Select prompt] → Shows "select a passage" text after all revealed — STATUS: **implemented**
- [ ] /home/qt — [Meditate button on selected card] → Opens RecordingOverlay bottom sheet — STATUS: **implemented**
- [ ] /home/qt — [Completed check mark] → Shows ✅ if passage.isCompleted — STATUS: **implemented**
- [ ] /home/qt — [Sets QT mode before recording] → Sets currentPrayerModeProvider='qt', passageRef, passageText — STATUS: **implemented**

### Recording Overlay (bottom sheet)

- [ ] /recording — [Pulse animation] → Animates while recording, respects reduced motion — STATUS: **implemented**
- [ ] /recording — [Timer] → Shows MM:SS, increments every second — STATUS: **implemented**
- [ ] /recording — [Text mode toggle] → Switch between STT and keyboard input — STATUS: **implemented**
- [ ] /recording — [Pause/Resume] → Pauses timer and STT — STATUS: **implemented**
- [ ] /recording — [Finish button] → Stores transcript → pops overlay → navigates to /home/ai-loading — STATUS: **implemented**
- [ ] /recording — [Close (X) button] → Shows leave confirmation dialog — STATUS: **implemented**
- [ ] /recording — [Leave confirmation → Leave] → Cancels STT, pops overlay — STATUS: **implemented**
- [ ] /recording — [Leave confirmation → Stay] → Dismisses dialog, continues — STATUS: **implemented**
- [ ] /recording — [PopScope back gesture] → Also shows leave confirmation — STATUS: **implemented**
- [ ] /recording — [STT error fallback] → Switches to text mode with snackbar — STATUS: **implemented**
- [ ] /recording — [Transcript preview] → Shows STT transcript below pulse (max 3 lines) — STATUS: **implemented**

### /home/ai-loading — AiLoadingView

- [ ] /ai-loading — [Stage animation] → 🌱→🌿→🌸 icon transitions — STATUS: **implemented**
- [ ] /ai-loading — [Loading text] → Shows l10n.aiLoadingText — STATUS: **implemented**
- [ ] /ai-loading — [Bible verse fade-in] → Fades in after stage 1 — STATUS: **implemented**
- [ ] /ai-loading — [Minimum 3 second display] → Enforced before navigation — STATUS: **implemented**
- [ ] /ai-loading — [Prayer mode → AI analysis] → Calls aiService.analyzePrayerCore → saves prayer → updates streak — STATUS: **implemented**
- [ ] /ai-loading — [QT mode → AI analysis] → Calls aiService.analyzeMeditation → saves prayer → updates streak — STATUS: **implemented**
- [ ] /ai-loading — [Network check] → Falls back to hardcoded result when offline — STATUS: **implemented**
- [ ] /ai-loading — [Error handling] → Catches exceptions → sets fallback result — STATUS: **implemented**
- [ ] /ai-loading — [Navigation → Prayer Dashboard] → Goes to /home/prayer-dashboard for prayer mode — STATUS: **implemented**
- [ ] /ai-loading — [Navigation → QT Dashboard] → Goes to /home/qt-dashboard for QT mode — STATUS: **implemented**
- [ ] /ai-loading — [Streak milestone celebration] → Checks milestones → shows notification — STATUS: **implemented**

### /home/prayer-dashboard — PrayerDashboardView

- [ ] /prayer-dashboard — [Back button] → Navigates to /home — STATUS: **implemented**
- [ ] /prayer-dashboard — [Share button] → Navigates to /community/write — STATUS: **implemented**
- [ ] /prayer-dashboard — [Prayer Summary Card] → Shows if prayerSummary is not null — STATUS: **implemented**
- [ ] /prayer-dashboard — [Scripture Card] → Shows verse and reference — STATUS: **implemented**
- [ ] /prayer-dashboard — [Testimony Card] → Shows transcript text — STATUS: **implemented**
- [ ] /prayer-dashboard — [Historical Story Card (premium)] → Shows if premium content loaded — STATUS: **implemented**
- [ ] /prayer-dashboard — [AI Prayer Card (premium)] → Shows if premium content loaded — STATUS: **implemented**
- [ ] /prayer-dashboard — [Load Premium button] → Calls _loadPremiumContent for premium users — STATUS: **implemented**
- [ ] /prayer-dashboard — [Non-premium locked cards] → Shows placeholder cards with premium upgrade CTA — STATUS: **implemented**
- [ ] /prayer-dashboard — [Back to Home button] → Navigates to /home — STATUS: **implemented**

### /home/qt-dashboard — QtDashboardView

- [ ] /qt-dashboard — [Back button] → Navigates to /home — STATUS: **implemented**
- [ ] /qt-dashboard — [Meditation Analysis Card] → Shows key theme and insight — STATUS: **implemented**
- [ ] /qt-dashboard — [Application Card] → Shows application suggestion — STATUS: **implemented**
- [ ] /qt-dashboard — [Related Knowledge Card] → Shows historical context, cross references — STATUS: **implemented**
- [ ] /qt-dashboard — [Growth Story Card (premium)] → Shows if result.growthStory is not null — STATUS: **implemented**
- [ ] /qt-dashboard — [Back to Home button] → Navigates to /home — STATUS: **implemented**
- [ ] /qt-dashboard — [Share button] → Missing (unlike PrayerDashboardView which has one) — STATUS: **missing**

### /home/dashboard — DashboardView (Legacy)

- [ ] /dashboard — [Full 6-card layout] → Scripture, BibleStory, Testimony, Guidance, AiPrayer, OriginalLang — STATUS: **implemented**
- [ ] /dashboard — [Premium blur/lock] → Uses per-card premium logic — STATUS: **implemented**
- [ ] /dashboard — NOTE: This view appears to be a legacy version alongside PrayerDashboardView — STATUS: **needs cleanup decision**

### /calendar — CalendarView

- [ ] /calendar — [Streak cards (current + best)] → Two side-by-side cards with garden icon — STATUS: **implemented**
- [ ] /calendar — [Month navigation (< >)] → Previous/next month buttons — STATUS: **implemented**
- [ ] /calendar — [Calendar grid] → 7-column grid with weekday headers — STATUS: **implemented**
- [ ] /calendar — [Today highlight] → Sage border on today — STATUS: **implemented**
- [ ] /calendar — [Prayer day dot] → Green dot for prayer days, gold for grace recovery — STATUS: **implemented**
- [ ] /calendar — [Date tap → select] → Toggles selection, shows day detail — STATUS: **implemented**
- [ ] /calendar — [Day detail — prayer list] → Shows prayers for selected date — STATUS: **implemented**
- [ ] /calendar — [Day detail — prayer tap] → Sets prayerResultProvider and pushes /home/prayer-dashboard — STATUS: **implemented**
- [ ] /calendar — [Day detail — no prayers] → Shows 🌱 empty state — STATUS: **implemented**
- [ ] /calendar — [Day detail — verse card] → Shows first scripture from that day's prayers — STATUS: **implemented**
- [ ] /calendar — [QT prayer detail tap] → Only navigates if prayer.result is not null; QT prayers have no result stored — STATUS: **bug** (QT prayers saved without result in ai_loading_view.dart line 167)

### /community — CommunityView

- [ ] /community — [Filter chips (All/Testimony/Prayer Request)] → Filters posts by category — STATUS: **implemented**
- [ ] /community — [Filter change → reload] → Listens to communityFilterProvider and calls _refresh — STATUS: **implemented**
- [ ] /community — [Infinite scroll] → Loads more posts at 200px from bottom — STATUS: **implemented**
- [ ] /community — [Pull-to-refresh] → RefreshIndicator calls _refresh — STATUS: **implemented**
- [ ] /community — [Post header] → Avatar, name, category pill, time, overflow menu — STATUS: **implemented**
- [ ] /community — [Double-tap like] → Toggles like with heart animation overlay — STATUS: **implemented**
- [ ] /community — [Like button] → Toggles like via repo.toggleLike — STATUS: **implemented**
- [ ] /community — [Comment button] → Opens comments bottom sheet — STATUS: **implemented**
- [ ] /community — [Save/Bookmark button] → Toggles save via repo.toggleSave — STATUS: **implemented**
- [ ] /community — [Expandable text "See more"] → Expands long post content — STATUS: **implemented**
- [ ] /community — [Inline comment previews] → Shows up to 2 top-level comments — STATUS: **implemented**
- [ ] /community — ["View all N comments"] → Opens comments sheet — STATUS: **implemented**
- [ ] /community — [Like summary] → "Liked by X and N others" — STATUS: **implemented**
- [ ] /community — [Delete post (owner only)] → Shows confirmation → deletes → refreshes — STATUS: **implemented**
- [ ] /community — [Report post] → Opens reason dialog → sends email via mailto: — STATUS: **implemented**
- [ ] /community — [FAB → Write Post] → Navigates to /community/write — STATUS: **implemented**
- [ ] /community — [Empty state] → Shows noPrayersRecorded text (wrong l10n key for community context) — STATUS: **partial** (reuses prayer-specific empty text)

### /community — Comments Bottom Sheet

- [ ] /community — [Comment list (threaded)] → Top-level comments with nested replies — STATUS: **implemented**
- [ ] /community — [Reply button on comment] → Sets _replyToCommentId, shows reply indicator — STATUS: **implemented**
- [ ] /community — [Reply indicator dismiss (X)] → Clears reply target — STATUS: **implemented**
- [ ] /community — [Submit comment] → Creates comment via repo → clears input → pops sheet → refreshes — STATUS: **implemented**
- [ ] /community — [Delete comment (owner)] → Deletes via repo → pops sheet → refreshes — STATUS: **implemented**
- [ ] /community — [Comment like] → Toggles like via repo.toggleCommentLike — STATUS: **implemented**
- [ ] /community — [Show/hide replies toggle] → Expands nested replies — STATUS: **implemented**
- [ ] /community — [Reply delete] → onDelete is empty `() {}` for replies — STATUS: **bug** (reply deletion non-functional)
- [ ] /community — [Reply ownership] → isOwner is hardcoded `false` for replies — STATUS: **bug** (reply delete button never shown)

### /community/write — WritePostView

- [ ] /community/write — [Anonymous toggle] → Switches between anonymous 🌿 and real name — STATUS: **implemented**
- [ ] /community/write — [Category chips (Testimony/Prayer Request)] → Selects category — STATUS: **implemented**
- [ ] /community/write — [Text input field] → Multi-line text field (minLines: 8) — STATUS: **implemented**
- [ ] /community/write — [Import from prayer button] → Loads latest prayer result testimony into text field — STATUS: **implemented**
- [ ] /community/write — [Share button (bottom)] → Submits post → invalidates provider → pops — STATUS: **implemented**
- [ ] /community/write — [Share button (app bar)] → Also calls _submitPost — STATUS: **implemented**
- [ ] /community/write — [Empty text guard] → Returns early if text is empty — STATUS: **implemented**
- [ ] /community/write — [Loading state] → Disables buttons during _isSubmitting — STATUS: **implemented**
- [ ] /community/write — [Close (X) button] → context.pop() — STATUS: **implemented**
- [ ] /community/write — [No unsaved changes warning] → Missing: no confirmation when leaving with typed text — STATUS: **missing**

### /settings — SettingsView

- [ ] /settings — [Profile card] → Shows avatar, name, email (or anonymous prompt) — STATUS: **implemented**
- [ ] /settings — [Link Account] → Opens bottom sheet with Apple/Google buttons (anonymous only) — STATUS: **implemented**
- [ ] /settings — [Link with Apple] → Calls authNotifier.linkWithApple → invalidates userProfile — STATUS: **implemented**
- [ ] /settings — [Link with Google] → Calls authNotifier.linkWithGoogle → invalidates userProfile — STATUS: **implemented**
- [ ] /settings — [Membership row] → Shows Free/Premium badge → navigates to /settings/membership — STATUS: **implemented**
- [ ] /settings — [AI Voice dropdown] → Shows 3 options (warm/calm/strong) — STATUS: **partial** (local state only; not persisted to profile/preferences)
- [ ] /settings — [Language dropdown] → 35 languages → updates localeProvider — STATUS: **implemented**
- [ ] /settings — [Dark mode toggle] → Switch exists but only changes local _darkMode state — STATUS: **not functional** (no ThemeMode provider or persistence)
- [ ] /settings — [Notification settings row] → Navigates to /settings/notifications — STATUS: **implemented**
- [ ] /settings — [Help Center] → onTap: () {} — STATUS: **not implemented** (empty handler)
- [ ] /settings — [Terms of Service] → onTap: () {} — STATUS: **not implemented** (empty handler)
- [ ] /settings — [Privacy Policy] → onTap: () {} — STATUS: **not implemented** (empty handler)
- [ ] /settings — [Logout] → Shows confirmation → signs out → navigates to /welcome — STATUS: **implemented**
- [ ] /settings — [Logout only for non-anonymous] → Correctly hidden when isAnon — STATUS: **implemented**
- [ ] /settings — [App version] → Shows "v1.0.0" — STATUS: **implemented** (hardcoded version)

### /settings/notifications — NotificationSettingsView

- [ ] /notifications — [Morning reminder toggle] → Updates via notificationService.updateSettings — STATUS: **implemented**
- [ ] /notifications — [Morning time picker] → Shows TimePicker → saves formatted time — STATUS: **implemented**
- [ ] /notifications — [Evening reminder toggle] → Updates setting — STATUS: **implemented**
- [ ] /notifications — [Afternoon nudge toggle] → Updates setting — STATUS: **implemented**
- [ ] /notifications — [Streak reminder toggle] → Updates setting — STATUS: **implemented**
- [ ] /notifications — [Weekly summary toggle] → Updates setting — STATUS: **implemented**
- [ ] /notifications — [Time picker shows only when morning reminder is on] → Conditional visibility — STATUS: **implemented**
- [ ] /notifications — [Evening time picker] → Missing (no time picker for evening reminder) — STATUS: **missing**

### /settings/membership — MembershipView

- [ ] /membership — [Header] → Shows 🌿 Abba Premium + subtitle — STATUS: **implemented**
- [ ] /membership — [Plan toggle (Monthly/Yearly)] → Switches selected plan — STATUS: **implemented**
- [ ] /membership — [Plan card] → Shows price, savings, benefits list — STATUS: **implemented**
- [ ] /membership — [BEST VALUE badge] → Shows only for yearly plan — STATUS: **implemented**
- [ ] /membership — [Start Membership button] → Calls subscriptionService.purchaseMonthly/Yearly — STATUS: **implemented**
- [ ] /membership — [Purchase loading indicator] → Shows spinner during purchase — STATUS: **implemented**
- [ ] /membership — [Purchase success → invalidate isPremiumProvider] → Refreshes premium status — STATUS: **implemented**
- [ ] /membership — [Purchase error] → Shows error snackbar — STATUS: **implemented**
- [ ] /membership — [Restore purchase] → Calls service.restorePurchases — STATUS: **implemented**
- [ ] /membership — [Cancel anytime] → Informational text — STATUS: **implemented**
- [ ] /membership — [Active premium card] → Shows when already premium — STATUS: **implemented**
- [ ] /membership — [Restore purchase feedback] → No success/error feedback after restore — STATUS: **missing**

### /home/my-records — MyPageView

- [ ] /my-records — [Profile header] → Avatar, name, email, 3-column stats — STATUS: **implemented**
- [ ] /my-records — [Stats: Total Prayers] → Shows profile.totalPrayers — STATUS: **implemented**
- [ ] /my-records — [Stats: Streak] → Shows streak from streakProvider — STATUS: **implemented**
- [ ] /my-records — [Stats: Testimonies] → Hardcoded '0' — STATUS: **not implemented** (placeholder value)
- [ ] /my-records — [Tab: My Prayers] → Shows prayer days for current month — STATUS: **implemented**
- [ ] /my-records — [Tab: My Prayers → prayer day tile] → Shows date + truncated transcripts — STATUS: **implemented**
- [ ] /my-records — [Tab: My Prayers → tap to view detail] → Missing (no navigation on tap) — STATUS: **missing**
- [ ] /my-records — [Tab: My Testimonies] → Shows user's community posts — STATUS: **implemented**
- [ ] /my-records — [Tab: Saved Posts] → Shows bookmarked posts — STATUS: **implemented**
- [ ] /my-records — [My Prayers shows only current month] → No month navigation — STATUS: **partial** (limited view)
- [ ] /my-records — [Post tile tap] → No navigation to post detail — STATUS: **missing**

---

## B) DATA SYNC — Provider Invalidation After Actions

- [ ] Prayer saved (AI loading) → streakProvider, userProfileProvider invalidated — STATUS: **implemented**
- [ ] Prayer saved (AI loading) → prayerHeatmapProvider NOT invalidated → Home heatmap may be stale — STATUS: **bug**
- [ ] Prayer saved (AI loading) → monthlyPrayerDaysProvider NOT invalidated → Calendar may be stale — STATUS: **bug** (autoDispose helps only if screen was disposed)
- [ ] Prayer saved (AI loading) → calendarPrayersProvider NOT invalidated → Day detail may be stale — STATUS: **bug**
- [ ] Post created (WritePostView) → filteredCommunityPostsProvider invalidated — STATUS: **implemented**
- [ ] Post created (WritePostView) → CommunityView uses manual _posts list, not provider → cursor-based list NOT auto-refreshed — STATUS: **partial** (invalidation exists but community_view uses its own list management, needs explicit _refresh call when returning)
- [ ] Post deleted (CommunityView) → Calls onRefresh (full refresh) — STATUS: **implemented**
- [ ] Comment submitted → Calls onRefresh → pops sheet — STATUS: **implemented**
- [ ] Like toggled → Local state updated, no provider invalidation needed — STATUS: **implemented**
- [ ] Save toggled → Local state updated — STATUS: **implemented**
- [ ] Account linked → userProfileProvider invalidated — STATUS: **implemented**
- [ ] Subscription purchased → isPremiumProvider invalidated — STATUS: **implemented**
- [ ] Notification setting changed → notificationSettingsProvider invalidated — STATUS: **implemented**
- [ ] Language changed → localeProvider updated (reactive) — STATUS: **implemented**
- [ ] Voice preference changed → Local state only; NOT persisted — STATUS: **bug**
- [ ] Dark mode changed → Local state only; NOT persisted or connected to theme — STATUS: **bug**
- [ ] todayPrayerCountProvider → In-memory StateProvider, resets on app restart — STATUS: **bug** (free user can bypass limit by restarting app)

---

## C) STATE TRANSITIONS

- [ ] Welcome → Home → Normal flow — STATUS: **implemented**
- [ ] Home idle → Prayer recording → Active prayer UI (timer, pulse, controls) — STATUS: **implemented**
- [ ] Prayer recording → Text mode → STT stops, text field appears with transcript — STATUS: **implemented**
- [ ] Text mode → STT mode → Text field hides, STT restarts — STATUS: **implemented**
- [ ] Active prayer → Pause → Timer pauses, pulse stops, STT stops — STATUS: **implemented**
- [ ] Pause → Resume → Timer resumes, pulse restarts, STT restarts — STATUS: **implemented**
- [ ] Active prayer → Finish → Confirmation dialog — STATUS: **implemented**
- [ ] Finish confirmed → AI Loading → Dashboard → Full flow — STATUS: **implemented**
- [ ] AI Loading error → Fallback result → Dashboard (graceful degradation) — STATUS: **implemented**
- [ ] AI Loading offline → Fallback result → Dashboard — STATUS: **implemented**
- [ ] Dashboard → Home → Resets to idle prayer tab — STATUS: **implemented**
- [ ] Tab switch during recording → Leave confirmation dialog — STATUS: **implemented**
- [ ] Tab switch confirmed → isRecordingProvider = false → Tab switches — STATUS: **implemented**
- [ ] QT passage select → Meditate → Recording overlay → AI loading → QT dashboard — STATUS: **implemented**
- [ ] Calendar date tap → Show prayers → Tap prayer → Prayer dashboard (push, not go) — STATUS: **implemented**
- [ ] Anonymous user → Link account → Profile updates — STATUS: **implemented**
- [ ] Logged-in user → Logout → /welcome — STATUS: **implemented**
- [ ] Free user → 2nd prayer → Premium modal — STATUS: **implemented**
- [ ] Premium modal → Purchase → Prayer starts — STATUS: **needs testing**
- [ ] Premium modal → Decline → Returns, prayer blocked — STATUS: **implemented**

---

## D) EDGE CASES

- [ ] STT unavailable (no permission/hardware) → Auto-fallback to text mode with snackbar — STATUS: **implemented**
- [ ] STT locale not mapped (e.g., 'pt', 'fr', 'hi') → Falls back to 'en_US' — STATUS: **partial** (works but poor UX for non-English speakers)
- [ ] Empty transcript submitted → AI gets empty string, may produce poor result — STATUS: **needs guard** (no minimum length check)
- [ ] Very long prayer (30+ minutes) → Timer displays correctly (MM:SS wraps) — STATUS: **needs testing**
- [ ] App killed during prayer → Timer/STT state lost, no recovery — STATUS: **expected** (no persistence needed)
- [ ] Network lost during AI call → Catches exception, uses fallback result — STATUS: **implemented**
- [ ] Network lost during premium content load → Catches exception, stops loading — STATUS: **implemented** (but no user-facing error message)
- [ ] Prayer with no result tapped in calendar → Returns early (prayer.result == null check) — STATUS: **implemented**
- [ ] QT passage none selected → No meditate button shown — STATUS: **implemented**
- [ ] Community empty feed → Shows placeholder text — STATUS: **implemented**
- [ ] Import from prayer when no prayer result → Silently does nothing — STATUS: **implemented**
- [ ] Write post with empty text → Returns early on submit — STATUS: **implemented**
- [ ] Double-tap submit post → _isSubmitting guard prevents double submission — STATUS: **implemented**
- [ ] Report with empty reason → Guarded by `reason.isNotEmpty` check — STATUS: **implemented**
- [ ] Report email client not available → launchUrl may fail silently — STATUS: **needs testing**
- [ ] Calendar navigate to far future month → Shows empty calendar (no errors) — STATUS: **needs testing**
- [ ] Calendar navigate to far past month → Shows empty calendar — STATUS: **needs testing**
- [ ] todayPrayerCount resets on app restart → Free users get unlimited prayers with restarts — STATUS: **bug**
- [ ] Multiple rapid like toggles → May cause race condition with server — STATUS: **needs testing**
- [ ] Bottom sheet comments → Keyboard overlap on short devices — STATUS: **needs testing**
- [ ] Weekday header locale → Uses `DateFormat.E(locale)` with hardcoded date (2024, 1, 7) which is a Sunday → Correctly starts week on Sunday — STATUS: **implemented**
- [ ] Anonymous user profile → Shows 🙏 avatar and "Anonymous" name — STATUS: **implemented**
- [ ] Post with null displayName → Shows l10n.anonymous — STATUS: **implemented**
- [ ] Comment on own post → Delete option shown, reply allowed — STATUS: **implemented**
- [ ] Scripture verse locale → verse(locale) method used correctly — STATUS: **needs verification**
- [ ] Locale change → All screens update immediately (Riverpod reactive) — STATUS: **implemented**
- [ ] Locale change → AI responses still in old language until new prayer — STATUS: **expected behavior**

---

## E) UNIMPLEMENTED / MISSING FEATURES

### Critical (affects core functionality)

- [ ] /home — [todayPrayerCount not persisted] — Free user prayer limit resets on app restart. Need to persist count with date key in SharedPreferences or Supabase
- [ ] /ai-loading — [prayerHeatmapProvider not invalidated] — Home screen heatmap doesn't update after new prayer until navigating away and back
- [ ] /ai-loading — [monthlyPrayerDaysProvider not invalidated] — Calendar doesn't show newly recorded prayer until tab re-entry
- [ ] /ai-loading — [QT prayer saved without result] — QT prayers are saved with `result: null`, so tapping them in Calendar does nothing
- [ ] /settings — [Dark mode not functional] — Toggle exists but doesn't change app theme. No ThemeMode provider, no persistence
- [ ] /settings — [Voice preference not persisted] — Dropdown resets to 'warm' on every visit. Local _voicePreference state only

### Important (affects UX)

- [ ] /settings — [Help Center] — Empty onTap handler. No URL or content
- [ ] /settings — [Terms of Service] — Empty onTap handler. No URL or content
- [ ] /settings — [Privacy Policy] — Empty onTap handler. No URL or content
- [ ] /dashboard/testimony_card — [Edit button] — Empty onTap handler `() {}`. Cannot edit testimony
- [ ] /welcome — [First launch detection] — Welcome screen exists but initialLocation is `/home`. No mechanism to show Welcome on first launch
- [ ] /community — [Reply deletion] — `_ThreadedCommentTile` for replies has `onDelete: () {}` (empty) and `isOwner: false` (hardcoded)
- [ ] /community — [Empty state l10n key] — Uses `l10n.noPrayersRecorded` instead of a community-specific empty message
- [ ] /my-records — [Testimonies count] — Hardcoded '0' placeholder instead of actual count from myPostsProvider
- [ ] /my-records — [Prayer day tile tap] — No navigation to prayer detail from My Prayers tab
- [ ] /my-records — [Post tile tap] — No navigation to post detail from My Testimonies or Saved tabs
- [ ] /my-records — [Only current month prayers] — No month navigation; only shows current month
- [ ] /community/write — [Unsaved changes warning] — No confirmation dialog when leaving with typed content
- [ ] /qt-dashboard — [Share button missing] — Unlike PrayerDashboardView, QtDashboardView has no share action in app bar
- [ ] /membership — [Restore purchase feedback] — No snackbar/dialog after restore attempt
- [ ] /notifications — [Evening time picker missing] — Morning has time picker but evening reminder has no time setting

### Spec vs Implementation Gaps

- [ ] SPEC: "Daily Verse card on Home" — Not implemented; Home shows heatmap + streak instead
- [ ] SPEC: "Recording as fullscreen overlay on Home" — Prayer recording is inline on Home (not a bottom sheet). QT uses bottom sheet correctly
- [ ] SPEC: "6 cards in Dashboard (Scripture, BibleStory, Testimony, Guidance, AiPrayer, OriginalLang)" — New PrayerDashboardView uses different cards (PrayerSummary, Scripture, Testimony, HistoricalStory, AiPrayer). Legacy DashboardView has original 6 cards. Two dashboard views coexist
- [ ] SPEC: "Premium content blur with BackdropFilter" — Premium cards show locked state but implementation varies by card widget (need to verify blur vs simple lock)
- [ ] SPEC: "TTS for AI Prayer" — TTS service provider exists but TTS integration in AI Prayer card needs verification
- [ ] SPEC: "Greeting with user name on Home" — Not implemented; Home shows tab bar + heatmap without greeting
- [ ] SPEC: "FCM push notifications" — Local notification service exists; FCM (remote push) not yet integrated
- [ ] SPEC: "4 tabs: Home/Calendar/Community/Settings" — Implemented correctly
- [ ] SPEC: "QT cronjob generates 5 passages daily" — Relies on qtRepository.getTodayPassages(); backend cronjob status unknown
- [ ] SPEC: "Week 7 streak → 3-day premium trial" — No implementation of time-based trial offer

### Technical Debt

- [ ] Two dashboard views exist (DashboardView + PrayerDashboardView) — Both registered in router at /home/dashboard and /home/prayer-dashboard. Need to decide which to keep
- [ ] STT locale mapping covers only 5 of 35 supported languages — Many users will get English STT regardless of app language
- [ ] `myPostsProvider` fetches ALL posts then filters client-side — Should use server-side user filter for efficiency
- [ ] `HeatmapDay.minutes` always 0 — `Prayer.durationSeconds` is likely 0 since duration is not tracked/saved

---

## F) NAVIGATION CONSISTENCY

- [ ] All `context.go('/home')` calls → Correct for returning to home (replaces stack) — STATUS: **consistent**
- [ ] Calendar prayer detail uses `context.push('/home/prayer-dashboard')` → Correct (adds to stack, allows back) — STATUS: **consistent**
- [ ] WritePostView uses `context.pop()` → Correct (returns to community) — STATUS: **consistent**
- [ ] Membership access uses `context.push('/settings/membership')` from dashboards, `context.go('/settings/membership')` from settings → Mixed but functional — STATUS: **acceptable**
- [ ] RecordingOverlay uses `Navigator.of(context).pop()` then `context.go('/home/ai-loading')` → Works but mixing Navigator + go_router — STATUS: **needs review**
- [ ] Login redirect in router → `/login` redirects to `/home` (Anonymous-First) — STATUS: **implemented**

---

## G) ACCESSIBILITY (Senior-Friendly)

- [ ] Button minimum height 56dp → abbaButtonHeight = 56.0 enforced in AbbaButton — STATUS: **implemented**
- [ ] Body text minimum 18pt → AbbaTypography.body fontSize: 18 — STATUS: **implemented**
- [ ] Reduced motion support → RecordingOverlay checks MediaQuery.disableAnimations — STATUS: **partial** (only in RecordingOverlay, not in HomeView pulse)
- [ ] Semantic labels → Recording close button has Semantics label — STATUS: **partial** (only one button has Semantics)
- [ ] Text overflow handling → maxLines + ellipsis used in most places — STATUS: **implemented**
- [ ] Tap targets → Most interactive elements are 56dp+ — STATUS: **needs audit**

---

## Summary

| Category | Total | Implemented | Partial/Bug | Missing |
|----------|-------|-------------|-------------|---------|
| Functionality | ~105 | ~85 | ~8 | ~12 |
| Data Sync | 16 | 10 | 2 | 4 |
| State Transitions | 20 | 18 | 1 | 1 |
| Edge Cases | 24 | 14 | 3 | 7 |
| Unimplemented | 28 | -- | -- | 28 |

### Top Priority Fixes

1. **todayPrayerCount persistence** — Free user limit bypassed on restart
2. **prayerHeatmapProvider + calendar providers not invalidated** — Stale data after prayer
3. **QT prayer result not saved** — Calendar can't show QT prayer details
4. **Dark mode toggle non-functional** — Remove or implement
5. **Voice preference not persisted** — Dropdown resets every time
6. **STT locale mapping incomplete** — Only 5 of 35 languages mapped
7. **Reply deletion broken** — Empty handler + hardcoded isOwner:false
8. **Testimony edit button empty** — Button shows but does nothing
