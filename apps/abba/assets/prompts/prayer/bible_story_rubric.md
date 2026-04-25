# Bible Story Rubric

> Output field: `bible_story` = `{title, summary}`
> Tier: T2 (background)
> Token target: ~1000

## 0. Output Locale (read first)

> Examples in this rubric may use Korean or English purely for illustration. They do NOT instruct you to write in those languages. Always generate every user-facing field in `{{LANG_NAME}}` using that locale's natural register, idioms, punctuation, and Bible book naming. Reference fields follow the lookup_reference vs display_reference rules in `system_base.md` §1 — when in doubt, the field is a lookup_reference (English).

## 1. Purpose

Retell a short Bible narrative (3-4 sentences) that resonates with the user's prayer. Must be textually accurate (no fabricated dialogue, no anachronism). Build on — not duplicate — the `scripture` selected in T1.

## 2. Forbidden Patterns (first for priority)

### Five commonly fabricated Bible details (never generate these)
1. "Three wise men" — Matthew never specifies the number of magi
2. Jonah swallowed by a "whale" — the text says Hebrew `dag gadol` (דָּג גָּדוֹל, "great fish" / 큰 물고기) and Greek `kētos` (κῆτος, "sea creature" / 바다 짐승); species is unspecified and "whale" is a later translation artefact
3. Mary Magdalene as "former prostitute" — conflation with Luke 7's anonymous woman
4. "Apple" as the forbidden fruit — Genesis says only `the fruit` (`peri`)
5. Paul "falling off his horse" on the Damascus road — Acts mentions no horse

### Anachronistic terms (do not inject modern concepts into ancient text)
- `trauma`, `자존감`, `self-care`, `힐링`, `mental health`, `boundaries`, `toxic`
- Modern psychology / therapy language projected onto biblical characters
- Gender-identity, political, or technological anachronisms

### Narrative prohibitions
- Inventing dialogue not in the text (no quotation marks for non-biblical words)
- Resolving interpretive disputes (Jonah fish historicity, Job authorship) in 3 sentences
- Embellishing with emotional details the text does not supply
- Merging two biblical characters into one composite

### Coherence with T1
- Do NOT retell the story of the verse selected in T1 (e.g., if T1 chose Ps 23, do not tell the "David as shepherd" story)
- Choose a DIFFERENT Biblical narrative that complements T1

## 3. Verification Gates

- [ ] Narrative is real Scripture (cite mental chapter/verse)
- [ ] No forbidden fabricated details
- [ ] No anachronistic modern terms
- [ ] `title` is 2-6 words
- [ ] `summary` is 3-4 sentences
- [ ] No invented dialogue (no quotation marks for fabricated speech)
- [ ] Does not retell the T1 scripture's story

## 4. Scoring Rubric (anchor 1 / 3 / 5)

| Score | Criteria | Example trait |
|-------|----------|---------------|
| 1 | Fabricated details, anachronism, or non-biblical story | "The three wise men brought gifts" / "Jesus felt burnout" |
| 3 | Biblically accurate but generic retelling | Standard "Daniel in the lions' den" summary with no specific connection |
| 5 | Accurate + specific to user's situation + concrete imagery | For user's fear of loss, Ruth choosing Naomi (loyalty in loss), with specific detail like Bethlehem fields |

## 5. Few-Shot Examples

### GOOD-1 (Korean)
**User prayer context**: 아픈 어머니를 위한 기도. T1 scripture: `Psalm 46:1-3`.

**Output**:
```json
{
  "title": "나사로의 무덤에서",
  "summary": "예수님은 죽은 친구 나사로의 무덤 앞에서 우셨습니다 (요한복음 11:35). 전능하신 능력으로 곧 그를 살리실 것을 아시면서도, 마르다와 마리아의 슬픔 앞에서 함께 눈물 흘리셨습니다. 이 장면은 하나님이 우리의 고통을 '해결해야 할 문제'가 아니라 '함께 울어야 할 슬픔'으로 먼저 받으심을 보여줍니다."
}
```
**Why good**: Biblically precise (cites John 11:35 mentally); specific detail (무덤 앞에서 우심); ties to user's mother's suffering; does not retell Ps 46.

### GOOD-2 (English)
**User prayer context**: Grief over miscarriage. T1 scripture: `Matthew 5:4`.

**Output**:
```json
{
  "title": "Hannah's Tears at Shiloh",
  "summary": "Hannah prayed at Shiloh with such grief that Eli the priest thought she was drunk (1 Samuel 1:12-16). She poured out her barren anguish to God without pretending. God heard her unspoken prayer — and so He hears yours, even when tears are the only language left."
}
```
**Why good**: Exact verse citation; vivid concrete setting; honors user's wordless grief; doesn't moralize.

### BAD-1
**User prayer**: 시험 앞둔 학생을 위한 기도.

**Output**:
```json
{
  "title": "다니엘과 세 친구",
  "summary": "다니엘과 세 친구 사드락, 메삭, 아벳느고는 바벨론 포로로 잡혀갔을 때 큰 트라우마를 겪었습니다. 하지만 그들은 자존감을 잃지 않고 믿음을 지켰습니다. 불타는 풀무 속에서 예수님이 네 번째 인물로 나타나셨습니다."
}
```
**Why bad**: Anachronistic terms ("트라우마", "자존감"); fourth-person identification disputed; conflates two separate stories (Daniel 1-2 vs Daniel 3 is the three friends, not Daniel).

### BAD-2
**User prayer**: 직장 스트레스.

**Output**:
```json
{
  "title": "The Three Wise Men",
  "summary": "The three wise men traveled a long journey following the star. Like you at work, they faced exhaustion but kept going. When they arrived and saw Jesus, they knew the journey was worth it."
}
```
**Why bad**: "Three" wise men (Matt 2 doesn't specify number); applied as motivational allegory rather than textually grounded; user's "work stress" vaguely mapped to "journey" without biblical resonance.

## 6. Tone Guidelines

- Historical present tense where natural ("Hannah prays at Shiloh...")
- Specific setting (place, time of day, physical detail) rather than abstract
- One concrete sensory image per retelling
- Avoid "we can learn from this" moralizing — let the narrative speak
- Connect to user's situation in the final sentence, not throughout

## 7. Common Pitfalls (max 6)

1. **Three-wise-men trap** — many "well-known" details are traditional embellishment, not text
2. **Modern psychology injection** — "trauma", "self-care" projected onto ancient figures
3. **Moralizing every sentence** — "like you, Hannah learned to..." is weak; let story stand
4. **Duplicate with T1** — if scripture chose Ps 23, don't tell David's shepherd boyhood
5. **Invented dialogue** — adding `"God, please help me," said David` when Scripture doesn't quote it
6. **Merged characters** — Mary Magdalene ≠ Luke 7 sinner woman; keep them separate
