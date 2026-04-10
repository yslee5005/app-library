"use client";

import { useRef, useEffect, useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import type { MapProduct } from "@/lib/data";
import { useScrollReveal } from "@/hooks/useScrollReveal";

interface LilsquareMapProps {
  products: MapProduct[];
}

const REVEAL_STYLE = {
  transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
};

/* ───────────────── Hero ───────────────── */
function HeroSection() {
  return (
    <section className="relative pt-40 pb-16 md:pt-48 md:pb-20 overflow-hidden">
      <div className="absolute inset-0 bg-bg-primary" />
      <div className="relative z-10 text-center px-6">
        <h1
          className="text-white text-[10vw] md:text-[4vw] font-light tracking-[0.3em] opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.2s" }}
        >
          LOCATION
        </h1>
      </div>
    </section>
  );
}

/* ───────────────── Map Section ───────────────── */
function MapSection({ products }: { products: MapProduct[] }) {
  const mapContainer = useRef<HTMLDivElement>(null);
  const mapRef = useRef<mapboxgl.Map | null>(null);
  const markersRef = useRef<mapboxgl.Marker[]>([]);
  const popupRef = useRef<mapboxgl.Popup | null>(null);
  const router = useRouter();

  const [mapLoaded, setMapLoaded] = useState(false);
  const [tokenMissing, setTokenMissing] = useState(false);

  const token = process.env.NEXT_PUBLIC_MAPBOX_TOKEN;

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
        center: [127.1273, 37.4116], // 야탑 (사무실 근처)
        zoom: 13,
        attributionControl: false,
      });

      map.addControl(
        new mapboxgl.NavigationControl({ showCompass: false }),
        "bottom-right",
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

  // Add markers
  useEffect(() => {
    if (!mapRef.current || !mapLoaded) return;

    clearMarkers();

    async function addMarkers() {
      const mapboxgl = (await import("mapbox-gl")).default;
      const map = mapRef.current!;

      // Office marker (gold, larger)
      const officeEl = document.createElement("div");
      officeEl.innerHTML = `
        <svg width="20" height="20" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
          <circle cx="10" cy="10" r="8" fill="#C5A46C" stroke="#0A0A0A" stroke-width="2"/>
        </svg>
      `;
      officeEl.style.cursor = "pointer";

      const officeMarker = new mapboxgl.Marker({ element: officeEl })
        .setLngLat([127.1273, 37.4116])
        .addTo(map);
      markersRef.current.push(officeMarker);

      // Project markers
      products.forEach((product) => {
        const el = document.createElement("div");
        el.innerHTML = `
          <svg width="10" height="10" viewBox="0 0 10 10" xmlns="http://www.w3.org/2000/svg">
            <circle cx="5" cy="5" r="4" fill="#C5A46C" fill-opacity="0.6" stroke="#0A0A0A" stroke-width="1"/>
          </svg>
        `;
        el.style.cursor = "pointer";
        el.style.transition = "transform 0.2s ease, filter 0.2s ease";

        el.addEventListener("mouseenter", () => {
          el.style.transform = "scale(1.8)";
          el.style.filter = "drop-shadow(0 0 6px #C5A46C)";

          if (popupRef.current) popupRef.current.remove();

          const popup = new mapboxgl.Popup({
            closeButton: false,
            closeOnClick: false,
            offset: 12,
          })
            .setLngLat(product.coordinates)
            .setHTML(
              `<div style="background:#141414;padding:8px;border-radius:2px;min-width:160px;border:1px solid #222;">
                <div style="font-size:13px;color:#F5F5F0;font-weight:400;margin-bottom:2px;">${product.name}</div>
                <div style="font-size:10px;color:#C5A46C;text-transform:uppercase;letter-spacing:0.1em;">${product.category}</div>
              </div>`,
            )
            .addTo(map);

          popupRef.current = popup;
        });

        el.addEventListener("mouseleave", () => {
          el.style.transform = "scale(1)";
          el.style.filter = "none";
        });

        el.addEventListener("click", () => {
          router.push(
            `/lilsquare/projects/${encodeURIComponent(product.slug)}`,
          );
        });

        const marker = new mapboxgl.Marker({ element: el })
          .setLngLat(product.coordinates)
          .addTo(map);
        markersRef.current.push(marker);
      });
    }

    addMarkers();
  }, [mapLoaded, products, clearMarkers, router]);

  if (tokenMissing) {
    return (
      <section className="px-6 md:px-10 pb-16">
        <div className="max-w-5xl mx-auto bg-bg-card border border-border flex items-center justify-center" style={{ height: "60vh" }}>
          <div className="text-center px-6">
            <div className="text-gold mb-4">
              <svg
                width="40"
                height="40"
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
            <p className="text-text-muted text-sm">
              지도를 표시하려면{" "}
              <code className="text-gold bg-bg-primary px-1.5 py-0.5 text-xs">
                NEXT_PUBLIC_MAPBOX_TOKEN
              </code>
              이 필요합니다.
            </p>
          </div>
        </div>
      </section>
    );
  }

  return (
    <section className="px-6 md:px-10 pb-16">
      <div className="max-w-5xl mx-auto relative" style={{ height: "60vh" }}>
        <div ref={mapContainer} className="w-full h-full" />
        {!mapLoaded && (
          <div className="absolute inset-0 flex items-center justify-center bg-bg-primary/80">
            <p className="text-text-muted text-sm tracking-[0.15em] uppercase font-body">
              Loading Map...
            </p>
          </div>
        )}
      </div>

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
    </section>
  );
}

