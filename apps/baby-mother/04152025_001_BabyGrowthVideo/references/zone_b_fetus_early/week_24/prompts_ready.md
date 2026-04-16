# Week 24 — AI Generation Prompts (Ready to Use)

> 생존 가능 경계, 미각 발달, REM 수면
> 크기: ~30cm | Zone B | Motion Type D (활발한 움직임)

---

## 1. Midjourney 프롬프트 (Discord에 복붙)

### Prompt V1 — 메인 (꿈꾸는 여행자)
```
A 24-week fetus floating peacefully in warm amniotic fluid,
viability threshold milestone, eyelids partially opening for the first time,
sensing soft golden light, wrinkled translucent skin with amber glow,
REM sleep with subtle rapid eye movement beneath thin eyelids,
warm amber gold and soft coral tones, pale dawn-blue light around eyes,
ethereal digital art style, macro perspective, medical illustration meets
dream-like fantasy, soft bokeh background, gentle warm lighting
--sref [기준URL] --ar 1:1 --v 6
```

### Prompt V2 — 감각 강조 (미각 발달)
```
A cute 24-week fetus character tasting amniotic fluid with a gentle smile,
taste buds developing, sweet flavor preference reaction,
floating in warm amber-gold amniotic space, eyes partially open,
surfactant production in tiny lungs, wrinkled but becoming opaque skin,
dreamy traveler ready for the outside world, coral and amber color palette,
ethereal digital art, soft glowing light from within, peaceful expression
--sref [기준URL] --ar 1:1 --v 6
```

### Prompt V3 — 청각 반응 (음악/목소리)
```
A 24-week fetus responding to external music and mother's voice,
enhanced hearing with ears fully formed, gentle startle response,
REM sleep pattern established, dreaming in warm golden light,
floating in amniotic fluid with soft coral undertones,
eyelids beginning to open, viability threshold reached,
ethereal digital art style, warm amber atmosphere,
medical illustration meets fantasy, macro photography style
--sref [기준URL] --ar 1:1 --v 6
```

### 사용법
1. `--sref [기준URL]` → Stage 1에서 확정한 스타일 레퍼런스 URL로 교체
2. 3개 프롬프트 모두 실행 → 각각 4장 생성됨 (총 12장)
3. 가장 좋은 1장 선택 → Upscale (U1-U4)
4. 다운로드 → `week_24/selected/week_24_final.png`로 저장

---

## 2. Kling AI 모션 프롬프트

### 비디오 설정
| 항목 | 값 |
|------|-----|
| 모델 | Kling 3.0 (또는 최신) |
| 길이 | 7초 |
| 해상도 | 1080x1080 (1:1) |
| Start Frame | Midjourney에서 선택한 이미지 |
| End Frame | Start Frame과 동일 (루프용) |

### Motion Prompt (Type D: 활발한 움직임 + REM 수면 커스텀)
```
Baby gently opening eyelids slightly, sensing warm golden light,
rapid eye movement during REM sleep phase then peacefully falling asleep,
subtle hand movement near face, floating in warm amniotic fluid,
soft amber glow pulsing gently, coral-tinted environment,
smooth seamless loop, dreamy and ethereal atmosphere
```

### Motion Prompt 대안 (더 잔잔한 버전)
```
Peaceful 24-week fetus with eyelids flickering open briefly,
eyes moving rapidly in REM sleep then settling into calm rest,
gentle floating motion in warm amber-gold fluid,
soft breathing-like body movement, serene expression,
seamless 7-second loop, warm ethereal lighting
```

---

## 3. 품질 체크리스트

### Midjourney 이미지 검수
- [ ] 앰버 골드 + 코랄 색감 유지
- [ ] 눈꺼풀이 부분적으로 열린 모습 표현
- [ ] 주름진 피부 (24주 특징)
- [ ] 불쾌한 골짜기 회피 (너무 리얼하지 않게)
- [ ] 해상도 1024x1024 이상
- [ ] --sref 스타일 일관성

### Kling 비디오 검수
- [ ] 7초 심리스 루프 (시작=끝)
- [ ] REM 눈 움직임 자연스러움
- [ ] 눈꺼풀 열림 모션 부드러움
- [ ] 전체적 분위기 평온
- [ ] 색감 이미지와 일치

---

## 4. 파일 저장 규칙

```
week_24/
├── source.md              ← 이미 존재
├── prompts_ready.md       ← 이 파일
├── selected/
│   ├── week_24_v1.png     ← Midjourney 결과 (Prompt V1)
│   ├── week_24_v2.png     ← Midjourney 결과 (Prompt V2)
│   └── week_24_final.png  ← 최종 선택 (Upscale 완료)
└── videos/
    ├── week_24_raw.mp4    ← Kling AI 원본
    └── week_24_7s.mp4     ← ffmpeg 후처리 완료 (앱용)
```
