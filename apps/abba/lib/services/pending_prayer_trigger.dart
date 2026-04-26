import 'package:app_lib_logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Phase B5 — kicks the `abba-process-pending-prayer` Edge Function so the
/// server-side automatic recovery (Phase B2 prayer T2 + B3 QT T2) actually
/// runs against this user's rows.
///
/// The Edge Function is the only thing that can pick up
/// `section_status->>'t2'='failed'` rows and re-analyze the missing tier.
/// Without this trigger the recovery engine sits idle and the user keeps
/// seeing partial-failed cards forever.
///
/// Behaviour
///   - Fire-and-forget. Never throws. The UI must not be gated on the
///     result — most invocations will be a 200 no-op (`no_eligible_prayer`).
///   - Throttled with a static `_lastInvokedAt` cursor so a chatty
///     lifecycle (rapid resume/pause) cannot stampede the function. The
///     cursor is process-scoped on purpose — a cold start is a strong
///     signal of intent and should always invoke.
///   - 401 (`UNAUTHORIZED_INVALID_JWT_FORMAT` or similar) is logged at
///     error level with `error:` set so SentryBreadcrumbOutput auto-
///     promotes it (learned-pitfalls §17). Per Phase B5 scope we only
///     OBSERVE the 401 here — root-cause is a separate phase (likely
///     supabase_flutter token format vs project JWKS migration).
///
/// See:
///   apps/abba/specs/LAUNCH_CHECKLIST.md (Phase 4 → Phase B post-deploy gate)
///   supabase/functions/abba-process-pending-prayer/index.ts
class PendingPrayerTrigger {
  PendingPrayerTrigger(this._client);

  final SupabaseClient _client;

  static const Duration _debounceWindow = Duration(seconds: 60);
  static const String _functionName = 'abba-process-pending-prayer';

  static DateTime? _lastInvokedAt;

  /// Best-effort kick. Returns immediately if within the debounce window
  /// or if there is no authenticated session (Edge requires a user JWT).
  /// Any failure is logged and swallowed.
  Future<void> tryTrigger({String reason = 'lifecycle'}) async {
    final now = DateTime.now();
    final last = _lastInvokedAt;
    if (last != null && now.difference(last) < _debounceWindow) {
      return;
    }

    final session = _client.auth.currentSession;
    if (session == null) {
      // No JWT → Edge would 401. Skip silently; subsequent lifecycle
      // events will retry once the anonymous sign-in lands.
      return;
    }

    _lastInvokedAt = now;

    try {
      final response = await _client.functions.invoke(_functionName);
      final status = response.status;
      if (status == 200 || status == 202) {
        apiLog.info(
          '[PendingTrigger] $reason status=$status body=${response.data}',
        );
        return;
      }
      if (status == 401) {
        apiLog.error(
          '[PendingTrigger] 401 from $_functionName — SDK token format may '
          'not match project JWKS gateway. Body: ${response.data}',
          error: StateError('pending_trigger_401'),
        );
        return;
      }
      apiLog.warning(
        '[PendingTrigger] non-success status=$status body=${response.data}',
      );
    } catch (e, st) {
      // FunctionException, network failure, or any other throw. Log with
      // error: set so Sentry picks it up, but never propagate — the UI
      // must keep working when the recovery trigger fails.
      apiLog.error(
        '[PendingTrigger] invoke threw: $e',
        error: e,
        stackTrace: st,
      );
    }
  }
}
