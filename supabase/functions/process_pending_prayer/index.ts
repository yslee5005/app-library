// Supabase Edge Function: process_pending_prayer
//
// Lazy retry handler for prayers where client-side AI analysis failed.
// Invoked from Flutter Home entry (Phase 5) via POST. Returns immediately
// after kicking off background processing so the client can poll the
// `prayers` row for status transitions.
//
// Scope (Phase 4): TEXT mode only. Voice mode pending prayers stay pending;
// they can still be retried manually by the user via the error view.
// A follow-up (Phase 4.x) will add multimodal audio download + Gemini audio
// input here.
//
// Cooldown: 10 minutes between retries for the same prayer.
// Cap: server_retry_count >= 10 → ai_status='failed' permanent.
//
// See:
//   apps/abba/specs/DESIGN.md §10
//   .claude/rules/learned-pitfalls.md §2-1

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// --- Constants --------------------------------------------------------------

const COOLDOWN_MINUTES = 10
const MAX_SERVER_RETRIES = 10
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

async function callGemini(
  transcript: string,
  locale: string,
  geminiKey: string,
): Promise<Record<string, unknown>> {
  const langName = LOCALE_NAMES[locale] ?? 'English'
  const systemPrompt = CORE_PROMPT.replaceAll('{{LANG_NAME}}', langName)

  const payload = {
    systemInstruction: { parts: [{ text: systemPrompt }] },
    contents: [{ role: 'user', parts: [{ text: transcript }] }],
    generationConfig: {
      responseMimeType: 'application/json',
      temperature: 0.9,
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
  return JSON.parse(text)
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

  // Authenticate user via JWT (using anon-role client with the caller's token).
  const userClient = createClient(supabaseUrl, serviceKey, {
    global: { headers: { Authorization: authHeader } },
  })
  const { data: userData, error: userErr } = await userClient.auth.getUser()
  if (userErr || !userData.user) {
    return json({ error: 'unauthorized', detail: userErr?.message }, 401)
  }
  const userId = userData.user.id

  // Admin client for DB writes (bypass RLS — we've already auth'd).
  const admin = createClient(supabaseUrl, serviceKey)

  // Find one pending prayer respecting cooldown + retry cap.
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
    return json({ error: 'query_failed', detail: qErr.message }, 500)
  }

  if (!candidates || candidates.length === 0) {
    return json({ accepted: false, reason: 'no_eligible_prayer' }, 200)
  }

  const prayer = candidates[0] as PendingPrayer

  // Phase 4 MVP — text-mode only. Voice pending rows remain pending and
  // can be manually retried client-side until Phase 4.x adds audio support.
  if (prayer.audio_storage_path != null && !prayer.transcript) {
    return json(
      { accepted: false, reason: 'voice_mode_not_supported_yet' },
      200,
    )
  }

  // Atomic lock: flip pending → processing. If already locked by concurrent
  // invocation, skip.
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
    // Another concurrent call grabbed this prayer; nothing to do.
    return json({ accepted: false, reason: 'already_processing' }, 200)
  }

  // Fire-and-forget background processing. Deno Edge supports
  // `EdgeRuntime.waitUntil` for post-response work, but a plain dangling
  // promise also works in practice — the function instance stays alive
  // until the promise settles.
  // deno-lint-ignore no-explicit-any
  const rt = (globalThis as any).EdgeRuntime
  const bg = processInBackground({
    admin,
    prayer,
    locale: (userData.user.user_metadata?.locale as string | undefined) ?? 'en',
    geminiKey,
  })
  if (rt && typeof rt.waitUntil === 'function') {
    rt.waitUntil(bg)
  } else {
    // Dangling promise — swallow errors (they're already logged by the
    // background function via DB updates).
    bg.catch((e) => console.error('bg task failed', e))
  }

  return json(
    {
      accepted: true,
      prayer_id: prayer.id,
      estimated_seconds: 30,
    },
    202,
  )
})

// --- Background ------------------------------------------------------------

async function processInBackground(args: {
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

    const result = await callGemini(prayer.transcript, locale, geminiKey)

    await admin
      .schema('abba')
      .from('prayers')
      .update({
        ai_status: 'completed',
        result: result,
        last_retry_at: new Date().toISOString(),
      })
      .eq('id', prayer.id)

    console.log(`[process_pending_prayer] ok id=${prayer.id}`)
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
      `[process_pending_prayer] fail id=${prayer.id} ` +
        `retry=${nextCount}/${MAX_SERVER_RETRIES} next=${nextStatus} err=${e}`,
    )
  }
}

// --- Helpers ---------------------------------------------------------------

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  })
}
