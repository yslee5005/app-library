"use client";

import { useState, useTransition, useCallback } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  Card,
  CardHeader,
  CardTitle,
  CardContent,
} from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import {
  updateMagazineFull,
  deleteMagazine,
  type AdminMagazine,
} from "@/lib/admin-actions";
import { inlineEditHtml } from "@/lib/ai-service";

// ── Types ──────────────────────────────────────────────

interface MagazineWithContent extends AdminMagazine {
  html_content: string | null;
  tags: string[] | null;
  seo_keywords: string[] | null;
}

interface MagazineEditClientProps {
  magazine: MagazineWithContent;
}

// ── Component ──────────────────────────────────────────

export default function MagazineEditClient({
  magazine,
}: MagazineEditClientProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();

  // Basic info
  const [title, setTitle] = useState(magazine.title);
  const [summary, setSummary] = useState(magazine.summary ?? "");
  const [date, setDate] = useState(magazine.date?.split("T")[0] ?? "");

  // HTML content
  const [editHtml, setEditHtml] = useState(magazine.html_content ?? "");

  // Tags & Keywords
  const [editTags, setEditTags] = useState<string[]>(magazine.tags ?? []);
  const [editKeywords, setEditKeywords] = useState<string[]>(
    magazine.seo_keywords ?? []
  );
  const [newTag, setNewTag] = useState("");
  const [newKeyword, setNewKeyword] = useState("");

  // Inline AI edit
  const [selectedText, setSelectedText] = useState("");
  const [editComment, setEditComment] = useState("");
  const [showEditPopover, setShowEditPopover] = useState(false);
  const [editingInline, setEditingInline] = useState(false);

  // Delete confirmation
  const [showDeleteDialog, setShowDeleteDialog] = useState(false);

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
      toast.error(
        "AI 수정 실패: " +
          (err instanceof Error ? err.message : "Unknown error")
      );
    } finally {
      setEditingInline(false);
    }
  };

  // ── Tag / Keyword Handlers ───────────────────────────

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

  // ── Save / Publish / Delete Handlers ─────────────────

  const handleSave = (status: string) => {
    startTransition(async () => {
      const result = await updateMagazineFull(magazine.id, {
        title,
        summary,
        date,
        html_content: editHtml,
        tags: editTags,
        seo_keywords: editKeywords,
        status,
      });
      if ("error" in result) {
        toast.error(result.error);
      } else {
        toast.success(
          status === "published" ? "Magazine published" : "Draft saved"
        );
        router.push("/admin/magazines");
        router.refresh();
      }
    });
  };

  const handleDelete = () => {
    startTransition(async () => {
      const result = await deleteMagazine(magazine.id);
      if ("error" in result) {
        toast.error(result.error);
      } else {
        toast.success("Magazine deleted");
        router.push("/admin/magazines");
        router.refresh();
      }
    });
  };

  const handleDownloadHtml = useCallback(() => {
    const fullHtml = `<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${title}</title>
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
  }, [title, editHtml]);

  // ── Render ──────────────────────────────────────────

  return (
    <>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold text-zinc-100">
              Edit Magazine
            </h1>
            <p className="mt-1 text-sm text-zinc-500">
              매거진 내용을 수정합니다
            </p>
          </div>
          <Button
            variant="ghost"
            onClick={() => router.push("/admin/magazines")}
            className="text-zinc-400 hover:text-zinc-200"
          >
            Back
          </Button>
        </div>

        {/* Card 1: Basic Info */}
        <Card className="border-zinc-800 bg-zinc-900">
          <CardHeader>
            <CardTitle className="text-zinc-100">Basic Info</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label className="text-zinc-300">Title</Label>
              <Input
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
                placeholder="Magazine title"
              />
            </div>

            <div className="space-y-2">
              <Label className="text-zinc-300">Summary</Label>
              <Textarea
                value={summary}
                onChange={(e) => setSummary(e.target.value)}
                className="min-h-[80px] border-zinc-700 bg-zinc-800 text-zinc-100"
                placeholder="Brief summary"
              />
            </div>

            <div className="space-y-2">
              <Label className="text-zinc-300">Date</Label>
              <Input
                type="date"
                value={date}
                onChange={(e) => setDate(e.target.value)}
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
              />
            </div>
          </CardContent>
        </Card>

        {/* Card 2: HTML Editor + Preview */}
        <Card className="border-zinc-800 bg-zinc-900">
          <CardHeader>
            <CardTitle className="text-zinc-100">
              HTML Editor &amp; Preview
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
              {/* Editor */}
              <div className="relative space-y-2">
                <Label className="text-zinc-400 text-xs">
                  HTML Content
                  <span className="ml-2 text-zinc-600">
                    (텍스트를 드래그하여 선택 → AI 수정 요청)
                  </span>
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
                      선택된 텍스트:{" "}
                      <span className="text-zinc-200">
                        &quot;
                        {selectedText.length > 80
                          ? selectedText.substring(0, 80) + "..."
                          : selectedText}
                        &quot;
                      </span>
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
          </CardContent>
        </Card>

        {/* Card 3: Tags & Keywords */}
        <Card className="border-zinc-800 bg-zinc-900">
          <CardHeader>
            <CardTitle className="text-zinc-100">
              Tags &amp; Keywords
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
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
                  onKeyDown={(e) =>
                    e.key === "Enter" && (e.preventDefault(), addTag())
                  }
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
          </CardContent>
        </Card>

        {/* Actions */}
        <div className="flex flex-col gap-3 sm:flex-row sm:justify-between">
          <Button
            variant="ghost"
            onClick={() => setShowDeleteDialog(true)}
            className="text-red-400 hover:text-red-300 hover:bg-red-400/10"
          >
            Delete Magazine
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
              onClick={() => handleSave("draft")}
              disabled={isPending || !title.trim()}
              className="border-zinc-700 text-zinc-300 hover:bg-zinc-800 disabled:opacity-50"
            >
              {isPending ? "Saving..." : "Save Draft"}
            </Button>
            <Button
              onClick={() => handleSave("published")}
              disabled={isPending || !title.trim()}
              className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200 disabled:opacity-50"
            >
              {isPending ? "Publishing..." : "Publish"}
            </Button>
          </div>
        </div>
      </div>

      {/* Delete Confirmation Dialog */}
      <Dialog
        open={showDeleteDialog}
        onOpenChange={(open) => !open && setShowDeleteDialog(false)}
      >
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete Magazine</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete &ldquo;{magazine.title}
              &rdquo;? This action cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button
              variant="ghost"
              onClick={() => setShowDeleteDialog(false)}
              className="text-zinc-400 hover:text-zinc-200"
            >
              Cancel
            </Button>
            <Button
              variant="destructive"
              onClick={handleDelete}
              disabled={isPending}
            >
              {isPending ? "Deleting..." : "Delete"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
