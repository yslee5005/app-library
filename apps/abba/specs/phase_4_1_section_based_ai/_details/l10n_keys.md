# l10n 키 정의

## 신규 ARB 키 (Phase 4.1)

en + ko 우선 번역. 나머지 33 locale은 영어 fallback (기존 패턴).

### Streaming / Loading 상태

| Key | English | Korean |
|-----|---------|--------|
| `aiStreamingInitial` | "Meditating on your prayer..." | "당신의 기도를 묵상하고 있어요..." |
| `aiTierProcessing` | "More reflections coming..." | "더 많은 이야기가 준비되고 있어요..." |
| `aiScriptureValidating` | "Finding the right scripture..." | "오늘의 말씀을 찾고 있어요..." |
| `aiScriptureValidatingFailed` | "Preparing this scripture for you..." | "이 말씀은 잠시 후 준비됩니다..." |
| `aiTemplateFallback` | "While we prepare your full analysis..." | "분석이 완성되는 동안 잠시 묵상해보세요..." |
| `aiPendingMore` | "Preparing more..." | "준비 중..." |
| `aiTierIncomplete` | "Coming soon, check back later" | "곧 완성돼요, 잠시 후 다시 확인해주세요" |

### Tier 완성 알림

| Key | English | Korean |
|-----|---------|--------|
| `tierCompleted` | "New reflection added" | "새로운 이야기가 도착했어요" |
| `tierProcessingNotice` | "Generating more reflections..." | "더 많은 이야기를 만들고 있어요..." |

### Pro 섹션 placeholder

| Key | English | Korean |
|-----|---------|--------|
| `proSectionLoading` | "Preparing your premium content..." | "프리미엄 콘텐츠를 준비 중이에요..." |
| `proSectionWillArrive` | "Your deep reflection will appear here" | "깊은 묵상이 곧 나타날 거예요" |

### Welcome modal (Phase 4 기존 + 확장)

기존 키 재활용:
- `pendingAnalysisReady` — "기도 분석이 완성됐어요 🌸"
- `viewAnalysisResult` — "보기"

### Error / Fallback

기존 Phase 3 키 재활용:
- `aiErrorNetworkTitle` — "연결이 불안정해요"
- `aiErrorApiTitle` — "AI 서비스가 불안정해요"
- `aiErrorRetry` — "다시 시도"
- `aiErrorHome` — "홈으로"

**추가 불필요** (Phase 3에서 충분).

### Template Fallback 카테고리 레이블

| Key | English | Korean |
|-----|---------|--------|
| `templateCategoryHealth` | "For Health Concerns" | "건강을 위한 묵상" |
| `templateCategoryFamily` | "For Family" | "가족을 위한 묵상" |
| `templateCategoryWork` | "For Work & Studies" | "일과 공부를 위한 묵상" |
| `templateCategoryGratitude` | "A Thankful Heart" | "감사의 마음" |
| `templateCategoryGrief` | "In Grief or Loss" | "슬픔과 상실 중에" |

### Section Status UI (Calendar / History)

| Key | English | Korean |
|-----|---------|--------|
| `sectionStatusCompleted` | "Analysis complete" | "분석 완료" |
| `sectionStatusPartial` | "Partial analysis (more coming)" | "부분 완성 (계속 진행 중)" |
| `sectionStatusPending` | "Analysis in progress" | "분석 진행 중" |

## 기존 유지 키 (Phase 1-4에서 정의, 변경 없음)

- `aiLoadingText`, `aiLoadingVerse` — Phase 1
- `prayerSummaryTitle`, `gratitudeLabel`, `petitionLabel`, `intercessionLabel` — Phase 1
- `scriptureTitle`, `bibleStoryTitle`, `testimonyTitle` — Phase 1
- `guidanceTitle`, `aiPrayerTitle`, `historicalStoryTitle` — Phase 1
- `premiumUnlock`, `backToHome`, `shareButton` — Phase 1
- `aiErrorNetworkTitle`, ... — Phase 3
- `aiErrorNetworkBody`, ... — Phase 3

