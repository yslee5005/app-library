<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/configuration/environment-variables -->

# Claude Code 환경 변수 완전 가이드

## 개요
Claude Code는 시작 시 환경 변수를 읽으며, 이를 통해 인증, API 접근, 런타임 동작 및 활성 기능을 제어할 수 있습니다.

---

## 인증 섹션

### ANTHROPIC_API_KEY
- **유형**: 문자열
- **목적**: "Anthropic API와 직접 인증하기 위한 API 키"
- **우선순위**: OAuth 자격증명보다 우선
- **예시**:
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

### ANTHROPIC_AUTH_TOKEN
- **유형**: 문자열
- **목적**: ANTHROPIC_API_KEY가 적용되지 않는 상황에서 사용하는 대체 인증 토큰

### ANTHROPIC_BASE_URL
- **유형**: 문자열
- **목적**: "프록시, 스테이징 환경 또는 호환 가능한 타사 엔드포인트"에 Claude Code를 지정
- **예시**:
```bash
export ANTHROPIC_BASE_URL="https://my-proxy.example.com"
```

### CLAUDE_CODE_API_BASE_URL
- **유형**: 문자열
- **특징**: ANTHROPIC_BASE_URL보다 우선순위 높음

### ANTHROPIC_BEDROCK_BASE_URL
- **유형**: 문자열
- **용도**: AWS Bedrock API 접근 시 설정

### ANTHROPIC_VERTEX_PROJECT_ID
- **유형**: 문자열
- **용도**: "Google Cloud의 Vertex AI 플랫폼을 통해 사용할 때 필수"

### CLAUDE_CODE_USE_BEDROCK
- **유형**: 문자열 (1 또는 true)
- **기능**: AWS Bedrock을 API 제공자로 활성화

### CLAUDE_CODE_USE_FOUNDRY
- **유형**: 문자열 (1 또는 true)
- **기능**: Anthropic Foundry를 API 제공자로 활성화

### CLAUDE_CODE_OAUTH_TOKEN
- **유형**: 문자열
- **용도**: "대화형 로그인 흐름을 우회하고 직접 인증하기 위한 OAuth 접근 토큰"

---

## 구성 경로 섹션

### CLAUDE_CONFIG_DIR
- **유형**: 문자열
- **기본값**: `~/.claude`
- **목적**: Claude Code가 구성, 설정 및 기록을 저장하는 디렉토리 재정의
- **예시**:
```bash
export CLAUDE_CONFIG_DIR="/opt/claude-config"
```

### CLAUDE_CODE_MANAGED_SETTINGS_PATH
- **유형**: 문자열
- **용도**: 기업 환경에서 기본 플랫폼 경로가 부적절할 때 관리 설정 파일 경로 재정의

---

## 모델 선택 섹션

### ANTHROPIC_MODEL
- **유형**: 문자열
- **기능**: 기본 모델 설정 (설정 파일 및 --model 플래그로 재정의 가능)

### CLAUDE_CODE_SUBAGENT_MODEL
- **유형**: 문자열
- **기능**: 주 에이전트가 생성한 하위 에이전트 작업용 모델 지정

### CLAUDE_CODE_AUTO_MODE_MODEL
- **유형**: 문자열
- **기능**: 자동 모드 실행 시 모델 지정 (미설정 시 주 세션 모델 사용)

---

## 동작 토글 섹션

### CLAUDE_CODE_REMOTE
- **유형**: 문자열 (1 또는 true)
- **기능**: "원격/컨테이너 모드 활성화 - API 타임아웃 확장, 대화형 프롬프트 억제"
- **예시**:
```bash
export CLAUDE_CODE_REMOTE=1
```

### CLAUDE_CODE_SIMPLE
- **유형**: 문자열 (1, true 또는 --bare 플래그)
- **기능**: "베어 모드 - 훅, LSP 통합, 플러그인 동기화 등 건너뜀"
- **인증 요구사항**: ANTHROPIC_API_KEY 필수

### DISABLE_AUTO_COMPACT
- **유형**: 문자열 (1 또는 true)
- **기능**: "자동 컨텍스트 압축 비활성화"
- **예시**:
```bash
export DISABLE_AUTO_COMPACT=1
```

### CLAUDE_CODE_DISABLE_BACKGROUND_TASKS
- **유형**: boolean (1 또는 true)
- **기능**: 백그라운드 프로세스 실행 불가능하게 설정

### CLAUDE_CODE_DISABLE_THINKING
- **유형**: 문자열 (1 또는 true)
- **기능**: 모든 API 호출에서 확장 사고 비활성화

### CLAUDE_CODE_DISABLE_AUTO_MEMORY
- **유형**: 문자열 (1, true, 0 또는 false)
- **기능**: 자동 메모리 읽기/쓰기 제어
- **자동 비활성화**: 베어 모드 및 원격 모드에서 자동 비활성화

### CLAUDE_CODE_DISABLE_CLAUDE_MDS
- **유형**: 문자열 (1 또는 true)
- **기능**: "모든 CLAUDE.md 메모리 파일 로딩 완전 비활성화"

### CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC
- **유형**: 문자열 (1 또는 true)
- **기능**: 분석, 원격 측정 및 비필수 네트워크 요청 억제

### CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD
- **유형**: 문자열 (1 또는 true)
- **기능**: --add-dir로 추가된 디렉토리에서 CLAUDE.md 파일 로드

### CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR
- **유형**: 문자열 (1 또는 true)
- **기능**: 각 Bash 명령 후 원래 프로젝트 루트로 작업 디렉토리 재설정

---

## 리소스 제한 섹션

### CLAUDE_CODE_MAX_OUTPUT_TOKENS
- **유형**: 숫자
- **목적**: "API 응답당 최대 출력 토큰 수 재정의"
- **용도**: 자동화 워크플로우에서 비용 제어
- **예시**:
```bash
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=4096
```

### CLAUDE_CODE_MAX_CONTEXT_TOKENS
- **유형**: 숫자
- **기능**: 최대 컨텍스트 윈도우 크기 재정의

### BASH_MAX_OUTPUT_LENGTH
- **유형**: 숫자
- **목적**: "Bash 명령 출력에서 캡처되는 최대 문자 수"
- **예시**:
```bash
export BASH_MAX_OUTPUT_LENGTH=50000
```

### API_TIMEOUT_MS
- **유형**: 숫자 (밀리초)
- **기본값**: 표준 모드 300,000ms (5분), 원격 모드 120,000ms (2분)
- **예시**:
```bash
export API_TIMEOUT_MS=60000
```

---

## 원격 측정 및 관찰성 섹션

### CLAUDE_CODE_ENABLE_TELEMETRY
- **유형**: 문자열 (1 또는 true)
- **기능**: "OpenTelemetry 내보내기 활성화 (추적, 메트릭, 로그)"
- **추가 설정**: 표준 OpenTelemetry 환경 변수 필요
- **예시**:
```bash
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_EXPORTER_OTLP_ENDPOINT="https://otel.example.com"
```

### CLAUDE_CODE_JSONL_TRANSCRIPT
- **유형**: 문자열 (파일 경로)
- **기능**: "세션의 JSONL 기록을 작성하는 파일"
- **형식**: 각 줄은 대화 이벤트를 나타내는 JSON 객체
- **예시**:
```bash
export CLAUDE_CODE_JSONL_TRANSCRIPT="/tmp/session.jsonl"
```

---

## Node.js 런타임 섹션

### NODE_OPTIONS
- **유형**: 문자열
- **기능**: "Claude Code가 --max-old-space-size 같은 플래그를 감지하고 동작 조정"
- **주의**: 코드 실행 플래그가 포함된 값은 피하기
- **예시**:
```bash
export NODE_OPTIONS="--max-old-space-size=4096"
```

---

## 호스트 플랫폼 재정의 섹션

### CLAUDE_CODE_HOST_PLATFORM
- **유형**: 문자열
- **허용값**: "win32", "darwin", "linux"
- **용도**: "컨테이너에서 실행되지만 실제 호스트 플랫폼이 다를 때 분석용 플랫폼 재정의"
- **예시**:
```bash
export CLAUDE_CODE_HOST_PLATFORM=darwin
```

---

## 클라우드 제공자 지역 재정의 섹션

Claude Code는 모델별 Vertex AI 지역 재정의를 지원합니다.

### 모델별 환경 변수 매핑

| 모델 프리픽스 | 환경 변수 |
|---|---|
| claude-haiku-4-5 | VERTEX_REGION_CLAUDE_HAIKU_4_5 |
| claude-3-5-haiku | VERTEX_REGION_CLAUDE_3_5_HAIKU |
| claude-3-5-sonnet | VERTEX_REGION_CLAUDE_3_5_SONNET |
| claude-3-7-sonnet | VERTEX_REGION_CLAUDE_3_7_SONNET |
| claude-opus-4-1 | VERTEX_REGION_CLAUDE_4_1_OPUS |
| claude-opus-4 | VERTEX_REGION_CLAUDE_4_0_OPUS |
| claude-sonnet-4-6 | VERTEX_REGION_CLAUDE_4_6_SONNET |
| claude-sonnet-4-5 | VERTEX_REGION_CLAUDE_4_5_SONNET |
| claude-sonnet-4 | VERTEX_REGION_CLAUDE_4_0_SONNET |

**예시**:
```bash
export VERTEX_REGION_CLAUDE_4_0_OPUS="us-central1"
```

**기본값**: `CLOUD_ML_REGION` (기본값: us-east5)

---

## AWS 자격증명 섹션

Bedrock 접근 시 표준 AWS 자격증명 환경 변수 사용:

### AWS_REGION
- **유형**: 문자열
- **용도**: Bedrock API 호출용 AWS 지역
- **폴백**: AWS_DEFAULT_REGION (기본값: us-east-1)

### AWS_DEFAULT_REGION
- **유형**: 문자열
- **기능**: AWS_REGION이 설정되지 않았을 때 폴백

---

## 모든 세션에 환경 변수 설정하기

설정 파일의 `env` 필드를 사용하여 모든 Claude Code 세션에 적용되는 환경 변수를 설정할 수 있습니다:

```json
{
  "env": {
    "DISABLE_AUTO_COMPACT": "1",
    "BASH_MAX_OUTPUT_LENGTH": "30000"
  }
}
```

상세 정보는 [Settings](/configuration/settings) 문서 참고.
