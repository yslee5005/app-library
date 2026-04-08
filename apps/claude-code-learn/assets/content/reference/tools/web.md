<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/reference/tools/web -->

# 웹 도구 (Web Tools)

## 개요

Claude Code는 웹 상호작용을 위해 두 가지 도구를 제공합니다: **WebFetch**와 **WebSearch**입니다.

---

## WebFetch 도구

### 기능

특정 URL을 가져와 HTML을 마크다운으로 변환한 후, 사용자의 프롬프트를 기반으로 콘텐츠를 분석합니다.

### 필수 매개변수

- **url** (문자열): 완전한 형식의 유효한 URL (HTTP는 자동으로 HTTPS로 업그레이드됨)
- **prompt** (문자열): 페이지에서 무엇을 추출할 것인지를 설명하는 자연어 프롬프트

### 작동 방식

1. URL 페칭 및 HTML -> 마크다운 변환
2. 마크다운과 프롬프트를 보조 모델에 전송
3. 모델의 합성된 응답 반환

### 주요 특징

- **캐싱**: 15분 메모리 내 캐시 (반복 호출 시 네트워크 요청 방지)
- **리디렉션 처리**: 다른 호스트로의 리디렉션은 자동 추종하지 않고 특별 메시지 반환

### 제한사항

- 읽기 전용 (폼 제출 불가)
- 인증 필요 페이지 미지원
- GitHub 리소스는 `gh` CLI 선호

### 사용 예시

**API 세부정보 추출**
```json
{
  "url": "https://docs.example.com/api/authentication",
  "prompt": "어떤 인증 방식이 지원되며 어떤 헤더가 필요한가?"
}
```

**라이브러리 버전 확인**
```json
{
  "url": "https://github.com/org/lib/blob/main/CHANGELOG.md",
  "prompt": "최신 버전에서 무엇이 변경되었나?"
}
```

**문서 읽기**
```json
{
  "url": "https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API",
  "prompt": "Fetch API를 요약하고 기본 사용 예시를 보여줘"
}
```

---

## WebSearch 도구

### 기능

웹을 검색하여 제목, URL, 모델 합성 요약을 포함한 결과를 반환합니다.

### 가용성

미국 내에서만 지원 (Anthropic, Vertex AI 또는 Foundry 호환 API 필요)

### 매개변수

| 이름 | 타입 | 필수 | 설명 |
|------|------|------|------|
| query | 문자열 | O | 검색 쿼리 (최소 2자) |
| allowed_domains | 문자열 배열 | - | 특정 도메인만 결과 포함 |
| blocked_domains | 문자열 배열 | - | 특정 도메인 제외 |

**주의**: `allowed_domains`과 `blocked_domains`은 동시에 사용 불가

### 출력 형식

- 결과 제목 및 URL
- 모델이 생성한 합성 요약
- 필수: 응답에 `Sources:` 섹션으로 출처 명시

### 도메인 필터링 예시

**신뢰할 수 있는 소스만 허용**
```json
{
  "query": "Python asyncio 모범 사례 2024",
  "allowed_domains": ["docs.python.org", "realpython.com"]
}
```

**저품질 소스 제외**
```json
{
  "query": "React 서버 컴포넌트 튜토리얼",
  "blocked_domains": ["medium.com"]
}
```

### 검색 한계

- 호출당 최대 8회 개별 웹 검색 수행
- Claude가 필요시 자동으로 쿼리 정제

### 연도 인식

최신 정보 검색 시 자동으로 현재 연도를 포함하여 오래된 결과 방지
