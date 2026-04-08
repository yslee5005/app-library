<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/guides/skills -->

# Claude Code Skills

## 개요
Skills는 마크다운 파일로 정의되는 재사용 가능한 프롬프트와 워크플로우입니다. 사용자가 `/skill-name` 명령을 입력하면 Claude가 해당 skill의 지시사항을 로드하고 실행합니다.

## Skills의 작동 원리

Skills는 `.claude/skills/` 디렉토리 내부의 디렉토리로, `SKILL.md` 파일을 포함합니다. Skill을 호출하면 Claude Code가 `SKILL.md`를 프롬프트로 로드합니다. 반복되는 배포, 변경로그 작성, PR 검토 등 다양한 워크플로우에 활용할 수 있습니다.

**주요 특징**: Skill은 호출될 때만 로드되므로(lazy loading), 많은 skill을 정의해도 시작 시간이나 컨텍스트 크기에 영향을 주지 않습니다.

## Skill 생성 단계

### 1단계: Skill 디렉토리 생성
```bash
mkdir -p .claude/skills/my-skill
```

Skill은 다음 위치에 저장 가능합니다:
- `.claude/skills/` (프로젝트 레벨)
- `~/.claude/skills/` (사용자 레벨, 모든 프로젝트에서 사용 가능)

### 2단계: SKILL.md 작성
`.claude/skills/my-skill/SKILL.md` 파일 생성:

```markdown
---
description: Run the full release process for this project
argument-hint: version number (e.g. 1.2.3)
---

Release the project at version $ARGUMENTS.

Steps:
1. Update the version in `package.json` to $ARGUMENTS
2. Update CHANGELOG.md with a new section for this version
3. Run `npm test` and confirm all tests pass
4. Commit with message "chore: release v$ARGUMENTS"
5. Create a git tag `v$ARGUMENTS`
```

### 3단계: Skill 호출
```
/my-skill 1.2.3
```

Claude는 skill을 로드하고 `$ARGUMENTS` 자리에 `1.2.3`을 대입하여 실행합니다.

## Skill Frontmatter 설정

```yaml
---
description: /skills에 표시되는 짧은 설명
argument-hint: 인자 설명 (자동완성에 표시)
allowed-tools: Bash, Write, Read
when_to_use: Skill 사용 시기에 대한 설명
model: claude-sonnet-4-6
user-invocable: true
context: fork
---
```

### Frontmatter 필드 상세

| 필드 | 설명 |
|------|------|
| `description` | slash command 목록에 표시되는 설명 |
| `argument-hint` | 자동완성에서 보여줄 인자 힌트 |
| `allowed-tools` | 쉼표로 구분된 허용 도구 목록 (기본값: 모두) |
| `when_to_use` | Claude가 능동적으로 skill을 사용할 시기 |
| `model` | 이 skill에 사용할 모델 (기본값: 세션 모델) |
| `user-invocable` | `false`로 설정하면 slash command 목록에서 숨김 |
| `context` | `fork`로 설정하면 격리된 하위에이전트 컨텍스트에서 실행 |
| `paths` | glob 패턴; 매칭 파일 수정 시에만 활성화 |
| `version` | Skill 버전 문자열 |
| `hooks` | 이 skill 실행에 범위가 지정된 hooks |

## 인자 치환

### 단순 인자
`SKILL.md`에서 `$ARGUMENTS`를 사용하여 slash command 뒤의 텍스트를 삽입합니다:

```markdown
Create a new React component named $ARGUMENTS following conventions.
```

호출:
```
/new-component UserProfile
```

### 명명된 인자
Frontmatter에서 인자 목록을 지정:

```yaml
---
arguments: [name, directory]
---
```

본문에서 `$name`, `$directory`로 참조합니다.

## 인라인 셸 명령어

백틱 주입 구문을 사용하여 호출 시점에 실행되는 셸 명령어를 포함할 수 있습니다:

```markdown
---
description: Review recent changes
---

Here are the recent commits for context:

!`git log --oneline -20`

Review the changes above and summarize what was accomplished.
```

`!` 접두사를 사용한 백틱 인용 명령어는 실행되며 그 출력이 프롬프트에 삽입됩니다.

**주의**: "인라인 셸 명령어는 셸과 동일한 권한으로 실행되며, skill 로드 시 아닌 호출 시점에 실행됩니다."

## Skill 나열

```
/skills
```

이 명령은 모든 범위(프로젝트, 사용자, 관리됨)의 모든 skill과 설명을 표시합니다.

## 네임스페이스 Skill

하위 디렉토리의 skill은 콜론으로 네임스페이스됩니다:

```
.claude/skills/
  deployment/
    SKILL.md      → /deployment
  database/
    migrate/
      SKILL.md    → /database:migrate
    seed/
      SKILL.md    → /database:seed
```

## 조건부 Skill (경로 기반 활성화)

`paths` frontmatter 필드를 추가하여 특정 파일 패턴 작업 시에만 활성화:

```yaml
---
description: Django model review
paths: "**/*.py"
when_to_use: Use when editing Django model files
---
```

매칭되는 파일을 읽거나 쓸 때 skill이 Claude 컨텍스트에 자동으로 로드됩니다.

## 번들 Skill

Claude Code는 빌트인 skill을 제공하며, `/skills`에서 확인 가능합니다 (소스: bundled). 포함 내용:
- 프로젝트 온보딩 지원
- 일반적인 코드 검토 워크플로우
- 검색 및 분석 패턴

## 사용자 레벨 Skill

`~/.claude/skills/`의 skill은 모든 프로젝트에서 사용 가능합니다:

```bash
mkdir -p ~/.claude/skills/standup
cat > ~/.claude/skills/standup/SKILL.md << 'EOF'
---
description: Summarize today's work for standup
---

Look at today's git commits and summarize in standup format.
EOF
```

## Skills 대 Hooks 비교

| 특징 | Skills | Hooks |
|------|--------|-------|
| **호출** | 명시적: `/skill-name` 또는 Claude 자동 호출 | 자동: 도구 이벤트 발생 시 |
| **사용 시기** | 의도적으로 트리거하는 반복 워크플로우 | 자동 부작용, 포맷팅, 린팅 |
| **설정** | `.claude/skills/`의 `SKILL.md` | 설정 JSON의 `hooks` 필드 |
| **컨텍스트** | 파일, 셸 출력, 상세 지시사항 포함 | 이벤트 JSON 수신, 종료 코드/출력 반환 |

## 예시: 커스텀 컴포넌트 생성기

```markdown
---
description: Generate a new React component with tests
argument-hint: ComponentName
allowed-tools: Write, Bash
---

Create a new React component named $ARGUMENTS.

1. Create `src/components/$ARGUMENTS/$ARGUMENTS.tsx` with:
   - Functional component using TypeScript
   - Props interface named `$ARGUMENTSProps`
   - JSDoc comment
   - Default export

2. Create test file `src/components/$ARGUMENTS/$ARGUMENTS.test.tsx`:
   - Rendering test using React Testing Library
   - Snapshot test

3. Create `src/components/$ARGUMENTS/index.ts` re-exporting component

4. Run `npx tsc --noEmit` to confirm no type errors
```

호출:
```
/new-component Button
```
