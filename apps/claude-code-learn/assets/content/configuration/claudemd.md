<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/configuration/claudemd -->

# CLAUDE.md

## 개요
CLAUDE.md 파일은 프로젝트 특화 지속적 지침을 인코딩하는 메커니즘입니다. "프로젝트 규칙을 매번 설명할 필요 없이 한 번 작성하면 Claude가 자동으로 로드"합니다.

## 포함되어야 할 내용

**필수 항목:**
- 정확한 빌드, 테스트, 린트 명령어 (도구명만이 아닌 전체 호출)
- 코드 작성 방식에 영향을 주는 아키텍처 결정사항
- 프로젝트 특화 코딩 컨벤션 (네이밍 패턴, 파일 구조 규칙)
- 환경 설정 요구사항 (필수 환경변수, 예상 서비스)
- 회피해야 할 일반적 함정이나 패턴
- 모노레포 구조 및 패키지 책임 영역

**제외할 내용:**
- Claude가 이미 아는 표준 지식 (TypeScript 문법)
- 명백한 상기사항 ("깨끗한 코드 작성")
- 민감 데이터 (API 키, 비밀번호, 토큰)
- 자주 변경되는 정보

## 파일 위치 체계

| 파일 경로 | 유형 | 용도 |
|---------|------|------|
| `/etc/claude-code/CLAUDE.md` | 관리자 | 시스템 전역 지침 |
| `~/.claude/CLAUDE.md` | 사용자 | 개인 전역 지침 |
| `~/.claude/rules/*.md` | 사용자 | 모듈화된 전역 규칙 |
| `CLAUDE.md` (프로젝트 루트) | 프로젝트 | 팀 공유 지침 |
| `.claude/CLAUDE.md` | 프로젝트 | 대체 위치 |
| `.claude/rules/*.md` | 프로젝트 | 주제별 모듈화 규칙 |
| `CLAUDE.local.md` | 로컬 | 개인 비공개 지침 |

## 로딩 순서 및 우선순위

**5단계 로딩:**

1. **관리자 메모리**: `/etc/claude-code/` 경로 파일들 (항상 로드, 제외 불가)
2. **사용자 메모리**: `~/.claude/` 경로 파일들
3. **프로젝트 메모리**: 파일시스템 루트에서 현재 디렉토리까지 순회 (현재 위치에 가까운 파일이 높은 우선순위)
4. **로컬 메모리**: `CLAUDE.local.md` 파일들 (기본 .gitignore 대상)

## @include 지시문

메모리 파일은 "@" 표기법을 통해 다른 파일을 포함할 수 있습니다.

**경로 형식:**

```
@filename                    → 현재 파일과 같은 디렉토리
@./relative/path            → 상대 경로
@~/path/in/home             → 홈 디렉토리 기준
@/absolute/path             → 절대 경로
```

**동작 방식:**
- 프래그먼트 제거 후 경로 해석
- 존재하지 않는 파일은 무시
- 순환 참조 감지 및 방지
- 최대 5단계 깊이 중첩 가능
- 텍스트 파일만 지원

## Frontmatter 경로 타겟팅

`.claude/rules/` 파일은 YAML frontmatter로 조건부 적용 가능:

```yaml
---
paths:
  - "src/api/**"
  - "*.graphql"
---
```

이 경우 해당 패턴과 일치하는 파일 작업 시에만 규칙 적용됩니다.

## 실행 명령어

- **`/init`**: 프로젝트의 CLAUDE.md 자동 생성
- **`/memory`**: 메모리 에디터 열기 (로드된 파일 목록 및 직접 편집)

## 파일 제외

settings.json의 `claudeMdExcludes` 설정으로 특정 CLAUDE.md 파일 제외 가능:

```json
{
  "claudeMdExcludes": [
    "/absolute/path/to/vendor/CLAUDE.md",
    "**/generated/**"
  ]
}
```

패턴은 절대 경로 기준 picomatch 규칙 사용. 관리자 파일은 항상 로드됩니다.
