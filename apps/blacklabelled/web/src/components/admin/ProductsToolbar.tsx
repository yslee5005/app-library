"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { useCallback, useEffect, useRef, useState } from "react";
import { Input } from "@/components/ui/input";
import { Select } from "@/components/ui/select";

interface Category {
  id: string;
  name: string;
  parent_name: string | null;
}

export default function ProductsToolbar({
  categories,
}: {
  categories: Category[];
}) {
  const router = useRouter();
  const searchParams = useSearchParams();

  const currentSearch = searchParams.get("search") ?? "";
  const currentCategory = searchParams.get("category") ?? "";

  const [searchValue, setSearchValue] = useState(currentSearch);
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Sync search input when URL changes externally
  useEffect(() => {
    setSearchValue(currentSearch);
  }, [currentSearch]);

  const updateParams = useCallback(
    (key: string, value: string) => {
      const params = new URLSearchParams(searchParams.toString());
      if (value) {
        params.set(key, value);
      } else {
        params.delete(key);
      }
      // Reset page when filters change
      params.delete("page");
      router.push(`/admin/products?${params.toString()}`);
    },
    [router, searchParams]
  );

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value;
    setSearchValue(val);

    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => {
      updateParams("search", val);
    }, 400);
  };

  const handleCategoryChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    updateParams("category", e.target.value);
  };

  return (
    <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
      <Input
        placeholder="Search products..."
        value={searchValue}
        onChange={handleSearchChange}
        className="max-w-sm border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-500"
      />
      <Select
        value={currentCategory}
        onChange={handleCategoryChange}
        className="max-w-[200px] border-zinc-700 bg-zinc-800 text-zinc-100"
      >
        <option value="">All Categories</option>
        {(() => {
          const groups = new Map<string, Category[]>();
          const noParent: Category[] = [];
          categories.forEach((cat) => {
            if (cat.parent_name) {
              if (!groups.has(cat.parent_name)) groups.set(cat.parent_name, []);
              groups.get(cat.parent_name)!.push(cat);
            } else {
              noParent.push(cat);
            }
          });
          return (
            <>
              {Array.from(groups.entries()).map(([parent, children]) => (
                <optgroup key={parent} label={parent}>
                  {children.map((cat) => (
                    <option key={cat.id} value={cat.id}>{cat.name}</option>
                  ))}
                </optgroup>
              ))}
            </>
          );
        })()}
      </Select>
    </div>
  );
}
