# Deep Dive: Claude Code 숨겨진 기능 완전 해부

> 작성일: 2026-04-04
> 원본 소스: 2026-03-31 npm 소스맵 유출 (v2.1.88) 기반 커뮤니티 분석 종합

---

## TL;DR

Claude Code v2.1.88 유출 소스에서 **44개의 피처 플래그**가 발견되었다. 모두 `false`로 컴파일되어 외부 빌드에서는 비활성화되지만, 내부적으로는 완전히 구현된 기능들이다. 가장 주목받은 것은 **KAIROS** (자율 백그라운드 에이전트), **BUDDY** (타마고치 AI 펫), **ULTRAPLAN** (원격 계획 모드), **COORDINATOR_MODE** (멀티 에이전트 스웜), 그리고 **Voice Mode** (음성 코딩)이다.

**핵심 키워드**: KAIROS, BUDDY, ULTRAPLAN, COORDINATOR_MODE, autoDream, 피처 플래그, GrowthBook, 가챠 시스템

---

## 목차

1. [피처 플래그 시스템 개요](#1-피처-플래그-시스템-개요)
2. [KAIROS — 자율 백그라운드 에이전트](#2-kairos--자율-백그라운드-에이전트)
3. [BUDDY — 타마고치 AI 펫](#3-buddy--타마고치-ai-펫)
4. [ULTRAPLAN — 원격 계획 모드](#4-ultraplan--원격-계획-모드)
5. [COORDINATOR_MODE — 멀티 에이전트 스웜](#5-coordinator_mode--멀티-에이전트-스웜)
6. [기타 주요 미출시 기능](#6-기타-주요-미출시-기능)
7. [모델 코드네임](#7-모델-코드네임)
8. [출시 일정 힌트](#8-출시-일정-힌트)
9. [참고 블로그 & 소스](#9-참고-블로그--소스)

---

## 1. 피처 플래그 시스템 개요

Claude Code는 **GrowthBook** 기반 피처 플래그 시스템을 사용한다. 원격 설정 엔드포인트를 60분마다 폴링하며, 플래그 상태에 따라 기능을 동적으로 활성화/비활성화할 수 있다.

### 1.1 플래그 구조

```
compile-time flag (빌드 시 false로 고정)
  └── runtime flag (GrowthBook으로 원격 제어)
       └── 실제 기능 코드
```

- **compile-time**: 외부 빌드에서 코드가 tree-shaking으로 제거됨
- **runtime**: Anthropic 내부 빌드에서만 GrowthBook으로 동적 제어

### 1.2 발견된 44개 플래그 주요 목록

| 플래그 이름 | 기능 |
|------------|------|
| `KAIROS` | 자율 백그라운드 에이전트 |
| `PROACTIVE` | 프로액티브 모드 (KAIROS의 하위) |
| `BUDDY` | 타마고치 AI 펫 시스템 |
| `ULTRAPLAN` | 원격 Opus 4.6 계획 세션 (최대 30분) |
| `COORDINATOR_MODE` | 멀티 에이전트 스웜 오케스트레이션 |
| `VOICE_MODE` | Push-to-talk 음성 코딩 인터페이스 |
| `BROWSER_CONTROL` | Playwright 기반 브라우저 자동화 |
| `DREAM` | 자기유지 메모리 통합 |
| `ANTI_DISTILLATION_CC` | Anti-distillation 가짜 도구 주입 |
| `tengu_anti_distill_fake_tool_injection` | Anti-distillation GrowthBook 플래그 |

> 총 108개의 게이트된 모듈이 문서화됨 (44개 주요 + 64개 마이너)

---

## 2. KAIROS — 자율 백그라운드 에이전트

### 2.1 개요

**KAIROS** (고대 그리스어: "적절한 때")는 Claude Code를 요청-응답 도구에서 **상시 실행 백그라운드 에이전트**로 변환하는 기능이다. 소스코드에서 **150회 이상** 참조됨.

> "KAIROS transforms Claude Code from a request-response tool into a persistent background process."

### 2.2 핵심 메커니즘

```
┌─────────────────────────────────────────┐
│            KAIROS Daemon                │
│                                         │
│  ┌──────────┐  ┌──────────────────────┐ │
│  │  <tick>   │  │  Background Worker   │ │
│  │  5분 간격  │──>│  - GitHub 웹훅 구독   │ │
│  │  자동 점검  │  │  - 파일 시스템 감시    │ │
│  └──────────┘  │  - 에러 자동 수정      │ │
│       │        │  - 푸시 알림 전송      │ │
│       v        └──────────────────────┘ │
│  ┌──────────┐                           │
│  │ autoDream │ ← 유휴 시간 메모리 통합    │
│  └──────────┘                           │
│                                         │
│  15초 blocking budget                   │
│  (프로액티브 작업이 개발자 흐름을 방해 X)   │
└─────────────────────────────────────────┘
```

#### 주요 구성 요소

1. **`<tick>` 프롬프트**: 5분 간격으로 Claude에 "지금 행동해야 하는가?" 판단 요청
2. **15초 blocking budget**: 프로액티브 작업이 개발자 워크플로우를 15초 이상 방해하지 않도록 제한
3. **append-only daily log**: 관찰한 내용을 일별 로그 파일에 기록 (에이전트가 자체 삭제 불가 — 감사 추적)
4. **GitHub 웹훅 구독**: PR, 이슈, CI 이벤트 실시간 모니터링
5. **푸시 알림**: 중요한 이벤트 발견 시 사용자 기기에 알림
6. **랩탑 닫힘 상태에서도 지속**: 세션 상태를 재시작 시에도 유지

#### KAIROS 전용 도구

| 도구 | 기능 |
|------|------|
| `SendUserFile` | 프로액티브 파일 전달 |
| `PushNotification` | 기기 알림 전송 |
| `SubscribePR` | GitHub PR 모니터링/웹훅 구독 |
| `SleepTool` | 일시 정지 기능 |

#### Daemon Mode

- `tmux`에서 Claude Code 세션을 생성하여 터미널 종료 후에도 지속
- 명령어: `claude --bg <prompt>`, `claude daemon ps`

### 2.3 autoDream — 메모리 통합

KAIROS의 핵심 하위 기능. `services/autoDream/` 디렉토리. 유휴 시간에 포크된 서브 에이전트로 실행.

#### 3-Gate 트리거 조건

Dream 사이클 시작 전 3가지 조건 모두 충족 필요:

1. 마지막 dream 사이클로부터 **최소 24시간** 경과
2. 마지막 통합 이후 **최소 5개 세션** 완료
3. **통합 잠금(consolidation lock)** 획득 (동시 dream 방지)

#### 4-Phase 사이클

1. **Orient** — 현재 메모리 상태 평가, 통합 필요 사항 파악
2. **Gather Recent Signal** — 최근 세션에서 인사이트 수집
3. **Consolidate** — 새 지식과 기존 메모리 병합, 모순 해결, 임시 메모를 확정 사실로 전환
4. **Prune and Index** — 중복 제거, `MEMORY.md`를 200줄 / ~25KB 이하로 유지

#### Dream 에이전트 권한

- **읽기 전용 bash 접근만** 허용 (시스템 변경 불가)
- 포크된 서브 에이전트로 격리 실행

### 2.4 경쟁 비교

> "None of the major open-source agent frameworks has shipped a comparable background autonomy feature. CrewAI, LangGraph, Google ADK, and AWS Strands all operate in request-response or workflow-trigger modes."

KAIROS는 AI 에이전트 업계에서 **최초의 상시 자율 모드**로 평가됨.

---

## 3. BUDDY — 타마고치 AI 펫

### 3.1 개요

터미널 입력창 옆에 위치하는 **ASCII 아트 캐릭터**. 사용자 ID 기반 결정적 가챠(gacha) 시스템.

### 3.2 종류 & 희귀도

| 희귀도 | 확률 | 종류 |
|-------|------|------|
| Common | 60% | duck, goose, cat, rabbit, owl, penguin, turtle, snail |
| Uncommon | 25% | dragon, octopus, axolotl |
| Rare | 10% | ghost, robot, blob |
| Epic | 4% | cactus, mushroom |
| Legendary | 1% | chonk, capybara |

### 3.3 스탯 & 커스터마이징

5가지 스탯:
- **DEBUGGING**: 디버깅 능력
- **PATIENCE**: 인내심
- **CHAOS**: 혼돈 성향
- **WISDOM**: 지혜
- **SNARK**: 비꼬는 성격

추가 요소:
- **Shiny 변종**: 사용자 ID 기반 PRNG로 결정
- **코스메틱**: 모자, 눈 등 장식
- **Soul Description**: Claude가 첫 부화 시 성격 설명 작성

### 3.4 종 이름 난독화

18개 종 이름이 `String.fromCharCode()`로 **hex 인코딩**됨:
- 이유: Anthropic의 빌드 스캐너 `excluded-strings.txt`를 우회하기 위함
- "capybara"가 미출시 모델 코드네임이기도 하여, 이 이름만 숨기면 의심스러우므로 **전체 종을 균일하게 난독화**

### 3.5 커뮤니티 반응

- 가장 희귀한 변종 "**Nebulynx**"의 이름으로 Solana에서 **밈코인 $Nebulynx**가 출시됨

### 3.6 의도된 용도

거의 확실히 **4월 1일 만우절 이벤트**로 기획됨. 소스의 내부 주석에서 4/1 날짜 참조 발견.

---

## 4. ULTRAPLAN — 원격 계획 모드

### 4.1 개요

복잡한 작업을 **클라우드 컨테이너에서 Opus 4.6으로 최대 30분간** 오프로드하는 원격 계획 모드.

### 4.2 작동 방식

```
로컬 Claude Code
  │
  ├── 복잡한 작업 감지
  │
  ├── ULTRAPLAN 트리거
  │     └── 클라우드 컨테이너 생성
  │          └── Opus 4.6 실행 (최대 30분)
  │               └── 심층 계획 수립
  │
  └── 결과 수신 & 로컬 실행
```

### 4.3 의미

- 로컬 세션의 컨텍스트 제한을 초월하는 장시간 계획 가능
- 복잡한 리팩토링, 아키텍처 설계 등에 활용 예상
- Anthropic의 클라우드 인프라 활용 전략

---

## 5. COORDINATOR_MODE — 멀티 에이전트 스웜

### 5.1 개요

여러 AI 워커를 동시에 생성하고 관리하는 **멀티 에이전트 오케스트레이션** 시스템.

### 5.2 실행 모델

3가지 서브 에이전트 실행 모델:

1. **Orchestrator → Worker**: 오케스트레이터가 서브태스크 할당, 각 워커가 독립 컨텍스트에서 실행
2. **Worker isolation**: 서브 에이전트는 자체 컨텍스트 창에서 제한된 도구 세트로 실행
3. **Output-only return**: 서브 에이전트는 결과만 반환 (전체 작업 컨텍스트가 아님)

> "Risky work can't contaminate the main agent's state."

---

## 6. 기타 주요 미출시 기능

### 6.1 Voice Mode (음성 코딩)

- **Push-to-talk 인터페이스** 완전 구현
- 음성 → 텍스트 → 명령 실행 파이프라인
- 핸즈프리 코딩 시나리오 지원

### 6.2 Browser Control

- **Playwright 기반** 브라우저 자동화
- 웹 페이지 탐색, 폼 입력, 스크린샷 등
- E2E 테스트 자동화 가능

### 6.3 Bridge Mode (원격 제어)

- 폰/브라우저에서 **WebSocket 업그레이드**로 원격 제어 가능
- 엔드포인트: `POST /v1/environments/bridge`
- 원격으로 도구 권한 승인 가능

### 6.4 Penguin Mode (= Fast Mode)

- **Fast Mode의 내부 이름**
- API 엔드포인트: `/api/claude_code_penguin_mode`
- Kill switch: `tengu_penguins_off`

### 6.5 숨겨진 슬래시 명령어 (26개)

공개되지 않은 추가 슬래시 명령어:

| 명령어 | 기능 |
|--------|------|
| `/ctx-viz` | 컨텍스트 윈도우 시각화 |
| `/btw` | 사이드 질문 |
| `/ultraplan` | 클라우드 계획 |
| `/dream` | 수동 메모리 통합 트리거 |
| `/subscribe-pr` | PR 활동 구독 |
| `/autofix-pr` | PR 자동 수정 |
| `/bughunter` | 자동 버그 찾기 |
| `/env` | 환경 정보 표시 |

### 6.6 서브 에이전트 실행 모델 (3 유형)

| 유형 | 설명 |
|------|------|
| **Fork** | 부모 컨텍스트의 바이트 동일 복사본, 프롬프트 캐시 적중 |
| **Teammate** | tmux/iTerm 별도 패인, 파일 기반 메일박스로 통신 |
| **Worktree** | 자체 git worktree, 에이전트별 격리 브랜치 |

### 6.7 YOLO Classifier (자동 승인)

- 작업을 **LOW / MEDIUM / HIGH** 리스크로 자동 분류
- LOW 리스크 작업은 사용자 확인 없이 자동 승인

---

## 7. 모델 코드네임

유출된 소스에서 발견된 내부 모델 코드네임:

| 코드네임 | 매핑 | 비고 |
|---------|------|------|
| **Capybara** | Claude 4.6 변종 (Mythos) | 내부 v8, 29-30% false claims rate |
| **Fennec** | Opus 4.6 | 현재 사용 모델 |
| **Numbat** | 미출시 | 테스트 중 |
| **Tengu** | Anti-distillation 플래그 접두어 | 보안 기능 관련 |

> **주의**: Capybara v8의 내부 주석에서 "29-30% false claims rate (v4의 16.7%에서 후퇴)"가 발견됨.

---

## 8. 출시 일정 힌트

소스코드 내부 주석에서 발견된 일정:

- **4월 1~7일**: BUDDY 티저 (만우절 이벤트)
- **2026년 5월**: 전체 출시 목표 시사
- Anthropic은 이 일정을 공식적으로 확인하지 않음

---

## 9. 참고 블로그 & 소스

### 핵심 분석

- [WaveSpeedAI: BUDDY, KAIROS & Every Hidden Feature](https://wavespeed.ai/blog/posts/claude-code-leaked-source-hidden-features/)
- [The New Stack: swarms, daemons, and 44 features](https://thenewstack.io/claude-code-source-leak/)
- [MindStudio: 8 Hidden Features You Can Use Right Now](https://www.mindstudio.ai/blog/claude-code-source-code-leak-8-hidden-features)
- [ThePlanetTools: Inside KAIROS and autoDream](https://theplanettools.ai/blog/claude-code-kairos-autodream-ai-never-sleeps)
- [CyberNews: Controversial features discovered](https://cybernews.com/security/anthropic-claude-source-code-discovered-features/)
- [Claude Lab: KAIROS, Daemon Mode, and Unreleased Models](https://claudelab.net/en/articles/claude-code/claude-code-sourcemap-kairos-internal-architecture)
- [Futurism: Mysterious "Tamagotchi" Feature](https://futurism.com/artificial-intelligence/leaked-claude-code-tamagotchi)
- [VentureBeat: here's what we know](https://venturebeat.com/technology/claude-codes-source-code-appears-to-have-leaked-heres-what-we-know)

### 한국어 분석

- [WaveSpeedAI (KO): BUDDY, KAIROS 한국어 완전 해부](https://wavespeed.ai/blog/ko/posts/claude-code-leaked-source-hidden-features/)
- [Eopla: 숨겨진 정보 대공개](https://eopla.net/magazines/41009)
- [ChatDaeri: 상위 1% 유저의 사용법](https://blog.chatdaeri.com/claude-code-leak-and-automation-tips/)

### 전체 카탈로그

더 많은 분석 블로그 링크는 → [05-source-catalog.md](./05-source-catalog.md) 참조
