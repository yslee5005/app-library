-- Supabase gamification tables

-- Streaks
create table if not exists public.streaks (
  id                  uuid primary key default gen_random_uuid(),
  app_id              text not null,
  user_id             uuid not null references auth.users(id) on delete cascade,
  current_streak      int not null default 0,
  best_streak         int not null default 0,
  last_activity_date  date,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  unique(app_id, user_id)
);

alter table public.streaks enable row level security;

create policy "Users can read own streak"
  on public.streaks for select
  using (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can update own streak"
  on public.streaks for update
  using (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can insert own streak"
  on public.streaks for insert
  with check (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

-- Milestones
create table if not exists public.milestones (
  id          uuid primary key default gen_random_uuid(),
  app_id      text not null,
  user_id     uuid not null references auth.users(id) on delete cascade,
  type        text not null,
  achieved_at timestamptz not null default now(),
  unique(app_id, user_id, type)
);

alter table public.milestones enable row level security;

create policy "Users can read own milestones"
  on public.milestones for select
  using (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can insert own milestones"
  on public.milestones for insert
  with check (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));
