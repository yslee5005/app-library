# Feature: Section-Based AI with Cached Rubrics (Phase 4.1)

> Status: draft · Owner: yslee5005 · Updated: 2026-04-23 · App: abba

## TL;DR

Gemini 2.5 Flash 기반 **3-tier Lazy Generation** + **공유 영어 cached rubric** + **Streaming T1** + **Scripture validation** 도입. 기도/QT AI 분석 품질 +10-15%, 비용 77% 절감, 첫 반응 체감 3-5s → ~600ms.

## Why

Phase 3에서 단일 Gemini call로 모든 AI 응답을 한 번에 생성하는 구조였으나:
- 하드코딩 fallback 제거(§2-1) 완료 후에도 **일관된 품질** 보장 어려움
- 응답 전체가 준비될 때까지 유저 대기 (UX 악화)
- 섹션별 재시도/Analytics 불가능
- 섹션 간 "필드 오염" (같은 성경 구절 반복 사용 등)

이 Phase는 유저 engagement curve(100%/55%/45%)에 맞춰 섹션을 3 tier로 분할하고, 각 tier가 독립적으로 Gemini 호출 → 비용과 품질 동시 개선.

## Scope

### 포함 (In-scope)
- 3-tier 구조 (T1=summary+scripture / T2=bible_story+testimony / T3=Pro premium)
- Gemini Context Cache (Strategy B 공유 cache, Lazy 생성)
- 글로벌 중립 rubric (영어 작성, 35 locale 대응)
- Scripture validation (local Bible bundle 검증)
- SSE streaming on T1 (Gemini `generateContentStream`)
- Progressive Dashboard UI (카드별 FadeIn)
- Day-1 template fallback
- Prayer + QT 양쪽 tier 구조 적용

### 제외 (Out-of-scope, Phase 2)
- Gemini Pro model 도입 (비용 4배, 적자 확인)
- prayers/qt_sessions 테이블 분리 (mode discriminator 유지)
- `result` JSONB → 컬럼 분해 (JSONB 유연성 유지)
- Batch API for T3 (Q4 최적화, 출시 후 적용)
- Flash-Lite routing (A/B test 후)
- Output token tuning 2000→1400 (실데이터 후)
- 35 locale 전체 rubric 번역 (영어 단일 + locale appendix만)
- 언어별 per-locale cache (Strategy A 거부)

## 핵심 의사결정 (이번 대화 synthesis)

| # | 결정 | 근거 |
|---|------|------|
| 1 | Gemini 2.5 Flash 유지 (Pro 거부) | Pro 4x 비용, 1K MAU에서 월 $1,219 적자 |
| 2 | 3-tier Lazy Generation | 유저 engagement 100/55/45% 매칭, 비용 $560→$187 |
| 3 | 단일 `abba.prayers` 테이블 유지 | 테이블 분리는 post-launch 판단, 지금 과잉 |
| 4 | `result JSONB` 유지 | 컬럼 분해는 rubric 변경 시 migration 러닝머신 |
| 5 | Strategy B 공유 cache (영어) | 35 locale-per-cache 대비 57% 절감, 35h→30분 유지보수 |
| 6 | Lazy cache 생성 (pg_cron 제거) | 첫 유저 500ms 패널티는 T1 호출에 묻힘, 단순성 ↑ |
| 7 | 영어 rubric + locale 예시 혼합 | Shi 2023, Duolingo/Google 선례 |
| 8 | Scripture validation layer (MVP 필수) | 환각 차단이 7-call 분할보다 큰 체감 품질 향상 |
| 9 | SSE streaming on T1 | 첫 반응 3-5s → ~600ms, 비용 변동 없음 |
| 10 | Day-1 template fallback | Empty state 이탈 방지, offline 대응 |

## 데이터
@./_details/data_model.md

## 아키텍처
@./_details/architecture.md

## Cache 전략
@./_details/cache_strategy.md

## Rubric 설계
@./_details/rubric_design.md

## 글로벌 중립 원칙 (35 locale)
@./_details/globalization.md

## 화면 (Empty / Loading / Streaming / Tier / Error)
@./_details/screens.md

## 인터랙션 매트릭스 (Ralph가 한 줄씩 구현)
@./_details/interactions.md

## l10n 사전 정의
@./_details/l10n_keys.md

## 관련 함정 (learned-pitfalls 참조)
@./_details/pitfall_refs.md

## 검증 통과 기준

### 자동 검증
- [ ] `flutter analyze apps/abba` → 0 issues
- [ ] `flutter test apps/abba` → 252+ pass (pre-existing 2 fail 유지)
- [ ] 모든 INT-XXX widget test 통과
- [ ] `scripts/harness_check.sh apps/abba` 통과

### 수동 검증 (사용자)
- [ ] 8개 rubric 문서 신학적 정확성 검토
- [ ] 실기기 E2E — 정상 기도 플로우
- [ ] 실기기 E2E — 비행기 모드 (에러 뷰)
- [ ] 실기기 E2E — Gemini 장애 시뮬레이션 (3회 재시도)
- [ ] 실기기 E2E — 재방문 시 pending 자동 복구
- [ ] Supabase Studio — section_status column 수동 inspect
- [ ] Gemini cache hit rate 확인 (`cached_tokens > 0`)

### 출시 후 관찰 (2-4주)
- [ ] Scripture validation 실패율 < 5%
- [ ] Cache hit rate > 95%
- [ ] T1 평균 latency < 5s (p95)
- [ ] Sentry AI error rate < 1%
- [ ] Non-Korean locale 품질 측정 (human eval 샘플)

## 예상 소요

| 단계 | 시간 | 담당 |
|------|------|------|
| Spec 작성 | 1h | Claude (현재) |
| 사용자 검토 | 1-2일 | 사용자 |
| Ralph 순차 구현 | 15-18h | Ralph agent |
| 실기기 E2E | 1-2h | 사용자 |
| **Total 캘린더** | **3-5일** | — |

## 후속 Phase 2 계획 (출시 후 데이터 기반)

- Batch API for T3 (-$110/월)
- Flash-Lite T2 routing (-$90/월, A/B test 후)
- Output token tuning (-$140/월)
- 저자원 locale 선별적 per-locale cache (아랍어/히브리어 필요 시)
- 핫 필드 TEXT 컬럼 승격 (쿼리 p95 > 200ms 시)
