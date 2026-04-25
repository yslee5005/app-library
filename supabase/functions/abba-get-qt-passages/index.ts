// Supabase Edge Function: abba-get-qt-passages
//
// On-demand single-locale QT passage fetcher. Contrast with
// `abba-generate-qt-passages` (batch, 35 locales, cron-triggered):
// this version generates ONLY the requested locale and caches for the day.
//
// Flow:
//   1. Caller POSTs { locale: "ko" }
//   2. We check abba.qt_passages for today + batch_slot='daily' + locale
//   3. Cache hit (10 rows) → return
//   4. Cache miss → call OpenAI for that locale, INSERT, return
//
// Cost model: pay-per-unique-(date, locale). Early-stage apps with
// traffic concentrated in 2-5 locales save ~90% vs the daily cron batch
// and grow linearly with actual usage.

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

interface Theme {
  key: string
  label: string
}

interface AiPassage {
  theme: string
  reference: string
  text: string
  topic: string
}

interface QtRecord {
  app_id: string
  reference: string
  locale: string
  text: string
  topic: string
  theme: string
  icon: string
  color_hex: string
  date: string
  batch_slot: string
}

const BATCH_SLOT = 'daily'

const THEMES: Theme[] = [
  { key: 'anxiety', label: 'anxiety and fear — for those feeling worried or uncertain' },
  { key: 'loneliness', label: 'loneliness and isolation — for those feeling alone or disconnected' },
  { key: 'grief', label: 'grief and loss — for those mourning or dealing with failure' },
  { key: 'anger', label: 'anger and conflict — for those struggling with frustration or injustice' },
  { key: 'burnout', label: 'exhaustion and burnout — for those feeling overwhelmed by life' },
  { key: 'gratitude', label: 'gratitude and thankfulness — discovering blessings in daily life' },
  { key: 'hope', label: 'hope and restoration — finding light in darkness' },
  { key: 'love', label: 'love and relationships — for family, neighbors, and community' },
  { key: 'forgiveness', label: 'forgiveness and reconciliation — healing and restoring relationships' },
  { key: 'wisdom', label: 'wisdom and discernment — guidance for life decisions' },
]

const ICONS: string[] = ['🌧️', '🕯️', '🍂', '🌊', '🪨', '🌸', '🌅', '💛', '🕊️', '🔍']
const COLORS: string[] = ['#B0BEC5', '#D7CCC8', '#BCAAA4', '#80DEEA', '#CFD8DC', '#FFB7C5', '#FFCCBC', '#FFF9C4', '#C8E6C9', '#D1C4E9']

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

function estDateToday(): string {
  const estNow: Date = new Date(Date.now() - 5 * 60 * 60 * 1000)
  return estNow.toISOString().split('T')[0]
}

