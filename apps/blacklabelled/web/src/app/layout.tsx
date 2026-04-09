import type { Metadata } from "next";
import "./globals.css";
import LayoutShell from "@/components/LayoutShell";

export const metadata: Metadata = {
  metadataBase: new URL("https://blacklabelled.co.kr"),
  title: "BLACKLABELLED | Your space is 'black label'",
  description:
    "설계에서 현실로 — 블랙라벨드 인테리어 디자인 스튜디오. 427+ 프로젝트, 성남 기반.",
  openGraph: {
    title: "BLACKLABELLED",
    description: "설계에서 현실로 — 블랙라벨드 인테리어 디자인 스튜디오",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ko" className="dark">
      <head>
        <link
          rel="stylesheet"
          href="https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@2.0/nanumsquare.css"
        />
      </head>
      <body className="bg-bg-primary text-text-primary font-body min-h-screen flex flex-col antialiased">
        <LayoutShell>{children}</LayoutShell>
      </body>
    </html>
  );
}
