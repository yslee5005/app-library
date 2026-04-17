"use client";

import { useState, useEffect, useRef, useCallback } from "react";
import { Input } from "@/components/ui/input";
import { getAdminProducts } from "@/lib/admin-actions";

export interface ProjectItem {
  id: string;
  name: string;
  slug: string;
  description: string | null;
}

interface Props {
  value: string;
  onChange: (value: string, item: ProjectItem | null) => void;
  valueKey?: "id" | "slug";
  initialSelected?: ProjectItem | null;
  placeholder?: string;
  className?: string;
}

const PAGE_SIZE = 20;
const DEBOUNCE_MS = 250;

export default function ProjectCombobox({
  value,
  onChange,
  valueKey = "id",
  initialSelected = null,
  placeholder = "프로젝트 검색...",
  className = "",
}: Props) {
  const [open, setOpen] = useState(false);
  const [search, setSearch] = useState("");
  const [items, setItems] = useState<ProjectItem[]>([]);
  const [page, setPage] = useState(1);
  const [hasMore, setHasMore] = useState(true);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState<ProjectItem | null>(initialSelected);

  const rootRef = useRef<HTMLDivElement>(null);
  const listRef = useRef<HTMLDivElement>(null);
  const sentinelRef = useRef<HTMLDivElement>(null);
  const debounceRef = useRef<NodeJS.Timeout | null>(null);
  const requestIdRef = useRef(0);

  const fetchPage = useCallback(
    async (q: string, pageNum: number, append: boolean) => {
      const myId = ++requestIdRef.current;
      setLoading(true);
      try {
        const result = await getAdminProducts({
          page: pageNum,
          limit: PAGE_SIZE,
          search: q || undefined,
        });
        if (myId !== requestIdRef.current) return;
        const newItems: ProjectItem[] = result.products.map((p) => ({
          id: p.id,
          name: p.name,
          slug: p.slug,
          description: p.description,
        }));
        setItems((prev) => (append ? [...prev, ...newItems] : newItems));
        const loaded = (append ? items.length : 0) + newItems.length;
        setHasMore(newItems.length === PAGE_SIZE && loaded < result.total);
      } finally {
        if (myId === requestIdRef.current) setLoading(false);
      }
    },
    [items.length]
  );

  // Debounced search + initial open load
  useEffect(() => {
    if (!open) return;
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => {
      setPage(1);
      fetchPage(search, 1, false);
    }, DEBOUNCE_MS);
    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [search, open]);

  // Infinite scroll
  useEffect(() => {
    if (!open || !hasMore || loading) return;
    const sentinel = sentinelRef.current;
    if (!sentinel) return;
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting) {
          const next = page + 1;
          setPage(next);
          fetchPage(search, next, true);
        }
      },
      { root: listRef.current, threshold: 0.3 }
    );
    observer.observe(sentinel);
    return () => observer.disconnect();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, hasMore, loading, page, search]);

  // Close on outside click
  useEffect(() => {
    if (!open) return;
    const handler = (e: MouseEvent) => {
      if (rootRef.current && !rootRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, [open]);

  const handleSelect = (item: ProjectItem) => {
    setSelected(item);
    onChange(item[valueKey], item);
    setOpen(false);
    setSearch("");
  };

  const handleClear = (e: React.MouseEvent) => {
    e.stopPropagation();
    setSelected(null);
    onChange("", null);
  };

  const displayText = selected?.name ?? "";

  return (
    <div ref={rootRef} className={`relative ${className}`}>
      <button
        type="button"
        onClick={() => setOpen((prev) => !prev)}
        className="flex w-full items-center justify-between rounded-md border border-zinc-700 bg-zinc-800 px-3 py-2 text-sm text-zinc-100 hover:border-zinc-600"
      >
        <span className={selected ? "text-zinc-100" : "text-zinc-500"}>
          {displayText || placeholder}
        </span>
        <span className="flex items-center gap-2">
          {selected && value && (
            <span
              role="button"
              tabIndex={0}
              onClick={handleClear}
              onKeyDown={(e) => {
                if (e.key === "Enter" || e.key === " ") handleClear(e as unknown as React.MouseEvent);
              }}
              className="text-zinc-500 hover:text-zinc-300 cursor-pointer"
              aria-label="Clear selection"
            >
              ✕
            </span>
          )}
          <span className="text-zinc-500">▾</span>
        </span>
      </button>

      {open && (
        <div className="absolute z-50 mt-1 w-full rounded-md border border-zinc-700 bg-zinc-900 shadow-xl">
          <div className="border-b border-zinc-800 p-2">
            <Input
              autoFocus
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="이름으로 검색..."
              className="border-zinc-700 bg-zinc-800 text-zinc-100 text-sm"
            />
          </div>
          <div ref={listRef} className="max-h-64 overflow-y-auto">
            {items.length === 0 && !loading && (
              <p className="p-3 text-sm text-zinc-500">
                {search ? "검색 결과 없음" : "프로젝트 없음"}
              </p>
            )}
            {items.map((item) => (
              <button
                type="button"
                key={item.id}
                onClick={() => handleSelect(item)}
                className={`flex w-full px-3 py-2 text-left text-sm transition-colors hover:bg-zinc-800 ${
                  item[valueKey] === value
                    ? "bg-zinc-800 text-zinc-100"
                    : "text-zinc-300"
                }`}
              >
                {item.name}
              </button>
            ))}
            {hasMore && <div ref={sentinelRef} className="h-4" />}
            {loading && (
              <p className="p-3 text-center text-xs text-zinc-500">로딩 중...</p>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
