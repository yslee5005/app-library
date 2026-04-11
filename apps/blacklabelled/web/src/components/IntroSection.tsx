"use client";

import { motion } from "framer-motion";
import BeforeAfterSlider from "./BeforeAfterSlider";

export default function IntroSection() {
  return (
    <section className="py-24 md:py-32 px-6 md:px-10 max-w-7xl mx-auto">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-12 md:gap-20 items-center">
        {/* Left text */}
        <motion.div
          initial={{ opacity: 0, x: -30 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true, margin: "-100px" }}
          transition={{ duration: 0.8 }}
        >
          <h2 className="font-heading text-4xl md:text-5xl text-text-primary font-light tracking-wider leading-tight">
            From Design
            <br />
            to Reality
          </h2>
          <p className="mt-6 text-text-secondary text-base leading-relaxed max-w-md">
            도면 위의 선은 현실이 됩니다. 블랙라벨드는 설계부터 시공까지, 당신의
            공간을 완성합니다.
          </p>
        </motion.div>

        {/* Right slider */}
        <motion.div
          initial={{ opacity: 0, x: 30 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true, margin: "-100px" }}
          transition={{ duration: 0.8, delay: 0.2 }}
        >
          <BeforeAfterSlider
            beforeImage={`${process.env.NEXT_PUBLIC_SUPABASE_URL}/storage/v1/object/public/blacklabelled/intro/before.png`}
            afterImage={`${process.env.NEXT_PUBLIC_SUPABASE_URL}/storage/v1/object/public/blacklabelled/intro/after.jpg`}
          />
        </motion.div>
      </div>
    </section>
  );
}
