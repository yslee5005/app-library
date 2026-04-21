# 이 Feature 관련 함정 체크리스트

> `.claude/rules/learned-pitfalls.md`에서 이 feature와 관련된 카테고리만 link.
> 매 INT-XXX 구현 전 해당 카테고리 다시 읽기.

---

## Phase 1 · 관련 카테고리

전체 16 카테고리 중 Phase 1 작업에 관련된 것:

- [x] **§1 Riverpod 라이프사이클** — audio player provider dispose, `ref.mounted` 체크
  - 특히: 오디오 재생 중 위젯 dispose 시 controller leak 방지
  - autoDispose vs keepAlive 판단 (카드 한정 = autoDispose)
- [x] **§2 Subscription / Payment Crash** — Phase 1엔 직접 영향 없음, **참고용** (Phase 3에서 본격)
- [ ] **§3 Multi-tenant (Supabase)** — Phase 1에선 스키마 변경 없음
- [x] **§4 i18n** — dual label 키 + helper 텍스트 신규 추가. **사전 정의 필수** (754키 사례 재발 방지)
- [ ] **§5 Auth Lifecycle** — 해당 없음
- [ ] **§6 DateTime / Timezone** — 해당 없음
- [ ] **§7 iOS Privacy / Compliance** — 오디오 권한은 Recording 단계에서 이미 확보됨
- [ ] **§8 Navigation** — 라우트 변경 없음
- [ ] **§9 FCM / Webhook** — 해당 없음
- [x] **§10 Optimistic UI** — 오디오 재생 토글(▶️/⏸️)은 즉시 반영 (로컬 상태)
- [x] **§11 성능** — 오디오 플레이어 초기화는 lazy (`audioUrl != null` 확인 후 생성)
- [x] **§12 Color / Design Token** — 오디오 플레이어 진행 바 색은 `AbbaColors.sage` 사용 (하드코딩 금지)
- [x] **§13 Dead Code Sweep** — TestimonyCard의 audio 로직 완전 제거 (주석으로 남기지 않음), `_currentAudioUrlProvider` 위치 이동 후 기존 참조 grep 검증
- [x] **§14 Layer Violation** — 카드에서 Supabase 직접 호출 금지. 현재 Phase 1에선 해당 없으나 패턴 준수
- [ ] **§15 Web 함정** — Flutter 작업이라 해당 없음
- [x] **§16 Code Generation** — 핵심
  - `testimony → transcript` rename → freezed 재생성 필수
  - `audioUrl` 신규 필드 → freezed + json_serializable 재생성
  - ARB 신규 키 → `flutter gen-l10n` 실행 필수
  - workspace root에서 `dart run build_runner build --delete-conflicting-outputs`

## 추가 메모 (Phase 1 특유)

### 1. JSON 역직렬화 호환성
기존 Supabase `prayers.result` JSON에 저장된 레코드는 `testimony` 키를 가지고 있음. `PrayerResult.fromJson`에서 **양쪽 키 모두 허용**:
```dart
factory PrayerResult.fromJson(Map<String, dynamic> json) => _$PrayerResultFromJson({
  ...json,
  'transcript': json['transcript'] ?? json['testimony'] ?? '',
});
```

### 2. Audio Player 위치 이동 시 provider scope
현재 `_currentAudioUrlProvider`는 TestimonyCard에서만 watched. Phase 1 이후 PrayerSummaryCard에서 watch. **타이밍 이슈 체크**:
- 카드 간 state가 독립적인지
- dashboard 재빌드 시 audio 재생 유지되는지 (UX — 카드 사이 스크롤할 때 끊기면 안 됨)

### 3. Dual label 문자열 길이
`Testimony · My prayer` / `나의 간증 · 기도 원문` — 카드 제목으로 긴 편. `AbbaTypography.h2` (20pt) 기준 compact(320dp) overflow 확인 필수. `maxLines: 1` + `overflow: ellipsis` 강제 or `maxLines: 2` 허용.

### 4. Hardcoded fallback 업데이트 순서
`_useHardcodedResponse = true` 상태이므로 **하드코딩부터 새 구조로 먼저 업데이트** → UI 검증 → 실제 API 프롬프트 수정 (API는 다음 Phase에서 활성화될 때).

