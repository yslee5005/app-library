"use client";

import { useState } from "react";
import Image from "next/image";
import { getImageUrl } from "@/lib/data";
import { getProductImages } from "@/lib/admin-actions";
import { Button } from "@/components/ui/button";

interface ImageOption {
  id: string;
  storage_path: string;
  type: string;
  sort_order: number;
}

interface ImagePickerMultiProps {
  productId: string;
  initialImages: ImageOption[];
  initialTotal: number;
  selectedPaths: string[];
  onToggle: (path: string) => void;
  pageSize?: number;
}

export default function ImagePickerMulti({
  productId,
  initialImages,
  initialTotal,
  selectedPaths,
  onToggle,
  pageSize = 4,
}: ImagePickerMultiProps) {
  const [images, setImages] = useState<ImageOption[]>(initialImages);
  const [total, setTotal] = useState(initialTotal);
  const [loading, setLoading] = useState(false);

  const hasMore = images.length < total;

  const handleLoadMore = async () => {
    setLoading(true);
    try {
      const result = await getProductImages(productId, images.length, pageSize);
      setImages((prev) => [...prev, ...result.images]);
      setTotal(result.total);
    } catch {
      // ignore
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between">
        <p className="text-xs text-zinc-500">
          Select images to include in your magazine (recommended: 3-5)
        </p>
        <span className="text-xs font-medium text-zinc-300">
          {selectedPaths.length} images selected
        </span>
      </div>
      <div className="grid grid-cols-4 gap-2">
        {images.map((img) => {
          const isSelected = selectedPaths.includes(img.storage_path);
          return (
            <button
              key={img.id}
              type="button"
              onClick={() => onToggle(img.storage_path)}
              className={`relative aspect-square rounded-lg overflow-hidden border-2 transition-colors ${
                isSelected
                  ? "border-white ring-2 ring-white/30"
                  : "border-zinc-700 hover:border-zinc-500"
              }`}
            >
              <Image
                src={getImageUrl(img.storage_path)}
                alt={`Image ${img.sort_order + 1}`}
                fill
                className="object-cover"
                sizes="100px"
              />
              {/* Checkbox overlay */}
              <span
                className={`absolute top-1.5 right-1.5 flex h-5 w-5 items-center justify-center rounded border transition-colors ${
                  isSelected
                    ? "border-white bg-white text-zinc-900"
                    : "border-zinc-400 bg-zinc-900/60"
                }`}
              >
                {isSelected && (
                  <svg
                    className="h-3.5 w-3.5"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    strokeWidth={3}
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M5 13l4 4L19 7"
                    />
                  </svg>
                )}
              </span>
              {img.type === "main" && (
                <span className="absolute top-1 left-1 rounded bg-zinc-900/80 px-1.5 py-0.5 text-[10px] text-zinc-300">
                  Main
                </span>
              )}
            </button>
          );
        })}
      </div>
      {hasMore && (
        <Button
          type="button"
          variant="outline"
          size="sm"
          disabled={loading}
          onClick={handleLoadMore}
          className="w-full border-zinc-700 text-zinc-400 hover:text-zinc-200 hover:bg-zinc-800"
        >
          {loading ? "Loading..." : `Load More (${total - images.length} remaining)`}
        </Button>
      )}
    </div>
  );
}
