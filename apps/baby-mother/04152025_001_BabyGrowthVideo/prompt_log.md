# Prompt Log — AI 이미지 & 영상 생성 프롬프트

## 1. Midjourney 베이스 프롬프트

### 공통 스타일 키워드
```
ethereal digital art, warm amber glow, amniotic fluid lighting,
soft bokeh background, medical illustration meets fantasy art,
gentle warm tones, macro photography style, --ar 1:1 --v 6
```

### --sref 전략 (스타일 일관성)
1. Phase 1에서 Stage 1 이미지를 먼저 생성
2. 마음에 드는 결과의 `--sref [URL]` 추출
3. 이후 모든 주차에 동일 `--sref` 적용
4. **핵심: 세포 → 사람 형태 변화가 있어도 색감/분위기/질감 통일**

### Zone별 프롬프트 템플릿

#### Zone A (Stage 1-23, 배아기)
```
[Stage 설명], ethereal digital art style, warm amber amniotic fluid,
soft glowing light from within, macro perspective, floating in warm liquid,
medical illustration meets dream-like fantasy, --sref [기준URL] --ar 1:1 --v 6
```

**Stage별 키워드 예시:**

| Stage | 추가 키워드 |
|-------|-----------|
| 1 | single luminous sphere, transparent zona pellucida, two pronuclei glowing inside |
| 2-3 | dividing cells, 2-4-8 cell cluster, each cell distinct and glowing |
| 3 | mulberry-shaped morula, 16 cells clustering together |
| 4 | blastocyst hatching from shell, inner glow breaking free |
| 5 | tiny light nestling into soft pink wall, implantation |
| 6-7 | abstract disk with three glowing layers, neural plate forming |
| 8 | tiny C-shaped form, first tube heart forming, neural tube |
| 9 | **heartbeat glow**, S-curved embryo, rhythmic red pulse |
| 10 | C-curved embryo with arm buds sprouting |
| 11-12 | leg buds, hand plate forming, paddle-shaped limbs |
| 13-16 | eye lens forming, face emerging, finger plate |
| 17-19 | fingers separating, eyelids forming, elbows visible |
| 20-23 | **human form complete**, fingers separated, eyelids closing |

#### Zone B (Week 9-24, 태아 초기)
```
[주차 설명], cute fetus character, warm amniotic fluid lighting,
translucent skin showing development, peaceful floating pose,
ethereal digital art, soft warm glow, --sref [기준URL] --ar 1:1 --v 6
```

**주차별 키워드 예시:**

| Week | 추가 키워드 |
|------|-----------|
| 9-10 | clear face features, individual finger movement, closed eyelids |
| 11-12 | **face complete**, yawning, tiny fingernails starting |
| 13-14 | bones hardening, fingerprints forming, hair pattern |
| 15-16 | **hands exploring**, grabbing umbilical cord, facial expressions |
| 17-18 | toenails growing, **hearing sounds**, ears in final position |
| 19-20 | vernix coating, **quickening movement**, lanugo hair |
| 21-22 | rapid growth, wrinkled skin, eyebrows visible |
| 23-24 | **viability threshold**, red wrinkled skin, REM sleep |

#### Zone C (Week 25-40, 태아 후기)
```
[주차 설명], chubby baby character, warm golden lighting,
peaceful sleeping or gentle movement, ready for the world,
ethereal digital art, soft dreamy glow, --sref [기준URL] --ar 1:1 --v 6
```

**구간별 키워드 예시:**

| Weeks | 추가 키워드 |
|-------|-----------|
| 25-26 | eyes starting to open, startle reflex, lung development |
| 27-28 | **eyes open**, brain folds forming, active REM sleep |
| 29-30 | fat layer growing, temperature regulation, chubby cheeks starting |
| 31-32 | fingernails reach fingertips, lanugo falling off, plump |
| 33-34 | immune system developing, sleep-wake cycle, lungs maturing |
| 35-36 | head down position, lots of fat, smooth skin |
| 37-38 | **full term**, all organs ready, vernix decreasing |
| 39-40 | **ready for birth**, average 3.2kg, peaceful and complete |

---

## 2. Kling AI 모션 프롬프트

### 공통 설정
- **길이**: 7초
- **루핑**: Start Frame = End Frame (심리스 루프)
- **해상도**: 1080x1080 (1:1)
- **모델**: Kling 2.0

### 모션 타입별 템플릿

#### Type A: 부유 (Stage 1-7, 미시적 단계)
```
Gentle floating motion in warm amber fluid, soft rotation,
internal light pulsing slowly, particles drifting,
seamless loop, calm and ethereal
```

#### Type B: 심장 박동 (Stage 8-23)
```
Gentle heartbeat pulse glowing from center, subtle body sway,
floating in warm amniotic fluid, rhythmic light pulse,
seamless loop, peaceful and alive
```

#### Type C: 미세 움직임 (Week 9-16)
```
Subtle hand/finger movement, gentle floating,
occasional stretch or yawn, eyes closed peacefully,
warm fluid environment, seamless loop
```

#### Type D: 활발한 움직임 (Week 17-24)
```
Baby gently moving hands and feet, exploring with fingers,
grabbing umbilical cord, facial expressions changing,
floating in warm space, seamless loop
```

#### Type E: 평화로운 수면 (Week 25-32)
```
Peaceful sleeping baby, gentle breathing movement,
occasional REM eye movement, soft body shift,
warm golden glow, seamless loop
```

#### Type F: 출산 준비 (Week 33-40)
```
Calm full-term baby in head-down position,
gentle breathing, peaceful expression,
soft warm light, ready for the world, seamless loop
```

---

## 3. 품질 체크리스트

### Midjourney 이미지 검수
- [ ] 스타일 일관성 (--sref 동일 적용)
- [ ] 해부학적 정확성 (주차에 맞는 발달 단계)
- [ ] 색감 통일 (따뜻한 앰버/금빛 톤)
- [ ] 배경 일관성 (양수 느낌)
- [ ] 해상도 1024x1024 이상
- [ ] 불쾌한 골짜기(uncanny valley) 회피

### Kling AI 영상 검수
- [ ] 7초 심리스 루핑 (끊김 없음)
- [ ] 모션 자연스러움
- [ ] 시작/끝 프레임 일치
- [ ] 해상도 1080x1080
- [ ] 파일 크기 500KB~1MB

---

## 4. 파일 명명 규칙

### 이미지
```
selected/stage_01_zygote.png
selected/stage_09_heartbeat.png
selected/week_12_face_complete.png
selected/week_20_quickening.png
selected/week_39-40_birth_ready.png
```

### AI 생성 이미지
```
generated/stage_01_zygote_mj.png
generated/week_12_face_complete_mj.png
```

### 영상
```
videos/stage_01_zygote_7s.mp4
videos/week_12_face_complete_7s.mp4
videos/week_39-40_birth_ready_7s.mp4
```

---

## 5. 예상 비용

| 항목 | 수량 | 단가 | 소계 |
|------|------|------|------|
| Midjourney v6 | 47장 × 4회 시도 | $10/월 Basic | ~$10 |
| Kling AI 2.0 | 47개 × 2회 시도 | $20/100크레딧 | ~$20 |
| **합계** | | | **~$30-40** |
