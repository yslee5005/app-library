# PROMPT — BlackLabelled Web Phase 3: 3D Depth Gallery + Mapbox

> Ralph 자율 실행용 프롬프트
> 선행: Phase 1, 2 완료

---

## 목표

Three.js 3D Depth Gallery + Mapbox Dark 지도 + 전체 테스트

## 패키지 설치

```bash
npm install three @react-three/fiber @react-three/drei
npm install mapbox-gl
npm install @types/mapbox-gl
```

---

## 체크리스트

### 1. 3D Depth Gallery (components/DepthGallery.tsx)

Phase 2의 기본 이미지 갤러리를 3D Depth Gallery로 업그레이드.

**참고:** https://tympanus.net/Tutorials/DepthGallery/

**구현:**
- React Three Fiber 사용
- Canvas: 풀 너비, 높이 = 이미지 수 × 150vh (스크롤 길이)
- 각 이미지를 Three.js Plane으로 생성
- Z축에 일정 간격으로 배치 (z = -index * 150)
- 스크롤에 따라 카메라가 Z축으로 이동
- 스크롤 속도(velocity)에 반응:
  - 빠르면: 이미지 기울기 증가 + 밝기 변화
  - 느리면: 안정적
- 마우스 X/Y → 카메라 약간 이동 (parallax)
- 배경: 이미지별 무드 컬러 그라디언트 (간단히 어두운 색 전환)

**간소화된 구현 (현실적):**
```tsx
// DepthGallery.tsx
"use client";
import { Canvas, useFrame, useThree } from "@react-three/fiber";
import { Image, ScrollControls, useScroll } from "@react-three/drei";
import { useRef } from "react";
import * as THREE from "three";

function ImagePlane({ url, index, total }) {
  const ref = useRef();
  const scroll = useScroll();

  useFrame(() => {
    const scrollOffset = scroll.offset;
    const z = -index * 3 + scrollOffset * total * 3;
    ref.current.position.z = z;
    // velocity 기반 기울기
    const velocity = scroll.delta;
    ref.current.rotation.x = velocity * 2;
    // opacity (가까울수록 선명)
    ref.current.material.opacity = Math.max(0, 1 - Math.abs(z) / 5);
  });

  return (
    <Image ref={ref} url={url} scale={[4, 3]} transparent />
  );
}

export function DepthGallery({ images }) {
  return (
    <div style={{ height: "400vh", background: "#0A0A0A" }}>
      <Canvas camera={{ position: [0, 0, 5], fov: 50 }}>
        <ScrollControls pages={images.length / 3} damping={0.25}>
          {images.map((img, i) => (
            <ImagePlane key={i} url={img.url} index={i} total={images.length} />
          ))}
        </ScrollControls>
        <ambientLight intensity={0.5} />
      </Canvas>
    </div>
  );
}
```

- Project Detail의 GALLERY 섹션에서 이 컴포넌트 사용
- "use client" 필수 (Three.js는 클라이언트 전용)
- 이미지 URL: 이미 다운로드된 이미지 → API route로 serve
- fallback: Three.js 로딩 실패 시 기본 이미지 그리드 표시

### 2. Map 페이지 (app/map/page.tsx)

**Mapbox GL 통합:**

```tsx
"use client";
import mapboxgl from "mapbox-gl";
import "mapbox-gl/dist/mapbox-gl.css";

// .env.local에 NEXT_PUBLIC_MAPBOX_TOKEN 저장
mapboxgl.accessToken = process.env.NEXT_PUBLIC_MAPBOX_TOKEN;
```

**지도 설정:**
- 스타일: mapbox://styles/mapbox/dark-v11
- 중심: [127.1, 37.4] (성남/분당)
- 줌: 12
- 컨트롤: zoom만 (나침반 등 제거)

**핀 데이터:**
- products.json에서 상품 이름의 지역명 추출
- 간단한 지역→좌표 매핑 테이블:
  ```
  잠실: [127.0862, 37.5133]
  서현: [127.0549, 37.3843]
  야탑: [127.1273, 37.4116]
  정자: [127.1115, 37.3658]
  수내: [127.1148, 37.3768]
  단대: [127.1587, 37.4483]
  구미: [127.1066, 37.3500]
  이매: [127.1250, 37.3950]
  분당: [127.1200, 37.3800]
  성남: [127.1400, 37.4200]
  강남: [127.0276, 37.4979]
  서울: [126.9780, 37.5665]
  용인: [127.1775, 37.2410]
  동탄: [127.0736, 37.2000]
  ```
- 매칭 안 되면 성남 중심으로 기본 배치 (약간 랜덤 offset)

**커스텀 핀:**
- SVG 마커: 원형, 골드 (#C5A46C), 12px
- hover: 크기 증가 + 골드 glow

**팝업:**
- 핀 hover 시 Mapbox Popup:
  - 배경: #141414
  - 썸네일 (80x60)
  - 프로젝트명 (Pretendard 14px, white)
  - 카테고리 (Inter 10px, 골드)
  - "View Project →" 링크
- 핀 클릭 → router.push(`/projects/${slug}`)

**필터 패널 (좌측):**
- 반투명 다크 패널 (bg: rgba(10,10,10,0.9))
- 카테고리 필터 버튼들
- 선택 시: 핀 필터링 (선택된 카테고리만 표시)

**주의:**
- Mapbox token이 없으면 "지도를 표시하려면 Mapbox 토큰이 필요합니다" 안내
- .env.local.example에 NEXT_PUBLIC_MAPBOX_TOKEN=your_token_here 추가

### 3. SEO 메타 태그

각 페이지에 metadata export:
```tsx
export const metadata = {
  title: "Projects | BLACKLABELLED",
  description: "427개의 완성된 인테리어 프로젝트를 살펴보세요.",
  openGraph: {
    title: "BLACKLABELLED - Projects",
    description: "...",
    images: [{ url: "/og-image.jpg" }],
  },
};
```

Project Detail: generateMetadata로 동적 메타 태그

### 4. 전체 테스트

```bash
# 빌드 테스트
npm run build

# 린트
npm run lint

# 각 페이지 접근 테스트
# localhost:3000 → Home
# localhost:3000/projects → Projects
# localhost:3000/projects/잠실트리지움_532 → Detail
# localhost:3000/map → Map
# localhost:3000/about → About
# localhost:3000/process → Process
# localhost:3000/contact → Contact
```

---

## 환경 변수

`.env.local.example`:
```
NEXT_PUBLIC_MAPBOX_TOKEN=pk.your_mapbox_token_here
```

## 완료 조건

- [ ] 3D Depth Gallery: 스크롤로 이미지 깊이감 이동
- [ ] Map: Mapbox Dark + 골드 핀 + 팝업 + 필터
- [ ] 모든 페이지 빌드 성공 (`npm run build`)
- [ ] 모든 페이지 린트 통과 (`npm run lint`)
- [ ] 모바일 반응형 동작
- [ ] 이미지 lazy loading
- [ ] SEO 메타 태그
