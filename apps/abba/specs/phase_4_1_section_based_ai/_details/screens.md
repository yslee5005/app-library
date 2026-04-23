# 화면 상태 — Progressive Streaming UX

## Overview

Phase 4.1은 **AI Loading** + **Prayer Dashboard** 두 화면의 UX를 근본적으로 바꿈. SSE streaming과 progressive card reveal을 중심으로.

## 1. AI Loading View (기도 제출 직후)

### State: Streaming (T1 진행 중)

```
┌─────────────────────────────────┐
│                                 │
│        🌱                       │
│                                 │
│   기도를 묵상하고 있어요...       │
│                                 │
│   [first token 받기 시작]       │
│                                 │
│   (background: stage timer +    │
│    fadeController)              │
│                                 │
└─────────────────────────────────┘
   ↓ Gemini SSE 첫 chunk 도착 (~600ms)
```

### State: First chunks received (아직 T1 완성 전)

- 첫 유의미 chunk 도착 즉시 Dashboard로 라우팅
- AI Loading 화면은 잠깐만 보여지고 사라짐
- Dashboard에서 typewriter-like streaming UX로 이어짐

### State: T1 Error (네트워크 실패 or Gemini 장애)

Phase 3 기존 에러뷰 재활용:
```
┌─────────────────────────────────┐
│        🌿                       │
│                                 │
│    연결이 불안정해요            │
│                                 │
│  기도는 안전히 저장됐어요.      │
│  잠시 후 다시 시도해주세요.    │
│                                 │
│  [ 🔄 다시 시도 ]               │
│  [ 🏠 홈으로 ]                  │
│                                 │
└─────────────────────────────────┘
```

## 2. Prayer Dashboard (T1 도착 직후 → 전체 완성까지)

### Phase 1: T1 Arrived (0-5초, streaming)

```
┌─────────────────────────────────┐
│  🌸 기도 분석                  │
│  [공유]              [홈으로]    │
│                                 │
│  ┌───────────────────────────┐  │
│  │ 📋 기도 요약              │  │
│  │                           │  │
│  │ 감사: [streaming text]    │  │ ← SSE chunk 도착마다 append
│  │ 간구: [streaming text]    │  │
│  │ 중보: [streaming text]    │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ 🌿 오늘의 말씀            │  │
│  │ Matthew 6:33              │  │ ← scripture reference 먼저
│  │ [verse text 로딩...]      │  │ ← bundle lookup 진행
│  └───────────────────────────┘  │
│                                 │
│  ⏳ 더 많은 내용 준비 중...       │ ← T2 플레이스홀더
│                                 │
└─────────────────────────────────┘
```

**Scripture 특수 처리**:
- `scripture.reference` streaming chunk에서 나오자마자 → client validation 시작
- Valid → bundle에서 verse text 조회 → 카드에 추가
- Invalid (환각) → 1회 재시도 or safe fallback UI

### Phase 2: T2 Arrived (7-10초 후)

```
┌─────────────────────────────────┐
│  📋 기도 요약 [완성]            │
│  🌿 오늘의 말씀 [완성]          │
│                                 │
│  ┌───────────────────────────┐  │
│  │ 📖 성경 이야기             │  │ ← FadeIn 0.5s
│  │ 나단 예언자의 용기          │  │
│  │ ...                        │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ ✍️ 나의 간증               │  │ ← FadeIn 0.5s (순차)
│  │ 주님께 오늘 감사의 기도를...  │  │
│  └───────────────────────────┘  │
│                                 │
│  [Pro 영역 플레이스홀더]         │ ← Pro 유저만
│                                 │
└─────────────────────────────────┘
```

### Phase 3: Pro 유저 스크롤 → T3 Trigger

```
유저가 스크롤 → Premium 카드 영역 visible
        ↓ VisibilityDetector
[T3 Gemini 호출 시작]
        ↓ ~15-18초
┌─────────────────────────────────┐
│  ...이전 카드들...              │
│                                 │
│  ┌───────────────────────────┐  │
│  │ 💬 AI 조언 [Pro]           │  │
│  │ 오늘 당신의 기도는...       │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ 🔊 당신을 위한 기도 [Pro]  │  │
│  │ 하늘 아버지, 오늘도...     │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ 📚 역사 이야기 [Pro]       │  │
│  │ George Müller의 새벽 기도  │  │
│  └───────────────────────────┘  │
│                                 │
│  [🏠 홈으로 돌아가기]           │
└─────────────────────────────────┘
```

