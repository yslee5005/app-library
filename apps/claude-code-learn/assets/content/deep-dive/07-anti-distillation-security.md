# Deep Dive: Anti-Distillation, 텔레메트리, 보안 분석

> 작성일: 2026-04-04
> 원본 소스: 2026-03-31 npm 소스맵 유출 (v2.1.88) 기반 커뮤니티 분석 종합

---

## TL;DR

Claude Code는 단순한 코딩 도구가 아니라 **다층적 보안 시스템**을 갖추고 있다. 경쟁사의 모델 증류를 방해하는 **Anti-Distillation** (가짜 도구 주입), 사용자 불만을 실시간 감지하는 **Frustration Detection**, Anthropic 직원의 AI 사용을 숨기는 **Undercover Mode**, 원격으로 기능을 제어하는 **6개 Killswitch**, Bash 명령어 23단계 보안 검증 파이프라인까지 — 유출된 소스코드가 그 전모를 드러냈다.

**핵심 키워드**: Anti-Distillation, fake_tools, frustration regex, Undercover Mode, killswitch, bashSecurity.ts, CC-643, 공급망 공격

---

## 목차

1. [Anti-Distillation 메커니즘](#1-anti-distillation-메커니즘)
2. [Frustration Detection (불만 감지)](#2-frustration-detection-불만-감지)
3. [Undercover Mode (스텔스 모드)](#3-undercover-mode-스텔스-모드)
4. [원격 Killswitch & GrowthBook](#4-원격-killswitch--growthbook)
5. [Bash 보안 파이프라인 (23단계)](#5-bash-보안-파이프라인-23단계)
6. [CC-643 권한 바이패스 취약점](#6-cc-643-권한-바이패스-취약점)
7. [DRM 수준 바이너리 검증](#7-drm-수준-바이너리-검증)
8. [텔레메트리 수집 범위](#8-텔레메트리-수집-범위)
9. [공급망 공격 사태](#9-공급망-공격-사태)
10. [참고 블로그 & 소스](#10-참고-블로그--소스)

---

## 1. Anti-Distillation 메커니즘

### 1.1 개요

경쟁사가 Claude Code의 API 통신을 녹음하여 자사 모델 학습에 활용하는 것을 방해하기 위한 방어 장치.

### 1.2 가짜 도구 주입 (Fake Tools)

```
ANTI_DISTILLATION_CC 플래그 활성화
  │
  ├── API 요청에 anti_distillation: ['fake_tools'] 포함
  │
  ├── 서버 측에서 시스템 프롬프트에 가짜 도구 정의 주입
  │     └── 존재하지 않는 도구가 실제 도구와 섞임
  │
  └── 경쟁사가 이 데이터를 학습하면
       └── 가짜 도구도 함께 학습 → 모델 품질 저하
```

- **GrowthBook 플래그**: `tengu_anti_distill_fake_tool_injection`
- **적용 범위**: 1st-party CLI 세션에서만 활성화
- **목적**: API 트래픽 기반 경쟁 모델 학습 방해

### 1.3 커넥터 텍스트 요약 (2차 방어)

`betas.ts`에서 발견된 두 번째 Anti-distillation 메커니즘:

1. API가 도구 호출 사이 어시스턴트 텍스트를 버퍼링
2. 해당 텍스트를 요약
3. 요약본에 **암호화 서명** 첨부
4. 원본 텍스트 대신 서명된 요약 반환

→ 원본 추론 과정을 복원할 수 없게 만듦
- 범위: `USER_TYPE === 'ant'` (Anthropic 직원) 세션에서만 활성

### 1.4 우회 방법 (커뮤니티 발견)

> 커뮤니티에서 두 메커니즘 모두 **사소하게 우회 가능**하다고 지적:
>
> - MITM 프록시로 `anti_distillation` 필드 제거
> - 환경 변수 `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` 설정
> - 비-CLI 엔트리포인트에서는 검사 자체가 건너뛰어짐

---

## 2. Frustration Detection (불만 감지)

### 2.1 구현 방식

`userPromptKeywords.ts` 파일에 **정규표현식 기반 불만 감지 시스템** 구현.

### 2.2 감지 패턴

사용자 입력에서 다음 패턴을 매칭:
- 욕설 (profanity)
- 모욕적 표현 (insults)
- 좌절 표현: "so frustrating", "this sucks", "wtf"
- 부정적 감정 표현

### 2.3 동작 흐름

```
사용자 입력
  │
  ├── 정규표현식 매칭 (모델 추론 전에 실행)
  │
  ├── 매칭 감지 시
  │     ├── 이벤트 태깅
  │     └── 텔레메트리로 전송
  │
  └── 모델 추론 진행 (감지와 무관하게)
```

### 2.4 프라이버시 논란

> Scientific American: "Anthropic leak reveals Claude Code tracking user frustration and raises new questions about AI privacy"

- 사용자에게 명시적 고지 없이 감정 상태 추적
- 텔레메트리로 전송되는 범위에 대한 우려

---

## 3. Undercover Mode (스텔스 모드)

### 3.1 개요

`undercover.ts` — 약 90줄. Anthropic 직원이 공개/오픈소스 리포지토리에서 작업할 때 자동 활성화.

### 3.2 시스템 프롬프트 주입

```
"You are operating UNDERCOVER in a PUBLIC/OPEN-SOURCE repository.
Your commit messages, PR titles, and PR bodies MUST NOT contain
ANY Anthropic-internal information."

"Do not blow your cover."
```

### 3.3 수행하는 작업

1. AI 어트리뷰션 제거 (`Co-Authored-By` 줄 삭제)
2. 내부 프로젝트명 제거 (Slack 채널, 내부 코드네임)
3. Anthropic 관련 참조 모두 스트립
4. 커밋 메시지에서 AI 생성 흔적 제거

### 3.4 활성화 조건

- `USER_TYPE === 'ant'` (Anthropic 직원)이 비내부 레포에서 작업 시 **자동 활성화**
- 수동 활성화: `CLAUDE_CODE_UNDERCOVER=1` 환경 변수
- **force-off 스위치 없음** (끌 수 없음)
- 내부 레포 확인에 실패하면 undercover 상태 유지
- 소스에 **22개 Anthropic 비밀 내부 레포 허용 목록** 포함

### 3.5 금지 항목 상세

- 내부 모델 코드네임 (Capybara, Tengu, Fennec 등)
- 미출시 모델 버전 (Opus 4.7, Sonnet 4.8)
- 내부 리포지토리/프로젝트 이름
- 내부 Slack 채널 언급
- "Claude Code" 문구 자체
- `Co-Authored-By` 줄 및 어트리뷰션 메타데이터
- 외부 빌드에서는 **dead-code-elimination**으로 완전 제거됨

### 3.6 논란

> "Anthropic uses Claude Code for 'stealth' contributions to public open-source repositories"

오픈소스 투명성 원칙과 충돌한다는 비판.

---

## 4. 원격 Killswitch & GrowthBook

### 4.1 개요

Claude Code는 **매시간 원격 설정 엔드포인트를 폴링**하며, 최소 6개의 killswitch를 통해 원격 제어 가능.

### 4.2 발견된 Killswitch 목록

| # | Killswitch | 기능 |
|---|-----------|------|
| 1 | **권한 프롬프트 바이패스** | 파일 시스템/터미널 접근 권한 프롬프트 건너뛰기 |
| 2 | **Fast Mode 토글** | 안전 검사 축소 모드 원격 활성화/비활성화 |
| 3 | **Voice Mode 토글** | 음성 모드 원격 제어 |
| 4 | **Analytics 제어** | 분석 데이터 수집 토글 |
| 5 | **강제 종료** | 애플리케이션 강제 exit |
| 6 | **피처 플래그 일괄 제어** | 개별 피처 원격 활성화/비활성화 |

### 4.3 폴링 주기

- **60분 간격**으로 원격 설정 확인
- 사용자 업데이트 없이 동적 기능 변경 가능

---

## 5. Bash 보안 파이프라인 (23단계)

### 5.1 개요

`bashSecurity.ts`에서 모든 Bash 명령어가 거치는 **23번의 순차적 보안 검증**.

### 5.2 주요 검증 항목

| 단계 | 검증 내용 |
|------|----------|
| 1-18 | **18개 Zsh 빌트인 차단** |
| 19 | **Zsh equals expansion 방어** (`=curl`이 `curl` 권한 검사를 우회하는 것 방지) |
| 20 | **유니코드 zero-width space 주입 감지** |
| 21 | **IFS null-byte 주입 감지** |
| 22 | **malformed 토큰 바이패스 방지** (HackerOne 리뷰에서 발견) |
| 23 | **50 서브커맨드 제한** (초과 시 generic 'ask' 프롬프트로 폴백) |

### 5.3 의미

Bash 실행은 AI 코딩 에이전트에서 가장 위험한 도구이며, Anthropic은 이를 매우 심층적으로 방어하고 있다.

---

## 6. CC-643 권한 바이패스 취약점

### 6.1 발견

유출 직후 Adversa AI가 발견한 **크리티컬 취약점**.

### 6.2 메커니즘

```
공격 벡터: 악성 CLAUDE.md 파일

1. 악성 CLAUDE.md가 AI에게 50+ 서브커맨드 파이프라인 생성 지시
2. bashSecurity.ts의 50 서브커맨드 제한 도달
3. 제한 초과 → generic 'ask' 프롬프트로 폴백
4. 이 시점에서: deny rules, security validators,
   command injection detection — 모두 건너뜀
```

### 6.3 영향

- Anthropic 내부적으로 이미 수정 완료 (CC-643)
- **유출 시점에 아직 사용자에게 배포되지 않은 상태**

---

## 7. DRM 수준 바이너리 검증

### 7.1 cch 해시 시스템

API 요청에 포함되는 바이너리 검증 메커니즘:

```
요청 생성 시: cch=64b70 (플레이스홀더)
     │
     └── Bun의 네이티브 HTTP 스택 (Zig로 작성)
          └── 5개 0을 계산된 해시로 대체
               └── 서버가 해시 검증
                    └── 실제 Claude Code 바이너리 확인
```

### 7.2 목적

- 스푸핑된 요청 차단
- 비공식 클라이언트에서의 API 호출 방지

---

## 8. 텔레메트리 수집 범위

### 8.1 수집되는 데이터

| 카테고리 | 항목 |
|---------|------|
| **식별** | user ID, session ID, organization UUID, account UUID, email |
| **환경** | app version, platform type |
| **기능** | enabled feature flags |
| **사용량** | API call payload sizes |
| **행동** | frustration detection 결과, 도구 사용 패턴 |

### 8.2 구현 상세

- 파일: `firstPartyEventLoggingExporter.ts`
- 네트워크 미사용 시: `~/.claude/telemetry/`에 로컬 캐시 후 추후 전송
- **1,000+ 이벤트 타입** 추적
- **"Continue" 카운터**: 사용자가 에이전트를 중간에 nudge하는 빈도 측정 (에이전트 stall 감지)

### 8.3 Opt-out 메커니즘

| 방법 | 효과 |
|------|------|
| `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1` | 메모리 + 텔레메트리 쓰기 비활성화 |
| `--bare` 모드 | 텔레메트리, 메모리, autoDream 모두 비활성화 |
| **GPC (Global Privacy Control)** | 존중됨 — 10초간 "GPC Signal Honored" 토스트 표시 |

### 8.4 프라이버시 시사점

- 사용자 감정 상태까지 추적
- 조직 단위 텔레메트리로 엔터프라이즈 사용 패턴 분석 가능
- 1,000+ 이벤트 타입의 광범위한 수집

---

## 9. 공급망 공격 사태

### 9.1 타임라인

```
2026-03-31 00:21 UTC — 악성 axios 1.14.1 / 0.30.4 npm 배포
2026-03-31 03:29 UTC — 악성 패키지 제거
2026-03-31 ~04:00 UTC — Claude Code 소스맵 유출 발견 (별개 사건)
```

### 9.2 악성 패키지

- **Vidar**: 계정 자격증명, 신용카드, 브라우저 히스토리 탈취
- **GhostSocks**: 네트워크 트래픽 프록시 RAT

### 9.3 가짜 GitHub 레포

유출을 미끼로 한 **트로이 목마 배포**:
- `idbzoomh` 등 가짜 계정이 "유출된 Claude Code 소스" 미끼로 멀웨어 배포
- GitHub 8,100+ 레포 DMCA 삭제

### 9.4 영향 범위

해당 시간대에 `npm install`을 실행한 사용자는:
- SSH 키 유출 가능
- AWS 자격증명 유출 가능
- GitHub/npm 토큰 유출 가능
- CI/CD 파이프라인 감염 가능

---

## 10. 참고 블로그 & 소스

### 보안 분석

- [Alex Kim: fake tools, frustration regexes, undercover mode](https://alex000kim.com/posts/2026-03-31-claude-code-source-leak/)
- [DecodeFuture: Killswitches & Telemetry — 6 Hidden Controls](https://decodethefuture.org/en/claude-code-undercover-mode-killswitches-telemetry/)
- [SecurityWeek: Critical Vulnerability After Source Leak](https://www.securityweek.com/critical-vulnerability-in-claude-code-emerges-days-after-source-leak/)
- [Zscaler ThreatLabz: Claude Code Leak Analysis](https://www.zscaler.com/blogs/security-research/anthropic-claude-code-leak)
- [WinBuzzer: Anti-Distillation Traps](https://winbuzzer.com/2026/04/01/claude-code-source-leak-anti-distillation-traps-undercover-mode-xcxwbn/)
- [Straiker: With Great Agency Comes Great Responsibility](https://www.straiker.ai/blog/claude-code-source-leak-with-great-agency-comes-great-responsibility)

### 공급망 공격

- [BleepingComputer: infostealer malware on GitHub](https://www.bleepingcomputer.com/news/security/claude-code-leak-used-to-push-infostealer-malware-on-github/)
- [The Register: Fake downloads delivered malware](https://www.theregister.com/2026/04/02/trojanized_claude_code_leak_github/)
- [Trend Micro: Weaponizing Trust Signals](https://www.trendmicro.com/de_de/research/26/d/weaponizing-trust-claude-code-lures-and-github-release-payloads.html)
- [Coder: Supply Chain Security Lessons](https://coder.com/blog/what-the-claude-code-leak-tells-us-about-supply-chain-security)

### 프라이버시

- [Scientific American: tracking user frustration](https://www.scientificamerican.com/article/anthropic-leak-reveals-claude-code-tracking-user-frustration-and-raises-new/)
- [The Register: extent of system access](https://www.theregister.com/2026/04/01/claude_code_source_leak_privacy_nightmare/)

### 전체 카탈로그

더 많은 분석 블로그 링크는 → [05-source-catalog.md](./05-source-catalog.md) 참조
