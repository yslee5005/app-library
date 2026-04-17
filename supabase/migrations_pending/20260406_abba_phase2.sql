-- ============================================================
-- Abba Phase 2 — abba 스키마 전용 테이블
-- profiles, notification_settings, user_devices는 public (공통)
-- user_settings, notification_settings는 20260417 마이그레이션으로 이미 생성됨
-- ============================================================

-- =====================
-- 1. Prayers (기도 기록)
-- =====================
CREATE TABLE IF NOT EXISTS abba.prayers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  transcript TEXT NOT NULL,
  mode TEXT NOT NULL,                -- 'prayer' | 'qt'
  qt_passage_ref TEXT,
  result JSONB,                      -- AI 분석 결과 전체
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE abba.prayers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "prayers_select_own" ON abba.prayers
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "prayers_insert_own" ON abba.prayers
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "prayers_update_own" ON abba.prayers
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "prayers_delete_own" ON abba.prayers
  FOR DELETE USING (auth.uid() = user_id);

CREATE INDEX idx_abba_prayers_user_date ON abba.prayers(user_id, created_at DESC);

-- =====================
-- 2. QT Passages (QT 말씀)
-- =====================
CREATE TABLE IF NOT EXISTS abba.qt_passages (
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

ALTER TABLE abba.qt_passages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "qt_passages_select_all" ON abba.qt_passages
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE INDEX idx_abba_qt_passages_date ON abba.qt_passages(date DESC);

-- =====================
-- 3. Community Posts
-- =====================
CREATE TABLE IF NOT EXISTS abba.community_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  category TEXT NOT NULL,
  content TEXT NOT NULL,
  like_count INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE abba.community_posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "community_posts_select_all" ON abba.community_posts
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "community_posts_insert_own" ON abba.community_posts
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "community_posts_update_own" ON abba.community_posts
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "community_posts_delete_own" ON abba.community_posts
  FOR DELETE USING (auth.uid() = user_id);

CREATE INDEX idx_abba_community_posts_created ON abba.community_posts(created_at DESC);

-- =====================
-- 4. Post Comments (1-depth reply)
-- =====================
CREATE TABLE IF NOT EXISTS abba.post_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES abba.community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  content TEXT NOT NULL,
  parent_comment_id UUID REFERENCES abba.post_comments(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE abba.post_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "post_comments_select_all" ON abba.post_comments
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "post_comments_insert_own" ON abba.post_comments
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "post_comments_delete_own" ON abba.post_comments
  FOR DELETE USING (auth.uid() = user_id);

CREATE INDEX idx_abba_post_comments_post ON abba.post_comments(post_id, created_at);

-- =====================
-- 5. Post Likes
-- =====================
CREATE TABLE IF NOT EXISTS abba.post_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES abba.community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(post_id, user_id)
);

ALTER TABLE abba.post_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "post_likes_select_all" ON abba.post_likes
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "post_likes_insert_own" ON abba.post_likes
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "post_likes_delete_own" ON abba.post_likes
  FOR DELETE USING (auth.uid() = user_id);

-- =====================
-- 6. Post Saves
-- =====================
CREATE TABLE IF NOT EXISTS abba.post_saves (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES abba.community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(post_id, user_id)
);

ALTER TABLE abba.post_saves ENABLE ROW LEVEL SECURITY;

CREATE POLICY "post_saves_select_own" ON abba.post_saves
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "post_saves_insert_own" ON abba.post_saves
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "post_saves_delete_own" ON abba.post_saves
  FOR DELETE USING (auth.uid() = user_id);

-- =====================
-- 7. Prayer Streaks
-- =====================
CREATE TABLE IF NOT EXISTS abba.prayer_streaks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  last_prayer_date DATE,
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(app_id, user_id)
);

ALTER TABLE abba.prayer_streaks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "prayer_streaks_select_own" ON abba.prayer_streaks
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "prayer_streaks_insert_own" ON abba.prayer_streaks
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "prayer_streaks_update_own" ON abba.prayer_streaks
  FOR UPDATE USING (auth.uid() = user_id);

CREATE INDEX idx_abba_prayer_streaks_user ON abba.prayer_streaks(user_id);
