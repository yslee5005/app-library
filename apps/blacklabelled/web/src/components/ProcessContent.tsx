"use client";

import { motion } from "framer-motion";
import Link from "next/link";

const STEPS = [
  {
    number: "01",
    title: "상담",
    description:
      "고객의 라이프스타일과 취향을 깊이 이해하는 것에서 시작합니다. 공간에 대한 꿈과 필요를 경청하고, 최적의 디자인 방향을 함께 찾아갑니다.",
    icon: (
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.2">
        <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
      </svg>
    ),
  },
  {
    number: "02",
    title: "도면 설계",
    description:
      "정밀한 실측을 바탕으로 공간의 가능성을 극대화합니다. 동선, 수납, 조명 — 삶의 모든 디테일을 도면 위에 담아냅니다.",
    icon: (
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.2">
        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
        <polyline points="14 2 14 8 20 8" />
        <line x1="16" y1="13" x2="8" y2="13" />
        <line x1="16" y1="17" x2="8" y2="17" />
      </svg>
    ),
  },
  {
    number: "03",
    title: "3D 렌더링",
    description:
      "설계된 공간을 사실적인 3D 이미지로 시각화합니다. 시공 전에 완성될 공간을 미리 경험하고, 세부 사항을 조율합니다.",
    icon: (
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.2">
        <path d="M12 2L2 7l10 5 10-5-10-5z" />
        <path d="M2 17l10 5 10-5" />
        <path d="M2 12l10 5 10-5" />
      </svg>
    ),
  },
  {
    number: "04",
    title: "시공",
    description:
      "검증된 시공팀이 설계의 의도를 정확하게 구현합니다. 자재 선정부터 마감까지, 모든 과정을 직접 관리하고 품질을 보증합니다.",
    icon: (
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.2">
        <path d="M2 20h20" />
        <path d="M5 20V8l7-5 7 5v12" />
        <path d="M10 20v-6h4v6" />
      </svg>
    ),
  },
  {
    number: "05",
    title: "완공",
    description:
      "최종 점검과 스타일링으로 공간에 생명을 불어넣습니다. 도면 위의 설계가 현실의 블랙라벨 공간으로 완성되는 순간입니다.",
    icon: (
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.2">
        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
        <polyline points="22 4 12 14.01 9 11.01" />
      </svg>
    ),
  },
];

export default function ProcessContent() {
  return (
    <>
      {/* Header */}
      <section className="pt-32 pb-16 md:pb-24 px-6 md:px-10 text-center">
        <motion.h1
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="font-heading text-5xl md:text-[60px] text-text-primary font-light tracking-wider"
        >
          PROCESS
        </motion.h1>
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.1 }}
          className="text-text-muted text-sm tracking-wider font-body mt-3"
        >
          설계에서 현실까지, 블랙라벨드의 프로세스
        </motion.p>
      </section>

      {/* Timeline */}
      <section className="pb-20 md:pb-32 px-6 md:px-10">
        <div className="max-w-3xl mx-auto relative">
          {/* Vertical line */}
          <div className="absolute left-6 md:left-1/2 top-0 bottom-0 w-[1px] bg-border md:-translate-x-[0.5px]" />

          {STEPS.map((step, i) => (
            <motion.div
              key={step.number}
              initial={{ opacity: 0, y: 40 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-80px" }}
              transition={{ duration: 0.7, delay: i * 0.1 }}
              className={`relative flex items-start gap-8 md:gap-0 mb-16 last:mb-0 ${
                i % 2 === 0
                  ? "md:flex-row"
                  : "md:flex-row-reverse"
              }`}
            >
              {/* Dot */}
              <div className="absolute left-6 md:left-1/2 -translate-x-1/2 w-3 h-3 rounded-full bg-gold border-2 border-bg-primary z-10 mt-2" />

              {/* Content */}
              <div
                className={`ml-14 md:ml-0 md:w-1/2 ${
                  i % 2 === 0 ? "md:pr-16 md:text-right" : "md:pl-16"
                }`}
              >
                <div
                  className={`flex items-center gap-4 mb-3 ${
                    i % 2 === 0 ? "md:justify-end" : ""
                  }`}
                >
                  <span className="text-gold">{step.icon}</span>
                  <span className="text-gold text-xs tracking-[0.2em] font-body">
                    {step.number}
                  </span>
                </div>
                <h3 className="font-heading text-2xl md:text-3xl text-text-primary font-light tracking-wider">
                  {step.title}
                </h3>
                <p className="text-text-secondary text-sm leading-relaxed font-body mt-3">
                  {step.description}
                </p>
              </div>
            </motion.div>
          ))}
        </div>
      </section>

      {/* CTA */}
      <section className="py-20 md:py-28 px-6 md:px-10 text-center border-t border-border">
        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
          className="font-heading text-2xl md:text-3xl text-text-primary font-light tracking-wider"
        >
          프로젝트를 시작할 준비가 되셨나요?
        </motion.h2>
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8, delay: 0.2 }}
          className="mt-8"
        >
          <Link
            href="/contact"
            className="inline-block bg-gold text-bg-primary px-10 py-4 text-sm tracking-[0.2em] uppercase font-body font-medium hover:bg-gold-light transition-colors duration-300"
          >
            상담 시작하기
          </Link>
        </motion.div>
      </section>
    </>
  );
}
