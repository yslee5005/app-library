"use client";

import { useState } from "react";
import Link from "next/link";
import { useScrollReveal } from "@/hooks/useScrollReveal";

const BUDGET_OPTIONS = [
  "1,000만원 이하",
  "1,000 ~ 3,000만원",
  "3,000 ~ 5,000만원",
  "5,000 ~ 1억원",
  "1억원 이상",
  "미정 / 상담 후 결정",
];

const REVEAL_STYLE = {
  transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)",
};

/* ───────────────── Hero ───────────────── */
function HeroSection() {
  return (
    <section className="relative pt-40 pb-20 md:pt-48 md:pb-28 overflow-hidden">
      <div className="absolute inset-0 bg-bg-primary" />
      <div className="relative z-10 text-center px-6">
        <h1
          className="text-white text-[10vw] md:text-[4vw] font-light tracking-[0.3em] opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.2s" }}
        >
          CONTACT
        </h1>
        <p
          className="text-text-secondary text-base md:text-lg font-light tracking-[0.1em] mt-4 opacity-0 animate-heroTitle"
          style={{ animationDelay: "0.6s" }}
        >
          공간의 시작은 대화에서부터
        </p>
      </div>
    </section>
  );
}

/* ───────────────── 연락 정보 카드 (2열) ───────────────── */
function InfoCards() {
  const { ref, visible } = useScrollReveal(0.15);

  return (
    <section ref={ref} className="px-6 md:px-10 pb-20 md:pb-28">
      <div
        className={`max-w-5xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-10 md:gap-16 transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[40px]"
        }`}
        style={REVEAL_STYLE}
      >
        {/* Left: 연락처 */}
        <div className="space-y-8">
          <div>
            <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
              전화
            </p>
            <p className="text-gold text-3xl md:text-4xl font-light tracking-wider mt-2">
              010-9887-2826(TR)
            </p>
          </div>
          <div>
            <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
              이메일
            </p>
            <p className="text-text-primary text-lg font-body mt-2">
              blacklabelled@naver.com
            </p>
          </div>
          <div>
            <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
              주소
            </p>
            <p className="text-text-primary font-body mt-2 leading-relaxed">
              경기도 성남시 중원구 양현로 411
              <br />
              시티오피스타워 605호
            </p>
          </div>
        </div>

        {/* Right: 상담 시간 + 오시는 길 */}
        <div className="space-y-8">
          <div>
            <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
              상담 시간
            </p>
            <p className="text-text-primary font-body mt-2 leading-relaxed">
              월 – 금 &nbsp;9:30 ~ 18:30
              <br />
              <span className="text-text-muted text-sm">
                (주말·공휴일 사전 예약 시 상담 가능)
              </span>
            </p>
          </div>
          <div>
            <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
              오시는 길
            </p>
            <p className="text-text-primary font-body mt-2 leading-relaxed text-sm">
              야탑역 2번 출구 도보 5분
              <br />
              주차장 이용 가능 (건물 지하 B2)
            </p>
          </div>
          <div>
            <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
              카카오톡
            </p>
            <p className="text-text-primary font-body mt-2">블랙라벨드</p>
          </div>
        </div>
      </div>
    </section>
  );
}

