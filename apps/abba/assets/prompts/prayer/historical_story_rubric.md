# Historical Story Rubric (Pro)

> Output field: `historical_story` = `{title, reference, summary, lesson}`
> Tier: T3 (Pro, lazy-triggered)
> Token target: ~1200

## 1. Purpose

Tell a real church-history story (not Bible narrative — that's `bible_story`'s job) that connects to the user's prayer. Must be historically verifiable. Maximum hallucination-risk section; strict gates.

## 2. Forbidden Patterns (first for priority)

### Hallucination risks (all banned)
- Fabricated quotes attributed to real figures
- Plausible but unverifiable dates ("In 1547 in Wittenberg...")
- Merged narratives (combining two people's lives into composite)
- Medieval legendary figures (Francis of Assisi anecdotes — many apocryphal)
- Early-church martyr tales outside Eusebius' verifiable corpus
- Living figures (no "Pastor So-and-so in 2020...")
- "Persecuted church in North Korea in year X" anecdotes without citable source

### Content prohibitions
- Hagiographic embellishment (making figures saintly beyond record)
- Moral lessons not supported by actual actions
- Anachronistic psychology ("he struggled with depression and anxiety")
- Theological disputes presented as settled
- Politically charged framing (nationalism, denominational triumphalism)

### Structure prohibitions
- Multiple figures in one story (one figure per narrative)
- Direct quotes without primary-source reference
- `reference` vague ("some time ago", "in the church history") — must be specific

## 3. Verification Gates

### Safe figure whitelist (use only these without additional verification)

**Western**:
- Augustine of Hippo (354-430) — Confessions, City of God verifiable
- Martin Luther (1483-1546) — 95 Theses, Table Talk, letters
- John Calvin (1509-1564) — Institutes, commentaries, letters
- John Wesley (1703-1791) — Journal entries dated
- Charles Spurgeon (1834-1892) — Sermons dated and published
- Dietrich Bonhoeffer (1906-1945) — Letters from Prison, Cost of Discipleship
- George Müller (1805-1898) — Narrative of the Lord's Dealings, Bristol records
- Hudson Taylor (1832-1905) — OMF records, letters
- Corrie ten Boom (1892-1983) — The Hiding Place
- C.S. Lewis (1898-1963) — books, BBC talks
- Billy Graham (1918-2018) — ministry archives

**Korean church history**:
- 주기철 (Ju Gi-Cheol, 1897-1944) — 신사참배 거부 martyrdom
- 손양원 (Son Yang-Won, 1902-1950) — 여수순천 사건, son's killers forgiveness
- 한경직 (Han Kyung-Chik, 1902-2000) — 영락교회, 템플턴상

### Forbidden (without additional user instruction)
- Francis of Assisi (legendary accretions heavy)
- Catherine of Siena, Teresa of Avila (mystic reports disputed)
- Polycarp and other pre-Nicene figures (Eusebius OK, others risky)
- Any contemporary public figure
- "Underground church" anonymous figures (unverifiable)

### Source / reference rules
- `reference` field: specific location + approximate era ("Bristol, 1838" or "City of God, Book XIX")
- Any direct quote in `summary`: must be from verifiable primary source (book + chapter/letter)
- Prefer paraphrase over direct quote
- Max one quote per story

## 4. Scoring Rubric (anchor 1 / 3 / 5)

| Score | Criteria | Example trait |
|-------|----------|---------------|
| 1 | Unverifiable figure/date; fabricated quote; legendary accretion | "In 1203, Francis told the wolf of Gubbio..." |
| 3 | Safe figure + verifiable event but generic retelling | Standard George Müller orphanage summary, no specifics |
| 5 | Safe figure + concrete sensory detail + primary-source quote + specific to user's situation | Müller's November 1838 morning with empty plates; direct quote from his journal |

## 5. Few-Shot Examples

### GOOD-1 (English, excerpt)
**User prayer context**: Financial worry, 은퇴 불안.

**Output**:
```json
{
  "title": "Müller's Daily Trust",
  "reference": "Bristol, 1830s-1840s (Narrative of the Lord's Dealings, Vols I-II)",
  "summary": "George Müller kept a meticulous daily journal of the Bristol orphanage's finances. What the Narrative actually records is not one dramatic rescue but hundreds of small, ordinary entries: a letter arriving with a shilling exactly sufficient for the evening's needs, an anonymous donor leaving coins on the doorstep, a neighbor bringing bread because 'somehow they had baked more than needed today.' Müller's rule was simple — he never asked anyone directly for money, only God — and he wrote down every answer so he could read them back to himself on harder days. The miracle in his pages is the quiet regularity, not the spectacle.",
  "lesson": "Müller's lesson was not that God always sends dramatic baker-at-the-door rescues. It was that trust could be a daily practice — kept honest by writing down what was asked and what was given. Your financial worry does not disqualify you from this kind of bookkeeping before God."
}
```
**Why good**: Müller is on the whitelist; `reference` uses a date *range* rather than a spuriously specific day; summary stays within what Müller himself documented (daily journal pattern — see *Narrative of the Lord's Dealings*, vol I ch. 2-3, archive.org); avoids the popular "empty plates + baker + milkman" scene, which researchers trace to *Adventuring with Sister Abigail* (Grace Sanger, repr. *Sunday School Times* 1920) and is **not** in Müller's own Narrative; the lesson echoes Müller's own practice (journaling answered prayer) rather than projecting a miracle genre.

### GOOD-2 (Korean)
**User prayer context**: 자녀의 믿음 약해짐 속상함.

**Output**:
```json
{
  "title": "손양원의 용서",
  "reference": "여수·순천, 1948",
  "summary": "손양원 목사님의 두 아들이 좌우 이념 충돌 중 학살당했습니다. 목사님은 장례식에서 아들들을 죽인 범인을 용서한다고 선언하셨고, 이후 그 청년을 양자로 삼으셨습니다. 이 용서는 '감정의 초월'이 아니라 '시간을 두고 하나님과 씨름한 결과'였다고, 목사님의 일기와 주변 증언이 기록합니다. 그는 용서하면서도 슬퍼했고, 슬퍼하면서도 용서의 길을 걸었습니다.",
  "lesson": "자녀의 문제로 마음이 무거우신 권사님께 — 용서가 감정을 즉시 정돈해주는 것이 아닙니다. 손 목사님도 슬픔을 안고 걸으셨습니다. 아들에 대한 권사님의 무거운 마음과 믿음이 모순되지 않습니다. 둘 다 안고 주님 앞에 나오시면 됩니다."
}
```
**Why good**: 손양원 whitelist; 1948 verifiable date; specific place (여수·순천); acknowledges complexity (감정 vs 시간); lesson applies to user's specific ache without moralizing.

### BAD-1
**Output**:
```json
{
  "title": "Francis and the Wolf",
  "reference": "Gubbio, Italy",
  "summary": "St. Francis of Assisi encountered a terrifying wolf in the town of Gubbio. He spoke to the wolf, saying 'Brother Wolf, why do you terrorize these people?' The wolf understood and became tame, eating from the townspeople's hands for the rest of its life.",
  "lesson": "Even wild circumstances in your life can be tamed if you speak with faith."
}
```
**Why bad**: Francis of Assisi + wolf legend is hagiographic accretion (from *Fioretti*, 14th century, legendary); no year; fabricated dialogue; moral stretch; Francis NOT on whitelist.

### BAD-2
**Output**:
```json
{
  "title": "The Miracle in Pyongyang",
  "reference": "North Korea, 2015",
  "summary": "A secret believer in Pyongyang named Kim was caught with a Bible. Before the guards could punish him, he prayed and suddenly they fell asleep. He escaped to China and now leads an underground church of 50,000.",
  "lesson": "God still performs miracles for his persecuted people today."
}
```
**Why bad**: Unverifiable "Kim"; contemporary, no primary source; "50,000 underground church" unsubstantiated; miracle account lacks verification; living-figure rule violated; NK persecuted-church anecdotes frequently fabricated in devotional literature.

## 6. Tone Guidelines

- **Historian's register** — not hagiographer's
- **Specific sensory details** over abstract praise
- **Acknowledge complexity** — real lives had doubts, setbacks, slow processes
- **Gentle connection to user's situation** in the `lesson` field, not throughout
- **Primary-source echo** — if using a direct quote, it should be from a cited work

## 7. Common Pitfalls (max 6)

1. **Whitelist drift** — tempting to use Francis, Teresa, Catherine; resist (too much legend)
2. **Fabricated quotes** — "Luther said X" without Table Talk citation
3. **Date confidence** — if uncertain about year, use era ("the 4th century") not specific year
4. **Contemporary anecdote** — underground church, recent revivals: verify before citing
5. **Moralizing lesson** — "you too can have faith like Müller" flattens; better: "this moment of Müller's matches this moment of yours"
6. **Merged narratives** — Corrie ten Boom's watchmaking family ≠ other hidden families; keep distinct
