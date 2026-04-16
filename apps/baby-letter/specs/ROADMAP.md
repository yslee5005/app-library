# 아기의 편지 (BabyLetter) — 개발 로드맵

> **Promise**: "아기가 보내는 편지로 시작하는, 판단하지 않는 육아앱"
> **상태**: 디자인 완료 (Stitch 61개 화면) → 개발 대기
> **마지막 업데이트**: 2026-04-16

---

## 관련 문서

| 문서 | 설명 | 링크 |
|------|------|------|
| 아이디어 검증 | YC 4P 검증, 타겟, 문제정의 | [IDEA.md](./IDEA.md) |
| 기능 요구사항 | 핵심 기능 8개, DB 스키마 | [REQUIREMENTS.md](./REQUIREMENTS.md) |
| 디자인 상세 | 컬러/폰트/카피/화면별 상세 | [DESIGN.md](./DESIGN.md) |
| Stitch 디자인 브리프 | 61개 화면 Stitch 프롬프트 | [STITCH_SCREENS.md](./STITCH_SCREENS.md) |
| 스크린 카탈로그 | 61개 화면 ID/설명/파일 매핑 | [SCREEN_CATALOG.md](./SCREEN_CATALOG.md) |
| 스크린 카탈로그 (JSON) | 머신 리더블 버전 | [SCREEN_CATALOG.json](./SCREEN_CATALOG.json) |
| **이 문서 (로드맵)** | **우선순위 등급별 개발 순서** | 현재 파일 |

---

## 디자인 시스템 요약

| 항목 | 값 |
|------|-----|
| Primary | Coral `#FF8A80` |
| Secondary | Amber `#FFD54F` |
| Tertiary | Sage Green `#81C784` |
| Background | Cream `#FFF8E1` |
| Headline Font | Plus Jakarta Sans |
| Body Font | Inter |
| Roundness | 12px |
| Mode | Light only |
| Stitch Project | `18309321079454432834` |
| Design System | `9717793471071498527` |

---

## 우선순위 등급 체계

| 등급 | 수량 | 목적 | 개발 시점 |
|------|------|------|----------|
| **S** | 10개 | 앱 실행 자체에 필수 | Phase 1 (출시) |
| **A** | 13개 | 핵심 가치 + 차별화 | Phase 1 (출시) |
| **B** | 18개 | Retention + 확장 | Phase 2 (출시 후 1-2개월) |
| **C** | 20개 | 고급 기능 / v2.0 | Phase 3 (시장 반응 후) |

**출시 목표: S + A = 23개 화면**

---

## S등급 — 앱 실행 필수 (10개)

> 이것 없이는 앱이 안 돌아감. Phase 1 필수.

### 유저 플로우
```
설치 → A1(스플래시) → A2(모드선택) → A3 or A4(정보입력)
     → B1 or B2(홈) → B3(편지 읽기!) → C1 or C2(기록) → F1(설정)
```

### 화면 목록

| # | Key | 화면 | 카테고리 | 코드 파일 | 핵심 이유 |
|---|-----|------|---------|----------|----------|
| 1 | A1 | 스플래시 | 온보딩 | `A1_splash.html` | 앱 진입점 |
| 2 | A2 | 모드 선택 | 온보딩 | `A2_welcome.html` | 임신/출산 분기 (앱 구조의 뿌리) |
| 3 | A3 | 임신정보 입력 | 온보딩 | `A3_pregnancy_input.html` | 주차 계산 → 편지/영상 매핑 기초 |
| 4 | A4 | 출산후 정보 입력 | 온보딩 | `A4_postnatal_input.html` | D+일수 → 콘텐츠 매핑 기초 |
| 5 | B1 | 홈 (임신중) | 홈탭 | `B1_home_pregnant.html` | 앱의 메인 화면 |
| 6 | B2 | 홈 (출산후) | 홈탭 | `B2_home_postnatal.html` | 앱의 메인 화면 |
| 7 | **B3** | **편지 상세** | 홈탭 | `B3_letter_detail.html` | **AHA moment. Promise 그 자체** |
| 8 | C1 | 기록 메인 (임신중) | 기록탭 | `C1_record_pregnant.html` | 기록탭 진입점 |
| 9 | C2 | 기록 메인 (출산후) | 기록탭 | `C2_record_postnatal.html` | 기록탭 진입점 |
| 10 | F1 | 설정 메인 | 설정 | `F1_settings_main.html` | 프로필/모드 변경 필수 |

