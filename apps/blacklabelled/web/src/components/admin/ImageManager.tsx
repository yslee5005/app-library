"use client";

import { useCallback, useRef, useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";
import {
  DndContext,
  closestCenter,
  KeyboardSensor,
  PointerSensor,
  useSensor,
  useSensors,
  type DragEndEvent,
} from "@dnd-kit/core";
import {
  arrayMove,
  SortableContext,
  sortableKeyboardCoordinates,
  useSortable,
  rectSortingStrategy,
} from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { getImageUrl } from "@/lib/data";
import {
  uploadProductImage,
  reorderProductImages,
  deleteProductImage,
  setImageType,
  type AdminProductImage,
} from "@/lib/admin-actions";

// ── Sortable Image Card ──────────────────────────────────

function SortableImageCard({
  image,
  onToggleType,
  onDelete,
  isPending,
}: {
  image: AdminProductImage;
  onToggleType: (id: string, currentType: string) => void;
  onDelete: (id: string) => void;
  isPending: boolean;
}) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: image.id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  };

  const imageUrl = getImageUrl(image.storage_path);

  return (
    <div
      ref={setNodeRef}
      style={style}
      className="group relative rounded-lg border border-zinc-700 bg-zinc-800 overflow-hidden"
    >
      {/* Drag handle */}
      <div
        {...attributes}
        {...listeners}
        className="absolute top-1 left-1 z-10 cursor-grab rounded bg-zinc-900/80 px-1.5 py-0.5 text-xs text-zinc-400 opacity-0 transition-opacity group-hover:opacity-100"
      >
        &#x2630;
      </div>

      {/* Type badge */}
      <div className="absolute top-1 right-1 z-10">
        <Badge
          variant={image.type === "main" ? "success" : "secondary"}
          className="cursor-pointer text-[10px]"
          onClick={() => onToggleType(image.id, image.type)}
        >
          {image.type}
        </Badge>
      </div>

      {/* Delete button */}
      <button
        onClick={() => onDelete(image.id)}
        disabled={isPending}
        className="absolute bottom-1 right-1 z-10 rounded bg-red-900/80 px-1.5 py-0.5 text-xs text-red-300 opacity-0 transition-opacity hover:bg-red-800 group-hover:opacity-100 disabled:opacity-50"
      >
        Delete
      </button>

      {/* Thumbnail */}
      <div className="aspect-square relative">
        {imageUrl ? (
          <Image
            src={imageUrl}
            alt={image.original_filename ?? "Product image"}
            fill
            className="object-cover"
            sizes="(max-width: 768px) 50vw, 25vw"
          />
        ) : (
          <div className="flex h-full items-center justify-center text-zinc-600">
            No image
          </div>
        )}
      </div>

      {/* Info */}
      <div className="px-2 py-1.5">
        <p className="truncate text-xs text-zinc-400">
          {image.original_filename ?? "unknown"}
        </p>
        <p className="text-[10px] text-zinc-600">
          #{image.sort_order}
          {image.file_size
            ? ` | ${(image.file_size / 1024).toFixed(0)}KB`
            : ""}
        </p>
      </div>
    </div>
  );
}

// ── Main ImageManager Component ──────────────────────────

interface ImageManagerProps {
  productId: string;
  initialImages: AdminProductImage[];
}

