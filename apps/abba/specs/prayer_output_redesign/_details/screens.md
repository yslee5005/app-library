# Screens

> Phase 1만 상세. Phase 2-5는 해당 phase 진입 시 추가. 모든 카드는 4 상태(Empty / Loading / Error / Data) 명시 필수.

화면 단위는 기존 `prayer_dashboard_view.dart`를 재사용. Phase 1에서 바뀌는 **카드 위젯**만 기술.

---

## Phase 1 · Card 1: `PrayerSummaryCard`

오디오 재생 기능을 Testimony에서 이곳으로 **이동**.

| State | Visual | Notes |
|---|---|---|
| **Empty** | 감사/간구/중보 3축 중 비어 있는 축은 해당 섹션 자체 숨김 | 전부 비면 카드 자체 숨김 (현재와 동일 정책) |
| **Loading** | 상위 AI Loading 화면에서 처리 (카드 개별 loading 없음) | Phase 1 내 변경 없음 |
| **Error** | 상위 Dashboard의 `errorGeneric` 메시지 표시 | 변경 없음 |
| **Data** | 기존 3축 리스트 + 신규 **오디오 플레이어 bar** (카드 하단) | 오디오 없을 때 플레이어 숨김 |

### 오디오 플레이어 Bar 스펙
- 위치: 카드 하단, 3축 리스트 **아래**
- 구성: `[▶️/⏸️ 재생/일시정지] [0:00 / 0:45] [──●────]` (진행 바)
- 라벨: `l10n.myPrayerAudioLabel` = "내 기도 녹음" / "My prayer recording"
- 재생 엔진: 기존 TestimonyCard에서 쓰던 audio player 위젯 재사용 (그대로 이동)
- 오디오 없을 때 (`audioUrl == null`): 플레이어 자체 렌더링 안 함 (공간도 차지 X)

### 라우팅
- 카드는 `prayer_dashboard_view.dart` 내 렌더링. 별도 라우트 없음.

### Responsive
- compact (< 600): 오디오 플레이어 full width, 재생 버튼 48dp
- medium (600-839): 동일 레이아웃 + 좌우 여백 증가 (`AbbaSpacing.lg`)
- expanded/large: 카드 max-width 720dp 고정, 중앙 정렬

---

## Phase 1 · Card 2: `TestimonyCard`

오디오 **제거** + 제목을 dual label + 설명 한 줄 추가.

| State | Visual | Notes |
|---|---|---|
| **Empty** | `transcript`가 빈 문자열이면 카드 자체 숨김 | 시니어 UX: 빈 카드 노출 금지 |
| **Loading** | 상위 AI Loading에서 처리 | 변경 없음 |
| **Error** | 상위 Dashboard 에러 | 변경 없음 |
| **Data** | **Dual 제목** + **helper 한 줄** + transcript 본문 (오디오 X) | 오디오 플레이어 완전 제거 |

### Dual 제목 스펙
- 첫 줄: `l10n.testimonyTitle` 값이 ARB에서 `"Testimony · 기도 원문"` (영어) 또는 `"나의 간증 · 기도 원문"` (한국어) 같이 **슬래시 또는 · 구분 병기**
- 구분자: `·` (U+00B7) — 두 언어·의미 병기를 시각적으로 동등하게
- **영어권 locale**: `"Testimony · My prayer"` 형식
- **한국어 locale**: `"나의 간증 · 기도 원문"` 형식
- 기타 언어: "간증/testimony" 의미어 + "기도 원문/my prayer" 의미어 병기 (각 locale 번역자가 적용)

### Helper 한 줄 (신규)
- 제목 아래, transcript 본문 위
- 스타일: `AbbaTypography.bodySmall` + `AbbaColors.muted`
- 내용: `l10n.testimonyHelperText` = "내가 뭐라고 기도했는지 돌아보기 · 커뮤니티 공유에도 사용"
- 영어: "Reflect on your prayer · Can be used to share with community"

### 오디오 제거 영향
- 기존 `TestimonyCard(audioUrl: ...)` 파라미터 **제거**
- `_currentAudioUrlProvider` 참조는 PrayerSummaryCard로 이동
- 기존 테스트(있다면) 업데이트

### Responsive
- compact: transcript 본문 maxLines 없음, 항상 전체 표시 (스크롤로 읽음)
- 모든 사이즈: `SingleChildScrollView` 안에서 자연스럽게 flow

---

---

## Phase 2 · ScriptureCard 확장 + OriginalLangCard 삭제

### Card: `ScriptureCard` (확장)

기존 3개 섹션 (verse / reference / reason green-box) 유지 + **2개 섹션 추가**.

| State | Visual | Notes |
|---|---|---|
| **Empty** | `verse` 없으면 카드 자체 숨김 | 시니어 UX |
| **Loading** | 상위 Loading 처리 | |
| **Error** | 상위 Dashboard 에러 | |
| **Data** | verse / reference / **reason(녹색)** / **posture(녹색, 신규)** / **originalWords expandable(신규)** | |

### 신규 섹션 1: Posture (읽는 자세)

- 위치: `reason` 섹션 **바로 아래**
- 스타일: `reason`과 같은 녹색(sage alpha 0.08) 배경 박스
- 구분법: 라벨과 아이콘으로 차별화
  - reason 라벨: `l10n.scriptureReasonLabel` = "왜 이 말씀을?" (이미 존재)
  - posture 라벨: `l10n.scripturePostureLabel` = "어떤 마음으로 읽을까요?" + 🌿 아이콘
- `posture(locale)` 비어 있으면 섹션 자체 숨김

### 신규 섹션 2: Original Words (원어로 만나는 깊은 뜻)

- 위치: posture 아래
- 기본 **접힘 상태** (expandable) — 시니어 UX: 긴 카드 방지
- 접힘 시: `"원어로 만나는 깊은 뜻 (2)"` 같이 개수 표시
- 펼침 시: 각 `OriginalWord` 세로 나열
  - 큰 글씨 원어 (히브리어/헬라어 hero 32pt)
  - 아래 작은 글씨 transliteration + language
  - 의미 `meaning(locale)` — body 18pt
  - 뉘앙스 `nuance(locale)` — bodySmall muted
  - 각 word 사이 divider 8pt

### RTL 처리

히브리어(he)는 RTL. `OriginalWord.language == 'Hebrew'`일 때 원어 `Text` 위젯 `textDirection: TextDirection.rtl`.

### Card: `OriginalLangCard` (삭제)

- 파일 삭제: `apps/abba/lib/features/dashboard/widgets/original_lang_card.dart`
- 참조 제거:
  - `prayer_dashboard_view.dart` (사용 중일 수 있음 — grep 후 제거)
  - `qt_dashboard_view.dart` (사용 안 하지만 import 확인)

### Responsive (Phase 2)
- compact (< 600): 원어 hero 32pt → 28pt로 축소 권장 (overflow 방지)
- medium 이상: 32pt 유지

## Phase 3-5 카드 변경 (추가 예정)

| Phase | 카드 | 변경 유형 |
|-------|------|---------|
| 3 | PrayerCoachingCard | 신규 생성 |
| 4 | HistoricalStoryCard | 확장 (todayLesson) |
| 5 | AiPrayerCard | 재작성 (audio 제거 + citations) |

## 참조
- `.claude/rules/responsive.md` — ScreenSize 4단계
- `.claude/rules/error-handling.md` — 3상태 필수
- `.claude/rules/flutter-layout.md` — ListView 규칙
- `.claude/rules/learned-pitfalls.md` §1 (Riverpod 라이프사이클 — 오디오 플레이어 provider dispose)
