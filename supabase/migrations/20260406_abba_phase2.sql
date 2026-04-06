-- ============================================================
-- Abba Phase 2 — Supabase Schema + RLS
-- All tables use app_id scoping for multi-app infrastructure
-- ============================================================

-- =====================
-- 1. Profiles
-- =====================
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  app_id TEXT NOT NULL DEFAULT 'abba',
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  avatar_url TEXT,
  total_prayers INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  subscription TEXT DEFAULT 'free',
  locale TEXT DEFAULT 'en',
  voice_preference TEXT DEFAULT 'warm',
  reminder_time TEXT,
  dark_mode BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "profiles_select_own" ON profiles
  FOR SELECT USING (
    auth.uid() = id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "profiles_insert_own" ON profiles
  FOR INSERT WITH CHECK (
    auth.uid() = id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "profiles_update_own" ON profiles
  FOR UPDATE USING (
    auth.uid() = id
    AND COALESCE(app_id, '') = 'abba'
  );

-- =====================
-- 2. Prayers (기도 기록)
-- =====================
CREATE TABLE IF NOT EXISTS prayers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  transcript TEXT NOT NULL,
  mode TEXT NOT NULL,                -- 'prayer' | 'qt'
  qt_passage_ref TEXT,
  result JSONB,                      -- AI 분석 결과 전체
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE prayers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "prayers_select_own" ON prayers
  FOR SELECT USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "prayers_insert_own" ON prayers
  FOR INSERT WITH CHECK (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "prayers_update_own" ON prayers
  FOR UPDATE USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "prayers_delete_own" ON prayers
  FOR DELETE USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE INDEX idx_prayers_user_date ON prayers(user_id, created_at DESC);
CREATE INDEX idx_prayers_app_id ON prayers(app_id);

-- =====================
-- 3. QT Passages (QT 말씀)
-- =====================
CREATE TABLE IF NOT EXISTS qt_passages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  reference TEXT NOT NULL,
  text_en TEXT NOT NULL,
  text_ko TEXT NOT NULL,
  icon TEXT NOT NULL,
  color_hex TEXT NOT NULL,
  date DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE qt_passages ENABLE ROW LEVEL SECURITY;

-- QT passages are readable by all authenticated users
CREATE POLICY "qt_passages_select_all" ON qt_passages
  FOR SELECT USING (
    auth.role() = 'authenticated'
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE INDEX idx_qt_passages_date ON qt_passages(date DESC);
CREATE INDEX idx_qt_passages_app_id ON qt_passages(app_id);

-- =====================
-- 4. Community Posts
-- =====================
CREATE TABLE IF NOT EXISTS community_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,                  -- null = 익명
  category TEXT NOT NULL,             -- 'testimony' | 'prayer_request'
  content TEXT NOT NULL,
  like_count INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE community_posts ENABLE ROW LEVEL SECURITY;

-- Community posts are readable by all authenticated users
CREATE POLICY "community_posts_select_all" ON community_posts
  FOR SELECT USING (
    auth.role() = 'authenticated'
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "community_posts_insert_own" ON community_posts
  FOR INSERT WITH CHECK (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "community_posts_update_own" ON community_posts
  FOR UPDATE USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "community_posts_delete_own" ON community_posts
  FOR DELETE USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE INDEX idx_community_posts_created ON community_posts(created_at DESC);
CREATE INDEX idx_community_posts_app_id ON community_posts(app_id);

-- =====================
-- 5. Post Comments (1-depth reply)
-- =====================
CREATE TABLE IF NOT EXISTS post_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  content TEXT NOT NULL,
  parent_comment_id UUID REFERENCES post_comments(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE post_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "post_comments_select_all" ON post_comments
  FOR SELECT USING (
    auth.role() = 'authenticated'
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "post_comments_insert_own" ON post_comments
  FOR INSERT WITH CHECK (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "post_comments_delete_own" ON post_comments
  FOR DELETE USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE INDEX idx_post_comments_post ON post_comments(post_id, created_at);
CREATE INDEX idx_post_comments_app_id ON post_comments(app_id);

-- =====================
-- 6. Post Likes
-- =====================
CREATE TABLE IF NOT EXISTS post_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(post_id, user_id)
);

ALTER TABLE post_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "post_likes_select_all" ON post_likes
  FOR SELECT USING (
    auth.role() = 'authenticated'
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "post_likes_insert_own" ON post_likes
  FOR INSERT WITH CHECK (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "post_likes_delete_own" ON post_likes
  FOR DELETE USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE INDEX idx_post_likes_app_id ON post_likes(app_id);

-- =====================
-- 7. Post Saves
-- =====================
CREATE TABLE IF NOT EXISTS post_saves (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(post_id, user_id)
);

ALTER TABLE post_saves ENABLE ROW LEVEL SECURITY;

CREATE POLICY "post_saves_select_own" ON post_saves
  FOR SELECT USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "post_saves_insert_own" ON post_saves
  FOR INSERT WITH CHECK (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "post_saves_delete_own" ON post_saves
  FOR DELETE USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE INDEX idx_post_saves_app_id ON post_saves(app_id);

-- =====================
-- 8. Prayer Streaks
-- =====================
CREATE TABLE IF NOT EXISTS prayer_streaks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  last_prayer_date DATE,
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(app_id, user_id)
);

ALTER TABLE prayer_streaks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "prayer_streaks_select_own" ON prayer_streaks
  FOR SELECT USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "prayer_streaks_insert_own" ON prayer_streaks
  FOR INSERT WITH CHECK (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE POLICY "prayer_streaks_update_own" ON prayer_streaks
  FOR UPDATE USING (
    auth.uid() = user_id
    AND COALESCE(app_id, '') = 'abba'
  );

CREATE INDEX idx_prayer_streaks_user ON prayer_streaks(user_id);
CREATE INDEX idx_prayer_streaks_app_id ON prayer_streaks(app_id);

-- =====================
-- Auto-create profile on signup (trigger)
-- =====================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, app_id, name, email)
  VALUES (
    NEW.id,
    'abba',
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.email, '')
  );

  INSERT INTO public.prayer_streaks (app_id, user_id, current_streak, best_streak)
  VALUES ('abba', NEW.id, 0, 0);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop if exists to be idempotent
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