export default function ImageManager({
  productId,
  initialImages,
}: ImageManagerProps) {
  const router = useRouter();
  const [images, setImages] = useState<AdminProductImage[]>(initialImages);
  const [isPending, startTransition] = useTransition();
  const [uploading, setUploading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState(0);
  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [isDragOver, setIsDragOver] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } }),
    useSensor(KeyboardSensor, {
      coordinateGetter: sortableKeyboardCoordinates,
    })
  );

  // ── Upload ──────────────────────────────────────────────

  const handleUpload = useCallback(
    async (files: FileList | File[]) => {
      const fileArray = Array.from(files);
      if (fileArray.length === 0) return;

      setUploading(true);
      setUploadProgress(0);

      let completed = 0;
      for (const file of fileArray) {
        const fd = new FormData();
        fd.set("file", file);
        // First image → main if no images exist, rest → detail
        const type =
          images.length === 0 && completed === 0 ? "main" : "detail";
        fd.set("type", type);

        const result = await uploadProductImage(productId, fd);
        if ("error" in result) {
          toast.error(`Upload failed: ${result.error}`);
        } else {
          setImages((prev) => [...prev, result]);
        }
        completed++;
        setUploadProgress(Math.round((completed / fileArray.length) * 100));
      }

      setUploading(false);
      setUploadProgress(0);
      router.refresh();
      toast.success(
        `${fileArray.length} image${fileArray.length > 1 ? "s" : ""} uploaded`
      );
    },
    [productId, images.length, router]
  );

  const onFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      handleUpload(e.target.files);
      e.target.value = "";
    }
  };

  const onDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragOver(false);
    if (e.dataTransfer.files) {
      handleUpload(e.dataTransfer.files);
    }
  };

  // ── Reorder ─────────────────────────────────────────────

  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    if (!over || active.id === over.id) return;

    const oldIndex = images.findIndex((img) => img.id === active.id);
    const newIndex = images.findIndex((img) => img.id === over.id);

    const reordered = arrayMove(images, oldIndex, newIndex);
    setImages(reordered);

    startTransition(async () => {
      const result = await reorderProductImages(
        productId,
        reordered.map((img) => img.id)
      );
      if ("error" in result) {
        toast.error(result.error);
        setImages(initialImages); // rollback
      } else {
        toast.success("Order saved");
        router.refresh();
      }
    });
  };

  // ── Toggle Type ─────────────────────────────────────────

  const handleToggleType = (imageId: string, currentType: string) => {
    const newType = currentType === "main" ? "detail" : "main";
    startTransition(async () => {
      const result = await setImageType(
        imageId,
        newType as "main" | "detail"
      );
      if ("error" in result) {
        toast.error(result.error);
      } else {
        // Update local state
        setImages((prev) =>
          prev.map((img) => {
            if (img.id === imageId) return { ...img, type: newType };
            if (newType === "main" && img.type === "main")
              return { ...img, type: "detail" };
            return img;
          })
        );
        router.refresh();
        toast.success(`Image set as ${newType}`);
      }
    });
  };

  // ── Delete ──────────────────────────────────────────────

  const handleConfirmDelete = () => {
    if (!deleteId) return;
    startTransition(async () => {
      const result = await deleteProductImage(deleteId);
      if ("error" in result) {
        toast.error(result.error);
      } else {
        setImages((prev) => prev.filter((img) => img.id !== deleteId));
        router.refresh();
        toast.success("Image deleted");
      }
      setDeleteId(null);
    });
  };

  return (
    <>
      <Card className="border-zinc-800 bg-zinc-900">
        <CardHeader>
          <CardTitle className="text-zinc-100">
            Images ({images.length})
          </CardTitle>
          <p className="text-xs text-zinc-500">Images are saved automatically when uploaded, reordered, or deleted.</p>
        </CardHeader>
        <CardContent className="space-y-4">
          {/* Upload zone */}
          <div
            onDragOver={(e) => {
              e.preventDefault();
              setIsDragOver(true);
            }}
            onDragLeave={() => setIsDragOver(false)}
            onDrop={onDrop}
            className={`rounded-lg border-2 border-dashed p-6 text-center transition-colors ${
              isDragOver
                ? "border-zinc-400 bg-zinc-800"
                : "border-zinc-700 bg-zinc-800/50"
            }`}
          >
            {uploading ? (
              <div className="space-y-2">
                <p className="text-sm text-zinc-300">
                  Uploading... {uploadProgress}%
                </p>
                <div className="mx-auto h-2 w-48 overflow-hidden rounded-full bg-zinc-700">
                  <div
                    className="h-full bg-zinc-300 transition-all"
                    style={{ width: `${uploadProgress}%` }}
                  />
                </div>
              </div>
            ) : (
              <div className="space-y-2">
                <p className="text-sm text-zinc-400">
                  Drag & drop images here, or
                </p>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={() => fileInputRef.current?.click()}
                  className="border-zinc-600 text-zinc-300 hover:bg-zinc-700"
                >
                  Choose Files
                </Button>
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/*"
                  multiple
                  onChange={onFileChange}
                  className="hidden"
                />
              </div>
            )}
          </div>

          {/* Image grid */}
          {images.length > 0 && (
            <DndContext
              sensors={sensors}
              collisionDetection={closestCenter}
              onDragEnd={handleDragEnd}
            >
              <SortableContext
                items={images.map((img) => img.id)}
                strategy={rectSortingStrategy}
              >
                <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-4">
                  {images.map((image) => (
                    <SortableImageCard
                      key={image.id}
                      image={image}
                      onToggleType={handleToggleType}
                      onDelete={(id) => setDeleteId(id)}
                      isPending={isPending}
                    />
                  ))}
                </div>
              </SortableContext>
            </DndContext>
          )}

          {images.length === 0 && !uploading && (
            <p className="text-center text-sm text-zinc-600">
              No images yet. Upload some above.
            </p>
          )}
        </CardContent>
      </Card>

      {/* Delete confirmation dialog */}
      <Dialog
        open={deleteId !== null}
        onOpenChange={(open) => !open && setDeleteId(null)}
      >
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete Image</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete this image? This action cannot be
              undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button
              variant="ghost"
              onClick={() => setDeleteId(null)}
              className="text-zinc-400 hover:text-zinc-200"
            >
              Cancel
            </Button>
            <Button
              variant="destructive"
              onClick={handleConfirmDelete}
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
