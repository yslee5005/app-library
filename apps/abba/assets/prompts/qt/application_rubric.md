# QT Application Rubric

> Output field: `application` = `{morning_action, day_action, evening_action}`
> Tier: T2 (background)
> Mode: QT
> Token target: ~1000

## 1. Purpose

Propose three concrete applications the user can do today — one in the morning, one during the day, one in the evening. Each action must meet **3P**: Personal (not abstract), Practical (doable), Possible (within today or tomorrow). Drawn from Korean QT tradition but universalized.

## 2. Forbidden Patterns (first for priority)

### 3P violations
- **Non-Personal**: "Christians should love each other" (abstract, who?)
- **Non-Practical**: "Meditate more" (vague, what action?)
- **Non-Possible**: "Fast for 40 days starting tomorrow" (unrealistic)
- "Read the whole book of Romans today" (unrealistic for seniors)

### Tone prohibitions
- Commanding imperatives ("You must..." / "~해야 합니다")
- Grandiose spiritual promises ("This will transform your life")
- Prosperity framing ("God will bless you if...")
- Moralizing ("If you truly love God, you'll...")

### Structure prohibitions
- Multiple actions per time slot
- Overlapping actions (morning and day essentially the same)
- Missing any time slot
- Action without concrete time/place/verb

### Coherence with T1
- Build on `meditation_summary.topic` from T1
- Reference the passage (`{{QT_PASSAGE_REF}}`) concretely in at least one action

## 3. Verification Gates

- [ ] Three distinct actions (morning, day, evening)
- [ ] Each action has: specific VERB + specific WHEN + specific PLACE/CONTEXT
- [ ] All 3P met (Personal, Practical, Possible)
- [ ] None of the actions requires more than 15 minutes
- [ ] Softer verbs ("try", "might", "could") rather than imperatives
- [ ] At least one action touches the passage or user's meditation directly

## 4. Scoring Rubric (anchor 1 / 3 / 5)

| Score | Criteria | Example |
|-------|----------|---------|
| 1 | Abstract, impractical, or generic | "Morning: pray. Day: meditate. Evening: reflect." |
| 3 | Meets 2P (missing one dimension) | "Morning: read Bible" (specific but generic) |
| 5 | All 3P with concrete time/place/verb | "Morning: before rising, whisper 'The Lord is my shepherd' three times while still in bed" |

## 5. Few-Shot Examples

### GOOD-1 (Korean)
**Passage**: `Psalm 23:1-6`
**User meditation**: 고요와 어둠을 함께 지나는 목자.

**Output**:
```json
{
  "morning_action": "일어나기 전, 침대에 누운 채로 '주님은 나의 목자시니'를 세 번 조용히 읊어 보세요. 목소리를 낼 필요는 없습니다.",
  "day_action": "점심 후 업무로 답답할 때, 책상 앞에서 숨을 한 번 깊이 들이쉬며 '주님, 이 오후도 저와 함께 가시죠'라고 속으로 말해 보세요.",
  "evening_action": "저녁 식사 후 가족과 함께 혹은 혼자서 시편 23편 전체를 천천히 한 번 낭독해 보세요. 읽는 속도는 평소의 절반으로."
}
```
**Why good**: All 3P; specific verb-time-place; builds on T1 topic (목자 임재); references passage (시편 23편); under 15 minutes each; softer verbs ("보세요").

### GOOD-2 (English)
**Passage**: `Matthew 6:25-34`
**User meditation**: Non-anxious work.

**Output**:
```json
{
  "morning_action": "Before checking your phone, sit at your kitchen table for 60 seconds with your coffee and silently name one worry. Then say, 'Birds fly without worry. Help me.'",
  "day_action": "At lunch, step outside (or to a window) and watch any bird — pigeon, sparrow — for 2 minutes. Let the observation itself be your prayer.",
  "evening_action": "Before bed, write one line in a notebook naming tomorrow's biggest worry. Tomorrow morning, before reading it, say the morning prayer first."
}
```
**Why good**: 3P all present; concrete verbs (sit, watch, write); specific settings (kitchen table, outside, notebook); connects to meditation's bird image; evening action creates morning-evening loop.

### BAD-1
**Output**:
```json
{
  "morning_action": "Read the Bible in the morning.",
  "day_action": "Pray throughout the day.",
  "evening_action": "Reflect on God's word before sleep."
}
```
**Why bad**: Not Practical (no specific time/duration/passage); not Personal (generic to any user); verbs abstract ("reflect"); no connection to user's specific meditation.

### BAD-2 (Korean)
**Output**:
```json
{
  "morning_action": "매일 새벽 5시에 일어나 1시간 기도하고, 성경 한 권씩 완독하세요.",
  "day_action": "직장에서 예수님의 마음을 품고 동료들을 섬기며 전도하세요.",
  "evening_action": "매일 30분씩 방언기도를 하시면 하나님이 큰 일 하실 것입니다."
}
```
**Why bad**: 비현실적 (새벽 5시 1시간 + 1권 완독); 추상적 ("예수님의 마음"); 교단-민감 ("방언기도"); 프로스퍼리티 ("큰 일 하실 것"); all 3P violated.

## 6. Tone Guidelines

- **Inviting, not commanding** — "~해 보세요", "try", "might try", "could"
- **Grounded in body/place** — actions should involve where the user is physically
- **Match senior capability** — no "run 5km" or "journal for an hour"
- **Short duration** — each action under 15 min, ideally 2-5 min
- **Whisper scale** — suggest quiet, private actions over public spiritual performance

## 7. Common Pitfalls (max 6)

1. **Vague verbs** — "reflect", "meditate", "consider" — replace with observable actions
2. **Duration overreach** — "pray for an hour" is impractical for most
3. **Public actions** — "evangelize coworkers" creates anxiety; prefer private
4. **Denomination-sensitive drift** — "pray in tongues" / "fast 40 days" (Pentecostal/Catholic specific)
5. **Missing time slot connection** — all three actions must be different in character
6. **Abstract morning / practical day / abstract evening** — keep consistency of specificity
