<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/installation -->

# Claude Code 설치 가이드

## 요구사항

Claude Code는 macOS, Linux, Windows(WSL 통해)에서 작동하며 Node.js 18 이상이 필수입니다.

- **Node.js 18 이상** — 시작 시 버전을 확인하고 미만일 경우 오류로 종료됩니다
- **npm** — Node.js와 함께 포함됨

버전 확인 명령어:
```bash
node --version
npm --version
```

## Claude Code 설치

전역 설치:
```bash
npm install -g @anthropic-ai/claude-code
```

설치 확인:
```bash
claude --version
```

## 플랫폼별 설치 가이드

### macOS
npm 전역 설치는 기본적으로 작동합니다. 권한 오류 발생 시:

**옵션 A: npm 권한 수정(권장)**
```bash
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
```

셸 프로필(`~/.zshrc` 또는 `~/.bash_profile`)에 추가:
```bash
export PATH=~/.npm-global/bin:$PATH
```

다시 로드 후 설치:
```bash
source ~/.zshrc
npm install -g @anthropic-ai/claude-code
```

**옵션 B: Node 버전 관리자 사용**

nvm이나 fnm 같은 도구 활용:
```bash
nvm install --lts
nvm use --lts
npm install -g @anthropic-ai/claude-code
```

### Linux

`npm install -g`는 `sudo` 또는 수정된 npm 접두사가 필요합니다. `sudo` 사용은 권장하지 않습니다.

**권장: Node 버전 관리자 사용**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install --lts
nvm use --lts
npm install -g @anthropic-ai/claude-code
```

**대안: npm 전역 접두사 수정**
```bash
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
npm install -g @anthropic-ai/claude-code
```

### Windows (WSL)

Claude Code는 Windows Subsystem for Linux를 통해 Windows에서 실행되며, Command Prompt나 PowerShell 직접 실행은 지원하지 않습니다.

**단계 1: WSL 설치**

관리자 권한 PowerShell에서:
```powershell
wsl --install
```

**단계 2: WSL 터미널 열기**

시작 메뉴에서 Ubuntu 실행 또는 PowerShell에서 `wsl` 실행

**단계 3: WSL 내에서 Node.js 설치**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts
```

**단계 4: Claude Code 설치**
```bash
npm install -g @anthropic-ai/claude-code
```

**참고**: 항상 WSL 터미널 내에서 `claude`를 실행하고 프로젝트 파일은 WSL 파일시스템에 위치해야 최적의 성능을 얻습니다.

## 업데이트

최신 버전으로 업데이트:
```bash
npm update -g @anthropic-ai/claude-code
```

또는 내장 업데이트 명령어 사용:
```bash
claude update
```

현재 버전 확인:
```bash
claude --version
```

## 제거

Claude Code 제거:
```bash
npm uninstall -g @anthropic-ai/claude-code
```

설정 파일 삭제:
```bash
rm -rf ~/.claude
```

## 문제 해결

### 1. 설치 후 'claude' 명령어를 찾을 수 없음

npm 전역 bin 디렉토리가 PATH에 없을 가능성이 높습니다.

확인 명령어:
```bash
npm config get prefix
```

해당 경로의 bin 하위 디렉토리를 셸 프로필에 추가하여 해결합니다.

### 2. Node.js 버전이 18 미만

Claude Code는 Node.js 버전 18 이상이 필요합니다.

버전 관리자를 통해 업그레이드:
```bash
nvm install --lts
nvm use --lts
```

### 3. npm install -g 실행 시 권한 거부

`sudo npm install -g`는 사용하지 마세요. 대신 npm 접두사를 수정합니다:
```bash
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
export PATH=~/.npm-global/bin:$PATH
npm install -g @anthropic-ai/claude-code
```

### 4. 첫 실행 시 인증 실패

브라우저 기반 OAuth가 작동하지 않으면 API 키를 환경 변수로 설정:
```bash
export ANTHROPIC_API_KEY=sk-ant-...
claude
```

[Anthropic Console](https://console.anthropic.com)에서 API 키를 얻을 수 있습니다.

### 5. Docker 또는 CI 환경에서 실행

비대화형 환경에서는 환경 변수를 통해 인증:
```bash
export ANTHROPIC_API_KEY=sk-ant-...
claude -p "run the test suite and report any failures"
```

권한 프롬프트를 건너뛰려면:
```bash
claude --dangerously-skip-permissions
```

이 플래그는 인터넷 접근이 없고 컨테이너 외부에서 루트로 실행되지 않는 환경에서만 작동합니다.
