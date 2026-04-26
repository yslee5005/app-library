// Supabase Edge Function: abba-process-pending-prayer
// (renamed from process_pending_prayer in Phase B2 to match the
//  abba-* convention used by all other app-scoped functions)
//
// Lazy retry handler for prayers where the client-side AI analysis failed.
// Invoked from Flutter Home entry (Phase 5) via POST. Returns immediately
// after kicking off background processing so the client can poll the
// `prayers` row for status transitions.
//
// Two retry paths share this function:
//
//   1. PENDING (full retry, original Phase 4):
//      Rows where the client never finished the initial analysis
//      (ai_status='pending'). The whole pipeline is replayed via the
//      monolithic CORE_PROMPT. TEXT mode only — voice rows wait for the
//      future multimodal audio path.
//
//   2. PARTIAL T2 (Phase B2):
//      Rows where the client got T1 in but T2 (bible_story + testimony)
//      failed mid-stream (ai_status='completed' AND
//      section_status->>'t2'='failed' OR stale 'processing'). The Edge
//      replays only T2 using the per-tier prompt (`_shared/prayer_t2_prompt.ts`)
//      and writes via the admin RPC trio added in Phase B4
//      (claim_failed_tier / complete_tier_admin / revert_tier_processing).
//
// Per-invocation policy: PENDING wins over PARTIAL when both have a
// candidate row, because pending blocks the user's dashboard from rendering
// at all while partial-failed only hides one card.
//
// Cooldown: 10 minutes between retries for the same prayer (both paths).
// Cap: server_retry_count >= MAX_SERVER_RETRIES → row is left in its
// current failed state and not re-claimed (the partial path's
// revert_tier_processing increments the same shared counter).
//
// See:
//   apps/abba/specs/DESIGN.md §10
//   apps/abba/specs/REQUIREMENTS.md §11
//   supabase/migrations/20260425000004_admin_partial_retry_rpcs.sql
//   supabase/functions/_shared/prayer_t2_prompt.ts
//   apps/abba/lib/services/real/section_analyzers/tier2_analyzer.dart
//   .claude/rules/learned-pitfalls.md §2-1, §3

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import {
  PRAYER_T2_SYSTEM,
  buildPrayerT2Prompt,
  buildPrayerT2RetryPrompt,
  type PrayerT1Context,
} from '../_shared/prayer_t2_prompt.ts'
import {
  QT_T2_SYSTEM,
  buildQtT2Prompt,
  type QtT1Context,
} from '../_shared/qt_t2_prompt.ts'

// --- Constants --------------------------------------------------------------

const COOLDOWN_MINUTES = 10
const MAX_SERVER_RETRIES = 10
const PARTIAL_T2_STALE_MINUTES = 10
const GEMINI_MODEL = 'gemini-2.5-flash'
const GEMINI_URL =
  `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent`

// --- Types ------------------------------------------------------------------

interface PendingPrayer {
  id: string
  user_id: string
  transcript: string | null
  mode: 'prayer' | 'qt'
  qt_passage_ref: string | null
  audio_storage_path: string | null
  server_retry_count: number
  last_retry_at: string | null
}

interface PartialPrayer {
  id: string
  user_id: string
  transcript: string | null
  mode: 'prayer' | 'qt'
  result: Record<string, unknown> | null
  section_status: Record<string, string> | null
  server_retry_count: number
  last_retry_at: string | null
}

interface PartialQtPrayer extends PartialPrayer {
  qt_passage_ref: string | null
}

// --- Gemini call ------------------------------------------------------------

const CORE_PROMPT = `You are the world's most compassionate and wise Christian prayer counselor.
The user has just finished praying. Analyze their prayer with deep empathy and biblical wisdom.

CRITICAL RULES:
1. Respond ENTIRELY in {{LANG_NAME}}. Do NOT mix languages.
2. Every field must be in {{LANG_NAME}} only.
3. SCRIPTURE: Do NOT generate verse text. Output only the "reference" — the
   app looks up the exact Public Domain verse text from a bundle. Output
   keys "verse_en"/"verse_ko"/"verse" are FORBIDDEN.
3. The user's prayer transcript is their raw spoken words — summarize and organize it in {{LANG_NAME}}.

Return a JSON object with ONLY these core sections:

{
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in {{LANG_NAME}}"],
    "petition": ["petition items summarized in {{LANG_NAME}}"],
    "intercession": ["intercession items summarized in {{LANG_NAME}}"]
  },
  "scripture": {
    "reference": "Bible reference as lookup KEY. REQUIREMENT: English book name ONLY (e.g., 'Matthew 6:33', 'I Kings 19:12', 'Psalm 23:1-3'). Our bundle uses English keys regardless of {{LANG_NAME}} — NEVER translate the book name.",
    "reason": "Why this verse for this prayer (2-3 sentences in {{LANG_NAME}})",
    "posture": "How to read it — action/mindset (2-3 sentences in {{LANG_NAME}})",
    "key_word_hint": "One key word from the verse with its original-language meaning (1 short line in {{LANG_NAME}}). Leave empty if not confident."
  },
  "bible_story": {
    "title": "story title in {{LANG_NAME}}",
    "summary": "3-4 sentence summary in {{LANG_NAME}}"
  },
  "testimony": "the prayer reorganized as a testimonial narrative in {{LANG_NAME}}"
}

IMPORTANT:
- Be warm, encouraging, biblically accurate. NEVER judge the prayer.
- The scripture must be a REAL Bible verse. Do NOT make up verses.`

