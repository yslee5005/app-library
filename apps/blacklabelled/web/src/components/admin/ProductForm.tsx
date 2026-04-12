"use client";

import { useEffect, useRef, useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { toast } from "sonner";

import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Select } from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
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

import {
  createProduct,
  updateProduct,
  deleteProduct,
} from "@/lib/admin-actions";

const productSchema = z.object({
  name: z.string().min(1, "Name is required"),
  slug: z.string().min(1, "Slug is required"),
  description: z.string(),
  price: z.number().min(0),
  status: z.enum(["published", "draft"]),
  main_category_id: z.string(),
});

type ProductFormValues = z.infer<typeof productSchema>;

interface Category {
  id: string;
  name: string;
  parent_name: string | null;
}

interface ProductFormProps {
  mode: "create" | "edit";
  productId?: string;
  defaultValues?: Partial<ProductFormValues>;
  categories: Category[];
  onCreated?: (id: string) => void;
}

function generateSlug(name: string): string {
  const randomSuffix = Math.random().toString(36).substring(2, 6);
  const base = name
    .trim()
    .replace(/\s+/g, "_")
    .replace(/[^\w가-힣\-]/g, "");
  return `${base}_${randomSuffix}`;
}

export default function ProductForm({
  mode,
  productId,
  defaultValues,
  categories,
  onCreated,
}: ProductFormProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();
  const [saving, setSaving] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const [showDeleteDialog, setShowDeleteDialog] = useState(false);
  const slugManuallyEdited = useRef(false);

  const {
    register,
    handleSubmit,
    setValue,
    watch,
    formState: { errors },
  } = useForm<ProductFormValues>({
    resolver: zodResolver(productSchema),
    defaultValues: {
      name: defaultValues?.name ?? "",
      slug: defaultValues?.slug ?? "",
      description: defaultValues?.description ?? "",
      price: defaultValues?.price ?? 0,
      status: defaultValues?.status ?? "draft",
      main_category_id: defaultValues?.main_category_id ?? "",
    },
  });

  const nameValue = watch("name");
  const slugValue = watch("slug");

  // Track if slug was manually edited
  const prevNameRef = useRef(defaultValues?.name ?? "");
  useEffect(() => {
    if (mode === "edit" && !slugManuallyEdited.current) {
      // In edit mode, don't auto-generate slug on first load
      prevNameRef.current = nameValue;
      return;
    }
    if (
      nameValue !== prevNameRef.current &&
      !slugManuallyEdited.current
    ) {
      setValue("slug", generateSlug(nameValue));
    }
    prevNameRef.current = nameValue;
  }, [nameValue, mode, setValue]);

  const onSubmit = (data: ProductFormValues) => {
    setSaving(true);
    startTransition(async () => {
      try {
        const formData = new FormData();
        formData.set("name", data.name);
        formData.set("slug", data.slug);
        formData.set("description", data.description ?? "");
        formData.set("price", String(data.price));
        formData.set("status", data.status);
        formData.set("main_category_id", data.main_category_id ?? "");

        if (mode === "create") {
          const result = await createProduct(formData);
          if ("error" in result) {
            toast.error(result.error);
          } else {
            toast.success("Project created — now add images below");
            if (onCreated) {
              onCreated(result.id);
            } else {
              router.push(`/admin/products/${result.id}/edit`);
            }
          }
        } else if (productId) {
          const result = await updateProduct(productId, formData);
          if ("error" in result) {
            toast.error(result.error);
          } else {
            toast.success("Project updated");
            router.refresh();
          }
        }
      } finally {
        setSaving(false);
      }
    });
  };

  const handleDelete = () => {
    if (!productId) return;
    setDeleting(true);
    startTransition(async () => {
      try {
        const result = await deleteProduct(productId);
        if ("error" in result) {
          toast.error(result.error);
        } else {
          toast.success("Project deleted");
          router.push("/admin/products");
        }
        setShowDeleteDialog(false);
      } finally {
        setDeleting(false);
      }
    });
  };

  return (
    <>
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        <Card className="border-zinc-800 bg-zinc-900">
          <CardHeader>
            <CardTitle className="text-zinc-100">Project Details</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {/* Name */}
            <div className="space-y-2">
              <Label htmlFor="name" className="text-zinc-300">
                Name <span className="text-red-400">*</span>
              </Label>
              <Input
                id="name"
                {...register("name")}
                className="border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-500"
                placeholder="Project name"
              />
              {errors.name && (
                <p className="text-sm text-red-400">{errors.name.message}</p>
              )}
            </div>

            {/* Slug */}
            <div className="space-y-2">
              <Label htmlFor="slug" className="text-zinc-300">
                Slug
              </Label>
              <Input
                id="slug"
                {...register("slug", {
                  onChange: () => {
                    slugManuallyEdited.current = true;
                  },
                })}
                className="border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-500"
                placeholder="auto-generated-slug"
              />
              {errors.slug && (
                <p className="text-sm text-red-400">{errors.slug.message}</p>
              )}
            </div>

            {/* Description */}
            <div className="space-y-2">
              <Label htmlFor="description" className="text-zinc-300">
                Description
              </Label>
              <Textarea
                id="description"
                {...register("description")}
                className="min-h-[120px] border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-500"
                placeholder="Project description"
              />
            </div>

            {/* Category */}
            <div className="space-y-2">
              <Label htmlFor="main_category_id" className="text-zinc-300">
                Category
              </Label>
              <Select
                id="main_category_id"
                {...register("main_category_id")}
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
              >
                <option value="">None</option>
                {categories.map((cat) => (
                  <option key={cat.id} value={cat.id}>
                    {cat.parent_name ? `${cat.parent_name} / ` : ""}
                    {cat.name}
                  </option>
                ))}
              </Select>
            </div>

            {/* Price */}
            <div className="space-y-2">
              <Label htmlFor="price" className="text-zinc-300">
                Price
              </Label>
              <Input
                id="price"
                type="number"
                step="any"
                {...register("price", { valueAsNumber: true })}
                className="border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-500"
                placeholder="0"
              />
            </div>

            {/* Status */}
            <div className="space-y-2">
              <Label htmlFor="status" className="text-zinc-300">
                Status
              </Label>
              <Select
                id="status"
                {...register("status")}
                className="border-zinc-700 bg-zinc-800 text-zinc-100"
              >
                <option value="draft">Draft</option>
                <option value="published">Published</option>
              </Select>
            </div>
          </CardContent>
        </Card>

        {/* Actions */}
        <div className="flex items-center gap-3">
          <Button
            type="submit"
            disabled={saving || isPending}
            className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200 disabled:opacity-50"
          >
            {saving
              ? "Saving..."
              : mode === "create"
                ? "Create Project"
                : "Save Changes"}
          </Button>

          <Button
            type="button"
            variant="ghost"
            onClick={() => router.push("/admin/products")}
            className="text-zinc-400 hover:text-zinc-200"
          >
            Cancel
          </Button>

          {mode === "edit" && (
            <Button
              type="button"
              variant="destructive"
              onClick={() => setShowDeleteDialog(true)}
              disabled={deleting || saving}
              className="ml-auto"
            >
              Delete
            </Button>
          )}
        </div>
      </form>

      {/* Delete confirmation dialog */}
      <Dialog open={showDeleteDialog} onOpenChange={setShowDeleteDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete Project</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete this project? This action can be
              undone by an administrator.
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
              disabled={deleting || isPending}
            >
              {deleting ? "Deleting..." : "Delete"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  );
}