## 전체 룰 참조

- `.claude/rules/learned-pitfalls.md` (전체 16 카테고리)
- `.claude/rules/error-handling.md` (3상태 필수)
- `.claude/rules/responsive.md` (ScreenSize 4단계)
- `.claude/rules/flutter-layout.md` (ListView 룰)
- `.claude/rules/copy-paste.md` (UI Kit 변경 시)

---

---

## Phase 2 · Scripture Deep 관련 함정

- [x] **§4 i18n** — 5 신규 키 (scripturePostureLabel, scriptureOriginalWordsTitle, originalWordMeaningLabel, originalWordNuanceLabel, originalWordsCountLabel) 35 locale 일괄. namedArg placeholder 메타(`count`) 누락 주의.
- [x] **§12 Color/Design Token** — reason 녹색 박스(sage α 0.08)와 posture 녹색 박스 시각 구분. **하드코딩 금지**, 토큰 사용.
- [x] **§13 Dead Code Sweep** — 핵심:
  - `OriginalLanguage` 클래스 완전 삭제 (model)
  - `OriginalLangCard` 파일 삭제
  - `prayer_dashboard_view.dart` + `qt_dashboard_view.dart`의 `OriginalLangCard` 참조 전부 제거
  - 주석으로 남기지 말 것 (`// removed` 같은 comment 금지 — CLAUDE.md 룰)
  - 삭제 전 `grep -r "OriginalLanguage\|OriginalLangCard\|originalLanguage" apps/abba/lib/`로 전체 참조 확인
- [x] **§16 Code Generation** — Scripture / OriginalWord 모델 변경 후:
  - (freezed 사용 안 하는 plain class라) fromJson 수동 업데이트 필요
  - `flutter gen-l10n` (신규 ARB 키)
- [x] **§1 Riverpod 라이프사이클** — ScriptureCard는 StatelessWidget 유지, expandable 내부 상태는 StatefulWidget으로 분리 시 dispose 주의

### Phase 2 특유 주의

#### 1. 히브리어/헬라어 폰트 렌더링
- 시스템 기본 폰트가 히브리어/헬라어 부재하면 `Text` 위젯에 fallback 적용
- 현재 앱 폰트(Noto Sans KR + Nunito)가 커버하는지 확인 필요
- 히브리어는 **RTL 필수** (`textDirection: TextDirection.rtl`)
- 헬라어는 LTR

#### 2. 두 녹색 박스 시각 구분
- 같은 `AbbaColors.sage` alpha 0.08 사용 시 시각 구분 어려움
- 해결안 A: 라벨 + 아이콘으로만 구분 (이모지 "❓" / "🌿")
- 해결안 B: reason α 0.08, posture α 0.12 (약간 진하게)
- 해결안 C: 하나로 병합 containter + divider
- **결정 필요**: Phase 2 구현 시작 전 UI 디자인 결정. 기본: A (아이콘 구분).

#### 3. Expandable 기본 접힘 상태
- `originalWords` 비어 있으면 섹션 자체 숨김
- 1개 이상이면 접힘 상태로 카드 표시 (시니어 UX: 카드 길이 제한)
- `ExpandableCard` 위젯 재사용 고려

#### 4. 기존 DB 레코드 호환
- 이미 저장된 `prayers.result` JSON에 `original_language` 필드 있음
- `PrayerResult.fromJson`에서 legacy `original_language` → `scripture.originalWords[0]`로 마이그레이션 (lossy)
- 또는 무시 (기존 데이터는 Phase 2 배포 후 다시 생성되면서 새 구조로)

---

## Phase 3 · Prayer Coaching 관련 함정

- [x] **§1 Riverpod 라이프사이클** — `prayerCoachingProvider`
  - `FutureProvider.autoDispose` (화면 떠나면 정리)
  - async gap 후 `ref.mounted` 체크 (특히 retry 로직)
