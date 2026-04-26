import 'dart:async';

import 'package:app_lib_logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/prayer.dart';

/// Polling helper for Phase 4 lazy retry — sits between
/// `Home/AiLoadingView` and the `abba-process-pending-prayer` Edge Function.
///
/// Usage:
///   final poller = PendingPrayerPoller(Supabase.instance.client);
///   final result = await poller.waitForCompletion(prayerId);
///   switch (result) {
///     case PollCompleted(:final prayer): ...
///     case PollFailed(): ...
///     case PollTimeout(): ...
///   }
///
/// See apps/abba/specs/DESIGN.md §10.
class PendingPrayerPoller {
  final SupabaseClient _client;
  final Duration interval;
  final Duration timeout;

  PendingPrayerPoller(
    this._client, {
    this.interval = const Duration(seconds: 3),
    this.timeout = const Duration(seconds: 60),
  });

  /// Poll `abba.prayers` every [interval] until ai_status transitions to
  /// `completed` or `failed`, or [timeout] elapses.
  Future<PollResult> waitForCompletion(String prayerId) async {
    final deadline = DateTime.now().add(timeout);
    apiLog.info(
      '[Poller] start id=$prayerId interval=$interval timeout=$timeout',
    );

    while (DateTime.now().isBefore(deadline)) {
      try {
        final data = await _client
            .schema('abba')
            .from('prayers')
            .select()
            .eq('id', prayerId)
            .maybeSingle();

        if (data == null) {
          apiLog.warning('[Poller] prayer disappeared id=$prayerId');
          return const PollFailed(reason: 'prayer_not_found');
        }

        final prayer = Prayer.fromJson(data);
        apiLog.debug('[Poller] id=$prayerId status=${prayer.aiStatus.name}');

        switch (prayer.aiStatus) {
          case PrayerAiStatus.completed:
            apiLog.info('[Poller] completed id=$prayerId');
            return PollCompleted(prayer);
          case PrayerAiStatus.failed:
            apiLog.info('[Poller] failed permanent id=$prayerId');
            return const PollFailed(reason: 'server_retry_cap');
          case PrayerAiStatus.processing:
          case PrayerAiStatus.pending:
            // Still working / waiting for cooldown — keep polling.
            break;
        }
      } catch (e) {
        apiLog.warning('[Poller] query error id=$prayerId', error: e);
        // Transient failure — continue polling rather than bail immediately.
      }

      await Future<void>.delayed(interval);
    }

    apiLog.info('[Poller] timeout id=$prayerId');
    return const PollTimeout();
  }
}

/// Terminal result of a polling session.
sealed class PollResult {
  const PollResult();
}

class PollCompleted extends PollResult {
  final Prayer prayer;
  const PollCompleted(this.prayer);
}

class PollFailed extends PollResult {
  final String reason;
  const PollFailed({required this.reason});
}

class PollTimeout extends PollResult {
  const PollTimeout();
}