const LOCALE_NAMES: Record<string, string> = {
  en: 'English', ko: 'Korean', ja: 'Japanese', zh: 'Chinese',
  es: 'Spanish', fr: 'French', de: 'German', it: 'Italian',
  pt: 'Portuguese', ru: 'Russian', ar: 'Arabic', hi: 'Hindi',
  th: 'Thai', vi: 'Vietnamese', id: 'Indonesian', ms: 'Malay',
  fil: 'Filipino', tr: 'Turkish', pl: 'Polish', nl: 'Dutch',
  sv: 'Swedish', da: 'Danish', no: 'Norwegian', fi: 'Finnish',
  cs: 'Czech', sk: 'Slovak', hu: 'Hungarian', ro: 'Romanian',
  hr: 'Croatian', uk: 'Ukrainian', el: 'Greek', he: 'Hebrew',
  am: 'Amharic', my: 'Burmese', sw: 'Swahili',
}

interface CallGeminiArgs {
  systemPrompt: string
  userPrompt: string
  geminiKey: string
  temperature?: number
}

/**
 * Generic Gemini call. The previous monolithic-only call signature was
 * collapsed into this generalized form during Phase B2 so the partial T2
 * path could share the network/parse layer with the pending full path.
 */
async function callGeminiWithPrompt(
  args: CallGeminiArgs,
): Promise<Record<string, unknown>> {
  const { systemPrompt, userPrompt, geminiKey } = args
  const temperature = args.temperature ?? 0.9

  const payload = {
    systemInstruction: { parts: [{ text: systemPrompt }] },
    contents: [{ role: 'user', parts: [{ text: userPrompt }] }],
    generationConfig: {
      responseMimeType: 'application/json',
      temperature,
    },
  }

  const res = await fetch(`${GEMINI_URL}?key=${geminiKey}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  })

  if (!res.ok) {
    const body = await res.text()
    throw new Error(`Gemini HTTP ${res.status}: ${body.slice(0, 200)}`)
  }

  const data = await res.json()
  const text = data?.candidates?.[0]?.content?.parts?.[0]?.text
  if (typeof text !== 'string' || text.length === 0) {
    throw new Error('Gemini returned no text')
  }
  return parseGeminiJson(text)
}

/**
 * Strip optional ```json fences and parse. Mirrors the client's
 * `Tier2Analyzer._stripCodeFence` + `_parseJson` so partial T2 responses
 * are handled the same way the client would.
 */
function parseGeminiJson(text: string): Record<string, unknown> {
  let cleaned = text.trim()
  if (cleaned.startsWith('```')) {
    const firstNewline = cleaned.indexOf('\n')
    if (firstNewline !== -1) {
      cleaned = cleaned.substring(firstNewline + 1)
      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3).trim()
      }
    }
  }
  return JSON.parse(cleaned) as Record<string, unknown>
}

// --- Request handler --------------------------------------------------------