serve(async (req: Request): Promise<Response> => {
  try {
    const supabaseUrl: string = Deno.env.get('SUPABASE_URL')!
    const supabaseKey: string = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const geminiKey: string = Deno.env.get('GEMINI_API_KEY')!

    const supabase = createClient(supabaseUrl, supabaseKey)

    // Parse + validate locale
    let locale = 'en'
    try {
      const body: { locale?: string } = await req.json()
      if (body.locale && LOCALE_NAMES[body.locale]) locale = body.locale
    } catch { /* default en */ }

    const today = estDateToday()

    // Cache check
    const { data: existing } = await supabase
      .schema('abba')
      .from('qt_passages')
      .select('*')
      .eq('app_id', 'abba')
      .eq('date', today)
      .eq('batch_slot', BATCH_SLOT)
      .eq('locale', locale)
      .order('created_at', { ascending: true })

    if (existing && existing.length >= 10) {
      return new Response(
        JSON.stringify({ cached: true, passages: existing }),
        { headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Cache miss — generate for this locale
    const langName = LOCALE_NAMES[locale] || 'English'
    const themeList = THEMES.map((t, i) => `${i + 1}. Theme: "${t.key}" — ${t.label}`).join('\n')

    const prompt = `Generate 10 Bible passages for daily quiet time (QT), one for each theme below.

Themes:
${themeList}

Requirements:
- Mix of Old Testament (5) and New Testament (5)
- Each passage should be from a DIFFERENT book of the Bible
- Respond ENTIRELY in ${langName}. Do NOT mix languages.
- Text should be a paraphrased/meditative version (not direct quote for copyright)
- Keep each passage to 2-3 sentences
- Each passage must match its assigned theme
- Include a short topic label (2-3 words) for each theme in ${langName}
- The "reference" field is a DISPLAY reference shown directly on the QT card — NOT a BibleTextService lookup key. Output it in ${langName} using THAT language's natural Bible book naming convention. Chapter:verse numerals stay as digits. Do not output the book name in any language other than ${langName}.
- Stay politically and socially neutral — focus only on universal human emotions and biblical wisdom

Return JSON array with exactly 10 items in theme order:
[{
  "theme": "anxiety",
  "reference": "<book name in ${langName}> chapter:verse — display label, not a lookup key",
  "text": "passage text in ${langName}...",
  "topic": "short topic label in ${langName}"
}]

Only return the JSON array, no other text.`

    // Gemini 2.5 Flash — matches client (gemini_service.dart) for consistency.
    const geminiUrl =
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${geminiKey}`

    const aiRes = await fetch(geminiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        systemInstruction: {
          parts: [{
            text: `You are a biblical scholar creating daily devotional passages. Always respond with valid JSON. Respond entirely in ${langName}. Stay politically and socially neutral.`,
          }],
        },
        contents: [{
          role: 'user',
          parts: [{ text: prompt }],
        }],
        generationConfig: {
          responseMimeType: 'application/json',
          temperature: 0.8,
          maxOutputTokens: 4000,
        },
      }),
    })

    if (!aiRes.ok) {
      return new Response(
        JSON.stringify({ error: `Gemini ${aiRes.status}`, passages: [] }),
        { status: 502, headers: { 'Content-Type': 'application/json' } }
      )
    }

    const aiJson: Record<string, any> = await aiRes.json()
    const content: string =
      aiJson.candidates?.[0]?.content?.parts?.[0]?.text?.trim() ?? ''

    if (!content) {
      return new Response(
        JSON.stringify({ error: 'Empty Gemini response', passages: [] }),
        { status: 502, headers: { 'Content-Type': 'application/json' } }
      )
    }

    let parsed: AiPassage[]
    try {
      parsed = JSON.parse(content)
    } catch {
      const m = content.match(/\[[\s\S]*\]/)
      if (!m) {
        return new Response(
          JSON.stringify({ error: 'Invalid AI JSON', passages: [] }),
          { status: 502, headers: { 'Content-Type': 'application/json' } }
        )
      }
      parsed = JSON.parse(m[0])
    }

    const records: QtRecord[] = parsed.slice(0, 10).map((p, i): QtRecord => ({
      app_id: 'abba',
      reference: p.reference,
      locale,
      text: p.text,
      topic: p.topic || '',
      theme: p.theme || THEMES[i].key,
      icon: ICONS[i],
      color_hex: COLORS[i],
      date: today,
      batch_slot: BATCH_SLOT,
    }))

    // INSERT — unique constraint handles concurrent race:
    // if a parallel caller just inserted, our insert fails; we then re-select.
    const { error: insertErr } = await supabase
      .schema('abba')
      .from('qt_passages')
      .insert(records)

    if (insertErr && !insertErr.message.includes('duplicate')) {
      return new Response(
        JSON.stringify({ error: insertErr.message, passages: [] }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Return — re-fetch to pick up anything a concurrent caller inserted
    const { data: final } = await supabase
      .schema('abba')
      .from('qt_passages')
      .select('*')
      .eq('app_id', 'abba')
      .eq('date', today)
      .eq('batch_slot', BATCH_SLOT)
      .eq('locale', locale)
      .order('created_at', { ascending: true })

    return new Response(
      JSON.stringify({ cached: false, passages: final || records }),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (err) {
    return new Response(
      JSON.stringify({ error: String(err), passages: [] }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
