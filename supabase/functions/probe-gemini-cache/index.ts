// Probe — Gemini caching baseline measurement
// =============================================================================
// THROWAWAY function. Run once before AI gateway migration to decide Full vs Slim.
// Remove after Step C decision is locked.
//
// SECURITY: verify_jwt=false in config.toml + REQUIRES x-probe-token header
// matching PROBE_ADMIN_TOKEN env. Without the operator token guard the URL
// alone would let anyone burn Gemini quota on this project's bill.
//
// What it measures (one HTTP call → JSON summary):
//   1. Implicit caching baseline   — same systemInstruction inline × N calls,
//                                    inspect usageMetadata.cachedContentTokenCount
//   2. Explicit cache create       — POST /v1beta/cachedContents
//   3. Explicit cache use          — generateContent with cachedContent field × N calls
//   4. Cleanup                     — DELETE /v1beta/cachedContents/{name}
//
// Decision inputs derived:
//   - implicit_hit_ratio  = avg(cachedTokens / promptTokens) across implicit runs
//   - explicit_hit_ratio  = avg(cachedTokens / promptTokens) across explicit runs
//   - latency_p50/p95     for both modes
//   - error_rate          per mode
//
// Result interpretation note:
//   cachedContentTokenCount = 0 is NOT proof that caching is impossible.
//   Possible reasons: (a) prompt prefix differs from production, (b) total
//   token count below the 1024-token minimum, (c) cold cache window. Verify
//   with the real production rubric prefix before locking the decision.
//
// Operator usage:
//   curl -X POST 'https://<ref>.functions.supabase.co/probe-gemini-cache' \
//        -H 'apikey: <SUPABASE_ANON_KEY>'                                  \
//        -H 'x-probe-token: <PROBE_ADMIN_TOKEN>'                           \
//        -H 'Content-Type: application/json'                               \
//        -d '{"runs": 5}'

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { PRAYER_RUBRIC_BUNDLE } from './_rubric_bundle.ts'

const MODEL = 'gemini-2.5-flash'
const API_BASE = 'https://generativelanguage.googleapis.com/v1beta'
const MAX_RUNS_PER_PHASE = 10  // hard ceiling — abuse defense + cost cap
const PER_CALL_TIMEOUT_MS = 20_000

// ── DUMMY mode payload ──────────────────────────────────────────────────────
// Hand-stretched generic content. Verified ≥ 1500 tokens so it clears
// Gemini 2.5 Flash's 1024-token explicit cache minimum even with conservative
// tokenizer estimates. Shape is generic on purpose (NOT prayer-app-specific)
// — dummy mode measures the cache machinery itself, not our rubric prefix.
const DUMMY_SYSTEM_INSTRUCTION =
  'You are a content analysis assistant. The following is a generic system instruction designed to be long enough to exercise the Gemini context cache without leaking any production-specific prefix into the measurement. The text below intentionally repeats general guidance multiple times in slightly varied phrasing to clear the 1024-token minimum cache threshold while remaining stable across runs.\n\n'.repeat(6) +
  '\n\nGUIDELINES:\n- Always respond in the language of the user request.\n- Format output as compact JSON when asked.\n- Do not invent facts about real people or institutions.\n- Cite a source string only when the user references a known work; otherwise leave the source field empty.\n- Avoid speculative claims about uncertain events.\n- When uncertain, prefer omission over fabrication.\n- When asked for a number, respond with a numeral, not a word, and include units explicitly.\n- Never use proprietary or trademarked terms unless the user introduces them first.\n- Treat the user words as the only source of factual claims about themselves; do not infer relationships, locations, or outcomes the user did not state.\n- When grammar in the user request is ambiguous, prefer the most neutral interpretation.\n- Emotional language directed at the reader is allowed only as a response framing, never asserted as the user current internal state.\n- Output schemas must be followed exactly; do not add or remove keys.\n- Numerical fields stay numeric; date fields use ISO 8601.\n- Reference identifiers used as lookup keys must remain in their canonical form regardless of the response language.\n- Display labels for the same identifier may be localized for human readers.\n- The distinction between a lookup identifier and a display label must be preserved in every response.\n- When the user asks for a brief answer, prefer two sentences. When asked for a thorough answer, prefer five to eight sentences.\n- Do not add disclaimers when the user did not ask for them.\n- Do not include trailing commentary after a JSON object.\n- Repetition of these guidelines across calls is intentional — it ensures the system instruction has a stable cacheable prefix.\n\nEND OF GUIDELINES.\n\n' +
  'Stable padding line designed to keep the system instruction above the cache minimum threshold while not introducing any production policy. '.repeat(20)

