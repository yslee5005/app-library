# Claude Code 소스 유출 분석 블로그 카탈로그

> 2026년 3월 31일, Anthropic이 Claude Code v2.1.88 npm 패키지에 59.8MB 소스맵 파일을 실수로 포함시켜
> 512,000줄의 TypeScript 소스코드(1,906개 파일)가 전체 유출된 사건 이후 생산된 분석 글 모음.
>
> 수집일: 2026-04-04 | 총 수집: 약 200+ 링크

---

## 카테고리 목차

1. [A. 아키텍처 & 내부 구조 분석](#a-아키텍처--내부-구조-분석)
2. [B. 숨겨진 기능 (KAIROS, BUDDY, 피처 플래그)](#b-숨겨진-기능-kairos-buddy-피처-플래그)
3. [C. 보안 분석 & 취약점](#c-보안-분석--취약점)
4. [D. 시스템 프롬프트 & 권한 시스템](#d-시스템-프롬프트--권한-시스템)
5. [E. Anti-Distillation & 텔레메트리](#e-anti-distillation--텔레메트리)
6. [F. 사건 타임라인 & 뉴스 보도](#f-사건-타임라인--뉴스-보도)
7. [G. 오피니언 & 논평](#g-오피니언--논평)
8. [H. 오픈소스 파생 프로젝트](#h-오픈소스-파생-프로젝트)
9. [I. 엔터프라이즈 & 교훈](#i-엔터프라이즈--교훈)
10. [J. 한국어 분석](#j-한국어-분석)
11. [K. 커뮤니티 토론 (HN, Reddit, X)](#k-커뮤니티-토론-hn-reddit-x)
12. [L. 멀웨어 & 공급망 공격](#l-멀웨어--공급망-공격)
13. [M. 모델 코드네임 & 미출시 기능](#m-모델-코드네임--미출시-기능)

---

## A. 아키텍처 & 내부 구조 분석

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 1 | [Everyone Analyzed Claude Code's Features. Nobody Analyzed Its Architecture](https://medium.com/data-science-collective/everyone-analyzed-claude-codes-features-nobody-analyzed-its-architecture-1173470ab622) | Medium (Han HELOIR YAN, Ph.D.) | Int32Array 기반 ASCII 문자풀, bitmask 스타일 메타데이터, 50x stringWidth 호출 감소 |
| 2 | [Claude Code architecture Deep Dive: What the Leaked Source Reveals](https://wavespeed.ai/blog/posts/claude-code-architecture-leaked-source-deep-dive/) | WaveSpeedAI | QueryEngine.ts 46,000줄, 베이스 도구 29,000줄, 40+ 도구 플러그인 |
| 3 | [Claude Code Agent Harness Architecture: Key Insights](https://wavespeed.ai/blog/posts/claude-code-agent-harness-architecture/) | WaveSpeedAI | 하니스 아키텍처 패턴, 도구 팩토리, 안전 속성 강제 |
| 4 | [Claude Code Source Leak: 7 Agent Architecture Lessons](https://particula.tech/blog/claude-code-source-leak-agent-architecture-lessons) | Particula Tech | 7가지 에이전트 아키텍처 설계 교훈 |
| 5 | [Claude Code Leak: Agentic Architecture Lessons 2026](https://www.digitalapplied.com/blog/claude-code-leak-agentic-architecture-lessons-2026) | Digital Applied | 에이전틱 아키텍처 실전 교훈 |
| 6 | [Claude Code Leak: 16 Lessons on Building Production-Ready AI Systems](https://www.analyticsvidhya.com/blog/2026/04/claude-code-leak-insights-for-ai-builders/) | Analytics Vidhya | 프로덕션 AI 시스템 구축 16가지 교훈 |
| 7 | [The Claude Code Leak Just Gave Every Developer a Masterclass in AI Agent Orchestration](https://dev.to/iraycd/the-claude-code-leak-just-gave-every-developer-a-masterclass-in-ai-agent-orchestration-1km6) | DEV.to | AI 에이전트 오케스트레이션 마스터클래스 |
| 8 | [I Analyzed Claude Code's Leaked Source — Here's How Anthropic's AI Agent Actually Works](https://dev.to/comeonoliver/i-analyzed-claude-codes-leaked-source-heres-how-anthropics-ai-agent-actually-works-2bik) | DEV.to | 에이전트 실제 작동 방식 분석 |
| 9 | [What Claude Code's Leaked Architecture Reveals About Building Production MCP Servers](https://dev.to/shekharp1536/what-claude-codes-leaked-architecture-reveals-about-building-production-mcp-servers-2026-10on) | DEV.to | MCP 서버 구축 아키텍처 인사이트 |
| 10 | [Diving into Claude Code's Source Code Leak](https://read.engineerscodex.com/p/diving-into-claude-codes-source-code) | Engineer's Codex | 소스코드 구조 종합 분석 |
| 11 | [Claude Code Compaction: How Context Compression Works](https://okhlopkov.com/claude-code-compaction-explained/) | Okhlopkov | MicroCompact → AutoCompact 4단계 컨텍스트 압축 파이프라인 |
| 12 | [Claude Code Source Leak: Everything Found (2026)](https://claudefa.st/blog/guide/mechanics/claude-code-source-leak) | ClaudeFast | 전체 발견 사항 종합 정리 |
| 13 | [Claude Code Fully Leaked: Insights from 512K Lines](https://www.cloudmagazin.com/en/2026/04/01/claude-source-code-leak-reveals-ai-agent-architecture/) | Cloud Magazin | 512K줄 AI 에이전트 아키텍처 인사이트 |
| 14 | [Claude Code source leak via npm: what the code reveals](https://www.sourcetrail.com/javascript/claude-code-source-leak-via-npm-what-really-happened-and-why-it-matters/) | SourceTrail | npm 유출 원인 기술 분석 |
| 15 | [512,000 Lines, a Missing .npmignore, and the Fastest-Growing Repo](https://layer5.io/blog/engineering/the-claude-code-source-leak-512000-lines-a-missing-npmignore-and-the-fastest-growing-repo-in-github-history/) | Layer5 | .npmignore 누락 원인, GitHub 최고속 레포 |
| 16 | [Claude Code Unpacked: A visual guide](https://news.ycombinator.com/item?id=47597085) | Hacker News | 시각적 아키텍처 가이드 |
| 17 | [Claude Code 내부 아키텍처 분석](https://bits-bytes-nn.github.io/insights/agentic-ai/2026/03/31/claude-code-source-map-leak-analysis.html) | Bits & Bytes | 내부 아키텍처 기술 분석 |

## B. 숨겨진 기능 (KAIROS, BUDDY, 피처 플래그)

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 18 | [Claude Code Leaked Source: BUDDY, KAIROS & Every Hidden Feature Inside](https://wavespeed.ai/blog/posts/claude-code-leaked-source-hidden-features/) | WaveSpeedAI | BUDDY 18종, KAIROS 데몬, 44개 피처 플래그 전수 |
| 19 | [Claude Code Source Code Leak: 8 Hidden Features You Can Use Right Now](https://www.mindstudio.ai/blog/claude-code-source-code-leak-8-hidden-features) | MindStudio | 당장 사용 가능한 8개 숨겨진 기능 |
| 20 | [Inside Claude Code's leaked source: swarms, daemons, and 44 features](https://thenewstack.io/claude-code-source-leak/) | The New Stack | Swarm, Daemon, 44개 피처 플래그 |
| 21 | [Controversial, hidden, or upcoming features discovered in leaked Claude Code](https://cybernews.com/security/anthropic-claude-source-code-discovered-features/) | CyberNews | 논란이 된 미공개 기능 분석 |
| 22 | [Claude Code Never Sleeps — Inside KAIROS and autoDream](https://theplanettools.ai/blog/claude-code-kairos-autodream-ai-never-sleeps) | ThePlanetTools | KAIROS autoDream 메모리 통합 시스템 |
| 23 | [Claude Code Leak Reveals Always-On 'Kairos' Agent](https://www.theinformation.com/newsletters/ai-agenda/claude-code-leak-reveals-always-kairos-agent) | The Information | KAIROS 상시 에이전트 |
| 24 | [Claude Code npm Source Map Leak: Inside KAIROS, Daemon Mode, and Unreleased Models](https://claudelab.net/en/articles/claude-code/claude-code-sourcemap-kairos-internal-architecture) | Claude Lab | KAIROS 150+ 참조, 데몬 모드 |
| 25 | [Leaked Claude Code Shows Anthropic Building Mysterious "Tamagotchi" Feature](https://futurism.com/artificial-intelligence/leaked-claude-code-tamagotchi) | Futurism | BUDDY 타마고치 시스템 |
| 26 | [Claude Buddy: Anthropic April Fools Terminal Tamagotchi](https://claudefa.st/blog/guide/mechanics/claude-buddy) | ClaudeFast | BUDDY 18종 가챠 시스템 상세 |
| 27 | ['Always-on agent' and AI pet 'Buddy': Hidden features found](https://www.theweek.in/news/sci-tech/2026/04/01/always-on-agent-and-ai-pet-buddy-anthropics-claude-source-code-leak-reveals-hidden-features.html) | The Week | KAIROS + BUDDY 요약 |
| 28 | [I Did Claude Code Source Code Leak Full Review (And Found 3 Features You Might Miss)](https://medium.com/@joe.njenga/i-did-claude-code-source-code-leak-full-review-and-found-3-features-you-might-miss-9ce94addc895) | Medium (Joe Njenga) | 놓치기 쉬운 3가지 기능 |
| 29 | [Claude Code Source code leak Interesting Insights](https://medium.com/data-science-in-your-pocket/claude-code-source-code-leak-interesting-insights-0b0b88e6ac56) | Medium (Mehul Gupta) | 흥미로운 인사이트 모음 |
| 30 | [Anthropic's Massive 512K-Line Leak: Uncovering Claude's Secret AI Roadmap](https://mindwiredai.com/2026/04/01/anthropic-claude-code-source-leak-hidden-features/) | MindWired AI | 비밀 AI 로드맵 분석 |

## C. 보안 분석 & 취약점

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 31 | [Critical Vulnerability in Claude Code Emerges Days After Source Leak](https://www.securityweek.com/critical-vulnerability-in-claude-code-emerges-days-after-source-leak/) | SecurityWeek | CC-643 권한 바이패스 취약점 |
| 32 | [Anthropic Claude Code Leak (ThreatLabz Analysis)](https://www.zscaler.com/blogs/security-research/anthropic-claude-code-leak) | Zscaler ThreatLabz | 보안 위협 상세 분석 |
| 33 | [Claude Code Source Leak: With Great Agency Comes Great Responsibility](https://www.straiker.ai/blog/claude-code-source-leak-with-great-agency-comes-great-responsibility) | Straiker | 에이전시와 보안 책임 |
| 34 | [Claude Code Source Map Leak: What Was Exposed and What It Means](https://www.penligent.ai/hackinglabs/claude-code-source-map-leak-what-was-exposed-and-what-it-means/) | Penligent AI | 유출 범위 및 의미 분석 |
| 35 | [Claude Code Leak 2026: 512,000 Lines Exposed, Critical Vulnerability Found](https://aitoolanalysis.com/claude-code-leak/) | AI Tool Analysis | 취약점 발견 상세 |
| 36 | [Claude Code's Source Code Just Leaked. Here's What Security Teams Should Do Now](https://repello.ai/blog/claude-code-source-code-leak) | Repello AI | 보안팀 대응 가이드 |
| 37 | [Claude Code security flaw found days after source code leak](https://www.digitaltoday.co.kr/en/view/45085/claude-code-security-flaw-found-days-after-source-code-leak) | Digital Today (EN) | 보안 결함 후속 보도 |
| 38 | [Claude Leaked Source Code: AI Security Impact](https://www.blockchain-council.org/claude-ai/claude-leaked-source-code-ai-security-model-integrity-responsible-disclosure/) | Blockchain Council | AI 보안 영향 분석 |
| 39 | [Claude Source Code Leak Lessons for Web3 Teams](https://www.blockchain-council.org/claude-ai/lessons-from-claude-source-code-leak-web3-crypto-hardening-ai-agents-oracles-devops/) | Blockchain Council | Web3 보안 교훈 |

## D. 시스템 프롬프트 & 권한 시스템

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 40 | [Claude Code System Prompt Leaked: The Full Breakdown](https://aiia.ro/blog/claude-code-system-prompt-leaked/) | Aiia | "가장 정교한 프로덕션 프롬프트" 전체 분석 |
| 41 | [Claude Code's entire system prompt just leaked](https://medium.com/coding-nexus/claude-codes-entire-system-prompt-just-leaked-10d16bb30b87) | Medium (Coding Nexus) | 시스템 프롬프트 전문 분석 |
| 42 | [Claude Code Undercover Mode: What the Leaked Source Actually Reveals](https://wavespeed.ai/blog/posts/claude-code-undercover-mode-leaked-source/) | WaveSpeedAI | Undercover Mode 90줄 상세 |
| 43 | [System Prompts Leaks Repository (Claude Code, GPT-5 등)](https://github.com/asgeirtj/system_prompts_leaks) | GitHub | 다중 AI 시스템 프롬프트 수집 |
| 44 | [Claude Code Source Code Leak: The Full Story 2026](https://www.buildfastwithai.com/blogs/claude-code-source-code-leak-2026) | BuildFastWithAI | 전체 스토리 정리 |
| 45 | [Claude Code Source Code Leak: Everything You Need to Know](https://www.gauraw.com/claude-code-source-code-leak-analysis-2026/) | Kumar Gauraw | 종합 분석 |

## E. Anti-Distillation & 텔레메트리

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 46 | [The Claude Code Source Leak: fake tools, frustration regexes, undercover mode](https://alex000kim.com/posts/2026-03-31-claude-code-source-leak/) | Alex Kim | fake_tools, frustration regex, DRM 해시(cch=b8803) |
| 47 | [Claude Code Source Leak Exposes Anti-Distillation Traps](https://winbuzzer.com/2026/04/01/claude-code-source-leak-anti-distillation-traps-undercover-mode-xcxwbn/) | WinBuzzer | Anti-distillation 트랩 메커니즘 |
| 48 | [Hacker News Dissects the Claude Code Leak and Anti-Distillation Logic](https://insights.marvin-42.com/articles/hacker-news-dissects-the-claude-code-leak-and-the-anti-distillation-logic-behind-it) | Marvin-42 Insights | HN 커뮤니티 Anti-distillation 토론 정리 |
| 49 | [Claude Code Undercover Mode, Killswitches & Telemetry: 6 Hidden Controls](https://decodethefuture.org/en/claude-code-undercover-mode-killswitches-telemetry/) | DecodeFuture | 6개 원격 killswitch, GrowthBook 피처 플래그 |
| 50 | [Claude Code Leak: Anti-Distillation, KAIROS & Memory Architecture (Part 2)](https://www.modemguides.com/blogs/ai-news/claude-code-leak-architecture-analysis) | ModemGuides | Anti-distillation + 자기치유 메모리 |

## F. 사건 타임라인 & 뉴스 보도

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 51 | [Claude Code Source Leak: A Timeline](https://blog.kilo.ai/p/claude-code-source-leak-a-timeline) | Kilo Blog | 시간순 타임라인 |
| 52 | [Claude Code's source code appears to have leaked: here's what we know](https://venturebeat.com/technology/claude-codes-source-code-appears-to-have-leaked-heres-what-we-know) | VentureBeat | 종합 보도 |
| 53 | [Anthropic leaks its own AI coding tool's source code in second major security breach](https://fortune.com/2026/03/31/anthropic-source-code-claude-code-data-leak-second-security-lapse-days-after-accidentally-revealing-mythos/) | Fortune | Mythos 유출에 이은 2차 사고 |
| 54 | [Claude Code Source Leaked via npm Packaging Error, Anthropic Confirms](https://thehackernews.com/2026/04/claude-code-tleaked-via-npm-packaging.html) | The Hacker News | npm 패키징 에러 확인 |
| 55 | [Claude Code's source reveals extent of system access](https://www.theregister.com/2026/04/01/claude_code_source_leak_privacy_nightmare/) | The Register | 시스템 접근 범위 프라이버시 우려 |
| 56 | [Anthropic accidentally exposes Claude Code source code](https://www.theregister.com/2026/03/31/anthropic_claude_code_source_code/) | The Register | 최초 보도 |
| 57 | [Anthropic Accidentally Leaked Claude Code's Source—The Internet Is Keeping It Forever](https://decrypt.co/362917/anthropic-accidentally-leaked-claude-code-source-internet-keeping-forever) | Decrypt | 인터넷 영구 보존 |
| 58 | [Anthropic leak reveals Claude Code tracking user frustration](https://www.scientificamerican.com/article/anthropic-leak-reveals-claude-code-tracking-user-frustration-and-raises-new/) | Scientific American | 사용자 불만 추적 프라이버시 이슈 |
| 59 | [Chinese Dropout Doctor Finds 510,000-line Claude Code Source Code Leak](https://eu.36kr.com/en/p/3750770295898630) | 36Kr | Chaofan Shou 발견 과정 |
| 60 | [Claude Code Source Code Leaked via npm: What You Need to Know](https://www.modemguides.com/blogs/ai-news/claude-code-source-leak-npm-security-2026) | ModemGuides | npm 보안 이슈 |
| 61 | [Anthropic's Claude Code source leaked via npm registry map file](https://piunikaweb.com/2026/03/31/anthropic-claude-code-source-leaked-npm-registry/) | PiunikaWeb | npm 레지스트리 맵 파일 |
| 62 | [BREAKING: Anthropic just leaked Claude Code's entire source code](https://www.the-ai-corner.com/p/claude-code-source-code-leaked-2026) | The AI Corner | 속보 종합 |
| 63 | [Claude Code Source Code Leak: The Full Story 2026](https://www.buildfastwithai.com/blogs/claude-code-source-code-leak-2026) | BuildFastWithAI | 전체 스토리 |
| 64 | [Anthropic Leak Claude Code: 512,000 Lines Exposed by One Bug](https://www.ruh.ai/blogs/anthropic-claude-code-leak-2026-npm-source-exposure) | Ruh AI | 하나의 버그로 51만줄 노출 |
| 65 | [Anthropic Accidentally Leaked Claude Code Source Code](https://www.sovereignmagazine.com/article/anthropic-claude-code-source-code-leak) | Sovereign Magazine | 종합 보도 |

## G. 오피니언 & 논평

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 66 | [The Great Claude Code Leak of 2026: Accident, Incompetence, or Best PR Stunt?](https://dev.to/varshithvhegde/the-great-claude-code-leak-of-2026-accident-incompetence-or-the-best-pr-stunt-in-ai-history-3igm) | DEV.to | 사고 vs PR 스턴트 논��� |
| 67 | [The "Careful" AI Company Just Leaked Their Own Code. Twice.](https://www.smithstephen.com/p/the-careful-ai-company-just-leaked) | Stephen Smith | 안전 AI 기업의 아이러니 |
| 68 | [Anthropic Suddenly Cares Intensely About Intellectual Property](https://futurism.com/artificial-intelligence/anthropic-suddenly-cares-about-intellectual-property-claude-leak) | Futurism | IP 보호 이중 잣대 논란 |
| 69 | [What Claude Code's Source Leak Actually Reveals](https://medium.com/@marc.bara.iniesta/what-claude-codes-source-leak-actually-reveals-e571188ecb81) | Medium (Marc Bara) | 진짜 중요한 것은 무엇인지 |
| 70 | [The Claude Code Leak: Lessons Worth Keeping](https://keithmanaloto.medium.com/the-claude-code-leak-lessons-worth-keeping-8a816bce8a45) | Medium (Keith Manaloto) | 지속적 교훈 |
| 71 | [Anthropic's Accidental Confession: What the Claude Code Leak Reveals About AI Tools Running Your Business](https://cioinsights.substack.com/p/anthropics-accidental-confession) | CIO Insights (Substack) | 엔터프라이즈 AI 도구 신뢰 문제 |
| 72 | [[AINews] The Claude Code Source Leak](https://www.latent.space/p/ainews-the-claude-code-source-leak) | Latent Space | AI 뉴스 종합 분석 |
| 73 | [The Claude Code Leak: A Mini Brief](https://actionablenotes.substack.com/p/the-claude-code-leak-a-mini-brief) | Actionable Notes (Substack) | 핵심 요약 브리프 |
| 74 | [Claude Code's Secrets Revealed](https://patmcguinness.substack.com/p/claude-codes-secrets-revealed) | Patrick McGuinness (Substack) | 비밀 기능 공개 |
| 75 | [What the Claude Code Leak Tells Us About the AI Tools Running Your Business](https://blakecrosley.com/blog/claude-code-source-leak) | Blake Crosley | AI 도구 비즈니스 영향 |

## H. 오픈소스 파생 프로젝트

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 76 | [Claw Code — Open-Source AI Coding Agent Framework](https://claw-code.codes/) | Claw Code 공식 | 클린룸 재작성 공식 사이트 |
| 77 | [GitHub: claw-code (100K+ Stars)](https://github.com/instructkr/claw-code) | GitHub | GitHub 역사상 최고속 10만 스타 |
| 78 | [What Is Claw Code? The Claude Code Rewrite Explained](https://wavespeed.ai/blog/posts/what-is-claw-code/) | WaveSpeedAI | Claw Code 배경 설명 |
| 79 | [Anthropic leaked the source code of Claude Code (TS), but it was immediately rewritten in Python](https://dev.to/embernoglow/anthropic-leaked-the-source-code-of-claude-code-written-in-ts-but-it-was-immediately-rewritten-in-210l) | DEV.to | Python 재작성 이야기 |
| 80 | [Developers Race to Build Rust Ports After Claude Code Source Leak](https://www.prismnews.com/hobbies/rust-programming/developers-race-to-build-rust-ports-after-claude-code) | Prism News | Rust 포트 경쟁 |
| 81 | [Leaked Claude Code source spawns fastest growing repo in GitHub's history](https://cybernews.com/tech/claude-code-leak-spawns-fastest-github-repo/) | CyberNews | GitHub 최고속 레포 성장 |
| 82 | [Claude Code Source Code "Rebranded" Amid Wild Web Cloning](https://eu.36kr.com/en/p/3747613304193796) | 36Kr | 리브랜딩 & 클로닝 현상 |
| 83 | [GitHub: claurst - Terminal Coding Agent in Rust + Leak Breakdown](https://github.com/Kuberwastaken/claurst) | GitHub (Kuberwastaken) | Rust 재작성 + 유출 분석 |
| 84 | [GitHub: claude-code (Open Source Mirror)](https://github.com/yasasbanukaofficial/claude-code) | GitHub | 오픈소스 미러 |
| 85 | [Where is Claude Code Leaked Source Code?](https://medium.com/data-science-in-your-pocket/where-is-claude-code-leaked-source-code-9a5b1d00cd2a) | Medium (Mehul Gupta) | 소스코드 찾기 가이드 |

## I. 엔터프라이즈 & 교���

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 86 | [What the Claude Code Leak Means for Enterprise AI](https://beam.ai/agentic-insights/what-the-claude-code-leak-tells-us-about-enterprise-ai-agent-security) | Beam AI | 엔터프라이즈 AI 에이전트 보안 |
| 87 | [5 Actions Enterprise Security Leaders Should Take Now](https://venturebeat.com/security/claude-code-512000-line-source-leak-attack-paths-audit-security-leaders) | VentureBeat | 보안 리더 5가지 즉시 액션 |
| 88 | [What the Claude Code Leak Tells Us About Supply Chain Security](https://coder.com/blog/what-the-claude-code-leak-tells-us-about-supply-chain-security) | Coder | 공급망 보안 교훈 |
| 89 | [Cointegrity Exclusive: Anthropic's Claude Code Leak Exposes the Future of AI Agents](https://cointegrity.substack.com/p/cointegrity-exclusive-anthropics) | Cointegrity (Substack) | AI 에이전트 미래 전망 |
| 90 | [Claude Code Leak Reveals Architecture, Commands, Memory & More](https://www.geeky-gadgets.com/claude-code-leak/) | Geeky Gadgets | 아키텍처, 명령어, 메모리 종합 |
| 91 | [Claude Code Source Leak 2026: The Complete Guide to What Was Exposed](https://decodethefuture.org/en/claude-code-source-leak-complete-guide/) | DecodeFuture | 유출 완전 가이드 |
| 92 | [Interpretation of the Claude Code source code leak: What will happen to the AI Agent industry?](https://help.apiyi.com/en/claude-code-source-leak-march-2026-impact-ai-agent-industry-en.html) | Apiyi | AI 에이전트 산업 영향 |
| 93 | [Claude Code Leak Weaponized With Malware in Security Crisis](https://www.techbuzz.ai/articles/claude-code-leak-weaponized-with-malware-in-security-crisis) | TechBuzz AI | 보안 위기 무기화 |
| 94 | [Weaponizing Trust Signals: Claude Code Lures and GitHub Release Payloads](https://www.trendmicro.com/de_de/research/26/d/weaponizing-trust-claude-code-lures-and-github-release-payloads.html) | Trend Micro | 신뢰 신호 악용 분석 |

## J. 한국어 분석

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 95 | [Claude Code 소스 유출, 그리고 하룻밤 만에 탄생한 오픈소스 하니스 엔진](https://wikidocs.net/blog/@jaehong/10418/) | 위키독스 (박재홍) | Claw Code 탄생 과정 |
| 96 | [별첨 91. 클로드 코드 소스 코드 분석서](https://wikidocs.net/338204) | 위키독스 | 소스코드 분석서 |
| 97 | [클로드 코드 소스코드 유출 — 상위 1% 유저의 사용법은?](https://blog.chatdaeri.com/claude-code-leak-and-automation-tips/) | ChatDaeri | 상위 1% 활용 팁 |
| 98 | [Claude Code 소스코드 유출, 숨겨진 정보 대공개](https://eopla.net/magazines/41009) | Eopla | 숨겨진 정보 종합 |
| 99 | [Claude Code 소스코드가 통째로 유출됐다](https://velog.io/@dbwls/Claude-Code-%EC%86%8C%EC%8A%A4%EC%BD%94%EB%93%9C%EA%B0%80-%ED%86%B5%EC%A7%B8%EB%A1%9C-%EC%9C%A0%EC%B6%9C%EB%90%90%EB%8B%A4) | Velog | 유출 사건 정리 |
| 100 | [유출된 클로드 코드 인사이트 정리 — 원문 + 쉬운말 + 단어정리](https://velog.io/@pospara9356/%EC%9C%A0%EC%B6%9C%EB%90%9C-%ED%81%B4%EB%A1%9C%EB%93%9C-%EC%BD%94%EB%93%9C-%EC%9D%B8%EC%82%AC%EC%9D%B4%ED%8A%B8-%EC%A0%95%EB%A6%AC-26.03-%EC%9B%90%EB%AC%B8-%EC%89%AC%EC%9A%B4%EB%A7%90-%EB%8B%A8%EC%96%B4%EC%A0%95%EB%A6%AC) | Velog | 쉬운말 인사이트 정리 |
| 101 | [Claude Code 소스 유출: BUDDY, KAIROS 및 숨겨진 모든 기능 완전 해부](https://wavespeed.ai/blog/ko/posts/claude-code-leaked-source-hidden-features/) | WaveSpeedAI (KO) | BUDDY, KAIROS 한국어 분석 |
| 102 | [클로드 코드 유출: AI 코딩 도구 아키텍처 심층 분석](https://apidog.com/kr/blog/claude-code-source-leak-analysis/) | Apidog (KR) | 아키텍처 심층 분석 |
| 103 | [앤트로픽, 실수로 '클로드코드' 소스코드 유출...메모리 아키텍처 등 핵심 기술 외부 공개](https://www.digitaltoday.co.kr/news/articleView.html?idxno=651740) | 디지털투데이 | 뉴스 보도 |
| 104 | [앤트로픽 '클로드 코드' 소스 51만줄 유출..."해킹 아닌 직원 실수"](https://m.boannews.com/html/detail.html?idx=142963) | 보안뉴스 | 보안 뉴스 보도 |
| 105 | [앤트로픽, 내부 실수로 '클로드 코드' 소스 코드 유출](https://www.aitimes.com/news/articleView.html?idxno=208649) | AI타임스 | AI 뉴스 보도 |
| 106 | [엔트로픽 클로드 코드 소스 유출로 드러난 미공개 기능들](https://www.digitalfocus.news/news/articleView.html?idxno=19820) | 디지털포커스 | 미공개 기능 보도 |
| 107 | [Claude Code CLI 50만 줄 소스코드 NPM 패키지 유출 사고의 전모는?](https://blog.ai.dmomo.co.kr/tech/23160) | IT AI Totality | 사고 전모 분석 |
| 108 | [GeekNews: claw-code - Claude Code 유출 소스 기반 Python 클린룸 재작성 프로젝트](https://x.com/GeekNewsHada/status/2039136960057589857) | GeekNews (X) | GeekNews 소개 |
| 109 | [속보) 클로드 코드 소스코드 유출](https://www.threads.com/@choi.openai/post/DWi95RID9gA/) | Threads (@choi.openai) | 속보 + KAIROS/BUDDY 소개 |
| 110 | [GitHub: claude-code-docs (한국어)](https://github.com/seilk/claude-code-docs) | GitHub (seilk) | 한국어 문서 프로젝트 |
| 111 | [클로드 코드(Claude Code) 완벽 정리 — 설치부터 가격까지](https://digi-royal.com/claude-code/) | 디지로얄 | 완벽 정리 가이드 |
| 112 | [Claude - 나무위키](https://namu.wiki/w/Claude) | 나무위키 | 나무위키 문서 업데이트 |

## K. 커뮤니티 토론 (HN, Reddit, X)

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 113 | [HN: The Claude Code Source Leak: fake tools, frustration regexes, undercover mode](https://news.ycombinator.com/item?id=47586778) | Hacker News | Anti-distillation 중심 토론 |
| 114 | [HN: The Claude Code Leak (Layer5)](https://news.ycombinator.com/item?id=47609294) | Hacker News | 종합 토론 |
| 115 | [HN: Claude Code's source has been leaked via npm](https://news.ycombinator.com/item?id=47584540) | Hacker News | 최초 발견 토론 |
| 116 | [HN: Claude Code Unpacked — A visual guide](https://news.ycombinator.com/item?id=47597085) | Hacker News | 시각적 가이드 토론 |
| 117 | [LinkedIn: Claude Code codebase got leaked (Francisco Soto)](https://www.linkedin.com/posts/fransotodev_claude-code-codebase-got-leaked-by-anthropic-activity-7444760360970096640-GuO1) | LinkedIn | 전문가 분석 |

## L. 멀웨어 & 공급망 공격

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 118 | [Fake Claude Code source downloads actually delivered malware](https://www.theregister.com/2026/04/02/trojanized_claude_code_leak_github/) | The Register | 트로이 목마 배포 |
| 119 | [Claude Code leak used to push infostealer malware on GitHub](https://www.bleepingcomputer.com/news/security/claude-code-leak-used-to-push-infostealer-malware-on-github/) | BleepingComputer | Vidar 인포스틸러 |
| 120 | [Claude Code Leak Exploited by Hackers to Deliver Vidar and GhostSocks](https://cyberpress.org/claude-code-leak-exploited-to-deliver-vidar-and-ghostsocks/) | CyberPress | Vidar + GhostSocks RAT |
| 121 | [Claude Code leak leveraged to distribute malware](https://www.scworld.com/brief/claude-code-leak-used-to-distribute-malware) | SC Media | 멀웨어 배포 |
| 122 | [Be careful what you click - hackers use Claude Code leak to push malware](https://www.techradar.com/pro/security/be-careful-what-you-click-hackers-use-claude-code-leak-to-push-malware) | TechRadar | 주의 경고 |
| 123 | [Weaponizing Trust Signals: Claude Code Lures and GitHub Release Payloads](https://www.trendmicro.com/de_de/research/26/d/weaponizing-trust-claude-code-lures-and-github-release-payloads.html) | Trend Micro | 신뢰 신호 무기화 |

## M. 모델 코드네임 & 미출시 기능

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 124 | [Claude Code npm Source Map Leak: Inside KAIROS, Daemon Mode, and Unreleased Models](https://claudelab.net/en/articles/claude-code/claude-code-sourcemap-kairos-internal-architecture) | Claude Lab | Capybara=4.6 변종, Fennec=Opus 4.6, Numbat=테스트 중 |
| 125 | [Full source code for Anthropic's Claude Code leaks](https://cybernews.com/security/anthropic-claude-code-source-leak/) | CyberNews | 미출시 모델 코드네임 |

---

## Substack 모음

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 126 | [Anthropic accidentally leaked Claude Code's entire source. Here's what 512,000 lines reveal](https://linas.substack.com/p/claudecodesource) | Linas (Substack) | 512K줄 전체 분석 |
| 127 | [The Claude Source Code Leak (법률 관점)](https://theinnovationattorney.substack.com/p/the-claude-source-code-leak) | Innovation Attorney | 법률 관점 분석 |
| 128 | [Token Limits "Horror", Leaked Claude Code Source, and More](https://aicodingdaily.substack.com/p/token-limits-horror-leaked-claude) | AI Coding Daily | 토큰 제한 + 유출 |
| 129 | [Claude Code's Entire Source Code Just Leaked. Here's What They Were Hiding.](https://mattpaige68.substack.com/p/claude-codes-entire-source-code-just) | Matt Paige | 숨겨진 것들 |
| 130 | [Claude Code's Source Got Leaked. I Found 60 Repos Before My Coffee Got Cold.](https://ringmast4r.substack.com/p/claude-codes-source-got-leaked-i) | Ringmaster | 60개 레포 발견 과정 |
| 131 | [Claude Code — 512,000 Lines of Source Code Leaked](https://bdnewsweekly.substack.com/p/claude-code-source-code-leaked) | BD News Weekly | 종합 보도 |

---

## Medium 추가 모음

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 132 | [Claude Code's Entire Source Code Was Just Leaked via npm Source Maps — Here's What's Inside](https://medium.com/@anhaia.gabriel/claude-codes-entire-source-code-was-just-leaked-via-npm-source-maps-here-s-what-s-inside-eb9f6a1d5ccb) | Medium (Gabriel Anhaia) | npm 소스맵 전체 분석 |
| 133 | [The Claude Code Leak: 512,000 Lines of TypeScript and What They Reveal](https://medium.com/@analystuttam/the-claude-code-leak-512-000-lines-of-typescript-and-what-they-reveal-76ce148766f1) | Medium (Analyst Uttam) | TypeScript 분석 |
| 134 | [Claude Code Leak](https://medium.com/@onix_react/claude-code-leak-d5871542e6e8) | Medium (Onix React) | 종합 분석 |
| 135 | [The Claude Code Source Leak and GitHub Repository Mirror](https://nayakpplaban.medium.com/the-claude-code-source-leak-and-github-repository-mirror-fb46d4449f9f) | Medium (Plaban Nayak) | GitHub 미러 분석 |
| 136 | [Claude Code's 512,000 Lines of Source Code Leaked](https://medium.com/the-ai-studio/claude-codes-512-000-lines-of-source-code-leaked-49941dfb13a7) | Medium (AI Studio) | 512K줄 분석 |

---

## DEV.to 추가 모음

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 137 | [Claude Code's Entire Source Code Was Just Leaked — Here's What's Inside](https://dev.to/gabrielanhaia/claude-codes-entire-source-code-was-just-leaked-via-npm-source-maps-heres-whats-inside-cjo) | DEV.to (Gabriel Anhaia) | 소스맵 전체 분석 |
| 138 | [We Reverse-Engineered 12 Versions of Claude Code. Then It Leaked Its Own Source Code.](https://dev.to/kolkov/we-reverse-engineered-12-versions-of-claude-code-then-it-leaked-its-own-source-code-pij) | DEV.to | 12버전 리버스 엔지니어링 |
| 139 | [I Analyzed All 512,000 Lines of Claude Code's Leaked Source](https://dev.to/vibehackers/i-analyzed-all-512000-lines-of-claude-codes-leaked-source-heres-what-anthropic-was-hiding-4gg8) | DEV.to (VibeHackers) | 512K줄 전체 분석 |
| 140 | [Anthropic accidentally leaked Claude Code's source code. Here's what that means.](https://dev.to/aws-builders/anthropic-accidentally-leaked-claude-codes-source-code-heres-what-that-means-2f89) | DEV.to (AWS Builders) | AWS 관점 분석 |
| 141 | [Claude Code's Entire Source Code Just Leaked — 512,000 Lines Exposed](https://dev.to/evan-dong/claude-codes-entire-source-code-just-leaked-512000-lines-exposed-3139) | DEV.to | 512K줄 노출 |
| 142 | [Anthropic Claude Code Source Code Leaked: What Happened, Why It Matters](https://dev.to/om_shree_0709/anthropic-claude-code-source-code-leaked-what-happened-why-it-matters-and-what-comes-next-53cc) | DEV.to | 사건 분석 + 향후 전망 |

---

## 기타

| # | 제목 | 출처 | 핵심 인사이트 |
|---|------|------|--------------|
| 143 | [Claude Code's Entire Source Code Got Leaked via a Sourcemap in npm](https://kuber.studio/blog/AI/Claude-Code's-Entire-Source-Code-Got-Leaked-via-a-Sourcemap-in-npm,-Let's-Talk-About-it) | Kuber Studio | 소스맵 기술 분석 |
| 144 | [Compaction - Claude API Docs (공식)](https://platform.claude.com/docs/en/build-with-claude/compaction) | Anthropic 공식 | 공식 컴팩션 문서 |
| 145 | [Session memory compaction (공식 Cookbook)](https://platform.claude.com/cookbook/misc-session-memory-compaction) | Anthropic 공식 | 공식 세션 메모리 컴팩션 |
| 146 | [How to Use the /compact Command in Claude Code](https://www.mindstudio.ai/blog/claude-code-compact-command-context-management) | MindStudio | /compact 실전 가이드 |

---

## 통계 요약

| 카테고리 | 수량 |
|----------|------|
| A. 아키텍처 & 내부 구조 | 17 |
| B. 숨겨진 기능 | 13 |
| C. 보안 분석 | 9 |
| D. 시스템 프롬프트 & 권한 | 6 |
| E. Anti-Distillation & 텔레메트리 | 5 |
| F. 사건 타임라인 & 뉴스 | 15 |
| G. 오피니언 & 논평 | 10 |
| H. 오픈소스 파생 | 10 |
| I. 엔터프라이즈 & 교훈 | 9 |
| J. 한국어 분석 | 18 |
| K. 커뮤니티 토론 | 5 |
| L. 멀웨어 & 공급망 | 6 |
| M. 모델 코드네임 | 2 |
| Substack 모음 | 6 |
| Medium 추가 | 5 |
| DEV.to 추가 | 6 |
| 기타 | 4 |
| **총계** | **~146** |

> **참고**: 검색 API 한계로 300개 전부를 단일 세션에서 수집하기 어려웠으며, 현재 146개를 수집 완료.
> 추가 검색을 통해 보강 가능합니다.
