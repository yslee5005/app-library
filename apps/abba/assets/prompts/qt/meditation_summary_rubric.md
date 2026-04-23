# QT Meditation Summary Rubric

> Output field: `meditation_summary` = `{summary, topic, insight}`
> Tier: T1 (immediate)
> Mode: QT
> Token target: ~700

## 1. Purpose

Summarize the user's meditation on a given Bible passage. Extract the topic they focused on and add one insight — something the user's meditation hinted at but didn't fully articulate. Preserve user's voice.

## 2. Forbidden Patterns (first for priority)

- Adding insights the user did not hint at
- Evaluating the meditation ("This is a shallow meditation")
- Moralizing about what the user should have focused on
- Generic platitudes as "insight" ("God loves you")
- Theological categorization beyond what user expressed
- Turning user's specific language into abstract categories

## 3. Verification Gates

- [ ] `summary` is 1-2 sentences summarizing WHAT user meditated on
- [ ] `topic` is 1 short line (3-7 words) naming the theme
- [ ] `insight` is 1-2 sentences — a subtle observation the user's meditation hinted at but didn't state
- [ ] All fields preserve concrete language from user's meditation when possible
- [ ] `insight` never states new theological content user didn't touch
- [ ] Output in `{{LANG_NAME}}` only

## 4. Scoring Rubric (anchor 1 / 3 / 5)

| Score | Criteria | Example |
|-------|----------|---------|
| 1 | Generic summary; invented insight; judgmental | "The user meditated generically. Insight: God loves everyone." |
| 3 | Accurate summary; insight is close but restates | Summary matches; insight just rewords the meditation |
| 5 | Summary preserves concrete detail; insight reveals a subtle thread user hinted at | Insight connects two images in user's meditation they didn't explicitly link |

## 5. Few-Shot Examples

### GOOD-1 (Korean)
**Passage**: `Psalm 23:1-6`
**User meditation**: "시편 23편을 읽으면서 '푸른 풀밭'과 '사망의 음침한 골짜기'가 같은 시편 안에 있다는 게 이상하게 위로가 됐어요. 둘 다 거치는 길인 것 같아서요."

**Output**:
```json
{
  "summary": "시편 23편에서 '푸른 풀밭'과 '사망의 음침한 골짜기'가 함께 등장하는 것이 위로가 되었다고 느끼셨습니다.",
  "topic": "고요와 어둠을 함께 지나는 목자",
  "insight": "'둘 다 거치는 길'이라는 표현이 암시하는 것은, 목자의 임재가 풀밭에서도 어둠 속에서도 동일하다는 인식일 수 있습니다. 경치는 바뀌지만 동행은 바뀌지 않는다는 것."
}
```
**Why good**: Summary preserves "푸른 풀밭", "음침한 골짜기"; topic captures user's theme; insight extends user's hint ("둘 다 거치는 길") without inventing new content.

### GOOD-2 (English)
**Passage**: `Matthew 6:25-34`
**User meditation**: "I kept thinking about the birds. Jesus says they don't worry about food. But birds still work — they fly and search. So maybe 'not worrying' isn't the same as 'not trying'."

**Output**:
```json
{
  "summary": "You focused on the birds in Matthew 6, noting that they don't worry but still actively work to find food.",
  "topic": "Non-anxious work",
  "insight": "Your observation hints at a distinction between anxiety and effort. Jesus' concern is not the user's industriousness but the undercurrent of fear — the bird's flight and the worrier's flight look different from the inside."
}
```
**Why good**: Summary preserves "birds", "work", "fly and search"; topic crisp; insight develops user's own distinction without adding foreign concepts.

### BAD-1
**User meditation**: "오늘 시편 23편이 좋았어요."

**Output**:
```json
{
  "summary": "권사님은 오늘 시편 23편을 깊이 묵상하시며 하나님의 인도하심과 공급하심, 그리고 영원한 사랑에 대한 큰 은혜를 경험하셨습니다.",
  "topic": "하나님의 영원한 사랑",
  "insight": "시편 23편은 구약의 위로 중 가장 깊은 것이며, 당신의 영혼도 이 말씀을 통해 치유될 것입니다."
}
```
**Why bad**: Inflates "좋았어요" into "깊이 묵상하시며 큰 은혜를 경험"; invents content ("영원한 사랑"); predicts outcome ("치유될 것"); makes user said things they didn't say.

### BAD-2
**User meditation**: "I found this passage convicting."

**Output**:
```json
{
  "summary": "The user's meditation was somewhat surface-level and didn't engage with the full depth of the passage.",
  "topic": "Surface reflection",
  "insight": "You should meditate more deeply next time by considering the historical context."
}
```
**Why bad**: Judgmental ("surface-level"); instructional ("should meditate more deeply"); violates "no evaluation" rule.

## 6. Tone Guidelines

- Reflective, like a thoughtful listener
- Preserves user's exact phrasing where it fits
- Insight is invitation, not lecture
- Avoid "you should..." — use "your reflection hints at..." / "your observation suggests..."

## 7. Common Pitfalls (max 6)

1. **Inflation** — turning a short meditation into a grand spiritual journey
2. **Invention** — adding content user didn't touch
3. **Judgment** — "shallow", "deep", rating the meditation
4. **Instruction** — telling user how to meditate better
5. **Abstract drift** — losing user's specific images in generalities
6. **Prophetic overreach** — predicting spiritual outcomes from the meditation
