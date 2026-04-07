-- Supabase subscription tracking table
-- Synced from RevenueCat webhook or client-side after purchase verification.

create table if not exists public.subscriptions (
  id            uuid primary key default gen_random_uuid(),
  app_id        text not null,
  user_id       uuid not null references auth.users(id) on delete cascade,
  status        text not null default 'free' check (status in ('free', 'premium', 'trial')),
  plan_id       text,
  started_at    timestamptz not null default now(),
  expires_at    timestamptz,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

-- RLS
alter table public.subscriptions enable row level security;

create policy "Users can read own subscription"
  on public.subscriptions for select
  using (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Service role can manage subscriptions"
  on public.subscriptions for all
  using (auth.role() = 'service_role');
