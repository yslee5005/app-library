"use client";

import { usePathname } from "next/navigation";
import Navigation from "./Navigation";
import Footer from "./Footer";

export default function LayoutShell({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const hideShell = pathname.startsWith("/lilsquare") || pathname.startsWith("/admin");

  return (
    <>
      {!hideShell && <Navigation />}
      <main className="flex-1">{children}</main>
      {!hideShell && <Footer />}
    </>
  );
}
