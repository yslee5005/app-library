import type { Metadata } from "next";
import { Inter, Noto_Sans_KR } from "next/font/google";
import "./globals.css";
import Navigation from "@/components/Navigation";
import Footer from "@/components/Footer";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  weight: ["300", "400", "500", "600", "700"],
  display: "swap",
});

const notoSansKR = Noto_Sans_KR({
  variable: "--font-noto-kr",
  subsets: ["latin"],
  weight: ["300", "400", "500", "700"],
  display: "swap",
});

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
    <html
      lang="ko"
      className={`${inter.variable} ${notoSansKR.variable} dark`}
    >
      <body className="bg-bg-primary text-text-primary font-body min-h-screen flex flex-col antialiased">
        <Navigation />
        <main className="flex-1">{children}</main>
        <Footer />
      </body>
    </html>
  );
}
