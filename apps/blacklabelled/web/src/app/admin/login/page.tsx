"use client";

import { useState } from "react";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { loginWithPassword, loginWithMagicLink } from "@/lib/admin-actions";

export default function AdminLoginPage() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [mode, setMode] = useState<"password" | "magic">("password");
  const [magicSent, setMagicSent] = useState(false);

  const urlParams = typeof window !== "undefined"
    ? new URLSearchParams(window.location.search)
    : null;
  const urlError = urlParams?.get("error");

  const handlePasswordLogin = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    const formData = new FormData(e.currentTarget);
    const result = await loginWithPassword(formData);

    if (result?.error) {
      setError(result.error);
      setLoading(false);
    }
    // If successful, server action redirects to /admin/dashboard
  };

  const handleMagicLink = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    const formData = new FormData(e.currentTarget);
    formData.set("origin", window.location.origin);
    const result = await loginWithMagicLink(formData);

    if (result?.error) {
      setError(result.error);
    } else if (result?.success) {
      setMagicSent(true);
    }
    setLoading(false);
  };

  return (
    <Card className="w-full max-w-md border-zinc-800 bg-zinc-900">
      <CardHeader className="text-center">
        <CardTitle className="text-2xl font-bold tracking-widest text-zinc-100">
          BL Admin
        </CardTitle>
        <CardDescription className="text-zinc-500">
          Sign in to manage your portfolio
        </CardDescription>
      </CardHeader>
      <CardContent>
        {(urlError === "unauthorized" || error) && (
          <div className="mb-4 rounded-lg bg-red-950/50 border border-red-900 p-3 text-sm text-red-400">
            {error || "You do not have admin access. Contact the owner."}
          </div>
        )}

        {magicSent ? (
          <div className="rounded-lg bg-emerald-950/50 border border-emerald-900 p-4 text-center">
            <p className="text-sm text-emerald-400">
              Magic link sent! Check your inbox.
            </p>
            <p className="mt-2 text-xs text-zinc-500">
              Click the link in your email to sign in.
            </p>
          </div>
        ) : mode === "password" ? (
          <form onSubmit={handlePasswordLogin} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email" className="text-zinc-300">Email</Label>
              <Input
                id="email"
                name="email"
                type="email"
                placeholder="you@example.com"
                required
                className="border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-600"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password" className="text-zinc-300">Password</Label>
              <Input
                id="password"
                name="password"
                type="password"
                placeholder="••••••••"
                required
                className="border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-600"
              />
            </div>

            <Button
              type="submit"
              disabled={loading}
              className="w-full bg-zinc-100 text-zinc-900 hover:bg-zinc-200 disabled:opacity-50"
            >
              {loading ? "Signing in..." : "Sign In"}
            </Button>

            <button
              type="button"
              onClick={() => { setMode("magic"); setError(null); }}
              className="w-full text-sm text-zinc-500 hover:text-zinc-300 transition-colors"
            >
              Or sign in with Magic Link
            </button>
          </form>
        ) : (
          <form onSubmit={handleMagicLink} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email-magic" className="text-zinc-300">Email</Label>
              <Input
                id="email-magic"
                name="email"
                type="email"
                placeholder="you@example.com"
                required
                className="border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-600"
              />
            </div>

            <Button
              type="submit"
              disabled={loading}
              className="w-full bg-zinc-100 text-zinc-900 hover:bg-zinc-200 disabled:opacity-50"
            >
              {loading ? "Sending..." : "Send Magic Link"}
            </Button>

            <button
              type="button"
              onClick={() => { setMode("password"); setError(null); }}
              className="w-full text-sm text-zinc-500 hover:text-zinc-300 transition-colors"
            >
              Or sign in with password
            </button>
          </form>
        )}
      </CardContent>
    </Card>
  );
}
