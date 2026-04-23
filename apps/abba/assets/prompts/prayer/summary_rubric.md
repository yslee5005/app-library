# Prayer Summary Rubric

> Output field: `summary` = `{gratitude: [], petition: [], intercession: []}`
> Tier: T1 (immediate)
> Token target: ~600

## 1. Purpose

Classify the user's prayer into three axes: gratitude (past blessings acknowledged), petition (personal requests), and intercession (prayers for others). Preserve concrete details from the user's original words.

## 2. Forbidden Patterns (first for priority)

- Adding theological categories the user did not express
- Abstracting concrete language ("가족 건강" → "육신의 연약함을 위하여 기도함")
- Inserting AI's own interpretations as if they were the user's
- Inventing recipients of intercession the user didn't name
- Labeling prayers as "inappropriate" or "unsuitable"
- Evaluating or scoring the prayer
- "Your gratitude list is incomplete" / "You should also thank God for..."

## 3. Verification Gates

- [ ] Each array item is a concrete phrase (not abstract "being grateful")
- [ ] Items preserve user's exact imagery where possible
- [ ] No array has more than 5 items (keep lists short)
- [ ] Empty arrays allowed when axis not expressed
- [ ] Output in `{{LANG_NAME}}` only

## 4. Scoring Rubric (anchor 1 / 3 / 5)

| Score | Criteria | Example trait |
|-------|----------|---------------|
| 1 | All axes missing or misclassified | Puts "I thank God" into petition |
| 3 | At least 2 axes correctly classified | Most items right, some drift |
| 5 | All 3 axes accurate + preserves user's specific details | "손주 진수가 오늘 수능 잘 보게 해주세요" kept as-is |

## 5. Few-Shot Examples

### GOOD-1 (Korean)
**User prayer**: "주님, 오늘 아침 건강하게 눈 뜨게 해주셔서 감사합니다. 우리 아들 민수가 직장에서 스트레스 많은 것 같은데 잘 견디게 해주세요. 옆집 김집사님 수술 잘 받으시도록 기도합니다."

**Output**:
```json
{
  "gratitude": ["오늘 아침 건강하게 눈 뜨신 것"],
  "petition": ["아들 민수가 직장 스트레스를 잘 견디는 것"],
  "intercession": ["옆집 김집사님의 수술이 잘 되는 것"]
}
```
**Why good**: Preserves "민수", "김집사님" concrete names; no abstraction; correct 3-axis split.

### GOOD-2 (English)
**User prayer**: "Lord, thank you for the rain yesterday. Please help my sister find a job. And I pray for the Johnsons — they just lost their father."

**Output**:
```json
{
  "gratitude": ["the rain yesterday"],
  "petition": ["my sister finding a job"],
  "intercession": ["the Johnsons, mourning their father"]
}
```
**Why good**: Uses user's exact names; intercession preserves both relationship and context.

### BAD-1 (Korean)
**User prayer**: "주님, 오늘도 감사합니다. 아들 건강 위해 기도합니다."

**Output**:
```json
{
  "gratitude": ["일반적 은혜에 대한 감사", "주님의 돌봄", "하루를 허락하신 것"],
  "petition": ["가족 구성원의 영적 성장", "평안한 일상"],
  "intercession": ["교회와 성도들", "국가와 지도자들"]
}
```
**Why bad**: Hallucinated content user didn't say ("교회와 성도들", "국가"); added "영적 성장" abstraction; expanded single gratitude into 3.

### BAD-2 (English)
**User prayer**: "God, I'm struggling with anger at my boss."

**Output**:
```json
{
  "gratitude": [],
  "petition": ["dealing with workplace issues"],
  "intercession": ["may God forgive my angry heart"]
}
```
**Why bad**: "dealing with workplace issues" loses the specific "anger at boss"; "may God forgive my angry heart" judges the user's prayer.

## 6. Tone Guidelines

Not a tone-heavy section — output is structured data. Preserve user's own phrasing tone rather than substituting formal register.

## 7. Common Pitfalls (max 6)

1. **Over-abstraction** — User says "무릎 수술", output says "신체의 건강" → keep "무릎 수술"
2. **Axis confusion** — "I'm worried about my mom" is petition, not intercession (user is worrier; mom is object but user's concern)
3. **Adding unspoken items** — don't fill empty arrays with generic filler
4. **Evaluative commentary** — array items should be noun phrases, not AI's commentary
5. **Proselytizing drift** — don't add "회개함" / "용서 구함" if user didn't express these
6. **Translation leakage** — output language must match `{{LANG_NAME}}`, not mix
