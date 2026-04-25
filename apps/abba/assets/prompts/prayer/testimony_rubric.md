# Testimony Rubric

> Output field: `testimony` (single string, 150-250 characters in `{{LANG_NAME}}`)
> Tier: T2 (background)
> Token target: ~700

## 1. Purpose

Reorganize the user's raw prayer into a personal testimony — a first-person narrative the user could share with a friend or small group. Preserve their concrete language and emotional honesty.

## 2. Forbidden Patterns (first for priority)

### Spiritualizing / falsifying patterns
- Turning unanswered prayers into "answered" or "experienced breakthrough"
- Manufacturing emotional resolution ("I felt God's peace") when user expressed ongoing distress
- Converting present-tense struggles ("I'm worried") into past-completion ("I overcame worry")
- Adding theological content the user didn't express

### Tone prohibitions
- Third-person formal narration ("The user prayed about...")
- Formal register that sounds translated, not lived
- Adding "I realized..." / "God showed me..." without the user expressing this
- "Your prayer pleased God" — valuation of prayer
- "I repented of..." — putting confession in user's mouth without cue

### Length violations
- Under 100 chars — too thin to feel like testimony
- Over 300 chars — too long for a single-card display

### Coherence with T1
- May reference the user's concrete prayer items from summary
- Should NOT quote the T1 scripture passage directly (scripture lives in scripture card)

## 3. Verification Gates

- [ ] Written in first person (I / 저 / yo / ich etc.)
- [ ] 150-250 characters in target locale
- [ ] Preserves at least one concrete phrase from user's original prayer
- [ ] Tense matches user's situation (ongoing ≠ resolved)
- [ ] No invented theological content (no phantom "깨달음")
- [ ] Natural conversational register (not formal)

## 4. Scoring Rubric (anchor 1 / 3 / 5)

| Score | Criteria | Example trait |
|-------|----------|---------------|
| 1 | 3rd person formal; resolution falsified; generic | "The believer offered prayer today and received peace." |
| 3 | 1st person, right length, but loses user's specific voice | "I prayed for my family today and asked God for help." |
| 5 | 1st person + user's specific words preserved + honest tense | "오늘 새벽, 진수가 수능 앞두고 잠 못 이루는 걸 보며 마음이 무거워 주님 앞에 엎드렸습니다. 해결됐다 말하기엔 이르지만, 혼자 지는 짐이 아니라는 것만은 알겠습니다." |

## 5. Few-Shot Examples

### GOOD-1 (Korean)
**User prayer**: "주님, 우리 아들 민수가 요즘 교회를 잘 안 나가요. 속상합니다. 다시 마음 돌이키게 해주세요."

**Output**:
```
"아들 민수가 교회를 멀리한 지 몇 달이 됐습니다. 속상한 마음을 부인하지 않고 주님께 가져갔습니다. 민수가 돌아오길 기다리는 이 마음도 함께 기도로 올려드립니다."
```
**Why good**: 1st person; keeps "민수", "교회", "속상"; tense honest (not claiming an answer the user never received); natural conversational. **AVOID** phrasing like "이것도 응답이라 믿습니다" — the user did not say they received an answer; declaring one on their behalf is fabrication.

### GOOD-2 (English)
**User prayer**: "God, I've been struggling with anger toward my coworker. I know I should forgive but it's hard."

**Output**:
```
"I brought my anger toward Sarah at work to God today, without pretending it was smaller than it is. Forgiveness still feels far. But I admitted it out loud to the One who sees, and that felt like a first honest step."
```
**Why good**: 1st person; keeps "anger", "coworker" (Sarah added as placeholder OK); honest about ongoing struggle; no fake resolution.

### BAD-1
**User prayer**: "주님, 아들 민수가 교회 안 나가서 속상합니다."

**Output**:
```
"권사님은 오늘 아들을 위해 기도하며 큰 깨달음을 얻으셨습니다. 주님께서 민수의 마음을 돌이키실 것을 믿음으로 고백하시며 평안을 얻으셨습니다."
```
**Why bad**: 3rd person ("권사님은"); adds phantom "깨달음" user didn't report; falsifies resolution ("평안을 얻으셨습니다"); formal translated register.

### BAD-2
**User prayer**: "Lord, help me with my stress at work. It's overwhelming."

**Output**:
```
"Today I prayed and God showed me that stress is just the enemy trying to steal my peace. I repented of not trusting Him enough and received His perfect rest. I will walk in victory now."
```
**Why bad**: Invented "God showed me"; spiritual-warfare framing user didn't express; forced confession ("repented"); prosperity-like claim ("walk in victory"); falsified resolution.

## 6. Tone Guidelines

- Conversational, like writing in a journal
- Preserves user's register (informal user → informal output)
- Allow emotional honesty (sadness, anger, doubt) without "but then I felt better" cliché
- If user's prayer ended in hope, testimony ends in hope. If it ended unresolved, leave it unresolved.
- Use user's exact nouns when possible: names, places, body parts, specific events

## 7. Common Pitfalls (max 6)

1. **Resolution falsification** — user still struggling, but output claims "peace found"
2. **3rd person drift** — testimony is "I", not "the user" or "권사님은"
3. **Phantom insights** — adding "I realized..." when user expressed no realization
4. **Over-spiritualizing** — ordinary frustration becomes "the enemy's attack"
5. **Forced confession** — adding "I repented" / "회개하며" when user didn't cue it
6. **Translated register** — awkwardly formal sentences that sound AI, not human
