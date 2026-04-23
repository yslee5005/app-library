"use client";

import { useState } from "react";
import { motion } from "framer-motion";

const PROJECT_TYPES = [
  "Residence",
  "Commercial",
  "Boutique",
  "Kitchen",
  "Bath",
  "Furniture",
  "기타",
];

export default function ContactContent() {
  const [form, setForm] = useState({
    name: "",
    phone: "",
    email: "",
    projectType: "",
    message: "",
  });
  const [submitted, setSubmitted] = useState(false);

  const handleChange = (
    e: React.ChangeEvent<
      HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement
    >
  ) => {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log("Contact form submitted:", form);
    setSubmitted(true);
  };

  return (
    <section className="pt-32 pb-20 md:pb-32 px-6 md:px-10">
      <div className="max-w-6xl mx-auto">
        <motion.h1
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="font-heading text-5xl md:text-[60px] text-text-primary font-light tracking-wider text-center"
        >
          CONTACT
        </motion.h1>
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.1 }}
          className="text-text-muted text-sm tracking-wider text-center mt-3 font-body"
        >
          LET&apos;S CREATE YOUR SPACE
        </motion.p>

        <div className="mt-16 grid grid-cols-1 md:grid-cols-2 gap-16 md:gap-20">
          {/* Form */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
          >
            {submitted ? (
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                className="py-20 text-center"
              >
                <p className="font-heading text-2xl text-gold font-light tracking-wider">
                  문의가 접수되었습니다
                </p>
                <p className="text-text-secondary text-sm font-body mt-4">
                  빠른 시일 내에 연락드리겠습니다.
                </p>
              </motion.div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-8">
                <div>
                  <input
                    type="text"
                    name="name"
                    placeholder="이름"
                    required
                    value={form.name}
                    onChange={handleChange}
                    className="w-full bg-transparent border-b border-border py-3 text-text-primary font-body text-sm placeholder:text-text-muted focus:border-gold focus:outline-none transition-colors duration-300"
                  />
                </div>
                <div>
                  <input
                    type="tel"
                    name="phone"
                    placeholder="연락처"
                    required
                    value={form.phone}
                    onChange={handleChange}
                    className="w-full bg-transparent border-b border-border py-3 text-text-primary font-body text-sm placeholder:text-text-muted focus:border-gold focus:outline-none transition-colors duration-300"
                  />
                </div>
                <div>
                  <input
                    type="email"
                    name="email"
                    placeholder="이메일"
                    value={form.email}
                    onChange={handleChange}
                    className="w-full bg-transparent border-b border-border py-3 text-text-primary font-body text-sm placeholder:text-text-muted focus:border-gold focus:outline-none transition-colors duration-300"
                  />
                </div>
                <div>
                  <select
                    name="projectType"
                    value={form.projectType}
                    onChange={handleChange}
                    className="w-full bg-transparent border-b border-border py-3 text-text-primary font-body text-sm focus:border-gold focus:outline-none transition-colors duration-300 appearance-none cursor-pointer"
                    style={{
                      backgroundImage: `url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23666666' stroke-width='2'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E")`,
                      backgroundRepeat: "no-repeat",
                      backgroundPosition: "right 0 center",
                    }}
                  >
                    <option value="" className="bg-bg-primary text-text-muted">
                      프로젝트 유형
                    </option>
                    {PROJECT_TYPES.map((type) => (
                      <option
                        key={type}
                        value={type}
                        className="bg-bg-primary text-text-primary"
                      >
                        {type}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <textarea
                    name="message"
                    placeholder="메시지"
                    rows={4}
                    value={form.message}
                    onChange={handleChange}
                    className="w-full bg-transparent border-b border-border py-3 text-text-primary font-body text-sm placeholder:text-text-muted focus:border-gold focus:outline-none transition-colors duration-300 resize-none"
                  />
                </div>
                <button
                  type="submit"
                  className="w-full bg-gold text-bg-primary py-4 text-sm tracking-[0.2em] uppercase font-body font-medium hover:bg-gold-light transition-colors duration-300"
                >
                  문의하기
                </button>
              </form>
            )}
          </motion.div>

          {/* Info */}
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.8, delay: 0.3 }}
            className="space-y-8"
          >
            <div>
              <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                주소
              </p>
              <p className="text-text-primary font-body mt-2 leading-relaxed">
                경기도 성남시 분당구 판교로610번길 5
                <br />
                2층 (주소지1층) 블랙라벨드
              </p>
            </div>
            <div>
              <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                전화
              </p>
              <p className="text-text-primary font-body mt-2">010-9887-2826(TR)</p>
              <p className="text-text-primary font-body mt-1">010-9046-3487(TD)</p>
            </div>
            <div>
              <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                이메일
              </p>
              <p className="text-text-primary font-body mt-2">
                blacklabelled@naver.com
              </p>
            </div>
            <div>
              <p className="text-text-muted text-xs tracking-[0.15em] uppercase font-body">
                영업시간
              </p>
              <p className="text-text-primary font-body mt-2">
                평일 9:30 – 18:30
              </p>
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}
