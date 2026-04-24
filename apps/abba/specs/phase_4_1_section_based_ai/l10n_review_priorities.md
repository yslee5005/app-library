# Phase 4.1 Translation — Reviewer Priority Report

> Self-critique of the 9-locale × 19-key backfill (2026-04-24). The
> translations were generated via an AI-assisted per-locale dictionary;
> this report flags the lines I am **least confident about** so native
> reviewers can focus there first.
>
> Columns: 🔴 HIGH risk → start here · 🟡 MEDIUM · 🟢 LOW.
> Cross-reference each flag against `l10n_review_{locale}.md` and the
> active file at `apps/abba/lib/l10n/app_{locale}.arb`.

---

## Per-locale confidence summary

| Locale | Overall | Why |
|--------|---------|-----|
| **es** | 🟢 LOW risk | Romance conventions clear; devotional register consistent. Check `templateCategoryGrief` tone only. |
| **pt** | 🟢 LOW risk | BR/PT dialect spread handled by neutral phrasings; check any pronoun drift. |
| **fr** | 🟢 LOW risk | Post-Vatican II `tu` standard applied; devotional register is literary but OK. |
| **de** | 🟡 MEDIUM | `dein` (informal 2nd person toward God) matches Lutheran/Catholic convention, but some template phrases feel "translated" rather than native. |
| **it** | 🟡 MEDIUM | Catholic-majority audience; Marian register is not touched directly, but verify no accidental formality mismatch. |
| **ru** | 🟡 MEDIUM | `Ты` reverential capitalisation convention for God not present in these keys (no direct address to God), but check Orthodox-appropriate vocabulary for `скорбь` vs `печаль`. |
| **ja** | 🔴 HIGH | Register is the trickiest. Current translations lean literary (`さらなる`, `想いを巡らせています`) — may feel cold to a 60-70 senior. Consider softening. |
| **zh** | 🔴 HIGH | Christian Simplified Chinese has specific devotional vocabulary. Check `祷告` vs `祈祷`, `经文` vs `圣经`, and ensure 您 honorific is consistent (not mixed with 你). |
| **ar** | 🔴 HIGHEST | Christian Arabic register distinct from Qur'anic/Islamic Arabic. `صلاة` and `الآية` are shared terms — risk of Islamic register leakage. Native Christian Arabic reviewer essential. |

---

## Top-risk entries, across the 9 locales

### A · `aiStreamingInitial` — "당신의 기도를 묵상하고 있어요..."

| Locale | My output | Flag |
|--------|-----------|------|
| **ar** 🔴 | `نتأمل في صلاتك...` | `صلاة` is the Islamic term for prayer (ṣalāt). Christian Arabic often uses `صلواتك` (plural, devotional) or adds `يا رب` softening. Needs Christian-register confirmation. |
| **ja** 🔴 | `あなたの祈りに想いを巡らせています...` | `あなた` (direct "you") may feel presumptuous toward a senior. `お祈り` (お-prefixed) softer. `想いを巡らせる` is literary — consider `静かに耳を傾けています`. |
| **zh** 🟡 | `正在默想您的祷告...` | `您的祷告` consistent honorific. `默想` is the correct term for Christian meditation. OK. |
| **de** 🟡 | `Wir meditieren über dein Gebet...` | `meditieren` is fine for Protestant; Catholic audience might prefer `betrachten wir dein Gebet`. |

### B · `aiScriptureValidating` — "오늘의 말씀을 찾고 있어요..."

| Locale | My output | Flag |
|--------|-----------|------|
| **ar** 🔴 | `نبحث عن الآية المناسبة...` | `الآية` can mean Qur'anic verse OR Bible verse. Christian usage often uses `الآية الكتابية` or `آية من الكتاب المقدس` to disambiguate. |
| **ja** 🟡 | `ふさわしいみことばを探しています...` | `みことば` (御言葉) correct Christian honorific for Scripture. ✓ good choice. |
| **zh** 🟡 | `正在寻找合适的经文...` | `经文` is correct Christian usage for Bible passage. ✓. |

### C · `templateCategoryGrief` — "슬픔과 상실 중에"

| Locale | My output | Flag |
|--------|-----------|------|
| **zh** 🟡 | `在悲伤或失去之中` | Grammatically correct but abstract. Senior readers may prefer concrete: `在失去亲人之中`. |
| **ar** 🟡 | `في الحزن أو الفقدان` | OK but `في أوقات الحزن والفقدان` (in times of...) is warmer. |
| **ja** 🟡 | `悲しみや喪失の中で` | `喪失` is medical/clinical register. Devotional preference: `愛する方を失ったとき` (when you have lost a loved one). |
| **de** 🟡 | `In Trauer oder Verlust` | Grammatically neutral. `In Zeiten der Trauer` (in times of grief) warmer. |

### D · `aiTierProcessing` + `tierCompleted` + `aiTierIncomplete`

