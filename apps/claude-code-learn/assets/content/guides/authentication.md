<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/guides/authentication -->

# Claude Code 인증 설정 - 완전 가이드

## 개요
Claude Code는 Anthropic API, AWS Bedrock, GCP Vertex AI를 통한 다양한 인증 방식을 지원합니다.

---

## 1. Claude.ai OAuth (기본값)

첫 실행 시 API 키 없이 OAuth 흐름을 자동으로 시작합니다.

**설정 단계:**
- 터미널에서 `claude` 명령 실행
- 표시되는 URL을 브라우저에서 열기
- claude.ai 계정으로 로그인 및 인증 승인
- 토큰이 자동으로 저장됨 (macOS Keychain 또는 자격증명 파일)

**토큰 갱신:** "OAuth tokens are refreshed automatically before they expire" - 명시적 재인증 불필요

---

## 2. API 키 인증

### 환경 변수 방식
```bash
export ANTHROPIC_API_KEY=sk-ant-...
```
설정 시 OAuth 프롬프트 제외됨

### 설정 파일 방식
`~/.claude/settings.json`에 추가:
```json
{
  "apiKeyHelper": "cat ~/.anthropic/api-key"
}
```
- 명령어는 키만 stdout으로 출력
- 종료 코드 0 필요
- 캐시: 기본 5분 (TTL 환경변수로 조정 가능)

**경고:** 이 방식 선택 시 OAuth 비활성화됨

---

## 3. AWS Bedrock 인증

**활성화:**
```bash
export CLAUDE_CODE_USE_BEDROCK=1
```

**AWS 자격증명 체인:**
- 자격증명 파일 (`~/.aws/credentials`)
- 환경변수: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`
- IAM 역할 (EC2, ECS)
- AWS SSO (`aws sso login`)

**리전 설정 (선택):**
```bash
export AWS_REGION=us-east-1
```

### 자격증명 자동 갱신

설정 파일에 추가:
```json
{
  "awsAuthRefresh": "aws sso login --profile my-profile"
}
```

또는 `awsCredentialExport`로 역할 전환:
```json
{
  "awsCredentialExport": "aws sts assume-role --role-arn arn:aws:iam::123456789012:role/MyRole --role-session-name claude-code --query Credentials --output json"
}
```

---

## 4. GCP Vertex AI 인증

**활성화:**
```bash
export CLAUDE_CODE_USE_VERTEX=1
```

**ADC (Application Default Credentials) 설정:**
- `gcloud auth application-default login`
- `GOOGLE_APPLICATION_CREDENTIALS` 환경변수 (서비스 계정)
- Workload Identity (GKE)

**프로젝트/리전 설정 (선택):**
```bash
export ANTHROPIC_VERTEX_PROJECT_ID=my-gcp-project
export CLOUD_ML_REGION=us-central1
```

### 자동 갱신
```json
{
  "gcpAuthRefresh": "gcloud auth application-default login"
}
```

---

## 5. 계정 전환

### 다른 계정 로그인
```
/login
```
새로운 OAuth 흐름 시작, 기존 토큰 교체

### 로그아웃
```
/logout
```
저장된 자격증명 제거, 다음 실행 시 재인증 필요

---

## 6. 토큰 만료 및 갱신 메커니즘

**자동 갱신 프로세스:**
- 각 API 요청 전 토큰 만료 확인
- 만료 시 갱신 토큰으로 자동 갱신
- 여러 인스턴스는 잠금 파일로 중복 방지
- 401 응답(예: 시간 차이)는 즉시 강제 갱신

**실패 처리:** "If refresh fails... Claude Code will prompt you to run `/login`"

---

## 7. 인증 우선순위

1. `ANTHROPIC_AUTH_TOKEN` 환경변수
2. `CLAUDE_CODE_OAUTH_TOKEN` 환경변수
3. OAuth 토큰 (파일 디스크립터)
4. `apiKeyHelper` 설정
5. 저장된 claude.ai OAuth 토큰
6. `ANTHROPIC_API_KEY` 환경변수

**CI/자동화 환경 권장:** API 키 또는 `CLAUDE_CODE_OAUTH_TOKEN` 사용

---

## 문서 인덱스
전체 문서: https://vineetagarwal-code-claude-code.mintlify.app/llms.txt