---

## A등급 — 핵심 차별화 (13개)

> 없으면 "그냥 또 다른 육아앱". Phase 1에 포함.

### 편지/콘텐츠 (Promise 강화)

| # | Key | 화면 | 코드 파일 | 핵심 이유 |
|---|-----|------|----------|----------|
| 11 | B5 | 편지 히스토리 | `B5_letter_collection.html` | 편지 모아보기 → 수집 동기 |
| 12 | B4 | 태아영상 풀스크린 | `B4_fetal_video.html` | 임신 중 킬러 콘텐츠 |
| 13 | NEW5 | 주차별 태아 카드 | `NEW5_weekly_fetal_card.html` | 주차별 통합 정보 (이미지+편지+발달) |

### 3대 기록 (출산 후 핵심)

| # | Key | 화면 | 코드 파일 | 핵심 이유 |
|---|-----|------|----------|----------|
| 14 | C3 | 태동 카운터 | `C3_kick_counter.html` | 임신 중 유일한 기록 기능 |
| 15 | C11 | 수유 기록 | `C11_feeding_log.html` | 출산 후 필수 기록 |
| 16 | C10 | 수면 기록 | `C10_sleep_tracking.html` | 출산 후 필수 기록 |
| 17 | C12 | 기저귀 기록 | `C12_diaper_log.html` | 출산 후 필수 기록 |

### 삼각형 케어 (최대 차별화)

| # | Key | 화면 | 코드 파일 | 핵심 이유 |
|---|-----|------|----------|----------|
| 18 | E1 | 우리 (트라이앵글) | `E1_us_main.html` | 가족 탭 메인, 삼각형 시각화 |
| 19 | E2 | EPDS 설문 | `E2_epds_survey.html` | 산후우울 조기발견 → 사회적 가치 |
| 20 | E4 | EPDS 결과 | `E4_epds_results.html` | 3단계 결과 + 행동 제안 |
| 21 | NEW1 | 감정 체크인 | `NEW1_emotion_checkin.html` | 매일 가벼운 감정 공유 (EPDS 보조) |

### 성장 Core

| # | Key | 화면 | 코드 파일 | 핵심 이유 |
|---|-----|------|----------|----------|
| 22 | D1 | 성장 타임라인 (게임맵) | `D1_growth_timeline.html` | 성장탭 메인 진입점 |
| 23 | D8 | WHO 성장 차트 | `D8_who_growth_chart.html` | 소아과 검진 시 실용적 가치 |

---

## B등급 — Retention 강화 (18개)

> 매일 돌아올 이유를 만듦. Phase 2 (출시 후 1-2개월).

### 기록 확장

| # | Key | 화면 | 코드 파일 | 핵심 이유 |
|---|-----|------|----------|----------|
| 24 | C4 | 기분 일기 | `C4_mood_diary.html` | 감정 추적 → 패턴 발견 |
| 25 | C5 | 사진 일기 | `C5_photo_diary.html` | 추억 기록 → 정서적 가치 |
| 26 | C6 | 체중 기록 | `C6_weight_tracking.html` | 임신 중 체중 관리 |
| 27 | C13 | 성장 측정 | `C13_growth_measurement.html` | 출산 후 체중/신장/머리둘레 |
| 28 | C9 | 기록 히스토리 | `C9_record_history.html` | 캘린더 뷰 → 한눈에 보기 |

### 성장/콘텐츠 확장

| # | Key | 화면 | 코드 파일 | 핵심 이유 |
|---|-----|------|----------|----------|
| 29 | D4 | 아기 프로필 | `D4_baby_profile.html` | 4-Layer 시각화 → 개인화 |
| 30 | D5 | 주간 비교 | `D5_weekly_comparison.html` | 패턴 인사이트 → "앱 쓰는 보람" |
| 31 | B6 | Serve & Return 가이드 | `B6_serve_return.html` | 뇌발달 과학 콘텐츠 |
| 32 | B8 | 발달팁 상세 | `B8_dev_tip_detail.html` | 일일 과학 콘텐츠 |
| 33 | B10 | 마일스톤 축하 | `B10_milestone_celebration.html` | 축하 모달 → 공유 → 바이럴 |

### 가족 확장