Potentially mechanical across all locales. These are UI status strings — acceptable if reviewer prefers concise over devotional. No strong flags.

### E · `templateCategoryWork` — "일과 공부를 위한 묵상"

| Locale | My output | Flag |
|--------|-----------|------|
| **ar** 🟡 | `من أجل العمل والدراسات` | Plural `الدراسات` (studies) — for Muslim-majority Arabic countries the word `عمل` (work) is fine but verify it doesn't pull Qur'anic `العمل الصالح` (righteous deeds) register. |
| **ja** 🟢 | `仕事と学びのための祈り` | `学び` (learning) is more senior-friendly than `勉強`. ✓ good. |

### F · `proSectionWillArrive` — "깊은 묵상이 곧 나타날 거예요"

| Locale | My output | Flag |
|--------|-----------|------|
| **ja** 🟡 | `深い黙想はここに現れます` | `現れます` is visible-from-nothing connotation (theophany). `表示されます` (will be displayed) is more UI-neutral but colder. Reviewer choice. |
| **ar** 🟢 | `سيظهر تأملك العميق هنا` | Natural. ✓. |
| **de** 🟢 | `Deine tiefere Einsicht erscheint hier` | Natural. ✓. |

---

## What reviewers should NOT spend time on

The following keys are **low-risk across all 9 locales** — review if you have time but skip if busy:

- `aiPendingMore` ("Preparing more…") — one or two words; all locales near-literal.
- `tierProcessingNotice` — generic progress text.
- `proSectionLoading` — generic progress text.
- `sectionStatusCompleted` / `sectionStatusPending` — status pill copy; any natural phrasing works.
- `templateCategoryHealth` / `templateCategoryFamily` / `templateCategoryGratitude` — common religious categories, low ambiguity.

---

## Review workflow suggestion

1. **ar reviewer**: 60 min — focus on Christian-register distinctiveness. `صلاة`, `الآية`, `العمل` are the top three words to verify.
2. **ja reviewer**: 45 min — senior tone check on `aiStreamingInitial`, `aiTierProcessing`, `aiScriptureValidating`. Suggest rewrites where literary phrasing feels cold.
3. **zh reviewer**: 30 min — honorific consistency (您 not 你), confirm `祷告` / `经文` / `默想` as devotional choices. Skim rest.
4. **de / it / ru reviewers**: 20 min each — verify religious register tone; flag only template category phrasings that could be warmer.
5. **es / pt / fr reviewers**: 15 min each — spot-check; expected to be lowest-effort.

---

## Revision flow

Reviewer edits the suggested-rewording field inside their
`l10n_review_{locale}.md`, a maintainer applies approved changes to
`apps/abba/lib/l10n/app_{locale}.arb`, then re-runs `flutter gen-l10n`.
No code changes needed elsewhere — Phase 4.1 rubric and the Phase 4.2
tier pipeline consume locale via `{{LANG_NAME}}` runtime variable, so
new wordings take effect on the next Gemini call.

---

## Self-review status (2026-04-24)

I performed a full second pass across all 171 entries (19 keys × 9
locales). Applied changes by pass:

- **Pass 1** (commit `659b63f`): 25 changes focused on the HIGH-risk
  flags in this report — ar register words, ja senior softening, zh
  concretisation, de/it/ru/es/pt/fr devotional "in times of" framing
  for the grief category.
- **Pass 2** (commit pending): 2 additional changes — both zh.
  - `tierCompleted`: `已添加新的默想` → `新的默想到了` (more devotional
    arrival feel vs UI-system "has been added")
  - `proSectionWillArrive`: `...将在此显示` → `...将在此呈现` (present /
    unfold vs UI display).

### Pass 2 entries deliberately LEFT alone

After checking every remaining key I did **not** apply further changes
where I was not confident enough to override the initial output:

- **fr** uses `vous / votre` consistently across all UI strings toward
  the user. Swapping individual lines to `tu / ta` for warmth would
  break register consistency. A French reviewer should make the whole-
  file choice (stay formal / move to informal across all keys) in one
  pass, not line by line.
- **ru** `размышления` (reflections) is slightly detached; `раздумья`
  could be warmer but is unusual in liturgical register. Reviewer's call.
- **ja** remaining literary elements (e.g. `後ほど` in `aiTierIncomplete`)
  could be softened but are idiomatic for senior register. Native
  reviewer preference.
- **ar** status pills (`sectionStatus*`) are neutral MSA — fine for
  dashboard copy; a reviewer may choose richer devotional register.
- All **category labels** other than `grief` (which was softened in
  pass 1) are near-literal mappings of brief English nouns. Over-
  rewording risks losing the "index button" feel.

### Bottom line

Two passes applied **27 changes** out of 171 candidate entries (~16%).
The remaining 144 entries are "reasonable as-is"; the residual quality
gap is shaped by subjective register preference that only a native
speaker can close.
