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

## Phase 2-5 키 (추가 예정)

Phase별 spec 작성 시 이 문서에 섹션 추가.

- Phase 2: `scriptureWhyTitle`, `scripturePostureTitle`, `scriptureOriginalWordsTitle`, `originalWordNuance` 등 ~10 키
- Phase 3: `coachingTitle`, `coachingStrengthsTitle`, `coachingImprovementsTitle`, `coachingExpertLevel*`, 점수 라벨 ~8 키
- Phase 4: `historicalLessonTitle`, `historicalFullStoryLabel` ~3 키
- Phase 5: `aiPrayerCitationsTitle`, `citationTypeQuote/Science/Example` ~5 키

## 참조

- `.claude/rules/learned-pitfalls.md` §4 (i18n — 사전 정의 필수, 754키 사례)
- `apps/abba/lib/l10n/app_en.arb` (기준 파일)
- `scripts/check_hardcoded_strings.sh` (있으면 검증)
- `scripts/check_l10n_sync.sh` (있으면 검증)
