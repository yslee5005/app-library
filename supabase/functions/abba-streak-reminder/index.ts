/**
 * abba-streak-reminder — Supabase Edge Function
 *
 * Cron: daily at 19:00 KST (10:00 UTC)
 *
 * Logic:
 *   1. Find users with streak_reminder = true (app_id = 'abba')
 *   2. For each user, check if they prayed today (KST)
 *   3. If NOT prayed, send FCM push to keep their streak alive
 *   4. Clean up invalid FCM tokens on 404
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

/** Get today's date string in KST (Asia/Seoul, UTC+9). */
function todayKST(): string {
  const now = new Date();
  const kst = new Date(now.getTime() + 9 * 60 * 60 * 1000);
  return kst.toISOString().slice(0, 10); // "YYYY-MM-DD"
}

Deno.serve(async (req) => {
  try {
    // Only allow POST (cron) or OPTIONS (preflight)
    if (req.method === "OPTIONS") {
      return new Response("ok", { status: 200 });
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const today = todayKST();
    console.log(`[abba-streak-reminder] Running for date: ${today}`);

    // 1. Get users who opted in for streak reminders
    const { data: settings, error: settingsError } = await supabase
      .schema("abba")
      .from("notification_settings")
      .select("user_id")
      .eq("app_id", APP_ID)
      .eq("streak_reminder", true);

    if (settingsError) {
      throw new Error(`Failed to fetch notification_settings: ${settingsError.message}`);
    }

    if (!settings || settings.length === 0) {
      console.log("[abba-streak-reminder] No users with streak_reminder enabled.");
      return new Response(JSON.stringify({ sent: 0, skipped: 0 }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    const userIds = settings.map((s: { user_id: string }) => s.user_id);
    console.log(`[abba-streak-reminder] ${userIds.length} users opted in.`);

    // 2. Find which users already prayed today
    //    prayers.created_at is TIMESTAMPTZ. We filter by KST date range.
    const todayStart = `${today}T00:00:00+09:00`;
    const todayEnd = `${today}T23:59:59+09:00`;

    const { data: prayedRows, error: prayedError } = await supabase
      .schema("abba")
      .from("prayers")
      .select("user_id")
      .eq("app_id", APP_ID)
      .in("user_id", userIds)
      .gte("created_at", todayStart)
      .lte("created_at", todayEnd);

    if (prayedError) {
      throw new Error(`Failed to query prayers: ${prayedError.message}`);
    }

    const prayedUserIds = new Set(
      (prayedRows ?? []).map((r: { user_id: string }) => r.user_id)
    );
    const notPrayedUserIds = userIds.filter(
      (uid: string) => !prayedUserIds.has(uid)
    );

    console.log(
      `[abba-streak-reminder] ${prayedUserIds.size} already prayed, ${notPrayedUserIds.length} have not.`
    );

    if (notPrayedUserIds.length === 0) {
      return new Response(JSON.stringify({ sent: 0, skipped: userIds.length }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // 3. Get active FCM tokens for users who haven't prayed
    const { data: devices, error: devicesError } = await supabase
      .from("user_devices")
      .select("user_id, fcm_token")
      .eq("app_id", APP_ID)
      .eq("is_active", true)
      .in("user_id", notPrayedUserIds);

    if (devicesError) {
      throw new Error(`Failed to fetch user_devices: ${devicesError.message}`);
    }

    if (!devices || devices.length === 0) {
      console.log("[abba-streak-reminder] No active devices for un-prayed users.");
      return new Response(
        JSON.stringify({ sent: 0, skipped: notPrayedUserIds.length }),
        { headers: { "Content-Type": "application/json" } }
      );
    }

    // 4. Get current streak for each user (for personalized message)
    const deviceUserIds = [
      ...new Set(devices.map((d: { user_id: string }) => d.user_id)),
    ];
    const { data: streaks } = await supabase
      .schema("abba")
      .from("prayer_streaks")
      .select("user_id, current_streak")
      .eq("app_id", APP_ID)
      .in("user_id", deviceUserIds);

    const streakMap = new Map<string, number>();
    for (const s of streaks ?? []) {
      streakMap.set(s.user_id, s.current_streak ?? 0);
    }

    // 5. Send notifications
    let sent = 0;
    let failed = 0;

    for (const device of devices) {
      const streak = streakMap.get(device.user_id) ?? 0;

      const title = "\u{1F525} \uC2A4\uD2B8\uB9AD\uC744 \uC720\uC9C0\uD558\uC138\uC694!"; // 🔥 스트릭을 유지하세요!
      let body: string;

      if (streak > 0) {
        body = `${streak}\uC77C \uC5F0\uC18D \uAE30\uB3C4 \uC911\uC774\uC5D0\uC694. \uC624\uB298\uB3C4 \uAE30\uB3C4\uD574\uBCF4\uC138\uC694!`;
        // "{streak}일 연속 기도 중이에요. 오늘도 기도해보세요!"
      } else {
        body =
          "\uC624\uB298\uB3C4 \uAE30\uB3C4\uD574\uBCF4\uC138\uC694. \uC5F0\uC18D \uAE30\uB3C4\uB97C \uC774\uC5B4\uAC00\uC138\uC694!";
        // "오늘도 기도해보세요. 연속 기도를 이어가세요!"
      }

      const result = await sendFcmNotification(device.fcm_token, title, body, {
        type: "streak_reminder",
        route: "/home",
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

    const summary = { sent, failed, skipped: prayedUserIds.size, total: userIds.length };
    console.log("[abba-streak-reminder] Done:", JSON.stringify(summary));

    return new Response(JSON.stringify(summary), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("[abba-streak-reminder] Error:", err);
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
