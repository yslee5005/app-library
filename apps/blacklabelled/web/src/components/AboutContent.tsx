"use client";

import { useEffect, useRef, useState } from "react";
import { motion } from "framer-motion";
import Link from "next/link";

interface CounterProps {
  target: number;
  suffix: string;
  label: string;
}

function Counter({ target, suffix, label }: CounterProps) {
  const [count, setCount] = useState(0);
  const ref = useRef<HTMLDivElement>(null);
  const started = useRef(false);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting && !started.current) {
          started.current = true;
          const duration = 2000;
          const start = performance.now();
          const animate = (now: number) => {
            const progress = Math.min((now - start) / duration, 1);
            const eased = 1 - Math.pow(1 - progress, 3);
            setCount(Math.floor(eased * target));
            if (progress < 1) requestAnimationFrame(animate);
          };
          requestAnimationFrame(animate);
        }
      },
      { threshold: 0.5 }
    );
    if (ref.current) observer.observe(ref.current);
    return () => observer.disconnect();
  }, [target]);

  return (
    <div ref={ref} className="text-center">
      <p className="font-heading text-5xl md:text-6xl text-gold font-light">
        {count}
        {suffix}
      </p>
      <p className="text-text-muted text-sm tracking-[0.15em] uppercase font-body mt-3">
        {label}
      </p>
    </div>
  );
}

export default function AboutContent() {
  return (
    <>
      {/* Hero */}
      <section className="relative h-[60vh] md:h-[70vh] flex items-center justify-center bg-bg-secondary overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-b from-bg-primary/60 to-bg-primary" />
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1 }}
          className="relative z-10 text-center px-6"
        >
          <h1 className="font-heading text-4xl md:text-5xl lg:text-6xl text-text-primary font-light tracking-wider">
            BLACKLABELLED
          </h1>
          <p className="font-heading text-xl md:text-2xl text-gold font-light tracking-wider mt-4">
            DESIGN STUDIO
          </p>
        </motion.div>
      </section>

      {/* Philosophy */}
      <section className="py-20 md:py-32 px-6 md:px-10">
        <div className="max-w-3xl mx-auto text-center">
          <motion.h2
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-100px" }}
            transition={{ duration: 0.8 }}
            className="font-heading text-3xl md:text-4xl text-text-primary font-light tracking-wider"
          >
            설계에서 현실로
          </motion.h2>
          <motion.p
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-100px" }}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="text-text-secondary text-base md:text-lg leading-relaxed font-body mt-8"
          >
            블랙라벨드는 공간의 본질을 탐구합니다. 단순히 아름다운 공간이 아니라,
            그 안에서 살아가는 사람의 삶을 깊이 이해하고 설계합니다. 도면 위의
            선 하나하나가 현실의 공간으로 완성되기까지, 디자인과 시공의 모든
            과정을 직접 책임집니다.
          </motion.p>
          <motion.p
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-100px" }}
            transition={{ duration: 0.8, delay: 0.3 }}
            className="text-text-secondary text-base md:text-lg leading-relaxed font-body mt-6"
          >
            &ldquo;Your space is black label&rdquo; — 당신의 공간에 블랙라벨의
            가치를 더합니다.
          </motion.p>
        </div>
      </section>

      {/* Numbers */}
      <section className="py-20 md:py-32 px-6 md:px-10 border-t border-border border-b">
        <div className="max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-12 md:gap-8">
          <Counter target={427} suffix="+" label="Projects" />
          <Counter target={10} suffix="+" label="Years" />
          <Counter target={1} suffix="" label="Seongnam Based" />
        </div>
      </section>

      {/* Contact Info */}
      <section className="py-20 md:py-32 px-6 md:px-10">
        <div className="max-w-3xl mx-auto">
          <motion.h2
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-100px" }}
            transition={{ duration: 0.8 }}
            className="font-heading text-3xl md:text-4xl text-text-primary font-light tracking-wider text-center mb-12"
          >
            Contact
          </motion.h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8 text-center md:text-left">
            <div className="space-y-4">
              <div>
                <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                  주소
                </p>
                <p className="text-text-primary font-body mt-1">
                  경기도 성남시 중원구 양현로 411
                  <br />
                  시티오피스타워 605호
                </p>
              </div>
              <div>
                <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                  전화
                </p>
                <p className="text-text-primary font-body mt-1">
                  010-9887-2826
                </p>
              </div>
            </div>
            <div className="space-y-4">
              <div>
                <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                  이메일
                </p>
                <p className="text-text-primary font-body mt-1">
                  blacklabelled@naver.com
                </p>
              </div>
              <div>
                <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                  카카오톡
                </p>
                <p className="text-text-primary font-body mt-1">블랙라벨드</p>
              </div>
              <div>
                <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                  영업시간
                </p>
                <p className="text-text-primary font-body mt-1">
                  월 – 금 9:30 ~ 18:30
                </p>
              </div>
            </div>
          </div>

          <div className="mt-14 text-center">
            <Link
              href="/contact"
              className="inline-block bg-gold text-bg-primary px-10 py-4 text-sm tracking-[0.2em] uppercase font-body font-medium hover:bg-gold-light transition-colors duration-300"
            >
              상담 문의
            </Link>
          </div>
        </div>
      </section>
    </>
  );
}
