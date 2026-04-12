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

interface ImagePickerProps {
  productId: string;
  initialImages: ImageOption[];
  initialTotal: number;
  selectedPath: string;
  onSelect: (path: string) => void;
  pageSize?: number;
}

export default function ImagePicker({
  productId,
  initialImages,
  initialTotal,
  selectedPath,
  onSelect,
  pageSize = 4,
}: ImagePickerProps) {
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
      <div className="grid grid-cols-4 gap-2">
        {images.map((img) => {
          const isSelected = selectedPath === img.storage_path;
          return (
            <button
              key={img.id}
              type="button"
              onClick={() => onSelect(img.storage_path)}
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
