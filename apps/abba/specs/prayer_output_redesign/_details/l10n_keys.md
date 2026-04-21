# l10n Keys (사전 정의)

> 코드 작성 **전** 모든 키를 여기 정의 → 35개 ARB 파일에 일괄 추가 → 코드에서 사용.
> 나중에 정리하면 미사용 키 폭증 (praybell 754개 정리 사례).

---

## Phase 1 · 신규 키 목록

| Key | EN | KO | 용도 / INT |
|---|---|---|---|
| `testimonyTitle` | `Testimony · My prayer` | `나의 간증 · 기도 원문` | TestimonyCard 제목 (dual label, INT-006) |
| `testimonyHelperText` | `Reflect on what you prayed · can be shared to community` | `내가 뭐라고 기도했는지 돌아보기 · 커뮤니티 공유에도 사용` | TestimonyCard helper 한 줄 (INT-006) |
| `myPrayerAudioLabel` | `My prayer recording` | `내 기도 녹음` | PrayerSummaryCard 오디오 플레이어 라벨 (INT-004) |
| `playPrayerAudio` | `Play prayer recording` | `기도 녹음 재생` | 재생 버튼 a11y (INT-005) |
| `pausePrayerAudio` | `Pause prayer recording` | `기도 녹음 일시정지` | 일시정지 버튼 a11y (INT-005) |

## Phase 1 · 기존 키 재확인 (값 변경 여부)

| Key | 현재 EN | 현재 KO | 변경 필요? |
|---|---|---|---|
| `testimonyTitle` | `Testimony` (추정) | `나의 간증` (추정) | **YES** — 위 dual label 값으로 갱신 |

→ Phase 1 구현 시 기존 `testimonyTitle` 값을 dual label로 덮어씀.

## namedArgs (Phase 1 해당 없음)

Phase 1에선 placeholder 사용 키 없음.

## 35개 언어 전략

- **1차 (Phase 1 구현 시 즉시)**: en + ko 정확하게 작성
- **2차 (Phase 1 끝날 때 일괄)**: 나머지 33 언어는 영어 fallback OR 기계 번역 초안
- **3차 (출시 직전)**: 주요 locale (ja, zh, es, fr, de, pt) 원어민 검토
- **dual label 특이사항**: "Testimony · 기도 원문" 같은 병기는 각 언어에서도 "해당 언어 의미어 · Native 의미어" 구조 유지

### 언어별 dual label 예시 (초안)

| Locale | testimonyTitle 값 |
|--------|------------------|
| en | `Testimony · My prayer` |
| ko | `나의 간증 · 기도 원문` |
| ja | `証し · 私の祈り` |
| zh | `见证 · 我的祷告` |
| es | `Testimonio · Mi oración` |
| fr | `Témoignage · Ma prière` |
| de | `Zeugnis · Mein Gebet` |

→ 나머지는 Phase 1 구현 말미에 일괄 (Claude 번역 + 기계 후처리).

---

---

## Phase 2 · 신규 키 목록

### 필수 신규 (ScriptureCard 확장)

| Key | EN | KO | 용도 / INT |
|---|---|---|---|
| `scripturePostureLabel` | `How should I read it?` | `어떤 마음으로 읽을까요?` | posture 녹색 박스 라벨 (INT-012) |
| `scriptureOriginalWordsTitle` | `Deeper meaning in original language` | `원어로 만나는 깊은 뜻` | expandable 섹션 제목 (INT-013) |
| `originalWordMeaningLabel` | `Meaning` | `의미` | 각 word 의미 라벨 (INT-013) |
| `originalWordNuanceLabel` | `Nuance vs translation` | `번역과의 뉘앙스 차이` | 각 word 뉘앙스 라벨 (INT-013) |
| `originalWordsCountLabel` | `{count} words` | `{count}개 단어` | expandable 접힘 상태 카운트 (INT-013, namedArg) |

### 기존 키 재확인

- `scriptureReasonLabel`: **이미 존재**. 값 재검토 필요할 수 있음.
  - 현재 추정값: "Why this verse?" / "왜 이 말씀?"
  - posture 신규 섹션과 시각 구분 위해 라벨 명확성 확인

### namedArgs 정의

```json
"originalWordsCountLabel": "{count} words",
"@originalWordsCountLabel": {
  "placeholders": {
    "count": { "type": "int" }
  }
}
```

한국어: `"{count}개 단어"` — 동일 placeholder 사용.

### 35 locale 전략 (Phase 1과 동일)

- 1차: en + ko 정확
- 2차 (Phase 2 구현 말미): 나머지 33 언어 locale-appropriate 번역 스크립트 일괄 적용
- Phase 1에서 만든 `/tmp/add_l10n_keys.py` 패턴 재사용 (Phase 2용 번역 맵 업데이트)

---

## Phase 3-5 키 (추가 예정)

Phase 2 승인 후 해당 phase 진입 시 추가:
- Phase 3: `coachingTitle`, `coachingStrengthsTitle`, `coachingImprovementsTitle`, `coachingExpertLevel*`, 점수 라벨 ~8 키
- Phase 4: `historicalLessonTitle`, `historicalFullStoryLabel` ~3 키
- Phase 5: `aiPrayerCitationsTitle`, `citationTypeQuote/Science/Example` ~5 키

## 참조

- `.claude/rules/learned-pitfalls.md` §4 (i18n — 사전 정의 필수, 754키 사례)
- `apps/abba/lib/l10n/app_en.arb` (기준 파일)
- `scripts/check_hardcoded_strings.sh` (있으면 검증)
- `scripts/check_l10n_sync.sh` (있으면 검증)
