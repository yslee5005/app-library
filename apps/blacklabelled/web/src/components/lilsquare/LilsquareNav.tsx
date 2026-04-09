"use client";

import { useState, useEffect } from "react";
import Link from "next/link";

const NAV_LINKS = [
  { href: "/lilsquare/projects", label: "PROJECTS" },
  { href: "/lilsquare/about", label: "ABOUT" },
  { href: "/lilsquare/process", label: "PROCESS" },
  { href: "/lilsquare/contact", label: "CONTACT" },
];

export default function LilsquareNav() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    const handler = () => setScrolled(window.scrollY > 50);
    window.addEventListener("scroll", handler, { passive: true });
    return () => window.removeEventListener("scroll", handler);
  }, []);

  useEffect(() => {
    if (mobileOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    return () => {
      document.body.style.overflow = "";
    };
  }, [mobileOpen]);

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

            {/* Grid icon */}
            <button className="ml-1 w-8 h-8 flex flex-col justify-center items-center gap-[3px]" aria-label="메뉴">
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
            onClick={() => setMobileOpen(!mobileOpen)}
            aria-label="메뉴"
          >
            <span
              className={`block w-6 h-[1px] bg-white transition-all duration-300 ${
                mobileOpen ? "rotate-45 translate-y-[3.5px]" : ""
              }`}
            />
            <span
              className={`block w-6 h-[1px] bg-white transition-all duration-300 ${
                mobileOpen ? "-rotate-45 -translate-y-[3.5px]" : ""
              }`}
            />
          </button>
        </div>
      </nav>

      {/* Mobile fullscreen overlay */}
      {mobileOpen && (
        <div className="fixed inset-0 z-40 bg-bg-primary flex flex-col items-center justify-center gap-10 animate-[fadeIn_0.3s_ease]">
          {NAV_LINKS.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              onClick={() => setMobileOpen(false)}
              className="font-heading text-3xl tracking-[0.2em] text-white hover:text-gold transition-colors duration-300"
            >
              {link.label}
            </Link>
          ))}
          <Link
            href="/lilsquare/contact"
            onClick={() => setMobileOpen(false)}
            className="mt-4 px-8 py-3 bg-gold text-white text-sm tracking-[0.15em] font-semibold hover:bg-gold-dark transition-colors duration-300"
          >
            상담신청
          </Link>
        </div>
      )}
    </>
  );
}