- [x] **§2 Subscription / Payment Crash** ★ 핵심
  - `isUserPremium` 체크 후 호출 (Free 유저에겐 API 호출 X)
  - ProBlur 위젯 재사용 (기존 패턴)
  - Pro 전환 후 `invalidate(prayerCoachingProvider)` → 재호출
  - 포그라운드 복귀 시 subscription 재확인
- [x] **§4 i18n** — 14 신규 키 × 35 locale. ACTS 용어는 **언어별 번역 주의** (가톨릭/개신교 맥락)
- [x] **§11 성능** — `rootBundle.loadString('assets/docs/prayer_guide.md')`는 **한 번만 로드 후 메모리 캐시** (매 call마다 파일 IO 금지)
- [x] **§12 Color/Design Token** — score bar 색: `AbbaColors.sage` / `AbbaColors.muted α 0.2`. 하드코딩 금지
- [x] **§16 Code Generation** — pubspec asset 경로 등록 후 `flutter pub get` + l10n 신규 키 후 `flutter gen-l10n`

### Phase 3 특유 주의

#### 1. AI Hallucinate 방지 (★ 최우선)
- prayer_guide.md는 LLM에 "reference"로 주지만, 출력을 guide 자체로 하지 않도록 명시
- 금지어 필터: 출력 JSON 파싱 후 `["부족", "못 하", "잘못", "inadequate", "lacking", "wrong"]` 포함 여부 검사 → 걸리면 placeholder로 대체 + Sentry 경고
- 100개 샘플 수동 검증 (출시 전) — 특히 Beginner 레벨 응답 톤

#### 2. Asset 로딩 타이밍
- `rootBundle` 로드는 async. Coaching call 생성 전 한 번만 로드해서 메모리 캐시
- `PrayerGuideLoader` 싱글톤 또는 Riverpod provider로 관리 (`prayerGuideProvider`)

#### 3. Pro 전환 UX
- 사용자가 Pro 구매 직후 Coaching 카드 즉시 업데이트
- `isPremiumProvider` change listener에서 `invalidate(prayerCoachingProvider)` 자동 발동
- 포그라운드 복귀 시 subscription + coaching 재확인 (§1, §2 함정)

#### 4. prayer_guide.md 버전 관리
- Asset 파일이라 앱 빌드 시 번들
- 문구 수정하려면 배포 필요 (동적 업데이트 X)
- v0.2로 업그레이드 시 Supabase storage로 이동 고려 (MVP 아님)

#### 5. ACTS vs Prayer Summary 3축 일관성
- Coaching은 ACTS 4축 기반, Prayer Summary는 3축 (감사/간구/중보)
- Coaching 결과에서 "Confession이 없네요" 제안 → 사용자가 Prayer Summary에서 찾으려 해도 없음 → 혼란 가능
- **UI 추가 문구 필요**: "앱의 기도 요약은 감사/간구/중보 3축이지만, 코칭은 전통 ACTS 4축 기준입니다" (또는 간단 info icon)

---

## Phase 4 · Historical Deep 관련 함정 (A-1 single-field 포함)

- [x] **§2 Subscription / Payment Crash** — Phase 4 직접 영향 없음. Premium 1 call 유지 (비용 변화 무).
- [x] **§11 성능** — 긴 summary(500-800자) 렌더 시 `Text` widget 단일 layout pass 충분. `height: 1.7` + `\n\n` 자동 처리.
- [x] **§12 Color / Design Token** — lesson 박스 `AbbaColors.sage.withValues(alpha: 0.1)` 기존 그대로. typography도 토큰 사용 (하드코딩 금지).
- [x] **§13 Dead Code Sweep** ★ 핵심 (A-1 리팩터링):
  - `HistoricalStory.title(locale)` / `.summary(locale)` / `.lesson(locale)` getter 3개 **완전 삭제** (주석 남기지 말 것)
  - `titleEn`, `titleKo`, `summaryEn`, `summaryKo`, `lessonEn`, `lessonKo` 필드 6개 제거
  - grep 검증: `grep -rn "HistoricalStory" apps/abba/lib/` → 전 호출부 업데이트 확인
  - 삭제 전 `grep -rn "historicalStory\.\(title\|summary\|lesson\)(" apps/abba/` 로 locale 전달 호출부 전수 점검
