# Baby Letter (아기의 편지)

아기가 보내는 1인칭 편지로 발달 과학을 전달하고, 판단 없이 기록하는 육아 앱.

## 도메인 컨텍스트

- 타겟: 임신 중 ~ 영유아 부모 (엄마 + 아빠)
- 핵심 가치: 판단하지 않는 육아. 아기 시점의 편지로 과학 기반 발달 정보 전달
- UX 원칙: 감성적 톤, 따뜻한 1인칭 서술 ("엄마, 나 오늘 이만큼 자랐어")
- 삼각형 케어: 엄마 + 아빠 + 아기 관점 균형
- Bundle ID: `com.ystech.babyletter`

## 기능 구조

```
lib/features/
├── onboarding/     # Progressive Profiling (임신 중/출산 후 분기, 3문항)
├── home/           # 메인 — 태아 성장 영상, 아기의 편지, 발달 팁
├── growth/         # 성장 기록 (주차별/월별 트래킹)
├── record/         # 일상 기록 (수유, 수면, 기저귀 등)
├── us/             # 부모 케어 ("우리" 탭)
└── settings/       # 설정
```

## 주의사항

- 임신 중 vs 출산 후 UX가 완전히 다름 — 온보딩에서 분기
- 태아 성장 영상: 47개 (1080x1080 루프), 로컬 asset 아님 → CDN
- Serve & Return 실천 가이드: 과학 출처 필수 표기
- 4th Trimester 준비 콘텐츠: 30주 이후 활성화

## 참고 문서

@specs/REQUIREMENTS.md
@specs/DESIGN.md
@specs/ROADMAP.md
