"use client";

import { useState, useEffect } from "react";
import { supabase } from "@/lib/supabase";
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

export default function AdminLoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [checking, setChecking] = useState(true);
  const [mode, setMode] = useState<"password" | "magic">("password");
  const [magicSent, setMagicSent] = useState(false);

  // Handle implicit flow: hash fragment contains access_token
  useEffect(() => {
    const hash = window.location.hash;
    if (hash && hash.includes("access_token")) {
      const params = new URLSearchParams(hash.substring(1));
      const accessToken = params.get("access_token");
      const refreshToken = params.get("refresh_token");

      if (accessToken && refreshToken) {
        supabase.auth
          .setSession({ access_token: accessToken, refresh_token: refreshToken })
          .then(async ({ error: sessionError }) => {
            if (sessionError) {
              setError("Session error: " + sessionError.message);
              setChecking(false);
              return;
            }
            const ok = await checkAdminRole();
            if (ok) {
              window.location.href = "/admin/dashboard";
            } else {
              setChecking(false);
            }
          });
        return;
      }
    }
    setChecking(false);
  }, []);

  async function checkAdminRole() {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      setError("User not found");
      return false;
    }
    // user_tenants is in public schema — direct REST API call
    const session = (await supabase.auth.getSession()).data.session;
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_SUPABASE_URL}/rest/v1/user_tenants?user_id=eq.${user.id}&role=in.(%22owner%22,%22admin%22)&limit=1`,
      {
        headers: {
          apikey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
          Authorization: `Bearer ${session?.access_token}`,
        },
      }
    );
    const tenantData = await res.json();

    if (!Array.isArray(tenantData) || tenantData.length === 0) {
      await supabase.auth.signOut();
      setError("You do not have admin access.");
      return false;
    }
    return true;
  }

  // Email + Password login
  const handlePasswordLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      const { error: authError } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (authError) {
        setError(authError.message);
        return;
      }

      const ok = await checkAdminRole();
      if (ok) {
        window.location.href = "/admin/dashboard";
      }
    } catch {
      setError("An unexpected error occurred.");
    } finally {
      setLoading(false);
    }
  };

  // Magic Link login
  const handleMagicLink = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      const { error: authError } = await supabase.auth.signInWithOtp({
        email,
        options: {
          emailRedirectTo: `${window.location.origin}/admin/auth/callback`,
        },
      });

      if (authError) {
        setError(authError.message);
      } else {
        setMagicSent(true);
      }
    } catch {
      setError("An unexpected error occurred.");
    } finally {
      setLoading(false);
    }
  };

  const urlParams = typeof window !== "undefined"
    ? new URLSearchParams(window.location.search)
    : null;
  const urlError = urlParams?.get("error");

  if (checking) {
    return (
      <Card className="w-full max-w-md border-zinc-800 bg-zinc-900">
        <CardContent className="p-8 text-center text-zinc-400">
          Authenticating...
        </CardContent>
      </Card>
    );
  }

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
              Magic link sent to <strong>{email}</strong>
            </p>
            <p className="mt-2 text-xs text-zinc-500">
              Check your inbox and click the link to sign in.
            </p>
          </div>
        ) : mode === "password" ? (
          <form onSubmit={handlePasswordLogin} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email" className="text-zinc-300">Email</Label>
              <Input
                id="email"
                type="email"
                placeholder="you@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-600"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password" className="text-zinc-300">Password</Label>
              <Input
                id="password"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                className="border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-600"
              />
            </div>

            <Button
              type="submit"
              disabled={loading || !email || !password}
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
                type="email"
                placeholder="you@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="border-zinc-700 bg-zinc-800 text-zinc-100 placeholder:text-zinc-600"
              />
            </div>

            <Button
              type="submit"
              disabled={loading || !email}
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
