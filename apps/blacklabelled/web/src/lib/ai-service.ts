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

// ── BlackLabelled Brand Style Guide ─────────────────────

const BRAND_STYLE_GUIDE = `
===== BlackLabelled 브랜드 스타일 가이드 =====

1. 색상 팔레트:
   - 주요 강조: #C5A572 (골드) — 섹션 제목, 테두리, 하이라이트
   - 보조 강조: #8B7355 (다크 골드) — 미묘한 요소
   - 하이라이트 배경: #FAF6EE (따뜻한 크림) — 형광펜 대체
   - 정보 카드 배경: #FAF8F5 (따뜻한 라이트)
   - 콜아웃 박스: border-left: 5px solid #C5A572; background: #FAF6EE;
   - 본문 텍스트: #2C2C2C (다크 그레이, 순수 검정 아님)
   - 제목 텍스트: #1A1A1A

2. 타이포그래피 (인라인 스타일 필수 — 네이버 호환):
   - 본문: font-family: 'NanumSquare', 'Noto Sans KR', sans-serif; font-size: 15px; line-height: 1.9; color: #2C2C2C;
   - 섹션 제목: font-size: 20px; font-weight: bold; border-left: 5px solid #C5A572; padding-left: 12px; color: #1A1A1A;
   - 임팩트 오프닝: font-size: 26px; font-weight: bold; text-align: center; color: #C5A572;
   - 구분선: <p style="text-align:center; font-size:14px; color:#C5A572; letter-spacing:8px;">━━━ ◆ ━━━</p>
   - 하이라이트: <span style="background-color:#FAF6EE; padding:2px 4px;"><b>텍스트</b></span>
   - 인용/콜아웃 박스: <div style="border-left:5px solid #C5A572; padding:15px 20px; background:#FAF6EE; margin:20px 0;"><b>제목</b><br><br>내용</div>
   - 정보 표 셀: background:#FAF8F5; border:1px solid #E8E0D4;
   - 숫자 하이라이트: <span style="font-size:28px; font-weight:bold; color:#C5A572;">427+</span>
   - 캡션: <p style="text-align:center; font-size:13px; color:#999; font-style:italic;">▲ 캡션</p>
   - 해시태그: <p style="text-align:center; color:#B8A080; font-size:14px;">#인테리어 #블랙라벨드 ...</p>
   - 이미지: <p style="text-align:center; margin:25px 0;"><img src="URL" style="max-width:100%; border:1px solid #E8E0D4;" /></p>

3. 문체:
   - 전문적이고 고급스러운 ~습니다 체
   - 인테리어 전문 용어 적극 활용 (공간, 마감, 자재, 동선, 시공 등)
   - 독자: "여러분" 존칭
   - 브랜드명: BlackLabelled (블랙라벨드)
   - 슬로건: "Your space is 'black label'"

4. HTML 기술 규칙:
   필수 사용:
   - <b>, <i>, <u> 텍스트 서식
   - <span style="color:..."> 색상 강조
   - <span style="background-color:#FAF6EE; padding:2px 4px;"> 하이라이트 (형광펜 대체)
   - border-left + background 인용구/콜아웃 박스
   - border + background 정보 카드
   - <table> inline style 표 (셀 배경: #FAF8F5, 테두리: #E8E0D4)
   - 인라인 스타일만 사용

   절대 금지:
   - float, flex, display:flex
   - box-shadow, linear-gradient
   - border-radius:50%
   - background 단독 사용 (border 없이)
   - <s> 취소선
   - padding-left 들여쓰기
   - <details> 접기
   - #2DB400 (네이버 초록) 사용 금지 → #C5A572 (골드) 사용
`;

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

// ── 3-Step Blog Generation ──────────────────────────────

/**
 * Step A: Generate a blog outline with 4-6 sections.
 * Fast (~5 seconds) because it only generates structure, no full content.
 */
export async function generateBlogOutline(params: {
  title: string;
  projectName: string;
  projectDescription: string;
  imageCount: number;
  userMemo?: string;
}): Promise<{
  sections: { title: string; description: string; imageIndices: number[] }[];
}> {
  const memoClause = params.userMemo
    ? `\n\n사용자 추가 메모:\n${params.userMemo}`
    : "";

  const prompt = `당신은 BlackLabelled 인테리어 디자인 스튜디오의 전문 블로그 에디터입니다.

아래 프로젝트 정보를 바탕으로 네이버 블로그 포스트의 목차(outline)를 생성해주세요.

제목: ${params.title}
프로젝트명: ${params.projectName}
프로젝트 설명: ${params.projectDescription}
사용 가능한 이미지 수: ${params.imageCount}장 (인덱스 0~${params.imageCount - 1})${memoClause}

===== 규칙 =====
- 4~6개 섹션으로 구성
- 첫 번째 섹션: 임팩트 오프닝 + 인트로 + 대표 이미지 + 프로젝트 정보 카드
- 중간 섹션들: 공간별/주제별 디자인 분석 (각각 이미지 포함)
- 마지막 섹션: 총평 + 마무리 + 해시태그
- 각 섹션에 들어갈 이미지 인덱스를 배정 (모든 이미지가 최소 1번은 사용되도록)

===== 출력 형식 (JSON만 출력) =====
\`\`\`json
[
  {
    "title": "섹션 제목",
    "description": "이 섹션에서 작성할 내용 설명 (2~3문장)",
    "imageIndices": [0, 1]
  }
]
\`\`\`

JSON 배열만 출력하세요. 다른 설명은 불필요합니다.`;

  const result = await callGemini(prompt);

  // Parse JSON from response
  const jsonMatch = result.match(/\[[\s\S]*\]/);
  if (!jsonMatch) {
    throw new Error("Failed to parse outline JSON from AI response");
  }

  try {
    const sections = JSON.parse(jsonMatch[0]) as {
      title: string;
      description: string;
      imageIndices: number[];
    }[];
    return { sections };
  } catch {
    throw new Error("Failed to parse outline JSON: invalid format");
  }
}

