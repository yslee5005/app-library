// Supabase Edge Function: delete_account
//
// Phase A3 — Option C account deletion.
//
// Deletes the caller's abba data (and their auth.users row IF abba is the
// last ystech app they use). The caller's identity is determined from the
// `Authorization: Bearer <jwt>` header (Supabase forwards it automatically
// when the Flutter client invokes via supabase.functions.invoke).
//
// Scope decision (Option C):
//   1. Always delete: abba.* rows owned by user, public.profiles row scoped
//      to app_id='abba', public.user_devices rows scoped to app_id='abba',
//      prayer-audio storage objects under {user_id}/.
//   2. Only delete auth.users when the caller has no other ystech app
//      profile (public.profiles WHERE id = userId AND app_id <> 'abba'
//      yields nothing). When other apps are present we leave auth.users
//      alone so blacklabelled etc. continue to work.
//
// Order of operations matters:
//   - Owned post / comment ids are pre-collected before any DELETE so
//     reports.target_id (which is NOT a FK) can be cleaned by id match.
//   - Reports go before posts/comments so the trg_reports_sync trigger
//     never updates rows that are about to disappear.
//   - Likes/saves the caller placed on OTHER users' content are deleted
//     explicitly (auth.users CASCADE alone won't fire in the abba_only
//     branch).
//   - Storage purge is best-effort: a failure logs and surfaces in the
//     response but does not stop auth.users deletion.
//
// Idempotent: re-invocation after a complete success is a no-op (every
// DELETE returns 0 rows; auth.admin.deleteUser on a missing user returns
// an error which we swallow as already-gone).
//
// See:
//   apps/abba/specs/REQUIREMENTS.md §11
//   .claude/rules/learned-pitfalls.md (Option C account deletion)

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// --- Constants --------------------------------------------------------------

const APP_ID = 'abba'
const STORAGE_BUCKET = 'prayer-audio'

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

// --- Response helper --------------------------------------------------------

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      'Content-Type': 'application/json',
      ...CORS_HEADERS,
    },
  })
}

// --- Auth helper ------------------------------------------------------------

/**
 * Resolve the caller's user_id from the Authorization header.
 *
 * Uses an anon-keyed client so getUser(jwt) hits Supabase auth and returns
 * the verified payload. Returns null if the JWT is missing/expired/invalid.
 */
async function resolveCallerUserId(req: Request): Promise<string | null> {
  const auth = req.headers.get('Authorization') ?? ''
  const match = auth.match(/^Bearer\s+(.+)$/i)
  if (!match) return null
  const jwt = match[1]

  const supabaseUrl = Deno.env.get('SUPABASE_URL')
  const anonKey = Deno.env.get('SUPABASE_ANON_KEY')
  if (!supabaseUrl || !anonKey) return null

  const anon = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: `Bearer ${jwt}` } },
  })

  const { data, error } = await anon.auth.getUser(jwt)
  if (error || !data?.user?.id) return null
  return data.user.id
}

// --- Main -------------------------------------------------------------------

serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: CORS_HEADERS })
  }
  if (req.method !== 'POST') {
    return json({ error: 'method_not_allowed' }, 405)
  }

  const userId = await resolveCallerUserId(req)
  if (!userId) {
    return json({ error: 'unauthorized' }, 401)
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL')!
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  const admin = createClient(supabaseUrl, serviceKey, {
    auth: { persistSession: false },
  })

  // -------------------------------------------------------------------------
  // 1. Decide scope: full account vs abba-only
  // -------------------------------------------------------------------------
  const { data: otherProfileRows, error: otherProfileErr } = await admin
    .from('profiles')
    .select('app_id')
    .eq('id', userId)
    .neq('app_id', APP_ID)
    .limit(1)

  if (otherProfileErr) {
    return json(
      { error: 'profile_lookup_failed', detail: otherProfileErr.message },
      500,
    )
  }

  const hasOtherApps = (otherProfileRows ?? []).length > 0
  const scope: 'full' | 'abba_only' = hasOtherApps ? 'abba_only' : 'full'

  // -------------------------------------------------------------------------
  // 2. Pre-collect owned post / comment ids before any DELETE so reports
  //    targeted by them can be cleaned by id match.
  // -------------------------------------------------------------------------
  const { data: postRows, error: postIdErr } = await admin
    .schema('abba')
    .from('community_posts')
    .select('id')
    .eq('user_id', userId)
  if (postIdErr) {
    return json(
      { error: 'post_id_collect_failed', detail: postIdErr.message },
      500,
    )
  }
  const ownedPostIds = (postRows ?? []).map((r: { id: string }) => r.id)

  const { data: commentRows, error: commentIdErr } = await admin
    .schema('abba')
    .from('post_comments')
    .select('id')
    .eq('user_id', userId)
  if (commentIdErr) {
    return json(
      { error: 'comment_id_collect_failed', detail: commentIdErr.message },
      500,
    )
  }
  const ownedCommentIds = (commentRows ?? []).map(
    (r: { id: string }) => r.id,
  )

  // -------------------------------------------------------------------------
  // 3. Storage purge (best-effort — failure does not block account delete).
  //    Bucket is per-user via path prefix `{user_id}/...`.
  // -------------------------------------------------------------------------
  let storageRemoved = 0
  let storageFailed = false
  try {
    const { data: listed, error: listErr } = await admin.storage
      .from(STORAGE_BUCKET)
      .list(`${userId}/`, { limit: 1000 })
    if (listErr) throw listErr
    const objectPaths = (listed ?? []).map(
      (entry) => `${userId}/${entry.name}`,
    )
    if (objectPaths.length > 0) {
      const { error: removeErr } = await admin.storage
        .from(STORAGE_BUCKET)
        .remove(objectPaths)
      if (removeErr) throw removeErr
      storageRemoved = objectPaths.length
    }
  } catch (e) {
    storageFailed = true
    console.error('storage purge failed:', (e as Error).message)
  }

  // -------------------------------------------------------------------------
  // 4. Reports cleanup. target_id is not a FK — must be done before posts /
  //    comments disappear, otherwise reports become orphan with no way to
  //    locate them.
  // -------------------------------------------------------------------------
  const counts: Record<string, number> = {}

  // 4a. user's own reports (ditto auth.users CASCADE only — needed for
  //     abba_only branch, harmless in full branch)
  const { count: reportsByUserCount } = await admin
    .schema('abba')
    .from('reports')
    .delete({ count: 'exact' })
    .eq('reporter_id', userId)
    .eq('app_id', APP_ID)
  counts.reports_by_user = reportsByUserCount ?? 0

  // 4b. reports targeting owned posts
  if (ownedPostIds.length > 0) {
    const { count: reportsOnPostsCount } = await admin
      .schema('abba')
      .from('reports')
      .delete({ count: 'exact' })
      .eq('target_type', 'post')
      .in('target_id', ownedPostIds)
      .eq('app_id', APP_ID)
    counts.reports_on_owned_posts = reportsOnPostsCount ?? 0
  } else {
    counts.reports_on_owned_posts = 0
  }

  // 4c. reports targeting owned comments
  if (ownedCommentIds.length > 0) {
    const { count: reportsOnCommentsCount } = await admin
      .schema('abba')
      .from('reports')
      .delete({ count: 'exact' })
      .eq('target_type', 'comment')
      .in('target_id', ownedCommentIds)
      .eq('app_id', APP_ID)
    counts.reports_on_owned_comments = reportsOnCommentsCount ?? 0
  } else {
    counts.reports_on_owned_comments = 0
  }

  // -------------------------------------------------------------------------
  // 5. Likes / saves placed by user on OTHER people's content.
  //    auth.users CASCADE only — won't fire in abba_only branch, so explicit.
  // -------------------------------------------------------------------------
  const { count: postLikesCount } = await admin
    .schema('abba')
    .from('post_likes')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
  counts.post_likes = postLikesCount ?? 0

  const { count: postSavesCount } = await admin
    .schema('abba')
    .from('post_saves')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
  counts.post_saves = postSavesCount ?? 0

  const { count: commentLikesCount } = await admin
    .schema('abba')
    .from('comment_likes')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
  counts.comment_likes = commentLikesCount ?? 0

  // -------------------------------------------------------------------------
  // 6. User's own posts / comments. community_posts.id CASCADE wipes
  //    post_comments / post_likes / post_saves under those posts;
  //    comment_likes cascades via post_comments.id.
  // -------------------------------------------------------------------------
  const { count: ownComments } = await admin
    .schema('abba')
    .from('post_comments')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
  counts.post_comments_owned = ownComments ?? 0

  const { count: ownPosts } = await admin
    .schema('abba')
    .from('community_posts')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
  counts.community_posts_owned = ownPosts ?? 0

  // -------------------------------------------------------------------------
  // 7. Remaining abba.* tables. Belt-and-suspenders even though migration
  //    20260425000003 added CASCADE — covers abba_only branch where
  //    auth.users is preserved.
  // -------------------------------------------------------------------------
  const { count: milestonesCount } = await admin
    .schema('abba')
    .from('milestones')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
  counts.milestones = milestonesCount ?? 0

  const { count: notifSettingsCount } = await admin
    .schema('abba')
    .from('notification_settings')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
  counts.notification_settings = notifSettingsCount ?? 0

  const { count: userSettingsCount } = await admin
    .schema('abba')
    .from('user_settings')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
  counts.user_settings = userSettingsCount ?? 0

  const { count: streaksCount } = await admin
    .schema('abba')
    .from('prayer_streaks')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
  counts.prayer_streaks = streaksCount ?? 0

  const { count: prayersCount } = await admin
    .schema('abba')
    .from('prayers')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
  counts.prayers = prayersCount ?? 0

  // -------------------------------------------------------------------------
  // 8. Public schema, abba-scoped.
  // -------------------------------------------------------------------------
  const { count: userDevicesCount } = await admin
    .from('user_devices')
    .delete({ count: 'exact' })
    .eq('user_id', userId)
    .eq('app_id', APP_ID)
  counts.user_devices = userDevicesCount ?? 0

  const { count: profileCount } = await admin
    .from('profiles')
    .delete({ count: 'exact' })
    .eq('id', userId)
    .eq('app_id', APP_ID)
  counts.profile = profileCount ?? 0

  // -------------------------------------------------------------------------
  // 9. Conditionally delete auth.users (last-app branch).
  //    Failure here does NOT roll back step 1-8 — the user has already been
  //    explicitly purged from abba; the operator can finish the auth removal
  //    manually if needed. We surface the failure in the response.
  // -------------------------------------------------------------------------
  let authUserDeleted = false
  let authUserError: string | null = null
  if (!hasOtherApps) {
    const { error: authErr } = await admin.auth.admin.deleteUser(userId)
    if (authErr) {
      // "User not found" is treated as success (idempotent re-invocation).
      const msg = authErr.message ?? ''
      if (/not.*found/i.test(msg)) {
        authUserDeleted = true
      } else {
        authUserError = msg
        console.error('auth.admin.deleteUser failed:', msg)
      }
    } else {
      authUserDeleted = true
    }
  }

  return json({
    ok: authUserError === null,
    scope,
    auth_user_deleted: authUserDeleted,
    storage_removed: storageRemoved,
    storage_failed: storageFailed,
    counts,
    auth_user_error: authUserError,
  })
})
