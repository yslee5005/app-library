# Deep Dive: 소스 유출 사건 타임라인 & 산업 영향

> 작성일: 2026-04-04
> 원본 소스: 2026-03-31 npm 소스맵 유출 (v2.1.88) 기반 커뮤니티 분석 종합

---

## TL;DR

2026년 3월 31일, Anthropic의 Claude Code v2.1.88이 npm에 배포되면서 **59.8MB 소스맵 파일**이 포함되어 **512,000줄의 전체 TypeScript 소스코드**가 유출되었다. 수 시간 만에 GitHub에서 **가장 빠르게 성장한 레포** 기록을 세웠고, Python/Rust 클린룸 재작성이 이루어졌으며, 동시에 멀웨어 공급망 공격이 발생했다. 이 사건은 AI 에이전트 보안, 빌드 파이프라인 관리, 그리고 오픈소스 생태계에 광범위한 영향을 미쳤다.

**핵심 키워드**: npm 소스맵, Bun 버그, .npmignore, Chaofan Shou, Claw Code, DMCA, 공급망 공격, 엔터프라이즈 보안

---

## 목차

1. [사건 타임라인](#1-사건-타임라인)
2. [유출 원인 분석](#2-유출-원인-분석)
3. [유출 규모 & 구성](#3-유출-규모--구성)
4. [커뮤니티 반응 & Claw Code](#4-커뮤니티-반응--claw-code)
5. [Anthropic의 대응](#5-anthropic의-대응)
6. [산업 영향 & 교훈](#6-산업-영향--교훈)
7. [엔터프라이즈 보안 액션 플랜](#7-엔터프라이즈-보안-액션-플랜)
8. [향후 전망](#8-향후-전망)
9. [참고 블로그 & 소스](#9-참고-블로그--소스)

---

## 1. 사건 타임라인

### 1.1 상세 타임라인

```
2026-03-11     Bun 버그 #28001 보고
               (소스맵이 프로덕션 빌드에서도 생성되는 버그)
               ↓ 20일간 미수정

2026-03-26     Anthropic CMS 오류 → Mythos 모델 관련 드래프트 블로그 유출
               (첫 번째 보안 사고)

2026-03-30     Claude Code v2.1.88 npm 배포
  ~24:00 UTC   59.8MB 소스맵 파일 포함

2026-03-31
  00:21 UTC    악성 axios 1.14.1 / 0.30.4 npm 배포 (별개 사건)
  03:29 UTC    악성 axios 패키지 제거
  ~04:00 UTC   Chaofan Shou (@Fried_rice) 유출 발견
  04:23 ET     X (Twitter)에 게시 → 16M+ 조회수
  ~06:00 UTC   GitHub 미러 레포 생성 시작
  ~08:00 UTC   claw-code 레포 생성 (Sigrid Jin, Python 재작성)
  ~10:00 UTC   claw-code 30,000 스타 돌파
  ~12:00 UTC   claw-code 50,000 스타 (2시간 만에)
  ~18:00 UTC   Anthropic npm 패키지 패치

2026-04-01
               claw-code 100,000+ 스타 (GitHub 역사상 최고속)
               GitHub DMCA 삭제 시작 → 8,100+ 레포 제거
               Adversa AI, CC-643 취약점 발견

2026-04-02
               가짜 Claude Code 소스 → 멀웨어 배포 발견
               (Vidar 인포스틸러, GhostSocks RAT)
```

### 1.2 5일 만에 2번의 유출

| 날짜 | 사건 | 원인 |
|------|------|------|
| 3/26 | Mythos 모델 블로그 유출 | CMS 설정 오류 |
| 3/31 | Claude Code 소스 유출 | npm 패키징 오류 |

> Fortune: "Anthropic marketing itself as the safety-first AI lab had experienced back-to-back operational security failures."

---

## 2. 유출 원인 분석

### 2.1 직접 원인

```
.npmignore에 *.map 미포함
  │
  └── 또는 package.json의 files 필드에서 .map 미제외
       │
       └── Bun 빌드 시스템이 기본으로 소스맵 생성
            │
            └── 59.8MB .map 파일이 npm 패키지에 포함
                 │
                 └── .map 파일이 R2 버킷의 원본 TypeScript 소스를 가리킴
```

### 2.2 Bun 버그 (#28001)

- **보고일**: 2026-03-11
- **내용**: 프로덕션 빌드에서도 소스맵이 생성됨 (문서와 불일치)
- **상태**: 유출 시점에 20일간 미수정
- **의미**: Anthropic이 인수한 Bun의 자체 버그가 원인

### 2.3 재발 사건

> "This is the second time this has happened. In February 2025, an early version of Claude Code had the exact same issue."

13개월 전에도 동일한 경로로 유출. 동일한 실수 반복.

---

## 3. 유출 규모 & 구성

### 3.1 코드베이스 통계

| 항목 | 수치 |
|------|------|
| 총 줄 수 | ~512,000줄 |
| 파일 수 | 1,906개 |
| 소스맵 크기 | 59.8MB |
| 언어 | TypeScript |
| 핵심 파일 | QueryEngine.ts (46,000줄) |
| 도구 정의 | 베이스 29,000줄 |
| 도구 수 | 46+개 |
| 피처 플래그 | 44개 (주요) / 108개 (전체) |
| 번들 크기 | 785KB (엔트리포인트) |
| Bash 보안 검증 | 2,500줄 (23단계) |
| 프롬프트 캐시 break vectors | 14개 추적 |
| 텔레메트리 이벤트 타입 | 1,000+ |
| 스피너 동사 | 187개 |
| 이벤트 훅 | 25+ |
| 일일 낭비 API 호출 (패치 전) | ~250,000 (autocompact 실패) |

### 3.2 유출되지 않은 것

| 항목 | 유출 여부 |
|------|----------|
| 고객 데이터 | X |
| 모델 가중치 | X |
| API 키/자격증명 | X |
| 서버 사이드 코드 | X (클라이언트 하니스만) |
| 사용자 대화 기록 | X |

---

## 4. 커뮤니티 반응 & Claw Code

### 4.1 Claw Code

| 항목 | 내용 |
|------|------|
| **제작자** | Sigrid Jin (@instructkr), 한국계 개발자 |
| **언어** | Python → Rust 재작성 |
| **방식** | 클린룸 재구현 (원본 소스 미사용) |
| **GitHub 스타** | 100,000+ (역대 최고속) |
| **법적 검증** | 독립 코드 감사: Anthropic 소유 코드 0% |

### 4.2 플랫폼별 반응

| 플랫폼 | 반응 |
|--------|------|
| **X (Twitter)** | Chaofan Shou 원본 포스트 16M+ 조회, Theo Browne: "AI 시대 최대 삽질" |
| **Hacker News** | 다수의 스레드, DRM 해시/anti-distillation 중심 기술 토론 |
| **Reddit r/LocalLLaMA** | 3,700+ 업보트, 로컬 LLM으로 유사 시스템 구축 논의 |
| **Reddit r/ClaudeAI** | 1,800+ 업보트, 토큰 드레인 문제 발견/패치 |
| **Medium** | 10+ 분석 글 |
| **DEV.to** | 10+ 분석 글 |
| **Substack** | 6+ 분석 글 |
| **한국 커뮤니티** | GeekNews, Velog, 위키독스, Threads 등에서 활발한 분석 |

### 4.3 파생 프로젝트

- **claurst**: Rust 재작성 (Kuberwastaken)
- **다수 Python/Rust 포트**: 유출 후 수십 개 프로젝트 생성
- **claude-code-docs**: 한국어 문서 프로젝트 (seilk)

---

## 5. Anthropic의 대응

### 5.1 공식 성명

> "No sensitive customer data or credentials were involved or exposed. This was a release packaging issue caused by human error, not a security breach."

### 5.2 조치

1. npm 패키지 패치 (소스맵 제거)
2. GitHub DMCA 삭제 요청 → 8,100+ 레포 제거
3. 재발 방지 조치 진행 중 (구체적 미공개)

### 5.3 논란

> Futurism: "Anthropic Suddenly Cares Intensely About Intellectual Property After Realizing With Horror That It Accidentally Leaked Claude's Source Code"

- AI 학습 데이터 수집 vs 자사 IP 보호의 이중 잣대 비판
- 해고 없음 (36Kr 보도)

---

## 6. 산업 영향 & 교훈

### 6.1 16가지 프로덕션 AI 시스템 구축 교훈

[Analytics Vidhya의 분석](https://www.analyticsvidhya.com/blog/2026/04/claude-code-leak-insights-for-ai-builders/)에서 정리한 핵심 교훈:

1. **CLI도 완전한 자율 시스템이 될 수 있다** — Claude Code는 얇은 래퍼가 아니라 40+ 도구, 멀티 에이전트, 메모리를 갖춘 풀 에이전트 플랫폼
2. **도구는 모듈형, 안전한 빌딩 블록으로 설계** — 공통 팩토리가 안전 속성 강제, 검사 우회 불가
3. **실행은 직접 행동이 아닌 제어된 시스템** — 스키마 검증 → UI 렌더링 → 권한 검사 → 샌드박스 실행 → 구조화된 출력
4. **생각과 행동을 분리** — 계획은 읽기 전용 모드, 사용자 승인 후에만 실행
5. **모델이 실패할 것을 전제로 설계** — 모든 모델 출력을 미검증 정보로 취급, 적대적 에이전트가 오류 테스트
6. **제한적으로 시작하고 명시적으로 완화** — 기본값은 모든 행동에 권한 요청, 사용자가 의식적으로 해제
7. **실패 상태를 적극적으로 예방하고 복구** — 무한 루프, 반복 출력, 과도한 토큰 사용 감지 → 중단 → 클린 체크포인트에서 재시작
8. **메모리는 구조화하고 자동 유지** — 4계층 메모리: 컨텍스트, 세션, 팀, 장기 DB
9. **메모리 품질을 지속적으로 최적화** — 백그라운드에서 그룹화, 중복 제거, 압축, 재평가
10. **체감 성능을 최적화** — 무거운 초기화 지연, 병렬 처리, 즉시 UI 렌더, 400ms 내 상호작용
11. **비용과 시스템 풋프린트를 사전 제어** — 실행 전 토큰 예산 검사, 미사용 도구 트리쉐이킹
12. **투명성이 자율 시스템의 신뢰를 구축** — 토큰 스트림으로 실행 상태 지속 표시
13. **실패를 경험의 일부로 설계** — 복구 지침 제공, 원인 설명, 내부 상태 보존
14. **멀티 에이전트는 기능이 아닌 아키텍처 결정** — Day 1부터 설계, 후속 추가 시 레이스 컨디션 발생
15. **병렬성보다 오케스트레이션이 중요** — 태스크 분해, 범위 지정 컨텍스트, 검증 체인
16. **독립적으로 행동할 때를 아는 시스템 구축** — 사용자 있을 때 협업, 헤드리스 시 자율 동작

### 6.2 에이전트 아키텍처의 표준화

> "This is the first complete, production-grade AI Agent architecture reference. Like Android's open-sourcing, it could catalyze ecosystem development."

유출된 아키텍처가 사실상 **AI 에이전트 아키텍처의 레퍼런스 구현**이 됨.

---

## 7. 엔터프라이즈 보안 액션 플랜

[VentureBeat 보도](https://venturebeat.com/security/claude-code-512000-line-source-leak-attack-paths-audit-security-leaders) 기반 **즉시 실행 5가지 액션**:

### 7.1 AI 공급망 감사

- AI 도구 의존성 전수 조사
- 패키지 출처 및 권한 검증

### 7.2 에이전트 권한 리뷰

- 파일 시스템, 터미널, 네트워크 접근 범위 점검
- 최소 권한 원칙 적용

### 7.3 CLAUDE.md 보안

- 악성 CLAUDE.md를 통한 프롬프트 주입 방어
- 코드 리뷰에 CLAUDE.md 변경 포함

### 7.4 텔레메트리 정책 수립

- AI 도구의 데이터 수집 범위 파악
- 기업 데이터 유출 리스크 평가

### 7.5 인시던트 대응 계획

- AI 도구 기반 공급망 공격 시나리오 추가
- 비상 차단 절차 수립

---

## 8. 향후 전망

### 8.1 긍정적 영향

- AI 에이전트 아키텍처 연구 가속화
- 보안 커뮤니티의 AI 도구 검증 강화
- 오픈소스 대안 생태계 (Claw Code 등) 성장

### 8.2 부정적 영향

- Anthropic 신뢰도 타격 ("safety-first" 이미지)
- 공격자에게 정확한 공격 표면 제공
- 프롬프트 주입 공격의 정밀도 향상

### 8.3 주목할 만한 커뮤니티 인용

> "If a tool is willing to conceal its own identity in commits, what else is it willing to conceal?" — HN 최다 추천 댓글

> "Nothing says 'agentic future' like shipping the source by accident." — 바이럴 댓글

> "The multi-agent orchestration fitting in a prompt makes LangChain and LangGraph look like solutions in search of a problem." — HN 커뮤니티

> **Gergely Orosz** (The Pragmatic Engineer): Anthropic의 법적 딜레마 지적 — 클린룸 재작성이 저작권 침해라 주장하면, 자사 학습 데이터 관련 공정 이용 방어가 약해짐

### 8.4 Claude Code ARR

> "Claude Code alone has achieved an annualized recurring revenue (ARR) of $2.5 billion, a figure that has more than doubled since the beginning of the year."

상업적으로 매우 성공적이며, 유출에도 불구하고 성장세 지속.

---

## 9. 참고 블로그 & 소스

### 타임라인 & 종합 보도

- [Kilo Blog: Source Leak Timeline](https://blog.kilo.ai/p/claude-code-source-leak-a-timeline)
- [VentureBeat: here's what we know](https://venturebeat.com/technology/claude-codes-source-code-appears-to-have-leaked-heres-what-we-know)
- [Fortune: second major security breach](https://fortune.com/2026/03/31/anthropic-source-code-claude-code-data-leak-second-security-lapse-days-after-accidentally-revealing-mythos/)
- [The Hacker News: npm Packaging Error](https://thehackernews.com/2026/04/claude-code-tleaked-via-npm-packaging.html)
- [Decrypt: Internet Is Keeping It Forever](https://decrypt.co/362917/anthropic-accidentally-leaked-claude-code-source-internet-keeping-forever)
- [Layer5: 512,000 Lines, a Missing .npmignore](https://layer5.io/blog/engineering/the-claude-code-source-leak-512000-lines-a-missing-npmignore-and-the-fastest-growing-repo-in-github-history/)
- [Latent Space: AINews](https://www.latent.space/p/ainews-the-claude-code-source-leak)

### Claw Code & 파생

- [Claw Code 공식](https://claw-code.codes/)
- [WaveSpeedAI: What Is Claw Code?](https://wavespeed.ai/blog/posts/what-is-claw-code/)
- [CyberNews: Fastest Growing Repo](https://cybernews.com/tech/claude-code-leak-spawns-fastest-github-repo/)

### 엔터프라이즈 & 교훈

- [VentureBeat: 5 Actions for Security Leaders](https://venturebeat.com/security/claude-code-512000-line-source-leak-attack-paths-audit-security-leaders)
- [Beam AI: Enterprise AI Agent Security](https://beam.ai/agentic-insights/what-the-claude-code-leak-tells-us-about-enterprise-ai-agent-security)
- [Analytics Vidhya: 16 Lessons](https://www.analyticsvidhya.com/blog/2026/04/claude-code-leak-insights-for-ai-builders/)
- [Coder: Supply Chain Security](https://coder.com/blog/what-the-claude-code-leak-tells-us-about-supply-chain-security)

### 한국어 보도

- [보안뉴스: 51만줄 유출](https://m.boannews.com/html/detail.html?idx=142963)
- [디지털투데이: 핵심 기술 외부 공개](https://www.digitaltoday.co.kr/news/articleView.html?idxno=651740)
- [AI타임스: 소스 코드 유출](https://www.aitimes.com/news/articleView.html?idxno=208649)
- [위키독스: 오픈소스 하니스 엔진 탄생](https://wikidocs.net/blog/@jaehong/10418/)

### 전체 카탈로그

더 많은 분석 블로그 링크는 → [05-source-catalog.md](./05-source-catalog.md) 참조
