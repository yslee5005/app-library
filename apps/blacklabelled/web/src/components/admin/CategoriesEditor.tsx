"use client";

import React from "react";
import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Table,
  TableHeader,
  TableBody,
  TableHead,
  TableRow,
  TableCell,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import {
  batchUpdateCategories,
  type AdminCategory,
} from "@/lib/admin-actions";

interface CategoriesEditorProps {
  initialCategories: AdminCategory[];
}

interface CategoryState {
  id: string;
  is_visible: boolean;
  sort_order: number;
}

export default function CategoriesEditor({
  initialCategories,
}: CategoriesEditorProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();
  const [changes, setChanges] = useState<Map<string, CategoryState>>(
    new Map()
  );

  // Group categories by parent
  const parents = initialCategories.filter((c) => !c.parent_id);
  const childrenMap = new Map<string, AdminCategory[]>();
  for (const cat of initialCategories) {
    if (cat.parent_id) {
      const list = childrenMap.get(cat.parent_id) ?? [];
      list.push(cat);
      childrenMap.set(cat.parent_id, list);
    }
  }

  const getCurrent = (cat: AdminCategory): CategoryState => {
    return (
      changes.get(cat.id) ?? {
        id: cat.id,
        is_visible: cat.is_visible,
        sort_order: cat.sort_order,
      }
    );
  };

  const updateField = (
    id: string,
    cat: AdminCategory,
    field: "is_visible" | "sort_order",
    value: boolean | number
  ) => {
    const current = getCurrent(cat);
    setChanges((prev) => {
      const next = new Map(prev);
      next.set(id, { ...current, [field]: value });
      return next;
    });
  };

  const hasChanges = changes.size > 0;

  const handleSave = () => {
    if (!hasChanges) return;
    startTransition(async () => {
      const updates = Array.from(changes.values());
      const result = await batchUpdateCategories(updates);
      if ("error" in result) {
        toast.error(result.error);
      } else {
        toast.success("Categories updated");
        setChanges(new Map());
        router.refresh();
      }
    });
  };

  const renderCategoryRow = (cat: AdminCategory, indent = false) => {
    const state = getCurrent(cat);
    const isChanged = changes.has(cat.id);

    return (
      <TableRow
        key={cat.id}
        className={isChanged ? "bg-zinc-800/80" : ""}
      >
        <TableCell className="text-zinc-100">
          <div className="flex items-center gap-2">
            {indent && (
              <span className="text-zinc-600 ml-4">&#x2514;</span>
            )}
            <span>{cat.name}</span>
          </div>
        </TableCell>
        <TableCell className="text-zinc-400">
          {cat.parent_name ?? "-"}
        </TableCell>
        <TableCell>
          <Badge
            variant={cat.product_count > 0 ? "default" : "secondary"}
            className="tabular-nums"
          >
            {cat.product_count}
          </Badge>
        </TableCell>
        <TableCell>
          <button
            onClick={() =>
              updateField(cat.id, cat, "is_visible", !state.is_visible)
            }
            className={`relative inline-flex h-5 w-9 items-center rounded-full transition-colors ${
              state.is_visible ? "bg-emerald-600" : "bg-zinc-700"
            }`}
          >
            <span
              className={`inline-block h-3.5 w-3.5 transform rounded-full bg-white transition-transform ${
                state.is_visible ? "translate-x-4.5" : "translate-x-1"
              }`}
            />
          </button>
        </TableCell>
        <TableCell>
          <Input
            type="number"
            value={state.sort_order}
            onChange={(e) =>
              updateField(
                cat.id,
                cat,
                "sort_order",
                parseInt(e.target.value, 10) || 0
              )
            }
            className="w-20 border-zinc-700 bg-zinc-800 text-zinc-100 text-center"
          />
        </TableCell>
      </TableRow>
    );
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <p className="text-sm text-zinc-500">
          {initialCategories.length} categories
          {hasChanges && (
            <span className="ml-2 text-amber-400">
              ({changes.size} modified)
            </span>
          )}
        </p>
        <Button
          onClick={handleSave}
          disabled={!hasChanges || isPending}
          className="bg-zinc-100 text-zinc-900 hover:bg-zinc-200 disabled:opacity-50"
        >
          {isPending ? "Saving..." : "Save Changes"}
        </Button>
      </div>

      <div className="rounded-lg border border-zinc-800 overflow-hidden">
        <Table>
          <TableHeader>
            <TableRow className="border-zinc-800 hover:bg-transparent">
              <TableHead>Name</TableHead>
              <TableHead>Parent</TableHead>
              <TableHead>Products</TableHead>
              <TableHead>Visible</TableHead>
              <TableHead>Sort Order</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {parents.map((parent) => (
              <React.Fragment key={parent.id}>
                {renderCategoryRow(parent)}
                {(childrenMap.get(parent.id) ?? []).map((child) =>
                  renderCategoryRow(child, true)
                )}
              </React.Fragment>
            ))}
            {/* Orphan categories (no parent but also not a parent themselves) */}
            {initialCategories
              .filter(
                (c) =>
                  c.parent_id &&
                  !parents.find((p) => p.id === c.parent_id)
              )
              .map((cat) => renderCategoryRow(cat))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}
