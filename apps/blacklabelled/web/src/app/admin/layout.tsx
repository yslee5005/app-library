"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { createClient } from "@supabase/supabase-js";
import { useEffect, useState } from "react";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

const navItems = [
  { href: "/admin/dashboard", label: "Dashboard", icon: "\u{1F4CA}", match: "/admin/dashboard" },
  { href: "/admin/products", label: "Products", icon: "\u{1F4E6}", match: "/admin/products" },
  { href: "/admin/categories", label: "Categories", icon: "\u{1F3F7}\uFE0F", match: "/admin/categories" },
  { href: "/admin/pages/home", label: "Pages", icon: "\u{1F4C4}", match: "/admin/pages" },
  { href: "/admin/magazines", label: "Magazines", icon: "\u{1F4D6}", match: "/admin/magazines" },
];

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();
  const [userEmail, setUserEmail] = useState<string | null>(null);

  useEffect(() => {
    const supabase = createClient(supabaseUrl, supabaseAnonKey);
    supabase.auth.getUser().then(({ data }) => {
      setUserEmail(data.user?.email ?? null);
    });
  }, []);

  const handleLogout = async () => {
    const supabase = createClient(supabaseUrl, supabaseAnonKey);
    await supabase.auth.signOut();
    router.push("/admin/login");
  };

  return (
    <div className="flex min-h-screen bg-zinc-950">
      {/* Sidebar */}
      <aside className="fixed left-0 top-0 z-40 flex h-screen w-64 flex-col bg-zinc-900 border-r border-zinc-800">
        {/* Logo */}
        <div className="flex h-16 items-center px-6 border-b border-zinc-800">
          <span className="text-lg font-bold tracking-widest text-zinc-100">
            BL ADMIN
          </span>
        </div>

        {/* Navigation */}
        <nav className="flex-1 overflow-y-auto px-3 py-4">
          <ul className="space-y-1">
            {navItems.map((item) => {
              const isActive = pathname.startsWith(item.match);
              return (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    className={`flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors ${
                      isActive
                        ? "bg-zinc-800 text-zinc-100"
                        : "text-zinc-400 hover:bg-zinc-800/50 hover:text-zinc-200"
                    }`}
                  >
                    <span className="text-base">{item.icon}</span>
                    {item.label}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>

        {/* User + Logout */}
        <div className="border-t border-zinc-800 p-4">
          {userEmail && (
            <p className="mb-3 truncate text-xs text-zinc-500">{userEmail}</p>
          )}
          <button
            onClick={handleLogout}
            className="flex w-full items-center gap-2 rounded-lg px-3 py-2 text-sm text-zinc-400 transition-colors hover:bg-zinc-800 hover:text-zinc-200"
          >
            <span className="text-base">{"\u{1F6AA}"}</span>
            Logout
          </button>
        </div>
      </aside>

      {/* Main content */}
      <main className="ml-64 flex-1 p-8">
        {children}
      </main>
    </div>
  );
}
