"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { motion, AnimatePresence } from "framer-motion";

const NAV_LINKS = [
  { href: "/projects", label: "PROJECTS" },
  { href: "/map", label: "MAP" },
  { href: "/about", label: "ABOUT" },
  { href: "/process", label: "PROCESS" },
  { href: "/magazines", label: "MAGAZINE" },
  { href: "/contact", label: "CONTACT" },
];

export default function Navigation() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 50);
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
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
        <div className="max-w-[1400px] mx-auto px-6 md:px-10 flex items-center justify-between h-20">
          {/* Logo */}
          <Link
            href="/"
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

            {/* 상담신청 버튼 */}
            <Link
              href="/contact"
              className="ml-4 px-5 py-2.5 bg-white text-black text-[13px] tracking-[0.1em] font-bold rounded-sm hover:bg-text-secondary transition-colors duration-300"
            >
              상담신청
            </Link>

            {/* 그리드 아이콘 (풀스크린 메뉴) */}
            <button
              onClick={() => setMobileOpen(true)}
              className="ml-2 w-10 h-10 flex items-center justify-center"
              aria-label="메뉴"
            >
              <div className="grid grid-cols-3 gap-[3px]">
                {Array.from({ length: 9 }).map((_, i) => (
                  <div key={i} className="w-[3px] h-[3px] bg-white rounded-full" />
                ))}
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
              className={`block w-6 h-[1px] bg-text-primary transition-all duration-300 ${
                mobileOpen ? "rotate-45 translate-y-[3.5px]" : ""
              }`}
            />
            <span
              className={`block w-6 h-[1px] bg-text-primary transition-all duration-300 ${
                mobileOpen ? "-rotate-45 -translate-y-[3.5px]" : ""
              }`}
            />
          </button>
        </div>
      </nav>

      {/* Fullscreen overlay menu */}
      <AnimatePresence>
        {mobileOpen && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.3 }}
            className="fixed inset-0 z-[100] bg-white flex flex-col"
          >
            {/* Top bar */}
            <div className="max-w-[1400px] mx-auto px-6 md:px-10 flex items-center justify-between h-20 w-full">
              <Link
                href="/"
                onClick={() => setMobileOpen(false)}
                className="font-heading text-black text-lg tracking-[0.15em] font-bold"
              >
                BLACKLABELLED
              </Link>
              <div className="flex items-center gap-4">
                <Link
                  href="/contact"
                  onClick={() => setMobileOpen(false)}
                  className="px-5 py-2.5 bg-red-500 text-white text-[13px] tracking-[0.1em] font-bold rounded-sm"
                >
                  상담신청
                </Link>
                <button
                  onClick={() => setMobileOpen(false)}
                  className="text-black text-3xl font-light"
                  aria-label="닫기"
                >
                  ✕
                </button>
              </div>
            </div>

            {/* Menu content */}
            <div className="flex-1 flex px-10 md:px-20 py-10">
              {/* Left — large links */}
              <div className="flex flex-col justify-center gap-2 w-1/3">
                <motion.div
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.1 }}
                >
                  <Link
                    href="/about"
                    onClick={() => setMobileOpen(false)}
                    className="text-5xl md:text-7xl font-black text-black hover:text-gray-500 transition-colors"
                  >
                    About
                  </Link>
                </motion.div>
                <motion.div
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.2 }}
                >
                  <Link
                    href="/process"
                    onClick={() => setMobileOpen(false)}
                    className="text-5xl md:text-7xl font-black text-black hover:text-gray-500 transition-colors"
                  >
                    Process
                  </Link>
                </motion.div>
              </div>

              {/* Right — links with counts */}
              <div className="flex-1 flex flex-wrap content-center gap-x-20 gap-y-6 pl-10">
                {[
                  { href: "/projects", label: "Projects", count: 427 },
                  { href: "/magazines", label: "Magazine" },
                  { href: "/contact", label: "Contact" },
                  { href: "/map", label: "Map" },
                ].map((item, i) => (
                  <motion.div
                    key={item.href}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 0.15 + i * 0.1 }}
                  >
                    <Link
                      href={item.href}
                      onClick={() => setMobileOpen(false)}
                      className="text-3xl md:text-5xl font-bold text-black hover:text-gray-500 transition-colors relative"
                    >
                      {item.label}
                      {item.count && (
                        <span className="absolute -top-2 -right-8 bg-red-500 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full">
                          {item.count}
                        </span>
                      )}
                    </Link>
                  </motion.div>
                ))}
              </div>
            </div>

            {/* Bottom — SNS + watermark */}
            <div className="px-10 md:px-20 pb-10 flex items-end justify-between border-t border-gray-200 pt-6">
              <div className="flex gap-6">
                <a href="#" className="text-black text-sm hover:text-gray-500">Instagram ↗</a>
                <a href="#" className="text-black text-sm hover:text-gray-500">Blog ↗</a>
              </div>
              <span className="text-gray-300 text-sm tracking-[0.3em] hidden md:block">
                Life Makes Sense
              </span>
              <div className="flex gap-6">
                <a href="#" className="text-black text-sm hover:text-gray-500">Youtube ↗</a>
                <a href="#" className="text-black text-sm hover:text-gray-500">Pinterest ↗</a>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}
