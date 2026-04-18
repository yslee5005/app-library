/**
 * abba-weekly-report — Supabase Edge Function
 *
 * Cron: every Sunday at 20:00 KST (11:00 UTC)
 *
 * Logic:
 *   1. Find users with weekly_summary = true (app_id = 'abba')
 *   2. Count prayers this week (Mon 00:00 KST – Sun 23:59 KST)
 *   3. Send FCM push with personalized encouragement
 *   4. Clean up invalid FCM tokens
 *
 * Required secrets:
 *   FIREBASE_SERVICE_ACCOUNT — Firebase service account JSON
 *   SUPABASE_URL             — set automatically
 *   SUPABASE_SERVICE_ROLE_KEY — set automatically
 */

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import {
  sendFcmNotification,
  deactivateToken,
} from "../_shared/fcm.ts";

const APP_ID = "abba";

/**
 * Get the Monday 00:00 and Sunday 23:59:59 of the current week in KST.
 * ISO weeks start on Monday.
 */
function currentWeekRangeKST(): { weekStart: string; weekEnd: string } {
  const now = new Date();
  // Shift to KST
  const kst = new Date(now.getTime() + 9 * 60 * 60 * 1000);

  // getUTCDay(): 0=Sun, 1=Mon ... 6=Sat
  const dayOfWeek = kst.getUTCDay();
  // Days since Monday (Sunday = 6 days since last Monday)
  const daysSinceMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1;

  const monday = new Date(kst);
  monday.setUTCDate(kst.getUTCDate() - daysSinceMonday);
  const mondayStr = monday.toISOString().slice(0, 10);

  const sunday = new Date(kst);
  sunday.setUTCDate(kst.getUTCDate() + (6 - daysSinceMonday));
  const sundayStr = sunday.toISOString().slice(0, 10);

  return {
    weekStart: `${mondayStr}T00:00:00+09:00`,
    weekEnd: `${sundayStr}T23:59:59+09:00`,
  };
}

/** Pick an encouragement message based on prayer count. */
function getEncouragement(count: number): string {
  if (count === 0) {
    return "\uB2E4\uC74C \uC8FC\uC5D0\uB294 \uD568\uAED8 \uAE30\uB3C4\uD574\uC694";
    // "다음 주에는 함께 기도해요"
  }
  if (count <= 3) {
    return "\uC88B\uC740 \uC2DC\uC791\uC774\uC5D0\uC694!";
    // "좋은 시작이에요!"
  }
  if (count <= 6) {
    return "\uAFB8\uC900\uD788 \uAE30\uB3C4\uD558\uACE0 \uC788\uC5B4\uC694! \uD83D\uDC4F";
    // "꾸준히 기도하고 있어요! 👏"
  }
  // count >= 7
  return "\uB9E4\uC77C \uAE30\uB3C4\uD588\uC5B4\uC694! \uD83C\uDF89";
  // "매일 기도했어요! 🎉"
}

Deno.serve(async (req) => {
  try {
    if (req.method === "OPTIONS") {
      return new Response("ok", { status: 200 });
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const { weekStart, weekEnd } = currentWeekRangeKST();
    console.log(`[abba-weekly-report] Week range: ${weekStart} ~ ${weekEnd}`);

    // 1. Get users who opted in for weekly summary
    const { data: settings, error: settingsError } = await supabase
      .schema("abba")
      .from("notification_settings")
      .select("user_id")
      .eq("app_id", APP_ID)
      .eq("weekly_summary", true);

    if (settingsError) {
      throw new Error(
        `Failed to fetch notification_settings: ${settingsError.message}`
      );
    }

    if (!settings || settings.length === 0) {
      console.log("[abba-weekly-report] No users with weekly_summary enabled.");
      return new Response(JSON.stringify({ sent: 0 }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    const userIds = settings.map((s: { user_id: string }) => s.user_id);
    console.log(`[abba-weekly-report] ${userIds.length} users opted in.`);

    // 2. Count prayers per user this week
    //    Supabase JS doesn't support GROUP BY directly, so we fetch rows
    //    and aggregate in code. For scale, use an RPC function instead.
    const { data: prayers, error: prayersError } = await supabase
      .schema("abba")
      .from("prayers")
      .select("user_id")
      .eq("app_id", APP_ID)
      .in("user_id", userIds)
      .gte("created_at", weekStart)
      .lte("created_at", weekEnd);

    if (prayersError) {
      throw new Error(`Failed to query prayers: ${prayersError.message}`);
    }

    // Count per user
    const countMap = new Map<string, number>();
    for (const p of prayers ?? []) {
      countMap.set(p.user_id, (countMap.get(p.user_id) ?? 0) + 1);
    }

    // 3. Get active FCM tokens
    const { data: devices, error: devicesError } = await supabase
      .from("user_devices")
      .select("user_id, fcm_token")
      .eq("app_id", APP_ID)
      .eq("is_active", true)
      .in("user_id", userIds);

    if (devicesError) {
      throw new Error(`Failed to fetch user_devices: ${devicesError.message}`);
    }

    if (!devices || devices.length === 0) {
      console.log("[abba-weekly-report] No active devices.");
      return new Response(JSON.stringify({ sent: 0 }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // 4. Send notifications
    let sent = 0;
    let failed = 0;

    for (const device of devices) {
      const count = countMap.get(device.user_id) ?? 0;
      const encouragement = getEncouragement(count);

      const title = "\uD83D\uDCCA \uC774\uBC88 \uC8FC \uAE30\uB3C4 \uB9AC\uD3EC\uD2B8";
      // "📊 이번 주 기도 리포트"

      const body = `\uC774\uBC88 \uC8FC ${count}\uBC88 \uAE30\uB3C4\uD588\uC5B4\uC694! ${encouragement}`;
      // "이번 주 {count}번 기도했어요! {encouragement}"

      const result = await sendFcmNotification(device.fcm_token, title, body, {
        type: "weekly_report",
        route: "/history",
        prayer_count: String(count),
      });

      if (result.success) {
        sent++;
      } else {
        failed++;
        if (result.tokenInvalid) {
          await deactivateToken(supabase, APP_ID, device.fcm_token);
        }
      }
    }

    const summary = { sent, failed, total: userIds.length };
    console.log("[abba-weekly-report] Done:", JSON.stringify(summary));

    return new Response(JSON.stringify(summary), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("[abba-weekly-report] Error:", err);
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