/* ───────────────── 상담 폼 ───────────────── */
function ConsultForm() {
  const { ref, visible } = useScrollReveal(0.1);
  const [form, setForm] = useState({
    name: "",
    phone: "",
    address: "",
    area: "",
    budget: "",
    message: "",
  });
  const [agreed, setAgreed] = useState(false);
  const [submitted, setSubmitted] = useState(false);

  const handleChange = (
    e: React.ChangeEvent<
      HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement
    >,
  ) => {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!agreed) return;
    console.log("Consultation form submitted:", form);
    setSubmitted(true);
  };

  const inputClass =
    "w-full bg-transparent border-b border-border py-3 text-text-primary font-body text-sm placeholder:text-text-muted focus:border-gold focus:outline-none transition-colors duration-300";

  return (
    <section
      ref={ref}
      className="px-6 md:px-10 pb-24 md:pb-32"
    >
      <div
        className={`max-w-3xl mx-auto transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[40px]"
        }`}
        style={REVEAL_STYLE}
      >
        <h2 className="text-center text-2xl md:text-3xl font-light tracking-wider text-text-primary mb-4">
          상담 신청
        </h2>
        <p className="text-center text-text-muted text-sm mb-12">
          아래 양식을 작성해 주시면 빠른 시일 내에 연락드리겠습니다.
        </p>

        {submitted ? (
          <div className="py-20 text-center">
            <p className="font-heading text-2xl text-gold font-light tracking-wider">
              상담 신청이 접수되었습니다
            </p>
            <p className="text-text-secondary text-sm font-body mt-4">
              빠른 시일 내에 연락드리겠습니다.
            </p>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="space-y-0">
            {/* Row 1: 이름 / 연락처 */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8">
              <div className="py-2">
                <input
                  type="text"
                  name="name"
                  placeholder="이름 *"
                  required
                  value={form.name}
                  onChange={handleChange}
                  className={inputClass}
                />
              </div>
              <div className="py-2">
                <input
                  type="tel"
                  name="phone"
                  placeholder="연락처 *"
                  required
                  value={form.phone}
                  onChange={handleChange}
                  className={inputClass}
                />
              </div>
            </div>

            {/* Row 2: 주소 / 평형 */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8">
              <div className="py-2">
                <input
                  type="text"
                  name="address"
                  placeholder="주소"
                  value={form.address}
                  onChange={handleChange}
                  className={inputClass}
                />
              </div>
              <div className="py-2">
                <input
                  type="text"
                  name="area"
                  placeholder="평형 (예: 34평)"
                  value={form.area}
                  onChange={handleChange}
                  className={inputClass}
                />
              </div>
            </div>

            {/* 예산 범위 드롭다운 */}
            <div className="py-2">
              <select
                name="budget"
                value={form.budget}
                onChange={handleChange}
                className={`${inputClass} appearance-none cursor-pointer`}
                style={{
                  backgroundImage: `url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23666666' stroke-width='2'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E")`,
                  backgroundRepeat: "no-repeat",
                  backgroundPosition: "right 0 center",
                }}
              >
                <option value="" className="bg-bg-primary text-text-muted">
                  예산 범위
                </option>
                {BUDGET_OPTIONS.map((opt) => (
                  <option
                    key={opt}
                    value={opt}
                    className="bg-bg-primary text-text-primary"
                  >
                    {opt}
                  </option>
                ))}
              </select>
            </div>

            {/* 메시지 */}
            <div className="py-2">
              <textarea
                name="message"
                placeholder="메시지"
                rows={4}
                value={form.message}
                onChange={handleChange}
                className={`${inputClass} resize-none`}
              />
            </div>

            {/* 개인정보 동의 */}
            <div className="py-4">
              <label className="flex items-start gap-3 cursor-pointer group">
                <input
                  type="checkbox"
                  checked={agreed}
                  onChange={(e) => setAgreed(e.target.checked)}
                  className="mt-0.5 w-4 h-4 accent-[#C5A46C] bg-transparent border-border"
                />
                <span className="text-text-muted text-xs leading-relaxed group-hover:text-text-secondary transition-colors">
                  개인정보 수집 및 이용에 동의합니다. 수집된 정보는 상담 목적으로만 사용되며, 상담 완료 후 즉시 파기됩니다.
                </span>
              </label>
            </div>

            {/* Submit */}
            <button
              type="submit"
              disabled={!agreed}
              className="w-full bg-gold text-bg-primary py-4 text-sm tracking-[0.2em] uppercase font-body font-medium hover:bg-gold-light transition-colors duration-300 disabled:opacity-40 disabled:cursor-not-allowed mt-4"
            >
              상담 신청하기
            </button>
          </form>
        )}
      </div>
    </section>
  );
}

/* ───────────────── 마무리: SNS ───────────────── */
function ClosingSection() {
  const { ref, visible } = useScrollReveal(0.2);

  return (
    <section
      ref={ref}
      className="py-20 md:py-28 px-6 bg-bg-secondary"
    >
      <div
        className={`max-w-2xl mx-auto text-center transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[30px]"
        }`}
        style={REVEAL_STYLE}
      >
        <p className="text-text-primary text-xl md:text-2xl font-light tracking-wider">
          편하게 연락주세요
        </p>
        <p className="text-text-muted text-sm mt-4 leading-relaxed">
          전화, 이메일, 카카오톡 어느 방법이든 좋습니다.
          <br />
          블랙라벨드가 당신만의 공간을 만들어 드립니다.
        </p>

        {/* SNS Icons */}
        <div className="flex items-center justify-center gap-6 mt-10">
          {/* Instagram */}
          <a
            href="https://www.instagram.com/blacklabelled_official"
            target="_blank"
            rel="noopener noreferrer"
            className="w-10 h-10 border border-border flex items-center justify-center text-text-muted hover:text-gold hover:border-gold transition-colors duration-300"
            aria-label="Instagram"
          >
            <svg
              width="18"
              height="18"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.5"
            >
              <rect x="2" y="2" width="20" height="20" rx="5" />
              <circle cx="12" cy="12" r="5" />
              <circle cx="17.5" cy="6.5" r="1.5" fill="currentColor" stroke="none" />
            </svg>
          </a>

          {/* KakaoTalk */}
          <a
            href="#"
            className="w-10 h-10 border border-border flex items-center justify-center text-text-muted hover:text-gold hover:border-gold transition-colors duration-300"
            aria-label="KakaoTalk"
          >
            <svg
              width="18"
              height="18"
              viewBox="0 0 24 24"
              fill="currentColor"
            >
              <path d="M12 3C6.48 3 2 6.58 2 10.94c0 2.8 1.86 5.27 4.66 6.67-.15.56-.96 3.6-.99 3.83 0 0-.02.16.08.22.1.06.22.01.22.01.29-.04 3.38-2.22 3.92-2.6.67.1 1.37.15 2.11.15 5.52 0 10-3.58 10-7.94S17.52 3 12 3z" />
            </svg>
          </a>

          {/* Blog / Naver */}
          <a
            href="#"
            className="w-10 h-10 border border-border flex items-center justify-center text-text-muted hover:text-gold hover:border-gold transition-colors duration-300"
            aria-label="Blog"
          >
            <svg
              width="18"
              height="18"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.5"
            >
              <path d="M4 4h16v16H4z" />
              <path d="M8 8v8" />
              <path d="M8 8l8 8" />
              <path d="M16 8v8" />
            </svg>
          </a>
        </div>

        {/* Map link */}
        <Link
          href="/lilsquare/map"
          className="inline-block mt-10 text-gold text-sm tracking-[0.15em] border-b border-gold/40 pb-0.5 hover:border-gold transition-colors duration-300"
        >
          오시는 길 →
        </Link>
      </div>
    </section>
  );
}

/* ───────────────── Main ───────────────── */
export default function LilsquareContact() {
  return (
    <div>
      <HeroSection />
      <InfoCards />
      <ConsultForm />
      <ClosingSection />
    </div>
  );
}
