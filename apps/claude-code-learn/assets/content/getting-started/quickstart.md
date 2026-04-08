<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/quickstart -->

# Claude Code Quickstart

## 개요

5분 내에 Claude Code를 설치하고 첫 번째 코딩 작업을 완료할 수 있도록 안내합니다.

## 필수 요구사항

- Node.js 18 이상
- npm

### 버전 확인
```bash
node --version
```

Node.js 설치 필요 시: [nodejs.org](https://nodejs.org)

## Step 1: Claude Code 설치

```bash
npm install -g @anthropic-ai/claude-code
```

설치 확인:
```bash
claude --version
```

## Step 2: 인증

```bash
claude
```

첫 실행 시 브라우저에서 Anthropic 계정으로 로그인. 자격증명은 안전하게 저장되어 재사용됨.

### 대체 방법 - API 키 설정
```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

**주의사항**: ANTHROPIC_API_KEY 환경변수 설정 시 우선 적용. 대화형 사용에는 OAuth 권장 (토큰 자동 갱신)

## Step 3: 프로젝트 디렉토리 이동

```bash
cd my-project
```

## Step 4: 대화형 세션 시작

```bash
claude
```

### 예시 작업:
- "explain the structure of this codebase"
- "add input validation to the signup form"
- "write tests for the UserService class"
- "find all places where we catch and swallow errors"

변경사항 승인/거절 가능

## Step 5: CLAUDE.md 파일 초기화

```
/init
```

프로젝트 구조 분석 후 CLAUDE.md 생성. 검토 및 편집 후 커밋 권장.

**팁**: CLAUDE.md는 모든 세션 시작 시 로드되어 비표준 빌드 명령어, 테스트 특수성, 코딩 컨벤션 등을 기록하기에 최적

## 비대화형 명령어 실행

```bash
claude -p "explain this codebase"
claude -p "list all TODO comments and the files they appear in"
claude -p "check for unused exports in src/"
```

## 주요 슬래시 명령어

| 명령어 | 설명 |
|--------|------|
| `/help` | 사용 가능한 명령어 및 단축키 표시 |
| `/init` | CLAUDE.md 생성 또는 업데이트 |
| `/memory` | 메모리 파일 보기 및 편집 |
| `/permissions` | 권한 모드 설정 변경 |
| `/mcp` | MCP 서버 연결 관리 |
| `/clear` | 대화 컨텍스트 초기화 |
| `/exit` | 세션 종료 |

## 다음 단계

- **핵심 개념**: Claude Code의 사고, 계획, 작업 실행 방식 이해
- **권한 모드**: Claude의 자율성 설정 방법
- **CLAUDE.md 참고**: 효과적인 메모리 파일 작성
- **MCP 서버**: 데이터베이스, API, 내부 도구 연동