| # | Key | 화면 | 코드 파일 | 핵심 이유 |
|---|-----|------|----------|----------|
| 34 | E8 | 가족 미션 | `E8_family_mission.html` | 양방향 미션 → 아빠 참여 |
| 35 | NEW2 | 배려 넛지 | `NEW2_care_nudge.html` | 파트너 배려 자동 제안 |
| 36 | NEW3 | 감사 저널 | `NEW3_gratitude_journal.html` | 저녁 앱 오픈 유도 → Retention |
| 37 | E3 | EPDS 히스토리 | `E3_epds_history.html` | 감정 추이 확인 |

### 설정/온보딩 확장

| # | Key | 화면 | 코드 파일 | 핵심 이유 |
|---|-----|------|----------|----------|
| 38 | F2 | 프로필 수정 | `F2_profile_edit.html` | 정보 수정 |
| 39 | F6 | 알림 설정 | `F6_notification_settings.html` | 알림 관리 |
| 40 | A5 | 알림 허용 | `A5_notification_permission.html` | 온보딩 마지막 단계 |

### Gamification 기본

| # | Key | 화면 | 코드 파일 | 핵심 이유 |
|---|-----|------|----------|----------|
| 41 | G1 | 뱃지 컬렉션 | `G1_badge_collection.html` | 수집 동기 → 기록 유도 |

---

## C등급 — v2.0 이후 (20개)

> 앱이 성장한 후 추가. 시장 반응 보고 결정. Phase 3.

### 기록 고급

| # | Key | 화면 | 코드 파일 | 비고 |
|---|-----|------|----------|------|
| 42 | C7 | 혈압 기록 | `C7_blood_pressure.html` | 고위험 임산부 전용 |
| 43 | C8 | 증상 기록 | `C8_symptom_log.html` | 있으면 좋지만 필수 아님 |

### 성장 고급

| # | Key | 화면 | 코드 파일 | 비고 |
|---|-----|------|----------|------|
| 44 | D2 | 마일스톤 상세 | `D2_milestone_detail.html` | D1에서 기본 표시로 충분 |
| 45 | D3 | 사진 비교 | `D3_photo_compare.html` | 재미 기능 |
| 46 | D6 | 수면 패턴 시각화 | `D6_pattern_sleep.html` | 고급 분석 |
| 47 | D7 | 수유 패턴 시각화 | `D7_pattern_feed.html` | 고급 분석 |

### 가족 고급

| # | Key | 화면 | 코드 파일 | 비고 |
|---|-----|------|----------|------|
| 48 | E7 | 전문가 가이드 | `E7_expert_guide.html` | 콘텐츠 축적 필요 |
| 49 | E9 | 가족 사진첩 | `E9_family_photo.html` | 사진앱과 중복 |
| 50 | E10 | 커뮤니티 | `E10_community.html` | IDEA.md에서 MVP 제외 대상 |

### 설정 고급

| # | Key | 화면 | 코드 파일 | 비고 |
|---|-----|------|----------|------|
| 51 | F3 | 앱 정보 | `F3_app_info.html` | 출시 직전에 추가 |
| 52 | F4 | 데이터 내보내기 | `F4_data_export.html` | 유저 많아진 후 |
| 53 | F5 | 프리미엄 | `F5_premium.html` | 수익화 단계에서 |

### Gamification 확장

| # | Key | 화면 | 코드 파일 | 비고 |
|---|-----|------|----------|------|
| 54 | G2 | 레벨 & XP 상세 | `G2_level_xp.html` | G1에서 기본 표시로 충분 |
| 55 | G3 | 캐릭터 진화 | `G3_character_evolution.html` | 재미 요소 |
| 56 | G4 | 주간 챌린지 | `G4_weekly_challenge.html` | Retention 추가 장치 |

### 콘텐츠/알림

| # | Key | 화면 | 코드 파일 | 비고 |
|---|-----|------|----------|------|
| 57 | B7 | 4th Trimester 가이드 | `B7_4th_trimester.html` | 콘텐츠 기능 |
| 58 | B9 | 알림 센터 | `B9_notification_center.html` | 시스템 알림으로 대체 가능 |
| 59 | NEW4 | 관심군 알림 | `NEW4_concern_alert.html` | 데이터 축적 후 가능 |

### 에셋

| # | Key | 화면 | 코드 파일 | 비고 |
|---|-----|------|----------|------|
| 60 | ASSET1 | 임산부 일러스트 | `ASSET1_pregnant_illustration.html` | 디자인 에셋 |
| 61 | ASSET2 | 캐릭터 일러스트 | `ASSET2_character_illustration.html` | 디자인 에셋 |

---

## 컨셉 적용 검증

### 핵심 철학 (IDEA.md) — 전체 적용 확인

