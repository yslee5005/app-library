"use client";

import Link from "next/link";
import { useScrollReveal } from "@/hooks/useScrollReveal";
import ImageCrossfade from "./ImageCrossfade";

interface StudioIntroProps {
  project1?: { id: string; name: string; images: string[] };
  project2?: { id: string; name: string; images: string[] };
  heading?: string;
  description?: string;
  linkText?: string;
  linkUrl?: string;
}

export default function StudioIntro({ project1, project2, heading, description, linkText, linkUrl }: StudioIntroProps) {
  const { ref, visible } = useScrollReveal(0.15);

  return (
    <section
      ref={ref as React.RefObject<HTMLElement>}
      className="bg-bg-primary py-24 md:py-32"
    >
      <div
        className={`max-w-[1400px] mx-auto px-6 md:px-10 flex flex-col md:flex-row gap-10 md:gap-8 transition-all duration-1000 ${
          visible
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-[50px]"
        }`}
        style={{ transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)" }}
      >
        {/* Left — Text */}
        <div className="md:w-[35%] flex flex-col justify-center">
          <h2 className="text-3xl md:text-[40px] text-text-primary font-light leading-[1.3] tracking-wide">
            {(heading ?? "Residential Space\nDesign Studio").split("\n").map((line, i, arr) => (
              <span key={i}>
                {line}
                {i < arr.length - 1 && <br />}
              </span>
            ))}
          </h2>
          <p className="mt-8 text-text-secondary text-[15px] leading-[1.8]">
            {description ?? "공간과 사용자 사이에는 보이지 않는 수많은 이야기가 혼재합니다. 블랙라벨드는 그 이야기를 읽어내고, 설계를 통해 공간에 생명을 부여합니다. 427개 이상의 프로젝트를 통해 쌓아온 경험으로, 당신만의 공간을 블랙라벨로 만들어 드립니다."}
          </p>
          <Link
            href={linkUrl ?? "/about"}
            className="inline-block mt-12 text-lg font-medium text-white border-b-2 border-white pb-1 tracking-wider hover:text-text-secondary hover:border-text-secondary transition-colors duration-300 w-fit"
          >
            {linkText ?? "LEARN MORE"}
          </Link>
        </div>

        {/* Center — Project card 1 */}
        <div
          className={`md:w-[35%] transition-all duration-1000 delay-200 ${
            visible
              ? "opacity-100 translate-y-0"
              : "opacity-0 translate-y-[50px]"
          }`}
          style={{ transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)" }}
        >
          {project1 ? (
            <>
              <ImageCrossfade
                images={project1.images.slice(0, 2)}
                interval={3000}
                aspectRatio="4/3"
              />
              <div className="mt-4">
                <p className="text-[11px] text-text-muted tracking-[0.15em] uppercase">
                  PROJECT NO.{project1.id}
                </p>
                <h3 className="text-xl text-text-primary font-light mt-1">
                  {project1.name} _ by.BLACKLABELLED
                </h3>
              </div>
            </>
          ) : (
            <div className="aspect-[4/3] bg-bg-card" />
          )}
        </div>

        {/* Right — Project card 2 */}
        <div
          className={`md:w-[30%] md:mt-4 transition-all duration-1000 delay-[400ms] ${
            visible
              ? "opacity-100 translate-y-0"
              : "opacity-0 translate-y-[50px]"
          }`}
          style={{ transitionTimingFunction: "cubic-bezier(0.19, 1, 0.22, 1)" }}
        >
          {project2 ? (
            <>
              <ImageCrossfade
                images={project2.images.slice(0, 2)}
                interval={3500}
                aspectRatio="4/3"
              />
              <div className="mt-4">
                <p className="text-[11px] text-text-muted tracking-[0.15em] uppercase">
                  PROJECT NO.{project2.id}
                </p>
                <h3 className="text-xl text-text-primary font-light mt-1">
                  {project2.name}
                </h3>
              </div>
            </>
          ) : (
            <div className="aspect-[4/3] bg-bg-card" />
          )}
        </div>
      </div>
    </section>
  );
}
