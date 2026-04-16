# Baby Growth Video — 태아 발달 AI 캐릭터 영상 프로젝트

## 목표
임신 40주(280일) 태아 발달을 AI 아트 스타일로 캐릭터화하고,
주차별 7초 심리스 루핑 영상을 제작하여 앱 메인화면에 적용한다.

## 3-Zone 구조

| Zone | 구간 | 세분화 | 폴더 수 | 예상 이미지 |
|------|------|--------|---------|-----------|
| **A** | Week 1-8 | Carnegie Stage (23단계, ~2일) | 23 | 150-200장 |
| **B** | Week 9-24 | 주차 단위 | 16 | 50-80장 |
| **C** | Week 25-40 | 2주 묶음 | 8 | 20-30장 |
| | **합계** | | **47** | **220-310장** |

## 폴더 구조

```
references/
  zone_a_embryo/       ← Carnegie Stage 1-23 (Day 1~56)
  zone_b_fetus_early/  ← Week 9-24
  zone_c_fetus_late/   ← Week 25-40
selected/              ← 주차당 최종 선택 1장
generated/             ← AI 변환 이미지
videos/                ← 루핑 영상 (7초, MP4)
```

## 파이프라인

```
1. 레퍼런스 수집 (source.md 가이드 따라 다운로드)
   ↓
2. 주차당 1장 선택 → selected/ 폴더로 복사
   ↓
3. Midjourney로 AI 캐릭터화 (prompt_log.md 참고)
   ↓
4. Kling AI로 7초 루핑 영상 변환
   ↓
5. 앱에 탑재
```

## 주요 소스

| 소스 | URL | 용도 |
|------|-----|------|
| EHD.org | https://www.ehd.org/prenatal-images-index.php | Zone A, B 주력 |
| Carnegie Atlas (UNSW) | https://embryology.med.unsw.edu.au/embryology/index.php/Carnegie_Stages | Stage 매핑 |
| 3D Embryo Atlas | https://www.3dembryoatlas.com/ | 3D 참고 |
| Lennart Nilsson | https://webneel.com/embryo-fetus-photos-lennart-nilsso | 감성 레퍼런스 |
| 3D 초음파 | https://www.alittleinsight.com/by-week | Zone B, C |
| Wikimedia Commons | https://commons.wikimedia.org/wiki/Category:Fetal_development | CC 라이선스 |

## 저작권 주의

- 수집한 이미지는 **AI 변환의 레퍼런스 용도만**
- 앱에 직접 사용 금지
- 최종 앱에는 AI 생성 이미지만 탑재

## 진행 체크리스트

### Phase 1: 핵심 6개 주차 (우선)
- [ ] Stage 1 (Week 1) — 수정란
- [ ] Stage 2-4 (Week 2) — 세포 분열/착상
- [ ] Stage 10 (Week 4) — 심장 박동
- [ ] Stage 23 (Week 8) — 배아→태아
- [ ] Week 12 — 얼굴 완성
- [ ] Week 16 — 손으로 탐색
- [ ] 6개 AI 이미지 생성 테스트
- [ ] 6개 루핑 영상 생성 테스트

### Phase 2: 전체 확장
- [ ] Zone A 전체 (23 stages) 이미지 수집
- [ ] Zone B 전체 (16주) 이미지 수집
- [ ] Zone C 전체 (8구간) 이미지 수집
- [ ] 40주 전체 AI 캐릭터 생성
- [ ] 40주 전체 루핑 영상 생성
