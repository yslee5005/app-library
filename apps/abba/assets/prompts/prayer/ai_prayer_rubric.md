# AI Prayer Rubric (Pro)

> Output field: `ai_prayer` = `{text, citations}`
> Tier: T3 (Pro, lazy-triggered)
> Token target: ~1500

## 1. Purpose

Compose a ~300-word prayer written FOR the user (not by them). The prayer should feel like it was crafted by a thoughtful pastor who listened to the user's situation. Includes 2-3 citations (real quotes, verifiable studies, or concrete examples).

## 2. Forbidden Patterns (first for priority)

### Theological boundaries
- Prosperity claims: "Father, please give [user] financial abundance"
- Healing guarantees: "We command healing in Jesus' name"
- Outcome dictation: "Please make [user]'s son repent by this weekend"
- Private revelation: "Father, you have shown us that..."
- Cursing others: "Bring judgment on [opponent]"
- Self-congratulation: "[User] has served you faithfully, so now..."

### Structure prohibitions
- Missing Trinitarian closing ("In Jesus' name, Amen" or equivalent)
- Missing submission clause ("in your will", "if it be your will", "주의 뜻대로")
- Starting without addressing God ("Please help with...")
- Ending without Amen equivalent
- Using formal 3rd-person narration ("May [user] receive...")

### Citation prohibitions
- Fabricated quotes (attributing to Augustine, Luther, Bonhoeffer without source)
- "According to recent studies..." without verifiable source
- Anachronistic quotes (modern phrases attributed to ancient figures)
- More than 3 citations (dilutes the prayer)
- Saint invocation in Protestant-baseline context (may include Mary reverently only if user denomination is Catholic/Orthodox)

### Length
- Under 200 words — too thin for 2-minute read
- Over 400 words — loses senior reader

### Coherence with T1+T2
- Do not re-quote the T1 scripture verse directly (may allude)
- Do not repeat the T2 testimony phrases
- DO reference user's specific concern by noun (son's name, surgery, coworker) if given

## 3. Verification Gates

- [ ] Addresses God directly (2nd person)
- [ ] Trinitarian closing present ("In Jesus' name, Amen" / "예수 그리스도의 이름으로 기도드립니다. 아멘." / "En el nombre de Jesús, amén.")
- [ ] Submission clause present
- [ ] 280-350 words in target locale (count more lenient for Korean/Japanese/Chinese)
- [ ] 5-part structure visible (gentle opening → concrete image → insight → specific petition → quiet close)
- [ ] 2-3 citations, each with verifiable source OR honest `source: ""` for examples
- [ ] No forbidden patterns

## 4. Scoring Rubric (anchor 1 / 3 / 5)

| Score | Criteria | Example trait |
|-------|----------|---------------|
| 1 | Formulaic, missing structure, or prosperity-leaning | "God, bless [user] with success and health. Amen." |
| 3 | Complete structure + honest submission + some specificity | Addresses user's situation but feels templated |
| 5 | Poetic + user-specific + citations land authentically + 5-part structure | Opens with concrete image from user's life; submission natural; citations illuminate |

## 5. Few-Shot Examples

### GOOD-1 (English, excerpt — full ~300 words)
**User prayer**: Mother's cancer diagnosis. Scripture selected: `Psalm 46:1-3`.

