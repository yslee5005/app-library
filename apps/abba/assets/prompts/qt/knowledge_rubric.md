# QT Knowledge Rubric

> Output field: `knowledge` = `{historical_context, cross_references, original_words}`
> Tier: T2 (background)
> Mode: QT
> Token target: ~1000

## 0. Output Locale (read first)

> Examples in this rubric may use Korean or English purely for illustration. They do NOT instruct you to write in those languages. Always generate every user-facing field in `{{LANG_NAME}}` using that locale's natural register, idioms, punctuation, and Bible book naming. Reference fields follow the lookup_reference vs display_reference rules in `system_base.md` §1 — when in doubt, the field is a lookup_reference (English).

## 1. Purpose

Provide scholarly scaffolding for the user's meditation passage: historical context (setting, author, audience), cross-references (2-3 related passages), and original-language words (1-2 key terms with glosses). Highest hallucination-risk section in QT — strict gates.

## 2. Forbidden Patterns (first for priority)

### Hallucination risks
- Invented historical dates ("This letter was written in 52 AD in Corinth...") without scholarly confidence
- Fabricated scholarly consensus ("Most scholars agree that...")
- Made-up Hebrew/Greek etymologies
- Anachronistic assumptions ("Paul had PTSD from his missionary travels")
- Contradicting accepted scholarly range ("Written in 200 BC" for a NT text)

### Original language prohibitions
- Providing Strong's-like gloss without confidence
- "The original Hebrew really means..." (false depth)
- Etymology chains ("This word comes from X which comes from Y")
- Mixing Hebrew and Greek in one entry
- OT verse with Greek word listed, or NT verse with Hebrew (unless intentional context)

### Cross-reference prohibitions
- Over-used verses (Jer 29:11, Phil 4:13, Rom 8:28) unless genuinely apt
- Verses in a different translation than the primary (bundle violation)
- Proof-texting (citing verse out of its context)
- More than 3 cross-references (keep focused)

## 3. Verification Gates

- [ ] `historical_context`: 3-4 sentences, settings facts only (author/date ranges, audience), no speculation
- [ ] `cross_references`: 2-3 entries, each providing ONLY `reference` (English book format). The app fills `text` at runtime from `BibleTextService` in the user's locale — the AI MUST NOT produce verse text itself.
- [ ] `original_words`: 0-2 entries, each with word (Hebrew/Greek), transliteration, language, meaning, context
- [ ] If uncertain about original word, return empty `original_words: []`
- [ ] Historical claims stay within scholarly consensus range
- [ ] Cross-references connect thematically to user's meditation, not just surface keywords

## 4. Scoring Rubric (anchor 1 / 3 / 5)

| Score | Criteria | Example |
|-------|----------|---------|
| 1 | Fabricated etymology; invented dates; over-used cross-refs | "Hebrew 'shalom' means 'prosperity' (KJV) — Jer 29:11 confirms" |
| 3 | Accurate context; cross-refs relevant; original-words empty safely | Standard Psalm 23 context, 2 OT cross-refs, no word |
| 5 | Specific scholarly grounding; fresh cross-refs; one strong original-word gloss | Ps 23 author/date range, cross-ref to John 10:11 + Ezek 34, "ro'i" gloss with Strong's echo |

## 5. Few-Shot Examples

### GOOD-1 (Korean)
**Passage**: `Psalm 23:1-6`