type ProbeMode = 'dummy' | 'prayer'

function getSystemInstruction(mode: ProbeMode): string {
  return mode === 'prayer' ? PRAYER_RUBRIC_BUNDLE : DUMMY_SYSTEM_INSTRUCTION
}

const USER_PROMPT_TEMPLATE = (n: number) =>
  `Test prayer #${n}: Lord, I'm grateful for today and ask for peace for my family.\n` +
  `Return ONLY JSON with keys: scripture (with reference="Psalm 23:1"), nothing else.`

type CallResult = {
  ok: boolean
  status: number
  latencyMs: number
  promptTokens: number
  candidateTokens: number
  cachedTokens: number
  totalTokens: number
  errorBody?: string
}

async function callGenerate(
  apiKey: string,
  systemInstructionInline: string | null,
  cachedContentName: string | null,
  userPrompt: string,
): Promise<CallResult> {
  const start = performance.now()
  const body: Record<string, unknown> = {
    contents: [{ role: 'user', parts: [{ text: userPrompt }] }],
    generationConfig: { temperature: 0.7, maxOutputTokens: 200 },
  }
  if (systemInstructionInline) {
    body.systemInstruction = { parts: [{ text: systemInstructionInline }] }
  }
  if (cachedContentName) {
    body.cachedContent = cachedContentName
  }

  const controller = new AbortController()
  const timer = setTimeout(() => controller.abort(), PER_CALL_TIMEOUT_MS)
  try {
    const res = await fetch(`${API_BASE}/models/${MODEL}:generateContent?key=${apiKey}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
      signal: controller.signal,
    })
    clearTimeout(timer)
    const latencyMs = Math.round(performance.now() - start)
    const json = await res.json()

    if (!res.ok) {
      return {
        ok: false,
        status: res.status,
        latencyMs,
        promptTokens: 0,
        candidateTokens: 0,
        cachedTokens: 0,
        totalTokens: 0,
        errorBody: JSON.stringify(json).slice(0, 500),
      }
    }

    const usage = json.usageMetadata ?? {}
    return {
      ok: true,
      status: res.status,
      latencyMs,
      promptTokens: usage.promptTokenCount ?? 0,
      candidateTokens: usage.candidatesTokenCount ?? 0,
      cachedTokens: usage.cachedContentTokenCount ?? 0,
      totalTokens: usage.totalTokenCount ?? 0,
    }
  } catch (e) {
    clearTimeout(timer)
    const err = e as Error
    return {
      ok: false,
      status: 0,
      latencyMs: Math.round(performance.now() - start),
      promptTokens: 0,
      candidateTokens: 0,
      cachedTokens: 0,
      totalTokens: 0,
      errorBody: err.name === 'AbortError'
        ? `client timeout after ${PER_CALL_TIMEOUT_MS}ms`
        : err.message,
    }
  }
}

async function createCache(
  apiKey: string,
  systemInstruction: string,
): Promise<{ ok: boolean; name?: string; tokenCount?: number; expireTime?: string; status: number; latencyMs: number; errorBody?: string }> {
  const start = performance.now()
  const controller = new AbortController()
  const timer = setTimeout(() => controller.abort(), PER_CALL_TIMEOUT_MS)
  try {
    const res = await fetch(`${API_BASE}/cachedContents?key=${apiKey}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: `models/${MODEL}`,
        systemInstruction: { parts: [{ text: systemInstruction }] },
        ttl: '600s',
        displayName: 'abba_probe',
      }),
      signal: controller.signal,
    })
    clearTimeout(timer)
    const latencyMs = Math.round(performance.now() - start)
    const json = await res.json()
    if (!res.ok) {
      return { ok: false, status: res.status, latencyMs, errorBody: JSON.stringify(json).slice(0, 500) }
    }
    return {
      ok: true,
      status: res.status,
      latencyMs,
      name: json.name,
      tokenCount: json.usageMetadata?.totalTokenCount ?? 0,
      expireTime: json.expireTime,
    }
  } catch (e) {
    clearTimeout(timer)
    const err = e as Error
    return {
      ok: false,
      status: 0,
      latencyMs: Math.round(performance.now() - start),
      errorBody: err.name === 'AbortError'
        ? `client timeout after ${PER_CALL_TIMEOUT_MS}ms`
        : err.message,
    }
  }
}