**Output** (excerpt):
```
"Father of all comfort,

We come before you tonight carrying Hye-jin's mother in our arms — not metaphorically, but as one carries a friend too tired to walk. The diagnosis arrived today, and already the ground has shifted beneath her.

You who held the earth when the mountains shook, hold her now. She does not ask for certainty. She asks to not be alone.

C.S. Lewis once wrote that grief feels like fear — the same fluttering, the same inability to settle. If that is her today, Lord, sit with her in the fluttering. Do not rush her to peace; give her your company before your answers.

We pray — and we know we are only echoing prayers already on her lips — for wisdom for her doctors, for tenderness between her and her daughter, for whatever healing is within your will.

And Father, for Hye-jin herself: when the cooking is done and the visitors gone and she is alone at her kitchen table at 2 AM, may your Spirit be the chair across from her.

In your mercy and in your timing — not ours —
In Jesus' name, Amen."

Citations:
[
  {"type": "quote", "source": "C.S. Lewis, A Grief Observed", "content": "Grief feels like fear — the same fluttering..."},
  {"type": "example", "source": "", "content": "A friend once described 2 AM loneliness..."}
]
```
**Why good**: Concrete image (carrying, fluttering); submission ("whatever healing is within your will", "in your timing not ours"); Trinitarian close; cited C.S. Lewis from verifiable book; user-specific (Hye-jin's mother, 2 AM scene); 5-part structure clear.

### GOOD-2 (Korean, excerpt)
**User prayer**: 손주 진수 수능 긴장.

**Output** (excerpt):
```
"사랑의 아버지,

오늘 권사님이 진수의 수능을 앞두고 주님 앞에 나아오셨습니다. 어제 잠 못 이룬 진수의 뒤척임 소리가 권사님 마음에 들렸고, 그 소리가 지금 주님의 귀에도 닿고 있음을 믿습니다.

주님, 수능이라는 짧은 시간이 진수의 평생을 좌우할 수 없음을 아시면서도, 그 하루가 진수에게는 커 보임을 아시는 분이십니다. 사도 바울이 '평안이 너희 마음과 생각을 지키시리라'(빌립보서 4:7)고 쓴 그 평안을, 시험장 그 자리에 앉아 있는 진수의 숨결에 부어 주시옵소서.

본회퍼는 감옥에서 쓴 편지에 이렇게 적었습니다: '우리의 기도가 하나님을 바꾸는 것이 아니라, 기도하는 우리를 바꾸는 것입니다.' 오늘 이 기도로 권사님과 진수 사이에 주님이 함께 계심을 먼저 믿게 하시옵소서.

진수의 실력을 넘어서는 결과를 구하지 않습니다. 진수가 자신이 준비한 만큼 차분히 내어놓고 돌아올 수 있기를, 그리고 결과 앞에서 너무 낙심하지도 너무 자만하지도 않기를 — 이 모든 것을 주의 뜻 안에서 구합니다.

예수 그리스도의 이름으로 기도드립니다. 아멘."

Citations:
[
  {"type": "quote", "source": "본회퍼, 옥중서간", "content": "우리의 기도가 하나님을 바꾸는 것이 아니라..."},
  {"type": "quote", "source": "Philippians 4:7", "content": "평안이 너희 마음과 생각을 지키시리라"}
]
```
**Why good**: 사도 바울 인용은 정확; 본회퍼 옥중서간 출처 verifiable; specific (진수, 수능, 어제 뒤척임); submission ("주의 뜻 안에서"); Trinitarian 종결; 5-part flow.

### BAD-1 (English)
**Output** (excerpt):
```
"Dear God,

Please bless [user] with prosperity, health, and long life. Give them success in all their endeavors. Remove all obstacles from their path. Heal every disease. Give them favor with every person they meet.

According to recent studies, prayer reduces cortisol by 40%. Augustine said 'Pray and work'. Einstein said science is blind without religion.

In Jesus' name, claim this victory, amen!"
```
**Why bad**: Prosperity list ("bless with prosperity, health, long life"); healing guarantee; "recent studies" unverifiable; "Augustine said" no source; "Einstein said" misattribution; "claim this victory" prosperity framing; not 5-part; no submission.

### BAD-2 (Korean, short)
**Output** (excerpt):
```
"하나님, [유저]가 직장에서 성공하게 해 주세요. 월급이 오르게 해 주세요. 그리고 방해되는 동료들은 징계해 주세요. 신유의 역사를 일으켜 모든 질병을 제하시고, [유저]의 믿음대로 반드시 응답하여 주시옵소서. 아멘."
```
**Why bad**: 프로스퍼리티 ("성공", "월급"); 타인 저주 ("동료 징계"); 치유 보증; "반드시 응답"; 구조 없음 (사실상 1문단); 삼위일체 종결 불완전; submission 없음.

## 6. Tone Guidelines

- **5-part structure** (loose, not rigid):
  1. **Gentle opening** — address God with a soft descriptor ("Father of all comfort", "사랑의 아버지")
  2. **Concrete image** — one specific sensory detail from user's life
  3. **Insight** — from Scripture allusion or cited quote
  4. **Specific petition** — user's actual concern by name, with submission
  5. **Quiet close** — submission to God's timing + Trinitarian ending

- **Register**: Warm but reverent. Allows quiet tears. Avoids theatrical flourishes.
- **For Korean**: 경어체 일관 유지; "~주시옵소서" 자연스러움; 새벽기도 운율 OK but avoid archaic excess.
- **For English**: reverent "Father/Lord"; avoid thee/thou unless locale cue.
- **For Spanish**: `Padre`, `Señor`; `tú` (not `usted`) toward God.
- **Breathing**: Separate scenes with blank lines (`\n\n`) for natural pauses.

## 7. Common Pitfalls (max 6)

1. **Citation fabrication** — "C.S. Lewis said X" without `source` field referencing a real book
2. **Submission missing** — "heal her now" without "within your will"
3. **Prosperity drift** — blessing lists (health, wealth, success) without grounding
4. **Cursing intrusion** — "judge those who harm [user]" has no place here
5. **Scripture re-quote** — don't re-paste T1's verse; may allude
6. **Length miscalibration** — Korean 300 words ≠ English 300 words; tune per locale
