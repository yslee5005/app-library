"use client";

import { usePathname } from "next/navigation";
import Navigation from "./Navigation";
import Footer from "./Footer";

export default function LayoutShell({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const isLilsquare = pathname.startsWith("/lilsquare");

  return (
    <>
      {!isLilsquare && <Navigation />}
      <main className="flex-1">{children}</main>
      {!isLilsquare && <Footer />}
    </>
  );
}
