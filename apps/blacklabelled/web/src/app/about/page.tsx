import type { Metadata } from "next";
import AboutContent from "@/components/AboutContent";

export const metadata: Metadata = {
  title: "ABOUT | BLACKLABELLED",
  description: "블랙라벨드 디자인 스튜디오 — 427+ 프로젝트, 10+ 년 경험, 성남 기반 인테리어 전문.",
  openGraph: {
    title: "BLACKLABELLED — About",
    description: "블랙라벨드 디자인 스튜디오 — 427+ 프로젝트, 10+ 년 경험.",
  },
};

export default function AboutPage() {
  return <AboutContent />;
}