serve(async (req) => {
  if (req.method !== 'POST') {
    return json({ error: 'method_not_allowed' }, 405)
  }

  const authHeader = req.headers.get('Authorization') ?? ''
  if (!authHeader.startsWith('Bearer ')) {
    return json({ error: 'missing_auth' }, 401)
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL')!
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  const geminiKey = Deno.env.get('GEMINI_API_KEY')

  if (!geminiKey) {
    return json({ error: 'gemini_key_missing' }, 500)
  }

  // Authenticate user via JWT (using service-role client with the caller's
  // token attached so getUser() resolves the JWT identity).
  const userClient = createClient(supabaseUrl, serviceKey, {
    global: { headers: { Authorization: authHeader } },
  })
  const { data: userData, error: userErr } = await userClient.auth.getUser()
  if (userErr || !userData.user) {
    return json({ error: 'unauthorized', detail: userErr?.message }, 401)
  }
  const userId = userData.user.id
  const locale =
    (userData.user.user_metadata?.locale as string | undefined) ?? 'en'

  // Admin client for DB writes (bypass RLS — we've already auth'd above).
  const admin = createClient(supabaseUrl, serviceKey)

  // ---------------------------------------------------------------
  // Path 1 — PENDING full retry (priority): the dashboard cannot
  // render at all until ai_status flips to 'completed', so a pending
  // row blocks more UX than a partial-failed row.
  // ---------------------------------------------------------------
  const pendingResp = await tryPendingPath({
    admin,
    userId,
    locale,
    geminiKey,
  })
  if (pendingResp) return pendingResp

  // ---------------------------------------------------------------
  // Path 2 — PARTIAL T2 retry (Prayer mode): after pending is
  // exhausted, look for ai_status='completed' prayer rows whose T2
  // failed (or stuck 'processing').
  // ---------------------------------------------------------------
  const partialResp = await tryPartialT2Path({
    admin,
    userId,
    locale,
    geminiKey,
  })
  if (partialResp) return partialResp

  // ---------------------------------------------------------------
  // Path 3 — PARTIAL QT T2 retry (Phase B3): same pattern as Path 2
  // but for QT meditation rows. Sequenced after prayer partial so the
  // already-validated path runs first; per-mode created_at ordering
  // applies within each path.
  // ---------------------------------------------------------------
  const partialQtResp = await tryPartialQtT2Path({
    admin,
    userId,
    locale,
    geminiKey,
  })
  if (partialQtResp) return partialQtResp

  return json({ accepted: false, reason: 'no_eligible_prayer' }, 200)
})

// --- Path 1: pending (existing monolithic full retry) -----------------------

async function tryPendingPath(args: {
  // deno-lint-ignore no-explicit-any
  admin: any
  userId: string
  locale: string
  geminiKey: string
}): Promise<Response | null> {
  const { admin, userId, locale, geminiKey } = args

  const cooldownCutoff = new Date(
    Date.now() - COOLDOWN_MINUTES * 60 * 1000,
  ).toISOString()

  const { data: candidates, error: qErr } = await admin
    .schema('abba')
    .from('prayers')
    .select('*')
    .eq('user_id', userId)
    .eq('ai_status', 'pending')
    .lt('server_retry_count', MAX_SERVER_RETRIES)
    .or(`last_retry_at.is.null,last_retry_at.lt.${cooldownCutoff}`)
    .order('created_at', { ascending: true })
    .limit(1)

  if (qErr) {
    return json({ error: 'pending_query_failed', detail: qErr.message }, 500)
  }
  if (!candidates || candidates.length === 0) return null

  const prayer = candidates[0] as PendingPrayer

  // Voice mode pending rows stay pending until the future multimodal path.
  if (prayer.audio_storage_path != null && !prayer.transcript) {
    return json(
      { accepted: false, reason: 'voice_mode_not_supported_yet' },
      200,
    )
  }

  // Atomic lock: flip pending → processing. Concurrent invocation that
  // grabbed the row first leaves count=0; we then bow out.
  const { error: lockErr, count } = await admin
    .schema('abba')
    .from('prayers')
    .update({ ai_status: 'processing' }, { count: 'exact' })
    .eq('id', prayer.id)
    .eq('ai_status', 'pending')

  if (lockErr) {
    return json({ error: 'lock_failed', detail: lockErr.message }, 500)
  }
  if (count === 0) {
    return json({ accepted: false, reason: 'already_processing' }, 200)
  }

  const bg = processPendingInBackground({
    admin,
    prayer,
    locale,
    geminiKey,
  })
  scheduleBackground(bg)

  return json(
    {
      accepted: true,
      path: 'pending',
      prayer_id: prayer.id,
      estimated_seconds: 30,
    },
    202,
  )
}

async function processPendingInBackground(args: {
  // deno-lint-ignore no-explicit-any
  admin: any
  prayer: PendingPrayer
  locale: string
  geminiKey: string
}) {
  const { admin, prayer, locale, geminiKey } = args

  try {
    if (!prayer.transcript) {
      throw new Error('transcript_missing_text_mode')
    }

    const langName = LOCALE_NAMES[locale] ?? 'English'
    const systemPrompt = CORE_PROMPT.replaceAll('{{LANG_NAME}}', langName)

    const result = await callGeminiWithPrompt({
      systemPrompt,
      userPrompt: prayer.transcript,
      geminiKey,
      temperature: 0.9,
    })

    await admin
      .schema('abba')
      .from('prayers')
      .update({
        ai_status: 'completed',
        result: result,
        last_retry_at: new Date().toISOString(),
      })
      .eq('id', prayer.id)

    console.log(`[abba-process-pending-prayer] pending ok id=${prayer.id}`)
  } catch (e) {
    const nextCount = prayer.server_retry_count + 1
    const nextStatus = nextCount >= MAX_SERVER_RETRIES ? 'failed' : 'pending'

    await admin
      .schema('abba')
      .from('prayers')
      .update({
        ai_status: nextStatus,
        server_retry_count: nextCount,
        last_retry_at: new Date().toISOString(),
      })
      .eq('id', prayer.id)

    console.error(
      `[abba-process-pending-prayer] pending fail id=${prayer.id} ` +
        `retry=${nextCount}/${MAX_SERVER_RETRIES} next=${nextStatus} err=${e}`,
    )
  }
}

// --- Path 2: partial T2 retry (Phase B2) ------------------------------------

async function tryPartialT2Path(args: {
  // deno-lint-ignore no-explicit-any
  admin: any
  userId: string
  locale: string
  geminiKey: string
}): Promise<Response | null> {
  const { admin, userId, locale, geminiKey } = args

  const cooldownCutoff = new Date(
    Date.now() - COOLDOWN_MINUTES * 60 * 1000,
  ).toISOString()
  const staleCutoff = new Date(
    Date.now() - PARTIAL_T2_STALE_MINUTES * 60 * 1000,
  ).toISOString()

  // Candidate rule:
  //   - mode='prayer' (QT lives in B3)
  //   - ai_status='completed' (T1 already landed; T2 is the gap)
  //   - transcript present (T2 prompt needs it)
  //   - section_status->>'t2' is 'failed' OR stale 'processing'
  //   - shared retry budget: server_retry_count < MAX_SERVER_RETRIES
  //   - per-row cooldown: last_retry_at older than COOLDOWN_MINUTES (or null)
  //
  // The stale-processing predicate here is also enforced inside
  // claim_failed_tier as a race-safety net. Filtering at SELECT avoids
  // wasting a claim RPC call on rows that are too fresh.
  const orFilter =
    `section_status->>t2.eq.failed,` +
    `and(section_status->>t2.eq.processing,or(last_retry_at.is.null,last_retry_at.lt.${staleCutoff}))`

  const { data: candidates, error: qErr } = await admin
    .schema('abba')
    .from('prayers')
    .select(
      'id,user_id,transcript,mode,result,section_status,server_retry_count,last_retry_at',
    )
    .eq('user_id', userId)
    .eq('mode', 'prayer')
    .eq('ai_status', 'completed')
    .not('transcript', 'is', null)
    .neq('transcript', '')
    .lt('server_retry_count', MAX_SERVER_RETRIES)
    .or(`last_retry_at.is.null,last_retry_at.lt.${cooldownCutoff}`)
    .or(orFilter)
    .order('created_at', { ascending: true })
    .limit(1)

  if (qErr) {
    return json(
      { error: 'partial_query_failed', detail: qErr.message },
      500,
    )
  }
  if (!candidates || candidates.length === 0) return null

  const prayer = candidates[0] as PartialPrayer

  // Build T1 context from the persisted result JSONB. If the row is too
  // sparse (no prayer_summary or no scripture.reference), skip without
  // touching DB state — re-failing an already-failed row would burn a
  // retry without learning anything new. A stuck row will keep returning
  // here for now; rare-enough to accept as data-quality outlier.
  const t1Context = extractT1Context(prayer.result)
  if (!t1Context) {
    console.warn(
      `[abba-process-pending-prayer] partial skipped id=${prayer.id} ` +
        `reason=missing_t1_context`,
    )
    return json(
      { accepted: false, reason: 'missing_t1_context', prayer_id: prayer.id },
      200,
    )
  }

  // Atomic claim: 'failed' → 'processing', or stale 'processing' re-claim.
  // Returns BOOLEAN — false means another invocation grabbed it first or
  // the staleness window is too tight.
  const { data: claimed, error: claimErr } = await admin
    .schema('abba')
    .rpc('claim_failed_tier', {
      p_prayer_id: prayer.id,
      p_user_id: userId,
      p_tier: 't2',
      p_stale_after_minutes: PARTIAL_T2_STALE_MINUTES,
    })

  if (claimErr) {
    return json({ error: 'claim_failed', detail: claimErr.message }, 500)
  }
  if (claimed !== true) {
    return json(
      { accepted: false, reason: 'already_processing', prayer_id: prayer.id },
      200,
    )
  }

  const userName =
    (prayer.result?.user_name as string | undefined) ??
    ''

  const bg = processPartialT2InBackground({
    admin,
    prayer,
    locale,
    geminiKey,
    t1Context,
    userName,
    userId,
  })
  scheduleBackground(bg)

  return json(
    {
      accepted: true,
      path: 'partial_t2',
      prayer_id: prayer.id,
      estimated_seconds: 20,
    },
    202,
  )
}

async function processPartialT2InBackground(args: {
  // deno-lint-ignore no-explicit-any
  admin: any
  prayer: PartialPrayer
  locale: string
  geminiKey: string
  t1Context: PrayerT1Context
  userName: string
  userId: string
}) {
  const { admin, prayer, locale, geminiKey, t1Context, userName, userId } =
    args
  const langName = LOCALE_NAMES[locale] ?? 'English'

  let resultJson: Record<string, unknown> | null = null

  try {
    const basePrompt = buildPrayerT2Prompt({
      transcript: prayer.transcript ?? '',
      locale,
      langName,
      userName,
      t1Context,
    })

    // Attempt 1
    let attempt = await callGeminiWithPrompt({
      systemPrompt: PRAYER_T2_SYSTEM,
      userPrompt: basePrompt,
      geminiKey,
      temperature: 0.75,
    })
    let storyHits = detectBibleStoryPitfalls(attempt['bible_story'])

    // Attempt 2 — only if the first attempt tripped a tradition-error
    // pattern. Mirrors Tier2Analyzer.analyze (lines 100-128).
    if (storyHits.length > 0) {
      console.warn(
        `[abba-process-pending-prayer] partial t2 retry id=${prayer.id} ` +
          `hits=${storyHits.join(',')}`,
      )
      const retryPrompt = buildPrayerT2RetryPrompt(basePrompt, storyHits)
      attempt = await callGeminiWithPrompt({
        systemPrompt: PRAYER_T2_SYSTEM,
        userPrompt: retryPrompt,
        geminiKey,
        temperature: 0.75,
      })
      storyHits = detectBibleStoryPitfalls(attempt['bible_story'])
      if (storyHits.length > 0) {
        throw new Error(
          `tradition_error_after_retry: ${storyHits.join(',')}`,
        )
      }
    }

    const bibleStory = attempt['bible_story']
    const testimonyRaw = attempt['testimony']
    if (
      bibleStory == null ||
      typeof bibleStory !== 'object' ||
      typeof testimonyRaw !== 'string'
    ) {
      throw new Error('t2_response_missing_fields')
    }

    const cleanedTestimony = stripTestimonyOverreach(
      testimonyRaw,
      prayer.transcript ?? '',
    )

    resultJson = {
      bible_story: bibleStory,
      testimony: cleanedTestimony,
    }
  } catch (e) {
    // Atomic revert + retry-count bump (B4 amendment §0).
    const { error: revertErr } = await admin
      .schema('abba')
      .rpc('revert_tier_processing', {
        p_prayer_id: prayer.id,
        p_user_id: userId,
        p_tier: 't2',
        p_increment_retry_count: true,
      })
    console.error(
      `[abba-process-pending-prayer] partial t2 fail id=${prayer.id} ` +
        `retry=${prayer.server_retry_count + 1}/${MAX_SERVER_RETRIES} ` +
        `revert_err=${revertErr?.message ?? 'none'} err=${e}`,
    )
    return
  }

  // Success — atomic merge + flip to 'completed'. The 'processing' guard
  // inside complete_tier_admin protects against stale workers stomping a
  // row that was meanwhile reverted by another invocation.
  const { error: completeErr } = await admin
    .schema('abba')
    .rpc('complete_tier_admin', {
      p_prayer_id: prayer.id,
      p_user_id: userId,
      p_tier: 't2',
      p_section_data: resultJson,
    })

  if (completeErr) {
    console.error(
      `[abba-process-pending-prayer] partial t2 complete_failed id=${prayer.id} ` +
        `err=${completeErr.message}`,
    )
    // The row stays in 'processing' until the stale window expires; next
    // invocation will re-claim. We do not attempt a manual revert here
    // because the lost-the-race scenario is already handled by the guard.
    return
  }

  console.log(`[abba-process-pending-prayer] partial t2 ok id=${prayer.id}`)
}

// --- Partial T2 helpers (ported from Tier2Analyzer) -------------------------

/**
 * Extract the T1 context required by `buildPrayerT2Prompt` from the
 * persisted `result` JSONB. Returns null if the row is missing the keys
 * the T2 prompt depends on (prayer_summary axes + scripture.reference).
 *
 * Tolerates the two shapes the client may have written:
 *   - { prayer_summary: {gratitude,petition,intercession}, scripture: {reference,...} }
 *   - { summary: {gratitude,petition,intercession}, scripture: {reference,...} }
 *
 * The first is what the monolithic CORE_PROMPT and Tier1Analyzer emit;
 * the second is the historical bare-`summary` key. Be liberal in what
 * we accept; the partial path should not fail because of key naming.
 */
function extractT1Context(
  result: Record<string, unknown> | null,
): PrayerT1Context | null {
  if (!result) return null

  const summaryRaw =
    (result['prayer_summary'] as Record<string, unknown> | undefined) ??
    (result['summary'] as Record<string, unknown> | undefined)
  const scriptureRaw = result['scripture'] as
    | Record<string, unknown>
    | undefined
  if (!summaryRaw || !scriptureRaw) return null

  const reference = scriptureRaw['reference']
  if (typeof reference !== 'string' || reference.length === 0) return null

  const asStringList = (v: unknown): string[] => {
    if (!Array.isArray(v)) return []
    return v.filter((x): x is string => typeof x === 'string')
  }

  return {
    scripture: { reference },
    summary: {
      gratitude: asStringList(summaryRaw['gratitude']),
      petition: asStringList(summaryRaw['petition']),
      intercession: asStringList(summaryRaw['intercession']),
    },
  }
}

/**
 * Popular-but-incorrect bible traditions watched for in `bible_story`.
 * Verbatim port of `Tier2Analyzer._bibleStoryTraditionErrors`
 * (apps/abba/lib/services/real/section_analyzers/tier2_analyzer.dart:260-276).
 * Keep in sync.
 */
const BIBLE_STORY_TRADITION_ERRORS: readonly string[] = [
  'three wise men',
  'three kings',
  '세 명의 동방박사',
  '동방박사 세',
  'jonah and the whale',
  '요나와 고래',
  '고래 뱃속',
  'apple in the garden',
  'forbidden apple',
  '선악과 사과',
  'paul fell from his horse',
  "paul's horse",
  '바울이 말에서',
  'mary magdalene was a prostitute',
  '막달라 마리아는 창녀',
]

function detectBibleStoryPitfalls(bibleStory: unknown): string[] {
  if (bibleStory == null || typeof bibleStory !== 'object') return []
  const story = bibleStory as Record<string, unknown>
  const title = typeof story['title'] === 'string' ? story['title'] : ''
  const summary = typeof story['summary'] === 'string' ? story['summary'] : ''
  const haystack = `${title} ${summary}`.toLowerCase()
  return BIBLE_STORY_TRADITION_ERRORS.filter((p) =>
    haystack.includes(p.toLowerCase()),
  )
}

/**
 * Resolution phrases that, when added unprompted, convert a lament into
 * a false testimony of answered prayer. Verbatim port of
 * `Tier2Analyzer._testimonyOverreachPhrases` (lines 280-292). Keep in sync.
 */
const TESTIMONY_OVERREACH_PHRASES: readonly string[] = [
  '응답이라 믿습니다',
  '응답을 주셨습니다',
  '응답해 주셨습니다',
  '평안을 주셨습니다',
  '평안을 주신',
  '치유해 주셨습니다',
  '해결해 주셨습니다',
  "felt god's peace",
  'god answered',
  'god healed',
  'god provided',
]

function escapeRegExp(s: string): string {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
}

/**
 * Mirror of `Tier2Analyzer._stripTestimonyOverreach`. If the user's own
 * transcript already contains the phrase (case-insensitive), it stays —
 * the AI is echoing the user, not fabricating a resolution.
 */
function stripTestimonyOverreach(
  testimony: string,
  transcript: string,
): string {
  const u = transcript.toLowerCase()
  let out = testimony
  const removed: string[] = []
  for (const phrase of TESTIMONY_OVERREACH_PHRASES) {
    if (u.includes(phrase.toLowerCase())) continue
    const escaped = escapeRegExp(phrase)
    const punctPattern = new RegExp(
      `[\\s]*[,\\.][\\s]*${escaped}[\\.\\s]*`,
      'gi',
    )
    if (punctPattern.test(out)) {
      out = out.replace(punctPattern, '.')
      removed.push(phrase)
      continue
    }
    const barePattern = new RegExp(escaped, 'gi')
    if (barePattern.test(out)) {
      out = out.replace(barePattern, '')
      removed.push(phrase)
    }
  }
  if (removed.length > 0) {
    console.warn(
      `[abba-process-pending-prayer] partial t2 testimony overreach stripped: ${removed.join(', ')}`,
    )
    out = out.replace(/\s{2,}/g, ' ').trim()
  }
  return out
}

// --- Path 3: partial QT T2 retry (Phase B3) ---------------------------------

async function tryPartialQtT2Path(args: {
  // deno-lint-ignore no-explicit-any
  admin: any
  userId: string
  locale: string
  geminiKey: string
}): Promise<Response | null> {
  const { admin, userId, locale, geminiKey } = args

  const cooldownCutoff = new Date(
    Date.now() - COOLDOWN_MINUTES * 60 * 1000,
  ).toISOString()
  const staleCutoff = new Date(
    Date.now() - PARTIAL_T2_STALE_MINUTES * 60 * 1000,
  ).toISOString()

  // Candidate rule (mirrors prayer partial path with mode='qt' and the
  // additional `qt_passage_ref IS NOT NULL` gate — QT T2 prompt cannot
  // be built without a passage reference).
  const orFilter =
    `section_status->>t2.eq.failed,` +
    `and(section_status->>t2.eq.processing,or(last_retry_at.is.null,last_retry_at.lt.${staleCutoff}))`

  const { data: candidates, error: qErr } = await admin
    .schema('abba')
    .from('prayers')
    .select(
      'id,user_id,transcript,mode,qt_passage_ref,result,section_status,server_retry_count,last_retry_at',
    )
    .eq('user_id', userId)
    .eq('mode', 'qt')
    .eq('ai_status', 'completed')
    .not('transcript', 'is', null)
    .neq('transcript', '')
    .not('qt_passage_ref', 'is', null)
    .lt('server_retry_count', MAX_SERVER_RETRIES)
    .or(`last_retry_at.is.null,last_retry_at.lt.${cooldownCutoff}`)
    .or(orFilter)
    .order('created_at', { ascending: true })
    .limit(1)

  if (qErr) {
    return json(
      { error: 'partial_qt_query_failed', detail: qErr.message },
      500,
    )
  }
  if (!candidates || candidates.length === 0) return null

  const prayer = candidates[0] as PartialQtPrayer

  // Build QT T1 context. Required: meditation_summary.{topic,summary},
  // scripture.reference, qt_passage_ref column. If any is missing, skip
  // without DB mutation (per user spec — re-failing an already-failed
  // row burns retry budget without learning anything new).
  const t1Context = extractQtT1Context(prayer.result)
  if (!t1Context || !prayer.qt_passage_ref) {
    console.warn(
      `[abba-process-pending-prayer] partial qt skipped id=${prayer.id} ` +
        `reason=missing_t1_context ` +
        `has_meditation_summary=${!!t1Context} has_passage_ref=${!!prayer.qt_passage_ref}`,
    )
    return json(
      { accepted: false, reason: 'missing_t1_context', prayer_id: prayer.id },
      200,
    )
  }

  // Atomic claim — same RPC as prayer path; tier='t2'.
  const { data: claimed, error: claimErr } = await admin
    .schema('abba')
    .rpc('claim_failed_tier', {
      p_prayer_id: prayer.id,
      p_user_id: userId,
      p_tier: 't2',
      p_stale_after_minutes: PARTIAL_T2_STALE_MINUTES,
    })

  if (claimErr) {
    return json({ error: 'claim_failed', detail: claimErr.message }, 500)
  }
  if (claimed !== true) {
    return json(
      { accepted: false, reason: 'already_processing', prayer_id: prayer.id },
      200,
    )
  }

  const userName =
    (prayer.result?.user_name as string | undefined) ?? ''

  const bg = processPartialQtT2InBackground({
    admin,
    prayer,
    locale,
    geminiKey,
    t1Context,
    userName,
    userId,
    passageRef: prayer.qt_passage_ref,
  })
  scheduleBackground(bg)

  return json(
    {
      accepted: true,
      path: 'partial_qt_t2',
      prayer_id: prayer.id,
      estimated_seconds: 20,
    },
    202,
  )
}

async function processPartialQtT2InBackground(args: {
  // deno-lint-ignore no-explicit-any
  admin: any
  prayer: PartialQtPrayer
  locale: string
  geminiKey: string
  t1Context: QtT1Context
  userName: string
  userId: string
  passageRef: string
}) {
  const {
    admin,
    prayer,
    locale,
    geminiKey,
    t1Context,
    userName,
    userId,
    passageRef,
  } = args
  const langName = LOCALE_NAMES[locale] ?? 'English'

  let resultJson: Record<string, unknown> | null = null

  try {
    const userPrompt = buildQtT2Prompt({
      meditation: prayer.transcript ?? '',
      passageRef,
      locale,
      langName,
      userName,
      t1Context,
    })

    // Single attempt — QT path mirrors the client `QtTier2Analyzer`
    // which has no retry/post-processing. Temperature 0.85 matches.
    const attempt = await callGeminiWithPrompt({
      systemPrompt: QT_T2_SYSTEM,
      userPrompt,
      geminiKey,
      temperature: 0.85,
    })

    const application = attempt['application']
    const knowledge = attempt['knowledge']
    if (
      application == null ||
      typeof application !== 'object' ||
      knowledge == null ||
      typeof knowledge !== 'object'
    ) {
      throw new Error('qt_t2_response_missing_fields')
    }

    // Defensive: client `CrossReference.fromJson` requires `reference` as
    // string; a malformed Gemini response could silently land in DB but
    // crash the dashboard parser. Validate the array shape lightly here.
    if (!validateCrossReferences(knowledge as Record<string, unknown>)) {
      throw new Error('qt_t2_cross_references_malformed')
    }

    resultJson = { application, knowledge }
  } catch (e) {
    const { error: revertErr } = await admin
      .schema('abba')
      .rpc('revert_tier_processing', {
        p_prayer_id: prayer.id,
        p_user_id: userId,
        p_tier: 't2',
        p_increment_retry_count: true,
      })
    console.error(
      `[abba-process-pending-prayer] partial qt t2 fail id=${prayer.id} ` +
        `retry=${prayer.server_retry_count + 1}/${MAX_SERVER_RETRIES} ` +
        `revert_err=${revertErr?.message ?? 'none'} err=${e}`,
    )
    return
  }

  const { error: completeErr } = await admin
    .schema('abba')
    .rpc('complete_tier_admin', {
      p_prayer_id: prayer.id,
      p_user_id: userId,
      p_tier: 't2',
      p_section_data: resultJson,
    })

  if (completeErr) {
    console.error(
      `[abba-process-pending-prayer] partial qt t2 complete_failed id=${prayer.id} ` +
        `err=${completeErr.message}`,
    )
    return
  }

  console.log(`[abba-process-pending-prayer] partial qt t2 ok id=${prayer.id}`)
}

// --- Partial QT T2 helpers (ported from QtTier2Analyzer + QT models) --------

/**
 * Extract the QT T1 context required by `buildQtT2Prompt` from the
 * persisted `result` JSONB. Returns null if the row is missing the keys
 * the T2 prompt depends on (`meditation_summary.{topic,summary}` +
 * `scripture.reference`).
 *
 * Caller must additionally verify the row has a non-null `qt_passage_ref`
 * column — that is not in result, so it is the caller's responsibility.
 */
function extractQtT1Context(
  result: Record<string, unknown> | null,
): QtT1Context | null {
  if (!result) return null

  const summaryRaw = result['meditation_summary'] as
    | Record<string, unknown>
    | undefined
  const scriptureRaw = result['scripture'] as
    | Record<string, unknown>
    | undefined
  if (!summaryRaw || !scriptureRaw) return null

  const topic = summaryRaw['topic']
  const summary = summaryRaw['summary']
  const reference = scriptureRaw['reference']
  if (typeof topic !== 'string' || topic.length === 0) return null
  if (typeof summary !== 'string' || summary.length === 0) return null
  if (typeof reference !== 'string' || reference.length === 0) return null

  return {
    meditationSummary: { topic, summary },
    scripture: { reference },
  }
}

/**
 * Verify `knowledge.cross_references` is either absent, an empty array,
 * or an array of objects each carrying a non-empty string `reference`
 * field. The Flutter client's `CrossReference.fromJson` requires
 * `reference` as string; a malformed entry would persist to DB then
 * crash dashboard parsing. Lightweight gate — full schema validation
 * stays in the prompt rubric.
 */
function validateCrossReferences(knowledge: Record<string, unknown>): boolean {
  const refs = knowledge['cross_references']
  if (refs === undefined || refs === null) return true
  if (!Array.isArray(refs)) return false
  for (const entry of refs) {
    if (entry === null || typeof entry !== 'object') return false
    const reference = (entry as Record<string, unknown>)['reference']
    if (typeof reference !== 'string' || reference.length === 0) return false
  }
  return true
}

// --- Helpers ---------------------------------------------------------------

// deno-lint-ignore no-explicit-any
function scheduleBackground(promise: Promise<any>): void {
  const rt = (globalThis as unknown as { EdgeRuntime?: { waitUntil?: (p: Promise<unknown>) => void } }).EdgeRuntime
  if (rt && typeof rt.waitUntil === 'function') {
    rt.waitUntil(promise)
  } else {
    promise.catch((e) => console.error('bg task failed', e))
  }
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  })
}
