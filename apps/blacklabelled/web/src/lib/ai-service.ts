"use server";

import { createSupabaseServerClient } from "./supabase-server";

// ── Constants ───────────────────────────────────────────

const GEMINI_API_BASE =
  "https://generativelanguage.googleapis.com/v1beta/models";

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL!;

function getImageUrl(storagePath: string): string {
  if (!storagePath) return "";
  if (storagePath.startsWith("http")) return storagePath;
  return `${SUPABASE_URL}/storage/v1/object/public/blacklabelled/${storagePath}`;
}

// ── Gemini API helpers ──────────────────────────────────

async function callGemini(
  prompt: string,
  model = "gemini-2.5-flash"
): Promise<string> {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) throw new Error("GEMINI_API_KEY is not configured");

  const url = `${GEMINI_API_BASE}/${model}:generateContent?key=${apiKey}`;

  const res = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      contents: [{ parts: [{ text: prompt }] }],
    }),
  });

  if (!res.ok) {
    const body = await res.text();
    throw new Error(`Gemini API error (${res.status}): ${body}`);
  }

  const data = await res.json();
  return data.candidates?.[0]?.content?.parts?.[0]?.text ?? "";
}

async function callGeminiVision(
  prompt: string,
  imageUrl: string,
  model = "gemini-2.5-flash"
): Promise<string> {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) throw new Error("GEMINI_API_KEY is not configured");

  // Download image and convert to base64
  const imageRes = await fetch(imageUrl);
  if (!imageRes.ok) {
    throw new Error(`Failed to fetch image: ${imageRes.status}`);
  }

  const arrayBuffer = await imageRes.arrayBuffer();
  const base64 = Buffer.from(arrayBuffer).toString("base64");
  const contentType = imageRes.headers.get("content-type") || "image/jpeg";

  const url = `${GEMINI_API_BASE}/${model}:generateContent?key=${apiKey}`;

  const res = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      contents: [
        {
          parts: [
            { text: prompt },
            { inline_data: { mime_type: contentType, data: base64 } },
          ],
        },
      ],
    }),
  });

  if (!res.ok) {
    const body = await res.text();
    throw new Error(`Gemini Vision API error (${res.status}): ${body}`);
  }

  const data = await res.json();
  return data.candidates?.[0]?.content?.parts?.[0]?.text ?? "";
}

// ── Tenant helper ───────────────────────────────────────

async function getTenantId(): Promise<string> {
  const supabase = await createSupabaseServerClient();
  const { data, error } = await supabase
    .from("tenants")
    .select("id")
    .eq("slug", "blacklabelled")
    .single();

  // Try blacklabelled schema's view of public.tenants
  if (error || !data) {
    // Fallback: query via the public-schema client
    const { createSupabaseServerClientPublic } = await import(
      "./supabase-server"
    );
    const pub = await createSupabaseServerClientPublic();
    const { data: d2, error: e2 } = await pub
      .from("tenants")
      .select("id")
      .eq("slug", "blacklabelled")
      .single();
    if (e2 || !d2) throw new Error("Tenant not found");
    return d2.id;
  }
  return data.id;
}

// ── Public Functions ────────────────────────────────────

/**
 * 1. Suggest blog post titles for a project.
 *    Supports "more" button via excludeTitles.
 */
export async function suggestTitles(params: {
  projectName: string;
  projectDescription: string;
  userMemo?: string;
  excludeTitles?: string[];
}): Promise<string[]> {
  const excludeClause =
    params.excludeTitles && params.excludeTitles.length > 0
      ? `\n\n이미 제안된 제목 (이 목록의 제목은 제외하고 새로운 것만 제안해주세요):\n${params.excludeTitles.map((t) => `- ${t}`).join("\n")}`
      : "";

  const memoClause = params.userMemo
    ? `\n\n사용자 메모:\n${params.userMemo}`
    : "";

  const prompt = `당신은 인테리어 디자인 전문 매거진 에디터입니다. BlackLabelled는 프리미엄 인테리어 디자인 스튜디오입니다.

아래 프로젝트 정보를 기반으로 네이버 블로그 포스트 제목 5개를 제안해주세요.

프로젝트명: ${params.projectName}
프로젝트 설명: ${params.projectDescription}${memoClause}${excludeClause}

제목 규칙:
- 한국어로 작성
- 15~25자
- SEO 친화적 (핵심 키워드를 앞에 배치)
- [지역명/프로젝트명] + [핵심 설명] + [부가 정보] 구조
- 클릭베이트/특수문자 남용 금지

정확히 5개의 제목만 줄바꿈으로 구분하여 출력해주세요. 번호나 기호 없이 제목만 출력하세요.`;

  const result = await callGemini(prompt);
  return result
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line.length > 0)
    .slice(0, 5);
}

/**
 * 2. Analyze a product image using Gemini Vision (with caching).
 */
