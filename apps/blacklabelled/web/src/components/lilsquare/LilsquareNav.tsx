"use client";

import { useState, useEffect } from "react";
import Link from "next/link";

const NAV_LINKS = [
  { href: "/lilsquare/projects", label: "PROJECTS" },
  { href: "/lilsquare/map", label: "MAP" },
  { href: "/lilsquare/about", label: "ABOUT" },
  { href: "/lilsquare/process", label: "PROCESS" },
  { href: "/lilsquare/contact", label: "CONTACT" },
];

const MENU_LEFT = [
  { href: "/lilsquare/about", label: "About" },
  { href: "/lilsquare/services", label: "Services" },
];

const MENU_CENTER = [
  { href: "/lilsquare/projects", label: "Projects", count: 427 },
  { href: "/lilsquare/reviews", label: "Reviews", count: 168 },
  { href: "/lilsquare/layouts", label: "Layouts", count: 124 },
];

const MENU_RIGHT = [
  { href: "/lilsquare/proposals", label: "Proposals", count: 6 },
  { href: "/lilsquare/episodes", label: "Episodes", count: 3 },
];

const SNS_LINKS = [
  { href: "https://www.instagram.com/blacklabelled/", label: "Instagram" },
  { href: "https://blog.naver.com/blacklabelled", label: "Blog" },
  { href: "https://www.youtube.com/@blacklabelled", label: "Youtube" },
  { href: "https://www.pinterest.co.kr/blacklabelled/", label: "Pinterest" },
];

