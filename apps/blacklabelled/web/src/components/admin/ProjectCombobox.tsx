"use client";

import {
  useState,
  useEffect,
  useLayoutEffect,
  useRef,
  useCallback,
} from "react";
import { createPortal } from "react-dom";
import Image from "next/image";
import { getAdminProducts } from "@/lib/admin-actions";
import { getImageUrl } from "@/lib/data";

export interface ProjectItem {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  main_image: string | null;
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
const DROPDOWN_MAX_H = 400;
const SENTINEL_COOLDOWN_MS = 150;

export default function ProjectCombobox({
  value,
  onChange,
  valueKey = "id",
  initialSelected = null,
  placeholder = "프로젝트 검색...",
  className = "",
}: Props) {
  const [open, setOpen] = useState(false);
  const [inputValue, setInputValue] = useState("");
  const [query, setQuery] = useState("");
  const [items, setItems] = useState<ProjectItem[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [hasMore, setHasMore] = useState(true);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState<ProjectItem | null>(initialSelected);
  const [mounted, setMounted] = useState(false);
  const [dropdownStyle, setDropdownStyle] = useState<React.CSSProperties>({});

  const rootRef = useRef<HTMLDivElement>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const listRef = useRef<HTMLDivElement>(null);
  const sentinelRef = useRef<HTMLDivElement>(null);
  const debounceRef = useRef<NodeJS.Timeout | null>(null);
  const requestIdRef = useRef(0);
  const lastLoadAtRef = useRef(0);

  useEffect(() => {
    setMounted(true);
  }, []);

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
          main_image: p.main_image,
        }));
        setTotal(result.total);
        setItems((prev) => {
          const next = append ? [...prev, ...newItems] : newItems;
          setHasMore(newItems.length === PAGE_SIZE && next.length < result.total);
          return next;
        });
        lastLoadAtRef.current = Date.now();
      } finally {
        if (myId === requestIdRef.current) setLoading(false);
      }
    },
    []
  );

  // Position the portal dropdown relative to the trigger button in viewport coords.
  const updatePosition = useCallback(() => {
    const rect = rootRef.current?.getBoundingClientRect();
    if (!rect) return;
    const spaceBelow = window.innerHeight - rect.bottom;
    const openUp = spaceBelow < DROPDOWN_MAX_H;
    setDropdownStyle({
      position: "fixed",
      left: rect.left,
      width: rect.width,
      ...(openUp
        ? { bottom: window.innerHeight - rect.top + 4 }
        : { top: rect.bottom + 4 }),
    });
  }, []);

  useLayoutEffect(() => {
    if (!open) return;
    updatePosition();
  }, [open, updatePosition]);

  // Track scroll/resize while open so the dropdown stays anchored.
  useEffect(() => {
    if (!open) return;
    window.addEventListener("resize", updatePosition);
    window.addEventListener("scroll", updatePosition, true);
    return () => {
      window.removeEventListener("resize", updatePosition);
      window.removeEventListener("scroll", updatePosition, true);
    };
  }, [open, updatePosition]);

  // Debounced search + initial open load
  useEffect(() => {
    if (!open) return;
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => {
      setPage(1);
      fetchPage(query, 1, false);
    }, DEBOUNCE_MS);
    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
  }, [query, open, fetchPage]);

  // Infinite scroll
  useEffect(() => {
    if (!open || !hasMore || loading) return;
    const sentinel = sentinelRef.current;
    if (!sentinel) return;
    const observer = new IntersectionObserver(
      (entries) => {
        if (!entries[0].isIntersecting) return;
        if (Date.now() - lastLoadAtRef.current < SENTINEL_COOLDOWN_MS) return;
        const next = page + 1;
        setPage(next);
        fetchPage(query, next, true);
      },
      { root: listRef.current, threshold: 0.3 }
    );
    observer.observe(sentinel);
    return () => observer.disconnect();
  }, [open, hasMore, loading, page, query, fetchPage]);

  // Close on outside click (check both trigger and portal subtree)
  useEffect(() => {
    if (!open) return;
    const handler = (e: MouseEvent) => {
      const target = e.target as Node;
      if (
        rootRef.current?.contains(target) ||
        dropdownRef.current?.contains(target)
      ) {
        return;
      }
      setOpen(false);
    };
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, [open]);

  const handleSelect = (item: ProjectItem) => {
    setSelected(item);
    onChange(item[valueKey], item);
    setOpen(false);
    setInputValue("");
    setQuery("");
  };

  const handleClear = (e: React.MouseEvent) => {
    e.stopPropagation();
    setSelected(null);
    onChange("", null);
  };

  const displayText = selected?.name ?? "";

  const dropdown = open ? (
    <div
      ref={dropdownRef}
      style={{ ...dropdownStyle, zIndex: 9999 }}
      className="rounded-md border border-zinc-700 bg-zinc-900 shadow-xl"
    >
      <div className="border-b border-zinc-800 p-2">
        <input
          autoFocus
          type="text"
          value={inputValue}
          onChange={(e) => {
            setInputValue(e.target.value);
            setQuery(e.target.value);
          }}
          placeholder="이름으로 검색..."
          className="w-full rounded-md border border-zinc-700 bg-zinc-800 px-3 py-1.5 text-sm text-zinc-100 placeholder:text-zinc-500 focus:border-zinc-500 focus:outline-none"
        />
      </div>
      {!loading && items.length > 0 && (
        <div className="border-b border-zinc-800 px-3 py-1.5 text-xs text-zinc-500">
          {items.length}개 표시 / 총 {total}개
          {hasMore && (
            <span className="ml-1 text-zinc-600">· 스크롤로 더 보기</span>
          )}
        </div>
      )}
      <div ref={listRef} className="max-h-80 overflow-y-auto">
        {items.length === 0 && !loading && (
          <p className="py-6 text-center text-sm text-zinc-300">
            {query ? `"${query}" 검색 결과 없음` : "프로젝트 없음"}
          </p>
        )}
        {items.map((item) => (
          <button
            type="button"
            key={item.id}
            onClick={() => handleSelect(item)}
            className={`flex w-full items-center gap-3 px-3 py-2 text-left text-sm transition-colors hover:bg-zinc-800 ${
              item[valueKey] === value
                ? "bg-zinc-800 text-zinc-100"
                : "text-zinc-300"
            }`}
          >
            <div className="relative h-10 w-14 shrink-0 overflow-hidden rounded border border-zinc-800 bg-zinc-950">
              {item.main_image ? (
                <Image
                  src={getImageUrl(item.main_image)}
                  alt=""
                  fill
                  sizes="56px"
                  className="object-cover"
                />
              ) : (
                <div className="flex h-full w-full items-center justify-center text-[10px] text-zinc-600">
                  no img
                </div>
              )}
            </div>
            <span className="min-w-0 flex-1 truncate">{item.name}</span>
          </button>
        ))}
        {hasMore && <div ref={sentinelRef} className="h-4" />}
        {loading && (
          <p className="p-3 text-center text-xs text-zinc-500">로딩 중...</p>
        )}
      </div>
    </div>
  ) : null;

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
                if (e.key === "Enter" || e.key === " ")
                  handleClear(e as unknown as React.MouseEvent);
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
      {mounted && dropdown && createPortal(dropdown, document.body)}
    </div>
  );
}
