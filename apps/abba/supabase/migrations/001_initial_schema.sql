-- Abba App Schema
-- All tables scoped by app_id = 'abba'

-- Profiles
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  app_id TEXT NOT NULL DEFAULT 'abba',
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  avatar_url TEXT,
  locale TEXT DEFAULT 'en',
  voice_preference TEXT DEFAULT 'warm',
  reminder_time TEXT DEFAULT '06:00',
  dark_mode BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY profiles_select ON profiles FOR SELECT USING (
  auth.uid() = id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY profiles_insert ON profiles FOR INSERT WITH CHECK (
  auth.uid() = id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY profiles_update ON profiles FOR UPDATE USING (
  auth.uid() = id AND COALESCE(app_id, '') = 'abba'
);

-- Prayers
CREATE TABLE IF NOT EXISTS prayers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  transcript TEXT NOT NULL,
  mode TEXT NOT NULL,
  qt_passage_ref TEXT,
  result JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE prayers ENABLE ROW LEVEL SECURITY;
CREATE POLICY prayers_select ON prayers FOR SELECT USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY prayers_insert ON prayers FOR INSERT WITH CHECK (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);

-- QT Passages (generated daily by cronjob)
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
CREATE POLICY qt_passages_select ON qt_passages FOR SELECT USING (
  COALESCE(app_id, '') = 'abba'
);

-- Community Posts
CREATE TABLE IF NOT EXISTS community_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  display_name TEXT,
  category TEXT NOT NULL,
  content TEXT NOT NULL,
  like_count INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,
  is_hidden BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE community_posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY posts_select ON community_posts FOR SELECT USING (
  COALESCE(app_id, '') = 'abba' AND NOT COALESCE(is_hidden, false)
);
CREATE POLICY posts_insert ON community_posts FOR INSERT WITH CHECK (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY posts_delete ON community_posts FOR DELETE USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);

-- Comments
CREATE TABLE IF NOT EXISTS post_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  display_name TEXT,
  content TEXT NOT NULL,
  parent_comment_id UUID REFERENCES post_comments(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE post_comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY comments_select ON post_comments FOR SELECT USING (
  COALESCE(app_id, '') = 'abba'
);
CREATE POLICY comments_insert ON post_comments FOR INSERT WITH CHECK (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY comments_delete ON post_comments FOR DELETE USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);

-- Likes
CREATE TABLE IF NOT EXISTS post_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(post_id, user_id)
);

ALTER TABLE post_likes ENABLE ROW LEVEL SECURITY;
CREATE POLICY likes_select ON post_likes FOR SELECT USING (
  COALESCE(app_id, '') = 'abba'
);
CREATE POLICY likes_insert ON post_likes FOR INSERT WITH CHECK (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY likes_delete ON post_likes FOR DELETE USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);

-- Saves
CREATE TABLE IF NOT EXISTS post_saves (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(post_id, user_id)
);

ALTER TABLE post_saves ENABLE ROW LEVEL SECURITY;
CREATE POLICY saves_select ON post_saves FOR SELECT USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY saves_insert ON post_saves FOR INSERT WITH CHECK (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY saves_delete ON post_saves FOR DELETE USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);

-- Prayer Streaks
CREATE TABLE IF NOT EXISTS prayer_streaks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  last_prayer_date DATE,
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(app_id, user_id)
);

ALTER TABLE prayer_streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY streaks_select ON prayer_streaks FOR SELECT USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY streaks_upsert ON prayer_streaks FOR INSERT WITH CHECK (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);
CREATE POLICY streaks_update ON prayer_streaks FOR UPDATE USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = 'abba'
);

-- Reports (for moderation)
CREATE TABLE IF NOT EXISTS reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  reporter_id UUID NOT NULL REFERENCES auth.users(id),
  target_type TEXT NOT NULL, -- 'post' | 'comment'
  target_id UUID NOT NULL,
  reason TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY reports_insert ON reports FOR INSERT WITH CHECK (
  auth.uid() = reporter_id AND COALESCE(app_id, '') = 'abba'
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_prayers_user_date ON prayers(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_prayers_app_id ON prayers(app_id);
CREATE INDEX IF NOT EXISTS idx_qt_passages_date ON qt_passages(date);
CREATE INDEX IF NOT EXISTS idx_posts_app_category ON community_posts(app_id, category);
CREATE INDEX IF NOT EXISTS idx_comments_post ON post_comments(post_id);
CREATE INDEX IF NOT EXISTS idx_streaks_user ON prayer_streaks(app_id, user_id);
