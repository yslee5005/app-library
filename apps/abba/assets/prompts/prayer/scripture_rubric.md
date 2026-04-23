# Scripture Selection Rubric

> Output field: `scripture` = `{reference, reason, posture, key_word_hint}`
> Tier: T1 (immediate)
> Token target: ~1000

## 1. Purpose

Select a Bible verse that speaks directly to the user's specific prayer content. Explain why it fits and how to read it. Provide optional original-language insight.

## 2. Forbidden Patterns (first for priority)

### Over-used verses (must avoid unless thematically necessary)
Rotate across biblical corpus. Avoid these clichés unless they are uniquely apt:
- `Jeremiah 29:11` — overused for generic hope
- `Philippians 4:13` — often decontextualized
- `Romans 8:28` — proof-texted for suffering
- `Psalm 23` — overused default comfort
- `Proverbs 3:5-6` — often misapplied as blank-check guidance
- `Matthew 11:28` — generic "rest"
- `1 Thessalonians 5:18` — overused "give thanks"
- `Isaiah 41:10` — generic "do not fear"
- `John 3:16` — misused outside evangelism context
- `Philippians 4:6-7` — generic anxiety response

### Language rules
- **English book names ONLY** in `reference`. Never `마태복음 6:33`, `マタイ 6:33`, `Mateo 6:33`.
- Format: `Book Chapter:Verse` or `Book Chapter:Verse-Verse` (same chapter range).

### Content prohibitions
- Claiming "the deeper Greek/Hebrew meaning is..." (false depth)
- "The Bible clearly says..." for contested passages
- Prosperity-gospel framing ("God promises you success through this verse")
- Dispensational confusion (applying Old Testament Israel promises directly to individual)
- Proof-texting (citing verse out of its literary/historical context)

## 3. Verification Gates

- [ ] `reference` uses English book name format
- [ ] `reference` not in over-used list (or has strong justification)
- [ ] `reference` is a real canonical Bible verse (66-book Protestant, deutero for Catholic context)
- [ ] `reason` cites specific content from the user's prayer (not generic encouragement)
- [ ] `posture` gives an action or mindset, not abstract platitudes
- [ ] `key_word_hint` only filled when confident about Strong's number; else empty string
- [ ] Chapter-only refs (`Psalm 23`) acceptable for whole-chapter meditations

## 4. Scoring Rubric (anchor 1 / 3 / 5)

| Score | Criteria | Example trait |
|-------|----------|---------------|
| 1 | Verse irrelevant to prayer; clichéd; or translated book name | Selects `Jer 29:11` for any hopeful topic; outputs `마태복음 6:33` |
| 3 | Thematic fit but generic; acceptable but unremarkable | `Philippians 4:6-7` for anxiety — correct but cliché |
| 5 | Specific match to user's situation; rotates beyond cliché pool; reason cites user's words | User prays for grieving sister → `Matthew 5:4`; reason references "your sister's loss" |

## 5. Few-Shot Examples

### GOOD-1 (Korean)
**User prayer**: "주님, 수능 앞둔 손주 진수가 긴장하고 있어요. 어제 잠도 못 잤대요."

**Output**:
```json
{
  "reference": "Isaiah 26:3",
  "reason": "손주 진수가 수능 긴장으로 잠을 못 이룬다는 권사님 마음을 알고 계세요. 이 말씀은 하나님께 마음을 고정할 때 오는 평안을 말합니다.",
  "posture": "진수의 이름을 부르며 이 구절을 조용히 낭독해 보세요. 하나님께서 진수의 마음을 붙드시도록 구하시면 됩니다.",
  "key_word_hint": "'평강(shalom)' = 단순한 평온이 아니라 온전함·회복까지 포함"
}
```
**Why good**: Avoids Jer 29:11 cliché; rotates to Isaiah 26:3; `reason` cites "진수", "수능 긴장", "잠"; posture is concrete action; key_word verified Hebrew.

### GOOD-2 (Spanish)
**User prayer**: "Padre, mi madre fue diagnosticada con cáncer. Me siento perdida."

**Output**:
```json
{
  "reference": "Psalm 46:1-3",
  "reason": "El diagnóstico de tu madre sacude tu suelo. Este salmo fue escrito para quienes sienten la tierra temblar bajo sus pies.",
  "posture": "Lee el salmo pensando en tu madre por nombre. Deja que la imagen de 'refugio' tome forma en tu corazón.",
  "key_word_hint": ""
}
```
**Why good**: Specific to diagnosis; Ps 46 beats generic Ps 23 for this context; `reason` echoes "sentir perdida"; empty `key_word_hint` preferred over fabrication.

### BAD-1
**User prayer**: "주님, 오늘 건강 주셔서 감사합니다."

**Output**:
```json
{
  "reference": "마태복음 6:33",
  "reason": "하나님의 나라를 먼저 구하는 사람에게 주시는 은혜입니다.",
  "posture": "이 말씀을 묵상하시면 은혜가 있을 것입니다.",
  "key_word_hint": "'구하다'의 헬라어 원어 ζητεω는 '끈질기게 추구하다'의 깊은 의미입니다."
}
```
**Why bad**: Korean book name (`마태복음`); irrelevant verse (건강 감사 vs 나라 추구); generic `reason`; vague `posture`; fabricated depth-claim in `key_word_hint`.

### BAD-2
**User prayer**: "God, I'm worried about my job interview tomorrow."

**Output**:
```json
{
  "reference": "Philippians 4:13",
  "reason": "You can do all things through Christ.",
  "posture": "Claim this promise for your interview.",
  "key_word_hint": "The original Greek πάντα means 'absolutely all'."
}
```
**Why bad**: Over-used verse out of context (Paul wrote about contentment in any state, not blank-check strength); proof-texting; "claim this promise" is prosperity framing; fabricated linguistic depth.

## 6. Tone Guidelines

- `reason`: conversational, addresses the user's concrete situation
- `posture`: actionable, physical if possible ("read aloud", "speak their name", "pause")
- `key_word_hint`: educational, humble; prefix with translation (e.g., `'peace' = Hebrew shalom — not just calm but restoration`)

## 7. Common Pitfalls (max 6)

1. **Cliché trap** — defaulting to Ps 23, Jer 29:11, Phil 4:13 when others fit better
2. **Translated book name** — NEVER `마태복음`, `マタイ`, etc.
3. **Decontextualized verse** — ignoring original pericope; Phil 4:13 ≠ "I can accomplish any task"
4. **Abstract reason** — "this will give you peace" without citing user's specific situation
5. **Fabricated etymology** — avoid "the original really means..." if uncertain; omit is safer
6. **Generic posture** — "meditate on this" is weak; give concrete action
