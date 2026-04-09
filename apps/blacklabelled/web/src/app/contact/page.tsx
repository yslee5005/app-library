import type { Metadata } from "next";
import ContactContent from "@/components/ContactContent";

export const metadata: Metadata = {
  title: "CONTACT | BLACKLABELLED",
  description: "블랙라벨드에 인테리어 상담을 문의하세요. 경기도 성남시 중원구 양현로 411.",
  openGraph: {
    title: "BLACKLABELLED — Contact",
    description: "인테리어 상담을 문의하세요.",
  },
};

export default function ContactPage() {
  return <ContactContent />;
}