export default function LilsquareNav() {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);

  useEffect(() => {
    const handler = () => setScrolled(window.scrollY > 50);
    window.addEventListener("scroll", handler, { passive: true });
    return () => window.removeEventListener("scroll", handler);
  }, []);

  useEffect(() => {
    if (menuOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    return () => {
      document.body.style.overflow = "";
    };
  }, [menuOpen]);

  return (
    <>
      <nav
        className={`fixed top-0 left-0 right-0 z-50 transition-all duration-500 ${
          scrolled
            ? "bg-black/80 backdrop-blur-md"
            : "bg-transparent"
        }`}
      >
        <div className="max-w-7xl mx-auto px-6 md:px-10 flex items-center justify-between h-20">
          {/* Logo */}
          <Link
            href="/lilsquare"
            className="font-heading text-white text-lg tracking-[0.15em] font-bold"
          >
            BLACKLABELLED
          </Link>

          {/* Desktop links */}
          <div className="hidden md:flex items-center gap-8">
            {NAV_LINKS.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className="text-[13px] tracking-[0.2em] text-text-secondary uppercase hover:text-white transition-colors duration-300"
              >
                {link.label}
              </Link>
            ))}

            {/* 상담신청 button */}
            <Link
              href="/lilsquare/contact"
              className="ml-2 px-5 py-2 bg-gold text-white text-[12px] tracking-[0.15em] font-semibold hover:bg-gold-dark transition-colors duration-300"
            >
              상담신청
            </Link>

            {/* Grid icon — opens fullscreen menu */}
            <button
              className="ml-1 w-8 h-8 flex flex-col justify-center items-center gap-[3px]"
              aria-label="전체 메뉴"
              onClick={() => setMenuOpen(true)}
            >
              <div className="flex gap-[3px]">
                <span className="w-[5px] h-[5px] bg-text-secondary" />
                <span className="w-[5px] h-[5px] bg-text-secondary" />
              </div>
              <div className="flex gap-[3px]">
                <span className="w-[5px] h-[5px] bg-text-secondary" />
                <span className="w-[5px] h-[5px] bg-text-secondary" />
              </div>
            </button>
          </div>

          {/* Mobile hamburger */}
          <button
            className="md:hidden relative w-8 h-8 flex flex-col justify-center items-center gap-1.5"
            onClick={() => setMenuOpen(!menuOpen)}
            aria-label="메뉴"
          >
            <span
              className={`block w-6 h-[1px] bg-white transition-all duration-300 ${
                menuOpen ? "rotate-45 translate-y-[3.5px]" : ""
              }`}
            />
            <span
              className={`block w-6 h-[1px] bg-white transition-all duration-300 ${
                menuOpen ? "-rotate-45 -translate-y-[3.5px]" : ""
              }`}
            />
          </button>
        </div>
      </nav>

      {/* Fullscreen white overlay menu */}
      {menuOpen && (
        <div className="fixed inset-0 z-[100] bg-white animate-[fadeIn_0.3s_ease] flex flex-col">
          {/* Top bar */}
          <div className="flex items-center justify-between px-6 md:px-10 h-20 max-w-7xl mx-auto w-full">
            <Link
              href="/lilsquare"
              onClick={() => setMenuOpen(false)}
              className="font-heading text-black text-lg tracking-[0.15em] font-bold"
            >
              BLACKLABELLED
            </Link>
            <div className="flex items-center gap-4">
              <Link
                href="/lilsquare/contact"
                onClick={() => setMenuOpen(false)}
                className="px-5 py-2 bg-gold text-white text-[12px] tracking-[0.15em] font-semibold hover:bg-gold-dark transition-colors duration-300"
              >
                상담신청
              </Link>
              <button
                onClick={() => setMenuOpen(false)}
                className="w-10 h-10 flex items-center justify-center text-black hover:text-gray-500 transition-colors"
                aria-label="닫기"
              >
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                  <path d="M18 6L6 18M6 6l12 12" />
                </svg>
              </button>
            </div>
          </div>

          {/* Menu content */}
          <div className="flex-1 flex flex-col justify-center px-6 md:px-16 lg:px-24 max-w-7xl mx-auto w-full">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 md:gap-12">
              {/* Left column — About / Services */}
              <div className="flex flex-col gap-4 md:gap-6">
                {MENU_LEFT.map((item) => (
                  <Link
                    key={item.href}
                    href={item.href}
                    onClick={() => setMenuOpen(false)}
                    className="text-4xl md:text-5xl lg:text-7xl font-black text-black hover:text-gray-400 transition-colors duration-300 leading-tight"
                  >
                    {item.label}
                  </Link>
                ))}
              </div>

              {/* Center column — Projects / Reviews / Layouts */}
              <div className="flex flex-col gap-4 md:gap-6">
                {MENU_CENTER.map((item) => (
                  <Link
                    key={item.href}
                    href={item.href}
                    onClick={() => setMenuOpen(false)}
                    className="group relative inline-flex items-baseline gap-2 text-2xl md:text-3xl lg:text-5xl font-bold text-black hover:text-gray-400 transition-colors duration-300 leading-tight"
                  >
                    {item.label}
                    <span className="inline-flex items-center justify-center min-w-[24px] h-6 px-1.5 rounded-full bg-red-500 text-white text-[11px] font-bold -translate-y-[0.6em]">
                      {item.count}
                    </span>
                  </Link>
                ))}
              </div>

              {/* Right column — Proposals / Episodes */}
              <div className="flex flex-col gap-4 md:gap-6">
                {MENU_RIGHT.map((item) => (
                  <Link
                    key={item.href}
                    href={item.href}
                    onClick={() => setMenuOpen(false)}
                    className="group relative inline-flex items-baseline gap-2 text-2xl md:text-3xl lg:text-5xl font-bold text-black hover:text-gray-400 transition-colors duration-300 leading-tight"
                  >
                    {item.label}
                    <span className="inline-flex items-center justify-center min-w-[24px] h-6 px-1.5 rounded-full bg-red-500 text-white text-[11px] font-bold -translate-y-[0.6em]">
                      {item.count}
                    </span>
                  </Link>
                ))}
              </div>
            </div>

            {/* Divider */}
            <div className="mt-12 md:mt-16 border-t border-gray-200" />

            {/* Bottom: SNS links + watermark */}
            <div className="mt-6 md:mt-8 grid grid-cols-3 items-center">
              {/* Left SNS */}
              <div className="flex flex-col gap-2 sm:flex-row sm:gap-6">
                {SNS_LINKS.slice(0, 2).map((link) => (
                  <a
                    key={link.href}
                    href={link.href}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-sm text-gray-500 hover:text-black transition-colors duration-300"
                  >
                    {link.label}{" "}
                    <span className="text-[10px]">&#8599;</span>
                  </a>
                ))}
              </div>

              {/* Center watermark */}
              <div className="text-center">
                <span className="text-xs text-gray-300 tracking-[0.3em] uppercase select-none">
                  Life Makes Sense
                </span>
              </div>

              {/* Right SNS */}
              <div className="flex flex-col gap-2 sm:flex-row sm:gap-6 justify-end">
                {SNS_LINKS.slice(2).map((link) => (
                  <a
                    key={link.href}
                    href={link.href}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-sm text-gray-500 hover:text-black transition-colors duration-300 text-right sm:text-left"
                  >
                    {link.label}{" "}
                    <span className="text-[10px]">&#8599;</span>
                  </a>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
