import type { Metadata } from "next";
import ProcessContent from "@/components/ProcessContent";

export const metadata: Metadata = {
  title: "PROCESS | BLACKLABELLED",
  description: "블랙라벨드 인테리어 프로세스 — 상담, 도면 설계, 3D 렌더, 시공, 완공까지.",
  openGraph: {
    title: "BLACKLABELLED — Process",
    description: "상담부터 완공까지, 블랙라벨드의 인테리어 프로세스를 확인하세요.",
  },
};

export default function ProcessPage() {
  return <ProcessContent />;
}