- [x] **§16 Code Generation** ★ 핵심:
  - HistoricalStory 모델 변경 후 `flutter analyze apps/abba` 0 error 확인
  - (freezed 사용 안 하는 plain class라) build_runner 불필요
  - l10n 신규 키 0개 → `flutter gen-l10n` 불필요
  - MockDataService JSON mock 파일(`assets/mock/prayer_result.json`) 포맷도 함께 업데이트 필요
- [x] **§3 Multi-tenant (Supabase)** — Supabase `prayers.result: JSONB` 스키마 변경 없음. 저장된 legacy 레코드는 fromJson의 3단 fallback이 처리 (lossy compat)
- [ ] **§1 Riverpod 라이프사이클** — 해당 없음 (기존 Premium 로딩 로직 재사용)
- [ ] **§4 i18n** — l10n 신규 키 없음 (prompt 품질만 강화)
- [x] **§15 Web** — 해당 없음 (Flutter only)

### Phase 4 특유 주의

#### 1. AI Hallucinate 방지 (★ 최우선)

이전 Phase 1-3는 사용자 기도 분석 기반이라 생성물이 짧고 제약적. **Phase 4는 "실존 인물의 실존 사건"을 8-10 문장으로 생성** — hallucinate 위험이 가장 큰 Phase.

- prompt에 "Do NOT fabricate quotes, dates, or events" + "If not confident, pick different story" 명시
- 출시 전 50 sample 수동 fact check (Sentry로 production sample 1% 샘플링)
- 검증 대상: 인물 실존 여부, 날짜 정확성, 인용문 출처

#### 2. 긴 텍스트 Flutter 렌더

- `Text`에 `\n\n` 포함된 긴 문자열 — `softWrap: true` (default) 로 자동 줄바꿈 OK
- `maxLines` 설정 **금지** (장문 truncate 시 사용자 불만)
- `overflow: TextOverflow.visible` (default) 유지
- 상위 ExpandableCard가 이미 스크롤 가능한 parent 안에서 렌더 → unbounded height 이슈 없음

#### 3. Typography 승격 (`bodySmall` → `body`) 영향

- body 18pt는 AbbaTypography 표준 (시니어 가독성)
- 기존 bodySmall 16pt 대비 세로 공간 약 +15% 증가 (카드 길어짐)
- compact 320dp + summary 500자 가정 시 약 18 라인 → 스크롤 필수 (이미 `ListView` 내부라 OK)

#### 4. prompt 품질 회귀 방지

- Phase 4 이후 `analyzePrayerPremium` system prompt 길이 증가 (+400 token 정도)
- Gemini 2.5 flash context 1M → 무시 가능
- 단 prompt A/B 테스트 비교 (Phase 4 이전 hardcoded → Phase 4 이후 실 API) 시 품질 대조 필요

#### 5. Legacy DB 레코드 i18n 불일치 (A-1 특유)

- Phase 3 이전 저장 레코드는 `title_en`, `title_ko` 둘 다 있음
- new fromJson은 `title` 없으면 `title_en` fallback → 한국어 사용자가 영어 레코드 보게 됨 (과거 기도 재조회 시)
- 판단: MVP는 **과거 레코드 정확성 포기**. 다음 기도 시 새 포맷으로 재생성됨. 중대한 버그 아님
- 모니터링 필요 시 Sentry custom event: `historical_story_legacy_record_loaded` 카운터

#### 6. Phase 4 scope 경계 유지

- A-1은 **HistoricalStory에만** 적용. Scripture / BibleStory / Guidance / AiPrayer의 `_en`/`_ko` 이원 필드는 **건드리지 않음**
- 유혹: "이왕 하는 김에 다 정리" — **금지**. Phase 4 scope 지키기 (MVP 원칙, 리스크 격리)
- 다른 모델의 single-field 리팩터링은 Phase 5 이후 별도 decision gate

---

## Phase 5 · AI Prayer Deep 관련 함정