export async function analyzeProductImage(
  imageStoragePath: string,
  imageId: string
): Promise<string> {
  const supabase = await createSupabaseServerClient();
  const tenantId = await getTenantId();

  // Check cache first
  const { data: cached } = await supabase
    .from("ai_analysis_cache")
    .select("analysis")
    .eq("target_type", "product_image")
    .eq("target_id", imageId)
    .eq("model", "gemini-2.5-flash")
    .single();

  if (cached?.analysis) {
    return typeof cached.analysis === "string"
      ? cached.analysis
      : JSON.stringify(cached.analysis);
  }

  // Call Gemini Vision
  const fullUrl = getImageUrl(imageStoragePath);
  const analysis = await callGeminiVision(
    "이 인테리어 사진을 분석해주세요. 공간의 특징, 사용된 자재, 디자인 스타일, 색상 톤, 분위기를 전문적으로 설명해주세요. 블로그 글 작성에 활용할 수 있도록 2~3문단으로 작성해주세요.",
    fullUrl
  );

  // Save to cache
  await supabase.from("ai_analysis_cache").insert({
    tenant_id: tenantId,
    target_type: "product_image",
    target_id: imageId,
    analysis: analysis,
    model: "gemini-2.5-flash",
  });

  return analysis;
}

/**
 * 3. Generate a full blog post (HTML) for Naver blog.
 *    Uses naver blog template rules for formatting.
 */
