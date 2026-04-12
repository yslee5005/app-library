import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

// Blacklabelled schema (products, categories, etc.)
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  db: { schema: "blacklabelled" },
});

// Re-export URL for image helpers
export { supabaseUrl };