### Pro 카드 영역 (T3 pending/processing)
```
┌───────────────────────────────┐
│ 💬 AI 조언 [Pro]              │
│                               │
│  ⏳ 준비 중...                │
│  (잠시만 기다려주세요)        │
│                               │
└───────────────────────────────┘
```

### Free 유저의 Premium 영역 (T3 아예 생성 안 됨)
Phase 1 디자인 유지 — 블러 처리 + "Pro 업그레이드" CTA.

## 3. Empty State (Template Fallback)

**Day-1 시나리오**: 첫 앱 실행 직후 기도 제출 → 네트워크 느리거나 Gemini cold start.

```
[유저 기도 제출]
  ↓
[Template fallback 즉시 표시] (캐시된 template + 유저 transcript)
  ↓ (background에서 실제 AI 호출 진행)
[AI 응답 도착 → 조용히 replace]
```

```
┌─────────────────────────────────┐
│  📋 기도 요약                   │
│                                 │
│  "[유저 기도 첫 부분]..."       │ ← 유저 transcript 축약
│                                 │
│  🌿 오늘의 말씀                 │
│  준비 중... (3-5초 후 완성)     │
│                                 │
└─────────────────────────────────┘
```

카테고리별 5-8개 template 기본 응답:
- 건강 기도
- 가족 기도
- 직장/학업
- 감사 기도
- 애도

Template는 `assets/prayer_templates/{category}_{locale}.json`에 저장.

## 4. Scripture Validation UI States

### Normal (verse 로드 성공)
```
🌿 Matthew 6:33
"너희는 먼저 그의 나라와 그의 의를 구하라..."

이 말씀은 당신의 기도와 깊이 연결돼 있어요.
오늘 이 구절을 묵상하시며...
```

### Fallback (validation 2회 실패 → safe fallback)
```
🌿 오늘의 말씀
준비 중인 구절이 있어요.
다시 앱을 열어보시면 완성돼 있을 거예요.
[새로고침]
```

## 5. Animation Timings

| 이벤트 | 애니메이션 |
|--------|----------|
| T1 streaming chunk arrival | 글자 즉시 append (CSS cursor blink) |
| Scripture reference 도착 | 카드 slide-down (300ms) |
| Verse text 도착 | 카드 expand (200ms) |
| T2 card 등장 | FadeIn (500ms) + slight scale(0.95→1.0) |
| T3 card 등장 (each of 3) | Sequential FadeIn (500ms each, 200ms stagger) |

## 6. Progressive Rendering Rules

- **Skeleton placeholders** 절대 사용 X (정적 placeholder는 "AI가 놀고 있다" 인상)
- **Background process indicator** 항상 표시 ("T2 준비 중" 라벨 + 작은 progress indicator)
- **Ghost text** 패턴: 유저가 읽을 위치에 T2 플레이스홀더 (CSS dashed outline으로 "곧 나타납니다" 암시)

## 7. Error State Recovery

### T2 실패 시
- 해당 영역 UI 숨김 (빈 공간)
- 유저에게 에러 표시 X (T1 completed → 유저 이미 만족)
- Sentry 조용히 로그

### T3 실패 시 (Pro)
- Premium 영역 "잠시 후 다시 와주세요" 메시지
- Phase 4 Edge Function lazy retry로 이관 (홈 재진입 시 완성)

### Scripture validation 2회 실패
- Scripture 카드만 safe fallback 표시
- 다른 카드 정상 렌더
- "이 기도에 대한 말씀은 곧 준비됩니다" 안내

## 8. Tier Loading Indicators (subtle)

각 tier 완성 전 카드 하단:
```
  T1 완성   ✅ 
  T2 완성   ✅ 
  T3 준비 중 ⏳
```

시니어에게 "지금 어디까지 됐나" 안내. 작게 표시 (caption 레벨).

## 9. Dashboard 카드 구조 (변경 없음)

기존 Phase 1 설계 유지:
- ScriptureCard
- BibleStoryCard
- TestimonyCard
- GuidanceCard (Pro blur if not Pro)
- AiPrayerCard (Pro blur if not Pro)
- HistoricalStoryCard (Pro blur if not Pro)

**변경점**: 카드가 **동시에 전부 렌더** → **tier별 등장**.

## 10. Calendar / History 재방문 시

과거 기도를 Calendar/History에서 탭해서 다시 보는 경우:
- `section_status` 전체 completed → 모든 카드 즉시 렌더 (FadeIn 애니메이션 skip)
- Typewriter 효과 X (이미 본 내용)
- Pro 블러 처리 그대로 (구독 상태 확인)

이 분기는 `PrayerSectionsNotifier.setAllTiersInstant(result)` 메서드로 처리.
