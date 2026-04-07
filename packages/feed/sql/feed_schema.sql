-- Supabase social feed tables

-- Posts
create table if not exists public.feed_posts (
  id              uuid primary key default gen_random_uuid(),
  app_id          text not null,
  user_id         uuid not null references auth.users(id) on delete cascade,
  display_name    text,
  category        text not null,
  content         text not null,
  like_count      int not null default 0,
  comment_count   int not null default 0,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

alter table public.feed_posts enable row level security;

create policy "Anyone can read posts"
  on public.feed_posts for select
  using (app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can create posts"
  on public.feed_posts for insert
  with check (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can delete own posts"
  on public.feed_posts for delete
  using (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

-- Comments
create table if not exists public.feed_comments (
  id          uuid primary key default gen_random_uuid(),
  app_id      text not null,
  post_id     uuid not null references public.feed_posts(id) on delete cascade,
  user_id     uuid not null references auth.users(id) on delete cascade,
  display_name text,
  content     text not null,
  parent_id   uuid references public.feed_comments(id) on delete cascade,
  created_at  timestamptz not null default now()
);

alter table public.feed_comments enable row level security;

create policy "Anyone can read comments"
  on public.feed_comments for select
  using (app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can create comments"
  on public.feed_comments for insert
  with check (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can delete own comments"
  on public.feed_comments for delete
  using (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

-- Likes
create table if not exists public.feed_likes (
  id        uuid primary key default gen_random_uuid(),
  app_id    text not null,
  post_id   uuid not null references public.feed_posts(id) on delete cascade,
  user_id   uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique(app_id, post_id, user_id)
);

alter table public.feed_likes enable row level security;

create policy "Users can read own likes"
  on public.feed_likes for select
  using (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can toggle likes"
  on public.feed_likes for insert
  with check (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can remove own likes"
  on public.feed_likes for delete
  using (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

-- Saves (bookmarks)
create table if not exists public.feed_saves (
  id        uuid primary key default gen_random_uuid(),
  app_id    text not null,
  post_id   uuid not null references public.feed_posts(id) on delete cascade,
  user_id   uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique(app_id, post_id, user_id)
);

alter table public.feed_saves enable row level security;

create policy "Users can read own saves"
  on public.feed_saves for select
  using (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can toggle saves"
  on public.feed_saves for insert
  with check (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

create policy "Users can remove own saves"
  on public.feed_saves for delete
  using (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));

-- Reports
create table if not exists public.feed_reports (
  id        uuid primary key default gen_random_uuid(),
  app_id    text not null,
  post_id   uuid not null references public.feed_posts(id) on delete cascade,
  user_id   uuid not null references auth.users(id) on delete cascade,
  reason    text not null,
  created_at timestamptz not null default now()
);

alter table public.feed_reports enable row level security;

create policy "Users can create reports"
  on public.feed_reports for insert
  with check (auth.uid() = user_id and app_id = coalesce(current_setting('app.app_id', true), ''));
