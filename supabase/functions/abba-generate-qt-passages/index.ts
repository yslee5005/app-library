// Supabase Edge Function: abba-generate-qt-passages
// Runs twice daily via pg_cron (EST 00:00, 12:00)
// Generates 10 themed QT passages × 35 languages = 350 rows per batch

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

const LOCALES: string[] = [
  'en', 'ko', 'ja', 'zh', 'es', 'fr', 'de', 'it', 'pt', 'ru',
  'ar', 'hi', 'th', 'vi', 'id', 'ms', 'fil', 'tr', 'pl', 'nl',
  'sv', 'da', 'no', 'fi', 'cs', 'sk', 'hu', 'ro', 'hr', 'uk',
  'el', 'he', 'am', 'my', 'sw',
]

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

serve(async (req: Request): Promise<Response> => {
  try {
    const supabaseUrl: string = Deno.env.get('SUPABASE_URL')!
    const supabaseKey: string = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const openaiKey: string = Deno.env.get('OPENAI_API_KEY')!

    const supabase = createClient(supabaseUrl, supabaseKey)

    // Parse batch_slot from request body
    let batchSlot: string = 'morning'
    try {
      const body: { batch_slot?: string } = await req.json()
      if (body.batch_slot === 'evening') batchSlot = 'evening'
    } catch {
      // Default to morning if no body
    }

    // Calculate today's date in EST (UTC-5)
    const estNow: Date = new Date(Date.now() - 5 * 60 * 60 * 1000)
    const today: string = estNow.toISOString().split('T')[0]

    // Check if this batch already exists (check English as baseline)
    const { data: existing } = await supabase
      .from('qt_passages')
      .select('id')
      .eq('app_id', 'abba')
      .eq('date', today)
      .eq('batch_slot', batchSlot)
      .eq('locale', 'en')
      .limit(1)

    if (existing && existing.length > 0) {
      return new Response(
        JSON.stringify({ message: 'Already generated', date: today, batch_slot: batchSlot }),
        { headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Build theme descriptions for prompt
    const themeList: string = THEMES.map((t: Theme, i: number) =>
      `${i + 1}. Theme: "${t.key}" — ${t.label}`
    ).join('\n')

    // Generate passages for each locale
    const allRecords: QtRecord[] = []

    for (const locale of LOCALES) {
      const langName: string = LOCALE_NAMES[locale] || locale

      const prompt: string = `Generate 10 Bible passages for daily quiet time (QT), one for each theme below.

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
- Stay politically and socially neutral — focus only on universal human emotions and biblical wisdom

Return JSON array with exactly 10 items in theme order:
[{
  "theme": "anxiety",
  "reference": "Psalm 46:1-2",
  "text": "passage text in ${langName}...",
  "topic": "short topic label in ${langName}"
}]

Only return the JSON array, no other text.`

      try {
        const response: Response = await fetch('https://api.openai.com/v1/chat/completions', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${openaiKey}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            model: 'gpt-4o-mini',
            messages: [
              {
                role: 'system',
                content: `You are a biblical scholar creating daily devotional passages. Always respond with valid JSON. Respond entirely in ${langName}. Stay politically and socially neutral.`,
              },
              { role: 'user', content: prompt },
            ],
            temperature: 0.8,
            max_tokens: 4000,
          }),
        })

        if (!response.ok) {
          console.error(`OpenAI API error for ${locale}: ${response.status}`)
          continue
        }

        const aiResult: Record<string, any> = await response.json()
        const content: string = aiResult.choices[0].message.content.trim()

        let passages: AiPassage[]
        try {
          passages = JSON.parse(content)
        } catch {
          const jsonMatch: RegExpMatchArray | null = content.match(/\[[\s\S]*\]/)
          if (jsonMatch) {
            passages = JSON.parse(jsonMatch[0])
          } else {
            console.error(`Failed to parse JSON for ${locale}`)
            continue
          }
        }

        const records: QtRecord[] = passages.slice(0, 10).map((p: AiPassage, i: number): QtRecord => ({
          app_id: 'abba',
          reference: p.reference,
          locale,
          text: p.text,
          topic: p.topic || '',
          theme: p.theme || THEMES[i].key,
          icon: ICONS[i],
          color_hex: COLORS[i],
          date: today,
          batch_slot: batchSlot,
        }))

        allRecords.push(...records)
      } catch (localeError) {
        console.error(`Error generating for ${locale}:`, localeError)
        continue
      }
    }

    // Batch insert all records
    if (allRecords.length > 0) {
      const { error: insertError } = await supabase
        .from('qt_passages')
        .insert(allRecords)

      if (insertError) {
        throw new Error(`Insert error: ${insertError.message}`)
      }
    }

    return new Response(
      JSON.stringify({
        message: 'Generated successfully',
        date: today,
        batch_slot: batchSlot,
        locales: LOCALES.length,
        total_rows: allRecords.length,
      }),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Error generating QT passages:', error)

    try {
      const supabaseUrl: string = Deno.env.get('SUPABASE_URL')!
      const supabaseKey: string = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
      const supabase = createClient(supabaseUrl, supabaseKey)

      let batchSlot: string = 'morning'
      try {
        const body: { batch_slot?: string } = await req.clone().json()
        if (body.batch_slot === 'evening') batchSlot = 'evening'
      } catch { /* default morning */ }

      const estNow: Date = new Date(Date.now() - 5 * 60 * 60 * 1000)
      const today: string = estNow.toISOString().split('T')[0]
      const yesterday: string = new Date(estNow.getTime() - 86400000).toISOString().split('T')[0]

      const { data: yesterdayPassages } = await supabase
        .from('qt_passages')
        .select('reference, locale, text, topic, theme, icon, color_hex')
        .eq('app_id', 'abba')
        .eq('date', yesterday)
        .eq('batch_slot', batchSlot)

      if (yesterdayPassages && yesterdayPassages.length > 0) {
        const fallback: QtRecord[] = yesterdayPassages.map((p: Record<string, string>): QtRecord => ({
          app_id: 'abba',
          reference: p.reference,
          locale: p.locale,
          text: p.text,
          topic: p.topic,
          theme: p.theme,
          icon: p.icon,
          color_hex: p.color_hex,
          date: today,
          batch_slot: batchSlot,
        }))
        await supabase.from('qt_passages').insert(fallback)
      }
    } catch (fallbackError) {
      console.error('Fallback also failed:', fallbackError)
    }

    return new Response(
      JSON.stringify({ error: String(error) }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