| 컨셉 | 적용 | 반영 화면 |
|------|------|----------|
| 아기 시점 1인칭 편지 | ✅ | B3 (편지지배경, 1인칭텍스트, 과학출처) |
| 비판단적 기록 | ✅ | D5, D8 ("많다/적다 판단 없이") |
| 삼각형 케어 (엄마+아빠+아기) | ✅ | E1 (트라이앵글 시각화) |
| Warm Start (임신→출산) | ✅ | A2 (모드선택), B1/B2 (분기 홈) |
| EPDS 산후우울 체크 | ✅ | E2, E3, E4 |
| 4-Layer 프로파일링 | ✅ | D4 (4단계카드, 레이더차트) |
| Technoference 방지 | ✅ | B2 (회고 형태) |
| 절대 위험만 알림 | ✅ | NEW4 (관심/주의 2단계) |
| Anonymous-First | ✅ | 로그인 화면 없음 |

### Gamification — 전체 적용 확인

| 요소 | 적용 | 반영 화면 |
|------|------|----------|
| 레벨 5단계 (씨앗→열매) | ✅ | G3 |
| XP 시스템 | ✅ | G2, 여러 화면 |
| 배지 8종 | ✅ | G1 |
| 연속 스트릭 | ✅ | 홈/기록 화면 |
| 주간 챌린지 | ✅ | G4 |

### 카피라이팅 공식 — 적용 확인

```
[감정 Hook] + [과학 사실] + [행동 유도]
```
- ❌ "24주입니다. 청각이 발달합니다."
- ✅ "콩이가 엄마 목소리를 구별하기 시작했어요. 오늘 3분만 노래 불러줄래요?"

→ B3 편지 상세, B8 발달팁 상세에 반영

---

## 누락/변경 사항 (향후 보완)

DESIGN.md 원본 대비 SCREEN_CATALOG에서 변경/누락된 화면:

| 원래 화면 | 상태 | 우선순위 | 비고 |
|----------|------|---------|------|
| 위험신호 상세 (풀스크린 경고) | 누락 | A등급 | 안전 기능, B8이 발달팁으로 변경됨 |
| 파트너 메시지 (감정카드 보내기/받기) | 누락 | B등급 | E7이 전문가 가이드로 변경됨 |
| 주간 회고 (하이라이트+감정변화) | 누락 | B등급 | E10이 커뮤니티로 변경됨 |
| 소아과 리포트 (PDF 내보내기) | 누락 | C등급 | D7이 수유 패턴으로 변경됨 |
| 프로파일링 퀴즈 3종 (크로노/기질/수면) | 누락 | B등급 | G카테고리가 게이미피케이션으로 변경 |
| 아빠 미션 상세 (타이머+완료사진) | 누락 | B등급 | E9가 가족 사진첩으로 변경됨 |
| EPDS 결과 3분할 (정상/주의/위험) | 통합 | - | E4 하나로 통합 (문제 없음) |

→ Phase 2에서 Stitch로 추가 생성 예정

---

## 파일 구조

```
apps/baby-letter/
├── specs/
│   ├── IDEA.md                 ← YC 4P 검증
│   ├── REQUIREMENTS.md         ← 기능 요구사항
│   ├── DESIGN.md               ← 디자인 상세 (61개 화면 프롬프트)
│   ├── STITCH_SCREENS.md       ← Stitch 디자인 브리프
│   ├── SCREEN_CATALOG.md       ← 스크린 카탈로그 (카테고리별)
│   ├── SCREEN_CATALOG.json     ← 스크린 카탈로그 (머신 리더블)
│   └── ROADMAP.md              ← 이 문서 (우선순위 로드맵)
├── stitch-designs/
│   ├── code/                   ← 61개 HTML 코드 파일
│   │   ├── A1_splash.html
│   │   ├── B1_home_pregnant.html
│   │   └── ...
│   └── rename_files.py         ← screen_id → key_name 변환 스크립트
└── lib/                        ← Flutter 소스 (개발 시작 시)
    └── shared/models/
        └── user_state.dart     ← UserMode (pregnant/postnatal) 모델
```

---

## 메모

- 다른 앱 배포 우선 → baby-letter는 디자인 완료 상태에서 대기
- 개발 시작 시 S등급 10개 → A등급 13개 순으로 진행
- S+A = 23개 화면으로 출시 가능
- Stitch HTML 코드는 `stitch-designs/code/`에 전체 보관됨
