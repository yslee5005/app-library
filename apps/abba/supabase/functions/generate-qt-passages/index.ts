// Supabase Edge Function: generate-qt-passages
// Runs daily via pg_cron to generate 5 QT passages using GPT-4o-mini

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const ICONS = ['🌸', '🌿', '🐦', '☀️', '💧']
const COLORS = ['#FFB7C5', '#B2DFDB', '#D1C4E9', '#FFCCBC', '#B3E5FC']

serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const openaiKey = Deno.env.get('OPENAI_API_KEY')!

    const supabase = createClient(supabaseUrl, supabaseKey)

    // Check if today's passages already exist
    const today = new Date().toISOString().split('T')[0]
    const { data: existing } = await supabase
      .from('qt_passages')
      .select('id')
      .eq('app_id', 'abba')
      .eq('date', today)
      .limit(1)

    if (existing && existing.length > 0) {
      return new Response(
        JSON.stringify({ message: 'Already generated for today', date: today }),
        { headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Generate passages using GPT-4o-mini
    const prompt = `Generate 5 Bible passages for daily quiet time (QT).
Requirements:
- Mix of Old Testament (2) and New Testament (3)
- Each passage should be from a DIFFERENT book
- Provide both English and Korean text
- Text should be a paraphrased/meditative version (not direct quote for copyright)
- Keep each passage to 2-3 sentences

Return JSON array with exactly 5 items:
[{
  "reference": "Psalm 23:1-3",
  "text_en": "The Lord watches over me like a shepherd...",
  "text_ko": "주님은 목자처럼 나를 돌보시며..."
}]

Only return the JSON array, no other text.`

    const response = await fetch('https://api.openai.com/v1/chat/completions', {
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
            content: 'You are a biblical scholar creating daily devotional passages. Always respond with valid JSON.',
          },
          { role: 'user', content: prompt },
        ],
        temperature: 0.8,
        max_tokens: 2000,
      }),
    })

    if (!response.ok) {
      throw new Error(`OpenAI API error: ${response.status}`)
    }

    const aiResult = await response.json()
    const content = aiResult.choices[0].message.content.trim()

    // Parse the JSON response
    let passages: Array<{ reference: string; text_en: string; text_ko: string }>
    try {
      passages = JSON.parse(content)
    } catch {
      // Try to extract JSON from markdown code block
      const jsonMatch = content.match(/\[[\s\S]*\]/)
      if (jsonMatch) {
        passages = JSON.parse(jsonMatch[0])
      } else {
        throw new Error('Failed to parse AI response as JSON')
      }
    }

    // Insert into qt_passages
    const records = passages.slice(0, 5).map((p, i) => ({
      app_id: 'abba',
      reference: p.reference,
      text_en: p.text_en,
      text_ko: p.text_ko,
      icon: ICONS[i],
      color_hex: COLORS[i],
      date: today,
    }))

    const { error: insertError } = await supabase
      .from('qt_passages')
      .insert(records)

    if (insertError) {
      throw new Error(`Insert error: ${insertError.message}`)
    }

    return new Response(
      JSON.stringify({ message: 'Generated successfully', date: today, count: records.length }),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    // On error, fallback: copy yesterday's passages with today's date
    console.error('Error generating QT passages:', error)

    try {
      const supabaseUrl = Deno.env.get('SUPABASE_URL')!
      const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
      const supabase = createClient(supabaseUrl, supabaseKey)

      const today = new Date().toISOString().split('T')[0]
      const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0]

      const { data: yesterdayPassages } = await supabase
        .from('qt_passages')
        .select('reference, text_en, text_ko, icon, color_hex')
        .eq('app_id', 'abba')
        .eq('date', yesterday)

      if (yesterdayPassages && yesterdayPassages.length > 0) {
        const fallback = yesterdayPassages.map((p) => ({
          ...p,
          app_id: 'abba',
          date: today,
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
