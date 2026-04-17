"use client";

import { useState, useTransition, useCallback } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import ProjectCombobox, { type ProjectItem } from "@/components/admin/ProjectCombobox";
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
} from "@/components/ui/card";
import { getImageUrl } from "@/lib/data";
import {
  getProductImages,
  createAIMagazine,
  publishMagazine,
} from "@/lib/admin-actions";
import {
  analyzeProductImage,
  generateBlogOutline,
  generateBlogSection,
  generateTagsAndKeywords,
  inlineEditHtml,
  enhanceMemo,
} from "@/lib/ai-service";
import { assembleBlogHtml, fixImageUrls } from "@/lib/blog-utils";
import ImagePickerMulti from "@/components/admin/ImagePickerMulti";

// ── Types ──────────────────────────────────────────────

interface ImageOption {
  id: string;
  storage_path: string;
  type: string;
  sort_order: number;
}

interface OutlineSection {
  title: string;
  description: string;
  imageIndices: number[];
}

type GenerationStepStatus = "pending" | "active" | "done" | "error";

interface GenerationStep {
  label: string;
  status: GenerationStepStatus;
}

// ── Component ──────────────────────────────────────────

export default function NewMagazineClient() {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();

  // Wizard state — 3 steps
  const [currentStep, setCurrentStep] = useState(1);
  const totalSteps = 3;

  // Step 1: Project selection
  const [selectedProductId, setSelectedProductId] = useState("");
  const [selectedProduct, setSelectedProduct] = useState<ProjectItem | null>(null);
  const [productImages, setProductImages] = useState<ImageOption[]>([]);
  const [productImagesTotal, setProductImagesTotal] = useState(0);
  const [selectedImagePaths, setSelectedImagePaths] = useState<string[]>([]);
  const [loadingImages, setLoadingImages] = useState(false);

  // Step 1: Title
  const [customTitle, setCustomTitle] = useState("");

  // Step 1: Memo
  const [userMemo, setUserMemo] = useState("");
  const [enhancingMemo, setEnhancingMemo] = useState(false);

  // Step 1: Generation (multi-step progress)
  const [generating, setGenerating] = useState(false);
  const [generationSteps, setGenerationSteps] = useState<GenerationStep[]>([]);
  const [generationProgress, setGenerationProgress] = useState(0);
  const [generatedHtml, setGeneratedHtml] = useState("");
  const [generatedTags, setGeneratedTags] = useState<string[]>([]);
  const [generatedKeywords, setGeneratedKeywords] = useState<string[]>([]);

  // Step 2: Edit
  const [editHtml, setEditHtml] = useState("");
  const [editTags, setEditTags] = useState<string[]>([]);
  const [editKeywords, setEditKeywords] = useState<string[]>([]);
  const [newTag, setNewTag] = useState("");
  const [newKeyword, setNewKeyword] = useState("");

  // Inline AI edit
  const [selectedText, setSelectedText] = useState("");
  const [editComment, setEditComment] = useState("");
  const [showEditPopover, setShowEditPopover] = useState(false);
  const [editingInline, setEditingInline] = useState(false);

  // Derived
  const finalTitle = customTitle;
  const canGenerate =
    !!selectedProductId &&
    selectedImagePaths.length > 0 &&
    !!finalTitle.trim();

  // ── Helper: Update generation step status ──────────────

  const updateStep = (index: number, status: GenerationStepStatus) => {
    setGenerationSteps((prev) =>
      prev.map((s, i) => (i === index ? { ...s, status } : s))
    );
  };

  const updateStepLabel = (index: number, label: string) => {
    setGenerationSteps((prev) =>
      prev.map((s, i) => (i === index ? { ...s, label } : s))
    );
  };

  // ── Inline AI Edit Handler ───────────────────────────

  const handleInlineEdit = async () => {
    if (!editComment.trim() || !selectedText.trim()) return;
    setEditingInline(true);
    try {
      const updatedHtml = await inlineEditHtml({
        fullHtml: editHtml,
        selectedText,
        userComment: editComment,
      });
      setEditHtml(updatedHtml);
      setShowEditPopover(false);
      toast.success("AI 수정 완료");
    } catch (err) {
      toast.error("AI 수정 실패: " + (err instanceof Error ? err.message : "Unknown error"));
    } finally {
      setEditingInline(false);
    }
  };

  // ── Handlers ──────────────────────────────────────────

  const handleSelectProduct = useCallback(
    async (productId: string, item: ProjectItem | null) => {
      setSelectedProductId(productId);
      setSelectedProduct(item);
      setSelectedImagePaths([]);
      setProductImages([]);
      setProductImagesTotal(0);

      if (!productId) return;

      setLoadingImages(true);
      try {
        const result = await getProductImages(productId, 0, 4);
        setProductImages(result.images);
        setProductImagesTotal(result.total);
      } catch {
        toast.error("Failed to load product images");
      } finally {
        setLoadingImages(false);
      }
    },
    []
  );

  const handleGenerate = useCallback(async () => {
    if (!selectedProduct || !finalTitle) return;

    setGenerating(true);
    setGenerationProgress(0);

    // Initialize steps: image analysis + outline + placeholder sections + tags
    const initialSteps: GenerationStep[] = [
      { label: "이미지 분석 중...", status: "active" },
      { label: "목차 생성 중...", status: "pending" },
    ];
    setGenerationSteps(initialSteps);

    try {
      // ── Phase 1: Analyze selected images only (parallel) ─────────
      const selectedImages = productImages.filter((img) =>
        selectedImagePaths.includes(img.storage_path)
      );
      updateStepLabel(0, `이미지 분석 중... (${selectedImages.length}장)`);
      const imageResults = await Promise.allSettled(
        selectedImages.map((img) =>
          analyzeProductImage(img.storage_path, img.id).then(
            (analysis) => ({ path: img.storage_path, analysis })
          )
        )
      );
      const imageAnalyses = imageResults
        .filter((r): r is PromiseFulfilledResult<{ path: string; analysis: string }> => r.status === "fulfilled")
        .map((r) => r.value);
      updateStep(0, "done");
      setGenerationSteps((prev) => {
        const updated = [...prev];
        updated[0] = { label: `이미지 분석 완료 (${imageAnalyses.length}장)`, status: "done" };
        return updated;
      });
      setGenerationProgress(10);

      // ── Phase 2: Generate outline ───────────────────
      updateStep(1, "active");
      const { sections: outline } = await generateBlogOutline({
        title: finalTitle,
        projectName: selectedProduct.name,
        projectDescription: selectedProduct.description ?? "",
        imageCount: imageAnalyses.length,
        userMemo: userMemo || undefined,
      });

      setGenerationSteps((prev) => {
        const updated = [...prev];
        updated[1] = { label: `목차 생성 완료 (${outline.length}개 섹션)`, status: "done" };
        // Add section steps + tags step
        const sectionSteps: GenerationStep[] = outline.map((s) => ({
          label: s.title,
          status: "pending" as GenerationStepStatus,
        }));
        return [
          ...updated,
          ...sectionSteps,
          { label: "태그/키워드 생성", status: "pending" },
        ];
      });
      setGenerationProgress(20);

      // ── Phase 3: Generate all sections in parallel ──
      const totalSections = outline.length;
      const sectionProgressShare = 60;
      let completedSections = 0;

      // Mark all sections as active
      for (let i = 0; i < totalSections; i++) {
        updateStep(i + 2, "active");
        updateStepLabel(i + 2, `${outline[i].title} (대기중)`);
      }

      const sectionPromises = outline.map((section, i) => {
        const sectionImages = section.imageIndices
          .filter((idx: number) => idx >= 0 && idx < imageAnalyses.length)
          .map((idx: number) => imageAnalyses[idx]);

        return generateBlogSection({
          sectionIndex: i,
          sectionTitle: section.title,
          sectionDescription: section.description,
          projectName: selectedProduct.name,
          projectDescription: selectedProduct.description ?? "",
          imageAnalyses: sectionImages,
          blogTitle: finalTitle,
          isFirst: i === 0,
          isLast: i === totalSections - 1,
          userMemo: userMemo || undefined,
        }).then((html) => {
          completedSections++;
          updateStep(i + 2, "done");
          updateStepLabel(i + 2, section.title);
          const sectionProgress = 20 + (completedSections / totalSections) * sectionProgressShare;
          setGenerationProgress(Math.round(sectionProgress));
          return { index: i, html };
        });
      });

      const results = await Promise.all(sectionPromises);
      const sectionHtmls = results
        .sort((a, b) => a.index - b.index)
        .map((r) => r.html);

      // ── Phase 4: Generate tags & keywords ──────────
      const tagsStepIndex = 2 + totalSections;
      updateStep(tagsStepIndex, "active");
      updateStepLabel(tagsStepIndex, "태그/키워드 생성 중...");

      const { tags, keywords } = await generateTagsAndKeywords({
        title: finalTitle,
        projectName: selectedProduct.name,
      });

      updateStep(tagsStepIndex, "done");
      updateStepLabel(tagsStepIndex, "태그/키워드 생성 완료");
      setGenerationProgress(90);

      // ── Phase 5: Assemble final HTML (client-side) ──
      const assembledHtml = assembleBlogHtml(sectionHtmls);

      // Fix broken image URLs (AI sometimes truncates UUIDs)
      const validImageUrls = selectedImagePaths.map((p) => getImageUrl(p));
      const finalHtml = fixImageUrls(assembledHtml, validImageUrls);

      setGeneratedHtml(finalHtml);
      setGeneratedTags(tags);
      setGeneratedKeywords(keywords);

      // Pre-fill edit step
      setEditHtml(finalHtml);
      setEditTags(tags);
      setEditKeywords(keywords);

      setGenerationProgress(100);

      // Small delay to show 100% before moving to Step 2 (Edit)
      setTimeout(() => {
        setCurrentStep(2);
      }, 500);
    } catch (err) {
      toast.error(
        err instanceof Error ? err.message : "Failed to generate magazine"
      );
      // Mark any active step as error
      setGenerationSteps((prev) =>
        prev.map((s) => (s.status === "active" ? { ...s, status: "error" } : s))
      );
    } finally {
      setGenerating(false);
    }
  }, [selectedProduct, finalTitle, productImages, selectedImagePaths, userMemo]);

  const handleSaveDraft = useCallback(() => {
    if (!selectedProduct) return;
    startTransition(async () => {
      const result = await createAIMagazine({
        title: finalTitle,
        htmlContent: editHtml,
        summary: editHtml.replace(/<[^>]*>/g, "").substring(0, 200),
        projectId: selectedProduct.id,
        tags: editTags,
        seoKeywords: editKeywords,
      });
      if ("error" in result) {
        toast.error(result.error);
      } else {
        toast.success("Draft saved successfully");
        router.push("/admin/magazines");
      }
    });
  }, [selectedProduct, finalTitle, editHtml, editTags, editKeywords, router, startTransition]);

  const handlePublish = useCallback(() => {
    if (!selectedProduct) return;
    startTransition(async () => {
      const createResult = await createAIMagazine({
        title: finalTitle,
        htmlContent: editHtml,
        summary: editHtml.replace(/<[^>]*>/g, "").substring(0, 200),
        projectId: selectedProduct.id,
        tags: editTags,
        seoKeywords: editKeywords,
      });
      if ("error" in createResult) {
        toast.error(createResult.error);
        return;
      }
      const pubResult = await publishMagazine(createResult.id);
      if ("error" in pubResult) {
        toast.error(pubResult.error);
      } else {
        toast.success("Magazine published successfully");
        router.push("/admin/magazines");
      }
    });
  }, [selectedProduct, finalTitle, editHtml, editTags, editKeywords, router, startTransition]);

  const handleDownloadHtml = useCallback(() => {
    const fullHtml = `<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${finalTitle}</title>
<style>
  body { font-family: 'Noto Sans KR', sans-serif; max-width: 700px; margin: 0 auto; padding: 20px; }
  img { max-width: 100%; height: auto; }
</style>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body>
${editHtml}
</body>
</html>`;
    const blob = new Blob([fullHtml], { type: "text/html" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "post.html";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }, [finalTitle, editHtml]);

  const addTag = useCallback(() => {
    const tag = newTag.trim().replace(/^#/, "");
    if (tag && !editTags.includes(tag)) {
      setEditTags((prev) => [...prev, tag]);
    }
    setNewTag("");
  }, [newTag, editTags]);

  const removeTag = useCallback((tag: string) => {
    setEditTags((prev) => prev.filter((t) => t !== tag));
  }, []);

  const addKeyword = useCallback(() => {
    const kw = newKeyword.trim();
    if (kw && !editKeywords.includes(kw)) {
      setEditKeywords((prev) => [...prev, kw]);
    }
    setNewKeyword("");
  }, [newKeyword, editKeywords]);

  const removeKeyword = useCallback((kw: string) => {
    setEditKeywords((prev) => prev.filter((k) => k !== kw));
  }, []);

  // ── Render ────────────────────────────────────────────

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-zinc-100">
            AI Magazine Creator
          </h1>
          <p className="mt-1 text-sm text-zinc-500">
            AI를 활용하여 프로젝트 매거진을 자동으로 생성합니다
          </p>
        </div>
        <Button
          variant="ghost"
          onClick={() => router.push("/admin/magazines")}
          className="text-zinc-400 hover:text-zinc-200"
        >
          Cancel
        </Button>
      </div>

      {/* Progress */}
      <div className="flex items-center gap-2">
        {Array.from({ length: totalSteps }, (_, i) => {
          const step = i + 1;
          const isActive = step === currentStep;
          const isComplete = step < currentStep;
          const stepLabels = ["Input + Generate", "Edit", "Save"];
          return (
            <div key={step} className="flex items-center gap-2">
              <div
                className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-medium transition-colors ${
                  isActive
                    ? "bg-zinc-100 text-zinc-900"
                    : isComplete
                      ? "bg-zinc-700 text-zinc-300"
                      : "bg-zinc-800 text-zinc-600"
                }`}
              >
                {isComplete ? (
                  <svg
                    className="h-4 w-4"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    strokeWidth={2}
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M5 13l4 4L19 7"
                    />
                  </svg>
                ) : (
                  step
                )}
              </div>
              <span
                className={`hidden text-xs sm:inline ${
                  isActive
                    ? "text-zinc-200"
                    : isComplete
                      ? "text-zinc-500"
                      : "text-zinc-600"
                }`}
              >
                {stepLabels[i]}
              </span>
              {step < totalSteps && (
                <div
                  className={`h-px w-6 ${
                    isComplete ? "bg-zinc-600" : "bg-zinc-800"
                  }`}
                />
              )}
            </div>
          );
        })}
        <span className="ml-3 text-xs text-zinc-500">
          Step {currentStep} of {totalSteps}
        </span>
      </div>

      {/* ════════════════════════════════════════════════════════════
          Step 1: Input + Generate
          ════════════════════════════════════════════════════════════ */}
      {currentStep === 1 && (
        <div className="space-y-6">
          {/* ── Title Card ── */}
          <Card className="border-zinc-800 bg-zinc-900">
            <CardHeader>
              <CardTitle className="text-zinc-100">제목</CardTitle>
              <CardDescription className="text-zinc-500">
                직접 입력하거나 AI 추천을 받으세요
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <Input
                value={customTitle}
                onChange={(e) => setCustomTitle(e.target.value)}
                placeholder="매거진 제목을 입력하세요..."
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
              />
            </CardContent>
          </Card>

          {/* ── Memo Card (Template) ── */}
          <Card className="border-zinc-800 bg-zinc-900">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm text-zinc-400">
                추가 메모 (선택사항)
              </CardTitle>
              <CardDescription className="text-zinc-600 text-xs">
                아래 항목을 참고하여 작성하면 더 좋은 매거진이 생성됩니다
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-3">
              <Textarea
                value={userMemo}
                onChange={(e) => setUserMemo(e.target.value)}
                disabled={enhancingMemo}
                placeholder={`[콘셉트] 이 프로젝트의 디자인 콘셉트 (예: 미니멀 모던, 내추럴 우드)\n[공간 특징] 특별히 강조할 공간이나 구조 (예: 오픈 키친, 팬트리)\n[자재/마감] 사용된 주요 자재 (예: 포세린 타일, 월넛 무늬목)\n[고객 요청] 고객이 원했던 핵심 요구사항\n[시공 포인트] 시공 시 특별했던 점이나 난이도\n[추가 정보] 그 외 블로그에 담고 싶은 내용`}
                className="min-h-[180px] border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-600 placeholder:leading-relaxed disabled:opacity-50 disabled:cursor-not-allowed"
              />
              <Button
                onClick={async () => {
                  if (!userMemo.trim()) return;
                  setEnhancingMemo(true);
                  try {
                    const enhanced = await enhanceMemo({
                      memo: userMemo,
                      projectName: selectedProduct?.name || "",
                      projectDescription: selectedProduct?.description || "",
                    });
                    setUserMemo(enhanced);
                    toast.success("메모가 강화되었습니다");
                  } catch {
                    toast.error("메모 강화 실패");
                  } finally {
                    setEnhancingMemo(false);
                  }
                }}
                disabled={enhancingMemo || !userMemo.trim()}
                variant="outline"
                size="sm"
                className="border-zinc-700 text-zinc-400 hover:text-zinc-200 hover:bg-zinc-800 disabled:opacity-50"
              >
                {enhancingMemo ? "강화 중..." : "✨ AI로 메모 강화하기"}
              </Button>
            </CardContent>
          </Card>

          {/* ── Project & Image Selection Card ── */}
          <Card className="border-zinc-800 bg-zinc-900">
            <CardHeader>
              <CardTitle className="text-zinc-100">
                프로젝트 &amp; 이미지
              </CardTitle>
              <CardDescription className="text-zinc-500">
                매거진을 작성할 프로젝트를 선택하고 이미지를 골라주세요
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label className="text-zinc-300">Project</Label>
                <ProjectCombobox
                  value={selectedProductId}
                  onChange={handleSelectProduct}
                  placeholder="-- Select a project --"
                />
              </div>

              {selectedProduct && (
                <div className="space-y-3 rounded-lg border border-zinc-800 bg-zinc-950 p-4">
                  <div>
                    <h3 className="font-medium text-zinc-200">
                      {selectedProduct.name}
                    </h3>
                    {selectedProduct.description && (
                      <p className="mt-1 text-sm text-zinc-400">
                        {selectedProduct.description}
                      </p>
                    )}
                  </div>

                  {loadingImages ? (
                    <p className="text-sm text-zinc-500">Loading images...</p>
                  ) : productImages.length > 0 ? (
                    <div className="space-y-2">
                      <Label className="text-zinc-400 text-xs">
                        Project Images ({productImagesTotal} total)
                        {selectedImagePaths.length > 0 && (
                          <span className="ml-2 text-zinc-200 font-medium">
                            — {selectedImagePaths.length} images selected
                          </span>
                        )}
                      </Label>
                      <ImagePickerMulti
                        productId={selectedProductId}
                        initialImages={productImages}
                        initialTotal={productImagesTotal}
                        selectedPaths={selectedImagePaths}
                        onToggle={(path) =>
                          setSelectedImagePaths((prev) =>
                            prev.includes(path)
                              ? prev.filter((p) => p !== path)
                              : [...prev, path]
                          )
                        }
                      />
                    </div>
                  ) : (
                    <p className="text-sm text-zinc-500">
                      No images available for this project
                    </p>
                  )}
                </div>
              )}
            </CardContent>
          </Card>

          {/* ── Generate Button + Progress ── */}
          {generating ? (
            <Card className="border-zinc-800 bg-zinc-900">
              <CardHeader>
                <CardTitle className="text-zinc-100">
                  매거진 생성 중
                </CardTitle>
                <CardDescription className="text-zinc-500">
                  AI가 매거진 콘텐츠를 단계별로 생성합니다
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                {/* Summary */}
                <div className="rounded-lg border border-zinc-800 bg-zinc-950 p-4 space-y-2">
                  <div className="flex gap-2 text-sm">
                    <span className="text-zinc-500">Project:</span>
                    <span className="text-zinc-200">{selectedProduct?.name}</span>
                  </div>
                  <div className="flex gap-2 text-sm">
                    <span className="text-zinc-500">Title:</span>
                    <span className="text-zinc-200">{finalTitle}</span>
                  </div>
                  <div className="flex gap-2 text-sm">
                    <span className="text-zinc-500">Images:</span>
                    <span className="text-zinc-200">
                      {selectedImagePaths.length} selected
                    </span>
                  </div>
                  {userMemo && (
                    <div className="flex gap-2 text-sm">
                      <span className="text-zinc-500">Memo:</span>
                      <span className="text-zinc-200 line-clamp-2">
                        {userMemo}
                      </span>
                    </div>
                  )}
                </div>

                {/* Step list */}
                <div className="rounded-lg border border-zinc-800 bg-zinc-950 p-6 space-y-4">
                  <p className="text-sm font-medium text-zinc-200">
                    AI가 매거진을 작성하고 있습니다
                  </p>
                  <div className="space-y-2">
                    {generationSteps.map((step, i) => (
                      <div key={i} className="flex items-center gap-3 text-sm">
                        {step.status === "done" ? (
                          <span className="flex h-5 w-5 items-center justify-center text-emerald-400">
                            <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                              <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                            </svg>
                          </span>
                        ) : step.status === "active" ? (
                          <span className="flex h-5 w-5 items-center justify-center">
                            <span className="h-3 w-3 animate-spin rounded-full border-2 border-zinc-600 border-t-zinc-100" />
                          </span>
                        ) : step.status === "error" ? (
                          <span className="flex h-5 w-5 items-center justify-center text-red-400">
                            <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                              <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                          </span>
                        ) : (
                          <span className="flex h-5 w-5 items-center justify-center">
                            <span className="h-2 w-2 rounded-full bg-zinc-700" />
                          </span>
                        )}
                        <span
                          className={
                            step.status === "done"
                              ? "text-zinc-300"
                              : step.status === "active"
                                ? "text-zinc-100 font-medium"
                                : step.status === "error"
                                  ? "text-red-400"
                                  : "text-zinc-600"
                          }
                        >
                          {step.label}
                        </span>
                      </div>
                    ))}
                  </div>

                  {/* Progress bar */}
                  <div className="space-y-1">
                    <div className="flex justify-between text-xs text-zinc-500">
                      <span>진행률</span>
                      <span>{generationProgress}%</span>
                    </div>
                    <div className="h-2 w-full rounded-full bg-zinc-800">
                      <div
                        className="h-2 rounded-full bg-zinc-100 transition-all duration-500"
                        style={{ width: `${generationProgress}%` }}
                      />
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          ) : (
            <div className="flex justify-end">
              <Button
                onClick={handleGenerate}
                disabled={!canGenerate}
                className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200 disabled:opacity-50 px-8 py-2 text-base"
              >
                매거진 생성
              </Button>
            </div>
          )}
        </div>
      )}

      {/* ════════════════════════════════════════════════════════════
          Step 2: Edit + Preview (was Step 5)
          ════════════════════════════════════════════════════════════ */}
      {currentStep === 2 && (
        <Card className="border-zinc-800 bg-zinc-900">
          <CardHeader>
            <CardTitle className="text-zinc-100">
              Step 2: Edit &amp; Preview
            </CardTitle>
            <CardDescription className="text-zinc-500">
              HTML을 수정하고 실시간 미리보기를 확인하세요
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
              {/* Editor */}
              <div className="relative space-y-2">
                <Label className="text-zinc-400 text-xs">
                  HTML Content
                  <span className="ml-2 text-zinc-600">(텍스트를 드래그하여 선택 → AI 수정 요청)</span>
                </Label>
                <textarea
                  value={editHtml}
                  onChange={(e) => setEditHtml(e.target.value)}
                  onMouseUp={(e) => {
                    const target = e.target as HTMLTextAreaElement;
                    const selected = target.value.substring(
                      target.selectionStart,
                      target.selectionEnd
                    );
                    if (selected.trim().length > 5) {
                      setSelectedText(selected);
                      setEditComment("");
                      setShowEditPopover(true);
                    } else {
                      setShowEditPopover(false);
                    }
                  }}
                  className="h-[500px] w-full resize-none rounded-lg border border-zinc-700 bg-zinc-950 p-3 font-mono text-xs text-zinc-300 focus:border-zinc-500 focus:outline-none"
                  spellCheck={false}
                />

                {/* AI Inline Edit Popover */}
                {showEditPopover && (
                  <div className="absolute bottom-4 left-4 right-4 z-10 rounded-lg border border-zinc-600 bg-zinc-800 p-4 shadow-xl">
                    <div className="mb-2 text-xs text-zinc-400">
                      선택된 텍스트: <span className="text-zinc-200">&quot;{selectedText.length > 80 ? selectedText.substring(0, 80) + "..." : selectedText}&quot;</span>
                    </div>
                    <div className="flex gap-2">
                      <Input
                        value={editComment}
                        onChange={(e) => setEditComment(e.target.value)}
                        placeholder="수정 요청 (예: 더 전문적으로, 자재명 추가, 줄여줘)"
                        className="flex-1 border-zinc-600 bg-zinc-900 text-zinc-200 text-sm placeholder:text-zinc-500"
                        onKeyDown={(e) => {
                          if (e.key === "Enter" && editComment.trim()) {
                            e.preventDefault();
                            handleInlineEdit();
                          }
                        }}
                      />
                      <Button
                        size="sm"
                        disabled={!editComment.trim() || editingInline}
                        onClick={handleInlineEdit}
                        className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200 disabled:opacity-50"
                      >
                        {editingInline ? "수정 중..." : "AI 수정"}
                      </Button>
                      <Button
                        size="sm"
                        variant="outline"
                        onClick={() => setShowEditPopover(false)}
                        className="border-zinc-600 text-zinc-400 hover:text-zinc-200"
                      >
                        ✕
                      </Button>
                    </div>
                  </div>
                )}
              </div>

              {/* Preview */}
              <div className="space-y-2">
                <Label className="text-zinc-400 text-xs">Live Preview</Label>
                <div className="h-[500px] overflow-y-auto rounded-lg border border-zinc-700 bg-white p-4">
                  <div
                    className="magazine-preview mx-auto max-w-[700px]"
                    style={{
                      fontFamily: "'Noto Sans KR', sans-serif",
                      color: "#333",
                      fontSize: "15px",
                      lineHeight: 1.8,
                    }}
                    dangerouslySetInnerHTML={{ __html: editHtml }}
                  />
                </div>
              </div>
            </div>

            {/* Tags */}
            <div className="space-y-2">
              <Label className="text-zinc-400 text-xs">Tags</Label>
              <div className="flex flex-wrap gap-1.5">
                {editTags.map((tag) => (
                  <Badge
                    key={tag}
                    variant="secondary"
                    className="cursor-pointer bg-zinc-800 text-zinc-300 hover:bg-zinc-700"
                    onClick={() => removeTag(tag)}
                  >
                    #{tag} &times;
                  </Badge>
                ))}
              </div>
              <div className="flex gap-2">
                <Input
                  value={newTag}
                  onChange={(e) => setNewTag(e.target.value)}
                  onKeyDown={(e) => e.key === "Enter" && (e.preventDefault(), addTag())}
                  placeholder="Add tag..."
                  className="max-w-xs border-zinc-700 bg-zinc-800 text-zinc-100 text-xs"
                />
                <Button
                  variant="outline"
                  size="sm"
                  onClick={addTag}
                  className="border-zinc-700 text-zinc-300 hover:bg-zinc-800"
                >
                  Add
                </Button>
              </div>
            </div>

            {/* SEO Keywords */}
            <div className="space-y-2">
              <Label className="text-zinc-400 text-xs">SEO Keywords</Label>
              <div className="flex flex-wrap gap-1.5">
                {editKeywords.map((kw) => (
                  <Badge
                    key={kw}
                    variant="outline"
                    className="cursor-pointer text-zinc-400 hover:text-zinc-200"
                    onClick={() => removeKeyword(kw)}
                  >
                    {kw} &times;
                  </Badge>
                ))}
              </div>
              <div className="flex gap-2">
                <Input
                  value={newKeyword}
                  onChange={(e) => setNewKeyword(e.target.value)}
                  onKeyDown={(e) =>
                    e.key === "Enter" && (e.preventDefault(), addKeyword())
                  }
                  placeholder="Add keyword..."
                  className="max-w-xs border-zinc-700 bg-zinc-800 text-zinc-100 text-xs"
                />
                <Button
                  variant="outline"
                  size="sm"
                  onClick={addKeyword}
                  className="border-zinc-700 text-zinc-300 hover:bg-zinc-800"
                >
                  Add
                </Button>
              </div>
            </div>

            <div className="flex justify-between">
              <Button
                variant="ghost"
                onClick={() => setCurrentStep(1)}
                className="text-zinc-400 hover:text-zinc-200"
              >
                Back
              </Button>
              <Button
                onClick={() => setCurrentStep(3)}
                className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200"
              >
                Next
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* ════════════════════════════════════════════════════════════
          Step 3: Save + Publish + Download (was Step 6)
          ════════════════════════════════════════════════════════════ */}
      {currentStep === 3 && (
        <Card className="border-zinc-800 bg-zinc-900">
          <CardHeader>
            <CardTitle className="text-zinc-100">
              Step 3: Save &amp; Publish
            </CardTitle>
            <CardDescription className="text-zinc-500">
              매거진을 저장하거나 바로 발행하세요
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            {/* Final Summary */}
            <div className="rounded-lg border border-zinc-800 bg-zinc-950 p-4 space-y-3">
              <div className="flex gap-2 text-sm">
                <span className="text-zinc-500 w-20 shrink-0">Project:</span>
                <span className="text-zinc-200">{selectedProduct?.name}</span>
              </div>
              <div className="flex gap-2 text-sm">
                <span className="text-zinc-500 w-20 shrink-0">Title:</span>
                <span className="text-zinc-200 font-medium">{finalTitle}</span>
              </div>
              <div className="flex gap-2 text-sm">
                <span className="text-zinc-500 w-20 shrink-0">Tags:</span>
                <span className="text-zinc-300">
                  {editTags.map((t) => `#${t}`).join("  ") || "-"}
                </span>
              </div>
              <div className="flex gap-2 text-sm">
                <span className="text-zinc-500 w-20 shrink-0">Keywords:</span>
                <span className="text-zinc-300">
                  {editKeywords.join(", ") || "-"}
                </span>
              </div>
              <div className="flex gap-2 text-sm">
                <span className="text-zinc-500 w-20 shrink-0">Content:</span>
                <span className="text-zinc-300">
                  {editHtml.length.toLocaleString()} characters
                </span>
              </div>
            </div>

            {/* Mini Preview */}
            <div className="space-y-2">
              <Label className="text-zinc-400 text-xs">Preview</Label>
              <div className="h-[50vh] overflow-y-auto rounded-lg border border-zinc-700 bg-white p-4">
                <div
                  className="mx-auto max-w-[700px]"
                  style={{
                    fontFamily: "'Noto Sans KR', sans-serif",
                    color: "#333",
                    fontSize: "12px",
                    lineHeight: 1.6,
                  }}
                  dangerouslySetInnerHTML={{ __html: editHtml }}
                />
              </div>
            </div>

            {/* Actions */}
            <div className="flex flex-col gap-3 sm:flex-row sm:justify-between">
              <Button
                variant="ghost"
                onClick={() => setCurrentStep(2)}
                className="text-zinc-400 hover:text-zinc-200"
              >
                Back to Edit
              </Button>

              <div className="flex flex-wrap gap-2">
                <Button
                  variant="outline"
                  onClick={handleDownloadHtml}
                  className="border-zinc-700 text-zinc-300 hover:bg-zinc-800"
                >
                  Download HTML
                </Button>
                <Button
                  variant="outline"
                  onClick={handleSaveDraft}
                  disabled={isPending}
                  className="border-zinc-700 text-zinc-300 hover:bg-zinc-800"
                >
                  {isPending ? "Saving..." : "Save as Draft"}
                </Button>
                <Button
                  onClick={handlePublish}
                  disabled={isPending}
                  className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200 disabled:opacity-50"
                >
                  {isPending ? "Publishing..." : "Publish"}
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