## 검증 체크리스트

- [ ] 모든 신규 키 `app_en.arb`에 추가
- [ ] 동일 키 `app_ko.arb`에 한국어 번역
- [ ] `flutter gen-l10n` 재실행 → `app_localizations*.dart` 재생성
- [ ] `flutter analyze` 0 issues (generated file typo 체크)
- [ ] `scripts/check_l10n_sync.sh` 또는 Python JSON 기반 검증 통과
- [ ] UI 렌더 시 하드코딩 문자열 0개 (`scripts/check_hardcoded_strings.sh`)

## 35 locale 완전 번역 (2026-04-24 업데이트)

**Phase 4.1 출시 전 모든 35 locale 완전 번역 완료** (원래 spec의 "en+ko만" fallback 전략 취소).

이유: 기존 abba 앱의 431 키는 이미 35 locale 모두 번역되어 있어 en/ko만 채우면 일관성이 깨짐. 시니어 유저가 비영어권에서 19 키만 영어로 보는 것은 부자연스러움.

- ✅ en + ko: 수동 작성 (L10-32 위 표 참조)
- ✅ 33 locale (am/ar/cs/da/de/el/es/fi/fil/fr/he/hi/hr/hu/id/it/ja/ms/my/nl/no/pl/pt/ro/ru/sk/sv/sw/th/tr/uk/vi/zh): AI 보조 번역
- **사용자 검토 필요**: 19 키 × 33 locale = 627 항목 네이티브 스피커 검토 권장 (특히 신학 뉘앙스 있는 `aiScriptureValidating` / `templateCategory*`)

## 번역 작업 가이드 (사용자 검토 시)

### `aiStreamingInitial` 톤
시니어에게 "지금 AI가 당신의 기도를 진지하게 다루고 있다"는 느낌.
- 🚫 "Processing your prayer..." (기계적)
- 🚫 "분석 중..." (차가움)
- ✅ "Meditating on your prayer..." (묵상)
- ✅ "당신의 기도를 묵상하고 있어요..." (따뜻함)

### `aiScriptureValidating` 톤
Scripture 검증은 유저 모름 → 자연스러운 말씀 찾기 표현.
- ✅ "Finding the right scripture..." / "오늘의 말씀을 찾고 있어요..."

### Template Fallback 톤
Template 표시 중인데 "가짜 같은" 느낌 없이.
- ✅ "While we prepare your full analysis..." / "분석이 완성되는 동안..."
- 완성 시 조용히 replace (UX에 티 안 나게)

## ARB 샘플 (diff 형식)

```diff
// app_en.arb
{
  "aiLoadingText": "Reflecting on your prayer...",
  "aiLoadingVerse": "Be still, and know that I am God.\n— Psalm 46:10",
+ "aiStreamingInitial": "Meditating on your prayer...",
+ "aiTierProcessing": "More reflections coming...",
+ "aiScriptureValidating": "Finding the right scripture...",
+ "aiScriptureValidatingFailed": "Preparing this scripture for you...",
+ "aiTemplateFallback": "While we prepare your full analysis...",
+ "aiPendingMore": "Preparing more...",
+ "aiTierIncomplete": "Coming soon, check back later",
+ "tierCompleted": "New reflection added",
+ "tierProcessingNotice": "Generating more reflections...",
+ "proSectionLoading": "Preparing your premium content...",
+ "proSectionWillArrive": "Your deep reflection will appear here",
+ "templateCategoryHealth": "For Health Concerns",
+ "templateCategoryFamily": "For Family",
+ "templateCategoryWork": "For Work & Studies",
+ "templateCategoryGratitude": "A Thankful Heart",
+ "templateCategoryGrief": "In Grief or Loss",
+ "sectionStatusCompleted": "Analysis complete",
+ "sectionStatusPartial": "Partial analysis (more coming)",
+ "sectionStatusPending": "Analysis in progress",
  ...
}
```

총 19개 신규 키. Phase 3 (8개) + Phase 4.1 (19개) = 27 키 신규 누적.
