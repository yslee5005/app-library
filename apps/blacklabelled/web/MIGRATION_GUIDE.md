# Next.js: data.ts → data-supabase.ts 전환 가이드

## 전환 방법

```bash
# 1. Supabase 패키지 설치
npm install @supabase/supabase-js

# 2. .env.local 생성
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...

# 3. 파일 교체
mv src/lib/data.ts src/lib/data-local.ts
mv src/lib/data-supabase.ts src/lib/data.ts
```

## 컴포넌트 수정 필요 (sync → async)

Supabase 버전의 모든 함수가 `async`이므로, 호출하는 페이지 컴포넌트에 `await` 추가 필요:

### app/page.tsx (Home)
```diff
- export default function Home() {
-   const featured = getFeaturedProducts(8);
-   const allProducts = getProducts();
+ export default async function Home() {
+   const featured = await getFeaturedProducts(8);
+   const allProducts = await getProducts();
```

### app/projects/page.tsx
```diff
- export default function ProjectsPage() {
-   const products = getDisplayProducts();
-   const categories = getFilterCategories();
+ export default async function ProjectsPage() {
+   const products = await getDisplayProducts();
+   const categories = await getFilterCategories();
```

### app/map/page.tsx
```diff
- export default function MapPage() {
-   const products = getMapProducts();
-   const categories = getFilterCategories();
+ export default async function MapPage() {
+   const products = await getMapProducts();
+   const categories = await getFilterCategories();
```

### app/projects/[slug]/page.tsx (이미 async)
```diff
  // generateStaticParams는 제거하거나 동적으로 변경
- export async function generateStaticParams() {
-   const products = getDisplayProducts();
+ export async function generateStaticParams() {
+   const products = await getDisplayProducts();

  // generateMetadata
-   const product = getProductBySlug(decodeURIComponent(slug));
+   const product = await getProductBySlug(decodeURIComponent(slug));

  // Page
-   const related = getRelatedProducts(product, 3);
-   const beforeAfter = getBeforeAfterPair(product);
-   const floorPlanImage = getFloorPlanImage(product);
+   const related = await getRelatedProducts(product, 3);
+   const beforeAfter = await getBeforeAfterPair(product);
+   const floorPlanImage = await getFloorPlanImage(product);
```

## 이미지 URL 변경

기존: 로컬 파일 경로 (`project/boutique/NES-인천_120/main.png`)
신규: Supabase Storage URL

```diff
- <Image src={`/images/${product.main_image}`} />
+ import { getImageUrl } from "@/lib/data";
+ <Image src={getImageUrl(product.main_image)} />
```

## 타입 변경 없음
Product, Category, ProductImage 인터페이스는 동일하게 유지됩니다.