async function deleteCache(apiKey: string, name: string): Promise<boolean> {
  const controller = new AbortController()
  const timer = setTimeout(() => controller.abort(), PER_CALL_TIMEOUT_MS)
  try {
    const res = await fetch(`${API_BASE}/${name}?key=${apiKey}`, {
      method: 'DELETE',
      signal: controller.signal,
    })
    clearTimeout(timer)
    return res.ok
  } catch {
    clearTimeout(timer)
    return false
  }
}

function summarize(label: string, results: CallResult[]) {
  const ok = results.filter((r) => r.ok)
  const errors = results.filter((r) => !r.ok)
  const latencies = ok.map((r) => r.latencyMs).sort((a, b) => a - b)
  const p50 = latencies[Math.floor(latencies.length * 0.5)] ?? null
  const p95 = latencies[Math.floor(latencies.length * 0.95)] ?? null
  const avgPrompt = ok.length ? Math.round(ok.reduce((s, r) => s + r.promptTokens, 0) / ok.length) : 0
  const avgCached = ok.length ? Math.round(ok.reduce((s, r) => s + r.cachedTokens, 0) / ok.length) : 0
  const hitRatio = avgPrompt > 0 ? Math.round((avgCached / avgPrompt) * 1000) / 1000 : 0
  return {
    label,
    runs: results.length,
    successes: ok.length,
    errors: errors.length,
    error_samples: errors.slice(0, 2).map((e) => ({ status: e.status, body: e.errorBody })),
    avg_prompt_tokens: avgPrompt,
    avg_cached_tokens: avgCached,
    cache_hit_ratio: hitRatio,
    latency_p50_ms: p50,
    latency_p95_ms: p95,
    per_call: ok.map((r) => ({
      prompt: r.promptTokens,
      cached: r.cachedTokens,
      candidate: r.candidateTokens,
      ms: r.latencyMs,
    })),
  }
}

