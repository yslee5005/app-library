# l10n Keys — qt_output_redesign

코드 작성 **전** 모든 키를 여기 정의 → 35개 ARB 파일에 일괄 추가 → 코드에서 사용.

---

## Phase 1 · 신규 키 (4개)

| Key | EN | KO | 용도 / INT |
|-----|----|----|-----|
| `meditationSummaryTitle` | `Today's Meditation` | `오늘의 묵상` | MeditationSummaryCard 제목 (INT-107) |
| `meditationTopicLabel` | `Topic` | `주제` | topic 구분 라벨 (INT-107) |
| `meditationSummaryLabel` | `Summary` | `한 마디로` | summary 구분 라벨 (optional) |
| `qtScriptureTitle` | `Today's Passage` | `오늘의 말씀` | QtScriptureCard 제목 (INT-108) |

### namedArgs (Phase 1 없음)

---

## Phase 2 · 신규 키 예상 (14개) — qt_guide Coaching 용

Prayer Coaching 키 세트 미러:
- `qtCoachingTitle` = "QT Coaching" / "QT 코칭"
- `qtCoachingLoadingText`, `qtCoachingErrorText`, `qtCoachingRetryButton`
- `qtCoachingScoreComprehension` (본문 이해)
- `qtCoachingScoreApplication` (개인 적용)
- `qtCoachingScoreDepth` (영적 깊이)
- `qtCoachingScoreAuthenticity` (진정성)
- `qtCoachingStrengthsTitle`, `qtCoachingImprovementsTitle`
- `qtCoachingProCta`
- `qtCoachingLevelBeginner`, `qtCoachingLevelGrowing`, `qtCoachingLevelExpert`

---

## Phase 3 · 신규 키 (5개) — Citations

| Key | EN | KO |
|-----|----|----|
| `qtCitationsTitle` | `Inspiration · Citations` | `영감 · 참고 자료` |
| `citationTypeHistory` | `History` | `역사` |
| (기존 재사용) `citationTypeQuote`, `citationTypeScience`, `citationTypeExample` | — | — |

기존 bible_text_i18n에서 만든 `citationTypeQuote`, `citationTypeScience`, `citationTypeExample` 는 재사용 (35 locale 이미 번역됨).

`citationTypeHistory` 1개만 신규 × 35 locale.

---

## Phase 4 · 신규 키 (0-1개)

GrowthStory 제목 기존 `growthStoryTitle` (있으면) 재사용. 필요시 `growthStoryLessonLabel` 추가.

---

## Phase 5 · 신규 키 (3개)

ApplicationSuggestion 확장 시:

| Key | EN | KO |
|-----|----|----|
| `applicationMorningLabel` | `Morning` | `아침` |
| `applicationDayLabel` | `Today` | `낮` |
| `applicationEveningLabel` | `Evening` | `저녁` |

---

## 35 locale 전략 (Phase 5 일괄 실행)

Phase 1에선 en + ko 정확하게. Phase 1 구현 완료 시점 나머지 33 locale 일괄 스크립트 (`scripts/add_phase_qt1_l10n.py` 등 기존 패턴 재사용).

Phase 2/3는 각 phase 말미에 동일 패턴.

## 참조

- prayer_output_redesign/_details/l10n_keys.md (Coaching 키 세트)
- bible_text_i18n/_details/l10n_keys.md (citationType 키)
- 기존 `scripts/add_phase*_l10n.py` 재사용
