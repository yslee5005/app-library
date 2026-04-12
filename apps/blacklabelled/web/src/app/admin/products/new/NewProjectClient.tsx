"use client";

import { useState } from "react";
import ProductForm from "@/components/admin/ProductForm";
import ImageManager from "@/components/admin/ImageManager";

interface Category {
  id: string;
  name: string;
  parent_name: string | null;
}

export default function NewProjectClient({
  categories,
}: {
  categories: Category[];
}) {
  const [createdId, setCreatedId] = useState<string | null>(null);

  return (
    <div>
      <h1 className="mb-6 text-2xl font-bold text-zinc-100">
        {createdId ? "Project Created — Add Images" : "New Project"}
      </h1>

      <div className="max-w-2xl">
        <ProductForm
          mode={createdId ? "edit" : "create"}
          productId={createdId ?? undefined}
          categories={categories}
          onCreated={(id) => setCreatedId(id)}
        />
      </div>

      {createdId && (
        <div className="mt-8 max-w-4xl">
          <h2 className="mb-4 text-lg font-semibold text-zinc-100">
            Images
          </h2>
          <ImageManager productId={createdId} initialImages={[]} />
        </div>
      )}
    </div>
  );
}