- [x] **§2 Subscription / Payment Crash** — Premium 1 call 유지, 영향 없음. 단 citations 배열이 커질 때 응답 토큰 과잉 방지 (최대 4개 제한 prompt에 명시)
- [x] **§4 i18n** — 5 신규 키 × 35 locale. Phase 3 스크립트 패턴 재사용
- [x] **§11 성능** — 긴 기도문(~300 words) + citations 4개 렌더. `Text` widget 단일 layout 충분. citations는 default **접힘** 상태로 초기 렌더 비용 최소화
- [x] **§12 Color / Design Token** — citations 타입별 accent 색: quote=`softGold`, science=`softSky`, example=`sage`. 하드코딩 금지
- [x] **§13 Dead Code Sweep** ★ 핵심:
  - `AiPrayer.textEn`, `.textKo` 필드 제거
  - `AiPrayer.text(locale)` getter 제거
  - `AiPrayer.audioUrl` 필드 제거 (이미 UI 미사용 dead field)
  - `AiPrayerCard.locale` prop 제거
  - grep 검증: `grep -rn "aiPrayer\.\(text(\|audioUrl\|textEn\|textKo\)" apps/abba/`
  - 삭제 전 주석/TODO 남기지 말 것 (CLAUDE.md)
- [x] **§16 Code Generation** — l10n 신규 키 5개 → `flutter gen-l10n` 실행. freezed 안 쓰므로 build_runner 불필요
- [ ] **§1 Riverpod 라이프사이클** — 해당 없음 (기존 Premium 로딩 로직 재사용)
- [x] **§3 Multi-tenant** — Supabase 스키마 변경 없음. legacy `text_en`/`text_ko` 키는 fromJson 3단 fallback으로 처리. `audio_url` 키는 무시

### Phase 5 특유 주의

#### 1. AI Hallucinate 방지 (★ 최우선, Phase 4보다 강함)

Phase 4 Historical Story는 "인물·사건"의 사실성, Phase 5 AI Prayer의 citations는 **"인용문·연구 결과"의 사실성**. 잘못된 quote 귀속 / 존재하지 않는 연구 인용은 앱 신뢰도에 치명적.

- prompt: "If not 100% confident about source, OMIT citation entirely"
- prompt: 악명 높은 misattribution 예시 금지 — "Einstein said...", "Gandhi said..." 패턴
- 출시 전 30 sample fact check: quote의 author × work 실존 확인, science의 study 실존 확인
- 금지어 필터 (선택): citation.source에 "recent study" 같은 모호 표현 감지 → 해당 citation drop

#### 2. citations 빈 배열 vs null

- DB legacy: `citations` 키 없음 → `fromJson`에서 빈 리스트로 처리 (`?? const []`)
- UI: `citations.isEmpty`면 citations 섹션 자체 숨김 (AiPrayerCard)
- AI 응답이 citations 생성 못 하면 빈 배열 반환 OK (필수 아님)

#### 3. 기존 DB 레코드 호환

- Phase 5 이전 레코드: `ai_prayer.text_en` / `text_ko` / `audio_url` 있음
- new fromJson은 `text` 없으면 `text_en` fallback → 한국어 유저도 영어 표시될 수 있음 (Phase 4와 동일 허용)
- `audio_url` 값은 무시 — PrayerPlayer는 사용자 본인 녹음용으로 이미 분리됨

#### 4. Phase 5 scope 경계 유지

- A-1 적용은 **AiPrayer만**. Scripture / BibleStory / Guidance의 `_en`/`_ko`는 건드리지 않음
- 유혹: "남은 Phase 하나니까 다 정리" — **금지**. Phase 5 완료 후 별도 "codebase i18n unification" 작업으로 분리
- 이유: 리스크 격리 + PR 리뷰 용이성

#### 5. AiPrayer.audioUrl 완전 삭제 주의

- Supabase storage에 실제 TTS mp3 파일이 남아있지 않은지 확인 (Phase 1/2에서 TTS 생성 안 했다면 OK)
- audioUrl 참조가 dashboard 이외 어디에도 없는지 grep
- `PrayerPlayer`, `audioUrl`, `audio_url` 완전히 분리된 context인지 재확인 (사용자 녹음 vs AI TTS)