export async function generateBlogPost(params: {
  title: string;
  projectName: string;
  projectDescription: string;
  imageAnalyses: { path: string; analysis: string }[];
  userMemo?: string;
}): Promise<{ html: string; tags: string[]; keywords: string[] }> {
  const imageSection = params.imageAnalyses
    .map(
      (img, i) =>
        `사진 ${i + 1}: ${img.analysis}\n  이미지 URL: ${getImageUrl(img.path)}`
    )
    .join("\n\n");

  const memoClause = params.userMemo
    ? `\n\n사용자 추가 메모:\n${params.userMemo}`
    : "";

  const prompt = `당신은 BlackLabelled 인테리어 디자인 스튜디오의 전문 블로그 에디터입니다.
아래 정보를 바탕으로 네이버 블로그 포스트를 작성해주세요.

제목: ${params.title}
프로젝트명: ${params.projectName}
프로젝트 설명: ${params.projectDescription}

사진 분석 결과:
${imageSection}${memoClause}

===== HTML 작성 규칙 =====

1. 글 구조 (14단계 흐름):
   (1) 임팩트 오프닝 (큰 텍스트 + 이모지)
   (2) 개성 구분선 (유니코드 장식)
   (3) 인트로 텍스트 (프로젝트 배경, 2~3문장)
   (4) 대표 이미지
   (5) 정보 카드 (테두리 박스 - 프로젝트 기본 정보)
   (6) 공간별 설명
   (7) 사진들 (분석된 이미지 사용)
   (8) 디자인 본문 (전문적 설명)
   (9) 추가 사진들
   (10) TIP/포인트 콜아웃 박스
   (11) 총평
   (12) 마무리 + 독자 소통 유도
   (13) 해시태그 (가운데 정렬, 회색)

2. HTML 기술 규칙:
   필수 사용:
   - <b>, <i>, <u> 텍스트 서식
   - <span style="color:..."> 색상 강조
   - <span style="background-color:..."> 형광펜
   - border-left + background 인용구/콜아웃 박스
   - border + background 정보 카드
   - <table> inline style 표
   - <hr> 구분선 + 유니코드 장식 구분선
   - 인라인 스타일만 사용

   절대 금지:
   - float, flex, display:flex
   - box-shadow, linear-gradient
   - border-radius:50%
   - background 단독 사용 (border 없이)
   - <s> 취소선
   - padding-left 들여쓰기
   - <details> 접기

3. 이미지 삽입:
   - 제공된 이미지 URL을 사용하여 <img> 태그로 직접 삽입
   - 형식: <p style="text-align:center;"><img src="이미지URL" style="max-width:100%;" /></p>
   - 이미지 아래 캡션: <p style="text-align:center; font-size:13px; color:#999;">설명</p>

4. SEO 규칙:
   - 본문 1,500자 이상
   - 키워드 밀도 1~2%
   - 키워드 위치: 첫 문단, 소제목, 마지막 문단

5. 가독성:
   - 한 문단 2~4문장
   - 텍스트 5~7줄마다 시각적 요소
   - 소제목 500~700자마다

6. 브랜드 가이드:
   - 브랜드명: BlackLabelled (블랙라벨드)
   - 슬로건: "Your space is 'black label'"
   - 브랜드 컬러: #C5A572 (골드), #1A1A1A (블랙), #FFFFFF (화이트)
   - 강조색으로 #2DB400 대신 #C5A572 (골드) 사용
   - 전문적이고 고급스러운 한국어 문체
   - 인테리어 전문 용어 적극 사용 (시공, 자재, 마감, 레이아웃, 동선 등)
   - 독자 호칭: "여러분" 또는 존칭

===== 출력 형식 =====

아래 형식으로 정확히 출력하세요:

---HTML_START---
(여기에 <body> 안의 HTML 콘텐츠만 출력. <!DOCTYPE>, <html>, <head>, <body> 태그 제외)
---HTML_END---

---TAGS_START---
태그1,태그2,태그3,태그4,태그5,태그6,태그7,태그8,태그9,태그10
---TAGS_END---

---KEYWORDS_START---
키워드1,키워드2,키워드3,키워드4,키워드5
---KEYWORDS_END---`;

  const result = await callGemini(prompt);

  // Parse HTML
  const htmlMatch = result.match(
    /---HTML_START---([\s\S]*?)---HTML_END---/
  );
  let html = htmlMatch?.[1]?.trim() ?? result;

  // Parse tags
  const tagsMatch = result.match(
    /---TAGS_START---([\s\S]*?)---TAGS_END---/
  );
  const tags = tagsMatch
    ? tagsMatch[1]
        .trim()
        .split(",")
        .map((t) => t.trim().replace(/^#/, ""))
        .filter(Boolean)
    : [];

  // Parse keywords
  const keywordsMatch = result.match(
    /---KEYWORDS_START---([\s\S]*?)---KEYWORDS_END---/
  );
  const keywords = keywordsMatch
    ? keywordsMatch[1]
        .trim()
        .split(",")
        .map((k) => k.trim())
        .filter(Boolean)
    : [];

  // If parsing failed (no markers), try to extract from raw result
  if (!htmlMatch) {
    // Remove any tag/keyword sections that might be at the end
    html = result
      .replace(/태그:.*$/m, "")
      .replace(/키워드:.*$/m, "")
      .trim();
  }

  return { html, tags, keywords };
}

/**
 * 4. Extract SEO metadata from existing HTML.
 */
export async function extractSEO(
  html: string
): Promise<{ tags: string[]; keywords: string[]; summary: string }> {
  const prompt = `아래 인테리어 블로그 HTML 콘텐츠를 분석하여 SEO 메타데이터를 추출해주세요.

HTML:
${html.substring(0, 5000)}

아래 형식으로 정확히 출력하세요:

---SUMMARY_START---
(블로그 내용 요약, 2~3문장)
---SUMMARY_END---

---TAGS_START---
태그1,태그2,태그3,태그4,태그5,태그6,태그7,태그8,태그9,태그10
---TAGS_END---

---KEYWORDS_START---
키워드1,키워드2,키워드3,키워드4,키워드5
---KEYWORDS_END---`;

  const result = await callGemini(prompt);

  const summaryMatch = result.match(
    /---SUMMARY_START---([\s\S]*?)---SUMMARY_END---/
  );
  const summary = summaryMatch?.[1]?.trim() ?? "";

  const tagsMatch = result.match(
    /---TAGS_START---([\s\S]*?)---TAGS_END---/
  );
  const tags = tagsMatch
    ? tagsMatch[1]
        .trim()
        .split(",")
        .map((t) => t.trim().replace(/^#/, ""))
        .filter(Boolean)
    : [];

  const keywordsMatch = result.match(
    /---KEYWORDS_START---([\s\S]*?)---KEYWORDS_END---/
  );
  const keywords = keywordsMatch
    ? keywordsMatch[1]
        .trim()
        .split(",")
        .map((k) => k.trim())
        .filter(Boolean)
    : [];

  return { tags, keywords, summary };
}

/**
 * 5. Inline edit — 전체 HTML 맥락을 유지하면서 선택된 부분만 수정
 */
export async function inlineEditHtml(params: {
  fullHtml: string;
  selectedText: string;
  userComment: string;
}): Promise<string> {
  const prompt = `당신은 BlackLabelled 인테리어 디자인 스튜디오의 전문 블로그 에디터입니다.

아래 블로그 HTML 전문에서, 유저가 선택한 부분을 유저의 요청에 맞게 수정해주세요.

===== 규칙 =====
1. 전체 글의 문맥, 톤, 스타일을 유지하면서 선택된 부분만 자연스럽게 수정
2. 나머지 HTML은 절대 변경하지 마세요
3. HTML 태그와 인라인 스타일은 기존 형식 유지
4. 네이버 블로그 HTML 규칙 준수 (flex, box-shadow 금지)
5. 수정된 전체 HTML을 반환

===== 전체 HTML =====
${params.fullHtml}

===== 유저가 선택한 텍스트 =====
${params.selectedText}

===== 유저의 수정 요청 =====
${params.userComment}

===== 출력 =====
수정된 전체 HTML만 출력하세요. 설명이나 주석 없이 HTML만 반환하세요.`;

  const result = await callGemini(prompt);

  // Clean up — remove markdown code fences if present
  return result
    .replace(/^```html?\n?/i, "")
    .replace(/\n?```$/i, "")
    .trim();
}
