"use client";

import { useRef, useEffect, useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import type { MapProduct } from "@/lib/data";

interface MapContentProps {
  products: MapProduct[];
  categories: string[];
}

export default function MapContent({ products, categories }: MapContentProps) {
  const mapContainer = useRef<HTMLDivElement>(null);
  const mapRef = useRef<mapboxgl.Map | null>(null);
  const markersRef = useRef<mapboxgl.Marker[]>([]);
  const popupRef = useRef<mapboxgl.Popup | null>(null);
  const router = useRouter();

  const [activeFilter, setActiveFilter] = useState<string | null>(null);
  const [mapLoaded, setMapLoaded] = useState(false);
  const [tokenMissing, setTokenMissing] = useState(false);

  const token = process.env.NEXT_PUBLIC_MAPBOX_TOKEN;

  const filteredProducts = activeFilter
    ? products.filter((p) => p.category === activeFilter)
    : products;

  const clearMarkers = useCallback(() => {
    markersRef.current.forEach((m) => m.remove());
    markersRef.current = [];
    if (popupRef.current) {
      popupRef.current.remove();
      popupRef.current = null;
    }
  }, []);

  // Initialize map
  useEffect(() => {
    if (!token) {
      setTokenMissing(true);
      return;
    }
    if (!mapContainer.current || mapRef.current) return;

    let cancelled = false;

    async function initMap() {
      const mapboxgl = (await import("mapbox-gl")).default;
      await import("mapbox-gl/dist/mapbox-gl.css");

      if (cancelled || !mapContainer.current) return;

      mapboxgl.accessToken = token!;

      const map = new mapboxgl.Map({
        container: mapContainer.current,
        style: "mapbox://styles/mapbox/dark-v11",
        center: [127.13, 37.41],
        zoom: 14,
        attributionControl: false,
      });

      map.addControl(
        new mapboxgl.NavigationControl({ showCompass: false }),
        "bottom-right"
      );

      map.on("load", () => {
        if (!cancelled) {
          mapRef.current = map;
          setMapLoaded(true);
        }
      });
    }

    initMap();

    return () => {
      cancelled = true;
      if (mapRef.current) {
        mapRef.current.remove();
        mapRef.current = null;
      }
    };
  }, [token]);

  // Add markers when map loaded or filter changes
  useEffect(() => {
    if (!mapRef.current || !mapLoaded) return;

    clearMarkers();

    async function addMarkers() {
      const mapboxgl = (await import("mapbox-gl")).default;
      const map = mapRef.current!;

      // Offset overlapping coordinates
      const coordMap = new Map<string, number>();
      const offsetProducts = filteredProducts.map((product) => {
        const key = `${product.coordinates[0].toFixed(3)},${product.coordinates[1].toFixed(3)}`;
        const count = coordMap.get(key) || 0;
        coordMap.set(key, count + 1);
        // Spread overlapping pins in a circle
        const angle = (count * 137.5 * Math.PI) / 180; // golden angle
        const radius = count * 0.0008;
        return {
          ...product,
          coordinates: [
            product.coordinates[0] + Math.cos(angle) * radius,
            product.coordinates[1] + Math.sin(angle) * radius,
          ] as [number, number],
        };
      });

      offsetProducts.forEach((product) => {
        // Custom SVG marker with proper anchor
        const el = document.createElement("div");
        el.className = "bl-map-marker";
        el.style.width = "12px";
        el.style.height = "12px";
        el.innerHTML = `
          <svg width="12" height="12" viewBox="0 0 12 12" xmlns="http://www.w3.org/2000/svg">
            <circle cx="6" cy="6" r="5" fill="#FFFFFF" stroke="#0A0A0A" stroke-width="1"/>
          </svg>
        `;
        el.style.cursor = "pointer";

        // Use CSS class for hover instead of inline transform (prevents anchor jump)
        el.addEventListener("mouseenter", () => {
          el.querySelector("circle")?.setAttribute("r", "6");
          el.querySelector("circle")?.setAttribute("fill", "#FFFFFF");

          // Show popup
          if (popupRef.current) popupRef.current.remove();

          const popup = new mapboxgl.Popup({
            closeButton: false,
            closeOnClick: false,
            offset: 15,
            className: "bl-map-popup",
          })
            .setLngLat(product.coordinates)
            .setHTML(
              `<div style="background:#141414;padding:8px;border-radius:2px;min-width:180px;border:1px solid #222;">
                <div style="width:100%;height:60px;background:url(${product.mainImage}) center/cover;border-radius:1px;margin-bottom:6px;"></div>
                <div style="font-family:Inter,sans-serif;font-size:14px;color:#F5F5F0;font-weight:400;margin-bottom:2px;">${product.name}</div>
                <div style="font-family:NanumSquare,sans-serif;font-size:10px;color:#999;text-transform:uppercase;letter-spacing:0.1em;margin-bottom:6px;">${product.category}</div>
                <div style="font-family:NanumSquare,sans-serif;font-size:11px;color:#FFF;cursor:pointer;" data-slug="${product.slug}">View Project →</div>
              </div>`
            )
            .addTo(map);

          popupRef.current = popup;

          // Click handler on popup link
          const popupEl = popup.getElement();
          const link = popupEl?.querySelector("[data-slug]");
          if (link) {
            link.addEventListener("click", () => {
              router.push(`/projects/${encodeURIComponent(product.slug)}`);
            });
          }
        });

        el.addEventListener("mouseleave", () => {
          el.querySelector("circle")?.setAttribute("r", "5");
          el.querySelector("circle")?.setAttribute("fill", "#FFFFFF");
        });

        el.addEventListener("click", () => {
          router.push(`/projects/${encodeURIComponent(product.slug)}`);
        });

        const marker = new mapboxgl.Marker({ element: el })
          .setLngLat(product.coordinates)
          .addTo(map);

        markersRef.current.push(marker);
      });
    }

    addMarkers();
  }, [mapLoaded, filteredProducts, clearMarkers, router]);

  if (tokenMissing) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-bg-primary pt-20">
        <div className="text-center max-w-md px-6">
          <div className="text-gold text-4xl mb-6">
            <svg
              width="48"
              height="48"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="1"
              className="mx-auto"
            >
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
              <circle cx="12" cy="10" r="3" />
            </svg>
          </div>
          <h2 className="font-heading text-2xl text-text-primary font-light tracking-wider mb-4">
            지도를 표시하려면 Mapbox 토큰이 필요합니다
          </h2>
          <p className="text-text-muted text-sm font-body leading-relaxed">
            <code className="text-gold bg-bg-card px-2 py-0.5 text-xs">
              .env.local
            </code>{" "}
            파일에{" "}
            <code className="text-gold bg-bg-card px-2 py-0.5 text-xs">
              NEXT_PUBLIC_MAPBOX_TOKEN
            </code>
            을 설정해주세요.
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="relative w-full h-screen pt-20">
      {/* Filter Panel */}
      <div className="absolute top-24 left-4 z-10 bg-bg-primary/90 backdrop-blur-md border border-border p-4 max-h-[calc(100vh-120px)] overflow-y-auto w-52">
        <h3 className="text-gold text-xs tracking-[0.2em] uppercase font-body mb-4">
          FILTER
        </h3>
        <button
          onClick={() => setActiveFilter(null)}
          className={`block w-full text-left text-xs tracking-[0.1em] uppercase font-body py-2 px-3 mb-1 transition-colors duration-200 ${
            activeFilter === null
              ? "bg-gold/10 text-gold border-l-2 border-gold"
              : "text-text-secondary hover:text-text-primary hover:bg-bg-hover"
          }`}
        >
          ALL ({products.length})
        </button>
        {categories.map((cat) => {
          const count = products.filter((p) => p.category === cat).length;
          return (
            <button
              key={cat}
              onClick={() =>
                setActiveFilter(activeFilter === cat ? null : cat)
              }
              className={`block w-full text-left text-xs tracking-[0.1em] uppercase font-body py-2 px-3 mb-1 transition-colors duration-200 ${
                activeFilter === cat
                  ? "bg-gold/10 text-gold border-l-2 border-gold"
                  : "text-text-secondary hover:text-text-primary hover:bg-bg-hover"
              }`}
            >
              {cat} ({count})
            </button>
          );
        })}
      </div>

      {/* Map container */}
      <div ref={mapContainer} className="w-full h-full" />

      {/* Loading overlay */}
      {!mapLoaded && !tokenMissing && (
        <div className="absolute inset-0 flex items-center justify-center bg-bg-primary/80 pt-20">
          <div className="text-text-muted text-sm tracking-[0.15em] uppercase font-body">
            Loading Map...
          </div>
        </div>
      )}

      <style jsx global>{`
        .mapboxgl-popup-content {
          background: transparent !important;
          padding: 0 !important;
          box-shadow: none !important;
          border-radius: 0 !important;
        }
        .mapboxgl-popup-tip {
          border-top-color: #141414 !important;
        }
      `}</style>
    </div>
  );
}