**Output**:
```json
{
  "historical_context": "시편 23편은 다윗의 저작으로 전해지며, 그의 양치기 시절이나 왕으로서의 박해 기간(아마 압살롬의 반란기) 중에 쓰였을 가능성이 학계에서 언급됩니다. 히브리 시편 구조상 '생명의 여정'을 목자-손님 은유로 노래합니다. 정확한 연대는 학자들 간 논의 중입니다.",
  "cross_references": [
    {"reference": "John 10:11"},
    {"reference": "Ezekiel 34:15"}
  ],
  "original_words": [
    {
      "word": "רֹעִי",
      "transliteration": "ro'i",
      "language": "Hebrew",
      "meaning": "나의 목자 — 직업 호칭이 아니라 나를 개인적으로 돌보는 분",
      "context": "'my'라는 소유격이 핵심. 공공의 목자가 아닌 '나의' 목자."
    }
  ]
}
```
**Why good**: Conservative date framing ("학자들 간 논의 중"); cross-refs are fresh (John 10, Ezek 34, not Ps 91); original word is well-established (ro'i), honest gloss.

### GOOD-2 (English)
**Passage**: `Matthew 6:25-34`

**Output**:
```json
{
  "historical_context": "Part of the Sermon on the Mount, likely delivered to a mixed Galilean crowd of peasants and disciples. Matthew's community (Jewish Christian, late 1st century) preserved this discourse. The 'birds of the air' and 'lilies of the field' references fit Palestinian rural imagery.",
  "cross_references": [
    {"reference": "Luke 12:22-31"},
    {"reference": "Philippians 4:6"}
  ],
  "original_words": [
    {
      "word": "μεριμνάω",
      "transliteration": "merimnao",
      "language": "Greek",
      "meaning": "to be divided / pulled apart in the mind — not just 'worry' but anxious splitting of attention",
      "context": "Used 6× in Matt 6:25-34. The opposite is unified focus on God's kingdom."
    }
  ]
}
```
**Why good**: Conservative historical framing; cross-refs complement rather than duplicate; original word (merimnao) has strong lexical basis; gloss acknowledges the word's nuance without overreach.

### BAD-1
**Passage**: `Psalm 23:1-6`

**Output**:
```json
{
  "historical_context": "Psalm 23 was written by David in 1010 BC on a Tuesday evening after he defeated the Philistines. Most scholars agree this was his greatest psalm.",
  "cross_references": [
    {"reference": "Jer 29:11", "text": "For I know the plans I have for you..."}
  ],
  "original_words": [
    {
      "word": "Shalom",
      "transliteration": "shalom",
      "language": "Hebrew",
      "meaning": "Not just peace but prosperity, wealth, and success",
      "context": "Found throughout Psalm 23"
    }
  ]
}
```
**Why bad**: Fabricated date ("Tuesday evening"); false scholarly consensus; Jer 29:11 is over-used and unrelated; "shalom" NOT in Ps 23 text; gloss leans prosperity-gospel ("wealth, success"); only one cross-ref.

### BAD-2
**Passage**: `Romans 8:28`

**Output**:
```json
{
  "historical_context": "Paul wrote Romans after having a vision of Rome's destruction. He was on his third missionary journey when he wrote this letter.",
  "cross_references": [
    {"reference": "Phil 4:13", "text": "I can do all things through Christ..."},
    {"reference": "Jer 29:11", "text": "For I know the plans I have for you..."},
    {"reference": "Rom 8:28", "text": "All things work together for good..."}
  ],
  "original_words": [
    {
      "word": "agape",
      "transliteration": "agape",
      "language": "Greek",
      "meaning": "The highest form of love, sacrificial love, deeper than phileo",
      "context": "This is the kind of love God has for you specifically"
    }
  ]
}
```
**Why bad**: Invented vision; Phil 4:13 + Jer 29:11 are over-used + Rom 8:28 is the passage itself (self-reference); "agape" gloss is cliché Bible-study lore, not strictly accurate (Koine usage more flexible); lacks scholarly precision.

## 6. Tone Guidelines

- **Conservative confidence** — use "likely", "scholars suggest", "traditionally attributed to" over definitive claims
- **Acknowledgment of dispute** when relevant ("Authorship is disputed", "Dating ranges...")
- **Concrete imagery** in historical_context — a peasant listening, a shepherd's landscape — not just facts
- **Cross-refs are invitations** — pick references whose bundled `text` (filled by the app at runtime) will resonate with the user's meditation, not just surface-level keyword matches
- **Original words honest** — if uncertain, empty array is better than fabrication

## 7. Common Pitfalls (max 6)

1. **Confident dates** — Bible dating is often range-based, not precise year
2. **Shalom / agape clichés** — both are overused in devotional writing with sloppy glosses
3. **Over-used cross-refs** — Jer 29:11, Phil 4:13, Rom 8:28 — avoid unless uniquely apt
4. **Self-reference** — don't cross-ref the passage back to itself
5. **Prosperity glosses** — "peace" sliding into "prosperity and wealth"
6. **Empty original_words caution** — when in doubt, empty array is correct behavior
