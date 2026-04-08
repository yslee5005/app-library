<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/reference/tools/bash -->

# Bash 도구

## 개요

Execute shell commands in a persistent bash session. Bash 도구는 지속적인 셸 세션에서 명령어를 실행합니다.

## 주요 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| command | string | O | 실행할 셸 명령어 (파이프, 리다이렉션, &&, \|\|, ; 포함 가능) |
| timeout | number | - | 실행 제한 시간(밀리초). 기본값: 120,000ms(2분), 최대: 600,000ms(10분) |
| description | string | - | 명령어 동작을 설명하는 짧은 텍스트 |
| run_in_background | boolean | - | true일 때 백그라운드에서 실행, & 추가 불필요 |

## 세션 동작 특성

**지속되는 것:**
- 작업 디렉토리

**초기화되는 것:**
- 셸 변수
- 별칭(aliases) 및 함수
- cd 변경 사항 (절대경로 사용)

각 세션은 사용자의 셸 프로필(bash 또는 zsh)에서 초기화됩니다.

## 타임아웃 설정

Default timeout 120,000 ms (2 min), Maximum timeout 600,000 ms (10 min)이며, 환경 변수로 런타임 시 재정의 가능합니다.

## 권한 모델

세 가지 결과:
- **Allow** -- 기존 허용 규칙 일치 또는 읽기 전용 분류
- **Ask** -- 사용자 승인 필요
- **Deny** -- 거부 규칙 일치로 차단

읽기 전용 명령어(ls, cat, git log, grep)는 자동 허용됩니다.

## 보안 제한 사항

다음 패턴 포함 시 명시적 승인 필요:
- 명령어 치환: `` `...` ``, `$()`, `${}`
- 프로세스 치환: `<()`, `>()`
- 의심스러운 리다이렉션
- Zsh 구성요소: zmodload, emulate 등
- ANSI-C 인용법 (`$'...'`)
- IFS 변수 조작
- `/proc/*/environ` 접근

## 백그라운드 실행

포그라운드(기본값): Claude가 완료까지 대기, 즉시 출력 수신

백그라운드: 명령어 시작 후 계속 진행, 완료 시 알림

## 도구 선호도

파일 검색은 Glob, 콘텐츠 검색은 Grep, 파일 읽기/편집은 Read/Edit 도구를 우선합니다. Bash는 전용 도구가 없는 빌드, 테스트, 셸 작업용입니다.