serve(async (req: Request): Promise<Response> => {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'POST only' }), {
      status: 405,
      headers: { 'Content-Type': 'application/json' },
    })
  }

  // Operator token guard — verify_jwt=false on this function means the URL
  // alone would otherwise be public. Block all calls that don't carry the
  // shared admin secret. This must be set as a function env var by the
  // operator (same plane as GEMINI_API_KEY): a long random string only the
  // operator knows, never committed to the repo.
  const expectedToken = Deno.env.get('PROBE_ADMIN_TOKEN')
  if (!expectedToken) {
    return new Response(
      JSON.stringify({ error: 'PROBE_ADMIN_TOKEN env not set on function' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } },
    )
  }
  const presentedToken = req.headers.get('x-probe-token') ?? ''
  if (presentedToken !== expectedToken) {
    return new Response(
      JSON.stringify({ error: 'Unauthorized: x-probe-token header missing or invalid' }),
      { status: 401, headers: { 'Content-Type': 'application/json' } },
    )
  }

  const apiKey = Deno.env.get('GEMINI_API_KEY')
  if (!apiKey) {
    return new Response(JSON.stringify({ error: 'GEMINI_API_KEY not set' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }

  let runs = 5
  let mode: ProbeMode = 'dummy'
  try {
    const body = await req.json()
    // runs — must be an integer in [1, MAX_RUNS_PER_PHASE]
    if (typeof body.runs === 'number') {
      if (!Number.isInteger(body.runs) || body.runs < 1 || body.runs > MAX_RUNS_PER_PHASE) {
        return new Response(
          JSON.stringify({
            error: `runs must be an INTEGER between 1 and ${MAX_RUNS_PER_PHASE}`,
            requested: body.runs,
          }),
          { status: 400, headers: { 'Content-Type': 'application/json' } },
        )
      }
      runs = body.runs
    }
    // mode — must be 'dummy' or 'prayer'
    if (typeof body.mode === 'string') {
      if (body.mode !== 'dummy' && body.mode !== 'prayer') {
        return new Response(
          JSON.stringify({
            error: 'mode must be "dummy" or "prayer"',
            requested: body.mode,
          }),
          { status: 400, headers: { 'Content-Type': 'application/json' } },
        )
      }
      mode = body.mode
    }
  } catch { /* default: 5 runs, dummy mode */ }

  const systemInstruction = getSystemInstruction(mode)

  const startedAt = new Date().toISOString()

  // ---- Phase 1: implicit baseline (system instruction inline) ----
  const implicitResults: CallResult[] = []
  for (let i = 0; i < runs; i++) {
    implicitResults.push(
      await callGenerate(apiKey, systemInstruction, null, USER_PROMPT_TEMPLATE(i + 1)),
    )
  }

  // ---- Phase 2: explicit cache create ----
  const create = await createCache(apiKey, systemInstruction)

  // ---- Phase 3: explicit cache use ----
  const explicitResults: CallResult[] = []
  if (create.ok && create.name) {
    for (let i = 0; i < runs; i++) {
      explicitResults.push(
        await callGenerate(apiKey, null, create.name, USER_PROMPT_TEMPLATE(i + 100)),
      )
    }
  }

  // ---- Phase 4: cleanup ----
  let cleanupOk = false
  if (create.ok && create.name) {
    cleanupOk = await deleteCache(apiKey, create.name)
  }

  const finishedAt = new Date().toISOString()

  return new Response(
    JSON.stringify(
      {
        meta: {
          model: MODEL,
          mode,
          system_instruction_chars: systemInstruction.length,
          runs_per_phase: runs,
          per_call_timeout_ms: PER_CALL_TIMEOUT_MS,
          started_at: startedAt,
          finished_at: finishedAt,
        },
        phase1_implicit: summarize('implicit (inline systemInstruction)', implicitResults),
        phase2_explicit_create: {
          ok: create.ok,
          status: create.status,
          latency_ms: create.latencyMs,
          cache_name: create.name,
          token_count: create.tokenCount,
          expire_time: create.expireTime,
          error: create.errorBody,
        },
        phase3_explicit_use: create.ok
          ? summarize('explicit (cachedContent ref)', explicitResults)
          : { skipped: true, reason: 'cache create failed' },
        phase4_cleanup: { deleted: cleanupOk },
        decision_inputs: {
          implicit_hit_ratio: summarize('', implicitResults).cache_hit_ratio,
          explicit_hit_ratio: create.ok
            ? summarize('', explicitResults).cache_hit_ratio
            : null,
          gap_to_explicit:
            create.ok && implicitResults.length && explicitResults.length
              ? Math.round(
                  (summarize('', explicitResults).cache_hit_ratio -
                    summarize('', implicitResults).cache_hit_ratio) *
                    1000,
                ) / 1000
              : null,
        },
      },
      null,
      2,
    ),
    { headers: { 'Content-Type': 'application/json' } },
  )
})