/* ───────────────── 오시는 길 정보 ───────────────── */
function DirectionsSection() {
  const { ref, visible } = useScrollReveal(0.15);

  return (
    <section ref={ref} className="px-6 md:px-10 pb-20 md:pb-28">
      <div
        className={`max-w-5xl mx-auto transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[40px]"
        }`}
        style={REVEAL_STYLE}
      >
        {/* 주소 */}
        <p className="text-text-primary text-xl md:text-2xl font-light tracking-wider text-center mb-12">
          경기도 성남시 중원구 양현로 411, 시티오피스타워 605호
        </p>

        {/* 교통 안내 3열 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-10 md:gap-8">
          {/* 지하철 */}
          <div className="text-center md:text-left">
            <div className="flex items-center justify-center md:justify-start gap-2 mb-3">
              <svg
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="1.5"
                className="text-gold"
              >
                <rect x="4" y="3" width="16" height="14" rx="2" />
                <path d="M4 10h16" />
                <circle cx="8" cy="15" r="1" fill="currentColor" />
                <circle cx="16" cy="15" r="1" fill="currentColor" />
                <path d="M6 17l-2 4" />
                <path d="M18 17l2 4" />
              </svg>
              <p className="text-gold text-xs tracking-[0.15em] uppercase font-body font-medium">
                지하철
              </p>
            </div>
            <p className="text-text-secondary text-sm leading-relaxed">
              분당선 야탑역 2번 출구
              <br />
              도보 약 5분
            </p>
          </div>

          {/* 버스 */}
          <div className="text-center md:text-left">
            <div className="flex items-center justify-center md:justify-start gap-2 mb-3">
              <svg
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="1.5"
                className="text-gold"
              >
                <rect x="3" y="3" width="18" height="14" rx="2" />
                <path d="M3 10h18" />
                <circle cx="7" cy="15" r="1" fill="currentColor" />
                <circle cx="17" cy="15" r="1" fill="currentColor" />
                <path d="M5 17v2" />
                <path d="M19 17v2" />
              </svg>
              <p className="text-gold text-xs tracking-[0.15em] uppercase font-body font-medium">
                버스
              </p>
            </div>
            <p className="text-text-secondary text-sm leading-relaxed">
              야탑역 정류장 하차
              <br />
              간선/일반 다수 노선
            </p>
          </div>

          {/* 자가용 */}
          <div className="text-center md:text-left">
            <div className="flex items-center justify-center md:justify-start gap-2 mb-3">
              <svg
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="1.5"
                className="text-gold"
              >
                <path d="M5 17h14v-5l-2-5H7L5 12v5z" />
                <circle cx="7.5" cy="17.5" r="1.5" />
                <circle cx="16.5" cy="17.5" r="1.5" />
                <path d="M3 12h2" />
                <path d="M19 12h2" />
              </svg>
              <p className="text-gold text-xs tracking-[0.15em] uppercase font-body font-medium">
                자가용
              </p>
            </div>
            <p className="text-text-secondary text-sm leading-relaxed">
              건물 지하 주차장 (B2) 이용
              <br />
              2시간 무료 주차
            </p>
          </div>
        </div>

        {/* 전화 + 이메일 */}
        <div className="mt-12 flex flex-wrap items-center justify-center gap-8 text-sm">
          <div className="flex items-center gap-2">
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.5"
              className="text-gold"
            >
              <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z" />
            </svg>
            <span className="text-text-primary">010-9887-2826(TR)</span>
          </div>
          <div className="flex items-center gap-2">
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.5"
              className="text-gold"
            >
              <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
              <polyline points="22,6 12,13 2,6" />
            </svg>
            <span className="text-text-primary">blacklabelled@naver.com</span>
          </div>
        </div>
      </div>
    </section>
  );
}

/* ───────────────── CTA ───────────────── */
function CTASection() {
  const { ref, visible } = useScrollReveal(0.2);

  return (
    <section ref={ref} className="py-20 md:py-28 px-6 bg-bg-secondary">
      <div
        className={`max-w-2xl mx-auto text-center transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[30px]"
        }`}
        style={REVEAL_STYLE}
      >
        <p className="text-text-primary text-xl md:text-2xl font-light tracking-wider mb-8">
          공간의 변화를 시작하세요
        </p>
        <Link
          href="/lilsquare/contact"
          className="inline-block bg-gold text-bg-primary px-10 py-4 text-sm tracking-[0.2em] uppercase font-body font-medium hover:bg-gold-light transition-colors duration-300"
        >
          상담 신청하기
        </Link>
      </div>
    </section>
  );
}

/* ───────────────── Main ───────────────── */
export default function LilsquareMap({ products }: LilsquareMapProps) {
  return (
    <div>
      <HeroSection />
      <MapSection products={products} />
      <DirectionsSection />
      <CTASection />
    </div>
  );
}