/**
 * Step B: Generate HTML for ONE section of the blog post.
 * Each call takes ~8 seconds, well within Vercel's 10s limit.
 */
export async function generateBlogSection(params: {
  sectionIndex: number;
  sectionTitle: string;
  sectionDescription: string;
  projectName: string;
  projectDescription: string;
  imageAnalyses: { path: string; analysis: string }[];
  blogTitle: string;
  isFirst: boolean;
  isLast: boolean;
  userMemo?: string;
}): Promise<string> {
  const imageSection = params.imageAnalyses
    .map(
      (img, i) =>
        `이미지 ${i + 1}: ${img.analysis}\n  URL: ${getImageUrl(img.path)}`
    )
    .join("\n\n");

  const memoClause = params.userMemo
    ? `\n\n사용자 추가 메모:\n${params.userMemo}`
    : "";

  const positionGuide = params.isFirst
    ? `이 섹션은 블로그의 첫 번째 섹션입니다. 반드시 포함:
   1. 임팩트 오프닝 (큰 텍스트, 가운데 정렬, 골드색)
      예: <p style="font-size:26px; font-weight:bold; text-align:center; color:#C5A572;">공간의 가치를 완성하다</p>
   2. 장식 구분선
      예: <p style="text-align:center; font-size:14px; color:#C5A572; letter-spacing:8px;">━━━ ◆ ━━━</p>
   3. 인트로 텍스트 (프로젝트 배경, 2~3문장, 본문 스타일)
   4. 이미지들 (캡션 포함)
   5. 프로젝트 정보 카드 (테이블 형식, 프로젝트명/위치/면적/스타일 등)`
    : params.isLast
      ? `이 섹션은 블로그의 마지막 섹션입니다. 반드시 포함:
   1. 섹션 본문 (총평 느낌으로)
   2. 마무리 메시지 + 독자 소통 유도 (콜아웃 박스)
   3. 해시태그 (가운데 정렬, #B8A080 색)
      예: <p style="text-align:center; color:#B8A080; font-size:14px;">#인테리어 #블랙라벨드 #인테리어디자인 ...</p>`
      : `이 섹션은 블로그의 중간 섹션입니다. 반드시 포함:
   1. 섹션 제목 (왼쪽 골드 보더)
      예: <p style="font-size:20px; font-weight:bold; border-left:5px solid #C5A572; padding-left:12px; color:#1A1A1A;">섹션 제목</p>
   2. 본문 텍스트 (2~4문단, 전문적)
   3. 이미지들 (캡션 포함)
   4. 하이라이트 또는 콜아웃 박스 (최소 1개)`;

  const prompt = `당신은 BlackLabelled 인테리어 디자인 스튜디오의 전문 블로그 에디터입니다.
블로그 포스트의 한 섹션 HTML을 작성해주세요.

===== 블로그 정보 =====
블로그 제목: ${params.blogTitle}
프로젝트명: ${params.projectName}
프로젝트 설명: ${params.projectDescription}

===== 이 섹션 정보 =====
섹션 번호: ${params.sectionIndex + 1}
섹션 제목: ${params.sectionTitle}
작성 지침: ${params.sectionDescription}

이 섹션에 사용할 이미지:
${imageSection || "(이미지 없음)"}${memoClause}

===== 섹션 위치 가이드 =====
${positionGuide}

${BRAND_STYLE_GUIDE}

===== SEO 규칙 =====
- 각 섹션 최소 300자 이상
- 키워드(프로젝트명, 인테리어 관련 용어) 자연스럽게 포함
- 한 문단 2~4문장
- 텍스트 5~7줄마다 시각적 요소 (이미지, 콜아웃, 하이라이트 등)

===== 출력 =====
이 섹션의 HTML만 출력하세요. 마커나 설명 없이 순수 HTML만 반환하세요.
<body> 안의 콘텐츠만 (<!DOCTYPE>, <html>, <head>, <body> 태그 제외).
모든 스타일은 인라인으로 작성하세요.`;

  const result = await callGemini(prompt);

  // Clean up — remove markdown code fences if present
  return result
    .replace(/^```html?\n?/i, "")
    .replace(/\n?```$/i, "")
    .trim();
}

/**
 * Generate tags and keywords for the blog post.
 */
export async function generateTagsAndKeywords(params: {
  title: string;
  projectName: string;
}): Promise<{ tags: string[]; keywords: string[] }> {
  const prompt = `당신은 BlackLabelled 인테리어 디자인 스튜디오의 SEO 전문가입니다.

아래 블로그 정보를 바탕으로 네이버 블로그용 태그와 SEO 키워드를 생성해주세요.

블로그 제목: ${params.title}
프로젝트명: ${params.projectName}

===== 규칙 =====
태그: 10개, 네이버 블로그 해시태그용 (# 없이)
키워드: 5개, SEO 검색 키워드 (롱테일 포함)

===== 출력 형식 =====

---TAGS_START---
태그1,태그2,태그3,태그4,태그5,태그6,태그7,태그8,태그9,태그10
---TAGS_END---

---KEYWORDS_START---
키워드1,키워드2,키워드3,키워드4,키워드5
---KEYWORDS_END---`;

  const result = await callGemini(prompt);

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

  return { tags, keywords };
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

${BRAND_STYLE_GUIDE}

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
